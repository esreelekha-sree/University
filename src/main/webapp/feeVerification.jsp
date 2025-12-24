<%
    String f = (String) session.getAttribute("financeEmail");
    if (f == null) {
        response.sendRedirect("financeLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Fee Verification</title>
</head>
<body>
    <h2>Fee Verification Panel</h2>

    <p>This is a placeholder page. You can add fee record verification here.</p>

    <a href="financePortal.jsp">Back</a>
</body>
</html>
