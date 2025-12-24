<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String facEmail = (String) session.getAttribute("facultyEmail");
    if (facEmail == null) {
        response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
        return;
    }

    List<Map<String,Object>> students = new ArrayList<>();
    try (Connection conn = com.university.utils.DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT id, name, email, department FROM students ORDER BY id ASC");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Map<String,Object> s = new HashMap<>();
            s.put("id", rs.getInt("id"));
            s.put("name", rs.getString("name"));
            s.put("email", rs.getString("email"));
            s.put("department", rs.getString("department"));
            students.add(s);
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "Error loading students: " + e.getMessage());
    }
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Registered Students</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
  <div class="container" style="max-width:900px">
    <h4>Registered Students</h4>
    <% String err = (String) request.getAttribute("error");
       if (err != null) { %>
      <div class="alert alert-danger"><%= err %></div>
    <% } %>

    <table class="table table-striped">
      <thead class="table-light">
        <tr><th>ID</th><th>Name</th><th>Email</th><th>Department</th></tr>
      </thead>
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
            <td><%= s.get("department") %></td>
          </tr>
        <%   }
           } %>
      </tbody>
    </table>

    <a href="facultyPortal.jsp">Back to Portal</a>
  </div>
</body>
</html>
