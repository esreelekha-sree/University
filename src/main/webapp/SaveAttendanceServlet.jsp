package com.university.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Collections;
import java.util.List;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/saveAttendance")
public class SaveAttendanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        String scheduleIdParam = req.getParameter("scheduleId");
        String ctx = req.getContextPath();

        String facultyEmail = (String) req.getSession().getAttribute("facultyEmail");
        if (facultyEmail == null) {
            resp.sendRedirect(ctx + "/facultyLogin.jsp");
            return;
        }

        if (scheduleIdParam == null) {
            resp.sendRedirect(ctx + "/facultyAssignedSchedules.jsp?error=Missing+scheduleId");
            return;
        }

        final int scheduleId;
        try {
            scheduleId = Integer.parseInt(scheduleIdParam);
        } catch (NumberFormatException nfe) {
            resp.sendRedirect(ctx + "/facultyAssignedSchedules.jsp?error=Invalid+scheduleId");
            return;
        }

        // collect parameter names as a typed list to avoid raw Enumeration warnings
        List<String> paramNames = Collections.list(req.getParameterNames());

        try (Connection con = com.university.utils.DatabaseConnection.getConnection()) {

            Timestamp now = new Timestamp(System.currentTimeMillis());

            // Step A: mark existing attendance as absent for this schedule
            final String markAbsentSql = "UPDATE attendance SET present = 0, recorded_at = ?, recorded_by = ? WHERE schedule_id = ?";
            try (PreparedStatement psMarkAbsent = con.prepareStatement(markAbsentSql)) {
                psMarkAbsent.setTimestamp(1, now);
                psMarkAbsent.setString(2, facultyEmail);
                psMarkAbsent.setInt(3, scheduleId);
                psMarkAbsent.executeUpdate();
            }

            // Step B: prepare update and insert statements
            final String updateSql = "UPDATE attendance SET present = ?, recorded_at = ?, recorded_by = ? WHERE schedule_id = ? AND student_id = ?";
            final String insertSql = "INSERT INTO attendance (student_id, schedule_id, present, recorded_at, recorded_by) VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement psUpdate = con.prepareStatement(updateSql);
                 PreparedStatement psInsert = con.prepareStatement(insertSql)) {

                for (String param : paramNames) {
                    if (!param.startsWith("present_")) continue;
                    String sidStr = param.substring("present_".length());
                    final int studentId;
                    try {
                        studentId = Integer.parseInt(sidStr);
                    } catch (NumberFormatException nfe) {
                        continue; // skip invalid param name
                    }

                    // Try update first
                    psUpdate.setInt(1, 1);              // present = 1
                    psUpdate.setTimestamp(2, now);
                    psUpdate.setString(3, facultyEmail);
                    psUpdate.setInt(4, scheduleId);
                    psUpdate.setInt(5, studentId);
                    int updated = psUpdate.executeUpdate();

                    if (updated == 0) {
                        // insert new row
                        psInsert.setInt(1, studentId);
                        psInsert.setInt(2, scheduleId);
                        psInsert.setInt(3, 1);
                        psInsert.setTimestamp(4, now);
                        psInsert.setString(5, facultyEmail);
                        psInsert.executeUpdate();
                    }
                }
            }

            String msg = "Attendance saved";
            String redirect = ctx + "/facultyAssignedSchedules.jsp?msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8.name());
            resp.sendRedirect(redirect);
            return;

        } catch (SQLException ex) {
            ex.printStackTrace();
            String err = "DB error: " + ex.getMessage();
            String redirect = ctx + "/facultyAssignedSchedules.jsp?error=" + URLEncoder.encode(err, StandardCharsets.UTF_8.name());
            resp.sendRedirect(redirect);
            return;
        }
    }
}
