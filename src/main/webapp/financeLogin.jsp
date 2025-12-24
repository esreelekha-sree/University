<%@ page import="models.FinanceDAO" %>
<%@ page import="models.FinanceOfficer" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Finance Officer Login</title>

<style>
    body{
        margin:0;
        background:#dceeff;
        font-family:Inter,Arial;
        height:100vh;
        display:flex;
        justify-content:center;
        align-items:center;
    }
    .box{
        width:380px;
        padding:30px;
        background:white;
        border-radius:14px;
        box-shadow:0 12px 34px rgba(0,0,0,0.08);
        text-align:center;
    }
    input{
        width:100%;
        padding:12px;
        margin-top:10px;
        border:1px solid #d0d7e2;
        border-radius:8px;
    }
    button{
        width:100%;
        padding:12px;
        margin-top:16px;
        background:#0d6efd;
        border:none;
        color:white;
        border-radius:8px;
        font-weight:600;
    }
    .error{
        margin-top:12px;
        background:#ffd7d7;
        padding:10px;
        color:#b00020;
        border-radius:8px;
    }
    a{ display:block; margin-top:14px; color:#475569; text-decoration:none; }
</style>

</head>
<body>
<div class="box">
    <h2>Finance Officer Login</h2>

    <form method="post" action="financeLogin.jsp">
        <input type="email" name="email" placeholder="Email" required />
        <input type="password" name="password" placeholder="Password" required />
        <button>Login</button>
    </form>

<%
    String error=null;
    if("POST".equalsIgnoreCase(request.getMethod())){
        String email=request.getParameter("email");
        String pass=request.getParameter("password");

        if(email!=null) email=email.trim().toLowerCase();

        if(!email.endsWith("@rguktrkv.ac.in")){
            error="Please use institutional email (@rguktrkv.ac.in).";
        } else {
            try{
                FinanceDAO dao=new FinanceDAO();
                FinanceOfficer f=dao.authenticate(email,pass);

                if(f!=null){
                    session.setAttribute("financeEmail",f.getEmail());
                    session.setAttribute("financeName",f.getName());
                    session.setAttribute("financeId",f.getId());
                    session.setMaxInactiveInterval(30*60);
                    response.sendRedirect("financePortal.jsp");
                    return;
                } else error="Invalid email or password.";

            } catch(Exception e){
                error="Server error.";
            }
        }
    }

    if(error!=null){
%>
    <div class="error"><%= error %></div>
<% } %>

    <a href="main.jsp">Back to Home</a>
</div>
</body>
</html>
