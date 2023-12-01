<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap" rel="stylesheet">

<title>Setup</title>
</head>
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
</style>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
$(function()
{
	$.ajaxSetup(
	{
		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		type : "post"
	});

	var add_html = "";
	for(var i = 1; i <= 1440; i++)
	{
		if("${setupMap.devplaykey_limit_min }" == i)
			add_html += "<option value="+ i +"  selected='selected'>" + i + "</option>";
		else
			add_html += "<option value="+ i +">" + i + "</option>";
	}

	$("#devplaykey_limit_min").append(add_html);


	add_html = "";
	for(var i = 1; i <= 30; i++)
	{
		if("${setupMap.eventtime_limit_day }" == i)
			add_html += "<option value="+ i +"  selected='selected'>" + i + "</option>";
		else
			add_html += "<option value="+ i +">" + i + "</option>";
	}

	$("#eventtime_limit_day").append(add_html);
});

function save()
{
	$("#save_btn").prop("disabled", true);

	do
	{
		if("${login_member.member_auth }" != 2)
		{
			alert("권한이 없습니다.");
			break;
		}

		var JSON_DATA = {"devplaykey_limit_min" : $("#devplaykey_limit_min option:selected").val(), "eventtime_limit_day" : $("#eventtime_limit_day option:selected").val()};
		$.ajax({
			type : "post",
			url : "save_setup.do",
			data : JSON.stringify(JSON_DATA),
			contentType : "application/json; charset=UTF-8",
			success : function(data) {
				switch(data)
				{
				case "nopermission":
					alert("권한이 없습니다.");
					break;
				case "success":
					alert("저장되었습니다.");
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
	while(false);

	$("#save_btn").prop("disabled", false);
}
</script>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	<table width="100%">
		<tr>
			<td height="50"></td>
		</tr>
		<tr>
			<td><jsp:include page="top.jsp" /></td>
		</tr>
		<tr>
			<td>
				<center>
					<table border="0" width="100%">
						<tr>
							<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="4" align="center" id="font2">S E T U P</td>
						</tr>
						<tr>
							<td height="30"></td>
						</tr>
						<tr height="0.1">
							<td colspan="4">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<tr height="35">
							<td width="40%" rowspan="3"></td>
							<td colspan="2">1. 영상관제 시스템 설정</td>
							<td width="20%" rowspan="3"></td>
						</tr>
						<tr height="25">
							<td width="14%">OTP 유효 시간</td>
							<td>
								<select id="devplaykey_limit_min" style="width: 80px;vertical-align: 9%;"></select> 분
							</td>
						</tr>
						<tr height="25">
							<td>영상관제 유효기간</td>
							<td>
								<select id="eventtime_limit_day" style="width: 80px;vertical-align: 9%;"></select> 일
							</td>
						</tr>
<!-- 						<tr height="20"></tr> -->
						<tr height="0.1">
							<td colspan="4">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<tr>
							<td height="30"></td>
						</tr>
						<c:if test="${login_member.member_auth == 2 }">
							<tr>
								<td colspan="4" align="center"><input type="button" id="save_btn" style="background: #000000; color: white;" value="저장" onclick="javascript:save()"></td>
							</tr>
						</c:if>
						<tr>
							<td height="30"></td>
						</tr>
						<tr>
							<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="4" align="center" id="font2">P U S H&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;S E R V E R&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A D M I N I S T R A T O R</td>
						</tr>
					</table>
				</center>
			</td>
		</tr>
	</table>
</body>
</html>