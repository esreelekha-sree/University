<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String a = (String) session.getAttribute("adminEmail");
    if (a == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>


<!--<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Event</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input, .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .form-group input[type="submit"] {
            background: #5cb85c;
            color: white;
            border: none;
            cursor: pointer;
        }
        .form-group input[type="submit"]:hover {
            background: #4cae4c;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Add Event</h2>
        <form action="addEvent" method="post">
            <div class="form-group">
                <label for="eventName">Event Name:</label>
                <input type="text" id="eventName" name="eventName" required>
            </div>
            <div class="form-group">
                <label for="eventDate">Event Date:</label>
                <input type="date" id="eventDate" name="eventDate" required>
            </div>
            <div class="form-group">
                <label for="eventTime">Event Time:</label>
                <input type="time" id="eventTime" name="eventTime" required>
            </div>
            <div class="form-group">
                <label for="eventLocation">Event Location:</label>
                <input type="text" id="eventLocation" name="eventLocation" required>
            </div>
            <div class="form-group">
                <label for="eventDescription">Event Description:</label>
                <textarea id="eventDescription" name="eventDescription" rows="4" required></textarea>
            </div>
            <div class="form-group">
                <input type="submit" value="Add Event">
            </div>
        </form>
        <a href="adminPortal.jsp">Back to home</a>
    </div>
</body>
</html>-->






<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Event</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #6E85B7, #B3C5D7);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            max-width: 500px;
            background-color: #ffffff;
            padding: 100px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        h2 {
            font-family: 'Playfair Display', serif;
            text-align: center;
            color: #333333;
            margin-bottom: 20px;
            font-size: 2rem;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555555;
            font-weight: 600;
        }

        .form-group input,
        .form-group textarea {
            width: 130%;
            padding: 4px;
            border: 1px solid #dddddd;
            border-radius: 5px;
            font-size: 1rem;
            color: #333333;
            box-sizing: border-box;
            align-content: center;
        }

        .form-group input[type="submit"] {
            background-color: #007bff;
            color: white;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .form-group input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #555555;
            font-size: 1rem;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #007bff;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Add Event</h2>
        <form action="addEvent" method="post">
            <div class="form-group">
                <label for="eventName">Event Name:</label>
                <input type="text" id="eventName" name="eventName" required>
            </div>
            <div class="form-group">
                <label for="eventDate">Event Date:</label>
                <input type="date" id="eventDate" name="eventDate" required>
            </div>
            <div class="form-group">
                <label for="eventTime">Event Time:</label>
                <input type="time" id="eventTime" name="eventTime" required>
            </div>
            <div class="form-group">
                <label for="eventLocation">Event Location:</label>
                <input type="text" id="eventLocation" name="eventLocation" required>
            </div>
            <div class="form-group">
                <label for="eventDescription">Event Description:</label>
                <textarea id="eventDescription" name="eventDescription" rows="4" required></textarea>
            </div>
            <div class="form-group">
                <input type="submit" value="Add Event">
            </div>
        </form>
        <a href="adminPortal.jsp" class="back-link">Back to adminPortal</a>
    </div>
</body>
</html>