<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // invalidate admin session and redirect to admin login
    session.removeAttribute("adminEmail");
    session.invalidate();
    response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
%>
