<%@ page import="java.sql.*, java.util.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  public String esc(String s) {
    if (s==null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#x27;");
  }
%>
<%
  List<Map<String,Object>> pubs = new ArrayList<>();
  String err = "";

  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement("SELECT id, title, author, content, datePosted FROM publications ORDER BY datePosted DESC")) {
    try (ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        Map<String,Object> m = new HashMap<>();
        m.put("id", rs.getInt("id"));
        m.put("title", rs.getString("title"));
        m.put("author", rs.getString("author"));
        m.put("content", rs.getString("content"));
        m.put("datePosted", rs.getTimestamp("datePosted"));
        pubs.add(m);
      }
    }
  } catch (Exception ex) {
    ex.printStackTrace();
    err = "Server error: " + ex.getMessage();
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Publications</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style> body{padding:20px;} .excerpt{white-space:pre-wrap; max-height:4.5em; overflow:hidden;} </style>
</head>
<body class="container">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Publications</h2>
    <a class="btn btn-sm btn-outline-secondary" href="<%= request.getContextPath() %>/studentPortal.jsp">Back</a>
  </div>

  <% if (!err.isEmpty()) { %>
    <div class="alert alert-danger"><%= esc(err) %></div>
  <% } %>

  <% if (pubs.isEmpty()) { %>
    <div class="alert alert-info">No publications yet.</div>
  <% } else { %>
    <div class="list-group">
      <% for (Map<String,Object> p : pubs) {
           String idStr = String.valueOf(p.get("id"));
           String title = (String)p.get("title");
           String author = (String)p.get("author");
           java.sql.Timestamp ts = (java.sql.Timestamp)p.get("datePosted");
           String content = (String)p.get("content");
      %>
      <div class="list-group-item mb-2">
        <div class="d-flex justify-content-between">
          <h5><%= esc(title) %></h5>
          <small class="text-muted"><%= ts == null ? "-" : ts.toString() %></small>
        </div>
        <p class="mb-1"><small>By <strong><%= esc(author) %></strong></small></p>
        <p class="excerpt"><%= esc(content==null? "": (content.length()>300? content.substring(0,300)+"...":content)) %></p>
        <a class="btn btn-sm btn-outline-primary" href="<%= request.getContextPath() %>/publicationDetails.jsp?id=<%= esc(idStr) %>">Read more</a>
      </div>
      <% } %>
    </div>
  <% } %>
</body>
</html>
