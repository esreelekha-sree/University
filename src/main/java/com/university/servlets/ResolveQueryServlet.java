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

@WebServlet("/resolve2Query")
public class ResolveQueryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String reply = request.getParameter("reply");
        String facultyEmail = (String) request.getSession().getAttribute("facultyEmail");

        if (idStr == null || idStr.trim().isEmpty() || reply == null || facultyEmail == null) {
            response.sendRedirect(request.getContextPath() + "/facultyViewQueries.jsp?error=Invalid+request");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/facultyViewQueries.jsp?error=Invalid+id");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "UPDATE student_queries SET response_text=?, responder_email=?, responded_at=NOW(), status='resolved' WHERE id=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, reply);
                ps.setString(2, facultyEmail);
                ps.setInt(3, id);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/facultyViewQueries.jsp?error=DB+Error");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/facultyViewQueries.jsp?msg=Resolved+Successfully");
    }
}
