<%@ page import="java.io.File" %>
<%@ page import="java.util.Arrays" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // optional: protect the gallery so only logged-in finance sees it
    String fEmail = (String) session.getAttribute("financeEmail");
    if (fEmail == null) {
        response.sendRedirect("financeLogin.jsp");
        return;
    }

    String imagesReal = application.getRealPath("/Images");
    File imagesDir = new File(imagesReal == null ? (new File(".")).getAbsolutePath() + File.separator + "Images" : imagesReal);
    File[] files = imagesDir.exists() ? imagesDir.listFiles() : new File[0];
    if (files == null) files = new File[0];

    // sort by lastModified desc
    Arrays.sort(files, (a,b) -> Long.compare(b.lastModified(), a.lastModified()));
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Gallery</title>
  <style>
    body{font-family:Arial,Helvetica,sans-serif;background:#f4f7fb;padding:30px}
    .wrap{max-width:1100px;margin:0 auto}
    .topbar{display:flex;justify-content:space-between;align-items:center;margin-bottom:18px}
    .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px}
    .card{background:#fff;padding:8px;border-radius:8px;box-shadow:0 6px 18px rgba(0,0,0,0.06);text-align:center}
    .card img{max-width:100%;height:160px;object-fit:cover;border-radius:6px}
    .card small{display:block;margin-top:8px;color:#666}
    .actions a{display:inline-block;margin-left:8px}
    .btn{padding:8px 12px;border-radius:6px;background:#007bff;color:#fff;text-decoration:none}
    .danger{background:#dc3545}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="topbar">
      <h2>Image Gallery</h2>
      <div class="actions">
        <a class="btn" href="uploadImage.jsp">Upload Image</a>
        <a class="btn" href="financePortal.jsp">Back to Portal</a>
      </div>
    </div>

    <div class="grid">
      <%
        if (files.length == 0) {
      %>
        <div style="grid-column:1/-1;background:#fff;padding:20px;border-radius:8px;box-shadow:0 6px 18px rgba(0,0,0,0.04)">No images found. Use <a href="uploadImage.jsp">Upload Image</a> to add some.</div>
      <%
        } else {
            for (File f : files) {
                if (!f.isFile()) continue;
                String name = f.getName();
                String lname = name.toLowerCase();
                if (!(lname.endsWith(".png")||lname.endsWith(".jpg")||lname.endsWith(".jpeg")||lname.endsWith(".gif")||lname.endsWith(".webp")))
                    continue;
      %>
        <div class="card">
          <a href="<%=request.getContextPath()%>/Images/<%=name%>" target="_blank">
            <img src="<%=request.getContextPath()%>/Images/<%=name%>" alt="<%=name%>">
          </a>
          <small><%= name %></small>
        </div>
      <%
            }
        }
      %>
    </div>
  </div>
</body>
</html>
