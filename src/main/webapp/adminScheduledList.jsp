<%@ page import="java.sql.*, java.util.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    // simple escape for HTML
    public String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;")
                .replace("<","&lt;")
                .replace(">","&gt;")
                .replace("\"","&quot;")
                .replace("'","&#x27;");
    }
%>
<%
    // only admin may access
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
        return;
    }

    String ctx = request.getContextPath();
    String msg = "";
    String err = "";

    // handle deletion (POST)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String deleteScheduleId = request.getParameter("deleteScheduleId");
        if (deleteScheduleId != null && !deleteScheduleId.trim().isEmpty()) {
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM schedules WHERE id = ?")) {
                ps.setInt(1, Integer.parseInt(deleteScheduleId));
                int affected = ps.executeUpdate();
                if (affected > 0) msg = "Schedule removed successfully.";
                else err = "No schedule found with id " + esc(deleteScheduleId) + ".";
            } catch (Exception e) {
                e.printStackTrace();
                err = "Server error while deleting schedule: " + esc(e.getMessage());
            }
        }
    }

    // load schedules
    List<Map<String,Object>> schedules = new ArrayList<>();
    try (Connection conn = DatabaseConnection.getConnection()) {
        String sql = "SELECT id, courseName, scheduleDate, duration, faculty_id, facultyName, faculty_email FROM schedules ORDER BY scheduleDate DESC, id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("courseName", rs.getString("courseName"));
                row.put("scheduleDate", rs.getTimestamp("scheduleDate"));
                row.put("duration", rs.getObject("duration"));
                row.put("faculty_id", rs.getObject("faculty_id"));
                row.put("facultyName", rs.getString("facultyName"));
                row.put("facultyEmail", rs.getString("faculty_email"));
                schedules.add(row);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        err = "Server error while loading schedules: " + esc(e.getMessage());
    }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Scheduled Courses (Admin)</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { padding: 20px; background: #f8f9fa; }
    .table td, .table th { vertical-align: middle; }
  </style>
</head>
<body>
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2>Scheduled Courses</h2>
      <div>
        <span class="me-3">Logged in as <strong><%= esc(adminEmail) %></strong> (Admin)</span>
        <a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/adminPortal.jsp">Back to Portal</a>
      </div>
    </div>

    <% if (!msg.isEmpty()) { %>
      <div class="alert alert-success"><%= esc(msg) %></div>
    <% } %>
    <% if (!err.isEmpty()) { %>
      <div class="alert alert-danger"><%= esc(err) %></div>
    <% } %>

    <div class="card mb-4">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-striped mb-0">
            <thead class="table-light">
              <tr>
                <th>ID</th>
                <th>Course</th>
                <th>Schedule Date &amp; Time</th>
                <th>Duration (mins)</th>
                <th>Faculty</th>
                <th>Faculty Email</th>
                <th class="text-end">Actions</th>
              </tr>
            </thead>
            <tbody>
              <% if (schedules.isEmpty()) { %>
                <tr><td colspan="7" class="text-center py-4">No schedules found.</td></tr>
              <% } else {
                   java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
                   for (int i = 0; i < schedules.size(); i++) {
                       Map<String,Object> r = schedules.get(i);
                       Object tsObj = r.get("scheduleDate");
                       String schedStr = "";
                       if (tsObj instanceof java.sql.Timestamp) {
                           schedStr = sdf.format(new java.util.Date(((java.sql.Timestamp)tsObj).getTime()));
                       } else if (tsObj != null) {
                           schedStr = esc(tsObj.toString());
                       }

                       int scheduleIdVal;
                       Object idObj = r.get("id");
                       if (idObj instanceof Number) scheduleIdVal = ((Number) idObj).intValue();
                       else {
                           try { scheduleIdVal = Integer.parseInt(String.valueOf(idObj)); }
                           catch (Exception ex) { scheduleIdVal = -1; }
                       }

                       String facultyName = esc((String) r.get("facultyName"));
                       String facultyEmail = esc((String) r.get("facultyEmail"));

              %>
                <tr>
                  <td><%= scheduleIdVal %></td>
                  <td><%= esc((String)r.get("courseName")) %></td>
                  <td><%= schedStr %></td>
                  <td><%= r.get("duration") == null ? "-" : r.get("duration") %></td>
                  <td><%= facultyName.isEmpty() ? "-" : facultyName %></td>
                  <td><%= facultyEmail.isEmpty() ? "-" : facultyEmail %></td>
                  <td class="text-end">
                    <!-- Edit button -> opens scheduleCourse.jsp with editId -->
                    <a class="btn btn-sm btn-outline-primary" href="<%= ctx %>/scheduleCourse.jsp?editId=<%= scheduleIdVal %>">Edit</a>
                    &nbsp;
                    <!-- Delete form -->
                    <form method="post" style="display:inline" onsubmit="return confirm('Delete scheduled entry ID <%= scheduleIdVal %>?');">
                      <input type="hidden" name="deleteScheduleId" value="<%= scheduleIdVal %>"/>
                      <button class="btn btn-sm btn-danger" type="submit">Delete</button>
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

    <a class="btn btn-secondary" href="<%= ctx %>/adminPortal.jsp">Back to Admin Portal</a>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
