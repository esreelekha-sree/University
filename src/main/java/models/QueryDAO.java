//package models;
//
//import com.university.utils.DatabaseConnection;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.SQLException;
//
//public class QueryDAO {
//
//    // Method to save a query into the database
//    public boolean saveQuery(Query query) {
//        String querySQL = "INSERT INTO queries (studentName, queryText) VALUES (?, ?)";
//
//        try (Connection conn = DatabaseConnection.getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(querySQL)) {
//
//            pstmt.setString(1, query.getStudentName());
//            pstmt.setString(2, query.getQueryText());
//
//            int rowsAffected = pstmt.executeUpdate();
//            return rowsAffected > 0;
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//}


package models;

import com.university.utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class QueryDAO {

    // Method to save a query into the database

    /**
     *
     * @param query
     * @return
     */
    public boolean saveQuery(Query1 query) {
        String querySQL = "INSERT INTO queries (studentName, queryText) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(querySQL)) {

            pstmt.setString(1, query.getStudentName());
            pstmt.setString(2, query.getQueryText());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
        }
        return false;
    }
}
