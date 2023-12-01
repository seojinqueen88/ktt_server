<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap" rel="stylesheet">
<link rel="icon" type="image/x-icon" href="favicon.ico">

<script type="text/javascript">

$(function() {
	if(opener && !opener.closed)
	{
		opener.parent.location.reload();
		window.close();
	}

	document.getElementById("member_id").focus();
	
});

function login()
{
	$("#login_btn").prop("disabled", true);

	if($("#member_id").val() == "" || $("#member_pw").val() == "")
	{
		alert("아이디와 비밀번호를 모두 입력해주세요.");
		$("#login_btn").prop("disabled", false);
		return false;
	}
	else
	{
		var JSON_DATA = {"member_id":$("#member_id").val(), "member_pw":$("#member_pw").val()};
		console.log(JSON_DATA);
		$.ajax({
			type : "post",
			url : "login_check.do",
			data : JSON.stringify(JSON_DATA),
			contentType : "application/json; charset=UTF-8",
			success : function(data) {
				switch(data)
				{
				case "success":
					location.href = "/PushAdmin/ddns_page.do";
					break;
				case "incorrect":
					alert("아이디 또는 비밀번호를 다시 확인하세요.");
					$("#member_id").val("");
					$("#member_pw").val("");
					$("#member_id").focus();
					$("#login_btn").prop("disabled", false);
					break;
				default:
					alert("관리자에게 문의하세요.");
					break;
				}
			},
			error : function(request,status,error) {
	       		alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	       	}
		});
	}
}

function onKeyDown()
{
	if(event.keyCode == 13)
	{
		login();
	}
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login</title>

<style type="text/css">
#font1 {
	font-family: Tahoma;
	font-size: 11px;
}

#font2 {
	color: #555555;
	font-family: Arial;
	font-size: 13px;
}
input .login_btn:active
{
	background-color: #6F6F6F
}
body{
    animation: fadein 2000ms ease-out;
    -moz-animation: fadein 2000ms ease-out; /* Firefox */
    -webkit-animation: fadein 2000ms ease-out; /* Safari and  Chrome */
    -o-animation: fadein 2000ms ease-out; /* Opera */
}
@keyframes fadein {
    from {opacity:0;}
    to {opacity:1;}
}
@-moz-keyframes fadein { /* Firefox */
    from {opacity:0;}
    to {opacity:1;}
}
@-webkit-keyframes fadein { /* Safari and Chrome */
    from {opacity:0;}
    to {opacity:1;}
}
@-o-keyframes fadein { /* Opera */
    from {opacity:0;}
    to {opacity: 1;}
}

</style>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	<table border="0" width="100%">
		<tr>
			<td height="50"></td>
		</tr>
		<tr>
			<td>
				<center>
					<table border="0" width="800">
						<tr>
							<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="5" align="center" id="font2">W E L C O M E</td>
						</tr>
						
						<tr>
							<td style="padding: 150px; padding-top: 50px; padding-bottom: 50px; text-align: center;">
								<div style="width: 300px; border-style: solid; border-color: #c8c8c8; border-width: 1px; padding: 30px; padding-left: 100px; padding-right: 100px; padding-bottom: 50px;">
									<table align="center">
										<c:choose>
											<c:when test="${login_member != null}">
												<tr>
													<td>로그인 중입니다.</td>
												</tr>
												<tr>
													<td>
														<input type="button" onclick="location.href='/PushAdmin/ddns_page.do'" style="background: #000000; color: white;" value="start">
													</td>
												</tr>
											</c:when>
											<c:otherwise>
												<tr>
													<td height="50" id="font1">
														ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input type="text" style="border-style: hidden;" id="member_id"><br>
														<p style="border-style: solid; border-color: #c8c8c8; border-bottom:medium; border-width: 1px;"></p>
														PW&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input type="password" style="border-style: hidden;" id="member_pw" onKeyDown="onKeyDown();">
													</td>
													<td>
														<input type="button" onclick="login()" id="login_btn"  class="login_btn"  style="width: 60px; height: 60px; background: #353535; border-color: white; font-family: Arial; font-size: 11px; color: #FFFFFF; border: 0px;" value="LOGIN">
													</td>
												</tr>
											</c:otherwise>
										</c:choose>
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="7" align="center" id="font2">P U S H&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;S E R V E R&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A D M I N I S T R A T O R</td>
						</tr>
					</table>
				</center>
			</td>
		</tr>
	</table>
</body>
</html>