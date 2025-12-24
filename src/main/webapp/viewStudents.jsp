<%@ page import="java.sql.*, java.util.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    String facultyEmail = (String) session.getAttribute("facultyEmail");
    // require either faculty or admin to view
    if (adminEmail == null && facultyEmail == null) {
        response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
        return;
    }

    List<Map<String,Object>> students = new ArrayList<>();
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT id, name, email, department FROM students ORDER BY id ASC");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Map<String,Object> m = new HashMap<>();
            m.put("id", rs.getInt("id"));
            m.put("name", rs.getString("name"));
            m.put("email", rs.getString("email"));
            m.put("department", rs.getString("department"));
            students.add(m);
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    }
%>
<!doctype html>
<html>
<head><meta charset="utf-8"/><title>Registered Students</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Registered Students</h2>
    <a class="btn btn-secondary" href="<%= request.getContextPath() %>/facultyPortal.jsp">Back</a>
  </div>
  <div class="table-responsive">
    <table class="table table-striped">
      <thead class="table-light"><tr><th>ID</th><th>Name</th><th>Email</th><th>Department</th></tr></thead>
      <tbody>
      <% if (students.isEmpty()) { %>
        <tr><td colspan="4" class="text-center">No students found.</td></tr>
      <% } else {
           for (Map<String,Object> s : students) {
      %>
        <tr>
          <td><%= s.get("id") %></td>
          <td><%= s.get("name") %></td>
          <td><%= s.get("email") %></td>
          <td><%= s.get("department") == null ? "-" : s.get("department") %></td>
        </tr>
      <%   }
         } %>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>
