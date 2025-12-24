package com.university.ml;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

public class MLClient {
    private final String endpoint;

    public MLClient(String endpoint) {
        this.endpoint = endpoint; 
    }

    public String recommendJson(int studentId, String interests, int topK) throws IOException {
        URL url = new URL(endpoint);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setDoOutput(true);
        con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

        String payload = String.format(
            "{\"student_id\":%d,\"interests\":%s,\"top_k\":%d}",
            studentId, jsonEscape(interests), topK
        );

        try (OutputStream os = con.getOutputStream()) {
            os.write(payload.getBytes(StandardCharsets.UTF_8));
        }

        int code = con.getResponseCode();
        InputStream is = (code >= 200 && code < 300) ? con.getInputStream() : con.getErrorStream();

        BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) sb.append(line);

        con.disconnect();
        return sb.toString();
    }

    private String jsonEscape(String s) {
        if (s == null) return "\"\"";
        s = s.replace("\\", "\\\\").replace("\"", "\\\"");
        return "\"" + s + "\"";
    }
}
