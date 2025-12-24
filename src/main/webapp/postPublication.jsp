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
  String err = "", msg = "";

  // form fields
  String id = request.getParameter("id"); // used for edit
  String title = request.getParameter("title");
  String content = request.getParameter("content");
  String author = request.getParameter("author");
  String formTitle = "";
  String formContent = "";
  String formAuthor = "";

  // If GET with id => load existing
  if ("GET".equalsIgnoreCase(request.getMethod()) && id != null && !id.trim().isEmpty()) {
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT id, title, content, author, faculty_email FROM publications WHERE id = ?")) {
      ps.setInt(1, Integer.parseInt(id));
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          String pubFacultyEmail = rs.getString("faculty_email");
          if (pubFacultyEmail == null || !pubFacultyEmail.equals(facultyEmail)) {
            err = "You are not authorized to edit this publication.";
            id = null;
          } else {
            formTitle = rs.getString("title");
            formContent = rs.getString("content");
            formAuthor = rs.getString("author");
          }
        } else {
          err = "Publication not found.";
          id = null;
        }
      }
    } catch (Exception ex) {
      ex.printStackTrace();
      err = "Server error while loading publication: " + esc(ex.getMessage());
    }
  } else {
    // prefill with POST values on failure / first-run
    formTitle = title == null ? formTitle : title;
    formContent = content == null ? formContent : content;
    formAuthor = author == null ? formAuthor : author;
  }

  // Handle POST: create or update
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    title = request.getParameter("title");
    content = request.getParameter("content");
    author = request.getParameter("author");
    String idPost = request.getParameter("id");

    if (title == null || title.trim().isEmpty()) {
      err = "Title is required.";
    } else if (content == null || content.trim().isEmpty()) {
      err = "Content is required.";
    } else {
      try (Connection conn = DatabaseConnection.getConnection()) {
        if (idPost != null && !idPost.trim().isEmpty()) {
          String upd = "UPDATE publications SET title = ?, content = ?, author = ?, faculty_email = ? WHERE id = ? AND faculty_email = ?";
          try (PreparedStatement ps = conn.prepareStatement(upd)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setString(3, author == null ? "" : author);
            ps.setString(4, facultyEmail);
            ps.setInt(5, Integer.parseInt(idPost));
            ps.setString(6, facultyEmail);
            int r = ps.executeUpdate();
            if (r > 0) {
              msg = "Publication updated.";
              response.sendRedirect(ctx + "/facultyViewPublications.jsp?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));
              return;
            } else {
              err = "Update failed or you are not authorized to edit this publication.";
            }
          }
        } else {
          String ins = "INSERT INTO publications (title, content, author, faculty_email) VALUES (?, ?, ?, ?)";
          try (PreparedStatement ps = conn.prepareStatement(ins)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setString(3, author == null ? "" : author);
            ps.setString(4, facultyEmail);
            ps.executeUpdate();
            msg = "Publication created.";
            response.sendRedirect(ctx + "/facultyViewPublications.jsp?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));
            return;
          }
        }
      } catch (Exception ex) {
        ex.printStackTrace();
        err = "Server error while saving: " + esc(ex.getMessage());
      }
    }
    formTitle = title;
    formContent = content;
    formAuthor = author;
    id = request.getParameter("id");
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title><%= (id!=null && !id.isEmpty()) ? "Edit Publication" : "New Publication" %></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style> body { padding:20px; } </style>
</head>
<body class="container">
  <h2><%= (id!=null && !id.isEmpty()) ? "Edit Publication" : "Post New Publication" %></h2>

  <% if (!err.isEmpty()) { %>
    <div class="alert alert-danger"><%= esc(err) %></div>
  <% } %>
  <% if (!msg.isEmpty()) { %>
    <div class="alert alert-success"><%= esc(msg) %></div>
  <% } %>

  <form method="post" action="<%= request.getRequestURI() %>">
    <% if (id != null && !id.isEmpty()) { %>
      <input type="hidden" name="id" value="<%= esc(id) %>"/>
    <% } %>

    <div class="mb-3">
      <label class="form-label">Title</label>
      <input name="title" class="form-control" value="<%= esc(formTitle) %>" required />
    </div>

    <div class="mb-3">
      <label class="form-label">Content</label>
      <textarea name="content" rows="10" class="form-control" required><%= esc(formContent) %></textarea>
    </div>

    <div class="mb-3">
      <label class="form-label">Author (display name)</label>
      <input name="author" class="form-control" value="<%= esc(formAuthor) %>" />
    </div>

    <button class="btn btn-primary" type="submit"><%= (id!=null && !id.isEmpty()) ? "Update" : "Publish" %></button>
    &nbsp;
    <a class="btn btn-secondary" href="<%= ctx %>/facultyViewPublications.jsp">Cancel</a>
  </form>
</body>
</html>
