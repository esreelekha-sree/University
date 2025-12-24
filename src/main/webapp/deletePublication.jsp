<%@ page import="java.sql.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String facultyEmail = (String) session.getAttribute("facultyEmail");
  if (facultyEmail == null) {
    response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
    return;
  }

  String id = request.getParameter("id");
  String ctx = request.getContextPath();
  String msg = "", err = "";

  if (id == null || id.trim().isEmpty()) {
    err = "Missing publication id.";
    response.sendRedirect(ctx + "/facultyViewPublications.jsp?err=" + java.net.URLEncoder.encode(err, "UTF-8"));
    return;
  }

  try (Connection conn = DatabaseConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement("DELETE FROM publications WHERE id = ? AND faculty_email = ?")) {
    ps.setInt(1, Integer.parseInt(id));
    ps.setString(2, facultyEmail);
    int r = ps.executeUpdate();
    if (r > 0) {
      msg = "Publication deleted.";
      response.sendRedirect(ctx + "/facultyViewPublications.jsp?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));
      return;
    } else {
      err = "Delete failed or you are not authorized.";
    }
  } catch (Exception ex) {
    ex.printStackTrace();
    err = "Server error: " + ex.getMessage();
  }

  response.sendRedirect(ctx + "/facultyViewPublications.jsp?err=" + java.net.URLEncoder.encode(err, "UTF-8"));
%>
