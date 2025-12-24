<%-- 
    Document   : main
    Created on : 18-Dec-2023, 10:06:35 pm
    Author     : suhan
--%>



<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="main.css" type="text/css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
    </head>
    <body>
        
    <header >
        <nav id="navbar" >
<!--            <a href="#"><img src="Images/download1.jpeg"></a>-->
            <div class="nav-links">
                <ul>
                    <li><a href="" >HOME</a></li>
                    <li><a href="#dept-about" >ABOUT</a></li>
                    <li><a href="#dept-highlights" >HIGHLIGHTS</a></li>                   
                    <li><a href="#dept-events" >EVENTS</a></li>
<!--                    <li><a href="#dept-contact" >Contact Us</a></li>-->
                    <li><a href="facultyPortal.jsp" >FACULTY</a></li>
                    <li><a href="studentPortal.jsp" >STUDENT</a></li>

                    <%-- admin link: show login if not signed in, otherwise portal  --%>
                    <% 
                        String adminEmail = (String) session.getAttribute("adminEmail");
                    %>
                    <li>
                        <% if (adminEmail == null) { %>
                            <a href="adminLogin.jsp">ADMIN</a>
                        <% } else { %>
                            <a href="adminPortal.jsp">ADMIN</a>
                            &nbsp;&nbsp;
                           <!-- <a href="adminLogout.jsp">Logout</a> --> 
                        <% } %>
                    </li>

                     <li><a href="financeLogin.jsp" >finance officer</a></li>
                </ul>
            </div>
        </nav>

        <div class="text-box">
            <br><br><br><br><br><br>
            <h1 class="text-light">****UNIVERSITY INTEGRATED SERVICES****</h1>
            <p class="text-light"><b>RAJIV GANDHI UNIVERSITY OF KNOWLEDGE AND TECHNOLOGIES , RK VALLEY CAMPUS , ANDHRA PRADESH..</b></p>
            <a href="departments.jsp"  class="login-btn"><b>AVAILABLE DEPARTMENTS</b></a>
        </div>
        <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
    </header>
   
        <div class="container-big-1 p-5" id="dept-about"><br>
            <h1 class="text-center mx-auto col-md-4 p-3" id="headings">DEPARTMENT</h1>                     
            
            <div class="dept-hod mx-auto col-md-9 text-center p-5 mt-5">
                <h3 >VISION AND MISSION</h3><!-- comment -->
                <h5 class="mt-3">The department of CSE at RGUKT RK valley, established in 2010</h5>
                <p class="mt-3">Strives to create knowledge pool of computer science and engineering professionals 
                    by providing a learning platform to the students and thereby providing a good 
                    quality education to all.</p>
                <p><b>The mission of the department is</b><br>
                    • To mold the students into responsible citizens and competent professionals by 
                    imparting contemporary technical skills and social ethics. <br><br>
                    • Build a domain knowledge base at the department level in order to give impetus
                    to research and development activities and thereby contributing towards 
                    development of computer science and engineering field.</p>
            </div>
            
