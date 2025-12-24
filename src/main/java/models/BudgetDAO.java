package models;

import com.university.utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BudgetDAO {

    public boolean saveBudget(Budget budget) {
        String query = "INSERT INTO budget (department, budget_amount, year, description) VALUES (?, ?, ?, ?)";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, budget.getDepartment());
            ps.setDouble(2, budget.getBudgetAmount());
            ps.setInt(3, budget.getYear());
            ps.setString(4, budget.getDescription());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
