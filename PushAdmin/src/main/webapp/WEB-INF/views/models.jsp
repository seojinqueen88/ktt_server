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

<title>Model</title>
</head>
<style type="text/css">
.select {
	color: #003399;
}
.select :hover {
	text-decoration: underline;
	color: #8080FF;
}
.font1 {
	font-family: Tahoma;
	font-size: 14px;
}

.font2 {
	color: #555555;
	font-family: Arial;
	font-size: 13px;
}
</style>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
var childWin = new Array();
var popup_idx = 0;
var m_check_count = 0;

$(function()
{
	$.ajaxSetup(
	{
		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		type : "post"
	});

	$("#search_btn").click(function()
	{
		$("#search_form").submit();
	});

	$("#excel_btn").click(function()
	{
		$("#excel_form").submit();
	});

	$("#excel_all_btn").click(function()
	{
		alert("데이터의 양에 따라 1~30초 정도의 시간이 소요될 수 있습니다.\n확인 버튼을 누르신 후 잠시만 기다려 주세요.");
		$("#excel_all_form").submit();
	});

	$("#add_btn").click(function()
	{
		if("${login_member.member_auth }" != 2)
		{
			alert("권한이 없습니다.");
			return false;
		}

		open_popup("/PushAdmin/add_models_page.do");
	});
});

function toggle_all_check()
{
	if($("#ck_all").prop("checked"))
	{
		m_check_count = 10;
		$("input[type=checkbox]").prop("checked", true);
	}
	else
	{
		m_check_count = 0;
		$("input[type=checkbox]").prop("checked", false);
	}
}

function toggle_sub_check(check_idx)
{
	if($("#ck_"+check_idx).prop("checked"))
		m_check_count++;
	else
		m_check_count--;

	if(m_check_count == 10)
		$("#ck_all").prop("checked", true);
	else
		$("#ck_all").prop("checked", false);
}

function open_popup(page_name)
{
	var winHeight = document.body.clientHeight;
	var winWidth = document.body.clientWidth;
	var winX = window.screenLeft;
	var winY = window.screenTop;

	var popX = winX + (winWidth - 600)/2;
	var popY = winY + (winHeight - 270)/2;
	childWin[popup_idx++] = window.open(page_name, "open_popup", "width=" + 600 + "px,height=" + 270 + "px,top=" + popY + ",left=" + popX);
}

function closeChildWin()
{
	for(var i = 0; i < childWin.length; i++)
	{
		if(childWin[i] && childWin[i].open && !childWin[i].closed)
			childWin[i].close();
	}
}

