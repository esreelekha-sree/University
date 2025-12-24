<%@ page import="models.AdminDAO, models.Admin" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  String adminEmail = (String) session.getAttribute("adminEmail");
  if (adminEmail != null) {
      response.sendRedirect(request.getContextPath() + "/adminPortal.jsp");
      return;
  }

  String message = "";
  if ("POST".equalsIgnoreCase(request.getMethod())) {
      String email = request.getParameter("email");
      String pass  = request.getParameter("password");

      try {
          AdminDAO dao = new AdminDAO();
          Admin admin = dao.authenticate(email, pass);

          if (admin != null) {
              session.setAttribute("adminEmail", admin.getEmail());
              response.sendRedirect("adminPortal.jsp");
              return;
          } else {
              message = "Invalid email or password.";
          }
      } catch (Exception e) {
          message = "Server error.";
      }
  }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Login</title>

<style>
    body{
        margin:0;
        background:#dceeff;
        font-family:Inter, Arial;
        height:100vh;
        display:flex;
        justify-content:center;
        align-items:center;
    }
    .card{
        width:380px;
        background:white;
        padding:28px;
        border-radius:14px;
        box-shadow:0 10px 30px rgba(0,0,0,0.08);
        text-align:center;
    }
    h2{ margin:0 0 16px 0; }
    input{
        width:100%;
        padding:12px;
        margin-top:10px;
        border-radius:8px;
        border:1px solid #d0d7e2;
    }
    button{
        margin-top:16px;
        width:100%;
        padding:12px;
        background:#0d6efd;
        border:none;
        color:white;
        border-radius:8px;
        font-weight:600;
        cursor:pointer;
    }
    .error{
        margin-top:10px;
        background:#ffd7d7;
        padding:10px;
        border-radius:8px;
        color:#b00020;
    }
    a{ display:block; margin-top:14px; text-decoration:none; color:#475569; }
</style>

</head>
<body>

<div class="card">
    <h2>Admin Login</h2>

    <% if(!message.isEmpty()){ %>
        <div class="error"><%= message %></div>
    <% } %>

    <form method="post" action="adminLogin.jsp">
        <input type="email" name="email" placeholder="Email" required/>
        <input type="password" name="password" placeholder="Password" required/>
        <button>Login</button>
    </form>

    <a href="main.jsp">Back to Home</a>
</div>

</body>
</html>
