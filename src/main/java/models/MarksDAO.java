package models;

import com.university.utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MarksDAO {

    public List<Marks> getMarksByStudentId(int studentId) {
        List<Marks> marksList = new ArrayList<>();
        String query = "SELECT * FROM marks WHERE studentId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Marks mark = new Marks(
                    rs.getInt("id"),
                    rs.getInt("studentId"),
                    rs.getString("courseName"),
                    rs.getInt("mark")
                );
                marksList.add(mark);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return marksList;
    }
}
