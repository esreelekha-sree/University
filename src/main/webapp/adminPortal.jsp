<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
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
  <title>Admin Portal</title>
  <style>
    :root{
      --page-bg:#e9f6ff;
      --card-bg: linear-gradient(180deg,#0d6efd,#0a58ca);
      --card-text:#fff;
      --muted:#6b7280;
      --danger:#d9534f;
      --radius:14px;
      --container:1100px;
      --card-h:150px;
      --pad:18px;
      --shadow: 0 10px 30px rgba(11,78,135,0.08);
    }
    html,body{
      height:100%;
      margin:0;
      font-family:Inter,Segoe UI,Arial;
      background:var(--page-bg);
      color:#0f172a;
    }
    .wrap{max-width:var(--container);margin:32px auto;padding:28px}
    .header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}
    h1{margin:0;font-size:30px}
    .user{font-size:14px;color:var(--muted)}
    .logout{background:var(--danger);color:#fff;padding:6px 10px;border-radius:8px;text-decoration:none;font-weight:700}
    .grid{display:grid;grid-template-columns:repeat(4,1fr);gap:18px}
    .card{
      background:var(--card-bg);
      color:var(--card-text);
      border-radius:var(--radius);
      padding:var(--pad);
      min-height:var(--card-h);
      display:flex;
      flex-direction:column;
      justify-content:space-between;
      box-shadow:var(--shadow);
      text-decoration:none;
      cursor:pointer;
    }
    .card h3{margin:0;font-size:18px}
    .card p{margin:8px 0 0;color:rgba(255,255,255,0.95);font-size:14px}
    .cta{
      background:rgba(255,255,255,0.12);
      padding:8px 12px;
      border-radius:8px;
      text-decoration:none;
      color:#fff;
      font-weight:700;
      display:inline-block;
    }
    .back{display:inline-block;margin-top:26px;color:var(--muted);text-decoration:none}
    @media(max-width:1000px){
      .grid{grid-template-columns:repeat(2,1fr)}
    }
    @media(max-width:520px){
      .grid{grid-template-columns:1fr}
      .header{flex-direction:column;align-items:flex-start;gap:12px}
    }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="header">
      <div>
        <h1>Admin Portal</h1>
        <div class="sub" style="color:var(--muted); margin-top:6px">Administration tools</div>
      </div>
      <div class="user">
        Signed in as: <strong><%= adminEmail %></strong>
        &nbsp;<a class="logout" href="<%= request.getContextPath() %>/adminLogout.jsp">Logout</a>
      </div>
    </div>

    <div class="grid">
      <div class="card" onclick="location.href='<%= request.getContextPath() %>/adminProfile.jsp'">
        <div><h3>MyProfile</h3><p>update your profile to provide security</p></div>
        <div><span class="cta">Open</span></div>
      </div>

      <div class="card" onclick="location.href='<%= request.getContextPath() %>/adminManageUsers.jsp'">
        <div><h3>Manage Users</h3><p>Add / remove or view students and faculty.</p></div>
        <div><span class="cta">Open</span></div>
      </div>

      <!-- <div class="card" onclick="location.href='<%= request.getContextPath() %>/viewStudent.jsp'">
        <div><h3>View Registered Students</h3><p>See full list of students registered on the system.</p></div>
        <div><span class="cta">Open</span></div>
      </div> -->
       

      <div class="card" onclick="location.href='<%= request.getContextPath() %>/viewFacultyList.jsp'">
        <div><h3>View Registered Faculty</h3><p>See full list of faculty registered on the system.</p></div>
        <div><span class="cta">Open</span></div>
      </div>

      <div class="card" onclick="location.href='<%= request.getContextPath() %>/addCourse.jsp'">
        <div><h3>Add Course</h3><p>Create new course entries.</p></div>
        <div><span class="cta">Open</span></div>
      </div>

      <div class="card" onclick="location.href='<%= request.getContextPath() %>/addEvent.jsp'">
        <div><h3>Add Event</h3><p>Create a new event.</p></div>
        <div><span class="cta">Open</span></div>
      </div>

      <div class="card" onclick="location.href='<%= request.getContextPath() %>/scheduleCourse.jsp'">
        <div><h3>Schedule Course</h3><p>Schedule a course session.</p></div>
        <div><span class="cta">Open</span></div>
      </div>
    </div>

    <a class="back" href="<%= request.getContextPath() %>/">Back to Home</a>
  </div>
</body>
</html>
