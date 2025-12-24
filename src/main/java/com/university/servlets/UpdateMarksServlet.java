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

@WebServlet("/UpdateMarksServlet")
public class UpdateMarksServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String studentIdStr = request.getParameter("studentId");
        String courseName = request.getParameter("courseName");
        String markStr = request.getParameter("mark");

        try {
            int studentId = Integer.parseInt(studentIdStr);
            int mark = Integer.parseInt(markStr);

            try (Connection connection = DatabaseConnection.getConnection()) {
                String sql = "UPDATE marks SET mark = ? WHERE studentId = ? AND courseName = ?";
                try (PreparedStatement statement = connection.prepareStatement(sql)) {
                    statement.setInt(1, mark);
                    statement.setInt(2, studentId);
                    statement.setString(3, courseName);
                    int rowsUpdated = statement.executeUpdate();

                    if (rowsUpdated > 0) {
                        response.sendRedirect("updateMarks.jsp?status=success");
                    } else {
                        response.sendRedirect("updateMarks.jsp?status=notfound");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("updateMarks.jsp?status=error");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("updateMarks.jsp?status=invalid");
        }
    }
}
