<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String fEmail = (String) session.getAttribute("financeEmail");
    String fName  = (String) session.getAttribute("financeName");
    if (fEmail == null || !fEmail.endsWith("@rguktrkv.ac.in")) {
        response.sendRedirect(request.getContextPath() + "/financeLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Finance Officer Portal</title>
    <style>
      :root{
        --page-bg:#e9f6ff; --text-color:#0f172a; --card-bg:#fff; --muted:#6b7280; --danger:#d9534f;
      }
      body.dark {
        --page-bg:#0d1117; --text-color:#e6edf3; --muted:#9da5b4;
      }
      html,body{height:100%;margin:0;font-family:Inter,Segoe UI,Arial;background:var(--page-bg);color:var(--text-color);transition:all .2s}
      .wrap{max-width:980px;margin:24px auto;background:var(--card-bg);border-radius:10px;padding:24px;box-shadow:0 8px 30px rgba(0,0,0,0.06)}
      .header{display:flex;justify-content:space-between;align-items:center}
      .user {text-align:left}
      .user h3{margin:0 0 4px 0}
      .user small{color:var(--muted)}
      .actions{margin-top:18px;display:flex;gap:12px;flex-wrap:wrap}
      .btn{padding:12px 18px;border-radius:8px;border:none;cursor:pointer;font-weight:700}
      .btn-primary{background:#007bff;color:#fff}
      .btn-secondary{background:#17a2b8;color:#fff}
      .btn-ghost{background:#f5f6f8;color:#333;border:1px solid #e2e6ea}
      .btn-danger{background:var(--danger);color:#fff}
      .theme-toggle{padding:6px 10px;border-radius:8px;background:#e2e8f0;border:none;cursor:pointer;font-weight:600}
      body.dark .theme-toggle{background:#30363d;color:#fff}
      @media(max-width:720px){ .actions{flex-direction:column} }
    </style>
</head>
<body>
  <div class="wrap">
    <div class="header">
      <div class="user">
        <h3>Finance Officer Portal</h3>
        <small>Signed in as: <strong><%= (fName != null ? fName : "Finance Officer") %></strong> — <%= fEmail %></small>
      </div>

     <div style="display:flex;align-items:center;gap:12px">
        
        <a class="btn btn-danger" href="<%=request.getContextPath()%>/financeLogout.jsp">Logout</a>
        <a class="btn btn" href="<%=request.getContextPath()%>/main.jsp">Back to home</a>
      </div>
    </div>

    <div style="margin-top:18px" class="actions">
      <button class="btn btn-primary" onclick="location.href='<%=request.getContextPath()%>/financeProfile.jsp'">My Profile</button>
      <button class="btn btn-primary" onclick="location.href='<%=request.getContextPath()%>/budgetPlanning.jsp'">Budget Planning</button>
      <button class="btn btn-secondary" onclick="location.href='<%=request.getContextPath()%>/viewBudgetPlanning.jsp'">View Budget Planning</button>
      <button class="btn btn-primary" onclick="location.href='<%=request.getContextPath()%>/budgetCalculator.jsp'">Budget Calculator</button>
      
      <!--  <button class="btn btn-ghost" onclick="location.href='<%=request.getContextPath()%>/aiAssistant.jsp'">AI Assistant</button>-->
    </div>

    <div style="margin-top:22px;color:var(--muted)">
      <small>Tip: use the Budget Calculator for quick estimates.</small>
    </div>
       
  </div>

<script>
    function toggleTheme(){
        document.body.classList.toggle("dark");
        localStorage.setItem("theme", document.body.classList.contains("dark") ? "dark" : "light");
    }
    window.addEventListener('DOMContentLoaded', () => {
        if (localStorage.getItem("theme") === "dark") document.body.classList.add("dark");
    });
</script>
</body>
</html>