<!--            <div class="dept-hod row col-md-9 mx-auto p-3 mt-5">
                <div class="col col-md-4 ms-3">
                    <img src="Images/hod.jpg" width="250px" height="210px">
                </div>
                <div class="col col-md-5 mt-4 ms-5">
                    <h5>HEAD OF THE DEPARTMENT</h5><br>
                    <b>NAME : </b> SatyaNandaram<br><br> comment 
                    <b>EDUCATION : </b> MSIT (IIIT H)  <br><br> comment 
                    <b>EMAIL : </b> satyanandaram@rguktrkv.ac.in<br><br>
                </div>
            </div>            -->
            
            
            
        </div>    
        
          
        
    <div class="container-big-2 p-5">
        <div class="gallery-wrap p-5">
            <img src="Images/back.png" id="backbtn">
            <div class="gallery">
            <div>
                <span><img src="Images/CSE_DEPT.JPG"></span>
                <span><img src="Images/cse1.jpeg"></span>
                <span><img src="Images/cse3.jpeg"></span>
            </div>
            <div>
                <span><img src="Images/cse2.jpg"></span>
                <span><img src="Images/cse1.jpeg"></span>
                <span><img src="Images/cse3.jpeg"></span>
            </div>
            <div>
                <span><img src="Images/CSE_DEPT.JPG"></span>
                <span><img src="Images/cse1.jpeg"></span>
                <span><img src="Images/cse3.jpeg"></span>
            </div>                
        </div>
            <img src="Images/next.png" id="nextbtn">
        </div>
            
    </div>
        


    <!--<div class="container-big-3 px-2 mt-5">
                <h1 class="container text-center"><br><br>DEPARTMENT HIGHLIGHTS</h1><br><br><br>
                <div class="container">
                    
                    <div class="row justify-content-between text-center gy-5" id="row">

                        <div class="card col-md-4 col-sm-12 pt-3 " id="card">
                            <img src="images/library.png" class="card-img-top" height="200px">
                            <div class="card-body">
                                <hr>
                            <h5 class="card-title">world class library</h5>
                            <p class="card-text">providing all types of books with peaceful place.</p>
                            
                            </div>
                        </div>
                        
                        <div class="card col-md-3 col-sm-12 pt-3" id="card2">
                            <img src="images/basketball.png" class="card-img-top " height="200px">
                            <div class="card-body"><hr>
                            <h5 class="card-title">Largest play ground</h5>
                            <p class="card-text">providing all equipment for playing specially trained for national sports meets.</p>
                            
                            </div>
                        </div>

                        <div class="card col-md-4 col-sm-12 pt-3" id="card3">
                            <img src="images/cafeteria.png" class="card-img-top" height="200px">
                            <div class="card-body"><hr>
                            <h5 class="card-title">Tasty and healthy food</h5>
                            <p class="card-text">providing tasty and healthy food. Varients of food avialable.</p>
                            </div>
                        </div>
                    </div>
                    <br><br><br><br>
                </div>
    </div>-->



    <div class="container-big-4 mt-5" id="dept-highlights"><br>
<h1 class="text-center col-md-5 mx-auto my-3 p-3" id="headings" >DEPARTMENT HIGHLIGHTS</h1><br><br><br>

    <div class="container-big-4-bg">

    </div>
    
    <div class="container-big-4-1 ">
        <div class="library row ">
            <div class="image col col-md-6 text-center">
                <img src="Images/library.png" class="col-md-5">
            </div>
            <div class="text col col-md-4 text-start">
                <h5 class="">world class library</h5>
                <p >providing all types of books related to technical and Computer Sciences.</p>
                <p>Active from 9:00am to 7:00pm</p>
            </div>
                 
        </div>
    </div>

    <div class="container-big-4-2">
        <div class="ground row ">
            <div class="col col-1"></div>
            <div class="text col col-md-4 text-start mt-5">
                <h5 >Computer Laboratories</h5>
                <p >provide excellent training and guidance to the students in Computers and Technology.</p>
            </div>
            
            <div class="image col col-md-6 text-center">
                <img src="Images/lab.jpg" class="col-md-5" >
            </div>            
                 
        </div>
    </div>             
      

<div class="container-big-4-3-bg">
    
