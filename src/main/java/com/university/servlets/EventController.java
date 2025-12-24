/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.university.servlets;

//package controllers;

import models.Event;
import com.university.utils.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/addEvent")
public class EventController extends HttpServlet {
	private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("eventName");
        String date = request.getParameter("eventDate");
        String time = request.getParameter("eventTime");
        String location = request.getParameter("eventLocation");
        String description = request.getParameter("eventDescription");

        Event event = new Event();
        event.setEventName(name);
        event.setEventDate(date);
        event.setEventTime(time);
        event.setEventLocation(location);
        event.setEventDescription(description);

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO events (name, date, time, location, description) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, event.getEventName());
            statement.setString(2, event.getEventDate());
            statement.setString(3, event.getEventTime());
            statement.setString(4, event.getEventLocation());
            statement.setString(5, event.getEventDescription());

            int rowsInserted = statement.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("index.html"); // Redirect to index or success page
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error occurred while adding event.");
        }
    }
}
