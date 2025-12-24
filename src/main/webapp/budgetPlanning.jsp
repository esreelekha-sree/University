<%@ page import="com.university.utils.DatabaseConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- session protection: require finance login ----
    String fEmail = (String) session.getAttribute("financeEmail");
    String fName  = (String) session.getAttribute("financeName");
    if (fEmail == null) {
        response.sendRedirect(request.getContextPath() + "/financeLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Budget Planning</title>
    <style>
        body{font-family:Arial,Helvetica,sans-serif;background:linear-gradient(#cfe2ff,#e9f2ff);margin:0;padding:40px}
        .card{max-width:760px;margin:0 auto;background:#fff;border-radius:8px;padding:28px;box-shadow:0 10px 30px rgba(0,0,0,0.08)}
        h1{text-align:center;margin-bottom:18px}
        label{display:block;margin:12px 0 6px;font-weight:600}
        input[type=text], input[type=number], textarea{width:100%;padding:12px;border-radius:6px;border:1px solid #ddd;box-sizing:border-box}
        button{display:block;width:100%;padding:12px;border-radius:6px;border:none;background:#007bff;color:#fff;font-weight:700;cursor:pointer;margin-top:14px}
        .msg {padding:12px;border-radius:6px;margin-bottom:12px}
        .msg.success{background:#e6f9ef;color:#0b7a3f;border:1px solid #bff0cd}
        .msg.warn{background:#fff4e6;color:#8a5300;border:1px solid #ffe0b8}
        .back {display:inline-block;margin-top:12px;color:#0066cc;text-decoration:none}
    </style>
</head>
<body>
  <div class="card">
    <h1>Budget Planning</h1>

<%
    // server-side processing
    String message = null;
    String messageClass = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String department = request.getParameter("department");
        String amountStr  = request.getParameter("budget_amount");
        String yearStr    = request.getParameter("year");
        String description= request.getParameter("description");

        // basic validation
        if (department == null || department.trim().isEmpty()
            || amountStr == null || amountStr.trim().isEmpty()
            || yearStr == null || yearStr.trim().isEmpty()) {
            message = "Please fill in Department, Budget Amount and Year.";
            messageClass = "warn";
        } else {
            // sanitize and parse
            department = department.trim();
            description = (description == null ? null : description.trim());
            BigDecimal amount = null;
            int year = 0;
            try {
                amount = new BigDecimal(amountStr.trim());
                year = Integer.parseInt(yearStr.trim());
            } catch (Exception ex) {
                message = "Invalid number or year format.";
                messageClass = "warn";
            }

            if (message == null) {
                // check duplicate then insert
                Connection conn = null;
                PreparedStatement psChk = null;
                PreparedStatement psIns = null;
                ResultSet rs = null;
                try {
                    conn = DatabaseConnection.getConnection();

                    String checkSql =
                      "SELECT budget_id FROM budget " +
                      "WHERE department = ? AND budget_amount = ? AND year = ? " +
                      "AND ( (description = ?) OR (description IS NULL AND ? IS NULL) ) " +
                      "LIMIT 1";

                    psChk = conn.prepareStatement(checkSql);
                    psChk.setString(1, department);
                    psChk.setBigDecimal(2, amount);
                    psChk.setInt(3, year);
                    // pass description twice for the NULL-safe comparison
                    psChk.setString(4, description);
                    psChk.setString(5, description);

                    rs = psChk.executeQuery();
                    if (rs.next()) {
                        // duplicate found
                        message = "This budget entry already exists — duplicate prevented.";
                        messageClass = "warn";
                    } else {
                        // insert
                        String insertSql = "INSERT INTO budget (department, budget_amount, year, description) VALUES (?, ?, ?, ?)";
                        psIns = conn.prepareStatement(insertSql);
                        psIns.setString(1, department);
                        psIns.setBigDecimal(2, amount);
                        psIns.setInt(3, year);
                        if (description == null || description.length() == 0) {
                            psIns.setNull(4, java.sql.Types.VARCHAR);
                        } else {
                            psIns.setString(4, description);
                        }
                        int updated = psIns.executeUpdate();
                        if (updated > 0) {
                            message = "Budget saved successfully.";
                            messageClass = "success";
                        } else {
                            message = "Failed to save budget (no DB rows affected).";
                            messageClass = "warn";
                        }
                    }
                } catch (Exception e) {
                    message = "Error: " + e.getMessage();
                    messageClass = "warn";
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
                    try { if (psChk != null) psChk.close(); } catch (Exception ignored) {}
                    try { if (psIns != null) psIns.close(); } catch (Exception ignored) {}
                    try { if (conn != null) conn.close(); } catch (Exception ignored) {}
                }
            }
        }

        // show message on page (fall through to render)
    }
%>

    <% if (message != null) { %>
      <div class="msg <%= ("success".equals(messageClass) ? "success" : "warn") %>">
        <%= message %>
      </div>
    <% } %>

    <form method="post" action="budgetPlanning.jsp">
        <label for="department">Department:</label>
        <input id="department" name="department" type="text" placeholder="Enter department name" value="<%= (request.getParameter("department")==null ? "" : request.getParameter("department")) %>" required>

        <label for="budget_amount">Budget Amount:</label>
        <input id="budget_amount" name="budget_amount" type="text" placeholder="Enter budget amount" value="<%= (request.getParameter("budget_amount")==null ? "" : request.getParameter("budget_amount")) %>" required>

        <label for="year">Year:</label>
        <input id="year" name="year" type="number" placeholder="Enter year" value="<%= (request.getParameter("year")==null ? "" : request.getParameter("year")) %>" required>

        <label for="description">Description:</label>
        <textarea id="description" name="description" rows="5" placeholder="Describe the budget"><%= (request.getParameter("description")==null ? "" : request.getParameter("description")) %></textarea>

        <button type="submit">Save Budget</button>
    </form>

    <a class="back" href="financePortal.jsp">Back to Portal</a>
  </div>
</body>
</html>
