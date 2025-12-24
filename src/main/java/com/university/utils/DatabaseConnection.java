package com.university.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // update database name, user, password
    private static final String URL = "jdbc:mysql://localhost:3306/University";
    private static final String USER = "root";
    private static final String PASS = "dosha@1314";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // ensure MySQL driver on WEB-INF/lib
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
