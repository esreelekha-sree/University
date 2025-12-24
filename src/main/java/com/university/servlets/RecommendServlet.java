package com.university.servlets;

import com.university.ml.MLClient;
import com.university.utils.DatabaseConnection;
import com.google.gson.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/recommend")
public class RecommendServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private MLClient mlClient;

    @Override
    public void init() throws ServletException {
        // ML microservice endpoint
        mlClient = new MLClient("http://127.0.0.1:8000/recommend");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 🔹 Get studentId from session (set during login)
        Integer studentId = (Integer) req.getSession().getAttribute("studentId");

        if (studentId == null) {
            resp.sendRedirect("studentLogin.jsp");
            return;
        }

        String interests = "";

        // 🔹 Fetch interests from database
        try (Connection con = DatabaseConnection.getConnection()) {
            PreparedStatement ps =
                con.prepareStatement("SELECT interests FROM students WHERE id=?");
            ps.setInt(1, studentId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                interests = rs.getString("interests");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 🔹 Java-8 safe empty check
        if (interests == null || interests.trim().isEmpty()) {
            interests = "general";
        }

        // 🔹 NORMALIZE interests (IMPORTANT FIX)
        interests = normalizeInterests(interests);

        // 🔹 Debug (you can remove later)
        System.out.println("ML Interests Used = " + interests);

        // 🔹 Call ML service
        interests = normalizeInterests(interests);
        String json = mlClient.recommendJson(studentId, interests, 5);


        // 🔹 Parse response and forward to JSP
        Gson gson = new Gson();
        JsonObject obj = gson.fromJson(json, JsonObject.class);

        req.setAttribute(
            "recommendationsJson",
            gson.toJson(obj.get("recommendations"))
        );

        req.getRequestDispatcher("/recommendations.jsp")
           .forward(req, resp);
    }

    /**
     * 🔹 Normalizes common abbreviations and variations
     * This solves the OS / DAA / DSA zero-score problem
     */
    private String normalizeInterests(String interests) {
        if (interests == null) return "";

        interests = interests.toLowerCase();

        interests = interests.replace("os", "operating systems");
        interests = interests.replace("cn", "computer networks");
        interests = interests.replace("dbms", "database systems");
        interests = interests.replace("dsa", "data structures algorithms");
        interests = interests.replace("daa", "design analysis algorithms");

        return interests;
    }
}
