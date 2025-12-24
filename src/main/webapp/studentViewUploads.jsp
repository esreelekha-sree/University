<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  public String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#x27;");
  }

  public String fmtTimestamp(java.sql.Timestamp t) {
    if (t == null) return "";
    return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(t.getTime()));
  }
%>

<%
  // require login (optional: if you want only logged-in students)
  String studentEmail = (String) session.getAttribute("studentEmail");
  if (studentEmail == null) {
    // redirect to login if you want students to sign in
    response.sendRedirect(request.getContextPath() + "/studentLogin.jsp");
    return;
  }

  String ctx = request.getContextPath();
  String error = "";
  List<Map<String,Object>> uploads = new ArrayList<>();

  try (Connection conn = com.university.utils.DatabaseConnection.getConnection()) {
    // select columns exactly as they exist in DB (original_filename, saved_filename)
    String sql = "SELECT id, original_filename, saved_filename, content_type, size_bytes, faculty_email, uploaded_at " +
                 "FROM uploads ORDER BY uploaded_at DESC";
    try (PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        Map<String,Object> m = new HashMap<>();
        m.put("id", rs.getInt("id"));
        m.put("original_filename", rs.getString("original_filename"));
        m.put("saved_filename", rs.getString("saved_filename"));
        m.put("content_type", rs.getString("content_type"));
        m.put("size_bytes", rs.getLong("size_bytes"));
        m.put("faculty_email", rs.getString("faculty_email"));
        m.put("uploaded_at", rs.getTimestamp("uploaded_at"));
        uploads.add(m);
      }
    }
  } catch (Exception ex) {
    ex.printStackTrace();
    error = "Error loading notes: " + esc(ex.getMessage());
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Study Materials / Uploaded Notes</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style> body { padding:24px;} </style>
</head>
<body>
  <div class="container">
    <h1 class="mb-4">Study Materials / Uploaded Notes</h1>
    <a class="btn btn-secondary mb-3" href="<%= ctx %>/studentPortal.jsp">Back to Portal</a>

    <% if (!error.isEmpty()) { %>
      <div class="alert alert-danger"><%= esc(error) %></div>
    <% } %>

    <div class="card mb-4">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-striped mb-0">
            <thead class="table-light">
              <tr>
                <th>File</th>
                <th>Size</th>
                <th>Uploaded At</th>
                <th>Uploaded By</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <% if (uploads.isEmpty()) { %>
                <tr><td colspan="5" class="text-center py-4">No notes uploaded yet.</td></tr>
              <% } else {
                   for (Map<String,Object> u : uploads) {
                     Object idObj = u.get("id");
                     String idStr = (idObj == null) ? "" : String.valueOf(idObj);
                     String original = (String) u.get("original_filename");
                     String saved = (String) u.get("saved_filename");
                     Long size = (u.get("size_bytes") instanceof Number) ? ((Number)u.get("size_bytes")).longValue() : null;
                     java.sql.Timestamp t = (java.sql.Timestamp) u.get("uploaded_at");
                     String by = (String) u.get("faculty_email");

                     // build safe download url using saved filename
                     String downloadUrl = ctx + "/download?filename=";
                     try {
                       if (saved != null) {
                         downloadUrl += URLEncoder.encode(saved, "UTF-8");
                       } else {
                         downloadUrl += URLEncoder.encode(original == null ? "" : original, "UTF-8");
                       }
                     } catch (java.io.UnsupportedEncodingException uee) {
                       // fallback (shouldn't happen for UTF-8)
                       downloadUrl += (saved == null ? original : saved);
                     }
              %>
                <tr>
                  <td style="max-width:420px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><%= esc(original) %></td>
                  <td><%= (size == null ? "-" : (size + " bytes")) %></td>
                  <td><%= esc(fmtTimestamp(t)) %></td>
                  <td><%= esc(by) %></td>
                  <td>
                    <a class="btn btn-sm btn-primary" href="<%= downloadUrl %>">Download</a>
                  </td>
                </tr>
              <%   }
                 } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <p class="text-muted">If downloads fail, ensure files are stored under <code>/uploads</code> inside the webapp or update the DownloadServlet path to your storage location.</p>

  </div>
</body>
</html>
