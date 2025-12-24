package models;

import com.university.utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class FinanceDAO {

    // Authenticate finance officer using email + password
    public FinanceOfficer authenticate(String email, String password) {

        String sql = "SELECT id, name, email, password FROM finance_officer WHERE email = ? AND password = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email.trim().toLowerCase());
            ps.setString(2, password.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {

                    FinanceOfficer f = new FinanceOfficer();
                    f.setId(rs.getInt("id"));         // IMPORTANT: used in session
                    f.setName(rs.getString("name"));
                    f.setEmail(rs.getString("email"));
                    f.setPassword(rs.getString("password"));

                    return f;
                }
            }
        } catch (Exception e) {
            System.out.println("FinanceDAO.authenticate() ERROR:");
            e.printStackTrace();
        }
        return null;
    }
}
