<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap" rel="stylesheet">

<style>
body {
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: FCFAF9;
  z-index: 1;
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
}
.ddns_btn {
	justify-content: center;
	display: flex;
	margin-top: 10px;
}
#service_table {
	width: 100%;
	font-size: 18px;
}
.service_table_td input[type="text"]{
	border: 0px;
	width: 350px;
	padding-left: 5px;
	font-size: 18px;
}
#service_user_select {
	width: 150px;
	font-size: 16px;
	text-align: center;
}
.ddns_btn input[type="button"] {
	margin-right: 5px;
}
</style>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DDNS</title>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
var mac = "${mac }";
var domain = "${domain }";
var service_user = "${service_user }";

function service_user_mod(value) 
{
	console.log(value);
	console.log(service_user);
	if(value==service_user)
	{
		alert("DDNS 상태가 변경되지 않았습니다.\n"
				+"상태를 변경하지 않으려면 취소를 눌러주세요");
		console.log("sevice_user가 같습니다. >>>> " + value);
	} 
	else if (value!=service_user)
	{		
		console.log("sevice_user가 다릅니다. >>>> " + value);
	}
}
function service_user_modify(){
	var modify_service_user = $("#service_user_select option:selected").val();
	console.log("domain: " + domain + "  mac: " +  mac + "  service_user: " + modify_service_user);
	var JSON_DATA = {"domain": domain, "mac": mac, "service_user": modify_service_user};
	if(modify_service_user == service_user)
	{
		console.log("sevice_user가 같습니다. >>>> " + value);
		alert("DDNS 상태가 변경되지 않았습니다.\n"
				+"상태를 변경하지 않으려면 취소를 눌러주세요");
	}
	else if(modify_service_user != service_user)
	{
		console.log("DDNS 상태가 변경됩니다! >>>> ajax 시작")
	$.ajax({
		type : "post",
		url : "check_ddns_service_modify_page.do",
		data : JSON.stringify(JSON_DATA),
		contentType : "application/json; charset=UTF-8",
		success : function(data) {
				switch(data)
				{
				case "success" :
					alert("변경에 성공하였습니다.");
					opener.parent.location.reload();
					window.close();	
					break;
				case "failed" :
					alert("수정에 실패하였습니다.");
					break;
				case "checked" :
					alert("관리자를 통한 확인이 필요합니다.");
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

</script>

</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
 
<form id="service_user_modify_form" name="service_user_modify_form">
	<table id="service_table">
		<tr>
			<td height="50"colspan="2">
				<font color="#00A2E8" style="font-weight: bold;">
					※ DDNS 장비 상태 변경<br>
					※ 상태 변경 시 선택한 장비의 도메인과 <br>
					&nbsp;&nbsp;&nbsp;맥 주소를 정확히 확인해주세요.<br>
				</font>
			</td>
		</tr>
		<tr><td colspan="2" height="30"></td></tr>
		<tr>
			<td>
				<span id="service_title domain" class="rf_span_title">1. 도메인</span>
			</td>
			<td class="service_table_td">
				<input type="text" value="<c:out value="${domain }"/>" readonly>
			</td>
		</tr>
		<tr>
			<td>
				<span id="service_title mac" class="rf_span_title">2. 맥 주소</span>
			</td>
			<td class="service_table_td">
				<input type="text" class="ipt_text" value="<c:out value="${mac }"/>" readonly>
			</td>
		</tr>
		<tr>
			<td>
				<span id="service_title user" class="rf_span_title">3. DDNS 상태</span>
			</td>
			<td class="service_table_td">
				<select id="service_user_select" onchange="service_user_mod(this.value);">
					<option value="0" <c:if test="${service_user == 0}"> selected</c:if>>서비스 중단</option>
					<option value="1" <c:if test="${service_user == 1}"> selected</c:if>>서비스 중</option>		
				</select>
			</td>
		</tr>
	</table>
	<div class="ddns_btn">
		<input type="button" value="수정" onclick="service_user_modify()" style="background: #000000; color: white;">
		<input type="button" value="취소" onclick="window.close()" style="background: #000000; color: white;">
	</div>
</form>
	
	
</body>
</html>