<%@ page import="java.sql.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  // HTML escape helper
  public String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#x27;");
  }
%>

<%
  // ensure faculty is logged in
  String sessionFacultyEmail = (String) session.getAttribute("facultyEmail");
  if (sessionFacultyEmail == null) {
    response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
    return;
  }

  String ctx = request.getContextPath();
  String error = "";
  String message = "";

  // Load faculty record
  Integer facultyId = null;
  String currentName = "";
  String currentEmail = sessionFacultyEmail;
  String currentDept = "";
  String storedPassword = null;

  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement(
           "SELECT id, name, email, department, password FROM faculty WHERE email = ? LIMIT 1")) {
    ps.setString(1, sessionFacultyEmail);
    try (ResultSet rs = ps.executeQuery()) {
      if (rs.next()) {
        facultyId = rs.getInt("id");
        currentName = rs.getString("name");
        currentEmail = rs.getString("email");
        currentDept = rs.getString("department");
        storedPassword = rs.getString("password");
      } else {
        error = "Faculty account not found for " + esc(sessionFacultyEmail) + ".";
      }
    }
  } catch (Exception ex) {
    ex.printStackTrace();
    error = "Server error while loading profile: " + esc(ex.getMessage());
  }

  // Handle POST (update profile / change password)
  if ("POST".equalsIgnoreCase(request.getMethod()) && error.isEmpty()) {
    String formName = request.getParameter("name");
    String formEmail = request.getParameter("email");      // readonly in UI, but still posted
    String formDept  = request.getParameter("department");

    String curPwd   = request.getParameter("currentPassword");
    String newPwd   = request.getParameter("newPassword");
    String confirm  = request.getParameter("confirmPassword");

    // Basic validation
    if (formName == null || formName.trim().isEmpty()) {
      error = "Name cannot be empty.";
    } else if (formEmail == null || formEmail.trim().isEmpty()) {
      error = "Email cannot be empty.";
    } else {
      Connection conn = null;
      try {
        conn = DatabaseConnection.getConnection();
        conn.setAutoCommit(false);

        // If email changed, ensure uniqueness (even though field is readonly – safe check)
        if (!formEmail.equalsIgnoreCase(currentEmail)) {
          try (PreparedStatement chk = conn.prepareStatement(
                  "SELECT COUNT(*) FROM faculty WHERE email = ?")) {
            chk.setString(1, formEmail);
            try (ResultSet crs = chk.executeQuery()) {
              if (crs.next() && crs.getInt(1) > 0) {
                throw new Exception("The email " + esc(formEmail) + " is already in use.");
              }
            }
          }
        }

        // Update faculty table (name, email, department)
        try (PreparedStatement upd = conn.prepareStatement(
             "UPDATE faculty SET name = ?, email = ?, department = ? WHERE id = ?")) {
          upd.setString(1, formName);
          upd.setString(2, formEmail);
          upd.setString(3, formDept);
          upd.setInt(4, facultyId);
          int rows = upd.executeUpdate();
          if (rows == 0) throw new Exception("Profile update failed (record not found).");
        }

        // Keep schedules table consistent when email or name changed
        try (PreparedStatement updSched = conn.prepareStatement(
             "UPDATE schedules SET facultyName = ?, faculty_email = ? WHERE faculty_email = ?")) {
          updSched.setString(1, formName);
          updSched.setString(2, formEmail);
          updSched.setString(3, currentEmail);
          updSched.executeUpdate(); // ignore affected count
        }

        // Handle password change only if new password provided
        if (newPwd != null && newPwd.trim().length() > 0) {

          if (curPwd == null || curPwd.trim().isEmpty()) {
            throw new Exception("To change password you must provide the current password.");
          }

          // Compare plain text password
          if (storedPassword == null || !storedPassword.equals(curPwd)) {
            throw new Exception("Current password is incorrect.");
          }

          if (!newPwd.equals(confirm)) {
            throw new Exception("New password and confirmation do not match.");
          }

          // Store new password directly (NO hashing)
          try (PreparedStatement psPwd = conn.prepareStatement(
               "UPDATE faculty SET password = ? WHERE id = ?")) {
            psPwd.setString(1, newPwd);
            psPwd.setInt(2, facultyId);
            psPwd.executeUpdate();
          }

          storedPassword = newPwd; // update in-memory copy
        }

        conn.commit();

        // success: update local variables and session
        message = "Profile updated successfully.";
        currentName = formName;
        currentEmail = formEmail;
        currentDept = formDept;
        session.setAttribute("facultyEmail", formEmail);

      } catch (Exception ex) {
        if (conn != null) {
          try { conn.rollback(); } catch (Exception ignore) {}
        }
        ex.printStackTrace();
        error = "Error updating profile: " + esc(ex.getMessage());
      } finally {
        if (conn != null) {
          try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignore) {}
        }
      }
    }
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>My Faculty Profile</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style>
    body { padding: 28px; background:#f4f7fb; }
    .card { max-width: 860px; margin: 0 auto; }
    .small-muted { color: #6c757d; }
  </style>
</head>
<body>
  <div class="card p-4 shadow-sm">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2>My Profile</h2>
      <div>
        Signed in: <strong><%= esc(currentEmail) %></strong>
        &nbsp; <a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/facultyPortal.jsp">Back</a>
      </div>
    </div>

    <% if (!error.isEmpty()) { %>
      <div class="alert alert-danger"><%= esc(error) %></div>
    <% } %>
    <% if (!message.isEmpty()) { %>
      <div class="alert alert-success"><%= esc(message) %></div>
    <% } %>

    <form method="post" class="mt-3">
      <div class="mb-3">
        <label class="form-label">Email (readonly)</label>
        <input name="email" type="email" class="form-control"
               value="<%= esc(currentEmail) %>" readonly/>
      </div>

      <div class="mb-3">
        <label class="form-label">Name</label>
        <input name="name" class="form-control" required
               value="<%= esc(currentName) %>"/>
      </div>

      <div class="mb-3">
        <label class="form-label">Department</label>
        <input name="department" class="form-control"
               value="<%= esc(currentDept) %>"/>
      </div>

      <hr/>
      <h5 class="mb-2">Change Password</h5>
      <p class="small-muted">Leave fields empty if you don't want to change your password.</p>

      <div class="mb-3">
        <label class="form-label">Current Password</label>
        <input name="currentPassword" type="password" class="form-control"
               placeholder="Enter current password"/>
      </div>

      <div class="mb-3">
        <label class="form-label">New Password</label>
        <input name="newPassword" type="password" class="form-control"
               placeholder="New password (min 6 chars)"/>
      </div>

      <div class="mb-3">
        <label class="form-label">Confirm New Password</label>
        <input name="confirmPassword" type="password" class="form-control"
               placeholder="Confirm new password"/>
      </div>

      <button class="btn btn-primary">Save Changes</button>
    </form>
  </div>
</body>
</html>
