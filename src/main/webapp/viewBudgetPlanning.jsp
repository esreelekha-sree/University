<%@ page import="com.university.utils.DatabaseConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // protect page for finance officers only
    String fEmail = (String) session.getAttribute("financeEmail");
    if (fEmail == null) {
        response.sendRedirect(request.getContextPath() + "/financeLogin.jsp");
        return;
    }

    List<Map<String,Object>> rows = new ArrayList<>();
    int total = 0;
    try (Connection conn = DatabaseConnection.getConnection()) {
        // count (debug)
        try (PreparedStatement psCount = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM budget");
             ResultSet rsC = psCount.executeQuery()) {
            if (rsC.next()) total = rsC.getInt("cnt");
        } catch (Exception e) {
            total = -1; // couldn't read count
        }

        // fetch rows - use the actual column names from your table
        String sql = "SELECT budget_id, department, budget_amount, year, description FROM budget ORDER BY year DESC, budget_id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String,Object> r = new HashMap<>();
                r.put("budget_id", rs.getInt("budget_id"));
                r.put("department", rs.getString("department"));
                r.put("budget_amount", rs.getBigDecimal("budget_amount"));
                r.put("year", rs.getInt("year"));
                r.put("description", rs.getString("description"));
                rows.add(r);
            }
        }
    } catch (Exception e) {
        // show error on page for debugging
        request.setAttribute("viewError", e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>View Budget Planning</title>
  <style>
    body{font-family:Arial,Helvetica,sans-serif;background:#f4f7fb;margin:0;padding:30px}
    .wrap{max-width:1100px;margin:0 auto;background:#fff;border-radius:8px;padding:20px;box-shadow:0 8px 30px rgba(0,0,0,0.06)}
    h1{margin:0 0 18px 0}
    .meta{margin-bottom:12px;color:#444}
    table{width:100%;border-collapse:collapse}
    th{background:#1790e0;color:#fff;padding:14px;text-align:left}
    td{padding:14px;border-bottom:1px solid #f1f3f5}
    .back-btn{float:right;background:#0d6efd;color:#fff;padding:8px 12px;border-radius:6px;text-decoration:none}
    .note{color:#666;margin-top:12px}
  </style>
</head>
<body>
  <div class="wrap">
    <a class="back-btn" href="<%=request.getContextPath()%>/financePortal.jsp">Back to Portal</a>
    <h1>Budget Planning Details</h1>

    <div class="meta">
        <!-- debug: show total rows -->
        <strong>Total rows in `budget`:</strong> <%= (total >= 0 ? total : "unknown (see error below)") %>
        <br/>
        <small>Signed in as: <strong><%= fEmail %></strong></small>
    </div>

    <% if (request.getAttribute("viewError") != null) { %>
        <div style="background:#fdecea;color:#9b1c1c;padding:10px;border-radius:6px;margin-bottom:12px">
            Error reading budget rows: <%= request.getAttribute("viewError") %>
        </div>
    <% } %>

    <table>
      <thead>
        <tr>
          <th>Department</th>
          <th>Budget Amount</th>
          <th>Year</th>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
      <% if (rows.isEmpty()) { %>
        <tr><td colspan="4" style="text-align:center;padding:22px;color:#666">No budget rows found.</td></tr>
      <% } else {
            for (Map<String,Object> r : rows) { %>
        <tr>
          <td><%= r.get("department") %></td>
          <td><%= r.get("budget_amount") %></td>
          <td><%= r.get("year") %></td>
          <td><%= r.get("description") %></td>
        </tr>
      <%   }
         } %>
      </tbody>
    </table>

    <!-- <div class="note">
      If you expect rows but see none: run <code>SELECT * FROM budget ORDER BY budget_id DESC LIMIT 10;</code> in MySQL and paste results here.
    </div> -->
  </div>
</body>
</html>