function delete_models()
{
	$("#delete_btn").prop("disabled", true);

	if("${login_member.member_auth }" != 2)
	{
		alert("권한이 없습니다.");
		$("#delete_btn").prop("disabled", false);
		return false;
	}

	var ck_list = [];
	var add_idx = 0;
	var ck_exist = false;

	for(var i = 0; i < 10; i++)
	{
		if($("#ck_" + i).prop("checked"))
		{
			if(($("#ck_" + i).val()).length == 0)
				continue;
			ck_list[add_idx++] = $("#ck_" + i).val();
			ck_exist = true;
		}
	}

	if(ck_exist == false)
	{
		alert("선택된 항목이 없거나 삭제할 장비가 없습니다.");
		$("#delete_btn").prop("disabled", false);
		return false;
	}

	if(!confirm("정말 삭제하시겠습니까?"))
	{
		$("#delete_btn").prop("disabled", false);
		return false;
	}

	var jsonData = JSON.stringify({"model_list" : ck_list});

	$.ajax({
		type : "post",
		url : "delete_models.do",
		data : jsonData,
		contentType:"application/json; charset=UTF-8",
		success : function(data) {
			switch(data)
			{
			case "nopermission":
				alert("권한이 없습니다.");
				break;
			case "success":
				location.reload(true);
				break;
			case "deletefail":
				alert("삭제 실패하였습니다. 관리자에게 문의하세요.");
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

	$("#delete_btn").prop("disabled", false);
}
</script>
<body onUnload="closeChildWin()" style="font-family: 'Noto Sans KR', sans-serif;">
	<table width="100%">
		<tr height="50">
			<td></td>
		</tr>
		<tr>
			<td><jsp:include page="top.jsp" /></td>
		</tr>
		<tr>
			<td>
				<table border="0" width="100%">
					<tr>
						<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="8" align="center" class="font2">M O D E L</td>
					</tr>
					<tr height="30">
						<td></td>
					</tr>
					<tr height="0.1">
						<td colspan="8">
							<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
						</td>
					</tr>
					<tr align="center">
						<td width="35%"></td>
						<td width="6">
							<c:if test="${login_member.member_auth == 2 }">
								<input type="checkbox" id="ck_all" onclick="toggle_all_check()">
							</c:if>
						</td>
						<td width="15%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/models_page.do?type=${type }&sort=model&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">모델</span></td>
						<td width="19%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/models_page.do?type=${type }&sort=fw_version&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">FW 버전</span></td>
						<td width="20%"></td>
					</tr>
					<tr height="0.1">
						<td colspan="8">
							<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
						</td>
					</tr>
					<c:forEach var="models_list" items="${models_list }" varStatus="status">
						<tr height="40" align="center">
							<td></td>
							<td>
								<c:if test="${login_member.member_auth == 2 }">
									<input type="checkbox" id="ck_${status.index }" value="${models_list.model }" onclick="toggle_sub_check(${status.index })">
								</c:if>
							</td>
							<td>${models_list.model }</td>
							<td>${models_list.fw_version }</td>
							<td></td>
						</tr>
						<tr height="0.1">
							<td colspan="8">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
					</c:forEach>
					<tr height="30">
						<td></td>
					</tr>
					<tr>
						<td colspan="6" align="center">
							<c:if test="${start_page > 10 }">
								<a href="/PushAdmin/models_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${1 }&search_type=${search_type }&search_word=${search_word }">[맨앞]</a>
								<a href="/PushAdmin/models_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page - 10 }&search_type=${search_type }&search_word=${search_word }">[이전]</a>
							</c:if>
							<c:forEach var="a" begin="${start_page }" end="${end_page <= last_page ? end_page : last_page }">
								<c:choose>
									<c:when test="${current_page == a }">
										<a>[${a }]</a>
									</c:when>
									<c:otherwise>
										<a href="/PushAdmin/models_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${a }&search_type=${search_type }&search_word=${search_word }">[${a }]</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<c:if test="${end_page < last_page }">
								<a href="/PushAdmin/models_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page + 10 }&search_type=${search_type }&search_word=${search_word }">[다음]</a>
								<a href="/PushAdmin/models_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${last_page }&search_type=${search_type }&search_word=${search_word }">[맨뒤]</a>
							</c:if>
						</td>
					</tr>
					<tr height="30">
						<td></td>
					</tr>
					<tr height="30">
						<td></td>
						<td colspan="3" align="center">
							<form id="search_form" name="search_form" action="/PushAdmin/models_page.do">
								<select name="search_type" id="search_type">
									<option value=0 <c:if test="${search_type == 0}">selected</c:if>>모델</option>
									<option value=1 <c:if test="${search_type == 1}">selected</c:if>>FW 버전</option>
								</select>
								<input id="search_word" name="search_word" style="vertical-align: 5%; width: 140px" value="${search_word }" maxlength="40">
								<input id="search_btn" type="button" style="background: #000000; color: white;" value="검색">
								<input type="hidden" name="type" id="type" value="models_search">
							</form>
						</td>
						
						<td colspan="3" align="right"> 
							<form id="excel_form" name="excel_form" action="/PushAdmin/models_excel.xlsx">엑셀 다운로드&nbsp;&nbsp;
								<input id="excel_btn" type="button" style="background: #000000; color: white;" value="현재 페이지">
								<input type="hidden" name="type" id="type" value="${type }">
								<input type="hidden" name="sort" id="sort" value="${sort }">
								<input type="hidden" name="page" id="page" value="${current_page }">
								<input type="hidden" name="direction" id="direction" value="${direction }">
								<c:if test="${type == 'models_search' }">
									<input type="hidden" name="search_type_excel" id="search_type_excel" value="${search_type }">
									<input type="hidden" name="search_word_excel" id="search_word_excel" value="${search_word }">
								</c:if>
								<input id="excel_all_btn" type="button" style="background: #000000; color: white;" value="전체 페이지">
							</form>
							<form id="excel_all_form" name="excel_all_form" action="/PushAdmin/models_excel.xlsx">
								<c:choose>
									<c:when test="${type == 'models' }">
										<input type="hidden" name="type" id="type" value="models_all">
									</c:when>
									<c:when test="${type == 'models_search' }">
										<input type="hidden" name="type" id="type" value="models_search_all">
										<input type="hidden" name="search_type_excel" id="search_type_excel" value="${search_type }">
										<input type="hidden" name="search_word_excel" id="search_word_excel" value="${search_word }">
									</c:when>
								</c:choose>
								<input type="hidden" name="sort" id="sort" value="${sort }">
								<input type="hidden" name="direction" id="direction" value="${direction }">
							</form>
						</td>
					</tr>
					<tr height="30" align="center">
						<td></td>
						<td colspan="3" align="center">
							<c:if test="${login_member.member_auth == 2 }">
								<input id="add_btn" type="button" style="background: #000000; color: white; width: 70px;" value="추가">
								<input id="delete_btn" type="button" style="background: #000000; color: white; width: 70px;" value="삭제" onclick="javascript:delete_models()">
							</c:if>
						</td>
						<td></td>
						<td colspan="2" align="right">
							<input type="button" onclick="location.href='/PushAdmin/models_page.do'" style="background: #000000; color: white;" value="전체 목록">
						</td>
					</tr>
					<tr height="30">
						<td></td>
					</tr>
					<tr>
						<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="8" align="center" class="font2">P U S H&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;S E R V E R&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A D M I N I S T R A T O R</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>