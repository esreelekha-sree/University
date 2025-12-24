<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Query" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.university.utils.DatabaseConnection" %>
<%
    String facEmail = (String) session.getAttribute("facultyEmail");
    if (facEmail == null || !facEmail.endsWith("@rguktrkv.ac.in")) {
        response.sendRedirect("facultyLogin.jsp");
        return;
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Queries</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Montserrat:wght@700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        /* Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #6E85B7, #B3C5D7);
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            width: 90%;
            max-width: 800px;
            background: #fff;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0px 10px 15px rgba(0, 0, 0, 0.1);
        }

        h2 {
            font-family: 'Montserrat', sans-serif;
            font-size: 2rem;
            color: #333;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
            font-size: 0.95rem;
        }

        thead th {
            background-color: #007BFF;
            color: white;
            font-weight: 500;
            padding: 12px;
            text-align: left;
        }

        tbody td {
            padding: 12px;
            color: #555;
            border-bottom: 1px solid #ddd;
        }

        tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .resolve-btn {
            display: inline-flex;
            align-items: center;
            background-color: #28a745;
            color: white;
            padding: 8px 12px;
            border-radius: 5px;
            text-decoration: none;
            transition: background-color 0.3s ease;
            font-weight: 500;
        }

        .resolve-btn:hover {
            background-color: #218838;
        }

        .resolve-btn i {
            margin-right: 5px;
        }

        /* Responsive Table */
        @media (max-width: 600px) {
            table {
                font-size: 0.9rem;
            }
            h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>View Queries</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Student Name</th>
                    <th>Query</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection connection = DatabaseConnection.getConnection()) {
                        String sql = "SELECT * FROM queries WHERE resolution IS NULL";
                        Statement statement = connection.createStatement();
                        ResultSet resultSet = statement.executeQuery(sql);
                        while (resultSet.next()) {
                            int id = resultSet.getInt("id");
                            String studentName = resultSet.getString("studentName");
                            String queryText = resultSet.getString("queryText");
                %>
                            <tr>
                                <td><%= id %></td>
                                <td><%= studentName %></td>
                                <td><%= queryText %></td>
                                <!-- CHANGED: open the JSP form page and pass numeric id -->
                                <td>
                                    <a class="resolve-btn" href="resolveQuery.jsp?id=<%= id %>">
                                        <i class="fas fa-check-circle"></i> Resolve
                                    </a>
                                </td>
                            </tr>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
    <a href="facultyPortal.jsp" class="back-link"><br>Back to facultyPortal</a>
    </div>
</body>
</html>
