<%@ page import="models.StudentDAO" %>
<%@ page import="models.Student" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Login</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <h2>Student Login</h2>
    <form action="login.jsp" method="post">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br><br>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>

        <input type="submit" value="Login">
    </form>

    <%
    if (request.getMethod().equalsIgnoreCase("post")) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        StudentDAO dao = new StudentDAO();
        Student student = null;
        try {
            student = dao.authenticateStudent(email, password);
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>Database unavailable right now.</p>");
        }

        if (student != null) {
            session.setAttribute("user", student); 
            out.println("<p>Welcome, " + student.getName() + "!</p>");
        } else {
            out.println("<p style='color:red;'>Invalid email or password.</p>");
        }
    }
   %>

</body>
</html>
