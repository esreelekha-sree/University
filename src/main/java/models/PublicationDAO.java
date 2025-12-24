//package models;
//
//import com.university.utils.DatabaseConnection;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.SQLException;
//
//public class PublicationDAO {
//    
//    // Method to save a publication to the database
//    public boolean savePublication(Publication publication) {
//        String querySQL = "INSERT INTO publications (title, content, author) VALUES (?, ?, ?)";
//
//        try (Connection conn = DatabaseConnection.getConnection();
//             PreparedStatement pstmt = conn.prepareStatement(querySQL)) {
//
//            pstmt.setString(1, publication.getTitle());
//            pstmt.setString(2, publication.getContent());
//            pstmt.setString(3, publication.getAuthor());
//
//            int rowsAffected = pstmt.executeUpdate();
//            return rowsAffected > 0;
//
//        } catch (SQLException e) {
//        }
//        return false;
//    }
//}
//



// File: university/model/PublicationDAO.java
package models;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.university.utils.DatabaseConnection;
import java.util.ArrayList;
import java.util.List;

public class PublicationDAO {
    
    public boolean savePublication(Publication publication) {
        String sql = "INSERT INTO publications (title, content, author) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, publication.getTitle());
            stmt.setString(2, publication.getContent());
            stmt.setString(3, publication.getAuthor());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            return false;
        }
    }
    public List<Publication> getAllPublications() {
        List<Publication> publications = new ArrayList<>();
        String sql = "SELECT * FROM publications ORDER BY datePosted DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Publication publication = new Publication(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("author"),
                        rs.getString("datePosted")
                );
                publications.add(publication);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return publications;
    }
}

