package com.university.servlets;

import models.Query;
import com.university.utils.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/resolveQuery")
public class QueryController extends HttpServlet {
	private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the query ID from the request
        int queryId = Integer.parseInt(request.getParameter("id"));
        
        // Fetch the query details for display
        Query query = null;
        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT * FROM queries WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, queryId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                query = new Query();
                query.setId(resultSet.getInt("id"));
                query.setStudentName(resultSet.getString("studentName"));
                query.setQueryText(resultSet.getString("queryText"));
                query.setResolution(resultSet.getString("resolution"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Set query in request attribute and forward to JSP
        request.setAttribute("query", query);
        request.getRequestDispatcher("resolveQuery.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle resolution submission
        int queryId = Integer.parseInt(request.getParameter("id"));
        String resolution = request.getParameter("resolution");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE queries SET resolution = ? WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, resolution);
            statement.setInt(2, queryId);
            statement.executeUpdate();
            response.sendRedirect("viewQueries.jsp"); // Redirect to a page that lists queries
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