</div>
         
    <div class="container-big-4-3">
        <div class="plantation row ">
            <div class="image col col-md-6 text-center">
                <img src="Images/coding_com.jpeg" class="col-md-5">
            </div>
            <div class="text col col-md-4 text-start">
                <h5 class="">Coding Competitions</h5>
                <p >We encourage our students to actively participate
                and compete with their co-peers in various coding competitions!</p>
            </div>
                 
        </div>
    </div>                  

    </div>
    
    
    
    
    
    
          <div class="container-big-6"><br><br><br><br>
            <h1 class="text-center mt-5">Our alumni are currently working in</h1><Br>
                <div class="caro-container">

                        <div id="carouselExampleInterval" class="carousel slide col-md-10 m-auto" data-bs-ride="carousel">
                            <div class="carousel-inner px-5">

                            <div class="carousel-item active " data-bs-interval="2000">
                                <div class="d-flex m-auto justify-content-around px-5">
                                    <img src="Images/1.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/2.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/3.webp" class="d-flex " alt="..." width="230px" height="80px">
                                </div>
                            </div>

                            <div class="carousel-item " data-bs-interval="2000">
                                <div class="d-flex m-auto justify-content-around px-5">
                                    <img src="Images/2.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/3.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/4.webp" class="d-flex " alt="..." width="230px" height="80px">
                                </div>
                            </div>

                            <div class="carousel-item " data-bs-interval="2000">
                                <div class="d-flex m-auto justify-content-around px-5">
                                    <img src="Images/3.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/4.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/5.webp" class="d-flex " alt="..." width="230px" height="80px">
                                </div>
                            </div>

                            <div class="carousel-item " data-bs-interval="2000">
                                <div class="d-flex m-auto justify-content-around px-5">
                                    <img src="Images/4.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/5.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/6.webp" class="d-flex " alt="..." width="230px" height="80px">
                                </div>
                            </div>

                            <div class="carousel-item " data-bs-interval="2000">
                                <div class="d-flex m-auto justify-content-around px-5">
                                    <img src="Images/5.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/6.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/7.webp" class="d-flex " alt="..." width="230px" height="80px">
                                </div>
                            </div>

                            <div class="carousel-item">
                                <div class="d-flex m-auto justify-content-around px-5">
                                    <img src="Images/6.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/7.webp" class="d-flex  " alt="..." width="230px" height="80px">
                                    <img src="Images/8.webp" class="d-flex " alt="..." width="230px" height="80px">
                                </div>
                            </div>


                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleInterval" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleInterval" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Next</span>
                            </button>
                        </div>
                    <br><br><br><br>
                </div>
            </div>


    
    
    
    
        
    <div class="container-big-7 p-5" id="dept-events">
        <h1 id="headings" class="text-center mx-auto col-md-7 p-3 my-3">EVENTS AND CULTURAL PROGRAMS</h1>
        <div class="gallery1-wrap p-5">
            <img src="Images/back.png" id="backbtn1">
            <div class="gallery1">
            <div>
                <span><img src="Images/event1.jpg"></span>
                <span><img src="Images/event2.jpg"></span>
                <span><img src="Images/event3.jpg"></span>
            </div>
            <div>
                <span><img src="Images/event8.jpg" ></span>
                <span><img src="Images/event4.jpeg"></span>
                <span><img src="Images/event5.jpeg"></span>
            </div>
            <div>
                <span><img src="Images/event6.jpeg"></span>
                <span><img src="Images/event9.jpg"></span>
                <span><img src="Images/event10.jpg"></span>
            </div>   
            <div>
                <span><img src="Images/event11.jpg"></span>
                <span><img src="Images/event12.jpg"></span>
                <span><img src="Images/event13.JPG"></span>
            </div>                 
        </div>
            <img src="Images/next.png" id="nextbtn1">
        </div>
            
    </div>
    
    

    
    <div class="container-big-8">
        <h1 id="headings" class="text-center mx-auto col-md-3 p-3 mt-5">CLUBS</h1><br>
       <div class="container mx-auto row justify-content-between m-5">           
            <div class="card pt-3" style="width:20em;">
                <img src="Images/placement.jpeg" class="card-img-top col-md-8" height="200px" alt="...">
                <div class="card-body text-center">
                  <h5 class="card-title">PLACEMENT PREPARATION CLUB</h5>
                  <p class="card-text">The mission is to assist students in developing the necessary skills and knowledge in the recruitment process.</p>

                </div>
            </div>
           
            <div class="card pt-3" style="width:20em;">
                <img src="Images/coding.jpeg" class="card-img-top" height="200px" alt="...">
                <div class="card-body text-center">
                  <h5 class="card-title">CODING CLUB</h5>
                  <p class="card-text">It helps our students an opportunity to learn the  basics of computer programming in a team setting. </p>

                </div>
            </div>

            <div class="card pt-3" style="width:20em;">
                <img src="Images/skillboosting.jpeg" class="card-img-top" height="200px" alt="...">
                <div class="card-body text-center">
                  <h5 class="card-title">SKILL BOOSTING</h5>
                  <p class="card-text">It unlocks the doors to enhance our student skills to land in high paying jobs and internship offers.</p>

                </div>
            </div>

           
       </div>
    </div>
    
    
    

            <div class="container-big-9 py-5">
                <div class="container py-3">
                <h1 class="text-center">Frequently Asked Question</h1><br><br>

                <div class="accordion" id="accordionExample">
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" >
                            <h5 class="text-dark"> What resources are available for CSE students, such as libraries and computing facilities?</h5>
                        </button>
                        </h2>
                        <div id="collapseOne" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
                        <div class="accordion-body">
                            The CSE department provides access to well-equipped libraries, computer labs, and online resources. Our students have access to the latest software and hardware for their academic and research needs.
                        </div>
                        </div>
                    </div>
                    <br>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" >
                        <h5 class="text-dark">Are there opportunities for internships and industry collaborations?</h5>
                        </button>
                        </h2>
                        <div id="collapseTwo" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
                        <div class="accordion-body">
                            Yes, the CSE department facilitates internships and has strong ties with industry partners. Our students often participate in internships and collaborative projects with leading companies.
                        </div>
                        </div>
                    </div>
                    <br>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" >
                        <h5 class="text-dark">Which companies hire our Students?</h5>
                        </button>
                        </h2>
                        <div id="collapseThree" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
                        <div class="accordion-body">
                        There are 30+ companies who have hired our students in the past. Industry Giants like Amazon,
                         Flipkart, Walmart Labs, AWS, Microsoft, Zomato are some of the names comprising this list.
                        </div>
                        </div>
                    </div>
                    <br>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour" >
                        <h5 class="text-dark">What are the admission requirements for the CSE programs?</h5>
                        </button>
                        </h2>
                        <div id="collapseFour" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
                        <div class="accordion-body">
                            Admission requirements vary for each program. Please visit the Admissions section on our website for detailed information on eligibility criteria and application procedures.
                        </div>
                        </div>
                    </div>
                    <br>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFive" >
                        <h5 class="text-dark"> Can I visit the campus and tour the CSE facilities?</h5>
                        </button>
                        </h2>
                        <div id="collapseFive" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
                        <div class="accordion-body">
                        Yes, we encourage prospective students to schedule a campus visit. You can explore our state-of-the-art laboratories, classrooms, and interact with faculty members. Please contact the Admissions Office to schedule a tour.
                        </div>
                        </div>
                    </div>
                    <br>
                    <div class="accordion-item ">
                        <h2 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseSix" >
                        <h5 class="text-dark">How can I get involved in student organizations related to CSE?</h5>
                        </button>
                        </h2>
                        <div id="collapseSix" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
                        <div class="accordion-body">
                        We have several student organizations, including coding club, skill boosting, and placement preparation club. Visit the Student Life section for details on how to join and participate.

                        </div>
                        </div>
                    </div>


                    </div>
                </div>
            </div>





            <div class="container-big-10 bg-dark py-5 px-2" id="dept-alumines">
                <div class="container"><br>
                        <h3 class="text-center text-light mb-5 p-3 col-md-7 mx-auto" id="headings">ALUMINES CURRENTLY WORKING IN MNCs</h3><Br><br>
                        <div class="row g-5 justify-content-evenly  ">

                        <div class="card col-md-4 col-sm-12 pt-4  text-center  " id="review1">
                            <div class="card-body ">
                                <h5 class="card-title text-center">Varun</h5>
                                <span style="color:grey;">CISCO SYSTEMS -12LPA</span>
                                <p class="card-text text-center pt-2"> Passion for learning new technologies and working on them helped me to get this oppurtunity.Support from the hod sir and the other faculty hepled me to overcome the difficult situations.
                                </p>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star-half-alt text-warning"></i>
                            
                            </div>
                            <span class="position-absolute top-0 start-50 translate-middle border border-light rounded-circle">
                                <img src="Images/student3.jpeg" height="70px" width="70px" class="rounded-circle">   
                            </span>

                        </div>





                        <div class="card col-md-4 col-sm-12 pt-4 position-relative text-center" id="review1">
                            <div class="card-body ">
                                <h5 class="card-title text-center">Naga Sowrav</h5>
                                <span style="color:grey;">GOOGLE -20LPA</span>
                                <p class="card-text text-center pt-2">COllege is stress free environment and the unconditional support from the hod and department faculty helped me achieve and had significant impact on my achievement.The experiential learning program at microsoft,wise has enhanced my technical capabilities. 
                                </p>

                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="far fa-star text-warning"></i>

                                
                            </div>
                                <span class="position-absolute top-0 start-50 translate-middle border border-light rounded-circle">
                                    <img src="Images/student2.jpeg" height="70px" width="70px" class="rounded-circle">   
                                </span>
                        </div>


                        <div class="card col-md-4 col-sm-12 pt-4 position-relative text-center mx-4" id="review1">
                            <div class="card-body ">
                                <h5 class="card-title text-center ">Manvika Shetty</h5>
                                <span style="color:grey;">META -22LPA</span>
                                <p class="card-text text-center pt-2">knowledge gained through working on projects and a strong understanding of basic networking concepts and skills i have developed through placement training conducted by the college helped me crack the Meta interview.I like to thank our hod for notifying us about job opportunities.
                                </p>

                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                                        
                            </div>
                            <span class="position-absolute top-0 start-50 translate-middle border border-light rounded-circle">
                                <img src="Images/student1.jpeg" height="70px" width="70px" class="rounded-circle">   
                            </span>
                        </div>


                    </div>
                    <br><br><br>
                </div>
            </div>



          <div class="footer bg-light text-dark" id="dept-contact">
                <div class="container pt-5">
                    <div class="row text-center">
                        <div class="col-md-4 col-sm-12">
                            <h5 class="">About Us</h5>
                            <p> <b class="text-success">DEPARTMENT OF CSE</b><br>
                                RGUKT RKVALLEY <br>
                                
                                <br>
                            </p>
                        </div>
                        <div class="col-md-4 col-sm-12">
                        <h5 class="">Contact Us</h5>
                            <p>deptofcse@rguktrkv.ac.in<br>
                                Andhra Pradesh,India.
                            </p>
                        </div>
                        <div class="col-md-4 col-sm-12">
                            <h5 class="">Social Media</h5><br>
                            <i class="fab fa-telegram" style="font-size: 35px;"></i>&nbsp &nbsp &nbsp &nbsp
                            <i class="fab fa-instagram" style="font-size: 35px;"></i>&nbsp &nbsp &nbsp &nbsp
                            <i class="fab fa-facebook" style="font-size: 35px;"></i>
                            
                        </div>
                    </div>
                </div>
            </div>  

    
    </body>
    
    
    
        <script>
            let scroll=document.querySelector(".gallery");
            let backbtn=document.getElementById("backbtn");
            let nextbtn=document.getElementById("nextbtn");
            
            scroll.addEventListener("wheel",e=>{
                e.preventDefault();
                scroll.scrollLeft+=e.deltaY;
            });
            
            backbtn.addEventListener("click",()=>{
                scroll. style.scrollBehavior="smooth";
                scroll.scrollLeft-=300;
            });
            
            nextbtn.addEventListener("click",()=>{
                scroll.style.scrollBehavior="smooth";
                scroll.scrollLeft+=300;
            });
            
            let scroll1=document.querySelector(".gallery1");
            let backbtn1=document.getElementById("backbtn1");
            let nextbtn1=document.getElementById("nextbtn1");
            
            scroll1.addEventListener("wheel",e=>{
                e.preventDefault();
                scroll1.scrollLeft+=e.deltaY;
            });
            
            backbtn1.addEventListener("click",()=>{
                scroll1. style.scrollBehavior="smooth";
                scroll1.scrollLeft-=350;
            });
            
            nextbtn1.addEventListener("click",()=>{
                scroll1.style.scrollBehavior="smooth";
                scroll1.scrollLeft+=350;
            });            
        </script>
    
</html>
