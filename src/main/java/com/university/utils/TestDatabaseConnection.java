package com.university.utils;

import java.sql.Connection;
//import java.sql.DriverManager;
import java.sql.SQLException;

public class TestDatabaseConnection {
    public static void main(String[] args) {
        try {
            // Attempt to establish a connection
            Connection connection = DatabaseConnection.getConnection();

            // Check if the connection is not null
            if (connection != null) {
                System.out.println("Connection established successfully!");
                // Close the connection after testing
                connection.close();
            } else {
                System.out.println("Failed to establish a connection.");
            }
        } catch (SQLException e) {
            // Print any SQL exceptions that occur
            System.err.println("SQL Exception: " + e.getMessage());
        } catch (Exception e) {
            // Print any other exceptions that occur
            System.err.println("Exception: " + e.getMessage());
        }
    }
}
