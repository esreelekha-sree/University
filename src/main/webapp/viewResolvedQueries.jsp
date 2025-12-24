<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.university.utils.DatabaseConnection" %>
<%
    String loggedEmail = (String) session.getAttribute("studentEmail");

    if (loggedEmail == null || !loggedEmail.endsWith("@rguktrkv.ac.in")) {
        response.sendRedirect("studentLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Resolved Queries</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&family=Montserrat:wght@600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            margin: 0;
            padding: 0;
            display: flex;
            min-height: 100vh;
            justify-content: center;
            align-items: center;
        }

        .container {
            width: 90%;
            max-width: 1000px;
            background-color: #ffffff;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        h2 {
            font-family: 'Montserrat', sans-serif;
            text-align: center;
            margin-bottom: 20px;
            color: #333333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            padding: 10px 12px;
            border-bottom: 1px solid #ddd;
            text-align: left;
            vertical-align: top;
        }

        th {
            background-color: #f5f5f5;
            font-weight: 600;
        }

        tr:hover {
            background-color: #f9f9f9;
        }

        .no-data {
            text-align: center;
            padding: 15px;
            font-style: italic;
            color: #555;
        }

        .back-link {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            color: #fff;
            background-color: #667eea;
            padding: 8px 16px;
            border-radius: 5px;
            font-weight: 500;
        }

        .back-link:hover {
            background-color: #4b5bd7;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Resolved Queries</h2>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Student Name</th>
            <th>Query</th>
            <th>Resolution</th>
        </tr>
        </thead>
        <tbody>
        <%
            boolean hasRows = false;
            try (Connection connection = DatabaseConnection.getConnection()) {
                String sql = "SELECT id, studentName, queryText, resolution FROM queries WHERE resolution IS NOT NULL";
                try (PreparedStatement ps = connection.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        hasRows = true;
                        int id = rs.getInt("id");
                        String studentName = rs.getString("studentName");
                        String queryText = rs.getString("queryText");
                        String resolution = rs.getString("resolution");
        %>
                        <tr>
                            <td><%= id %></td>
                            <td><%= studentName %></td>
                            <td><%= queryText %></td>
                            <td><%= resolution %></td>
                        </tr>
        <%
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (!hasRows) {
        %>
            <tr>
                <td colspan="4" class="no-data">
                    No queries have been resolved yet. Please check again later.
                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <a href="studentPortal.jsp" class="back-link">Back to Student Portal</a>
</div>
</body>
</html>
