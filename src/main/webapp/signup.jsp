<%@ page import="models.StudentDAO" %>
<%@ page import="models.Student" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Sign Up</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <h2>Student Sign Up</h2>
    <form action="signup.jsp" method="post">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required><br><br>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br><br>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>

        <label for="department">Department:</label>
        <input type="text" id="department" name="department"><br><br>

        <input type="submit" value="Sign Up">
    </form>

    <%
        if (request.getMethod().equalsIgnoreCase("post")) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String department = request.getParameter("department");

            // Create student object and save to database
            Student student = new Student(name, email, password, department);
            StudentDAO dao = new StudentDAO();

            if (dao.addStudent(student)) {
                out.println("<p>Registration successful!</p>");
            } else {
                out.println("<p>Registration failed. Please try again.</p>");
            }
        }
    %>
</body>
</html>
