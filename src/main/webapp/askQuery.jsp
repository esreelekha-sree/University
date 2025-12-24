<%@ page import="models.QueryDAO, models.Query1" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Query1, models.QueryDAO" %>
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ask a Query</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&family=Lora:wght@400;500&display=swap" rel="stylesheet">
    <style>
        /* General Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Montserrat', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #6E85B7, #B3C5D7);
            min-height: 100vh;
            color: #444;
        }

        .container {
            background-color: #fff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            width: 90%;
        }

        h2 {
            font-family: 'Lora', serif;
            font-size: 2rem;
            color: #3f2b96;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        label {
            font-weight: 600;
            color: #3f2b96;
            margin-bottom: 0.3rem;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 1rem;
            font-family: 'Montserrat', sans-serif;
            color: #555;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus,
        textarea:focus {
            border-color: #3f2b96;
            outline: none;
        }

        textarea {
            resize: vertical;
            height: 120px;
        }

        input[type="submit"] {
            padding: 0.8rem;
            background-color: #3f2b96;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
        }

        input[type="submit"]:hover {
            background-color: #35267d;
            transform: translateY(-2px);
        }

        .response-message {
            text-align: center;
            font-size: 1.1rem;
            color: #3f2b96;
            margin-top: 1rem;
        }

    </style>
</head>
<body>

<div class="container">
    <h2>Ask a Query</h2>
    
    <form method="post" action="">
        <label for="studentName">Student Name:</label>
        <input type="text" id="studentName" name="studentName" required>
        
        <label for="queryText">Your Query:</label>
        <textarea id="queryText" name="queryText" required></textarea>
        
        <input type="submit" value="Submit Query">
    </form>

    <%
        if ("post".equalsIgnoreCase(request.getMethod())) {
            String studentName = request.getParameter("studentName");
            String queryText = request.getParameter("queryText");

            Query1 query = new Query1(0, studentName, queryText, null);
            QueryDAO queryDAO = new QueryDAO();

            boolean isSaved = queryDAO.saveQuery(query);

            if (isSaved) {
                out.println("<p class='response-message'>Your query has been submitted successfully!</p>");
            } else {
                out.println("<p class='response-message' style='color: #e74c3c;'>Failed to submit your query. Please try again later.</p>");
            }
        }
    %>
<a href="studentPortal.jsp" class="back-link"><br>Back to studentPortal</a>   
</div>

</body>
</html>