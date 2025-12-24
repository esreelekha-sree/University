package com.university.servlets;

import models.Student;
import models.StudentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ViewStudents")
public class ViewStudentsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            StudentDAO dao = new StudentDAO();
            List<Student> students = dao.getAllStudents();

            // Debug output to console
            System.out.println("ViewStudentsServlet: fetched " + students.size() + " students");

            request.setAttribute("students", students);
            request.getRequestDispatcher("/viewStudents.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/viewStudents.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
