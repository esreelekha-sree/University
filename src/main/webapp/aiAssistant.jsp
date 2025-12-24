<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // simple optional: require login if you want (uncomment)
  // String studentEmail = (String) session.getAttribute("studentEmail");
  // if (studentEmail == null) { response.sendRedirect("studentLogin.jsp"); return; }
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>AI Assistant</title>
  <style>
    :root{
      --page-bg: #e9f6ff;
      --card-bg: linear-gradient(180deg,#0d6efd,#0a58ca);
      --card-text: #ffffff;
      --muted: #6b7280;
      --radius:12px;
      --container:900px;
      --shadow:0 8px 24px rgba(11,78,135,0.06);
    }
    html,body{height:100%;margin:0;font-family:Inter,Segoe UI,Arial;background:var(--page-bg);color:#0f172a}
    .wrap{max-width:var(--container);margin:36px auto;padding:24px}
    .card{background:#fff;border-radius:12px;padding:20px;box-shadow:var(--shadow)}
    h1{margin:0 0 12px 0}
    form { display:flex; gap:10px; align-items:flex-start; }
    input[type="text"]{flex:1;padding:10px;border-radius:8px;border:1px solid #dbe7ff;font-size:15px}
    button{background:#0d6efd;color:#fff;padding:10px 14px;border-radius:8px;border:none;cursor:pointer;font-weight:700}
    .answer{margin-top:16px;padding:14px;border-radius:8px;background:#f4f8ff;border:1px solid #e6f0ff;color:#0b2b4a}
    .small{color:var(--muted);font-size:13px;margin-top:8px}
    a.back{display:inline-block;margin-top:14px;color:#0d6efd;text-decoration:none}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="card">
      <h1>AI Assistant</h1>
      <p class="small">Ask a short question about the system (attendance, upload, downloads, marks, schedules, publications, UI tips).</p>

      <form method="post" action="aiAssistant.jsp">
        <input type="text" name="question" placeholder="Type your question here..." required />
        <button type="submit">Ask</button>
      </form>

      <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String q = request.getParameter("question");
            String aiResponse = "Sorry — I don't recognize that query. Try asking about attendance, uploads, downloads, marks, or schedules.";

            if (q != null) {
                String low = q.trim().toLowerCase();

                if (low.contains("attendance") || low.contains("mark attendance") || low.contains("record attendance")) {
                    aiResponse = "To record attendance: go to 'Assigned Schedules', open a schedule, mark checkboxes for present students and click 'Save Attendance'. If you get a 404 on /saveAttendance, ensure SaveAttendanceServlet is deployed and mapped to /saveAttendance.";
                } else if (low.contains("download") || low.contains("uploads") || low.contains("file")) {
                    aiResponse = "Downloads: faculty files stored under /uploads (webapp). If download fails, check that the file exists in webapps/University/uploads or use the DownloadServlet which streams by filename or id.";
                } else if (low.contains("marks") || low.contains("upload csv") || low.contains("csv")) {
                    aiResponse = "For marks: use 'Upload (CSV)' for bulk uploads or 'Update Marks' for single-entry updates. CSV must match the expected columns (studentId, marks...).";
                } else if (low.contains("schedule") || low.contains("schedules")) {
                    aiResponse = "Schedules are in the 'schedules' table. Faculty see assigned schedules under 'Assigned Schedules'. If your table name differs, update SQL queries in recordAttendance.jsp accordingly (e.g. schedules vs scheduled_courses).";
                } else if (low.contains("servlet") || low.contains("classnotfound")) {
                    aiResponse = "If you see ClassNotFound or NoClassDefFound errors, ensure the .class is deployed under WEB-INF/classes and package names match. Restart Tomcat or republish from Eclipse (WTP) so class files are copied to the runtime folder.";
                } else if (low.contains("ui") || low.contains("theme") || low.contains("portal")) {
                    aiResponse = "UI tips: keep a consistent CSS variables theme, use grid layout for cards, and keep Logout button in red for visibility. I can generate updated JSP snippets for portals on request.";
                } else if (low.contains("database") || low.contains("table")) {
                    aiResponse = "DB tip: use `SHOW TABLES; DESCRIBE <table>;` to inspect. For missing table errors, run your SQL create script or import the provided dump.";
                } else if (low.contains("help") || low.contains("example")) {
                    aiResponse = "Try questions like: 'How to record attendance?', 'Why download returns 404?', 'How to add delete button for uploads?'.";
                } else {
                    // small heuristic fallback: echo with guidance
                    aiResponse = "I couldn't match a specific topic. Try asking about 'attendance', 'downloads', 'marks', 'uploads', 'schedules', or 'servlets'.";
                }
            }

      %>
        <div class="answer"><strong>Answer:</strong><br/><%= aiResponse %></div>
      <% } %>

      <a class="back" href="studentPortal.jsp">Back to Portal</a>
    </div>
  </div>
</body>
</html>
