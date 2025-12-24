package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class FacultyDAO {

    // register faculty (returns true if OK, false if email already exists)
    public boolean register(Faculty f) throws Exception {
        String check = "SELECT id FROM faculty WHERE email = ?";
        String insert = "INSERT INTO faculty (name, email, password, department) VALUES (?, ?, ?, ?)";
        try (Connection conn = com.university.utils.DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(check)) {
            ps.setString(1, f.getEmail());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return false; // already exists
            }
            try (PreparedStatement ps2 = conn.prepareStatement(insert)) {
                ps2.setString(1, f.getName());
                ps2.setString(2, f.getEmail());
                ps2.setString(3, f.getPassword());
                ps2.setString(4, f.getDepartment());
                ps2.executeUpdate();
                return true;
            }
        }
    }

    // authenticate faculty; returns Faculty object or null
    public Faculty authenticate(String email, String password) throws Exception {
        String sql = "SELECT id, name, email, password, department FROM faculty WHERE email = ? AND password = ?";
        try (Connection conn = com.university.utils.DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Faculty f = new Faculty();
                    f.setId(rs.getInt("id"));
                    f.setName(rs.getString("name"));
                    f.setEmail(rs.getString("email"));
                    f.setPassword(rs.getString("password"));
                    f.setDepartment(rs.getString("department"));
                    return f;
                }
            }
        }
        return null;
    }
}
