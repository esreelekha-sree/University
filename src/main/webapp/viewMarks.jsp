<%@page import="java.util.List"%>
<%@ page import="models.MarksDAO, models.Marks" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String loggedEmail = (String) session.getAttribute("studentEmail");

    if (loggedEmail == null || !loggedEmail.endsWith("@rguktrkv.ac.in")) {
        response.sendRedirect("studentLogin.jsp");
        return;
    }
%>
<!--<!DOCTYPE html>
<html>
<head>
    <title>View Marks</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h2>View Marks</h2>
    
    <form method="post" action="">
        Enter Student ID: <input type="text" name="studentId" required>
        <input type="submit" value="View Marks">
    </form>

    <%
        if ("post".equalsIgnoreCase(request.getMethod())) {
            int studentId = Integer.parseInt(request.getParameter("studentId"));

            MarksDAO marksDAO = new MarksDAO();
            List<Marks> marksList = marksDAO.getMarksByStudentId(studentId);

            if (!marksList.isEmpty()) {
    %>
                <table border="1">
                    <tr>
                        <th>Course Name</th>
                        <th>Mark</th>
                    </tr>
                    <%
                        for (Marks mark : marksList) {
                    %>
                        <tr>
                            <td><%= mark.getCourseName() %></td>
                            <td><%= mark.getMark() %></td>
                        </tr>
                    <%
                        }
                    %>
                </table>
    <%
            } else {
                out.println("<p>No marks found for the given Student ID.</p>");
            }
        }
    %>
</body>
</html>
-->





<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Marks</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@500;700&display=swap" rel="stylesheet">
    <style>
        /* Reset and General Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Open Sans', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #6E85B7, #B3C5D7);
            color: #2d3436;
        }

        .container {
            background: #fff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            width: 90%;
        }

        h2 {
            font-family: 'Raleway', sans-serif;
            font-size: 2rem;
            color: #4b6584;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        form {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.8rem;
            margin-bottom: 1.5rem;
            font-weight: 600;
            color: #333;
        }

        form input[type="text"] {
            padding: 0.8rem;
            border: 1px solid #dcdde1;
            border-radius: 8px;
            width: 60%;
            font-size: 1rem;
        }

        form input[type="submit"] {
            padding: 0.8rem 1.4rem;
            background-color: #4b7bec;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-family: 'Raleway', sans-serif;
            font-weight: 700;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        form input[type="submit"]:hover {
            background-color: #3867d6;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        table, th, td {
            border: 1px solid #dcdde1;
        }

        th, td {
            padding: 1rem;
            text-align: center;
        }

        th {
            background-color: #4b7bec;
            color: #fff;
            font-family: 'Raleway', sans-serif;
        }

        td {
            font-family: 'Open Sans', sans-serif;
            color: #2d3436;
            background-color: #f7f7f7;
        }

        .no-data {
            text-align: center;
            font-size: 1.2rem;
            color: #e17055;
            margin-top: 1.5rem;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>View Marks</h2>
    
    <form method="post" action="">
        <label for="studentId">Enter Student ID:</label>
        <input type="text" name="studentId" id="studentId" required>
        <input type="submit" value="View Marks">
    </form>

    <%
        if ("post".equalsIgnoreCase(request.getMethod())) {
            int studentId = Integer.parseInt(request.getParameter("studentId"));

            MarksDAO marksDAO = new MarksDAO();
            List<Marks> marksList = marksDAO.getMarksByStudentId(studentId);

            if (!marksList.isEmpty()) {
    %>
                <table>
                    <tr>
                        <th>Course Name</th>
                        <th>Mark</th>
                    </tr>
                    <%
                        for (Marks mark : marksList) {
                    %>
                        <tr>
                            <td><%= mark.getCourseName() %></td>
                            <td><%= mark.getMark() %></td>
                        </tr>
                    <%
                        }
                    %>
                </table>
    <%
            } else {
    %>
                <p class="no-data">No marks found for the given Student ID.</p>
    <%
            }
        }
    %>
<a href="studentPortal.jsp" class="back-link">Back to studentPortal</a>
</div>

</body>
</html>