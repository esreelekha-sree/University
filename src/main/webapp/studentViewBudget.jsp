<%@ page import="java.sql.*" %>
<%@ page import="com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // ------------------ SESSION PROTECTION ------------------
    String stEmail = (String) session.getAttribute("studentEmail");
    String stName  = (String) session.getAttribute("studentName");

    if (stEmail == null) {
        response.sendRedirect("studentLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Student - View Budget Planning</title>
    <style>
        body {font-family: Arial; background: #f4f6f8; margin:0; padding:20px;}
        .wrap {max-width: 900px; margin: auto; background: white;
               padding:20px; border-radius:10px; box-shadow:0 0 10px #ddd;}
        table {width: 100%; border-collapse: collapse; margin-top:20px;}
        th, td {padding: 10px; border:1px solid #ccc; text-align:center;}
        th {background:#007bff; color:white;}
        .back-btn {margin-top:15px; display:inline-block; padding:10px 15px;
                   background:#444; color:white; text-decoration:none; border-radius:5px;}
    </style>
</head>
<body>

<div class="wrap">
    <h2>Budget Transparency Portal</h2>
    <p>Welcome, <strong><%= stName %></strong></p>

    <hr>

    <h3>Budget Planning Summary</h3>

    <table>
        <tr>
            <th>ID</th>
            <th>Department</th>
            <th>Amount (₹)</th>
            <th>Year</th>
            <th>Description</th>
        </tr>

        <%
            try {
                Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM budget ORDER BY budget_id DESC");
                ResultSet rs = ps.executeQuery();

                while(rs.next()) {
        %>

        <tr>
            <td><%= rs.getInt("budget_id") %></td>
            <td><%= rs.getString("department") %></td>
            <td><%= rs.getBigDecimal("budget_amount") %></td>
            <td><%= rs.getInt("year") %></td>
            <td><%= rs.getString("description") %></td>
        </tr>

        <%
                }
                rs.close();
                ps.close();
            } catch(Exception e) {
                out.println("<tr><td colspan='5'>Error loading data</td></tr>");
            }
        %>

    </table>

    <a href="studentPortal.jsp" class="back-btn">⬅ Back to Student Portal</a>

</div>

</body>
</html>
