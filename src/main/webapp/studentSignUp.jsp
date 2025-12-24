<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Student, models.StudentDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Signup</title>

    <style>
        /* Page background and font */
        :root{
            --bg-start: #cfefff;
            --bg-end:   #e9f6ff;
            --card-bg:  #ffffff;
            --accent:   #1e88e5;
            --muted:    #6b7280;
            --radius:   12px;
            --shadow:   0 18px 40px rgba(32,40,60,0.12);
        }
        html,body{height:100%;margin:0;font-family:Inter, "Segoe UI", Arial, sans-serif;background: linear-gradient(135deg,var(--bg-start),var(--bg-end));-webkit-font-smoothing:antialiased;}
        .wrap{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:36px}

        /* Card */
        .card {
            width:420px;
            max-width:92%;
            background:var(--card-bg);
            border-radius:14px;
            box-shadow:var(--shadow);
            padding:28px 30px;
            text-align:center;
            border:1px solid rgba(20,30,50,0.03);
        }

        .logo {
            width:72px;height:72px;margin:0 auto 10px;border-radius:12px;
            background: linear-gradient(135deg,#2f80ed,#0b5ed7);
            display:flex;align-items:center;justify-content:center;color:#fff;font-weight:800;font-size:20px;
            box-shadow:0 6px 18px rgba(11,78,135,0.08);
        }

        h2 { margin:8px 0 18px 0; font-size:22px; color:#0f172a; }
        .subtitle { color:var(--muted); font-size:13px; margin-bottom:18px; }

        /* form fields */
        form{text-align:left}
        label { display:block; font-size:13px; color:#374151; margin-bottom:6px; font-weight:600; }
        .field { width:100%; box-sizing:border-box; }
        input[type="text"], input[type="email"], input[type="password"] {
            width:100%;
            padding:12px 14px;
            border-radius:10px;
            border:1px solid #e6e9ef;
            background:#fff;
            font-size:14px;
            color:#0f172a;
            margin-bottom:12px;
            outline:none;
            transition: box-shadow .15s, border-color .12s;
        }
        input:focus { border-color:var(--accent); box-shadow:0 6px 18px rgba(30,136,229,0.08); }

        /* submit */
        .btn {
            display:block;
            width:100%;
            padding:12px;
            border-radius:10px;
            background: linear-gradient(90deg,#1976d2,#0b5ed7);
            color: #fff;
            font-weight:700;
            border: none;
            cursor:pointer;
            font-size:15px;
            margin-top:6px;
        }
        .btn:hover { filter:brightness(.98); }

        /* messages */
        .msg { text-align:center; margin-top:14px; font-size:14px; }
        .msg.success { color:#155724; background:#e9f7ee; padding:10px; border-radius:8px; }
        .msg.error   { color:#b91c1c; background:#ffdede; padding:10px; border-radius:8px; }

        .muted-line { text-align:center; margin-top:14px; color:var(--muted); font-size:13px; }
        .link { color:var(--accent); text-decoration:none; font-weight:600; }
        .link:hover { text-decoration:underline; }

        /* small screens */
        @media (max-width:420px) {
            .card { padding:20px; width:92%; }
            .logo { width:60px;height:60px;font-size:18px; }
        }
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">

        <div class="logo">S</div>
        <h2>Student Signup</h2>
        <div class="subtitle">Create your student account (use institutional email)</div>

        <%-- POST handling and validation are unchanged below --%>
        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String department = request.getParameter("department");

                // basic validation
                if (name == null || email == null || password == null ||
                    name.trim().isEmpty() || email.trim().isEmpty()) {
        %>
                    <div class="msg error">Please fill required fields.</div>
        <%
                }
                // Institutional email validation (unchanged)
                else if (!email.trim().endsWith("@rguktrkv.ac.in")) {
        %>
                    <div class="msg error">Only institutional emails (@rguktrkv.ac.in) are allowed for signup.</div>
        <%
                } else {
                    Student student = new Student();
                    student.setName(name.trim());
                    student.setEmail(email.trim());
                    student.setPassword(password); // consider hashing later
                    student.setDepartment(department == null ? "" : department.trim());

                    try {
                        StudentDAO dao = new StudentDAO();
                        if (dao.addStudent(student)) {
        %>
                            <div class="msg success">Signup successful! <a class="link" href="studentLogin.jsp">Login</a></div>
        <%
                        } else {
        %>
                            <div class="msg error">Error: Could not register student. Try again.</div>
        <%
                        }
                    } catch (Exception ex) {
                        out.println("<div class='msg error'>Server error while registering. Please try again later.</div>");
                        ex.printStackTrace();
                    }
                }
            } // end POST
        %>

        <!-- Form (GET or re-show after validation) - logic unchanged -->
        <form method="post" action="studentSignUp.jsp" novalidate>
            <label for="name">Full name</label>
            <input class="field" type="text" id="name" name="name" required />

            <label for="email">Email</label>
            <input class="field" type="email" id="email" name="email" required />

            <label for="password">Password</label>
            <input class="field" type="password" id="password" name="password" required />

            <label for="department">Department</label>
            <input class="field" type="text" id="department" name="department" />

            <button class="btn" type="submit">Sign Up</button>
        </form>

        <div class="muted-line">
            Already have an account? <a class="link" href="studentLogin.jsp">Login</a>
        </div>

        <div class="muted-line" style="margin-top:8px;">
            <a class="link" href="main.jsp">Back to Home</a>
        </div>
    </div>
</div>
</body>
</html>
