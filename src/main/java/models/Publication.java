//package models;
//
//public class Publication {
//    private final int id;
//    private final String title;
//    private final String content;
//    private final String author;
//    private final String datePosted;
//
//    public Publication(int id, String title, String content, String author, String datePosted) {
//        this.id = id;
//        this.title = title;
//        this.content = content;
//        this.author = author;
//        this.datePosted = datePosted;
//    }
//
//    // Implement getter methods properly
//    public int getId() {
//        return id;
//    }
//
//    public String getTitle() {
//        return title; // Make sure this is implemented
//    }
//
//    public String getContent() {
//        return content;
//    }
//
//    public String getAuthor() {
//        return author;
//    }
//
//    public String getDatePosted() {
//        return datePosted;
//    }
//
//    // Implement setter methods if needed
//}




// File: university/model/Publication.java
package models;

public class Publication {
    private int id;
    private String title;
    private String content;
    private String author;
    private String datePosted;

    public Publication(int id, String title, String content, String author, String datePosted) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.author = author;
        this.datePosted = datePosted;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public String getAuthor() {
        return author;
    }

    public String getDatePosted() {
        return datePosted;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public void setDatePosted(String datePosted) {
        this.datePosted = datePosted;
    }
}
