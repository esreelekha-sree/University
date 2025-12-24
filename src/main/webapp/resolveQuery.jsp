<%@ page import="java.sql.*, com.university.utils.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String facEmail = (String) session.getAttribute("facultyEmail");
    if (facEmail == null || !facEmail.endsWith("@rguktrkv.ac.in")) {
        response.sendRedirect("facultyLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Resolve Query</title>
    <style>
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg,#6E85B7,#B3C5D7); padding:20px; }
        .container { max-width:700px; margin:40px auto; background:#fff; padding:20px; border-radius:8px; box-shadow:0 6px 18px rgba(0,0,0,0.1); }
        label{font-weight:600; display:block; margin-bottom:6px}
        input[type=text], textarea { width:100%; padding:10px; border:1px solid #ddd; border-radius:4px; }
        .btn { display:inline-block; margin-top:12px; padding:10px 16px; background:#28a745; color:#fff; border-radius:5px; text-decoration:none; border:none; cursor:pointer; }
        .btn-danger{ background:#c0392b;}
    </style>
</head>
<body>
<div class="container">
<%
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.trim().isEmpty()) {
%>
    <h2>No query selected</h2>
    <p>No query id was provided. Go back and choose a query to resolve.</p>
    <p><a href="viewQueries.jsp">Back to Queries</a></p>
<%
    } else {
        idParam = idParam.trim();
        if (idParam.startsWith("${") && idParam.endsWith("}")) {
%>
    <h2>Invalid request</h2>
    <p>The page was opened incorrectly (template expression not evaluated). Please open the Resolve form from the <a href="viewQueries.jsp">Queries list</a>.</p>
<%
        } else {
            int queryId = -1;
            try {
                queryId = Integer.parseInt(idParam);
            } catch (NumberFormatException nfe) {
%>
    <h2>Invalid Query ID</h2>
    <p>The provided query id is invalid: <%= idParam %></p>
    <p><a href="viewQueries.jsp">Back to Queries</a></p>
<%
                return;
            }

            // fetch query from DB
            String studentName = "";
            String queryText = "";
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT studentName, queryText FROM queries WHERE id = ?")) {
                ps.setInt(1, queryId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        studentName = rs.getString("studentName");
                        queryText = rs.getString("queryText");
                    } else {
%>
    <h2>Not found</h2>
    <p>Query with id <%= queryId %> was not found.</p>
    <p><a href="viewQueries.jsp">Back to Queries</a></p>
<%
                        return;
                    }
                }
            } catch (Exception ex) {
                out.println("<h2>Database error</h2>");
                out.println("<p>" + ex.getMessage() + "</p>");
                ex.printStackTrace(new java.io.PrintWriter(out));
                return;
            }
%>

    <h2>Resolve Query</h2>

    <form action="resolveQuery" method="post">
        <!-- hidden numeric id (safe) -->
        <input type="hidden" name="id" value="<%= queryId %>" />

        <label for="studentName">Student Name</label>
        <input type="text" id="studentName" name="studentName" value="<%= studentName %>" readonly />

        <label for="queryText">Query</label>
        <textarea id="queryText" name="queryText" rows="5" readonly><%= queryText %></textarea>

        <label for="resolution">Resolution</label>
        <textarea id="resolution" name="resolution" rows="5" required placeholder="Type the resolution..."></textarea>

        <button type="submit" class="btn">Submit Resolution</button>
        <a href="viewQueries.jsp" class="btn btn-danger" style="text-decoration:none; margin-left:10px;">Cancel</a>
    </form>

<%
        } // end else (id ok)
    } // end else (id present)
%>
</div>
</body>
</html>
