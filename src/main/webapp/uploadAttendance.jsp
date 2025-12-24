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
    <title>Upload Attendance</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Upload Attendance</h1>
        <form action="uploadAttendance.jsp" method="post">
            <label for="studentId">Student ID:</label>
            <input type="number" id="studentId" name="studentId" required>
            <br>
            <label for="courseName">Course Name:</label>
            <input type="text" id="courseName" name="courseName" required>
            <br>
            <label for="attendanceDate">Attendance Date:</label>
            <input type="date" id="attendanceDate" name="attendanceDate" required>
            <br>
            <label for="status">Status:</label>
            <select id="status" name="status" required>
                <option value="Present">Present</option>
                <option value="Absent">Absent</option>
            </select>
            <br>
            <input type="submit" value="Upload">
            <br><br><br>
            <a href="facultyPortal.jsp">back to facultyPortal</a>
        </form>
    </div>

    <%
        String url = "jdbc:mysql://localhost:3306/University";
        String user = "root";
        String password = "dosha@1314";

        if (request.getMethod().equalsIgnoreCase("POST")) {
            String studentId = request.getParameter("studentId");
            String courseName = request.getParameter("courseName");
            String attendanceDate = request.getParameter("attendanceDate");
            String status = request.getParameter("status");

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, user, password);
                String sql = "INSERT INTO attendance (studentId, courseName, attendanceDate, status) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(studentId));
                pstmt.setString(2, courseName);
                pstmt.setDate(3, java.sql.Date.valueOf(attendanceDate));
                pstmt.setString(4, status);
                pstmt.executeUpdate();
                out.println("<p>Attendance uploaded successfully!</p>");
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
