<%@ page import="java.sql.*, java.util.*, java.text.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  public String esc(String s){
    if (s==null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#x27;");
  }
%>
<%
  // auth
  String studentEmail = (String) session.getAttribute("studentEmail");
  Integer studentIdObj = (Integer) session.getAttribute("studentId");
  if (studentEmail == null || studentIdObj == null) {
    response.sendRedirect(request.getContextPath() + "/studentLogin.jsp");
    return;
  }
  int studentId = studentIdObj.intValue();

  String ctx = request.getContextPath();
  String msg = "";
  String err = "";

  // handle POST: Unregister
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String unregisterId = request.getParameter("unregisterScheduleId");
    if (unregisterId != null && !unregisterId.trim().isEmpty()) {
      try (Connection conn = DatabaseConnection.getConnection();
           PreparedStatement del = conn.prepareStatement(
             "DELETE FROM schedule_students WHERE schedule_id = ? AND student_id = ?")) {
        del.setInt(1, Integer.parseInt(unregisterId));
        del.setInt(2, studentId);
        int affected = del.executeUpdate();
        if (affected > 0) msg = "Unregistered from schedule #" + unregisterId + ".";
        else err = "Could not unregister (maybe you were not registered).";
      } catch (Exception ex) {
        ex.printStackTrace();
        err = "Server error while unregistering: " + esc(ex.getMessage());
      }
    }
  }

  // Load registered schedules for this student (join schedule_students -> schedules)
  List<Map<String,Object>> schedules = new ArrayList<>();
  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement(
         "SELECT s.id AS schedule_id, s.courseName, s.scheduleDate, s.duration, s.facultyName, s.faculty_email " +
         "FROM schedules s JOIN schedule_students ss ON ss.schedule_id = s.id " +
         "WHERE ss.student_id = ? " +
         "ORDER BY s.scheduleDate DESC, s.id DESC")) {
    ps.setInt(1, studentId);
    try (ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        Map<String,Object> m = new HashMap<>();
        m.put("schedule_id", rs.getInt("schedule_id"));
        m.put("courseName", rs.getString("courseName"));
        m.put("scheduleDate", rs.getTimestamp("scheduleDate"));
        m.put("duration", rs.getObject("duration"));
        m.put("facultyName", rs.getString("facultyName"));
        m.put("facultyEmail", rs.getString("faculty_email"));
        schedules.add(m);
      }
    }
  } catch (Exception ex) {
    ex.printStackTrace();
    err = "Server error while loading your registered schedules: " + esc(ex.getMessage());
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>My Registered Courses</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style> body { padding: 24px; } </style>
</head>
<body>
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2>My Registered Schedules</h2>
      <a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/studentPortal.jsp">Back to Portal</a>
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
                <th class="text-end">Action</th>
              </tr>
            </thead>
            <tbody>
              <% if (schedules.isEmpty()) { %>
                <tr><td colspan="7" class="text-center py-4">You are not registered to any schedules.</td></tr>
              <% } else {
                   java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
                   for (Map<String,Object> r : schedules) {
                      int sid = (r.get("schedule_id") instanceof Number) ? ((Number)r.get("schedule_id")).intValue() : -1;
                      Object ts = r.get("scheduleDate");
                      String schedStr = "";
                      if (ts instanceof java.sql.Timestamp) {
                        schedStr = sdf.format(new java.util.Date(((java.sql.Timestamp)ts).getTime()));
                      } else if (ts != null) {
                        schedStr = esc(String.valueOf(ts));
                      }
              %>
                <tr>
                  <td><%= sid %></td>
                  <td><%= esc((String)r.get("courseName")) %></td>
                  <td><%= schedStr %></td>
                  <td><%= r.get("duration")==null ? "-" : r.get("duration") %></td>
                  <td><%= esc((String)r.get("facultyName")) %></td>
                  <td><%= esc((String)r.get("facultyEmail")) %></td>
                  <td class="text-end">
                    <form method="post" style="display:inline" onsubmit="return confirm('Unregister from schedule #' + <%= sid %> + '?');">
                      <input type="hidden" name="unregisterScheduleId" value="<%= sid %>"/>
                      <button type="submit" class="btn btn-sm btn-danger">Unregister</button>
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

  <!--p>If you want to register for more schedules, go to <a href="<%= ctx %>/studentAvailableSchedules.jsp">Available Schedules</a> or <a href="<%= ctx %>/registerForCourse.jsp">Register for Course</a>.</p>  -->  
  </div>
</body>
</html>
