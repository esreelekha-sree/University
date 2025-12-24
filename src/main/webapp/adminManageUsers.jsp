<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String adminEmail = (String) session.getAttribute("adminEmail");
    if (adminEmail == null) {
        response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
        return;
    }

    String msg = "";
    String err = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String deleteStudentId = request.getParameter("deleteStudentId");
        String deleteFacultyId = request.getParameter("deleteFacultyId");

        try (Connection conn = com.university.utils.DatabaseConnection.getConnection()) {
            if (deleteStudentId != null && !deleteStudentId.trim().isEmpty()) {
                String sql = "DELETE FROM students WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, Integer.parseInt(deleteStudentId));
                    int r = ps.executeUpdate();
                    if (r > 0) msg = "Student removed successfully.";
                    else err = "No student found with id " + deleteStudentId + ".";
                }
            } else if (deleteFacultyId != null && !deleteFacultyId.trim().isEmpty()) {
                String sql = "DELETE FROM faculty WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, Integer.parseInt(deleteFacultyId));
                    int r = ps.executeUpdate();
                    if (r > 0) msg = "Faculty removed successfully.";
                    else err = "No faculty found with id " + deleteFacultyId + ".";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            err = "Server error: " + e.getMessage();
        }
    }

    List<Map<String,Object>> students = new ArrayList<>();
    List<Map<String,Object>> faculty = new ArrayList<>();

    try (Connection conn = com.university.utils.DatabaseConnection.getConnection()) {
        // students: adapt to your students table (you said columns: id,name,email,department,password)
        try (PreparedStatement ps = conn.prepareStatement("SELECT id, name, email, department FROM students ORDER BY id ASC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("name", rs.getString("name"));
                row.put("email", rs.getString("email"));
                row.put("department", rs.getString("department"));
                students.add(row);
            }
        } catch (SQLException ex) {
            request.setAttribute("studentsLoadError", ex.getMessage());
        }

        // faculty: attempt to load table named 'faculty' (common). If your faculty table uses a different name, change here.
        try (PreparedStatement ps = conn.prepareStatement("SELECT id, name, email, department FROM faculty ORDER BY id ASC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("name", rs.getString("name"));
                row.put("email", rs.getString("email"));
                row.put("department", rs.getString("department"));
                faculty.add(row);
            }
        } catch (SQLException ex) {
            request.setAttribute("facultyLoadError", ex.getMessage());
        }

    } catch (Exception e) {
        e.printStackTrace();
        err = "Server error while loading users: " + e.getMessage();
    }
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Manage Users - Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { padding: 20px; background:#f7f7f7; }
    .card { margin-bottom: 20px; }
    table td, table th { vertical-align: middle; }
    .small-action { font-size:0.9rem; }
  </style>
</head>
<body>
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2>Manage Users</h2>
      <div>
        <span class="me-3">Signed in as <strong><%= adminEmail %></strong></span>
        <a class="btn btn-sm btn-outline-secondary" href="<%= request.getContextPath() %>/adminPortal.jsp">Back to Portal</a>
      </div>
    </div>

    <% if (!msg.isEmpty()) { %>
      <div class="alert alert-success"><%= msg %></div>
    <% } %>
    <% if (!err.isEmpty()) { %>
      <div class="alert alert-danger"><%= err %></div>
    <% } %>

    <% String sErr = (String) request.getAttribute("studentsLoadError");
       String fErr = (String) request.getAttribute("facultyLoadError");
       if (sErr != null) { %>
      <div class="alert alert-warning">Error loading students: <%= sErr %></div>
    <% } 
       if (fErr != null) { %>
      <div class="alert alert-warning">Error loading faculty: <%= fErr %> (If faculty table has a different name run DESCRIBE faculty_table_name and update SQL accordingly.)</div>
    <% } %>

    <!-- Students -->
    <div class="card">
      <div class="card-header">
        <h5 class="mb-0">Registered Students (<%= students.size() %>)</h5>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-striped table-hover mb-0">
            <thead class="table-light">
              <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Department</th>
                
              </tr>
            </thead>
            <tbody>
            <% if (students.isEmpty()) { %>
              <tr><td colspan="5" class="text-center py-4">No students registered.</td></tr>
            <% } else {
                 for (Map<String,Object> st : students) {
            %>
              <tr>
                <td><%= st.get("id") %></td>
                <td><%= st.get("name") %></td>
                <td><%= st.get("email") %></td>
                <td><%= st.get("department") == null ? "-" : st.get("department") %></td>
                <td class="text-end small-action">
                  <form method="post" style="display:inline" onsubmit="return confirm('Delete student ID <%= st.get("id") %>?');">
                    <input type="hidden" name="deleteStudentId" value="<%= st.get("id") %>"/>
                    <button class="btn btn-sm btn-danger" type="submit">Delete</button>
                  </form>
                  &nbsp;
                  <a class="btn btn-sm btn-outline-primary" href="<%= request.getContextPath() %>/viewStudent.jsp?id=<%= st.get("id") %>">View</a>
                </td>
              </tr>
            <%   }
               } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Faculty -->
    <div class="card">
      <div class="card-header">
        <h5 class="mb-0">Registered Faculty (<%= faculty.size() %>)</h5>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-striped table-hover mb-0">
            <thead class="table-light">
              <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Department</th>
                
              </tr>
            </thead>
            <tbody>
            <% if (faculty.isEmpty()) { %>
              <tr><td colspan="5" class="text-center py-4">No faculty registered or faculty table not found.</td></tr>
            <% } else {
                 for (Map<String,Object> f : faculty) {
            %>
              <tr>
                <td><%= f.get("id") %></td>
                <td><%= f.get("name") %></td>
                <td><%= f.get("email") %></td>
                <td><%= f.get("department") == null ? "-" : f.get("department") %></td>
                <td class="text-end small-action">
                  <form method="post" style="display:inline" onsubmit="return confirm('Delete faculty ID <%= f.get("id") %>?');">
                    <input type="hidden" name="deleteFacultyId" value="<%= f.get("id") %>"/>
                    <button class="btn btn-sm btn-danger" type="submit">Delete</button>
                  </form>
                  &nbsp;
                  <a class="btn btn-sm btn-outline-primary" href="<%= request.getContextPath() %>/viewFaculty.jsp?id=<%= f.get("id") %>">View</a>
                </td>
              </tr>
            <%   }
               } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="mt-3">
      <a class="btn btn-secondary" href="<%= request.getContextPath() %>/adminPortal.jsp">Back to Admin Portal</a>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
