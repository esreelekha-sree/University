<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.google.gson.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>AI Recommendations</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 20px;
        }
        h2 {
            color: #0d6efd;
        }
        ul {
            list-style: none;
            padding: 0;
        }
        li {
            background: #ffffff;
            margin-bottom: 10px;
            padding: 12px 16px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
        }
        .score {
            color: #555;
            font-size: 14px;
        }
        .back {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            font-weight: bold;
            color: #0d6efd;
        }
    </style>
</head>

<body>

<h2>Recommended Courses for You</h2>

<%
    String recJson = (String) request.getAttribute("recommendationsJson");

    if (recJson == null || recJson.trim().isEmpty()) {
%>
        <p>No recommendations available at the moment.</p>
<%
    } else {
        JsonArray recs = JsonParser.parseString(recJson).getAsJsonArray();

        if (recs.size() == 0) {
%>
            <p>No matching courses found.</p>
<%
        } else {
%>
            <ul>
<%
            for (JsonElement e : recs) {
                JsonObject r = e.getAsJsonObject();

                // SAFE access
                String title = "Unknown Course";
                if (r.has("course_title") && !r.get("course_title").isJsonNull()) {
                    title = r.get("course_title").getAsString();
                }

                double score = 0.0;
                if (r.has("score") && !r.get("score").isJsonNull()) {
                    score = r.get("score").getAsDouble();
                }
%>
                <li>
                    <strong><%= title %></strong><br>
                    <span class="score">Score: <%= String.format("%.3f", score) %></span>
                </li>
<%
            }
%>
            </ul>
<%
        }
    }
%>

<a class="back" href="studentPortal.jsp">← Back to Student Portal</a>

</body>
</html>
