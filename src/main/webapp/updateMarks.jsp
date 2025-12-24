<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>

<head>
    <title>Update Marks</title>
    <style>
/*        body { font-family: Arial, sans-serif; background-color: #f4f6f8; }
        h1 { text-align: center; color: #333; }
        form { max-width: 500px; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 5px; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1); }
        input[type="text"], input[type="number"] { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 4px; }
        button { padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background-color: #45a049; }
        .message, .error { text-align: center; font-weight: bold; }
        .message { color: #4CAF50; }
        .error { color: #FF0000; }*/
        
        
         body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #6E85B7, #B3C5D7);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        h1 {
            text-align: center;
            color: #444;
            font-family: 'Montserrat', sans-serif;
            font-size: 2.2rem;
        }

        form {
            max-width: 500px;
            width: 100%;
            background-color: #fff;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }

        label {
            font-weight: 500;
            color: #555;
            margin-top: 1rem;
            display: block;
        }

        input[type="text"], input[type="number"] {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            margin-bottom: 1rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }

        button {
            width: 100%;
            padding: 12px;
            font-size: 1rem;
            font-family: 'Montserrat', sans-serif;
            font-weight: 500;
            color: white;
            background-color: #007BFF;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #0056b3;
        }

        .message, .error {
            text-align: center;
            font-weight: 500;
            margin-top: 1rem;
            padding: 10px;
            border-radius: 4px;
            width: 100%;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }

        .message {
            background-color: #e6f7e6;
            color: #2f8132;
        }

        .error {
            background-color: #fde8e8;
            color: #b22a2a;
        }
    </style>
</head>
<body>

<h1>Update Student Marks</h1>
<form action="UpdateMarksServlet" method="post">
    <label>Student ID:</label>
    <input type="text" name="studentId" placeholder="Enter Student ID" required>
    
    <label>Course Name:</label>
    <input type="text" name="courseName" placeholder="Enter Course Name" required>
    
    <label>New Mark:</label>
    <input type="number" name="mark" placeholder="Enter New Mark" required>

    <button type="submit">Update Marks</button>
    <a href="facultyPortal.jsp" class="back-link"><br>Back to facultyPortal</a>
</form>

<%
    String status = request.getParameter("status");
    if (status != null) {
        if ("success".equals(status)) {
%>
            <p class="message">Marks updated successfully!</p>
<%
        } else if ("notfound".equals(status)) {
%>
            <p class="error">No record found for the provided Student ID and Course Name.</p>
<%
        } else if ("error".equals(status)) {
%>
            <p class="error">An error occurred. Please try again.</p>
<%
        } else if ("invalid".equals(status)) {
%>
            <p class="error">Invalid input. Please enter valid data.</p>
<%
        }
    }
%>

</body>






