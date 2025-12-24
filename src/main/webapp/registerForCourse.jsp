<%@ page import="java.sql.*, java.util.* , com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> -->

<%!
  // small helper to escape HTML
  public String esc(String s){
    if (s==null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#x27;");
  }
%>
<%
  // --- require logged-in student ---
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

  // Handle POST => register selected schedule
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String scheduleIdStr = request.getParameter("scheduleId");
    if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
      err = "Please select a schedule to register.";
    } else {
      int scheduleId = -1;
      try {
        scheduleId = Integer.parseInt(scheduleIdStr);
      } catch (Exception ex) {
        scheduleId = -1;
      }
      if (scheduleId <= 0) {
        err = "Invalid schedule selected.";
      } else {
        try (Connection conn = DatabaseConnection.getConnection()) {
          // ensure schedule exists
          try (PreparedStatement psChk = conn.prepareStatement("SELECT id FROM schedules WHERE id = ?")) {
            psChk.setInt(1, scheduleId);
            try (ResultSet rs = psChk.executeQuery()) {
              if (!rs.next()) {
                err = "Selected schedule does not exist.";
              }
            }
          }

          if (err.isEmpty()) {
            // check already registered
            try (PreparedStatement psExists = conn.prepareStatement(
                  "SELECT 1 FROM schedule_students WHERE schedule_id = ? AND student_id = ?")) {
              psExists.setInt(1, scheduleId);
              psExists.setInt(2, studentId);
              try (ResultSet rs2 = psExists.executeQuery()) {
                if (rs2.next()) {
                  msg = "You are already registered for that schedule.";
                } else {
                  // insert mapping
                  try (PreparedStatement psIns = conn.prepareStatement(
                        "INSERT INTO schedule_students (schedule_id, student_id) VALUES (?, ?)")) {
                    psIns.setInt(1, scheduleId);
                    psIns.setInt(2, studentId);
                    int aff = psIns.executeUpdate();
                    if (aff > 0) {
                      msg = "Registered successfully for schedule #" + scheduleId + ".";
                    } else {
                      err = "Registration failed (no rows inserted).";
                    }
                  }
                }
              }
            }
          }
        } catch (Exception ex) {
          ex.printStackTrace();
          err = "Server error while registering: " + esc(ex.getMessage());
        }
      }
    }
  }

  // Load available schedules (exclude ones student already registered for)
  List<Map<String,Object>> schedules = new ArrayList<>();
  try (Connection conn = DatabaseConnection.getConnection()) {
    String sql =
      "SELECT s.id, s.courseName, s.scheduleDate, s.duration, s.facultyName, s.faculty_email " +
      "FROM schedules s " +
      "WHERE s.id NOT IN (SELECT schedule_id FROM schedule_students WHERE student_id = ?) " +
      "ORDER BY s.scheduleDate DESC, s.id DESC";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, studentId);
      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          Map<String,Object> m = new HashMap<>();
          m.put("id", rs.getInt("id"));
          m.put("courseName", rs.getString("courseName"));
          m.put("scheduleDate", rs.getTimestamp("scheduleDate"));
          m.put("duration", rs.getObject("duration"));
          m.put("facultyName", rs.getString("facultyName"));
          m.put("facultyEmail", rs.getString("faculty_email"));
          schedules.add(m);
        }
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
  <title>Register for Course</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style>
    body { padding: 30px; background: #f8f9fa; }
    .card { max-width: 900px; margin: 0 auto; }
  </style>
</head>
<body>
  <!-- <c:import url="/recommend" /> -->
   <div class="card p-4">
    <h3>Register for Course</h3>
    <p>Your Student ID: <strong><%= studentId %></strong></p>

    <% if (!err.isEmpty()) { %>
      <div class="alert alert-danger"><%= esc(err) %></div>
    <% } else if (!msg.isEmpty()) { %>
      <div class="alert alert-success"><%= esc(msg) %></div>
    <% } %>

    <form method="post" action="<%= request.getRequestURI() %>">
      <div class="mb-3">
        <label class="form-label">Select Schedule</label>
        <select name="scheduleId" class="form-select" required>
          <option value="">-- Choose a schedule --</option>
          <% java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
             for (Map<String,Object> s : schedules) {
                int sid = (s.get("id") instanceof Number) ? ((Number)s.get("id")).intValue() : -1;
                Object ts = s.get("scheduleDate");
                String sched = "";
                if (ts instanceof java.sql.Timestamp) sched = sdf.format(new java.util.Date(((java.sql.Timestamp)ts).getTime()));
                else if (ts != null) sched = esc(String.valueOf(ts));
                String label = esc((String)s.get("courseName")) + " — " + sched +
                               " (" + (s.get("duration")==null ? "-" : s.get("duration")) + " mins)";
          %>
            <option value="<%= sid %>"><%= label %></option>
          <% } %>
        </select>
      </div>

      <div class="mb-3">
        <button class="btn btn-primary" type="submit">Register</button>
        <a class="btn btn-secondary" href="<%= ctx %>/studentPortal.jsp">Back to Portal</a>
      </div>

      <% if (schedules.isEmpty()) { %>
        <div class="text-muted">No available schedules to register (you may already be registered).</div>
      <% } %>
    </form>

    <p class="mt-3">Tip: use <a href="<%= ctx %>/studentCourses.jsp">My Registered Courses</a> to view the schedules you have registered for.</p>
  </div>
</body>
</html>
