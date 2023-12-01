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
</style>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DDNS</title>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
	function serviceNo_chk() {
		var serviceNo = document.getElementById('serviceNo').value;
		var empNo = document.getElementById('empNo').value;
		var serviceNo_M = document.getElementById('serviceNo_M').value;
		var cnt_serviceNo = serviceNo_M.replace(/(\s*)/g, '');
		var mac = document.getElementById('mac').value;

		if (serviceNo == cnt_serviceNo) {
			alert("기존 서비스 번호와 동일합니다.");
		} else if (cnt_serviceNo.length == 8 || cnt_serviceNo.length == 0) {

			serviceNo_modi(cnt_serviceNo, mac, empNo)
		} else {
			alert("입력한 서비스 번호가 잘못되었습니다.");
		}
	}

	function serviceNo_modi(serviceNo, mac, empNo) {
		var JSON_DATA = {
			"mac" : mac,
			"serviceNo" : serviceNo,
			"empNo" : empNo
		};
		$.ajax({
			type : "post",
			url : "ddns_service_no_modify.do",
			data : JSON.stringify(JSON_DATA),
			contentType : "application/json; charset=UTF-8",
			success : function(data) {
				switch (data) {
				case "success":
					alert("서비스 번호 변경 완료되었습니다.");
					opener.parent.location.reload();
					window.close();
					break;
				case "failed":
					alert("서비스 번호 변경 실패하였습니다.");
					break;
				case "checked":
					alert("관리자를 통한 확인이 필요합니다.");
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
					style="font-weight: bold;"> ※ DDNS 장비 서비스 번호 등록<br> ※
						선택한 장비의 MAC 주소와 등록할 서비스 번호를 확인해주세요. <br> ※ 서비스 번호는 8자리 혹은 빈칸
						이어야합니다.<br>
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
					class="rf_span_title">서비스 번호</span></td>
				<td class="service_table_td"><input type="hidden"
					id="serviceNo" value="<c:out value="${serviceNo }"/>"> <input
					type="hidden" id="empNo"
					value="<c:out value="${login_member.member_id }"/>"> <input
					type="text" id="serviceNo_M" name="serviceNo_M" maxlength="8"
					onkeyup="this.value=this.value.replace(/[^-0-9]/g,'');"
					value="${serviceNo }"></td>
			</tr>
			<tr></tr>
		</table>
		<div class="ddns_btn">
			<input type="button" value="수정" onclick="serviceNo_chk()"
				style="background: #000000; color: white;"> <input
				type="button" value="취소" onclick="window.close()"
				style="background: #000000; color: white;">
		</div>
	</div>
</body>
</html>