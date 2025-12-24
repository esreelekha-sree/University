<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // require finance login (simple protection)
    String fEmail = (String) session.getAttribute("financeEmail");
    if (fEmail == null) {
        response.sendRedirect("financeLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Upload Image</title>
  <style>
    body{font-family:Arial,Helvetica,sans-serif;background:#eef2f7;padding:30px}
    .card{max-width:700px;margin:40px auto;background:#fff;padding:24px;border-radius:8px;box-shadow:0 6px 20px rgba(0,0,0,0.06)}
    input[type=file]{display:block;margin:12px 0}
    button{background:#007bff;color:#fff;padding:10px 14px;border:none;border-radius:6px;cursor:pointer}
    .message{padding:10px;background:#e9f7ef;color:#155724;border-radius:6px;margin-bottom:12px}
    .error{padding:10px;background:#fdecea;color:#c0392b;border-radius:6px;margin-bottom:12px}
    a.back{display:inline-block;margin-top:12px}
  </style>
</head>
<body>
  <div class="card">
    <h2>Upload Image to Gallery</h2>
    <p>Allowed: png, jpg, jpeg, gif, webp — max size 8 MB</p>

    <!-- show message from servlet (uploadMsg + uploadOK) -->
    <%
        String msg = (String) request.getAttribute("uploadMsg");
        String ok  = (String) request.getAttribute("uploadOK");
        if (msg != null) {
            if ("true".equalsIgnoreCase(ok)) {
    %>
        <div class="message"><%= msg %></div>
    <%
            } else {
    %>
        <div class="error"><%= msg %></div>
    <%
            }
        }
    %>

    <form method="post" action="<%=request.getContextPath()%>/ImageUpload" enctype="multipart/form-data">
      <label>Select image file</label>
      <input type="file" name="imageFile" accept="image/*" required>
      <button type="submit">Upload</button>
    </form>

    <a class="back" href="viewGallery.jsp">Back to Gallery</a>
    <br><br>
    <a class="back" href="financePortal.jsp">Back to Finance Portal</a>
  </div>
</body>
</html>
