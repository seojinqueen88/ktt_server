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

<title>Service</title>
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
$(function() {
	$.ajaxSetup({
		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		type : "post"
	});
	$("#search_btn").click(function() {
		$("#search_form").submit();
	});
	$("#excel_btn").click(function() {
		$("#excel_form").submit();
	});
	$("#excel_all_btn").click(function() {
		alert("데이터의 양에 따라 1~30초 정도의 시간이 소요될 수 있습니다.\n확인 버튼을 누르신 후 잠시만 기다려 주세요.");
		$("#excel_all_form").submit();
	});
});
</script>
<body style="font-family: 'Noto Sans KR', sans-serif;">
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
						<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="10" align="center" class="font2">S E R V I C E</td>
					</tr>
					<tr height="30">
						<td></td>
					</tr>
					<tr height="0.1">
						<td colspan="10">
							<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
						</td>
					</tr>
					<tr align="center">
						<td width="8%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/service_page.do?type=${type }&sort=service_no&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">서비스 번호</span></td>
						<td width="8%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/service_page.do?type=${type }&sort=customer_no&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">고객 번호</span></td>
						<td width="8%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/service_page.do?type=${type }&sort=contract_no&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">계약 번호</span></td>
						<td width="22%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/service_page.do?type=${type }&sort=firm_nm&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">상호명</span></td>
						<td width="7%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/service_page.do?type=${type }&sort=mgr_lomo_cd&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">관리 본부</span></td>
						<td width="7%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/service_page.do?type=${type }&sort=mgr_brno_cd&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">관리 지사</span></td>
						<td width="11%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/service_page.do?type=${type }&sort=sys_id&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">시스템 아이디</span></td>
						<td width="8%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/service_page.do?type=${type }&sort=cust_sts&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">고객 상태</span></td>
						<td width="8%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/service_page.do?type=${type }&sort=cont_gd_smlcls&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">서비스 소</span></td>
						<td width="13%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/service_page.do?type=${type }&sort=update_time&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">갱신 시간</span></td>
					</tr>
					<tr height="0.1">
						<td colspan="10">
							<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
						</td>
					</tr>
					<c:forEach var="service_list" items="${service_list }">
						<tr align="center" height="30">
							<td>${service_list.service_no }</td>
							<td>${service_list.customer_no }</td>
							<td>${service_list.contract_no }</td>
							<td>${service_list.firm_nm }</td>
							<td>${service_list.mgr_lomo_cd }</td>
							<td>${service_list.mgr_brno_cd }</td>
							<td>${service_list.sys_id }</td>
							<td>
								<c:choose>
									<c:when test="${(service_list.cust_sts).equals('01')}">01 유지</c:when>
									<c:when test="${(service_list.cust_sts).equals('02')}">02 정지</c:when>
									<c:when test="${(service_list.cust_sts).equals('03')}">03 해지</c:when>
									<c:when test="${(service_list.cust_sts).equals('04')}">04 청약</c:when>
									<c:when test="${(service_list.cust_sts).equals('05')}">05 설변</c:when>
									<c:when test="${(service_list.cust_sts).equals('09')}">09 청약 취소</c:when>
									<c:when test="${(service_list.cust_sts).equals('99')}">99 이중 등록</c:when>
									<c:otherwise>${service_list.cust_sts}</c:otherwise>
								</c:choose>
							</td>
							<td>${service_list.cont_gd_smlcls }</td>
							<td>${service_list.update_time }</td>
						</tr>
						<tr height="0.1">
							<td colspan="10">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
					</c:forEach>
					<tr height="30">
						<td></td>
					</tr>
					<tr align="center">
						<td colspan="10">
							<c:if test="${start_page > 10 }">
								<a href="/PushAdmin/service_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${1 }&search_type=${search_type }&search_word=${search_word }">[맨앞]</a>
								<a href="/PushAdmin/service_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page - 10 }&search_type=${search_type }&search_word=${search_word }">[이전]</a>
							</c:if>
							<c:forEach var="a" begin="${start_page }" end="${end_page <= last_page ? end_page : last_page }">
								<c:choose>
									<c:when test="${current_page == a }">
										<a>[${a }]</a>
									</c:when>
									<c:otherwise>
										<a href="/PushAdmin/service_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${a }&search_type=${search_type }&search_word=${search_word }">[${a }]</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<c:if test="${end_page < last_page }">
								<a href="/PushAdmin/service_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page + 10 }&search_type=${search_type }&search_word=${search_word }">[다음]</a>
								<a href="/PushAdmin/service_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${last_page }&search_type=${search_type }&search_word=${search_word }">[맨뒤]</a>
							</c:if>
						</td>
					</tr>
					<tr height="30">
						<td></td>
					</tr>
					<tr height="30">
						<td colspan="3"></td>
						<td align="center" colspan="5">
							<form id="search_form" name="search_form" action="/PushAdmin/service_page.do">
								<select name="search_type" id="search_type">
									<option value=0 <c:if test="${search_type == 0}">selected</c:if>>서비스 번호</option>
									<option value=1 <c:if test="${search_type == 1}">selected</c:if>>상호명</option>
									<option value=2 <c:if test="${search_type == 2}">selected</c:if>>시스템 아이디</option>
									<option value=3 <c:if test="${search_type == 3}">selected</c:if>>고객 상태</option>
								</select>
								<input id="search_word" name="search_word" style="vertical-align: 5%; width: 140px" value="${search_word }" maxlength="40">
								<input id="search_btn" type="button" style="background: #000000; color: white;" value="검색">
								<input type="hidden" name="type" id="type" value="service_search">
							</form>
						</td>
						<td align="right" colspan="2"> 
							<form id="excel_form" name="excel_form" action="/PushAdmin/service_excel.xlsx">엑셀 다운로드&nbsp;&nbsp;
								<input id="excel_btn" type="button" style="background: #000000; color: white;" value="현재 페이지">
								<input type="hidden" name="type" id="type" value="${type }">
								<input type="hidden" name="sort" id="sort" value="${sort }">
								<input type="hidden" name="page" id="page" value="${current_page }">
								<input type="hidden" name="direction" id="direction" value="${direction }">
								<c:if test="${type == 'service_search' }">
									<input type="hidden" name="search_type_excel" id="search_type_excel" value="${search_type }">
									<input type="hidden" name="search_word_excel" id="search_word_excel" value="${search_word }">
								</c:if>
								<input id="excel_all_btn" type="button" style="background: #000000; color: white;" value="전체 페이지">
							</form>
							<form id="excel_all_form" name="excel_all_form" action="/PushAdmin/service_excel.xlsx">
								<c:choose>
									<c:when test="${type == 'service' }">
										<input type="hidden" name="type" id="type" value="service_all">
									</c:when>
									<c:when test="${type == 'service_search' }">
										<input type="hidden" name="type" id="type" value="service_search_all">
										<input type="hidden" name="search_type_excel" id="search_type_excel" value="${search_type }">
										<input type="hidden" name="search_word_excel" id="search_word_excel" value="${search_word }">
									</c:when>
								</c:choose>
								<input type="hidden" name="sort" id="sort" value="${sort }">
								<input type="hidden" name="direction" id="direction" value="${direction }">
							</form>
						</td>
					</tr>
					<tr height="30" align="right">
						<td colspan="10">
							<input type="button" onclick="location.href='/PushAdmin/service_page.do'" style="background: #000000; color: white;" value="전체 목록">
						</td>
					</tr>
					<tr height="30">
						<td></td>
					</tr>
					<tr>
						<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="10" align="center" class="font2">P U S H&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;S E R V E R&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A D M I N I S T R A T O R</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>