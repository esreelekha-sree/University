<%@ page import="java.sql.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  // helper to escape HTML
  public String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#x27;");
  }
%>

<%
  // require admin session
  String sessionAdminEmail = (String) session.getAttribute("adminEmail");
  if (sessionAdminEmail == null) {
    response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
    return;
  }

  String ctx = request.getContextPath();
  String error = "";
  String message = "";

  // Load admin record
  Integer adminId = null;
  String currentName = "";
  String currentEmail = sessionAdminEmail;
  String storedPassword = null;

  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement("SELECT admin_id, name, email, password FROM admins WHERE email = ? LIMIT 1")) {
    ps.setString(1, sessionAdminEmail);
    try (ResultSet rs = ps.executeQuery()) {
      if (rs.next()) {
        adminId = rs.getInt("admin_id");
        currentName = rs.getString("name");
        currentEmail = rs.getString("email");
        storedPassword = rs.getString("password");
      } else {
        error = "Admin account not found for " + esc(sessionAdminEmail) + ".";
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

        // If email changed, ensure uniqueness
        if (!formEmail.equalsIgnoreCase(currentEmail)) {
          try (PreparedStatement chk = conn.prepareStatement("SELECT COUNT(*) FROM admins WHERE email = ?")) {
            chk.setString(1, formEmail);
            try (ResultSet crs = chk.executeQuery()) {
              if (crs.next() && crs.getInt(1) > 0) {
                throw new Exception("The email " + esc(formEmail) + " is already in use.");
              }
            }
          }
        }

        // Update admins table (name, email)
        try (PreparedStatement upd = conn.prepareStatement(
            "UPDATE admins SET name = ?, email = ? WHERE admin_id = ?")) {
          upd.setString(1, formName);
          upd.setString(2, formEmail);
          upd.setInt(3, adminId);
          int rows = upd.executeUpdate();
          if (rows == 0) throw new Exception("Profile update failed (record not found).");
        }

        // Handle password change only if new password provided
        if (newPwd != null && newPwd.trim().length() > 0) {
          // require current password
          if (curPwd == null || curPwd.trim().isEmpty()) {
            throw new Exception("To change password you must provide the current password.");
          }
          if (!newPwd.equals(confirm)) {
            throw new Exception("New password and confirmation do not match.");
          }

          // PLAINTEXT verification (no hashing)
          boolean verified = (storedPassword != null && storedPassword.equals(curPwd));
          if (!verified) throw new Exception("Current password is incorrect.");

          // Store new password as plaintext (per your request)
          try (PreparedStatement psPwd = conn.prepareStatement("UPDATE admins SET password = ? WHERE admin_id = ?")) {
            psPwd.setString(1, newPwd);
            psPwd.setInt(2, adminId);
            psPwd.executeUpdate();
          }
        }

        conn.commit();

        // success: update local variables and session
        message = "Profile updated successfully.";
        currentName = formName;
        currentEmail = formEmail;
        session.setAttribute("adminEmail", formEmail);

        // reload storedPassword for future checks
        try (PreparedStatement reload = conn.prepareStatement("SELECT password FROM admins WHERE admin_id = ?")) {
          reload.setInt(1, adminId);
          try (ResultSet r2 = reload.executeQuery()) {
            if (r2.next()) storedPassword = r2.getString(1);
          }
        }
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
  <title>Admin Profile</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style>
    body { padding: 28px; background: #f8fafc; }
    .card { max-width: 900px; margin: 0 auto; }
    .small-muted { color: #6c757d; }
  </style>
</head>
<body>
  <div class="card p-4 shadow-sm">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2>Admin Profile</h2>
      <div>
        Signed in: <strong><%= esc(currentEmail) %></strong>
        &nbsp; <a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/adminPortal.jsp">Back</a>
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
        <label class="form-label">Email</label>
        <input name="email" type="email" class="form-control" value="<%= esc(currentEmail) %>" required/>
      </div>

      <div class="mb-3">
        <label class="form-label">Name</label>
        <input name="name" class="form-control" required value="<%= esc(currentName) %>"/>
      </div>

      <hr/>
      <h5 class="mb-2">Change Password</h5>
      <p class="small-muted">Leave fields empty if you don't want to change your password.</p>

      <div class="mb-3">
        <label class="form-label">Current Password</label>
        <input name="currentPassword" type="password" class="form-control" placeholder="Enter current password"/>
      </div>

      <div class="mb-3">
        <label class="form-label">New Password</label>
        <input name="newPassword" type="password" class="form-control" placeholder="New password"/>
      </div>

      <div class="mb-3">
        <label class="form-label">Confirm New Password</label>
        <input name="confirmPassword" type="password" class="form-control" placeholder="Confirm new password"/>
      </div>

      <button class="btn btn-primary">Save Changes</button>
    </form>
  </div>
</body>
</html>
