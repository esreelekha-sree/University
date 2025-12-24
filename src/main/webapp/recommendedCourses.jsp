<%@ page import="com.google.gson.*" %>
<%
    String recJson = (String) request.getAttribute("recommendationsJson");
    if (recJson == null) recJson = "[]";
    JsonArray recs = JsonParser.parseString(recJson).getAsJsonArray();
%>

<h2 style="color:#0d6efd;">⭐ AI Recommended Courses</h2>

<% if (recs.size() == 0) { %>
    <p>No recommendations available.</p>
<% } else { %>
    <ul style="list-style:none;padding:0">
    <% for (JsonElement e : recs) {
        JsonObject r = e.getAsJsonObject();
        String title = r.get("course_title").getAsString();
        double score = r.get("score").getAsDouble();
    %>
        <li style="margin:10px 0;padding:12px;border-radius:8px;
                   background:#e7f1ff;border-left:6px solid #0d6efd">
            <strong><%= title %></strong>
            <span style="color:#555">(AI score: <%= String.format("%.2f", score) %>)</span>
        </li>
    <% } %>
    </ul>
<% } %>

<hr/>
