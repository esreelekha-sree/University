package models;

public class Query1 {
    private int id;
    private String studentName;
    private String queryText;
    private String resolution;

    public Query1(int id, String studentName, String queryText, String resolution) {
        this.id = id;
        this.studentName = studentName;
        this.queryText = queryText;
        this.resolution = resolution;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getQueryText() {
        return queryText;
    }

    public void setQueryText(String queryText) {
        this.queryText = queryText;
    }

    public String getResolution() {
        return resolution;
    }

    public void setResolution(String resolution) {
        this.resolution = resolution;
    }
}
