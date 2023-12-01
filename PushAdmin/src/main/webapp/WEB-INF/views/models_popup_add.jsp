<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Model</title>
</head>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap" rel="stylesheet">

<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
$(function() {
	$("#model").focus();
	$("#model").on("keyup", function() {
	    $(this).val($(this).val().replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣~`!@#$%\^&*()+=_\[\]{}|\\"':;<>\?,./]/g,""));
	});
});

function add_models()
{
	if(($("#model").val()).length == 0)
	{
		alert("모델을 입력해주세요.");
		$("#model").focus();
		return false;
	}

	var JSON_DATA = {"model" : $("#model").val()};
	$.ajax({
		type : "post",
		url : "add_models.do",
		data : JSON.stringify(JSON_DATA),
		contentType : "application/json; charset=UTF-8",
		success : function(data) {
			switch(data)
			{
			case "nopermission":
				alert("권한이 없습니다.");
				break;
			case "success":
				opener.parent.location.reload();
				window.close();
				break;
			case "wrongmodel":
				alert("올바른 모델을 입력해주세요.");
				$("#model").focus();
				break;
			case "exist":
				alert("이미 등록된 모델입니다.");
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
						<tr height="30">
							<td width="25%"></td>
							<td width="25%">모델</td>
							<td>
								<input id="model" maxlength="32" style="vertical-align: 5%">
							</td>
						</tr>
						<tr height="30">
							<td></td>
							<td>FW 버전</td>
							<td>1.0.0</td>
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
								<input type="button" onclick="add_models()" style="background: #000000; color: white;" value="등록" />
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