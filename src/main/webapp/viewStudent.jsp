<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
        return;
    }
    String idParam = request.getParameter("id");
    if (idParam == null) {
        out.println("Missing id");
        return;
    }
    int id = Integer.parseInt(idParam);
    String name=null, email=null, department=null;
    try (Connection conn = com.university.utils.DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT id,name,email,department FROM students WHERE id = ?")) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                name = rs.getString("name");
                email = rs.getString("email");
                department = rs.getString("department");
            } else {
                out.println("Student not found.");
                return;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Server error: " + e.getMessage());
        return;
    }
%>
<!doctype html>
<html>
<head><meta charset="utf-8"/><title>Student Detail</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body class="p-4">
  <div class="container">
    <h2>Student Detail</h2>
    <dl class="row">
      <dt class="col-sm-3">ID</dt><dd class="col-sm-9"><%= id %></dd>
      <dt class="col-sm-3">Name</dt><dd class="col-sm-9"><%= name %></dd>
      <dt class="col-sm-3">Email</dt><dd class="col-sm-9"><%= email %></dd>
      <dt class="col-sm-3">Department</dt><dd class="col-sm-9"><%= department == null ? "-" : department %></dd>
    </dl>
    <a class="btn btn-secondary" href="<%= request.getContextPath() %>/viewStudents.jsp">Back to Students</a>
  </div>
</body>
</html>
