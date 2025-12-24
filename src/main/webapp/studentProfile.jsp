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
  // require student to be logged in
  String sessionStudentEmail = (String) session.getAttribute("studentEmail");
  if (sessionStudentEmail == null) {
    response.sendRedirect(request.getContextPath() + "/studentLogin.jsp");
    return;
  }

  String ctx = request.getContextPath();
  String error = "";
  String message = "";

  // Load student record
  Integer studentId = null;
  String currentName = "";
  String currentEmail = sessionStudentEmail;
  String currentDept = "";
  String storedPassword = null;

  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement("SELECT id, name, email, department, password FROM students WHERE email = ? LIMIT 1")) {
    ps.setString(1, sessionStudentEmail);
    try (ResultSet rs = ps.executeQuery()) {
      if (rs.next()) {
        studentId = rs.getInt("id");
        currentName = rs.getString("name");
        currentEmail = rs.getString("email");
        currentDept = rs.getString("department");
        storedPassword = rs.getString("password");
      } else {
        error = "Student account not found.";
      }
    }
  } catch (Exception ex) {
    ex.printStackTrace();
    error = "Server error while loading profile: " + esc(ex.getMessage());
  }

  // Handle POST (update profile / change password)
  if ("POST".equalsIgnoreCase(request.getMethod()) && error.isEmpty()) {

    String formName = request.getParameter("name");
    String formEmail = request.getParameter("email");
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

        // Check new email uniqueness if changed
        if (!formEmail.equalsIgnoreCase(currentEmail)) {
          try (PreparedStatement chk = conn.prepareStatement(
                  "SELECT COUNT(*) FROM students WHERE email = ?")) {
            chk.setString(1, formEmail);
            try (ResultSet crs = chk.executeQuery()) {
              if (crs.next() && crs.getInt(1) > 0) {
                throw new Exception("The email " + esc(formEmail) + " is already registered.");
              }
            }
          }
        }

        // Update profile (name, email, dept)
        try (PreparedStatement upd = conn.prepareStatement(
                "UPDATE students SET name = ?, email = ?, department = ? WHERE id = ?")) {
          upd.setString(1, formName);
          upd.setString(2, formEmail);
          upd.setString(3, formDept);
          upd.setInt(4, studentId);
          upd.executeUpdate();
        }

        // Handle password change ONLY if new password entered
        if (newPwd != null && newPwd.trim().length() > 0) {

          if (curPwd == null || curPwd.trim().isEmpty())
            throw new Exception("Enter your current password.");

          if (!storedPassword.equals(curPwd))
            throw new Exception("Current password is incorrect.");

          if (!newPwd.equals(confirm))
            throw new Exception("New password and confirmation do not match.");

          // Store password directly (NO SHA-256)
          try (PreparedStatement psPwd = conn.prepareStatement(
                  "UPDATE students SET password = ? WHERE id = ?")) {
            psPwd.setString(1, newPwd);
            psPwd.setInt(2, studentId);
            psPwd.executeUpdate();
          }
        }

        conn.commit();

        message = "Profile updated successfully!";
        storedPassword = newPwd.trim().length() > 0 ? newPwd : storedPassword;
        currentName = formName;
        currentEmail = formEmail;
        currentDept = formDept;
        session.setAttribute("studentEmail", formEmail);

      } catch (Exception ex) {
        if (conn != null) conn.rollback();
        error = "Error updating profile: " + esc(ex.getMessage());
      } finally {
        if (conn != null) conn.setAutoCommit(true);
      }
    }
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>My Student Profile</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style>
    body { padding: 28px; background: #f4f7fb; }
    .card { max-width: 860px; margin: 0 auto; }
    .small-muted { color: #6c757d; }
  </style>
</head>
<body>
  <div class="card p-4 shadow-sm">

    <div class="d-flex justify-content-between mb-3">
      <h2>My Profile</h2>
      <div>
        Signed in: <strong><%= esc(currentEmail) %></strong>
        &nbsp;<a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/studentPortal.jsp">Back</a>
      </div>
    </div>

    <% if (!error.isEmpty()) { %>
      <div class="alert alert-danger"><%= esc(error) %></div>
    <% } %>
    <% if (!message.isEmpty()) { %>
      <div class="alert alert-success"><%= esc(message) %></div>
    <% } %>

    <form method="post">
      <div class="mb-3">
        <label>Email</label>
        <input name="email" type="email" class="form-control" value="<%= esc(currentEmail) %>" required>
      </div>

      <div class="mb-3">
        <label>Name</label>
        <input name="name" class="form-control" required value="<%= esc(currentName) %>">
      </div>

      <div class="mb-3">
        <label>Department</label>
        <input name="department" class="form-control" value="<%= esc(currentDept) %>">
      </div>

      <hr>
      <h5>Change Password</h5>
      <p class="small-muted">Leave empty if you do not want to change password.</p>

      <div class="mb-3">
        <label>Current Password</label>
        <input name="currentPassword" type="password" class="form-control">
      </div>

      <div class="mb-3">
        <label>New Password</label>
        <input name="newPassword" type="password" class="form-control">
      </div>

      <div class="mb-3">
        <label>Confirm New Password</label>
        <input name="confirmPassword" type="password" class="form-control">
      </div>

      <button class="btn btn-primary">Save Changes</button>
    </form>

  </div>
</body>
</html>
