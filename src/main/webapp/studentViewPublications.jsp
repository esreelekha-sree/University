<%@ page import="java.sql.*, java.util.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String studentEmail = (String) session.getAttribute("studentEmail");
  if (studentEmail == null) {
    response.sendRedirect(request.getContextPath() + "/studentLogin.jsp");
    return;
  }

  List<Map<String,Object>> pubs = new ArrayList<>();
  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement("SELECT id, title, abstract_text, author_name, author_email, created_at FROM publications ORDER BY created_at DESC");
       ResultSet rs = ps.executeQuery()) {
    while (rs.next()) {
      Map<String,Object> m = new HashMap<>();
      m.put("id", rs.getInt("id"));
      m.put("title", rs.getString("title"));
      m.put("abstract", rs.getString("abstract_text"));
      m.put("author", rs.getString("author_name"));
      m.put("authorEmail", rs.getString("author_email"));
      m.put("createdAt", rs.getTimestamp("created_at"));
      pubs.add(m);
    }
  } catch (Exception ex) { ex.printStackTrace(); }
%>
<!doctype html>
<html>
<head><meta charset="utf-8"/><title>Publications</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Publications</h2>
    <a class="btn btn-secondary" href="<%= request.getContextPath() %>/studentPortal.jsp">Back</a>
  </div>

  <% for (Map<String,Object> p : pubs) { %>
    <div class="card mb-3">
      <div class="card-body">
        <h5 class="card-title"><%= p.get("title") %></h5>
        <p class="card-text"><%= p.get("abstract") %></p>
        <p class="text-muted small">By <%= p.get("author") %> &lt;<%= p.get("authorEmail") %>&gt; on <%= p.get("createdAt") %></p>
      </div>
    </div>
  <% } %>
</div>
</body>
</html>
