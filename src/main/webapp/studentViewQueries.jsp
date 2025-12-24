<%@ page import="java.util.*, java.sql.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  public String esc(String s) { if (s==null) return ""; return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#x27;"); }
%>
<%
  Integer studentId = (Integer) session.getAttribute("studentId");
  String studentEmail = (String) session.getAttribute("studentEmail");
  if (studentId == null) {
    response.sendRedirect(request.getContextPath() + "/studentLogin.jsp");
    return;
  }

  String ctx = request.getContextPath();
  String error = "";
  String msg = "";

  List<Map<String,Object>> queries = new ArrayList<>();
  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement("SELECT id, subject, message, created_at, status, response_text, responder_email, responded_at FROM student_queries WHERE student_id = ? ORDER BY created_at DESC")) {
    ps.setInt(1, studentId);
    try (ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        Map<String,Object> m = new HashMap<>();
        m.put("id", rs.getInt("id"));
        m.put("subject", rs.getString("subject"));
        m.put("message", rs.getString("message"));
        m.put("created_at", rs.getTimestamp("created_at"));
        m.put("status", rs.getString("status"));
        m.put("response_text", rs.getString("response_text"));
        m.put("responder_email", rs.getString("responder_email"));
        m.put("responded_at", rs.getTimestamp("responded_at"));
        queries.add(m);
      }
    }
  } catch (Exception ex) {
    error = "Server error: " + esc(ex.getMessage());
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>My Queries</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h1>My Queries</h1>
      <a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/studentPortal.jsp">Back to Portal</a>
    </div>

    <% if (!error.isEmpty()) { %>
      <div class="alert alert-danger"><%= esc(error) %></div>
    <% } %>

    <table class="table table-striped">
      <thead class="table-light">
        <tr><th>ID</th><th>Subject</th><th>Message</th><th>Posted</th><th>Status</th><th>Response</th></tr>
      </thead>
      <tbody>
      <% if (queries.isEmpty()) { %>
        <tr><td colspan="6" class="text-center">You have not asked any queries yet.</td></tr>
      <% } else {
           for (Map<String,Object> q : queries) {
      %>
        <tr>
          <td><%= q.get("id") %></td>
          <td><%= esc((String)q.get("subject")) %></td>
          <td style="max-width:400px;"><%= esc((String)q.get("message")) %></td>
          <td><%= q.get("created_at") %></td>
          <td><%= esc((String)q.get("status")) %></td>
          <td>
            <% if (q.get("response_text") != null) { %>
              <div><strong><%= esc((String)q.get("responder_email")) %></strong> @ <%= q.get("responded_at") %></div>
              <div><%= esc((String)q.get("response_text")) %></div>
            <% } else { %>
              <span class="text-muted">No response yet</span>
            <% } %>
          </td>
        </tr>
      <%    }
         } %>
      </tbody>
    </table>
  </div>
</body>
</html>
