<%-- 
    Document   : viewEvents
    Created on : 27-Oct-2024, 11:39:38 pm
    Author     : rguktrkvalley
--%>

<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String loggedEmail = (String) session.getAttribute("studentEmail");

    if (loggedEmail == null || !loggedEmail.endsWith("@rguktrkv.ac.in")) {
        response.sendRedirect("studentLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Events</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .events-table {
            margin: 0 auto;
            border-collapse: collapse;
            width: 80%;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .events-table th, .events-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .events-table th {
            background-color: #f2f2f2;
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #6E85B7, #B3C5D7);
            color: #333;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }

        h1 {
            font-family: 'Open Sans', sans-serif;
            font-weight: 600;
            font-size: 2rem;
            color: #2c3e50;
            margin-bottom: 20px;
            text-align: center;
        }

        .events-table {
            width: 90%;
            max-width: 1000px;
            border-collapse: collapse;
            background-color: #ffffff;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
            margin-top: 20px;
        }

        .events-table th, .events-table td {
            padding: 15px;
            text-align: left;
            font-size: 0.95rem;
            color: #2c3e50;
        }

        .events-table th {
            background-color: #3498db;
            color: #ffffff;
            font-weight: 500;
        }

        .events-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .events-table tr:hover {
            background-color: #f1f7ff;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .events-table {
                width: 100%;
            }

            .events-table th, .events-table td {
                padding: 10px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <h1>Upcoming Events</h1>
    <table class="events-table">
        <tr>
            <th>Name</th>
            <th>Date</th>
            <th>Time</th>
            <th>Location</th>
            <th>Description</th>
        </tr>
        <%
            String url = "jdbc:mysql://localhost:3306/University";
            String user = "root";
            String password = "dosha@1314";
            Connection connection = null;
            Statement statement = null;
            ResultSet resultSet = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(url, user, password);
                statement = connection.createStatement();
                String query = "SELECT * FROM events";
                resultSet = statement.executeQuery(query);

                while (resultSet.next()) {
                    String name = resultSet.getString("name");
                    String date = resultSet.getString("date");
                    String time = resultSet.getString("time");
                    String location = resultSet.getString("location");
                    String description = resultSet.getString("description");
        %>
        <tr>
            <td><%= name %></td>
            <td><%= date %></td>
            <td><%= time %></td>
            <td><%= location %></td>
            <td><%= description %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </table>
    <a href="studentPortal.jsp">Back to Home</a>
</body>
</html>


