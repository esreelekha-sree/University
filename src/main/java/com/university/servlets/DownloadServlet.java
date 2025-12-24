package com.university.servlets;

import java.io.*;
import java.nio.file.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/download")
public class DownloadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    private static final String UPLOAD_DIR = "uploads"; // relative to webapp root

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // supports either ?filename=<name> OR ?id=<db id> (DB lookup optional)
        String filename = req.getParameter("filename");
        String idParam = req.getParameter("id");

        if ((filename == null || filename.trim().isEmpty()) && (idParam == null || idParam.trim().isEmpty())) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing file identifier (filename or id)");
            return;
        }

        // If id provided but filename not, optionally implement DB lookup (not required for tests)
        if ((filename == null || filename.trim().isEmpty()) && idParam != null) {
            // Implement lookupSavedFilenameById(...) if you store filenames in DB.
            // filename = lookupSavedFilenameById(Integer.parseInt(idParam));
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "ID lookup not implemented for test; use ?filename=");
            return;
        }

        // Resolve path under deployed webapp
        String webappRoot = getServletContext().getRealPath("/");
        String fullPath;
        if (webappRoot != null) {
            fullPath = Paths.get(webappRoot, UPLOAD_DIR, filename).toString();
        } else {
            // fallback (Tomcat specific)
            fullPath = System.getProperty("catalina.base") + File.separator + "webapps"
                     + File.separator + req.getContextPath().replaceFirst("/", "") + File.separator
                     + UPLOAD_DIR + File.separator + filename;
        }

        System.out.println("[DownloadServlet] Resolved path: " + fullPath);

        File file = new File(fullPath);
        if (!file.exists() || !file.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "File missing on server: " + filename);
            return;
        }

        String mime = getServletContext().getMimeType(file.getName());
        if (mime == null) mime = "application/octet-stream";

        resp.setContentType(mime);
        resp.setContentLengthLong(file.length());
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

        try (BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
             BufferedOutputStream out = new BufferedOutputStream(resp.getOutputStream())) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) out.write(buffer, 0, bytesRead);
        }
    }
}
