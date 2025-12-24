<%@ page import="java.sql.*, java.security.MessageDigest, java.security.NoSuchAlgorithmException, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  // -------------------------
  // Helper utilities (declarations)
  // -------------------------
  public String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#x27;");
  }

  // compute SHA-256 hex for a string
  public String sha256Hex(String input) {
    if (input == null) return null;
    try {
      MessageDigest md = MessageDigest.getInstance("SHA-256");
      byte[] h = md.digest(input.getBytes("UTF-8"));
      StringBuilder sb = new StringBuilder();
      for (byte b : h) sb.append(String.format("%02x", b & 0xff));
      return sb.toString();
    } catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
      return null;
    }
  }

  // detect whether a string looks like a sha256 hex (64 hex chars)
  public boolean looksLikeSha256(String s) {
    return s != null && s.matches("(?i)^[0-9a-f]{64}$");
  }

  // Check whether a ResultSetMetaData contains a column name (case-insensitive)
  public boolean hasColumn(ResultSetMetaData md, String col) throws SQLException {
    if (md == null || col == null) return false;
    int count = md.getColumnCount();
    for (int i = 1; i <= count; i++) {
      if (col.equalsIgnoreCase(md.getColumnLabel(i))) return true;
    }
    return false;
  }
%>

<%
  // -------------------------
  // Ensure finance user is logged in
  // -------------------------
  String sessionEmail = (String) session.getAttribute("financeEmail");
  if (sessionEmail == null) {
    response.sendRedirect(request.getContextPath() + "/financeLogin.jsp");
    return;
  }

  String ctx = request.getContextPath();
  String message = "";
  String error = "";

  // local vars to hold profile values (defaults)
  Integer financeId = null;
  String currentEmail = sessionEmail;
  String currentName = "";
  String currentDept = "";      // may remain empty if column not present
  String storedPassword = null; // from DB

  // -------------------------
  // Load record from finance_officer table (flexible: only read columns that exist)
  // -------------------------
  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement("SELECT * FROM finance_officer WHERE email = ? LIMIT 1")) {

    ps.setString(1, sessionEmail);
    try (ResultSet rs = ps.executeQuery()) {
      if (rs.next()) {
        ResultSetMetaData md = rs.getMetaData();
        // common columns we expect; check for existence before reading
        if (hasColumn(md, "id")) financeId = rs.getInt("id");
        if (hasColumn(md, "name")) currentName = rs.getString("name");
        if (hasColumn(md, "email")) currentEmail = rs.getString("email");
        if (hasColumn(md, "department")) currentDept = rs.getString("department");
        if (hasColumn(md, "password")) storedPassword = rs.getString("password");
      } else {
        error = "Finance account not found for " + esc(sessionEmail) + ".";
      }
    }
  } catch (Exception ex) {
    ex.printStackTrace();
    error = "Server error while loading profile: " + esc(ex.getMessage());
  }

  // -------------------------
  // Handle POST (profile update / change password)
  // -------------------------
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

        // If email changed, ensure uniqueness (if column exists in table)
        try (PreparedStatement chk = conn.prepareStatement("SELECT COUNT(*) FROM finance_officer WHERE email = ?")) {
          chk.setString(1, formEmail);
          try (ResultSet crs = chk.executeQuery()) {
            if (crs.next() && crs.getInt(1) > 0 && !formEmail.equalsIgnoreCase(sessionEmail)) {
              throw new Exception("The email " + esc(formEmail) + " is already in use.");
            }
          }
        }

        // Build dynamic update statement depending on which columns exist
        // We'll check the table metadata first
        boolean hasName=false, hasEmail=false, hasDept=false, hasPassword=false;
        try (PreparedStatement pmd = conn.prepareStatement("SELECT * FROM finance_officer LIMIT 1")) {
          try (ResultSet rmd = pmd.executeQuery()) {
            ResultSetMetaData md = rmd.getMetaData();
            hasName = hasColumn(md, "name");
            hasEmail = hasColumn(md, "email");
            hasDept = hasColumn(md, "department");
            hasPassword = hasColumn(md, "password");
          }
        }

        // Prepare update for profile fields (name, email, department) only if those columns exist
        StringBuilder upd = new StringBuilder();
        java.util.List<Object> params = new java.util.ArrayList<>();

        if (hasName) {
          if (upd.length() > 0) upd.append(", ");
          upd.append("name = ?");
          params.add(formName);
        }
        if (hasEmail) {
          if (upd.length() > 0) upd.append(", ");
          upd.append("email = ?");
          params.add(formEmail);
        }
        if (hasDept) {
          if (upd.length() > 0) upd.append(", ");
          upd.append("department = ?");
          params.add(formDept == null ? "" : formDept);
        }

        if (upd.length() > 0) {
          String sql = "UPDATE finance_officer SET " + upd.toString() + " WHERE ";
          // use id if available, else email fallback
          if (financeId != null) {
            sql += "id = ?";
            params.add(financeId);
          } else {
            sql += "email = ?";
            params.add(sessionEmail);
          }
          try (PreparedStatement upstmt = conn.prepareStatement(sql)) {
            for (int i=0;i<params.size();i++) upstmt.setObject(i+1, params.get(i));
            int rows = upstmt.executeUpdate();
            if (rows == 0) throw new Exception("Profile update failed (record not found).");
          }
        }

        // Handle password change (only if a new password was provided)
        if (newPwd != null && newPwd.trim().length() > 0) {
          // require current password (to verify)
          if (curPwd == null || curPwd.trim().isEmpty()) {
            throw new Exception("To change password you must provide the current password.");
          }
          if (!newPwd.equals(confirm)) {
            throw new Exception("New password and confirmation do not match.");
          }

          // verify current password - supports both hashed and plain text stored passwords
          boolean verified = false;
          if (storedPassword == null) {
            verified = false;
          } else if (looksLikeSha256(storedPassword)) {
            // DB stores sha256 hex
            String curHash = sha256Hex(curPwd);
            verified = (curHash != null && curHash.equalsIgnoreCase(storedPassword));
          } else {
            // DB stores plain text
            verified = storedPassword.equals(curPwd);
          }

          if (!verified) throw new Exception("Current password is incorrect.");

          // Store new password. Here we will preserve existing storage style:
          // - if stored password was sha256, store new one as sha256
          // - otherwise store plaintext (this mirrors what your DB already uses).
          String toStore = looksLikeSha256(storedPassword) ? sha256Hex(newPwd) : newPwd;
          if (hasPassword) {
            try (PreparedStatement psPwd = conn.prepareStatement(
                (financeId != null) ? "UPDATE finance_officer SET password = ? WHERE id = ?" : "UPDATE finance_officer SET password = ? WHERE email = ?")) {
              psPwd.setString(1, toStore);
              if (financeId != null) psPwd.setInt(2, financeId); else psPwd.setString(2, sessionEmail);
              psPwd.executeUpdate();
            }
          } else {
            // If password column does not exist, throw an informative exception
            throw new Exception("Password column not found in table.");
          }
        }

        conn.commit();

        // success: update local copies and session as needed
        message = "Profile updated successfully.";
        currentName = formName;
        currentEmail = formEmail;
        currentDept = formDept == null ? "" : formDept;
        session.setAttribute("financeEmail", formEmail);

        // reload storedPassword for future checks
        try (PreparedStatement reload = conn.prepareStatement("SELECT password FROM finance_officer WHERE " + (financeId != null ? "id = ?" : "email = ?"))) {
          if (financeId != null) reload.setInt(1, financeId); else reload.setString(1, formEmail);
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
  } // end POST handling
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>My Finance Profile</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style>
    body { padding: 28px; background:#f8fafc; }
    .card { max-width: 860px; margin: 0 auto; }
    .small-muted { color: #6c757d; }
  </style>
</head>
<body>
  <div class="card p-4 shadow-sm">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2>My Finance Profile</h2>
      <div>
        Signed in: <strong><%= esc(currentEmail) %></strong>
        &nbsp; <a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/financePortal.jsp">Back</a>
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

      <div class="mb-3">
        <label class="form-label">Department</label>
        <input name="department" class="form-control" value="<%= esc(currentDept) %>"/>
        <div class="form-text">If your table doesn't have a `department` column this field will be ignored on save.</div>
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
