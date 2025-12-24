<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // require faculty login
    String facultyEmail = (String) session.getAttribute("facultyEmail");
    if (facultyEmail == null) {
        response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
        return;
    }

    List<Map<String,Object>> schedules = new ArrayList<>();

    try (Connection conn = com.university.utils.DatabaseConnection.getConnection()) {
        String sql = "SELECT id, courseName, scheduleDate, duration, facultyName FROM scheduled_courses WHERE faculty_email = ? ORDER BY scheduleDate DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, facultyEmail);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> row = new HashMap<>();
                    // if your table uses different column names adjust these
                    row.put("id", rs.getInt("id"));
                    row.put("courseName", rs.getString("courseName"));
                    row.put("scheduleDate", rs.getString("scheduleDate"));
                    row.put("duration", rs.getInt("duration"));
                    row.put("facultyName", rs.getString("facultyName"));
                    schedules.add(row);
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("loadError", e.getMessage());
    }
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>My Scheduled Courses</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background:#f7f7f7; font-family: Arial, sans-serif; padding:20px; }
    .card { max-width:1000px; margin:20px auto; }
    table th, table td { vertical-align: middle; }
  </style>
</head>
<body>
  <div class="card">
    <div class="card-body">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>Scheduled Courses for <strong><%= facultyEmail %></strong></h4>
        <a class="btn btn-sm btn-secondary" href="<%= request.getContextPath() %>/facultyPortal.jsp">Back to Faculty Portal</a>
      </div>

      <% String loadErr = (String) request.getAttribute("loadError");
         if (loadErr != null) { %>
         <div class="alert alert-danger">Error loading schedules: <%= loadErr %></div>
      <% } %>

      <% if (schedules.isEmpty()) { %>
        <p>No scheduled courses found for your account.</p>
      <% } else { %>
        <div class="table-responsive">
          <table class="table table-striped table-bordered">
            <thead class="table-light">
              <tr>
                <th>#</th>
                <th>Course Name</th>
                <th>Schedule Date & Time</th>
                <th>Duration (min)</th>
                <th>Assigned to</th>
              </tr>
            </thead>
            <tbody>
              <% for (Map<String,Object> r : schedules) { %>
                <tr>
                  <td><%= r.get("id") %></td>
                  <td><%= r.get("courseName") %></td>
                  <td><%= r.get("scheduleDate") %></td>
                  <td><%= r.get("duration") %></td>
                  <td><%= r.get("facultyName") == null ? "-" : r.get("facultyName") %></td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } %>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
