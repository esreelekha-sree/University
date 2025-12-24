<%-- index.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>University Department System</title>
    <style>
        /* Basic Styling for the Main Website */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .header {
            background-color: #333;
            color: white;
            padding: 10px 0;
            text-align: center;
        }
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .role-section {
            margin: 20px 0;
        }
        .role-section h2 {
            background-color: #444;
            color: white;
            padding: 10px;
            margin: 0;
        }
        .link-list {
            list-style-type: none;
            padding: 0;
        }
        .link-list li {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        .link-list li a {
            text-decoration: none;
            color: #0066cc;
            font-size: 18px;
        }
        .link-list li a:hover {
            color: #00509e;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>Welcome to the University Department System</h1>
    </div>

    <div class="container">
        <!-- Student Section -->
        <div class="role-section">
            <h2>Student</h2>
            <ul class="link-list">
                <li><a href="studentCourses.jsp">My Registered Courses</a></li>
                <li><a href="studentSignUp.jsp">Sign Up</a></li>
                <li><a href="studentLogin.jsp">Login</a></li>
                <li><a href="registerForCourse.jsp">Register for Course</a></li>
                <li><a href="viewMarks.jsp">View Marks</a></li>
                <li><a href="askQuery.jsp">Ask a Query</a></li>
                <li><a href="viewPublication.jsp">View Publications</a></li>
                <li><a href="studentViewBudget.jsp">View University Budget</a></li>
                <li><a href="viewAttendance.jsp">View Attendance</a></li>
            </ul>
        </div>

        <!-- Faculty Section -->
        <div class="role-section">
            <h2>Faculty</h2>
            <ul class="link-list">
                <li><a href="facultySignUp.jsp">Sign Up</a></li>
                <li><a href="facultyLogin.jsp">Login</a></li>
            </ul>
        </div>

        <!-- Admin Section -->
        <div class="role-section">
            <h2>Admin</h2>
            <ul class="link-list">
                <li><a href="addCourse.jsp">Add Course</a></li>
                <li><a href="addEvent.jsp">Add Event</a></li>
                <li><a href="scheduleCourse.jsp">Schedule Course</a></li>
                <li><a href="removeStudent.jsp">Remove Student</a></li>
            </ul>
        </div>

        <!-- Finance Officer Section -->
        <div class="role-section">
            <h2>Finance Officer</h2>
            <ul class="link-list">
                <!-- Always point to login first so the finance user authenticates -->
                <li><a href="financeLogin.jsp">Finance Login</a></li>

                <!-- after login the portal will be accessible -->
                <li><a href="financePortal.jsp">Finance Portal</a></li>

                <!-- specific finance pages (protected by session checks in each JSP) -->
                <li><a href="budgetPlanning.jsp">Budget Planning</a></li>
                <li><a href="viewBudgetPlanning.jsp">View Budget Planning</a></li>
                <li><a href="verifyTransaction.jsp">Verify Transaction</a></li>
                <li><a href="feeVerification.jsp">Fee Verification</a></li>
            </ul>
        </div>
    </div>

</body>
</html>
