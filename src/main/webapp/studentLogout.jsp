<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Clear student session and redirect to public portal landing
    session.removeAttribute("studentEmail");
    session.removeAttribute("studentName");
    session.removeAttribute("studentId");
    session.invalidate();

    response.sendRedirect("studentPortal.jsp");
%>
