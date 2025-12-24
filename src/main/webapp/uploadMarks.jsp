
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String facEmail = (String) session.getAttribute("facultyEmail");
    if (facEmail == null || !facEmail.endsWith("@rguktrkv.ac.in")) {
        response.sendRedirect("facultyLogin.jsp");
        return;
    }
%>
<html>
<head>
    <title>Upload Marks</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        /* Basic Styles */
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #6E85B7, #B3C5D7);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        .container {
            width: 90%;
            max-width: 500px;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: #333;
            margin-bottom: 20px;
        }

        label {
            display: block;
            text-align: left;
            font-weight: 500;
            color: #555;
            margin: 15px 0 5px;
        }

        input[type="number"], input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #dcdcdc;
            border-radius: 5px;
            font-size: 1rem;
            color: #333;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px;
            font-size: 1rem;
            font-weight: 500;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 15px;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .message {
            font-size: 1rem;
            padding: 10px;
            margin-top: 15px;
            border-radius: 5px;
            font-weight: 500;
        }

        .message.success {
            color: #155724;
            background-color: #d4edda;
        }

        .message.error {
            color: #721c24;
            background-color: #f8d7da;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Upload Marks</h1>
        <form action="uploadMarks.jsp" method="post">
            <label for="studentId">Student ID:</label>
            <input type="number" id="studentId" name="studentId" required>
            <br>
            <label for="courseName">Course Name:</label>
            <input type="text" id="courseName" name="courseName" required>
            <br>
            <label for="mark">Mark:</label>
            <input type="number" id="mark" name="mark" required>
            <br>
            <input type="submit" value="Upload">
             <a href="facultyPortal.jsp" class="back-link"><br>Back to facultyPortal</a>
        </form>
    </div>

    <%
        String url = "jdbc:mysql://localhost:3306/University";
        String user = "root";
        String password = "dosha@1314";

        if (request.getMethod().equalsIgnoreCase("POST")) {
            String studentId = request.getParameter("studentId");
            String courseName = request.getParameter("courseName");
            String mark = request.getParameter("mark");

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, user, password);
                String sql = "INSERT INTO marks (studentId, courseName, mark) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(studentId));
                pstmt.setString(2, courseName);
                pstmt.setInt(3, Integer.parseInt(mark));
                pstmt.executeUpdate();
                out.println("<p>Marks uploaded successfully!</p>");
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    %>
</body>
</html>



