<%@ page import="java.util.*, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  public String esc(String s) { if (s==null) return ""; return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#x27;"); }
  public String fmtTs(Timestamp t) { if (t==null) return ""; return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(t.getTime())); }
%>

<%
  // require faculty session
  String facultyEmail = (String) session.getAttribute("facultyEmail");
  if (facultyEmail == null) {
    response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
    return;
  }

  String ctx = request.getContextPath();
  String scheduleIdParam = request.getParameter("scheduleId");
  String attendanceDateParam = request.getParameter("attendanceDate"); // optional

  if (scheduleIdParam == null) {
    out.println("<p class='text-danger'>No schedule selected.</p>");
    return;
  }

  int scheduleId;
  try {
    scheduleId = Integer.parseInt(scheduleIdParam);
  } catch (NumberFormatException nfe) {
    out.println("<p class='text-danger'>Invalid schedule id.</p>");
    return;
  }

  // containers
  Map<String,Object> schedule = new HashMap<>();
  List<Map<String,Object>> students = new ArrayList<>(); // student_id, name, email
  Map<Integer, Boolean> existing = new HashMap<>(); // student_id -> present

  try (Connection conn = com.university.utils.DatabaseConnection.getConnection()) {
    // 1) load schedule info from 'schedules' table (use courseName, scheduleDate)
    try (PreparedStatement ps = conn.prepareStatement("SELECT id, courseName, scheduleDate FROM schedules WHERE id = ?")) {
      ps.setInt(1, scheduleId);
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          schedule.put("id", rs.getInt("id"));
          schedule.put("courseName", rs.getString("courseName"));
          schedule.put("scheduleDate", rs.getTimestamp("scheduleDate"));
        } else {
          out.println("<div class='alert alert-danger'>Schedule not found.</div>");
          return;
        }
      }
    }

    // 2) load the students for this schedule using schedule_students table
    String sqlStudents =
      "SELECT s.id AS student_id, s.name AS student_name, s.email AS student_email " +
      "FROM students s " +
      "JOIN schedule_students ss ON s.id = ss.student_id " +
      "WHERE ss.schedule_id = ? " +
      "ORDER BY s.name";

    try (PreparedStatement ps = conn.prepareStatement(sqlStudents)) {
      ps.setInt(1, scheduleId);
      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          Map<String,Object> m = new HashMap<>();
          m.put("student_id", rs.getInt("student_id"));
          m.put("student_name", rs.getString("student_name"));
          m.put("student_email", rs.getString("student_email"));
          students.add(m);
        }
      }
    }

    // 3) load existing attendance for these students for quick pre-check
    // we assume attendance table uses schedule_id column (if different, adapt)
    try (PreparedStatement ps = conn.prepareStatement("SELECT student_id, present FROM attendance WHERE schedule_id = ?")) {
      ps.setInt(1, scheduleId);
      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          existing.put(rs.getInt("student_id"), rs.getInt("present") == 1);
        }
      }
    }

  } catch (Exception ex) {
    ex.printStackTrace();
    out.println("<div class='alert alert-danger'>Server error: " + esc(ex.getMessage()) + "</div>");
    return;
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Record Attendance</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style> body { padding:24px; } </style>
</head>
<body>
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h1>Record Attendance</h1>
      <a class="btn btn-secondary" href="<%= ctx %>/facultyAssignedSchedules.jsp">Back to Portal</a>
    </div>

    <div class="mb-3">
      <strong>Schedule:</strong> <%= esc(String.valueOf(schedule.get("courseName") == null ? "" : schedule.get("courseName"))) %>
      &nbsp; | &nbsp;
      <strong>Date:</strong> <%= esc(fmtTs((java.sql.Timestamp) schedule.get("scheduleDate"))) %>
    </div>

    <form method="post" action="<%= ctx %>/saveAttendance">
      <input type="hidden" name="scheduleId" value="<%= scheduleId %>"/>
      <% if (attendanceDateParam != null && !attendanceDateParam.trim().isEmpty()) { %>
        <input type="hidden" name="attendanceDate" value="<%= esc(attendanceDateParam) %>"/>
      <% } %>

      <div class="table-responsive">
        <table class="table table-bordered">
          <thead class="table-light">
            <tr>
              <th>#</th>
              <th>Student Name</th>
              <th>Email</th>
              <th>Present</th>
              <th>Record Time (last)</th>
            </tr>
          </thead>
          <tbody>
            <% if (students.isEmpty()) { %>
              <tr><td colspan="5" class="text-center py-4">No students found for this schedule.</td></tr>
            <% } else {
                 int cnt = 1;
                 for (Map<String,Object> s : students) {
                    int sid = (Integer) s.get("student_id");
                    String sname = (String) s.get("student_name");
                    String semail = (String) s.get("student_email");
                    boolean pres = existing.containsKey(sid) ? existing.get(sid) : false;
            %>
              <tr>
                <td><%= cnt++ %></td>
                <td><%= esc(sname) %></td>
                <td><%= esc(semail) %></td>
                <td style="width:120px; text-align:center;">
                  <input type="checkbox" name="present_<%= sid %>" value="1" <%= pres ? "checked" : "" %> />
                </td>
                <td>-</td>
              </tr>
            <%   }
               } %>
          </tbody>
        </table>
      </div>

      <div class="mb-3">
        <button class="btn btn-success" type="submit">Save Attendance</button>
        <a class="btn btn-secondary" href="<%= ctx %>/facultyAssignedSchedules.jsp">Cancel</a>
      </div>
    </form>
  </div>
</body>
</html>
