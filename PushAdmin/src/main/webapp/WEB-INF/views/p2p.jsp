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
var childWin = new Array();
var popup_idx = 0;
var m_check_count = 0;

$(function()
{
	$.ajaxSetup({
		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		type : "post"
	});

	$("#search_mac_btn").click(function() {
		$("#search_mac_form").submit();
	});

	$("#search_p2p_uid_btn").click(function() {
		$("#search_p2p_uid_form").submit();
	});

	$("#excel_btn").click(function() {
		$("#excel_form").submit();
	});

	$("#excel_all_btn").click(function() {
		$("#excel_all_form").submit();
	});

	$("#add_p2p_btn").click(function()
	{
		if("${login_member.member_auth }" != 2)
		{
			alert("권한이 없습니다.");
			return false;
		}

		open_popup("/PushAdmin/add_p2p_page.do");
	});

	$("#add_p2preserved_btn").click(function()
	{
		if("${login_member.member_auth }" != 2)
		{
			alert("권한이 없습니다.");
			return false;
		}

		open_popup("/PushAdmin/add_p2preserved_page.do");
	});
});

function closeChildWin()
{
	for(var i = 0; i < childWin.length; i++)
	{
		if(childWin[i] && childWin[i].open && !childWin[i].closed)
			childWin[i].close();
	}
}

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

