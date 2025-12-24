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
    <title>Verify Transactions</title>
</head>
<body>
    <h2>Verify Student Transactions</h2>

    <p>This is a placeholder page. You can add transaction tables later.</p>

    <a href="financePortal.jsp">Back</a>
</body>
</html>
