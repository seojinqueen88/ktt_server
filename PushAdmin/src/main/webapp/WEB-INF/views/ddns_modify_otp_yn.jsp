<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap"
	rel="stylesheet">
<link rel="shortcut icon" href="#">
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

.service_table_td input[type="text"] {
	border: 2px solid #b3b3b3;
	border-radius: 12px;
	padding: 5px;
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
select {
   -webkit-appearance:none;
   -moz-appearance:none;
   -ms-appearance:none;
   appearance:none;
   outline:0;
   box-shadow:none;
   border:0!important;
   background: #5c6664;
   background-image: none;
   flex: 1;
   padding: 0 .5em;
   color:#fff;
   cursor:pointer;
   font-size: 1em;
   font-family: 'Open Sans', sans-serif;
}
select::-ms-expand {
   display: none;
}
.select {
   position: relative;
   display: flex;
   width: 20em;
   height: 3em;
   line-height: 3;
   background: #5c6664;
   overflow: hidden;
   border-radius: .25em;
}
.select::after {
   content: '\25BC';
   position: absolute;
   top: 0;
   right: 0;
   padding: 0 1em;
   background: #2b2e2e;
   cursor:pointer;
   pointer-events:none;
   transition:.25s all ease;
}
.select:hover::after {
   color: #23b499;
}
</style>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DDNS</title>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script type="text/javascript">

	function No_chk() {
		var modify_opt_yn = $("#otp_yn option:selected").val();
		var empNo = document.getElementById('empNo').value;
		var mac = document.getElementById('mac').value;
		var id = document.getElementById('_id').value;
		var before_otp_yn =  document.getElementById('before_otp_yn').value; 
		if(typeof modify_opt_yn =='string' )
			modify_opt_yn = parseInt(modify_opt_yn , 10);
		if(typeof before_otp_yn =='string' )
			before_otp_yn = parseInt(before_otp_yn , 10);
		//console.log(modify_opt_yn);
		//console.log(typeof modify_opt_yn );
		switch(modify_opt_yn){
		case 3:
			if(confirm("인증완료 처리시 변경 불가능합니다. 계속하시겠습니까?") == false)
				return;
		case 0:
		case 1:
		case 2:
			otp_Yn_modi(id, modify_opt_yn , before_otp_yn, mac, empNo );
			break;
			default:
				alert("입력한 OTP 인증 선택이 잘못되었습니다.");
			break;
		}
		
	}

	function otp_Yn_modi(id, opt_yn,before_otp_yn, mac, empNo) {
		var JSON_DATA = {
			"mac" : mac,
			"opt_yn" : opt_yn,
			"before_otp_yn" : before_otp_yn,
			"id" : id,
			"empNo" : empNo
		};
		
		$.ajax({
			type : "post",
			url : "ddns_service_opt_yn_modify.do",
			data : JSON.stringify(JSON_DATA),
			contentType : "application/json; charset=UTF-8",
			success : function(data) {
				//console.log(JSON.stringify(data));
				switch (data) {
				case "success":
					alert("OTP 변경이 완료되었습니다.");
					opener.parent.location.reload();
					window.close();
					break;
				case "failed":
					alert("OTP 변경 되지 않았습니다. 확인이 필요로 합니다.");
					break;
				default:
					alert("관리자에게 문의하세요.");
					break;
				}
			},
			error : function(request, status, error) {
				alert("오류가 발생되었습니다. 관리자에게 문의해주세요");
				console.log("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}
</script>

</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	<div>
		<table id="service_table">
			<tr>
				<td height="50" colspan="2"><font color="#00A2E8"
					style="font-weight: bold;"> ※ DDNS 장비 OTP 인증 변경<br> ※
						선택한 장비의 MAC 주소와 변경할 OTP 인증 상태를 확인해주세요. <br> ※ 인증 완료 선택 시 변경 불가능합니다..<br>
				</font></td>
			</tr>
			<tr></tr>
			<tr>
				<td colspan="2" height="30"></td>
			</tr>
			<tr>
				<td width="100px"><span id="service_title mac"
					class="rf_span_title">맥 주소</span></td>
				<td class="service_table_td"><input type="text" id="mac"
					value="<c:out value="${mac }"/>" readonly></td>
			</tr>
			<tr>
				 
				<td width="100px"><span id="service_title user"
					class="rf_span_title">OTP 인증</span></td>
				<td class="service_table_td">
				  <input type="hidden" id="serviceNo" value="<c:out value="${serviceNo }"/>">
				  <input type="hidden" id="empNo" value="<c:out value="${login_member.member_id }"/>">
				  <input type="hidden" id="_id" value="<c:out value="${login_member.member_id }"/>">
				  <input type="hidden" id="before_otp_yn" value="<c:out value="${otp_yn }"/>">
				  
				 <div class="select">
				 <select name="search_type" id="otp_yn">
				 	<option value=0 <c:if test="${otp_yn == 0}">selected</c:if>>0 OTP 인증 안함</option>
					<option value=1 <c:if test="${otp_yn == 1}">selected</c:if>>1 기존통합앱사용자</option>
					<option value=2 <c:if test="${otp_yn == 2}">selected</c:if>>2 관리자 변경</option>
					<!-- 
					<option value=3 <c:if test="${otp_yn == 3}">selected</c:if>>3 OTP 인증완료</option> 
					-->
				</select>	
				</div>	
			</tr>
			<tr></tr>
		</table>
		<div class="ddns_btn">
			<input type="button" value="수정" onclick="No_chk()"
				style="background: #000000; color: white;">
				 <input
				type="button" value="취소" onclick="window.close()"
				style="background: #000000; color: white;">
		</div>
	</div>
</body>
</html>