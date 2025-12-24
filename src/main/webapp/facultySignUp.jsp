<%@ page import="models.Faculty, models.FacultyDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = "";
    // Use request.getMethod() to detect POST; keep behavior same as before
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String department = request.getParameter("department");

        try {
            Faculty f = new Faculty();
            f.setName(name);
            f.setEmail(email);
            f.setPassword(password); // plain-text: keep consistent with your DB
            f.setDepartment(department);

            FacultyDAO dao = new FacultyDAO();
            boolean ok = dao.register(f);
            if (ok) {
                message = "Registration successful. You may login now.";
            } else {
                message = "Email already registered.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Server error: " + e.getMessage();
        }
    }
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Faculty Signup</title>
  <!-- you can remove the bootstrap link if you aren't using bootstrap globally -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    /* small local styles so page still looks okay if bootstrap not used */
    body { background:#f6f8fb; font-family: Arial, sans-serif; padding:32px; }
    .box { max-width:600px; margin:0 auto; background:#fff; padding:22px; border-radius:10px; box-shadow:0 8px 24px rgba(0,0,0,0.06); }
  </style>
</head>
<body>
  <div class="box">
    <h3>Faculty Signup</h3>
    <% if (message != null && !message.isEmpty()) { %>
      <div class="alert alert-info"><%= message %></div>
    <% } %>

    <!-- POST to the same page (works regardless of exact filename/casing) -->
    <form method="post" action="<%= request.getRequestURI() %>">
      <div class="mb-3">
        <label class="form-label">Full name</label>
        <input class="form-control" name="name" required/>
      </div>
      <div class="mb-3">
        <label class="form-label">Email</label>
        <input class="form-control" name="email" type="email" required/>
      </div>
      <div class="mb-3">
        <label class="form-label">Password</label>
        <input class="form-control" name="password" type="password" required/>
      </div>
      <div class="mb-3">
        <label class="form-label">Department</label>
        <input class="form-control" name="department"/>
      </div>

      <button class="btn btn-primary" type="submit">Register</button>
      &nbsp;<a href="facultyLogin.jsp">Login</a>
    </form>
  </div>
</body>
</html>
