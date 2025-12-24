package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAO {

    // Authenticate returns Admin object if credentials match, otherwise null
    public Admin authenticate(String email, String password) throws Exception {
        String sql = "SELECT admin_id, name, email, password FROM admins WHERE email = ? AND password = ?";
        try (Connection conn = com.university.utils.DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin a = new Admin();
                    a.setId(rs.getInt("admin_id"));
                    a.setName(rs.getString("name"));
                    a.setEmail(rs.getString("email"));
                    a.setPassword(rs.getString("password"));
                    return a;
                }
            }
        }
        return null;
    }
}
