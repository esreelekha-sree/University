<%@ page import="java.sql.*, java.util.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    // small escape helper to prevent XSS when echoing values
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
    // session checks - allow admin OR faculty to view this page
    String facultyEmail = (String) session.getAttribute("facultyEmail");
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (facultyEmail == null && adminEmail == null) {
        // not logged in as faculty or admin
        response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
        return;
    }

    String ctx = request.getContextPath();
    String msg = "";
    String err = "";

    // Handle deletion only for admin (POST)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String deleteScheduleId = request.getParameter("deleteScheduleId");
        if (deleteScheduleId != null && !deleteScheduleId.trim().isEmpty()) {
            if (adminEmail == null) {
                err = "Unauthorized: only admin can delete schedules.";
            } else {
                try (Connection conn = DatabaseConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("DELETE FROM schedules WHERE id = ?")) {
                    ps.setInt(1, Integer.parseInt(deleteScheduleId));
                    int r = ps.executeUpdate();
                    if (r > 0) msg = "Schedule removed successfully.";
                    else err = "No schedule found with id " + deleteScheduleId + ".";
                } catch (Exception e) {
                    e.printStackTrace();
                    err = "Server error while deleting schedule: " + esc(e.getMessage());
                }
            }
        }
    }

    // Load schedules
    List<Map<String,Object>> schedules = new ArrayList<>();
    try (Connection conn = DatabaseConnection.getConnection()) {
        // If admin -> select all
        if (adminEmail != null) {
            String sql = "SELECT id, courseName, scheduleDate, duration, facultyName, faculty_email FROM schedules ORDER BY scheduleDate DESC, id DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> r = new HashMap<>();
                    r.put("id", rs.getInt("id"));
                    r.put("courseName", rs.getString("courseName"));
                    r.put("scheduleDate", rs.getTimestamp("scheduleDate"));
                    r.put("duration", rs.getObject("duration"));
                    r.put("facultyName", rs.getString("facultyName"));
                    r.put("facultyEmail", rs.getString("faculty_email"));
                    schedules.add(r);
                }
            }
        } else {
            // faculty view: try to limit schedules to those assigned to this faculty
            // attempt to find faculty_id in a faculty table (if it exists)
            Integer facultyId = null;
            try (PreparedStatement fps = conn.prepareStatement("SELECT id FROM faculty WHERE email = ?")) {
                fps.setString(1, facultyEmail);
                try (ResultSet frs = fps.executeQuery()) {
                    if (frs.next()) facultyId = frs.getInt(1);
                }
            } catch (SQLException ignore) {
                // if faculty table doesn't exist, ignore and rely on faculty_email column
            }

            String sql;
            if (facultyId != null) {
                // match either by faculty_email or by faculty_id
                sql = "SELECT id, courseName, scheduleDate, duration, facultyName, faculty_email FROM schedules " +
                      "WHERE faculty_email = ? OR faculty_id = ? ORDER BY scheduleDate DESC, id DESC";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, facultyEmail);
                    ps.setInt(2, facultyId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String,Object> r = new HashMap<>();
                            r.put("id", rs.getInt("id"));
                            r.put("courseName", rs.getString("courseName"));
                            r.put("scheduleDate", rs.getTimestamp("scheduleDate"));
                            r.put("duration", rs.getObject("duration"));
                            r.put("facultyName", rs.getString("facultyName"));
                            r.put("facultyEmail", rs.getString("faculty_email"));
                            schedules.add(r);
                        }
                    }
                }
            } else {
                // only filter by faculty_email
                sql = "SELECT id, courseName, scheduleDate, duration, facultyName, faculty_email FROM schedules " +
                      "WHERE faculty_email = ? ORDER BY scheduleDate DESC, id DESC";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, facultyEmail);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String,Object> r = new HashMap<>();
                            r.put("id", rs.getInt("id"));
                            r.put("courseName", rs.getString("courseName"));
                            r.put("scheduleDate", rs.getTimestamp("scheduleDate"));
                            r.put("duration", rs.getObject("duration"));
                            r.put("facultyName", rs.getString("facultyName"));
                            r.put("facultyEmail", rs.getString("faculty_email"));
                            schedules.add(r);
                        }
                    }
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
  <title>Assigned Schedules</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { padding: 20px; background: #f8f9fa; }
    .table td, .table th { vertical-align: middle; }
  </style>
</head>
<body>
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2>Assigned Schedules</h2>
      <div>
        <% if (adminEmail != null) { %>
          <span class="me-3">Signed in as <strong><%= esc(adminEmail) %></strong></span>
        <% } else { %>
          <span class="me-3">Signed in as <strong><%= esc(facultyEmail) %></strong></span>
        <% } %>
        <a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/facultyPortal.jsp">Back to Portal</a>
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
                <th>Schedule Date</th>
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
                 for (Map<String,Object> r : schedules) {
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
            %>
              <tr>
                <td><%= scheduleIdVal %></td>
                <td><%= esc((String)r.get("courseName")) %></td>
                <td><%= schedStr %></td>
                <td><%= r.get("duration") == null ? "-" : r.get("duration") %></td>
                <td><%= esc((String)r.get("facultyName")) %></td>
                <td><%= esc((String)r.get("facultyEmail")) %></td>
                <td class="text-end">
                  <%-- Faculty and admin can record/view attendance; only admin can delete --%>
                  <a class="btn btn-sm btn-primary" href="<%= ctx %>/recordAttendance.jsp?scheduleId=<%= scheduleIdVal %>">Record Attendance</a>
                  &nbsp;
                  <a class="btn btn-sm btn-success" href="<%= ctx %>/viewAttendance.jsp?scheduleId=<%= scheduleIdVal %>">View Attendance</a>
                  &nbsp;
                  <% if (adminEmail != null) { %>
                    <form method="post" style="display:inline" onsubmit="return confirm('Delete schedule ID <%= scheduleIdVal %>?');">
                      <input type="hidden" name="deleteScheduleId" value="<%= scheduleIdVal %>"/>
                      <button class="btn btn-sm btn-danger" type="submit">Delete</button>
                    </form>
                  <% } %>
                </td>
              </tr>
            <%   }
               } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <a class="btn btn-secondary" href="<%= ctx %>/facultyPortal.jsp">Back to Faculty Portal</a>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
