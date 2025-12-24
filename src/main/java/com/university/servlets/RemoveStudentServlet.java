/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.university.servlets;


import com.university.utils.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/RemoveStudentServlet")
public class RemoveStudentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studentIdStr = request.getParameter("studentId");

        try {
            int studentId = Integer.parseInt(studentIdStr);

            try (Connection connection = DatabaseConnection.getConnection()) {
                String sql = "DELETE FROM students WHERE id = ?";
                try (PreparedStatement statement = connection.prepareStatement(sql)) {
                    statement.setInt(1, studentId);
                    int rowsAffected = statement.executeUpdate();

                    if (rowsAffected > 0) {
                        response.sendRedirect("removeStudent.jsp?status=success");
                    } else {
                        response.sendRedirect("removeStudent.jsp?status=notfound");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("removeStudent.jsp?status=error");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("removeStudent.jsp?status=invalid");
        }
    }
}

