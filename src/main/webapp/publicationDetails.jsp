<%@ page import="java.sql.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  public String esc(String s) {
    if (s==null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#x27;");
  }
%>
<%
  String id = request.getParameter("id");
  if (id == null) {
    response.sendRedirect(request.getContextPath() + "/viewPublications.jsp");
    return;
  }
  String title = "", author = "", content = "";
  Timestamp ts = null;
  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement("SELECT title, author, content, datePosted FROM publications WHERE id = ?")) {
    ps.setInt(1, Integer.parseInt(id));
    try (ResultSet rs = ps.executeQuery()) {
      if (rs.next()) {
        title = rs.getString(1);
        author = rs.getString(2);
        content = rs.getString(3);
        ts = rs.getTimestamp(4);
      } else {
        response.sendRedirect(request.getContextPath() + "/viewPublications.jsp");
        return;
      }
    }
  } catch (Exception ex) {
    ex.printStackTrace();
    response.sendRedirect(request.getContextPath() + "/viewPublications.jsp");
    return;
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title><%= esc(title) %></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style> body{padding:20px;} </style>
</head>
<body class="container">
  <a class="btn btn-outline-secondary mb-3" href="<%= request.getContextPath() %>/viewPublication.jsp">Back</a>
  <h1><%= esc(title) %></h1>
  <p class="text-muted">By <strong><%= esc(author) %></strong> — <%= ts==null ? "-" : ts.toString() %></p>
  <hr/>
  <div><pre style="white-space:pre-wrap"><%= esc(content) %></pre></div>
</body>
</html>
