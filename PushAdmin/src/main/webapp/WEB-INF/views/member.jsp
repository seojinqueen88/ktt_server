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

<title>Member</title>
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
var pass_duplicate_ck = 0;
var member_auth = 0;

$(function()
{
	$.ajaxSetup({
		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		type : "post"
	});
	$("input[name=member_id]").change(function() {
		pass_duplicate_ck = 0;
	});
});

function check_only_one(val)
{
	var obj = document.getElementsByName("member_auth");
	for(var i = 0; i < obj.length; i++)
	{
		if(obj[i] != val)
		{
			obj[i].checked = false;
		}
		else
		{// DDNS : 0, 조회 : 1, 조회 + 수정 : 2
			if($("input:checkbox[name='member_auth']").is(":checked"))
				member_auth = parseInt(obj[i].value, 10);
			else
				member_auth = 0;
		}
	}
}

function check_pw_char(value)
{
	var spa= /[\{\}\[\]\/?.,;:|\)*~`!^\-+┼<>@\#$%&\'\"\\\(\=]/gi;  
	var cha = /[a-z]|[A-Z]/gi;
	var num = /[0-9]/gi;

	if(spa.test(value) && cha.test(value) && num.test(value))
		return true;
	else
		return false;
}

function add_member()
{
	$("#add_btn").prop("disabled", true);

	do
	{
		if($("#member_id").val() == "" || $("#member_pw").val() == "")
		{
			alert("사용자 ID와 비밀번호는 필수 입력사항 입니다.");
			$("#member_id").focus();
			break;
		}

		if(pass_duplicate_ck == 0)
		{
			alert("사용자 ID의 중복 확인은 필수입니다.");
			break;
		}

		if($("#member_pw").val().length < 8 || $("#member_pw").val().length > 16 || !check_pw_char($.trim($("#member_pw").val())))
		{
			alert("비밀번호는 영문, 숫자, 특수문자의 조합으로 8 ~ 16 자리를 입력해주세요.");
			$("#member_pw").val("");
			$("#member_pw_ck").val("");
			$("#member_pw").focus();
			break;
		}

		if($("#member_pw").val() != $("#member_pw_ck").val())
		{
			alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.")
			$("#member_pw").focus();
			break;
		}

		var JSON_DATA = {"member_id" : $("#member_id").val(), "member_pw" : $("#member_pw").val(), "member_auth" : member_auth};
		$.ajax({
			type : "post",
			url : "add_member.do",
			data : JSON.stringify(JSON_DATA),
			contentType : "application/json; charset=UTF-8",
			success : function(data) {
				switch(data)
				{
				case "nopermission":
					alert("사용자 계정을 추가하실 권한이 없습니다.");
					break;
				case "success":
					location.reload(true);
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

	$("#add_btn").prop("disabled", false);
}

function id_duplicate_ck()
{
	$("#check_btn").prop("disabled", true);

	do
	{
		if($("#member_id").val() == "")
		{	
			alert("사용하실 아이디를 입력해주세요.");
			break;
		}

		var JSON_DATA = {"member_id" : $("#member_id").val()};
		$.ajax({
			type : "post",
			url : "id_duplicate_ck.do",
			data : JSON.stringify(JSON_DATA),
			contentType : "application/json; charset=UTF-8",
			success : function(data) {
				switch(data)
				{
				case "nopermission":
					alert("권한이 없습니다.");
					break;
				case "success":
					if(confirm("사용하실 수 있는 아이디 입니다. 이 아이디를 사용하시겠습니까?"))
						pass_duplicate_ck = 1;
					else
						pass_duplicate_ck = 0;
					break;
				case "exist":
					alert("이미 등록된 아이디 입니다.");
					$("#member_id").val("");
					$("#member_id").focus();
					pass_duplicate_ck = 0;
					break;
				default:
					alert("관리자에게 문의하세요.");
					pass_duplicate_ck = 0;
					break;
				}
			},
			error : function(request,status,error) {
	       		alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	       	}
		});
	}
	while(false);

	$("#check_btn").prop("disabled", false);
}

function delete_member(member_idx)
{
	$("#delete_btn").prop("disabled", true);

	do
	{
		if(confirm('삭제하시겠습니까?'))
		{
			var JSON_DATA = {"member_idx" : member_idx};
			$.ajax({
				type : "post",
				url : "delete_member.do",
				data : JSON.stringify(JSON_DATA),
				contentType : "application/json; charset=UTF-8",
				success : function(data) {
					switch(data)
					{
					case "nopermission":
						alert("사용자 계정을 삭제하실 권한이 없습니다.");
						break;
					case "success":
						location.reload(true);
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
	while(false);

	$("#delete_btn").prop("disabled", false);
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
							<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="8" align="center" id="font2">M E M B E R</td>
						</tr>
						<tr>
							<td height="30"></td>
						</tr>
						<tr height="0.1">
							<td colspan="8">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<tr>
							<td width="4%" align="center" id="font1">No.</td>
							<c:choose>
								<c:when test="${direction == 'desc' }">
									<td width="19%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/member_page.do?sort=member_id&direction=${direction.equals('desc') ? 'asc' : 'desc' }'">사용자 아이디</td>
									<td width="19%" align="center" id="font1">비밀번호</td>
									<td width="18%" align="center" id="font1" colspan="2" style="cursor:pointer;" onclick="location.href='/PushAdmin/member_page.do?sort=member_auth&direction=${direction.equals('desc') ? 'asc' : 'desc' }'">수정 권한</td>
									<td width="18%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/member_page.do?sort=last_login_date&direction=${direction.equals('desc') ? 'asc' : 'desc' }'">최종접속일시</td>
									<td width="18%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/member_page.do?sort=create_date&direction=${direction.equals('desc') ? 'asc' : 'desc' }'">등록일시</td>
								</c:when>
								<c:otherwise>
									<td width="19%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/member_page.do?sort=member_id&direction=${direction.equals('desc') ? 'asc' : 'desc' }'">사용자 아이디</td>
									<td width="19%" align="center" id="font1">비밀번호</td>
									<td width="18%" align="center" id="font1" colspan="2" style="cursor:pointer;" onclick="location.href='/PushAdmin/member_page.do?sort=member_auth&direction=${direction.equals('desc') ? 'asc' : 'desc' }'">수정 권한</td>
									<td width="18%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/member_page.do?sort=last_login_date&direction=${direction.equals('desc') ? 'asc' : 'desc' }'">최종접속일시</td>
									<td width="18%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/member_page.do?sort=create_date&direction=${direction.equals('desc') ? 'asc' : 'desc' }'">등록일시</td>
								</c:otherwise>
							</c:choose>
							<td width="4%" align="center" id="font1">삭제</td>
						</tr>
						<tr height="0.1">
							<td colspan="8">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<c:forEach var="member_list" items="${member_list }">
							<tr height="40">
								<td align="center">${member_list.row_idx }</td>
								<td align="center">${member_list.member_id }</td>
								<td align="center"><input type="password" value="000000" style="border-style: hidden; text-align: center" ></td>
								<td align="center" colspan="2">
									<c:choose>
										<c:when test="${member_list.member_auth == 0}">DDNS</c:when>
										<c:when test="${member_list.member_auth == 1}">조회</c:when>
										<c:when test="${member_list.member_auth == 2}">조회 + 수정</c:when>
										<c:otherwise>${member_list.member_auth}</c:otherwise>
									</c:choose>
								</td>
								<td align="center">${member_list.last_login_date }</td>
								<td align="center">${member_list.create_date }</td>
								<td align="center">
									<input type="button" id="delete_btn" style="background: #000000; color: white;" value="삭제" onclick="delete_member(${member_list.member_idx })">
								</td>
							</tr>
							<tr height="0.1">
								<td colspan="8">
									<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
								</td>
							</tr>
						</c:forEach>
						<tr>
							<td height="30"></td>
						</tr>
						<tr>
							<td colspan="8" align="center">
								<c:if test="${start_page > 10 }">
									<a href="/PushAdmin/member_page.do?sort=${sort }&page=${1 }">[맨앞]</a>
									<a href="/PushAdmin/member_page.do?sort=${sort }&page=${start_page - 10 }">[이전]</a>
								</c:if>
								<c:forEach var="a" begin="${start_page }" end="${end_page <= last_page ? end_page : last_page }">
									<c:choose>
										<c:when test="${current_page == a }">
											<a>[${a }]</a>
										</c:when>
										<c:otherwise>
											<a href="/PushAdmin/member_page.do?sort=${sort }&page=${a }">[${a }]</a>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								<c:if test="${end_page < last_page }">
									<a href="/PushAdmin/member_page.do?sort=${sort }&page=${start_page + 10 }">[다음]</a>
									<a href="/PushAdmin/member_page.do?sort=${sort }&page=${last_page }">[맨뒤]</a>
								</c:if>
							</td>
						</tr>
						<tr>
							<td height="30"></td>
						</tr>
						<tr>
							<td colspan="3" rowspan="4"></td>
							<td align="left" width="8%">사용자 ID</td>
							<td colspan="2">
								<input size="20" name="member_id" id="member_id">
								<input type="button" id="check_btn" style="background: #000000; color: white; vertical-align: middle;" value="중복 확인" onclick="id_duplicate_ck()">
							</td>
							<td colspan="2" rowspan="4"></td>
						</tr>
						<tr>
							<td align="left">비밀번호</td>
							<td colspan="2"><input type="password" size="20" name="member_pw" id="member_pw"></td>
						</tr>
						<tr>
							<td align="left">비밀번호 확인</td>
							<td colspan="2"><input type="password" size="20" name="member_pw_ck" id="member_pw_ck"></td>
						</tr>
						<tr>
							<td align="left">권한 설정</td>
							<td colspan="2">
								<input type="checkbox" name="member_auth" value="1" onclick="check_only_one(this)">조회&nbsp;&nbsp;&nbsp;
								<input type="checkbox" name="member_auth" value="2"onclick="check_only_one(this)">조회 + 수정
							</td>
						</tr>
						
						<tr>
							<td height="30"></td>
						</tr>
						<tr>
							<td colspan="8" align="center"><input type="button" id="add_btn" style="background: #000000; color: white;" value="추가" onclick="add_member()"></td>
						</tr>
						<tr>
							<td height="30"></td>
						</tr>
						<tr>
							<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="8" align="center" id="font2">P U S H&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;S E R V E R&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A D M I N I S T R A T O R</td>
						</tr>
					</table>
				</center>
			</td>
		</tr>
	</table>
</body>
</html>