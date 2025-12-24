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
  String facultyEmail = (String) session.getAttribute("facultyEmail");
  if (facultyEmail == null) {
    response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
    return;
  }
  String ctx = request.getContextPath();
  String err = "";
  String msg = request.getParameter("msg") == null ? "" : request.getParameter("msg");

  List<Map<String,Object>> pubs = new ArrayList<>();
  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement("SELECT id, title, author, content, datePosted FROM publications WHERE faculty_email = ? ORDER BY datePosted DESC")) {
    ps.setString(1, facultyEmail);
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
  <title>My Publications</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style> body{padding:20px;} .excerpt{white-space:pre-wrap; max-height:4.5em; overflow:hidden;} </style>
</head>
<body class="container">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>My Publications</h2>
    <div>
      Signed in: <strong><%= esc(facultyEmail) %></strong>
      &nbsp;
      <a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/facultyPortal.jsp">Back</a>
    </div>
  </div>

  <% if (!err.isEmpty()) { %>
    <div class="alert alert-danger"><%= esc(err) %></div>
  <% } %>
  <% if (!msg.isEmpty()) { %>
    <div class="alert alert-success"><%= esc(msg) %></div>
  <% } %>

  <div class="mb-3">
    <a class="btn btn-primary" href="<%= ctx %>/postPublication.jsp">Post New Publication</a>
    &nbsp;
    <!--  <a class="btn btn-outline-secondary" href="<%= ctx %>/viewPublications.jsp">View All Publications (public)</a>-->
  </div>

  <% if (pubs.isEmpty()) { %>
    <div class="alert alert-info">You have no publications yet.</div>
  <% } else { %>
    <div class="list-group">
      <% for (Map<String,Object> p : pubs) {
           String idStr = String.valueOf(p.get("id"));
           String title = (String)p.get("title");
           String author = (String)p.get("author");
           java.sql.Timestamp ts = (java.sql.Timestamp)p.get("datePosted");
      %>
        <div class="list-group-item mb-2">
          <div class="d-flex w-100 justify-content-between">
            <h5 class="mb-1"><%= esc(title) %></h5>
            <small class="text-muted"><%= ts == null ? "-" : ts.toString() %></small>
          </div>
          <p class="mb-1"><small>By <strong><%= esc(author) %></strong></small></p>
          <div class="d-flex justify-content-end">
            <a class="btn btn-sm btn-outline-primary me-2" href="<%= ctx %>/postPublication.jsp?id=<%= esc(idStr) %>">Edit</a>

            <form method="post" action="<%= ctx %>/deletePublication.jsp" style="display:inline" onsubmit="return confirm('Delete this publication?');">
              <input type="hidden" name="id" value="<%= esc(idStr) %>"/>
              <button class="btn btn-sm btn-danger" type="submit">Delete</button>
            </form>
          </div>
        </div>
      <% } %>
    </div>
  <% } %>
</body>
</html>
