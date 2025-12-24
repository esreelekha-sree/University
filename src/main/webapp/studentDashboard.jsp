<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Session protection
    String studentName = (String) session.getAttribute("studentName");
    String studentEmail = (String) session.getAttribute("studentEmail");

    if (studentEmail == null) {
        response.sendRedirect("studentLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            margin: 0;
            padding: 24px;
        }
        .card {
            max-width: 900px;
            margin: auto;
            background: #fff;
            padding: 24px;
            border-radius: 10px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        h1 {
            margin-top: 0;
        }
        .links {
            list-style: none;
            padding: 0;
            margin-top: 20px;
        }
        .links li {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        .links li a {
            text-decoration: none;
            font-size: 18px;
            font-weight: 600;
            color: #007bff;
        }
        .links li a:hover {
            color: #0056b3;
        }
        .logout-btn {
            background: #dc3545;
            padding: 8px 12px;
            color: white;
            border-radius: 6px;
            text-decoration: none;
            float: right;
        }
    </style>
</head>

<body>

<div class="card">

    <a class="logout-btn" href="studentLogout.jsp">Logout</a>

    <h1>Welcome, <%= (studentName != null ? studentName : studentEmail) %>!</h1>
    <p>Select any option below:</p>

    <ul class="links">
        <li><a href="studentCourses.jsp">My Registered Courses</a></li>
        <li><a href="registerForCourse.jsp">Register for Course</a></li>

        <!-- ⭐ New Feature: Students can see approved budget -->
        <li><a href="studentViewBudget.jsp">View University Budget</a></li>
         
        <li><a href="viewMarks.jsp">View Marks</a></li>
        <li><a href="askQuery.jsp">Ask a Query</a></li>
        <li><a href="viewPublication.jsp">View Publications</a></li>
        <li><a href="viewAttendance.jsp">View Attendance</a></li>
    </ul>

</div>

</body>
</html>
