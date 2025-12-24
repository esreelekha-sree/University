<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // require admin login
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
        return;
    }

    // load faculty list (columns in your DB: id, name, email, department)
    List<Map<String,Object>> faculty = new ArrayList<>();
    String loadError = null;
    try (Connection conn = com.university.utils.DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT id, name, email, department FROM faculty ORDER BY id ASC");
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Map<String,Object> row = new HashMap<>();
            row.put("id", rs.getInt("id"));
            row.put("name", rs.getString("name"));
            row.put("email", rs.getString("email"));
            row.put("department", rs.getString("department"));
            faculty.add(row);
        }
    } catch (Exception e) {
        e.printStackTrace();
        loadError = e.getMessage();
    }
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Registered Faculty - Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style> body{padding:20px;background:#f7f7f7;} table td,table th{vertical-align:middle;} </style>
</head>
<body>
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2>Registered Faculty</h2>
      <div>
        <span class="me-3">Signed in as <strong><%= adminEmail %></strong></span>
        <a class="btn btn-sm btn-outline-secondary" href="<%= request.getContextPath() %>/adminPortal.jsp">Back to Portal</a>
      </div>
    </div>

    <% if (loadError != null) { %>
      <div class="alert alert-warning">Error loading faculty: <%= loadError %></div>
    <% } %>

    <div class="card">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-striped table-hover mb-0">
            <thead class="table-light">
              <!-- <tr><th>ID</th><th>Name</th><th>Email</th><th>Department</th><th class="text-end">Actions</th></tr> -->
            </thead>
            <tbody>
            <% if (faculty.isEmpty()) { %>
              <tr><td colspan="5" class="text-center py-4">No faculty registered.</td></tr>
            <% } else {
                 for (Map<String,Object> f : faculty) {
                     String idStr = String.valueOf(f.get("id"));
            %>
              <tr>
                <td><%= idStr %></td>
                <td><%= f.get("name") %></td>
                <td><%= f.get("email") %></td>
                <td><%= f.get("department") == null ? "-" : f.get("department") %></td>
                <td class="text-end">
                <!--<a class="btn btn-sm btn-outline-primary" href="<%= request.getContextPath() %>/viewFacultyDetail.jsp?id=<%= idStr %>">View</a>
                  &nbsp;  -->   
                  <form method="post" action="<%= request.getContextPath() %>/adminManageUsers.jsp" style="display:inline" onsubmit="return confirm('Delete faculty ID <%= idStr %>?');">
                    <input type="hidden" name="deleteFacultyId" value="<%= idStr %>"/>
                   <!-- <button class="btn btn-sm btn-danger" type="submit">Delete</button> --> 
                  </form>
                </td>
              </tr>
            <%   }
               } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="mt-3">
      <a class="btn btn-secondary" href="<%= request.getContextPath() %>/adminPortal.jsp">Back to Admin Portal</a>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
