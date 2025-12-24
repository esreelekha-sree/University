<%@ page import="java.sql.*, java.util.*, java.text.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  public String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#x27;");
  }

  public String fmtDate(java.sql.Date d) {
    if (d == null) return "";
    return new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date(d.getTime()));
  }

  public String fmtTimestamp(Timestamp t) {
    if (t == null) return "";
    return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(t.getTime()));
  }
%>

<%
  String studentEmail = (String) session.getAttribute("studentEmail");
  if (studentEmail == null) {
    response.sendRedirect(request.getContextPath() + "/studentLogin.jsp");
    return;
  }

  String ctx = request.getContextPath();
  String error = "";
  List<Map<String,Object>> rows = new ArrayList<>();

  try (Connection conn = DatabaseConnection.getConnection()) {
    // get student id from email
    Integer studentId = null;
    try (PreparedStatement ps0 = conn.prepareStatement("SELECT id FROM students WHERE email = ? LIMIT 1")) {
      ps0.setString(1, studentEmail);
      try (ResultSet rs0 = ps0.executeQuery()) {
        if (rs0.next()) studentId = rs0.getInt(1);
      }
    }

    if (studentId == null) {
      error = "Student account not found for " + esc(studentEmail) + ".";
    } else {
      /*
        Select only records for this student.
        We use snake_case column names (student_id, schedule_id).
        Use LEFT JOIN schedules so rows without schedule_id still show up (courseName will be null).
      */
      String sql =
        "SELECT a.id, a.student_id, a.schedule_id, s.courseName, a.attendanceDate, a.present, a.recorded_at " +
        "FROM attendance a " +
        "LEFT JOIN schedules s ON s.id = a.schedule_id " +
        "WHERE a.student_id = ? " +
        "ORDER BY a.attendanceDate DESC, a.recorded_at DESC";
      try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, studentId);
        try (ResultSet rs = ps.executeQuery()) {
          while (rs.next()) {
            Map<String,Object> m = new HashMap<>();
            m.put("id", rs.getInt("id"));
            m.put("student_id", rs.getInt("student_id"));
            Object schedIdObj = rs.getObject("schedule_id");
            m.put("schedule_id", schedIdObj); // may be null
            m.put("courseName", rs.getString("courseName")); // may be null
            m.put("attendanceDate", rs.getDate("attendanceDate")); // may be null
            m.put("present", rs.getBoolean("present"));
            m.put("recorded_at", rs.getTimestamp("recorded_at"));
            rows.add(m);
          }
        }
      }
    }
  } catch (Exception ex) {
    ex.printStackTrace();
    error = "Server error while loading attendance: " + esc(ex.getMessage());
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>My Attendance</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style> body { padding:24px; } </style>
</head>
<body>
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h1>My Attendance</h1>
      <!-- CORRECTED: single expression <%= ctx %> -->
      <a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/studentPortal.jsp">Back to Portal</a>
    </div>

    <% if (!error.isEmpty()) { %>
      <div class="alert alert-danger"><%= esc(error) %></div>
    <% } %>

    <div class="card mb-4">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-striped mb-0">
            <thead class="table-light">
              <tr>
                <th>Schedule ID</th>
                <th>Course</th>
                <th>Date</th>
                <th>Present</th>
                <th>Recorded At</th>
              </tr>
            </thead>
            <tbody>
              <% if (rows.isEmpty()) { %>
                <tr><td colspan="5" class="text-center py-4">No attendance recorded yet.</td></tr>
              <% } else {
                   for (Map<String,Object> r : rows) {
                     Object schedObj = r.get("schedule_id");
                     String schedStr = (schedObj == null) ? "-" : String.valueOf(schedObj);
                     java.sql.Date ad = (java.sql.Date) r.get("attendanceDate");
                     Timestamp rec = (Timestamp) r.get("recorded_at");
              %>
               <tr>
                 <td><%= esc(schedStr) %></td>
                 <td><%= esc((String) r.get("courseName") == null ? "-" : (String) r.get("courseName")) %></td>
                 <td><%= esc(fmtDate(ad)) %></td>
                 <td><%= ((Boolean) r.get("present")) ? "Yes" : "No" %></td>
                 <td><%= esc(fmtTimestamp(rec)) %></td>
               </tr>
              <%   }
                 } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <p class="text-muted">Note: This page shows only your attendance records. If you expect records but see none, contact the faculty or admin.</p>
  </div>
</body>
</html>
