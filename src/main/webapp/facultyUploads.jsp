<%@ page import="java.util.*, java.text.*, java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
  // small HTML escape helper
  public String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;").replace("<","&lt;")
            .replace(">","&gt;").replace("\"","&quot;")
            .replace("'","&#x27;");
  }

  public String fmtTimestamp(java.sql.Timestamp t) {
    if (t == null) return "";
    return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(t.getTime()));
  }
%>

<%
  // require faculty session
  String facultyEmail = (String) session.getAttribute("facultyEmail");
  if (facultyEmail == null) {
    response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
    return;
  }

  String ctx = request.getContextPath();

  // messages set by servlet (may be null)
  String error = request.getAttribute("error") instanceof String ? (String) request.getAttribute("error") : "";
  String msg   = request.getAttribute("msg")   instanceof String ? (String) request.getAttribute("msg")   : "";

  // safe retrieval of uploads list (avoid unchecked cast warnings)
  List<Map<String,Object>> uploads = new ArrayList<>();
  Object uploadsObj = request.getAttribute("uploads");
  if (uploadsObj instanceof List<?>) {
      for (Object o : (List<?>) uploadsObj) {
          if (o instanceof Map<?,?>) {
              // safe cast: copy into properly typed Map<String,Object>
              Map<?,?> raw = (Map<?,?>) o;
              Map<String,Object> safeMap = new HashMap<>();
              for (Map.Entry<?,?> e : raw.entrySet()) {
                  Object k = e.getKey();
                  if (k instanceof String) {
                      safeMap.put((String) k, e.getValue());
                  }
              }
              uploads.add(safeMap);
          }
      }
  }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>My Uploads</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <style>
    body { padding: 28px; background: #fff; }
    .note { font-size: .9rem; color: #6c757d; }
    td pre { white-space: pre-wrap; word-wrap: break-word; margin:0; }
  </style>
</head>
<body>
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h1>My Uploads</h1>
      <div>
        Signed in: <strong><%= esc(facultyEmail) %></strong>
        &nbsp;
        <a class="btn btn-sm btn-outline-secondary" href="<%= ctx %>/facultyPortal.jsp">Back</a>
      </div>
    </div>

    <% if (error != null && !error.isEmpty()) { %>
      <div class="alert alert-danger"><%= esc(error) %></div>
    <% } else if (msg != null && !msg.isEmpty()) { %>
      <div class="alert alert-success"><%= esc(msg) %></div>
    <% } %>

    <div class="card mb-4">
      <div class="card-body">
        <form method="post" action="<%= ctx %>/upload" enctype="multipart/form-data">
          <div class="mb-3">
            <label class="form-label">Select file to upload (PDF, DOCX, PPTX, images, zip etc)</label>
            <input class="form-control" type="file" name="file" />
          </div>
          <button class="btn btn-primary" type="submit">Upload</button>
          <span class="ms-3 note">Uploaded files are stored under <code>/uploads</code> inside the webapp (or configured server path).</span>
        </form>
      </div>
    </div>

    <h4>Your recent uploads</h4>
    <div class="card mb-4">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-striped mb-0">
            <thead class="table-light">
              <tr>
                <th>File</th>
                <th>Type</th>
                <th>Size</th>
                <th>Uploaded At</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <% if (uploads.isEmpty()) { %>
                <tr><td colspan="5" class="text-center py-4">No uploads yet.</td></tr>
              <% } else {
                   for (Map<String,Object> u : uploads) {
                     String original = u.get("original_filename") == null ? "" : String.valueOf(u.get("original_filename"));
                     String saved    = u.get("saved_filename")    == null ? "" : String.valueOf(u.get("saved_filename"));
                     String ctype    = u.get("content_type")      == null ? "" : String.valueOf(u.get("content_type"));
                     Object sizeObj  = u.get("size_bytes");
                     Long size = (sizeObj instanceof Number) ? ((Number)sizeObj).longValue() : null;
                     java.sql.Timestamp t = u.get("uploaded_at") instanceof java.sql.Timestamp ? (java.sql.Timestamp) u.get("uploaded_at") : null;
                     Object idObj = u.get("id");
                     String idStr = (idObj == null) ? "" : String.valueOf(idObj);

                     String downloadHref = ctx + "/uploads/";
                     try {
                       if (saved != null && !saved.isEmpty()) {
                         downloadHref += URLEncoder.encode(saved, "UTF-8");
                       } else {
                         downloadHref += URLEncoder.encode(original == null ? "" : original, "UTF-8");
                       }
                     } catch (java.io.UnsupportedEncodingException e) {
                       // UTF-8 always supported; fallback to raw value
                       downloadHref = ctx + "/uploads/" + (saved == null ? original : saved);
                     }
              %>
                <tr>
                  <td style="max-width:320px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><%= esc(original) %></td>
                  <td><%= esc(ctype==null || ctype.isEmpty() ? "-" : ctype) %></td>
                  <td><%= (size==null ? "-" : (size + " bytes")) %></td>
                  <td><%= esc(fmtTimestamp(t)) %></td>
                  <td>
                    <!-- If saved under webapp/uploads, this link will work: /context/uploads/<saved> -->
                    <a class="btn btn-sm btn-outline-primary" href="<%= downloadHref %>" target="_blank" rel="noopener noreferrer">Download</a>

                    <!-- DELETE form (visible only to the uploading faculty) -->
                    <form method="post" action="<%= ctx %>/deleteUpload" style="display:inline" onsubmit="return confirm('Delete this file? This action cannot be undone.');">
                      <input type="hidden" name="id" value="<%= esc(idStr) %>"/>
                      <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                    </form>
                  </td>
                </tr>
              <%   }
                 } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

   <!--<p class="text-muted">Note: If you store files outside the webapp, use a DownloadServlet to stream the file by id.</p>  --> 

    <!-- Developer/test sample file path (exact path you provided earlier) -->
    <!-- <p class="note">Sample uploaded file path (from your environment): -->
     <a href="file:///home/sreelekha/Downloads/apache-tomcat-10.1.49/webapps/University/uploads/test.pdf">/home/sreelekha/Downloads/apache-tomcat-10.1.49/webapps/University/uploads/test.pdf</a>   
    </p>

    <div class="mt-3">
      <a class="btn btn-secondary" href="<%= ctx %>/facultyPortal.jsp">Back to Faculty Portal</a>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
