<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String facultyEmail = (String) session.getAttribute("facultyEmail");
    if (facultyEmail == null) {
        response.sendRedirect(request.getContextPath() + "/facultyLogin.jsp");
        return;
    }
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Faculty Portal</title>
  <style>
    :root{
      --page-bg:#e9f6ff;
      --card-bg: linear-gradient(180deg,#0d6efd,#0a58ca);
      --card-text:#fff;
      --muted:#6b7280;
      --danger:#d9534f;
      --radius:14px;
      --container:1100px;
      --card-h:160px;
      --pad:20px;
      --shadow: 0 10px 30px rgba(11,78,135,0.08);
    }

    html,body{
      margin:0;
      font-family:Inter, "Segoe UI", Arial, Helvetica, sans-serif;
      background:var(--page-bg);
      color:#0f172a;
    }

    .wrap{max-width:var(--container);margin:32px auto;padding:28px}
    .header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}
    h1{margin:0;font-size:30px}
    .sub{color:var(--muted); margin-top:6px}
    .user{font-size:14px;color:var(--muted)}
    .logout{
      background:var(--danger);
      color:#fff;
      padding:6px 10px;
      border-radius:8px;
      text-decoration:none;
      font-weight:700;
      font-size:13px;
    }
    .grid{
      display:grid;
      grid-template-columns:repeat(4,1fr);
      gap:18px;
    }
    .card{
      background:var(--card-bg);
      color:var(--card-text);
      border-radius:var(--radius);
      padding:var(--pad);
      min-height:var(--card-h);
      display:flex;
      flex-direction:column;
      justify-content:space-between;
      text-decoration:none;
      box-shadow:var(--shadow);
      transition: transform .18s ease, box-shadow .18s ease;
    }
    .card:hover{ transform: translateY(-4px); box-shadow:0 18px 40px rgba(11,78,135,0.12); }
    .card h3{margin:0;font-size:18px}
    .card p{margin-top:8px;font-size:14px;color:rgba(255,255,255,0.95)}
    .card-link{
      display:inline-block;
      background:rgba(255,255,255,0.12);
      padding:8px 12px;
      border-radius:8px;
      color:#fff;
      text-decoration:none;
      font-weight:700;
      font-size:14px;
    }
    .card-link:hover{ filter:brightness(0.95); }
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
      <h1>Faculty Portal</h1>
      <div class="sub">Tools for teaching and management</div>
    </div>

    <div class="user">
      Signed in: <strong><%= facultyEmail %></strong>
      &nbsp;<a class="logout" href="<%= request.getContextPath() %>/facultyLogout.jsp">Logout</a>
    </div>
  </div>

  <div class="grid">

    <!-- Assigned Schedules -->
    <div class="card">
      <div>
        <h3>Assigned Schedules</h3>
        <p>View assigned sessions &amp; attendance.</p>
      </div>
      <div><a class="card-link" href="<%= request.getContextPath() %>/facultyAssignedSchedules.jsp">Open</a></div>
    </div>

    <!-- Students -->
    <div class="card">
      <div>
        <h3>Students</h3>
        <p>View registered students.</p>
      </div>
      <div><a class="card-link" href="<%= request.getContextPath() %>/viewStudents.jsp">Open</a></div>
    </div>

    <!-- Profile -->
    <div class="card">
      <div>
        <h3>Profile</h3>
        <p>Update profile details.</p>
      </div>
      <div><a class="card-link" href="<%= request.getContextPath() %>/facultyProfile.jsp">Open</a></div>
    </div>

    <!-- Marks -->
    <div class="card">
      <div>
        <h3>Marks</h3>
        <p>Update student marks.</p>
      </div>
      <div><a class="card-link" href="<%= request.getContextPath() %>/updateMarks.jsp">Open</a></div>
    </div>

    <!-- Post Publication -->
    <div class="card">
      <div>
        <h3>Post Publication</h3>
        <p>Upload papers &amp; notes.</p>
      </div>
      <div><a class="card-link" href="<%= request.getContextPath() %>/postPublication.jsp">Open</a></div>
    </div>

    <!-- View Publications -->
    <div class="card">
      <div>
        <h3>View Publications</h3>
        <p>See your uploaded content.</p>
      </div>
      <div><a class="card-link" href="<%= request.getContextPath() %>/facultyViewPublications.jsp">Open</a></div>
    </div>

    <!-- My Uploads -->
    <div class="card">
      <div>
        <h3>My Uploads</h3>
        <p>Manage teaching material.</p>
      </div>
      <div><a class="card-link" href="<%= request.getContextPath() %>/facultyUploads.jsp">Open</a></div>
    </div>

    <!-- Upload CSV -->
    <div class="card">
      <div>
        <h3>Upload CSV</h3>
        <p>Bulk marks upload.</p>
      </div>
      <div><a class="card-link" href="<%= request.getContextPath() %>/uploadMarks.jsp">Open</a></div>
    </div>

    <!-- Student Queries -->
    <div class="card">
      <div>
        <h3>Student Queries</h3>
        <p>Respond to student questions.</p>
      </div>
      <div><a class="card-link" href="<%= request.getContextPath() %>/viewQueries.jsp">Open</a></div>
    </div>

    <!-- AI Assistant -->
    <!-- <div class="card">
      <div>
        <h3>AI Assistant</h3>
        <p>Ask questions &amp; get instant answers.</p>
      </div>
      <div><a class="card-link" href="<%= request.getContextPath() %>/aiAssistant.jsp">Open</a></div>
    </div> -->

  </div>

  <a class="back" href="<%= request.getContextPath() %>/main.jsp">Back to Home</a>

</div>
</body>
</html>
