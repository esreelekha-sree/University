<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String a = (String) session.getAttribute("adminEmail");
    if (a == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Remove Student</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f9f9f9; }
        h1 { text-align: center; color: #333; }
        form { max-width: 500px; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 5px; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1); }
        input[type="text"] { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 4px; }
        button { padding: 10px 20px; background-color: #e74c3c; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background-color: #c0392b; }
        .message, .error { text-align: center; font-weight: bold; }
        .message { color: #4CAF50; }
        .error { color: #FF0000; }
         body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #6E85B7, #B3C5D7);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            color: #333;
        }

        .container {
            max-width: 450px;
            width: 100%;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            text-align: center;
        }

        h1 {
            font-family: 'Lobster', cursive;
            font-size: 2rem;
            color: #4E6C94;
            margin-bottom: 20px;
            align-content: center;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            font-weight: bold;
            color: #555;
            display: block;
            margin-bottom: 8px;
        }

        .form-group input[type="text"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
        }

        .form-group button {
            width: 100%;
            padding: 12px;
            background-color: #e74c3c;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .form-group button:hover {
            background-color: #c0392b;
        }

        .message, .error {
            font-weight: bold;
            font-size: 1rem;
            padding: 10px;
            margin-top: 20px;
            border-radius: 4px;
        }

        .message {
            color: #27ae60;
            background-color: #e9f7ef;
        }

        .error {
            color: #c0392b;
            background-color: #fce4e4;
        }
    </style>
</head>
<body>

<h1>Remove Student</h1>
<br><br><br><br><br><br><br><br><br><br><br><br><br>
<form action="RemoveStudentServlet" method="post">
    <label>Student ID:</label>
    <input type="text" name="studentId" placeholder="Enter Student ID to Remove" required>

    <button type="submit">Remove Student</button>
</form>
 <a href="adminPortal.jsp">Back to adminPortal</a>

<%
    String status = request.getParameter("status");
    if (status != null) {
        if ("success".equals(status)) {
%>
            <p class="message">Student removed successfully!</p>
<%
        } else if ("notfound".equals(status)) {
%>
            <p class="error">No student found with the provided ID.</p>
<%
        } else if ("error".equals(status)) {
%>
            <p class="error">An error occurred. Please try again.</p>
<%
        } else if ("invalid".equals(status)) {
%>
            <p class="error">Invalid input. Please enter a valid student ID.</p>
<%
        }
    }
%>

</body>
</html>


