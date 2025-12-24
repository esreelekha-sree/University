package models;

public class Marks {
    private int id;
    private int studentId;
    private String courseName;
    private int mark;

    public Marks(int id, int studentId, String courseName, int mark) {
        this.id = id;
        this.studentId = studentId;
        this.courseName = courseName;
        this.mark = mark;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public int getMark() {
        return mark;
    }

    public void setMark(int mark) {
        this.mark = mark;
    }
}
