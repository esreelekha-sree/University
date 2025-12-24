<%@page import="models.Student"%>
<%@page import="models.StudentDAO"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Login</title>
    <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{font-family:Arial;background:linear-gradient(135deg,#6E85B7,#B3C5D7);display:flex;align-items:center;justify-content:center;min-height:100vh;color:#444;}
        .container{background:#fff;padding:30px;border-radius:12px;box-shadow:0 4px 15px rgba(0,0,0,0.1);width:360px;text-align:center;}
        h2{margin-bottom:20px;color:#2c3e50;font-size:24px;font-weight:700;}
        input[type="email"],input[type="password"]{width:100%;padding:10px 12px;margin:8px 0;border:1px solid #ccc;border-radius:6px;}
        button{width:100%;padding:12px;background:linear-gradient(135deg,#3498db,#2c3e50);border:none;border-radius:6px;color:#fff;font-size:18px;font-weight:700;cursor:pointer;margin-top:12px;}
        .error{background:#fdecea;color:#c0392b;padding:10px;border-radius:6px;margin-top:12px;}
        .back-link{display:inline-block;margin-top:12px;text-decoration:none;color:#2c3e50;font-weight:700;}
    </style>
</head>
<body>
<div class="container">
    <h2>Student Login</h2>
    <form action="studentLogin.jsp" method="post">
        <input type="email" name="email" placeholder="Email" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <button type="submit">Login</button>
    </form>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
    %>
        <div class="error">Please enter both email and password.</div>
    <%
            } else if (!email.trim().endsWith("@rguktrkv.ac.in")) {
    %>
        <div class="error">Only institutional email IDs (@rguktrkv.ac.in) are allowed.</div>
    <%
            } else {
                email = email.trim();
                StudentDAO dao = new StudentDAO();
                Student student = null;
                try { student = dao.authenticateStudent(email, password); } catch (Exception ex) { ex.printStackTrace(); }
                if (student != null) {
                    session.setAttribute("studentEmail", student.getEmail());
                    session.setAttribute("studentName", student.getName());
                    session.setAttribute("studentId", student.getId());
                    // <-- IMPORTANT: redirect to studentPortal.jsp so the portal page shows the signed-in menu
                    response.sendRedirect("studentPortal.jsp");
                    return;
                } else {
    %>
        <div class="error">Invalid email or password. Please try again.</div>
    <%
                }
            }
        }
    %>

    <a href="studentPortal.jsp" class="back-link">Back to Home</a>
</div>
</body>
</html>
