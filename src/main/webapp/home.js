let rating = {
    "q1": 0,
    "q2": 0,
    "q3": 0,
    "q4": 0,
    "q5": 0,
    "q6": 0,
    "q7": 0,
    "q8": 0,
    "q9": 0
};

let subErr = document.getElementById("fb-err");
let op = document.getElementById("op");
let facName = document.getElementById("facName");

let cook = document.cookie.split("=")[1];

let dbUpload = async (rat) => {
    let res;
    let b = new FormData();
    b.append("uname", cook);
    b.append("fac", facName.value);
    b.append("rat", rat);
    b.append("op", op.value);
    await fetch('fb.php', {
        method: "POST",
        body: b
    })
        .then(resp => resp.text())
        .then(data => res = data);
    console.log(res);
    if (res == "") {
        window.location.replace("./tq.html");
    }
}

function logout(){
    document.cookie = "uname=; path=/home;"
    window.location.replace("../login/login.html");
}

function starr(q, st){
    rating["q"+q] = parseInt(st);
    let c = parseInt(st);
    let s;
    while (c > 0){
        s = document.getElementById(q+c.toString());
        s.classList.add("fa-solid");
        s.classList.add("greeen");
        c = c - 1;
    }
    c = parseInt(st) + 1;
    while (c <= 5){
        s = document.getElementById(q+c.toString());
        s.classList.remove("fa-solid");
        s.classList.remove("greeen");
        c = c + 1;
    }
}

function subResp() {
    let c = 0;
    for (let q in rating){
        if (rating[q] == 0){
            let que = document.getElementById(q);
            subErr.textContent = "Please check " + que.textContent;
            break;
        }
        c = c + 1;
    }
    if (c == 9){
        subErr.textContent = "";
        let avg = 0;
        for (let q in rating){
            avg = avg + rating[q];
        }
        avg = parseFloat(avg / 9, 2).toFixed(2);
        dbUpload(avg);
    }
}

function subAno(){
    window.location.replace("./home.html");
}