function delete_p2p()
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
		return false;
	}

	if(confirm("정말 삭제하시겠습니까?"))
	{
		var jsonData = JSON.stringify({"mac_list" : ck_list});

		$.ajax({
			type : "post",
			url : "delete_p2p.do",
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
				case "unusedfail":
					alert("초기화에 실패하였습니다. 관리자에게 문의하세요.");
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
	else{}

	$("#delete_btn").prop("disabled", false);
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
</script>
<body onUnload="closeChildWin()" style="font-family: 'Noto Sans KR', sans-serif;">
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
							<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="9" align="center" id="font2">P 2 P</td>
						</tr>
						<tr>
							<td height="30"></td>
						</tr>
						<tr height="0.1">
							<td colspan="9">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<tr>
							<td width="22%"></td>
							<td width="4%" align="center">
								<c:if test="${login_member.member_auth == 2 }">
									<input type="checkbox" id="ck_all" onclick="toggle_all_check()">
								</c:if>
							</td>
							<td width="10%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/p2p_page.do?type=${type }&sort=jumin&direction=${direction.equals('desc') ? 'asc' : 'desc' }&mac=${mac }&p2p_uid=${p2p_uid }'">맥 주소</td>
							<td colspan="2" width="13%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/p2p_page.do?type=${type }&sort=p2p_uid&direction=${direction.equals('desc') ? 'asc' : 'desc' }&mac=${mac }&p2p_uid=${p2p_uid }'">P2P UID</td>
							<td width="10%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/p2p_page.do?type=${type }&sort=p2p_priority&direction=${direction.equals('desc') ? 'asc' : 'desc' }&mac=${mac }&p2p_uid=${p2p_uid }'">접속 우선순위</td>
							<td width="10%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/p2p_page.do?type=${type }&sort=used&direction=${direction.equals('desc') ? 'asc' : 'desc' }&mac=${mac }&p2p_uid=${p2p_uid }'">사용 여부</td>
							<td width="12%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/p2p_page.do?type=${type }&sort=last_used_time&direction=${direction.equals('desc') ? 'asc' : 'desc' }&mac=${mac }&p2p_uid=${p2p_uid }'">마지막 사용 시간</td>
							<td width="19%"></td>
						</tr>
						<tr height="0.1">
							<td colspan="9">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<c:forEach var="p2p_list" items="${p2p_list }" varStatus="status">
							<tr height="40" align="center">
								<td></td>
								<td>
									<c:if test="${login_member.member_auth == 2 }">
										<input type="checkbox" id="ck_${status.index }" value="${p2p_list.jumin }" onclick="toggle_sub_check(${status.index })">
									</c:if>
								</td>
								<td>${p2p_list.jumin }</td>
								<td colspan="2">${p2p_list.p2p_uid }</td>
								<td>
									<c:choose>
										<c:when test="${p2p_list.p2p_priority == 2}">P2P만 사용</c:when>
										<c:when test="${p2p_list.p2p_priority == 1}">Auto</c:when>
										<c:when test="${p2p_list.p2p_priority == 0}">P2P 사용 안 함</c:when>
										<c:otherwise>${p2p_list.p2p_priority}</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${p2p_list.used == 1}">사용</c:when>
										<c:when test="${p2p_list.used == 0}">사용 가능</c:when>
										<c:otherwise>${p2p_list.used}</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${(p2p_list.last_used_time).equals('1970-01-01 00:00:00')}"></c:when>
										<c:otherwise>${p2p_list.last_used_time }</c:otherwise>
									</c:choose>
								</td>
								<td></td>
							</tr>
							<tr height="0.1">
								<td colspan="9">
									<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
								</td>
							</tr>
						</c:forEach>
						<tr>
							<td height="30"></td>
						</tr>
						<tr>
							<td colspan="9" align="center">
								<c:if test="${start_page > 10 }">
									<a href="/PushAdmin/p2p_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${1 }&mac=${mac}&p2p_uid=${p2p_uid}">[맨앞]</a>
									<a href="/PushAdmin/p2p_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page - 10 }&mac=${mac}&p2p_uid=${p2p_uid}">[이전]</a>
								</c:if>
								<c:forEach var="a" begin="${start_page }" end="${end_page <= last_page ? end_page : last_page }">
									<c:choose>
										<c:when test="${current_page == a }">
											<a>[${a}]</a>
										</c:when>
										<c:otherwise>
											<a href="/PushAdmin/p2p_page.do?type=${type}&sort=${sort}&direction=${direction}&page=${a}&mac=${mac}&p2p_uid=${p2p_uid}">[${a}]</a>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								<c:if test="${end_page < last_page }">
									<a href="/PushAdmin/p2p_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page + 10 }&mac=${mac}&p2p_uid=${p2p_uid}">[다음]</a>
									<a href="/PushAdmin/p2p_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${last_page }&mac=${mac}&p2p_uid=${p2p_uid}">[맨뒤]</a>
								</c:if>
							</td>
						</tr>
						<tr>
							<td height="30"></td>
						</tr>
						<tr height="30">
							<td colspan="4"></td>
							<td colspan="4">
								<form id="search_mac_form" name="search_mac_form" action="/PushAdmin/p2p_page.do">맥 주소&nbsp;&nbsp;
									<input id="mac" name="mac" maxlength="17" style="vertical-align: 5%" value="${mac}">
									<input id="search_mac_btn" type="button" style="background: #000000; color: white;" value="검색">
									<input type="hidden" name="type" id="type" value="p2p_search_mac">
								</form>
							</td>
							<td align="right"> 
								<form id="excel_form" name="excel_form" action="/PushAdmin/p2p_excel.xlsx">엑셀 다운로드&nbsp;&nbsp;
									<input id="excel_btn" type="button" style="background: #000000; color: white;" value="현재 페이지">
									<input type="hidden" name="type" id="type" value="${type}">
									<input type="hidden" name="sort" id="sort" value="${sort}">
									<input type="hidden" name="page" id="page" value="${current_page}">
									<input type="hidden" name="direction" id="direction" value="${direction}">
									<c:choose>
										<c:when test="${type == 'p2p_search_mac'}">
											<input type="hidden" name="mac_excel" id="mac_excel" value="${mac}">
										</c:when>
										<c:when test="${type == 'p2p_search_p2p_uid' }">
											<input type="hidden" name="p2p_uid_excel" id="p2p_uid_excel" value="${p2p_uid}">
										</c:when>
									</c:choose>
									<input id="excel_all_btn" type="button" style="background: #000000; color: white;" value="전체 페이지">
								</form>
								<form id="excel_all_form" name="excel_all_form" action="/PushAdmin/p2p_excel.xlsx">
									<c:choose>
										<c:when test="${type == 'p2p' }">
											<input type="hidden" name="type" id="type" value="p2p_all">
										</c:when>
										<c:when test="${type == 'p2p_search_mac' }">
											<input type="hidden" name="type" id="type" value="p2p_search_mac_all">
											<input type="hidden" name="mac_excel" id="mac_excel" value="${mac}">
										</c:when>
										<c:when test="${type == 'p2p_search_p2p_uid' }">
											<input type="hidden" name="type" id="type" value="p2p_search_p2p_uid_all">
											<input type="hidden" name="p2p_uid_excel" id="p2p_uid_excel" value="${p2p_uid}">
										</c:when>
									</c:choose>
									<input type="hidden" name="sort" id="sort" value="${sort}">
									<input type="hidden" name="direction" id="direction" value="${direction}">
								</form>
							</td>
						</tr>
						<tr height="30">
							<td colspan="4"></td>
							<td colspan="4">
								<form id="search_p2p_uid_form" name="search_p2p_uid_form" action="/PushAdmin/p2p_page.do">P2P UID&nbsp;&nbsp;
									<input id="p2p_uid" name="p2p_uid" maxlength="30" style="vertical-align: 5%" value="${p2p_uid}">
									<input id="search_p2p_uid_btn" type="button" style="background: #000000; color: white;" value="검색">
									<input type="hidden" name="type" id="type" value="p2p_search_p2p_uid">
								</form>
							</td>
							<td align="right">
								<input type="button" onclick="location.href='/PushAdmin/p2p_page.do'" style="background: #000000; color: white;" value="전체 목록">
							</td>
						</tr>
						<c:if test="${login_member.member_auth == 2 }">
							<tr>
								<td height="30" colspan="9" align="center">
									<input id="add_p2p_btn" type="button" style="background: #000000; color: white;" value="장비 등록">
									<input id="delete_btn" type="button" style="background: #000000; color: white;" value="장비 삭제" onclick="javascript:delete_p2p()">
									<input id="add_p2preserved_btn" type="button" style="background: #000000; color: white;" value="P2P UID 등록">
								</td>
							</tr>
						</c:if>
						<tr>
							<td height="30"></td>
						</tr>
						<tr>
							<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="9" align="center" id="font2">P U S H&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;S E R V E R&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A D M I N I S T R A T O R</td>
						</tr>
					</table>
				</center>
			</td>
		</tr>
	</table>
</body>
</html>