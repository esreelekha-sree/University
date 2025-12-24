<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String facEmail = (String) session.getAttribute("facultyEmail");
    if (facEmail == null) {
        response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
        return;
    }

    List<Map<String,Object>> schedules = new ArrayList<>();
    try (Connection conn = com.university.utils.DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(
             "SELECT id, courseName, scheduleDate, duration, facultyName FROM scheduled_courses WHERE faculty_email = ? ORDER BY scheduleDate ASC")) {
        ps.setString(1, facEmail);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> r = new HashMap<>();
                r.put("id", rs.getInt("id"));
                r.put("courseName", rs.getString("courseName"));
                r.put("scheduleDate", rs.getString("scheduleDate"));
                r.put("duration", rs.getInt("duration"));
                r.put("facultyName", rs.getString("facultyName"));
                schedules.add(r);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "Error loading schedules: " + e.getMessage());
    }
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>My Assigned Schedules</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
  <div class="container" style="max-width:900px">
    <h4>Schedules assigned to you</h4>
    <% String err = (String) request.getAttribute("error");
       if (err != null) { %>
      <div class="alert alert-danger"><%= err %></div>
    <% } %>

    <div class="table-responsive">
      <table class="table table-striped">
        <thead class="table-light">
          <tr><th>ID</th><th>Course</th><th>Schedule</th><th>Duration</th></tr>
        </thead>
        <tbody>
          <% if (schedules.isEmpty()) { %>
            <tr><td colspan="4" class="text-center">No scheduled courses assigned to you.</td></tr>
          <% } else {
               for (Map<String,Object> r : schedules) {
          %>
            <tr>
              <td><%= r.get("id") %></td>
              <td><%= r.get("courseName") %></td>
              <td><%= r.get("scheduleDate") %></td>
              <td><%= r.get("duration") %></td>
            </tr>
          <%   }
             } %>
        </tbody>
      </table>
    </div>

    <a href="facultyPortal.jsp">Back to Portal</a>
  </div>
</body>
</html>
