<%@ page import="java.util.*, java.sql.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  // small HTML-escape helper
  public String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;")
            .replace("<","&lt;")
            .replace(">","&gt;")
            .replace("\"","&quot;")
            .replace("'","&#x27;");
  }

  // timestamp formatter helper (null-safe)
  public String fmtTs(java.sql.Timestamp t) {
    if (t == null) return "";
    return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(t.getTime()));
  }
%>

<%
  // require faculty login
  String facultyEmail = (String) session.getAttribute("facultyEmail");
  if (facultyEmail == null) {
    response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
    return;
  }

  String ctx = request.getContextPath();
  // read optional messages from query params (keep behavior unchanged)
  String error = request.getParameter("error") == null ? "" : request.getParameter("error");
  String msg = request.getParameter("msg") == null ? "" : request.getParameter("msg");

  // load queries
  List<Map<String,Object>> queries = new ArrayList<>();
  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement(
         "SELECT id, student_id, student_name, student_email, subject, message, created_at, status, response_text FROM query ORDER BY created_at DESC"
       )) {

    try (ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        Map<String,Object> m = new HashMap<>();
        m.put("id", rs.getInt("id"));
        m.put("student_id", rs.getInt("student_id"));
        m.put("student_name", rs.getString("student_name"));
        m.put("student_email", rs.getString("student_email"));
        m.put("subject", rs.getString("subject"));
        m.put("message", rs.getString("message"));
        m.put("created_at", rs.getTimestamp("created_at"));
        m.put("status", rs.getString("status"));
        m.put("response_text", rs.getString("response_text"));
        queries.add(m);
      }
    }

  } catch (Exception ex) {
    // keep same visible error behavior
    error = "Server error: " + esc(ex.getMessage());
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Student Queries</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    /* small UI tweaks so long texts wrap nicely */
    td pre { white-space: pre-wrap; word-wrap: break-word; margin:0; }
  </style>
</head>
<body class="p-4">
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h1>Student Queries</h1>
      <a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/facultyPortal.jsp">Back</a>
    </div>

    <% if (!msg.isEmpty()) { %>
      <div class="alert alert-success"><%= esc(msg) %></div>
    <% } %>
    <% if (!error.isEmpty()) { %>
      <div class="alert alert-danger"><%= esc(error) %></div>
    <% } %>

    <div class="table-responsive">
      <table class="table table-striped">
        <thead class="table-light">
          <tr>
            <th>ID</th>
            <th>Student</th>
            <th>Subject</th>
            <th>Message</th>
            <th>Posted</th>
            <th>Status</th>
            <th>Response</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
        <% if (queries.isEmpty()) { %>
          <tr><td colspan="8" class="text-center">No queries found.</td></tr>
        <% } else {
             for (Map<String,Object> q : queries) {
               String id = String.valueOf(q.get("id"));
               String status = (String) q.get("status");
        %>
          <tr>
            <td><%= esc(id) %></td>
            <td>
              <strong><%= esc((String) q.get("student_name")) %></strong><br/>
              <small><%= esc((String) q.get("student_email")) %></small>
            </td>
            <td><%= esc((String) q.get("subject")) %></td>
            <td style="max-width:360px;"><pre><%= esc((String) q.get("message")) %></pre></td>
            <td><%= fmtTs((java.sql.Timestamp) q.get("created_at")) %></td>
            <td><%= esc(status) %></td>
            <td style="max-width:300px;"><pre><%= esc((String) q.get("response_text")) %></pre></td>
            <td style="min-width:160px;">
              <% if (!"resolved".equalsIgnoreCase(status)) { %>
                <form method="post" action="<%= ctx %>/resolveQuery">
                  <input type="hidden" name="id" value="<%= esc(id) %>"/>
                  <textarea name="reply" class="form-control mb-1" placeholder="Type reply..." rows="2" required></textarea>
                  <button class="btn btn-sm btn-success" type="submit">Resolve &amp; Send</button>
                </form>
              <% } else { %>
                <span class="text-muted">Already resolved</span>
              <% } %>
            </td>
          </tr>
        <%   }
           } %>
        </tbody>
      </table>
    </div>
  </div>
</body>
</html>
