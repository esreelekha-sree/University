package com.university.servlets;

import com.university.utils.DatabaseConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/saveInterests")
public class SaveStudentInterestsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        // ✅ CORRECT session key
        Integer studentId = (Integer) req.getSession().getAttribute("studentId");
        String interests = req.getParameter("interests");

        // DEBUG (keep for now)
        System.out.println("DEBUG SaveStudentInterestsServlet");
        System.out.println("Student ID = " + studentId);
        System.out.println("Interests = " + interests);

        if (studentId == null || interests == null || interests.trim().isEmpty()) {
            resp.sendRedirect("studentPortal.jsp");
            return;
        }

        try (Connection con = DatabaseConnection.getConnection()) {
            PreparedStatement ps =
                con.prepareStatement("UPDATE students SET interests=? WHERE id=?");
            ps.setString(1, interests.trim().toLowerCase());
            ps.setInt(2, studentId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("studentPortal.jsp");
    }
}
