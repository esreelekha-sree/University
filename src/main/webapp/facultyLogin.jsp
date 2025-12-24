<%@ page import="models.Faculty, models.FacultyDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        try {
            FacultyDAO dao = new FacultyDAO();
            Faculty f = dao.authenticate(email, password);
            if (f != null) {
                session.setAttribute("facultyEmail", f.getEmail());
                session.setAttribute("facultyName", f.getName());
                session.setAttribute("facultyId", f.getId());
                response.sendRedirect(request.getContextPath() + "/facultyPortal.jsp");
                return;
            } else {
                message = "Invalid email or password.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Server error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Faculty Login</title>

<style>
    body {
        margin: 0;
        font-family: Inter, Arial, sans-serif;
        background: #dff0ff;  /* light blue theme */
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .card {
        width: 380px;
        background: #ffffff;
        padding: 32px;
        border-radius: 14px;
        box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        text-align: center;
    }

    h2 {
        margin-bottom: 20px;
        color: #0f172a;
        font-size: 24px;
    }

    input {
        width: 100%;
        padding: 12px;
        border-radius: 8px;
        border: 1px solid #d0d7e2;
        margin-top: 10px;
        font-size: 15px;
        outline: none;
    }

    input:focus {
        border-color: #0d6efd;
    }

    .btn-primary {
        width: 100%;
        padding: 12px;
        background: #0d6efd;
        color: white;
        border: none;
        border-radius: 8px;
        margin-top: 16px;
        cursor: pointer;
        font-weight: 600;
        font-size: 15px;
    }

    .btn-primary:hover {
        background: #0b5ed7;
    }

    .alert {
        background: #ffdede;
        color: #b91c1c;
        padding: 10px;
        border-radius: 8px;
        margin-bottom: 12px;
        font-size: 14px;
    }

    .link {
        margin-top: 14px;
        display: block;
        color: #555;
        text-decoration: none;
        font-size: 14px;
    }

    .signup-link {
        display: block;
        margin-top: 10px;
        color: #0d6efd;
        font-weight: 600;
        text-decoration: none;
    }

    .signup-link:hover {
        text-decoration: underline;
    }
</style>

</head>
<body>

<div class="card">

    <h2>Faculty Login</h2>

    <% if (!message.isEmpty()) { %>
        <div class="alert"><%= message %></div>
    <% } %>

    <form method="post" action="facultyLogin.jsp">

        <input type="email" name="email" placeholder="Email" required>

        <input type="password" name="password" placeholder="Password" required>

        <button class="btn-primary" type="submit">Login</button>

    </form>

    <!-- Signup Option -->
    <a class="signup-link" href="facultySignUp.jsp">New Faculty? Create an Account</a>

    <a class="link" href="main.jsp">Back to Home</a>

</div>

</body>
</html>
