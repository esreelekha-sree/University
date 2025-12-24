<%@ page import="java.sql.*, java.util.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    String facultyEmail = (String) session.getAttribute("facultyEmail");
    if (adminEmail == null && facultyEmail == null) {
        response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
        return;
    }

    List<Map<String,Object>> faculty = new ArrayList<>();
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT id, name, email, department FROM faculty ORDER BY id ASC");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Map<String,Object> m = new HashMap<>();
            m.put("id", rs.getInt("id"));
            m.put("name", rs.getString("name"));
            m.put("email", rs.getString("email"));
            m.put("department", rs.getString("department"));
            faculty.add(m);
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    }
%>
<!doctype html>
<html>
<head><meta charset="utf-8"/><title>Registered Faculty</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Registered Faculty</h2>
    <a class="btn btn-secondary" href="<%= request.getContextPath() %>/facultyPortal.jsp">Back</a>
  </div>
  <div class="table-responsive">
    <table class="table table-striped">
      <thead class="table-light"><tr><th>ID</th><th>Name</th><th>Email</th><th>Department</th></tr></thead>
      <tbody>
      <% if (faculty.isEmpty()) { %>
        <tr><td colspan="4" class="text-center">No faculty found.</td></tr>
      <% } else {
           for (Map<String,Object> f : faculty) {
      %>
        <tr>
          <td><%= f.get("id") %></td>
          <td><%= f.get("name") %></td>
          <td><%= f.get("email") %></td>
          <td><%= f.get("department") == null ? "-" : f.get("department") %></td>
        </tr>
      <%   }
         } %>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>
