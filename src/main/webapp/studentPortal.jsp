<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String studentName = (String) session.getAttribute("studentName");
    String studentEmail = (String) session.getAttribute("studentEmail");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Student Portal</title>

    <style>
        :root{
          --page-bg: #e9f6ff;
          --card-bg: linear-gradient(180deg,#0d6efd,#0a58ca);
          --card-text: #ffffff;
          --muted: #6b7280;
          --danger: #d9534f;
          --radius:14px;
          --container:1100px;
          --card-h:160px;
          --pad:20px;
          --shadow: 0 10px 30px rgba(11,78,135,0.08);
        }

        body{
          margin:0;
          font-family:Segoe UI,Arial;
          background:var(--page-bg);
        }

        .wrap{max-width:var(--container);margin:32px auto;padding:28px}
        .header{display:flex;justify-content:space-between;align-items:center}
        h1{margin:0}
        .sub{color:var(--muted)}
        .logout{background:var(--danger);color:#fff;padding:6px 10px;border-radius:8px;text-decoration:none}

        .grid{display:grid;grid-template-columns:repeat(4,1fr);gap:18px;margin-top:25px}

        .card{
          background:var(--card-bg);
          color:var(--card-text);
          border-radius:var(--radius);
          padding:var(--pad);
          min-height:var(--card-h);
          display:flex;
          flex-direction:column;
          justify-content:space-between;
          cursor:pointer;
          box-shadow:var(--shadow);
        }

        .cta{
          background:rgba(255,255,255,0.15);
          padding:8px 12px;
          border-radius:8px;
          display:inline-block;
          font-weight:bold;
        }

        .small-grid{display:flex;gap:20px;margin-top:30px}
        .small-card{
          background:var(--card-bg);
          color:white;
          padding:20px;
          width:300px;
          border-radius:12px;
          cursor:pointer;
        }

        .interest-box{
          margin-top:40px;
          background:#fff;
          padding:20px;
          border-radius:12px;
          box-shadow:var(--shadow);
          max-width:500px;
        }

        input[type=text]{
          width:100%;
          padding:10px;
          margin-top:10px;
        }

        button{
          margin-top:12px;
          padding:8px 16px;
          background:#0d6efd;
          color:white;
          border:none;
          border-radius:6px;
          cursor:pointer;
        }

        .back{margin-top:30px;display:inline-block;color:#555}
    </style>
</head>

<body>
<div class="wrap">

<div class="header">
  <div>
    <h1>Student Portal</h1>
    <div class="sub">University Integrated Services</div>
  </div>

  <% if(studentEmail!=null){ %>
    Signed in as <%=studentName%>
     <a class="logout" href="studentLogout.jsp">Logout</a>
  <% } %>
</div>

<%-- NOT LOGGED IN --%>
<% if(studentEmail==null){ %>

  <div class="small-grid">
    <div class="small-card" onclick="location.href='studentSignUp.jsp'">
      <h3>Student Sign Up</h3>
      <p>Create an account</p>
    </div>

    <div class="small-card" onclick="location.href='studentLogin.jsp'">
      <h3>Student Login</h3>
      <p>Access your account</p>
    </div>
  </div>

<% } else { %>

<%-- LOGGED IN GRID --%>
<div class="grid">

  <div class="card" onclick="location.href='studentProfile.jsp'"><h3>My Profile</h3><span class="cta">Open</span></div>
  <div class="card" onclick="location.href='studentCourses.jsp'"><h3>My Registered Courses</h3><span class="cta">Open</span></div>
  <div class="card" onclick="location.href='registerForCourse.jsp'"><h3>Register for Course</h3><span class="cta">Open</span></div>
  <div class="card" onclick="location.href='recommend'"><h3>AI Recommendations</h3><span class="cta">Open</span></div>

  <div class="card" onclick="location.href='viewMarks.jsp'"><h3>View Marks</h3><span class="cta">Open</span></div>
  <div class="card" onclick="location.href='studentViewAttendance.jsp'"><h3>View Attendance</h3><span class="cta">Open</span></div>
  <div class="card" onclick="location.href='askQuery.jsp'"><h3>Ask Query</h3><span class="cta">Open</span></div>
  <div class="card" onclick="location.href='studentViewUploads.jsp'"><h3>Uploaded Notes</h3><span class="cta">Open</span></div>

  <div class="card" onclick="location.href='viewResolvedQueries.jsp'"><h3>Resolved Queries</h3><span class="cta">Open</span></div>
  <div class="card" onclick="location.href='viewPublication.jsp'"><h3>View Publications</h3><span class="cta">Open</span></div>
  <div class="card" onclick="location.href='studentViewBudget.jsp'"><h3>Budget Planning</h3><span class="cta">Open</span></div>
  <div class="card" onclick="location.href='aiAssistant.jsp'"><h3>AI Assistant</h3><span class="cta">Open</span></div>

</div>


<form action="saveInterests" method="post">
    <label>My Interests (comma separated):</label><br>
    <input type="text" name="interests"
           placeholder="daa algorithms design analysis"
           required>
    <br><br>
    <button type="submit">Save Interests</button>
</form>


<% } %>

<a class="back" href="main.jsp">Back to Home</a>

</div>
</body>
</html>
