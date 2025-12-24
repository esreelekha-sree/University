package com.university.servlets;

import java.io.File;
import java.io.InputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ImageUpload")
@MultipartConfig(fileSizeThreshold = 1024 * 50,    // 50KB
                 maxFileSize = 1024 * 1024 * 8,     // 8MB
                 maxRequestSize = 1024 * 1024 * 16) // 16MB
public class ImageUploadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean allowed(String name) {
        String n = name.toLowerCase();
        return n.endsWith(".jpg") || n.endsWith(".jpeg") || n.endsWith(".png") || n.endsWith(".gif") || n.endsWith(".webp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part part = request.getPart("imageFile");
        if (part == null || part.getSize() == 0) {
            request.setAttribute("uploadMsg", "No file selected.");
            request.setAttribute("uploadOK", "false");
            request.getRequestDispatcher("uploadImage.jsp").forward(request, response);
            return;
        }

        String submitted = part.getSubmittedFileName();
        if (submitted == null || submitted.trim().isEmpty()) {
            request.setAttribute("uploadMsg", "Invalid file.");
            request.setAttribute("uploadOK", "false");
            request.getRequestDispatcher("uploadImage.jsp").forward(request, response);
            return;
        }

        if (!allowed(submitted)) {
            request.setAttribute("uploadMsg", "Only jpg, png, gif, webp allowed.");
            request.setAttribute("uploadOK", "false");
            request.getRequestDispatcher("uploadImage.jsp").forward(request, response);
            return;
        }

        String safeName = System.currentTimeMillis() + "_" + submitted.replaceAll("[^a-zA-Z0-9._-]", "_");
        String imagesPath = getServletContext().getRealPath("/Images");
        File imagesDir = new File(imagesPath);
        if (!imagesDir.exists()) imagesDir.mkdirs();

        File file = new File(imagesDir, safeName);

        try (InputStream in = part.getInputStream();
             FileOutputStream out = new FileOutputStream(file)) {
            byte[] buf = new byte[4096];
            int len;
            while ((len = in.read(buf)) > 0) out.write(buf, 0, len);
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("uploadMsg", "Upload failed: " + ex.getMessage());
            request.setAttribute("uploadOK", "false");
            request.getRequestDispatcher("uploadImage.jsp").forward(request, response);
            return;
        }

        request.setAttribute("uploadMsg", "Uploaded successfully: " + safeName);
        request.setAttribute("uploadOK", "true");
        request.getRequestDispatcher("uploadImage.jsp").forward(request, response);
    }
}
