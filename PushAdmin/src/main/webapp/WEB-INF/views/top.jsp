<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta name="viewport" content="width=,initial-scale="/>
<meta name="description" content="Lavalike css-only menu effect" />
<meta name="keywords" content="css-only menu hover effect transitions" />
<meta name="author" content="PeHaa for PEPSized" />
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap" rel="stylesheet">
<link rel="shortcut icon" href="#">
<link href="https://fonts.googleapis.com/css2?family=Lato:wght@900&display=swap" rel="stylesheet"/>
<title>top</title>
<style>

html {
	line-height: 1;
}
 
body {
	font-family: AR BONNIE;
	font-size: 1em;
	text-shadow: 0 1px 0 white;
}

.nav {
	text-align: center;
	overflow: hidden;
	margin: 0em auto;
	width: 100%;
	position: relative;
}

.nav a {
	display: block;
	position: relative;
	float: left;
	padding: 0em 0 3em;
	width: 11%;
	text-decoration: none;
	color: #393939;
	-webkit-transition: .7s;
	-moz-transition: .7s;
	-o-transition: .7s;
	-ms-transition: .7s;
	transition: .7s;
}

.nav a:hover {
	color: #c6342e;
}

.effect {
	position: absolute;
	left: -9.5%;
	-webkit-transition: 0.7s ease-in-out;
	-moz-transition: 0.7s ease-in-out;
	-o-transition: 0.7s ease-in-out;
	-ms-transition: 0.7s ease-in-out;
	transition: 0.7s ease-in-out;
}

.nav a:nth-child(1):hover ~ .effect {
	left: 5.5%;
}

.nav a:nth-child(2):hover ~ .effect {
	left: 16.5%;
}

.nav a:nth-child(3):hover ~ .effect {
	left: 27.5%;
}

.nav a:nth-child(4):hover ~ .effect {
	left: 38.5%;
}

.nav a:nth-child(5):hover ~ .effect {
	left: 49.5%;
}

.nav a:nth-child(6):hover ~ .effect {
	left: 60.5%;
}

.nav a:nth-child(7):hover ~ .effect {
	left: 71.5%;
}

.nav a:nth-child(8):hover ~ .effect {
	left: 82.5%;
}

.nav a:nth-child(9):hover ~ .effect {
	left: 93.5%;
}


/* ----- line example -----*/
.ph-line-nav .effect {
	width: 90px;
	height: 2px;
	bottom: 36px;
	background: #c6342e;
	box-shadow: 0 1px 0 white;
	margin-left: -45px;
}

 
.nav_ {
	text-align: center;
	overflow: hidden;
	margin: 0em auto;
	width: 100%;
	position: relative;
}

.nav_ a {
	display: block;
	position: relative;
	float: left;
	padding: 0em 0 3em;
	width: 8.3%;
	text-decoration: none;
	color: #393939;
	-webkit-transition: .7s;
	-moz-transition: .7s;
	-o-transition: .7s;
	-ms-transition: .7s;
	transition: .7s;
}

.nav_ a:hover {
	color: #c6342e;
}

.nav_ a:nth-child(1):hover ~ .effect {
	left: 4.1%;
}

.nav_ a:nth-child(2):hover ~ .effect {
	left: 12.4%;
}

.nav_ a:nth-child(3):hover ~ .effect {
	left: 20.7%;
}

.nav_ a:nth-child(4):hover ~ .effect {
	left: 29.1%;
}

.nav_ a:nth-child(5):hover ~ .effect {
	left: 37.4%;
}

.nav_ a:nth-child(6):hover ~ .effect {
	left: 45.6%;
}

.nav_ a:nth-child(7):hover ~ .effect {
	left: 54%;
}

.nav_ a:nth-child(8):hover ~ .effect {
	left: 62.3%;
}

.nav_ a:nth-child(9):hover ~ .effect {
	left: 70.6%;
}

.nav_ a:nth-child(10):hover ~ .effect {
	left: 78.9%;
}

.nav_ a:nth-child(11):hover ~ .effect {
	left: 87.2%;
}

.nav_ a:nth-child(12):hover ~ .effect {
	left: 95.5%;
}

/* ----- line example -----*/
.ph-line-nav_ .effect {
	width: 90px;
	height: 2px;
	bottom: 36px;
	background: #c6342e;
	box-shadow: 0 1px 0 white;
	margin-left: -45px;
}
  
 
</style>
 
 
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">

<div class="ph-line-nav_ nav_">
	<a href="/PushAdmin/ddns_page.do"><b>DDNS</b></a>
	<a href="/PushAdmin/service_page.do"><b>Service</b></a>
	<a href="/PushAdmin/models_page.do"><b>Model</b></a>
	<a href="/PushAdmin/commodity_page.do"><b>Commodity</b></a>
	 
	<a href="/PushAdmin/ddnslog_page.do"><b>DDNS Log</b></a> 
<!-- 	<a href="/PushAdmin/accesslog_page.do"><b>Access Log</b></a>-->
		 
	<a href="/PushAdmin/mobile_page.do"><b>Mobile</b></a>
	<a href="/PushAdmin/register_page.do"><b>Register</b></a>
	<a href="/PushAdmin/allinone_page.do"><b>All In One</b></a>
	<a href="/PushAdmin/p2p_page.do"><b>P2P</b></a>
	<a href="/PushAdmin/setup_page.do"><b>Setup</b></a>
	<a href="/PushAdmin/member_page.do">M<b>ember</b></a>
	<a href="/PushAdmin/logout.do"><b>Logout</b></a>
	<div class="effect"></div>
	<div id="clock"></div>
</div>
 <script>
 function currentTime() {
	  let date = new Date(); 
	  let hh = date.getHours();
	  let mm = date.getMinutes();
	  let ss = date.getSeconds();
	  let session = "AM";

	    
	  if(hh > 12){
	      session = "PM";
	   }

	   hh = (hh < 10) ? "0" + hh : hh;
	   mm = (mm < 10) ? "0" + mm : mm;
	   ss = (ss < 10) ? "0" + ss : ss;
	    
	   let time = hh + ":" + mm + ":" + ss + " " + session;

	  document.getElementById("clock").innerText = time; 
	  var t = setTimeout(function(){ currentTime() }, 1000); 

	}

	currentTime();

  </script>
</body>
</html>