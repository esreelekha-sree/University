<%@ page import="java.sql.*, java.time.*, java.time.format.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  // small html-escape helper
  public String esc(String s){
    if(s==null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#x27;");
  }

  // convert datetime-local value (yyyy-MM-dd'T'HH:mm) to SQL datetime string (yyyy-MM-dd HH:mm:ss)
  public String convertDatetimeLocalToSql(String v) {
    if (v == null) return null;
    v = v.trim();
    if (v.length() == 0) return null;
    // Replace 'T' with space
    v = v.replace('T', ' ');
    // If seconds missing, append :00
    if (v.matches("^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}$")) {
      v = v + ":00";
    }
    // Basic validation try
    try {
      // will throw if format invalid
      LocalDateTime.parse(v, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
      return v;
    } catch (Exception ex) {
      // fallback: try to normalize with LocalDateTime parse of known input
      try {
        LocalDateTime dt = LocalDateTime.parse(v, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        return dt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
      } catch (Exception e2) {
        return null;
      }
    }
  }
%>
<%
  // ensure admin only
  String adminEmail = (String) session.getAttribute("adminEmail");
  if (adminEmail == null) {
    response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
    return;
  }

  String message = "";
  String error = "";

  // form fields (may be null)
  String id = request.getParameter("id");              // used for update POST
  String courseName = request.getParameter("courseName");
  String scheduleDateInput = request.getParameter("scheduleDate"); // expected yyyy-MM-dd'T'HH:mm
  String duration = request.getParameter("duration");
  String facultyName = request.getParameter("facultyName");
  String facultyEmail = request.getParameter("facultyEmail");

  // handle POST: create or update (write to "schedules" table)
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    // basic validation
    if (courseName == null || courseName.trim().isEmpty()) {
      error = "Course name is required.";
    } else if (scheduleDateInput == null || scheduleDateInput.trim().isEmpty()) {
      error = "Schedule date/time is required.";
    } else if (duration == null || duration.trim().isEmpty()) {
      error = "Duration is required.";
    } else if (facultyName == null || facultyName.trim().isEmpty()) {
      error = "Faculty name is required.";
    } else if (facultyEmail == null || facultyEmail.trim().isEmpty()) {
      error = "Faculty email is required.";
    }

    if (error.isEmpty()) {
      String scheduleForDb = convertDatetimeLocalToSql(scheduleDateInput);
      if (scheduleForDb == null) {
        error = "Invalid schedule date format.";
      } else {
        try (Connection conn = DatabaseConnection.getConnection()) {
          if (id != null && !id.trim().isEmpty()) {
            // UPDATE existing schedule (table name: schedules)
            String sql = "UPDATE schedules SET courseName = ?, scheduleDate = ?, duration = ?, facultyName = ?, faculty_email = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
              ps.setString(1, courseName.trim());
              ps.setString(2, scheduleForDb);
              ps.setInt(3, Integer.parseInt(duration));
              ps.setString(4, facultyName.trim());
              ps.setString(5, facultyEmail.trim());
              ps.setInt(6, Integer.parseInt(id));
              int r = ps.executeUpdate();
              if (r > 0) message = "Schedule updated.";
              else error = "Update failed (id not found).";
            }
          } else {
            // INSERT new schedule into schedules table
            String sql = "INSERT INTO schedules (courseName, scheduleDate, duration, facultyName, faculty_email) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
              ps.setString(1, courseName.trim());
              ps.setString(2, scheduleForDb);
              ps.setInt(3, Integer.parseInt(duration));
              ps.setString(4, facultyName.trim());
              ps.setString(5, facultyEmail.trim());
              int r = ps.executeUpdate();
              if (r > 0) {
                try (ResultSet g = ps.getGeneratedKeys()) {
                  if (g.next()) {
                    int newId = g.getInt(1);
                    message = "Schedule created (ID " + newId + ").";
                  } else message = "Schedule created.";
                }
              } else {
                error = "Failed to create schedule.";
              }
            }
          }
        } catch (Exception ex) {
          ex.printStackTrace();
          error = "Server error: " + esc(ex.getMessage());
        }
      }
    }
  }

  // prepare form defaults (for edit or for showing values after failed POST)
  String editId = request.getParameter("editId");
  if (editId == null) editId = request.getParameter("id"); // could be present after failed POST
  String formCourse = "";
  String formSchedule = "";
  String formDuration = "";
  String formFacultyName = "";
  String formFacultyEmail = "";

  if (editId != null && !editId.trim().isEmpty()) {
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT id, courseName, scheduleDate, duration, facultyName, faculty_email FROM schedules WHERE id = ?")) {
      ps.setInt(1, Integer.parseInt(editId));
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          formCourse = rs.getString("courseName");
          Timestamp ts = rs.getTimestamp("scheduleDate");
          if (ts != null) {
            // convert to datetime-local value: yyyy-MM-ddTHH:mm
            java.time.LocalDateTime ldt = ts.toLocalDateTime();
            formSchedule = ldt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
          } else formSchedule = "";
          formDuration = String.valueOf(rs.getInt("duration"));
          formFacultyName = rs.getString("facultyName");
          formFacultyEmail = rs.getString("faculty_email");
        } else {
          error = "Schedule entry not found for id " + esc(editId);
        }
      }
    } catch (Exception ex) {
      ex.printStackTrace();
      error = "Server error while loading schedule: " + esc(ex.getMessage());
    }
  } else {
    // if POST failed, display posted values so user doesn't lose them
    formCourse = courseName == null ? "" : courseName;
    formSchedule = scheduleDateInput == null ? "" : scheduleDateInput;
    formDuration = duration == null ? "" : duration;
    formFacultyName = facultyName == null ? "" : facultyName;
    formFacultyEmail = facultyEmail == null ? "" : facultyEmail;
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Create / Edit Schedule</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2><%= (editId!=null && !editId.isEmpty()) ? "Edit Schedule" : "Create Schedule" %></h2>
    <div>
      <a class="btn btn-secondary" href="<%= request.getContextPath() %>/adminScheduledList.jsp">Back to schedules</a>
    </div>
  </div>

  <% if (!message.isEmpty()) { %>
    <div class="alert alert-success"><%= esc(message) %></div>
  <% } %>
  <% if (!error.isEmpty()) { %>
    <div class="alert alert-danger"><%= esc(error) %></div>
  <% } %>

  <form method="post" action="<%= request.getRequestURI() %>">
    <% if (editId!=null && !editId.isEmpty()) { %>
      <input type="hidden" name="id" value="<%= esc(editId) %>"/>
    <% } %>

    <div class="mb-3">
      <label class="form-label">Course Name</label>
      <input name="courseName" class="form-control" required value="<%= esc(formCourse) %>"/>
    </div>

    <div class="mb-3">
      <label class="form-label">Schedule Date & Time</label>
      <input name="scheduleDate" type="datetime-local" class="form-control" required value="<%= esc(formSchedule) %>"/>
    </div>

    <div class="mb-3">
      <label class="form-label">Duration (minutes)</label>
      <input name="duration" type="number" min="1" class="form-control" required value="<%= esc(formDuration) %>"/>
    </div>

    <div class="mb-3">
      <label class="form-label">Faculty Name</label>
      <input name="facultyName" class="form-control" required value="<%= esc(formFacultyName) %>"/>
    </div>

    <div class="mb-3">
      <label class="form-label">Faculty Email</label>
      <input name="facultyEmail" type="email" class="form-control" required value="<%= esc(formFacultyEmail) %>"/>
    </div>

    <button class="btn btn-primary" type="submit"><%= (editId!=null && !editId.isEmpty()) ? "Update" : "Create" %></button>
  </form>
</div>
</body>
</html>
