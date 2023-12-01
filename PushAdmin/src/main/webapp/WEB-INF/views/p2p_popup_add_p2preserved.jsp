<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	$("#start_p2p_uid").focus();
	$("#start_p2p_uid, #end_p2p_uid").on("keyup", function()
	{
	    $(this).val($(this).val().replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣~`!@#$%\^&*()+=\-_\[\]{}|\\"';:<>\?,./]/g,""));
	});
});

function add_p2preserved()
{
	var start_p2p_uid = $("#start_p2p_uid").val();
	var end_p2p_uid = $("#end_p2p_uid").val();

	if(start_p2p_uid == "" && end_p2p_uid == "")
	{
		alert("내용을 입력해주세요.");
		$("#start_p2p_uid").focus();
	}
	else
	{
		alert("P2P UID 개수에 따라 1~30초 정도의 시간이 소요될 수 있습니다.\n확인 버튼을 누르신 후 잠시만 기다려 주세요.");

		if(start_p2p_uid == "")
			start_p2p_uid = end_p2p_uid;
		else if(end_p2p_uid == "")
			end_p2p_uid = start_p2p_uid;

		var JSON_DATA = {"start_p2p_uid" : start_p2p_uid, "end_p2p_uid" : end_p2p_uid};
		$.ajax({
			type : "post",
			url : "add_p2preserved.do",
			data : JSON.stringify(JSON_DATA),
			contentType : "application/json; charset=UTF-8",
			success : function(data) {
				switch(data)
				{
				case "success":
					opener.parent.location.reload();
					window.close();
					break;
				case "nopermission":
					alert("권한이 없습니다.");
					break;
				case "wrong":
					alert("잘못 입력하셨습니다. 시작 P2P UID가 끝 P2P UID보다 클 수 없습니다.");
					break;
				case "exist":
					alert("이미 등록된 P2P UID가 있습니다.");
					break;
				case "insertfail":
					alert("등록 실패하였습니다. 관리자에게 문의하세요.");
					break;
				case "toomany":
					alert("P2P UID는 한번에 10000개 이상 등록할 수 없습니다.");
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
							<td width="5%"></td>
							<td width="18%">P2P UID</td>
							<td>
								<input type="text" id="start_p2p_uid" maxlength="15" size="20"> ~
								<input type="text" id="end_p2p_uid" maxlength="15" size="20">
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
							<td align="center" colspan="3">
								<input type="button" onclick="add_p2preserved()" style="background: #000000; color: white;" value="등록" />
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