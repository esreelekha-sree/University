<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Require admin logged in
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
        return;
    }
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Add Course</title>
  <style>
    :root{
      --page-bg:#e9f6ff;
      --card-bg: linear-gradient(180deg,#0d6efd,#0a58ca);
      --accent:#0d6efd;
      --muted:#6b7280;
      --danger:#d9534f;
      --card-text:#fff;
      --radius:12px;
      --container:900px;
      --shadow: 0 10px 30px rgba(11,78,135,0.06);
    }
    html,body{margin:0;font-family:Inter,Segoe UI,Arial,Helvetica,sans-serif;background:var(--page-bg);color:#0f172a}
    .wrap{max-width:var(--container);margin:36px auto;padding:20px}
    .header{display:flex;justify-content:space-between;align-items:center;margin-bottom:18px}
    h1{margin:0;font-size:24px}
    .sub{color:var(--muted);margin-top:6px}
    .user{font-size:14px;color:var(--muted)}
    .logout{background:var(--danger);color:#fff;padding:6px 10px;border-radius:8px;text-decoration:none;font-weight:700}
    .card{background:#fff;border-radius:12px;padding:20px;box-shadow:var(--shadow)}
    label{display:block;margin-top:12px;margin-bottom:6px;color:#123; font-weight:600}
    input[type="text"], textarea, input[type="number"]{
      width:100%; padding:10px; border:1px solid #dfe8fb; border-radius:8px; box-sizing:border-box;
      background: #fff;
    }
    textarea{min-height:120px; resize:vertical}
    .row{display:flex; gap:12px}
    .col{flex:1}
    .actions{margin-top:16px; display:flex; gap:8px; align-items:center}
    .btn{background:var(--accent); color:#fff; padding:10px 16px; border-radius:8px; border:none; cursor:pointer; font-weight:700; text-decoration:none}
    .btn-ghost{background:#f3f7ff; color:#0d6efd; padding:10px 16px; border-radius:8px; border:1px solid #dfe8fb; cursor:pointer; font-weight:600; text-decoration:none}
    .hint{color:var(--muted); font-size:13px; margin-top:8px}
    .error{color:#9b1c1c;background:#ffdede;padding:8px;border-radius:6px;margin-top:10px}
    .success{color:#0f5132;background:#e6fff0;padding:8px;border-radius:6px;margin-top:10px}
    @media(max-width:700px){ .row{flex-direction:column} }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="header">
      <div>
        <h1>Add Course</h1>
        <div class="sub">Create a new course entry for your system</div>
      </div>

      <div class="user">
        Signed in: <strong><%= adminEmail %></strong>
        &nbsp;
        <a class="logout" href="<%= request.getContextPath() %>/adminLogout.jsp">Logout</a>
      </div>
    </div>

    <div class="card">
      <%
        // Show messages if the servlet redirected back with query params (optional).
        // If you prefer flash messages from servlet, you can set session attributes instead.
        String msg = request.getParameter("msg");
        String err = request.getParameter("err");
        if (msg != null && !msg.isEmpty()) {
      %>
        <div class="success"><%= msg %></div>
      <% } else if (err != null && !err.isEmpty()) { %>
        <div class="error"><%= err %></div>
      <% } %>

      <!-- Form: posts to the AddCourseServlet (your servlet handles DB insert) -->
      <form method="post" action="<%= request.getContextPath() %>/AddCourseServlet">
        <label for="courseName">Course name</label>
        <input id="courseName" name="courseName" type="text" placeholder="e.g. Introduction to Signals" required />

        <div class="row">
          <div class="col">
            <label for="courseCode">Course code</label>
            <input id="courseCode" name="courseCode" type="text" placeholder="e.g. EC101" required />
          </div>

          <div style="width:140px">
            <label for="credits">Credits</label>
            <input id="credits" name="credits" type="number" min="0" step="1" value="3" required />
          </div>
        </div>

        <label for="courseDescription">Course description</label>
        <textarea id="courseDescription" name="courseDescription" placeholder="Short description about the course (topics, objective)"></textarea>

        <div class="actions">
          <button class="btn" type="submit">Add Course</button>
          <a class="btn-ghost" href="<%= request.getContextPath() %>/viewScheduledCourses.jsp">Cancel</a>
        </div>

        <div class="hint">Note: this form submits to <code>/AddCourseServlet</code> — your servlet will insert into the <code>courses</code> table.</div>
      </form>
    </div>

    <a class="back" href="<%= request.getContextPath() %>/adminPortal.jsp">Back to Admin Portal</a>
  </div>
</body>
</html>
