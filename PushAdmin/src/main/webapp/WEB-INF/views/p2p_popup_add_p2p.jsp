<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap" rel="stylesheet">

<title>P2P</title>
</head>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
$(function()
{
	if(${all_used})
	{
		alert("등록 가능한 P2P UID가 없습니다.");
		window.close();
	}

	$("#mac").focus();
	$("#mac").on("keyup", function() {
	    $(this).val($(this).val().replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣~`!@#$%\^&*()+=\-_\[\]{}|\\"';<>\?,./]/g,""));
	});
});

function add_p2p()
{
	if(($("#mac").val()).length < 12)
	{
		alert("올바른 맥 주소를 입력해주세요.");
		$("#mac").focus();
		return false;
	}

	var JSON_DATA = {"mac" : $("#mac").val(), "p2p_priority" : parseInt($("#p2p_priority").val(), 10)};
	$.ajax({
		type : "post",
		url : "add_p2p.do",
		data : JSON.stringify(JSON_DATA),
		contentType : "application/json; charset=UTF-8",
		success : function(data) {
			switch(data)
			{
			case "success":
				opener.parent.location.reload();
				window.close();
				break;
			case "exist":
				alert("이미 등록된 장비입니다.");
				break;
			case "nodevice":
				alert("장비가 존재하지 않습니다.");
				break;
			case "nop2puid":
				alert("남은 P2P UID가 없습니다.");
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
</script>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	<center>
		<table width="100%">
			<tr>
				<td height="50"></td>
			</tr>
			<tr>
				<td>
					<table align="center" border="0" width="90%">
						<tr height="0.1">
							<td colspan="3">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<tr>
							<td width="20%"></td>
							<td width="30%">맥 주소</td>
							<td>
								<input id="mac" maxlength="17" style="vertical-align: 5%">
							</td>
						</tr>
						<tr>
							<td></td>
							<td>접속 우선순위</td>
							<td>
								<select id="p2p_priority">
									<option value="2">P2P만 사용</option>
									<option value="1" selected>Auto</option>
									<option value="0">P2P 사용 안 함</option>
								</select>
							</td>
						</tr>
						<tr height="0.1">
							<td colspan="3">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<tr>
							<td height="30"></td>
						</tr>
						<tr>
							<td align="right" colspan="2">
								<input type="button" onclick="add_p2p()" style="background: #000000; color: white;" value="등록" />
							</td>
							<td align="left">
								<input type="button" onclick="window.close()" style="background: #000000; color: white;" value="취소" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</center>
</body>
</html>