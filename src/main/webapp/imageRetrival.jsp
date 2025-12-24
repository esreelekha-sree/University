<%-- 
    Document   : imageRetrival
    Created on : 03-Jan-2024, 10:47:08 pm
    Author     : suhan
--%>


<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Display Image from Database</title>
</head>
<body>

<%
    // Replace these variables with your database connection details
    String url = "jdbc:mysql://localhost:3306/University";
    String username = "root";
    String password = "dosha@1314";

    Connection connection = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(url, username, password);

        // Replace "your_table" and "image_column" with your actual table and column names
        String sql = "SELECT photo FROM contacts";
        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            // Set the image ID (replace 1 with the actual image ID)
            //preparedStatement.setInt(1, 1);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    // Retrieve image data
                    byte[] imageData = resultSet.getBytes("photo");

                    // Convert image data to Base64
                    String base64Image = Base64.getEncoder().encodeToString(imageData);

                    // Display the image on the web page
%>
                    <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Image">
<%
                } else {
                    out.println("Image not found");
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

</body>
</html>