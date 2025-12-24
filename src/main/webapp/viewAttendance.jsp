<%@ page import="java.sql.*, java.util.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    public String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
                .replace("\"","&quot;").replace("'","&#x27;");
    }
%>
<%
  String studentEmail = (String) session.getAttribute("studentEmail");
  String facultyEmail = (String) session.getAttribute("facultyEmail");
  String adminEmail = (String) session.getAttribute("adminEmail");

  String scheduleIdParam = request.getParameter("scheduleId");
  String attendanceDateParam = request.getParameter("attendanceDate"); // yyyy-MM-dd format
  String msg = "";
  String err = "";

  // If not logged in, redirect
  if (studentEmail==null && facultyEmail==null && adminEmail==null) {
    response.sendRedirect(request.getContextPath() + "/");
    return;
  }

  // If POST -> update attendance (faculty/admin only)
  if ("POST".equalsIgnoreCase(request.getMethod())) {
      if (facultyEmail == null && adminEmail == null) {
          err = "Unauthorized.";
      } else {
          String postScheduleId = request.getParameter("postScheduleId");
          String postDate = request.getParameter("attendanceDate");
          String[] presentArr = request.getParameterValues("present");
          Set<Integer> presentSet = new HashSet<>();
          if (presentArr != null) {
              for (String s : presentArr) {
                  try { presentSet.add(Integer.parseInt(s)); } catch(Exception e){}
              }
          }
          if (postScheduleId == null || postScheduleId.trim().isEmpty() || postDate == null || postDate.trim().isEmpty()) {
              err = "Missing schedule or date.";
          } else {
              int scheduleId = Integer.parseInt(postScheduleId);
              java.sql.Date attendanceDate = java.sql.Date.valueOf(postDate);
              Connection conn = null;
              try {
                  conn = DatabaseConnection.getConnection();
                  conn.setAutoCommit(false);

                  // delete existing for that schedule and date
                  try (PreparedStatement del = conn.prepareStatement(
                          "DELETE FROM attendance WHERE schedule_id = ? AND attendanceDate = ?")) {
                      del.setInt(1, scheduleId);
                      del.setDate(2, attendanceDate);
                      del.executeUpdate();
                  }

                  // determine student list (use schedule_students mapping if exists)
                  List<Integer> studentsToSave = new ArrayList<>();
                  try (PreparedStatement ps = conn.prepareStatement(
                          "SELECT s.id FROM schedule_students ss JOIN students s ON s.id = ss.student_id WHERE ss.schedule_id = ? ORDER BY s.id")) {
                      ps.setInt(1, scheduleId);
                      try (ResultSet rs = ps.executeQuery()) {
                          while (rs.next()) studentsToSave.add(rs.getInt(1));
                      }
                  }
                  if (studentsToSave.isEmpty()) {
                      try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM students ORDER BY id");
                           ResultSet rs = ps.executeQuery()) {
                          while (rs.next()) studentsToSave.add(rs.getInt(1));
                      }
                  }

                  String insertSql = "INSERT INTO attendance (student_id, schedule_id, present, courseName, attendanceDate, status) VALUES (?, ?, ?, ?, ?, ?)";
                  String courseName = request.getParameter("courseName");
                  if (courseName == null) courseName = "";

                  try (PreparedStatement ins = conn.prepareStatement(insertSql)) {
                      for (Integer sid : studentsToSave) {
                          boolean present = presentSet.contains(sid);
                          ins.setInt(1, sid);
                          ins.setInt(2, scheduleId);
                          ins.setBoolean(3, present);
                          ins.setString(4, courseName);
                          ins.setDate(5, attendanceDate);
                          ins.setString(6, present ? "Present" : "Absent");
                          ins.addBatch();
                      }
                      ins.executeBatch();
                  }

                  conn.commit();
                  msg = "Attendance updated for " + attendanceDate.toString();

                  // set params so page displays this date after POST
                  scheduleIdParam = String.valueOf(scheduleId);
                  attendanceDateParam = attendanceDate.toString();

              } catch (Exception ex) {
                  if (conn != null) try { conn.rollback(); } catch(Exception ignore){}
                  ex.printStackTrace();
                  err = "Error updating attendance: " + esc(ex.getMessage());
              } finally {
                  if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch(Exception ignore){}
              }
          }
      }
  }

  // Now populate view data
  List<Map<String,Object>> rows = new ArrayList<>();
  List<java.sql.Date> dates = new ArrayList<>();
  String scheduleCourseName = "";
  if (scheduleIdParam != null) {
    int scheduleId = Integer.parseInt(scheduleIdParam);
    try (Connection conn = DatabaseConnection.getConnection()) {
      // load distinct attendance dates for this schedule (for selection)
      try (PreparedStatement ps = conn.prepareStatement(
              "SELECT DISTINCT attendanceDate FROM attendance WHERE schedule_id = ? ORDER BY attendanceDate DESC")) {
          ps.setInt(1, scheduleId);
          try (ResultSet rs = ps.executeQuery()) {
              while (rs.next()) dates.add(rs.getDate(1));
          }
      }

      // get course name (for display)
      try (PreparedStatement ps = conn.prepareStatement("SELECT courseName FROM schedules WHERE id = ?")) {
          ps.setInt(1, scheduleId);
          try (ResultSet rs = ps.executeQuery()) {
              if (rs.next()) scheduleCourseName = rs.getString(1);
          }
      }

      // If attendanceDateParam present -> show attendance rows for that date
      if (attendanceDateParam != null && !attendanceDateParam.trim().isEmpty()) {
          java.sql.Date selDate = java.sql.Date.valueOf(attendanceDateParam);
          try (PreparedStatement ps = conn.prepareStatement(
                  "SELECT a.student_id, st.name, st.email, a.present, a.recorded_at " +
                  "FROM attendance a " +
                  "LEFT JOIN students st ON st.id = a.student_id " +
                  "WHERE a.schedule_id = ? AND a.attendanceDate = ? ORDER BY st.name")) {
              ps.setInt(1, scheduleId);
              ps.setDate(2, selDate);
              try (ResultSet rs = ps.executeQuery()) {
                  while (rs.next()) {
                      Map<String,Object> m = new HashMap<>();
                      m.put("studentId", rs.getInt(1));
                      m.put("name", rs.getString(2));
                      m.put("email", rs.getString(3));
                      m.put("present", rs.getBoolean(4));
                      m.put("recordedAt", rs.getTimestamp(5));
                      rows.add(m);
                  }
              }
          }
      }
    } catch (Exception ex) {
      ex.printStackTrace();
      err = "Server error: " + esc(ex.getMessage());
    }
  } else {
    // If no schedule for admin/faculty, redirect back
    if (facultyEmail != null) response.sendRedirect(request.getContextPath()+"/facultyAssignedSchedules.jsp");
    else if (adminEmail != null) response.sendRedirect(request.getContextPath()+"/adminScheduledList.jsp");
    else response.sendRedirect(request.getContextPath()+"/");
    return;
  }
