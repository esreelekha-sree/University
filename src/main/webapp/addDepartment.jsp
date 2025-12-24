<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Department</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Add Department</h1>
            <nav>
                <ul>
                    <li><a href="index.html">Home</a></li>
                    <li><a href="departments.jsp">View Departments</a></li>
                    <li><a href="contact.jsp">Contact Us</a></li>
                </ul>
            </nav>
        </header>
        <main>
            <h2>Add a New Department</h2>
            <form action="addDepartment.jsp" method="post">
                <label for="deptName">Department Name:</label>
                <input type="text" id="deptName" name="deptName" required>
                <br>
                <label for="deptDescription">Description:</label>
                <textarea id="deptDescription" name="deptDescription" required></textarea>
                <br>
                <input type="submit" value="Add Department">
            </form>
        </main>
        <footer>
            <p>&copy; 2025 University Department System. All Rights Reserved.</p>
        </footer>
    </div>
</body>
</html>

