package models;

import com.university.utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // Add student - used by signup. Signature must match calls in JSP
    public boolean addStudent(Student student) throws SQLException {
        String sql = "INSERT INTO students (name, email, password, department) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, student.getName());
            ps.setString(2, student.getEmail());
            ps.setString(3, student.getPassword());
            ps.setString(4, student.getDepartment());
            return ps.executeUpdate() > 0;
        }
    }

    // Authenticate by email+password (throws SQLException)
    public Student authenticateStudent(String email, String password) throws SQLException {
        String sql = "SELECT id, name, email, department, password FROM students WHERE email = ? AND password = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student s = new Student();
                    s.setId(rs.getInt("id"));                // IMPORTANT: set ID
                    s.setName(rs.getString("name"));
                    s.setEmail(rs.getString("email"));
                    s.setPassword(rs.getString("password"));
                    s.setDepartment(rs.getString("department"));
                    return s;
                }
            }
        }

        return null;
    }

    // Convenience wrapper that hides SQLException
    public Student loginStudent(String email, String password) {
        try {
            return authenticateStudent(email, password);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // Return all students for faculty view
    public List<Student> getAllStudents() throws SQLException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT id, name, email, department FROM students ORDER BY id";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setEmail(rs.getString("email"));
                s.setDepartment(rs.getString("department"));
                list.add(s);
            }
        }
        return list;
    }
}