%>

<!doctype html>
<html>
<head><meta charset="utf-8"/><title>View Attendance</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<style> body { padding:24px; } </style>
</head>
<body>
<div class="container py-4">
  <h3>Attendance</h3>
  <p><strong>Attendance for schedule:</strong> <%= esc(scheduleCourseName.isEmpty() ? ("#" + scheduleIdParam) : scheduleCourseName) %></p>

  <% if (!err.isEmpty()) { %>
    <div class="alert alert-danger"><%= esc(err) %></div>
  <% } %>
  <% if (!msg.isEmpty()) { %>
    <div class="alert alert-success"><%= esc(msg) %></div>
  <% } %>

  <div class="mb-3">
    <form method="get" class="d-flex align-items-center" action="<%= request.getRequestURI() %>">
      <input type="hidden" name="scheduleId" value="<%= esc(scheduleIdParam) %>"/>
      <label class="me-2">Choose date:</label>
      <select name="attendanceDate" class="form-select me-2" style="width:auto">
        <option value="">-- select date --</option>
        <% for (java.sql.Date d : dates) { %>
          <option value="<%= d.toString() %>" <%= (d.toString().equals(attendanceDateParam) ? "selected" : "") %>><%= d.toString() %></option>
        <% } %>
      </select>
      <button class="btn btn-outline-primary me-2" type="submit">Open</button>
      <% if ((facultyEmail != null || adminEmail != null) && attendanceDateParam != null && !attendanceDateParam.isEmpty()) { %>
        <!-- quick link to recordAttendance page for this schedule/date if needed -->
        <a class="btn btn-secondary me-2" href="<%= request.getContextPath() %>/recordAttendance.jsp?scheduleId=<%= esc(scheduleIdParam) %>&attendanceDate=<%= esc(attendanceDateParam) %>">Open in Record Page</a>
      <% } %>
      <a class="btn btn-secondary" href="<%= request.getContextPath() %>/facultyAssignedSchedules.jsp">Back</a>
    </form>
  </div>

  <% if (attendanceDateParam == null || attendanceDateParam.trim().isEmpty()) { %>
    <div class="text-muted">No attendance recorded for this schedule yet.</div>
  <% } else { %>

    <% if (rows.isEmpty()) { %>
      <div class="alert alert-info">No attendance recorded for this date (<%= esc(attendanceDateParam) %>).</div>
    <% } %>

    <!-- If faculty/admin: allow updating attendance for the chosen date -->
    <% if (facultyEmail != null || adminEmail != null) { %>
      <form method="post" action="<%= request.getRequestURI() %>">
        <input type="hidden" name="postScheduleId" value="<%= esc(scheduleIdParam) %>"/>
        <input type="hidden" name="attendanceDate" value="<%= esc(attendanceDateParam) %>"/>
        <input type="hidden" name="courseName" value="<%= esc(scheduleCourseName) %>"/>

        <table class="table">
          <thead><tr><th>Student ID</th><th>Name</th><th>Email</th><th>Date</th><th>Present</th><th>Recorded At</th></tr></thead>
          <tbody>
            <% for (Map<String,Object> r : rows) { %>
              <tr>
                <td><%= r.get("studentId") %></td>
                <td><%= esc((String)r.get("name")) %></td>
                <td><%= esc((String)r.get("email")) %></td>
                <td><%= esc(attendanceDateParam) %></td>
                <td><input type="checkbox" name="present" value="<%= r.get("studentId") %>" <%= ((Boolean)r.get("present")) ? "checked" : "" %> /></td>
                <td><%= r.get("recordedAt") == null ? "-" : r.get("recordedAt") %></td>
              </tr>
            <% } %>
          </tbody>
        </table>

        <button class="btn btn-primary" type="submit">Save Changes</button>
      </form>
    <% } else { /* student view (read-only) */ %>
      <table class="table">
        <thead><tr><th>Student ID</th><th>Name</th><th>Email</th><th>Date</th><th>Present</th><th>Recorded At</th></tr></thead>
        <tbody>
          <% for (Map<String,Object> r : rows) { %>
            <tr>
              <td><%= r.get("studentId") %></td>
              <td><%= esc((String)r.get("name")) %></td>
              <td><%= esc((String)r.get("email")) %></td>
              <td><%= esc(attendanceDateParam) %></td>
              <td><%= ((Boolean)r.get("present")) ? "Yes" : "No" %></td>
              <td><%= r.get("recordedAt") == null ? "-" : r.get("recordedAt") %></td>
            </tr>
          <% } %>
        </tbody>
      </table>
    <% } %>
  <% } %>

</div>
</body>
</html>
