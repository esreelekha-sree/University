package models;

import com.university.utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for operations related to courses and student registrations.
 */
public class CourseDAO {

    /**
     * Return all courses as List<String> with format "course_id - course_name"
     * (This matches how your JSPs currently consume course lists.)
     */
    public List<String> getAllCourses() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT course_id, course_name FROM courses ORDER BY course_name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("course_id");
                    String name = rs.getString("course_name");
                    list.add(id + " - " + name);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Register a student for a course.
     * Returns true when registration was successfully inserted.
     * If the student is already registered for the course, returns false.
     */
    public boolean registerCourse(int studentId, int courseId) {
        String sql = "INSERT INTO registrations (student_id, course_id) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            // If duplicate registration exists or any SQL error, print and return false.
            // Optionally detect SQLState or error code for duplicate-key and handle specially.
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Returns list of courses registered by the given student.
     * Each entry is "course_id - course_name".
     */
    public List<String> getRegisteredCourses(int studentId) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT c.course_id, c.course_name " +
                     "FROM courses c " +
                     "JOIN registrations r ON c.course_id = r.course_id " +
                     "WHERE r.student_id = ? " +
                     "ORDER BY r.registration_id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int cid = rs.getInt("course_id");
                    String name = rs.getString("course_name");
                    list.add(cid + " - " + name);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Drop a course registration for a student.
     * Returns true if the registration row was deleted.
     */
    public boolean dropCourse(int studentId, int courseId) {
        String sql = "DELETE FROM registrations WHERE student_id = ? AND course_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Optional helper: fetch course name by id (useful for detail pages).
     * Returns null if not found.
     */
    public String getCourseNameById(int courseId) {
        String sql = "SELECT course_name FROM courses WHERE course_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("course_name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
