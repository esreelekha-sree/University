package com.university.servlets;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/deleteUpload")
public class DeleteUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads"; // relative to webapp root

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        String ctx = req.getContextPath();

        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(ctx + "/facultyUploads.jsp?error=" + URLEncoder.encode("Missing id", "UTF-8"));
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException nfe) {
            resp.sendRedirect(ctx + "/facultyUploads.jsp?error=" + URLEncoder.encode("Invalid id", "UTF-8"));
            return;
        }

        String savedFilename = null;
        String ownerEmail = null;

        try (Connection con = com.university.utils.DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT saved_filename, faculty_email FROM uploads WHERE id = ?")) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    savedFilename = rs.getString("saved_filename");
                    ownerEmail = rs.getString("faculty_email"); // adjust column name if different
                } else {
                    resp.sendRedirect(ctx + "/facultyUploads.jsp?error=" + URLEncoder.encode("Upload record not found", "UTF-8"));
                    return;
                }
            }

            // ownership check: allow only same faculty (or extend with admin role)
            String sessionEmail = (String) req.getSession().getAttribute("facultyEmail");
            if (sessionEmail == null || !sessionEmail.equalsIgnoreCase(ownerEmail)) {
                resp.sendRedirect(ctx + "/facultyUploads.jsp?error=" + URLEncoder.encode("Not authorized to delete this file", "UTF-8"));
                return;
            }

            // Construct physical path
            String webappRoot = getServletContext().getRealPath("/");
            String filePath;
            if (webappRoot != null) {
                filePath = webappRoot + (webappRoot.endsWith(File.separator) ? "" : File.separator) + UPLOAD_DIR + File.separator + savedFilename;
            } else {
                filePath = System.getProperty("catalina.base") + File.separator + "webapps"
                         + File.separator + req.getContextPath().replaceFirst("/", "") + File.separator
                         + UPLOAD_DIR + File.separator + savedFilename;
            }

            // Delete file if exists
            boolean fileDeleted = true;
            File f = new File(filePath);
            if (f.exists() && f.isFile()) {
                fileDeleted = f.delete();
            }

            // Delete DB row
            try (PreparedStatement del = con.prepareStatement("DELETE FROM uploads WHERE id = ?")) {
                del.setInt(1, id);
                int rows = del.executeUpdate();
                if (rows > 0) {
                    String msg = "Upload deleted";
                    if (!fileDeleted) msg += " (DB removed but file could not be deleted from disk)";
                    resp.sendRedirect(ctx + "/facultyUploads.jsp?msg=" + URLEncoder.encode(msg, "UTF-8"));
                } else {
                    resp.sendRedirect(ctx + "/facultyUploads.jsp?error=" + URLEncoder.encode("Could not remove DB record", "UTF-8"));
                }
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
            resp.sendRedirect(ctx + "/facultyUploads.jsp?error=" + URLEncoder.encode("Server error: " + ex.getMessage(), "UTF-8"));
        }
    }
}
