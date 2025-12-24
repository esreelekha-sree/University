package com.university.servlets;

import com.university.utils.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * UploadServlet handles file uploads from faculty and lists faculty's uploads (GET).
 */
@WebServlet("/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1MB before writing to disk
    maxFileSize = 50L * 1024 * 1024,      // 50MB per file
    maxRequestSize = 200L * 1024 * 1024   // 200MB total
)
public class UploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // You can change this to an absolute path outside the webapp if desired
    private String ensureUploadsDir(jakarta.servlet.ServletContext ctx) {
        // store inside webapp: <webapp>/uploads
        String path = ctx.getRealPath("/uploads");
        if (path == null) {
            // fallback (container may return null): use temp directory
            path = System.getProperty("java.io.tmpdir") + File.separator + "university-uploads";
        }
        File d = new File(path);
        if (!d.exists()) d.mkdirs();
        return d.getAbsolutePath();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // show list of uploads for the logged-in faculty
        String facultyEmail = (String) req.getSession().getAttribute("facultyEmail");
        if (facultyEmail == null) {
            resp.sendRedirect(req.getContextPath() + "/facultyLogin.jsp");
            return;
        }

        List<Map<String,Object>> uploads = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, original_filename, saved_filename, content_type, size_bytes, uploaded_at " +
                         "FROM uploads WHERE faculty_email = ? ORDER BY uploaded_at DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, facultyEmail);
                try (java.sql.ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String,Object> m = new HashMap<>();
                        m.put("id", rs.getInt("id"));
                        m.put("original_filename", rs.getString("original_filename"));
                        m.put("saved_filename", rs.getString("saved_filename"));
                        m.put("content_type", rs.getString("content_type"));
                        m.put("size_bytes", rs.getLong("size_bytes"));
                        m.put("uploaded_at", rs.getTimestamp("uploaded_at"));
                        uploads.add(m);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error while loading uploads: " + e.getMessage());
        }

        req.setAttribute("uploads", uploads);
        req.getRequestDispatcher("/facultyUploads.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String facultyEmail = (String) req.getSession().getAttribute("facultyEmail");
        if (facultyEmail == null) {
            resp.sendRedirect(req.getContextPath() + "/facultyLogin.jsp");
            return;
        }

        Part filePart = null;
        try {
            // The input field name in the form must be "file"
            filePart = req.getPart("file");
        } catch (Exception ex) {
            req.setAttribute("error", "Unable to process parts as no multi-part configuration has been provided: " + ex.getMessage());
            doGet(req, resp);
            return;
        }

        if (filePart == null || filePart.getSize() == 0) {
            req.setAttribute("error", "No file selected.");
            doGet(req, resp);
            return;
        }

        String uploadsDir = ensureUploadsDir(getServletContext());
        String originalFileName = getSubmittedFileName(filePart);
        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            originalFileName = "upload";
        }

        // build a safe saved filename: timestamp + original name
        String savedFileName = System.currentTimeMillis() + "_" + originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
        File saved = new File(uploadsDir, savedFileName);

        // copy to disk
        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, saved.toPath(), StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException ioe) {
            ioe.printStackTrace();
            req.setAttribute("error", "Failed to save file: " + ioe.getMessage());
            doGet(req, resp);
            return;
        }

        // store metadata in DB
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO uploads (faculty_email, original_filename, saved_filename, content_type, size_bytes) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, facultyEmail);
                ps.setString(2, originalFileName);
                ps.setString(3, savedFileName);
                ps.setString(4, filePart.getContentType());
                ps.setLong(5, filePart.getSize());
                ps.executeUpdate();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            req.setAttribute("error", "Server error while recording upload: " + ex.getMessage());
            // optional: delete saved file if DB insert failed
            saved.delete();
            doGet(req, resp);
            return;
        }

        req.setAttribute("msg", "Upload successful.");
        // show list again (GET will forward to facultyUploads.jsp)
        doGet(req, resp);
    }

    // Helper to get filename across servlet containers
    private static String getSubmittedFileName(Part part) {
        if (part == null) return null;
        String cd = part.getHeader("content-disposition");
        if (cd == null) return null;
        for (String token : cd.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                // some browsers send full path, pick only file name
                return new File(name).getName();
            }
        }
        return null;
    }
}
