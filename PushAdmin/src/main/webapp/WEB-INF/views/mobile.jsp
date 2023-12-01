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

<title>Mobile</title>
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
$(function()
{
	$.ajaxSetup(
	{
		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		type : "post"
	});

	$("#search_mobile_type_btn").click(function()
	{
		$("#search_mobile_type_form").submit();
	});

	$("#search_user_id_btn").click(function()
	{
		$("#search_user_id_form").submit();
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
});

function mobile_search_create_date()
{
	var start_create_date = document.getElementById("start_create_date");
	var start_year = document.getElementById("start_year");
	var start_month = document.getElementById("start_month");
	var start_month_str;
	var start_day = document.getElementById("start_day");
	var start_day_str;

	if(start_month.value.length < 2)
		start_month_str = "0" + start_month.value;
	else
		start_month_str = start_month.value;

	if(start_day.value.length < 2)
		start_day_str = "0" + start_day.value;
	else
		start_day_str = start_day.value;

	start_create_date.value = start_year.value + start_month_str + start_day_str;

	var end_create_date = document.getElementById("end_create_date");
	var end_year = document.getElementById("end_year");
	var end_month = document.getElementById("end_month");
	var end_month_str;
	var end_day = document.getElementById("end_day");
	var end_day_str;
	
	if(end_month.value.length < 2)
		end_month_str = "0" + end_month.value;
	else
		end_month_str = end_month.value;

	if(end_day.value.length < 2)
		end_day_str = "0" + end_day.value;
	else
		end_day_str = end_day.value;
	
	end_create_date.value = end_year.value + end_month_str + end_day_str;
	
	var start_create_date_int = start_create_date.value*1;
	var end_create_date_int = end_create_date.value*1;

	if(start_create_date_int > end_create_date_int)
	{
		alert("잘못된 날짜 형식을 입력하셨습니다.\n시작 날짜가 끝 날짜보다 늦을 수 없습니다.")
		return false;
	}

	$("#search_create_date_form").submit();
}

function start_month_change(e)
{
	var start_month = e.value; // 선택 월
	var max_date = new Date(new Date($("#start_year").val(), start_month, 1)-86400000).getDate(); // 해당월의 마지막 날짜 구하기
	var day_element = document.getElementById("start_day");
	remove_all(day_element); // 전체 options 삭제
	set_day_option(day_element, max_date); // 해당 마지막 날짜까지 options 생성
}

function end_month_change(e)
{
	var end_month = e.value; // 선택 월
	var max_date = new Date(new Date($("#end_year").val(), end_month, 1)-86400000).getDate(); // 해당월의 마지막 날짜 구하기
	var day_element = document.getElementById("end_day");
	remove_all(day_element); // 전체 options 삭제
	set_day_option(day_element, max_date); // 해당 마지막 날짜까지 options 생성
}

function remove_all(e)
{
	var limit = e.options.length;
	for(var i = limit; i >= 0; i--)
	{
		e.remove(i);
	}
}

function set_day_option(e, max_len)
{
	for(var i = 1; i <= max_len; i++)
	{
		var opt = document.createElement("option");
		opt.value = i;
		opt.text = i;
		e.options.add(opt);
	}
}
</script>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	<table width="100%" style="table-layout:fixed;">
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
							<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="9" align="center" id="font2">M O B I L E</td>
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
							<td width="8%" align="center" id="font1">No.</td>
							<td width="30%" align="center" id="font1">토큰</td>
							<td width="10%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/mobile_page.do?type=${type }&sort=user_id&direction=${direction.equals('desc') ? 'asc' : 'desc' }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }'">사용자 아이디</td>
							<td width="8%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/mobile_page.do?type=${type }&sort=mobile_type&direction=${direction.equals('desc') ? 'asc' : 'desc' }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }'">모바일 종류</td>
							<td width="8%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/mobile_page.do?type=${type }&sort=lang_cd&direction=${direction.equals('desc') ? 'asc' : 'desc' }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }'">언어</td>
							<td width="8%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/mobile_page.do?type=${type }&sort=app_num&direction=${direction.equals('desc') ? 'asc' : 'desc' }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }'">앱 종류</td>
							<td width="8%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/mobile_page.do?type=${type }&sort=app_ver&direction=${direction.equals('desc') ? 'asc' : 'desc' }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }'">앱 버전</td>
							<td width="8%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/mobile_page.do?type=${type }&sort=register_count&direction=${direction.equals('desc') ? 'asc' : 'desc' }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }'">등록한 장비 개수</td>
							<td width="12%" align="center" id="font1" style="cursor:pointer;" onclick="location.href='/PushAdmin/mobile_page.do?type=${type }&sort=create_date&direction=${direction.equals('desc') ? 'asc' : 'desc' }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }'">등록일</td>
						</tr>
						<tr height="0.1">
							<td colspan="9">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<c:forEach var="mobile_list" items="${mobile_list }">
							<tr height="40">
								<td align="center">${mobile_list.row_idx }</td>
								<td align="center" style="word-break:break-all;white-space:nowrap;text-overflow:ellipsis;overflow:hidden"><strong style="font-size: 11px;">${mobile_list.token_id }</strong></td>
								<td align="center">${mobile_list.user_id }</td>
								<td align="center">
									<c:choose>
										<c:when test="${mobile_list.mobile_type == 1}">Android</c:when>
										<c:when test="${mobile_list.mobile_type == 2}">iOS</c:when>
										<c:otherwise>${mobile_list.mobile_type}</c:otherwise>
									</c:choose>
								</td>
								<td align="center">
									<c:choose>
										<c:when test="${mobile_list.lang_cd == 1}">Korean</c:when>
										<c:when test="${mobile_list.lang_cd == 2}">English</c:when>
										<c:otherwise>${mobile_list.lang_cd}</c:otherwise>
									</c:choose>
								</td>
								<td align="center">
									<c:choose>
										<c:when test="${mobile_list.app_num == 10}">OCT INAPP</c:when>
										<c:when test="${mobile_list.app_num == 9}">OCT Plus</c:when>
										<c:when test="${mobile_list.app_num == 7}">Sea Black Box</c:when>
										<c:when test="${mobile_list.app_num == 6}">Olleh CCTV Telecop</c:when>
										<c:when test="${mobile_list.app_num == 0}"></c:when>
										<c:otherwise>${mobile_list.app_num}</c:otherwise>
									</c:choose>
								</td>
								<td align="center">${mobile_list.app_ver }</td>
								<td align="center">${mobile_list.register_count }</td>
								<td align="center">${mobile_list.create_date }</td>
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
									<a href="/PushAdmin/mobile_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${1 }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }">[맨앞]</a>
									<a href="/PushAdmin/mobile_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page - 10 }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }">[이전]</a>
								</c:if>
								<c:forEach var="a" begin="${start_page }" end="${end_page <= last_page ? end_page : last_page }">
									<c:choose>
										<c:when test="${current_page == a }">
											<a>[${a }]</a>
										</c:when>
										<c:otherwise>
											<a href="/PushAdmin/mobile_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${a }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }">[${a }]</a>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								<c:if test="${end_page < last_page }">
									<a href="/PushAdmin/mobile_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page + 10 }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }">[다음]</a>
									<a href="/PushAdmin/mobile_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${last_page }&user_id=${user_id }&mobile_type=${mobile_type }&start_create_date=${start_create_date }&end_create_date=${end_create_date }">[맨뒤]</a>
								</c:if>
							</td>
						</tr>
						<tr>
							<td height="30"></td>
						</tr>
						<tr>
							<!-- <td colspan="1" height="30"></td> -->
							<td colspan="7" align="center">
								<form id="search_user_id_form" name="search_user_id_form" action="/PushAdmin/mobile_page.do">사용자 아이디&nbsp;&nbsp;
									<input id="user_id" name="user_id" style="vertical-align: 5%" value="${user_id }">
									<input id="search_user_id_btn" type="button" style="background: #000000; color: white;" value="검색">
									<input type="hidden" name="type" id="type" value="mobile_search_user_id">
								</form>
							</td>
							<td colspan="2" align="right"> 
								<form id="excel_form" name="excel_form" action="/PushAdmin/mobile_excel.xlsx">엑셀 다운로드&nbsp;&nbsp;
									<input id="excel_btn" type="button" style="background: #000000; color: white;" value="현재 페이지">
									<input type="hidden" name="type" id="type" value="${type }">
									<input type="hidden" name="sort" id="sort" value="${sort }">
									<input type="hidden" name="page" id="page" value="${current_page }">
									<input type="hidden" name="direction" id="direction" value="${direction }">
									<c:choose>
										<c:when test="${type == 'mobile_search_user_id' }">
											<input type="hidden" name="user_id_excel" id="user_id_excel" value="${user_id }">
										</c:when>
										<c:when test="${type == 'mobile_search_mobile_type' }">
											<input type="hidden" name="mobile_type_excel" id="mobile_type_excel" value="${mobile_type }">
										</c:when>
										<c:when test="${type == 'mobile_search_create_date' }">
											<input type="hidden" name="start_create_date_excel" id="start_create_date_excel" value="${start_create_date }">
											<input type="hidden" name="end_create_date_excel" id="end_create_date_excel" value="${end_create_date }">
										</c:when>
									</c:choose>
									<input id="excel_all_btn" type="button" style="background: #000000; color: white;" value="전체 페이지">
								</form>
								<form id="excel_all_form" name="excel_all_form" action="/PushAdmin/mobile_excel.xlsx">
									<c:choose>
										<c:when test="${type == 'mobile' }">
											<input type="hidden" name="type" id="type" value="mobile_all">
										</c:when>
										<c:when test="${type == 'mobile_search_user_id' }">
											<input type="hidden" name="type" id="type" value="mobile_search_user_id_all">
											<input type="hidden" name="user_id_excel" id="user_id_excel" value="${user_id }">
										</c:when>
										<c:when test="${type == 'mobile_search_mobile_type' }">
											<input type="hidden" name="type" id="type" value="mobile_search_mobile_type_all">
											<input type="hidden" name="mobile_type_excel" id="mobile_type_excel" value="${mobile_type }">
										</c:when>
										<c:when test="${type == 'mobile_search_create_date' }">
											<input type="hidden" name="type" id="type" value="mobile_search_create_date_all">
											<input type="hidden" name="start_create_date_excel" id="start_create_date_excel" value="${start_create_date }">
											<input type="hidden" name="end_create_date_excel" id="end_create_date_excel" value="${end_create_date }">
										</c:when>
									</c:choose>
									<input type="hidden" name="sort" id="sort" value="${sort }">
									<input type="hidden" name="direction" id="direction" value="${direction }">
								</form>
							</td>
						</tr>
						<tr>
							<!-- <td colspan="2" height="30"></td> -->
							<td colspan="8" align="center">
								<form id="search_mobile_type_form" name="search_mobile_type_form" action="/PushAdmin/mobile_page.do">모바일 종류&nbsp;&nbsp;
									<select name="mobile_type" id="mobile_type">
										<option value=1 ${mobile_type == 1 ? 'selected="selected"' : '' }>Android</option>
										<option value=2 ${mobile_type == 2 ? 'selected="selected"' : '' }>iOS</option>
									</select>
									<input id="search_mobile_type_btn" type="button" style="background: #000000; color: white;" value="검색">
									<input type="hidden" name="type" id="type" value="mobile_search_mobile_type">
								</form>
							</td>
							<td colspan="1" align="right">
								<input type="button" onclick="location.href='/PushAdmin/mobile_page.do'" style="background: #000000; color: white;" value="전체 목록">
							</td>
						</tr>
						<tr>
						<!-- 	<td colspan="3" height="30"></td> -->
							<td colspan="9" align="center" >등록일&nbsp;&nbsp;
								<select name="start_year" id="start_year">
									<option value="2015" ${start_create_date.substring(0, 4) == 2015 ? 'selected="selected"' : '' }>2015</option>
									<option value="2016" ${start_create_date.substring(0, 4) == 2016 ? 'selected="selected"' : '' }>2016</option>
									<option value="2017" ${start_create_date.substring(0, 4) == 2017 ? 'selected="selected"' : '' }>2017</option>
									<option value="2018" ${start_create_date.substring(0, 4) == 2018 ? 'selected="selected"' : '' }>2018</option>
									<option value="2019" ${start_create_date.substring(0, 4) == 2019 ? 'selected="selected"' : '' }>2019</option>
									<option value="2020" ${start_create_date.substring(0, 4) == 2020 ? 'selected="selected"' : '' }>2020</option>
									<option value="2021" ${start_create_date.substring(0, 4) == 2021 ? 'selected="selected"' : '' }>2021</option>
									<option value="2022" ${start_create_date.substring(0, 4) == 2022 ? 'selected="selected"' : '' }>2022</option>
									<option value="2023" ${start_create_date.substring(0, 4) == 2023 ? 'selected="selected"' : '' }>2023</option>
									<option value="2024" ${start_create_date.substring(0, 4) == 2024 ? 'selected="selected"' : '' }>2024</option>
									<option value="2025" ${start_create_date.substring(0, 4) == 2025 ? 'selected="selected"' : '' }>2025</option>
									<option value="2026" ${start_create_date.substring(0, 4) == 2026 ? 'selected="selected"' : '' }>2026</option>
									<option value="2027" ${start_create_date.substring(0, 4) == 2027 ? 'selected="selected"' : '' }>2027</option>
									<option value="2028" ${start_create_date.substring(0, 4) == 2028 ? 'selected="selected"' : '' }>2028</option>
									<option value="2029" ${start_create_date.substring(0, 4) == 2029 ? 'selected="selected"' : '' }>2029</option>
									<option value="2030" ${start_create_date.substring(0, 4) == 2030 ? 'selected="selected"' : '' }>2030</option>
									<option value="2031" ${start_create_date.substring(0, 4) == 2031 ? 'selected="selected"' : '' }>2031</option>
									<option value="2032" ${start_create_date.substring(0, 4) == 2032 ? 'selected="selected"' : '' }>2032</option>
									<option value="2033" ${start_create_date.substring(0, 4) == 2033 ? 'selected="selected"' : '' }>2033</option>
									<option value="2034" ${start_create_date.substring(0, 4) == 2034 ? 'selected="selected"' : '' }>2034</option>
									<option value="2035" ${start_create_date.substring(0, 4) == 2035 ? 'selected="selected"' : '' }>2035</option>
									<option value="2036" ${start_create_date.substring(0, 4) == 2036 ? 'selected="selected"' : '' }>2036</option>
									<option value="2037" ${start_create_date.substring(0, 4) == 2037 ? 'selected="selected"' : '' }>2037</option>
									<option value="2038" ${start_create_date.substring(0, 4) == 2038 ? 'selected="selected"' : '' }>2038</option>
									<option value="2039" ${start_create_date.substring(0, 4) == 2039 ? 'selected="selected"' : '' }>2039</option>
									<option value="2040" ${start_create_date.substring(0, 4) == 2040 ? 'selected="selected"' : '' }>2040</option>
								</select>년
								<select name="start_month" id="start_month" onChange="start_month_change(this);">
									<option value="1" ${start_create_date.substring(4, 6) == 01 ? 'selected="selected"' : '' }>1</option>
									<option value="2" ${start_create_date.substring(4, 6) == 02 ? 'selected="selected"' : '' }>2</option>
									<option value="3" ${start_create_date.substring(4, 6) == 03 ? 'selected="selected"' : '' }>3</option>
									<option value="4" ${start_create_date.substring(4, 6) == 04 ? 'selected="selected"' : '' }>4</option>
									<option value="5" ${start_create_date.substring(4, 6) == 05 ? 'selected="selected"' : '' }>5</option>
									<option value="6" ${start_create_date.substring(4, 6) == 06 ? 'selected="selected"' : '' }>6</option>
									<option value="7" ${start_create_date.substring(4, 6) == 07 ? 'selected="selected"' : '' }>7</option>
									<option value="8" ${start_create_date.substring(4, 6) == 08 ? 'selected="selected"' : '' }>8</option>
									<option value="9" ${start_create_date.substring(4, 6) == 09 ? 'selected="selected"' : '' }>9</option>
									<option value="10" ${start_create_date.substring(4, 6) == 10 ? 'selected="selected"' : '' }>10</option>
									<option value="11" ${start_create_date.substring(4, 6) == 11 ? 'selected="selected"' : '' }>11</option>
									<option value="12" ${start_create_date.substring(4, 6) == 12 ? 'selected="selected"' : '' }>12</option>
								</select>월
								<select name="start_day" id="start_day">
									<option value="1" ${start_create_date.substring(6, 8) == 01 ? 'selected="selected"' : '' }>1</option>
									<option value="2" ${start_create_date.substring(6, 8) == 02 ? 'selected="selected"' : '' }>2</option>
									<option value="3" ${start_create_date.substring(6, 8) == 03 ? 'selected="selected"' : '' }>3</option>
									<option value="4" ${start_create_date.substring(6, 8) == 04 ? 'selected="selected"' : '' }>4</option>
									<option value="5" ${start_create_date.substring(6, 8) == 05 ? 'selected="selected"' : '' }>5</option>
									<option value="6" ${start_create_date.substring(6, 8) == 06 ? 'selected="selected"' : '' }>6</option>
									<option value="7" ${start_create_date.substring(6, 8) == 07 ? 'selected="selected"' : '' }>7</option>
									<option value="8" ${start_create_date.substring(6, 8) == 08 ? 'selected="selected"' : '' }>8</option>
									<option value="9" ${start_create_date.substring(6, 8) == 09 ? 'selected="selected"' : '' }>9</option>
									<option value="10" ${start_create_date.substring(6, 8) == 10 ? 'selected="selected"' : '' }>10</option>
									<option value="11" ${start_create_date.substring(6, 8) == 11 ? 'selected="selected"' : '' }>11</option>
									<option value="12" ${start_create_date.substring(6, 8) == 12 ? 'selected="selected"' : '' }>12</option>
									<option value="13" ${start_create_date.substring(6, 8) == 13 ? 'selected="selected"' : '' }>13</option>
									<option value="14" ${start_create_date.substring(6, 8) == 14 ? 'selected="selected"' : '' }>14</option>
									<option value="15" ${start_create_date.substring(6, 8) == 15 ? 'selected="selected"' : '' }>15</option>
									<option value="16" ${start_create_date.substring(6, 8) == 16 ? 'selected="selected"' : '' }>16</option>
									<option value="17" ${start_create_date.substring(6, 8) == 17 ? 'selected="selected"' : '' }>17</option>
									<option value="18" ${start_create_date.substring(6, 8) == 18 ? 'selected="selected"' : '' }>18</option>
									<option value="19" ${start_create_date.substring(6, 8) == 19 ? 'selected="selected"' : '' }>19</option>
									<option value="20" ${start_create_date.substring(6, 8) == 20 ? 'selected="selected"' : '' }>20</option>
									<option value="21" ${start_create_date.substring(6, 8) == 21 ? 'selected="selected"' : '' }>21</option>
									<option value="22" ${start_create_date.substring(6, 8) == 22 ? 'selected="selected"' : '' }>22</option>
									<option value="23" ${start_create_date.substring(6, 8) == 23 ? 'selected="selected"' : '' }>23</option>
									<option value="24" ${start_create_date.substring(6, 8) == 24 ? 'selected="selected"' : '' }>24</option>
									<option value="25" ${start_create_date.substring(6, 8) == 25 ? 'selected="selected"' : '' }>25</option>
									<option value="26" ${start_create_date.substring(6, 8) == 26 ? 'selected="selected"' : '' }>26</option>
									<option value="27" ${start_create_date.substring(6, 8) == 27 ? 'selected="selected"' : '' }>27</option>
									<option value="28" ${start_create_date.substring(6, 8) == 28 ? 'selected="selected"' : '' }>28</option>
									<option value="29" ${start_create_date.substring(6, 8) == 29 ? 'selected="selected"' : '' }>29</option>
									<option value="30" ${start_create_date.substring(6, 8) == 30 ? 'selected="selected"' : '' }>30</option>
									<option value="31" ${start_create_date.substring(6, 8) == 31 ? 'selected="selected"' : '' }>31</option>
								</select>일 ~ 
								<select name="end_year" id="end_year">
									<option value="2015" ${end_create_date.substring(0, 4) == 2015 ? 'selected="selected"' : '' }>2015</option>
									<option value="2016" ${end_create_date.substring(0, 4) == 2016 ? 'selected="selected"' : '' }>2016</option>
									<option value="2017" ${end_create_date.substring(0, 4) == 2017 ? 'selected="selected"' : '' }>2017</option>
									<option value="2018" ${end_create_date.substring(0, 4) == 2018 ? 'selected="selected"' : '' }>2018</option>
									<option value="2019" ${end_create_date.substring(0, 4) == 2019 ? 'selected="selected"' : '' }>2019</option>
									<option value="2020" ${end_create_date.substring(0, 4) == 2020 ? 'selected="selected"' : '' }>2020</option>
									<option value="2021" ${end_create_date.substring(0, 4) == 2021 ? 'selected="selected"' : '' }>2021</option>
									<option value="2022" ${end_create_date.substring(0, 4) == 2022 ? 'selected="selected"' : '' }>2022</option>
									<option value="2023" ${end_create_date.substring(0, 4) == 2023 ? 'selected="selected"' : '' }>2023</option>
									<option value="2024" ${end_create_date.substring(0, 4) == 2024 ? 'selected="selected"' : '' }>2024</option>
									<option value="2025" ${end_create_date.substring(0, 4) == 2025 ? 'selected="selected"' : '' }>2025</option>
									<option value="2026" ${end_create_date.substring(0, 4) == 2026 ? 'selected="selected"' : '' }>2026</option>
									<option value="2027" ${end_create_date.substring(0, 4) == 2027 ? 'selected="selected"' : '' }>2027</option>
									<option value="2028" ${end_create_date.substring(0, 4) == 2028 ? 'selected="selected"' : '' }>2028</option>
									<option value="2029" ${end_create_date.substring(0, 4) == 2029 ? 'selected="selected"' : '' }>2029</option>
									<option value="2030" ${end_create_date.substring(0, 4) == 2030 ? 'selected="selected"' : '' }>2030</option>
									<option value="2031" ${end_create_date.substring(0, 4) == 2031 ? 'selected="selected"' : '' }>2031</option>
									<option value="2032" ${end_create_date.substring(0, 4) == 2032 ? 'selected="selected"' : '' }>2032</option>
									<option value="2033" ${end_create_date.substring(0, 4) == 2033 ? 'selected="selected"' : '' }>2033</option>
									<option value="2034" ${end_create_date.substring(0, 4) == 2034 ? 'selected="selected"' : '' }>2034</option>
									<option value="2035" ${end_create_date.substring(0, 4) == 2035 ? 'selected="selected"' : '' }>2035</option>
									<option value="2036" ${end_create_date.substring(0, 4) == 2036 ? 'selected="selected"' : '' }>2036</option>
									<option value="2037" ${end_create_date.substring(0, 4) == 2037 ? 'selected="selected"' : '' }>2037</option>
									<option value="2038" ${end_create_date.substring(0, 4) == 2038 ? 'selected="selected"' : '' }>2038</option>
									<option value="2039" ${end_create_date.substring(0, 4) == 2039 ? 'selected="selected"' : '' }>2039</option>
									<option value="2040" ${end_create_date.substring(0, 4) == 2040 ? 'selected="selected"' : '' }>2040</option>
								</select>년
								<select name="end_month" id="end_month" onChange="end_month_change(this);">
									<option value="1" ${end_create_date.substring(4, 6) == 01 ? 'selected="selected"' : '' }>1</option>
									<option value="2" ${end_create_date.substring(4, 6) == 02 ? 'selected="selected"' : '' }>2</option>
									<option value="3" ${end_create_date.substring(4, 6) == 03 ? 'selected="selected"' : '' }>3</option>
									<option value="4" ${end_create_date.substring(4, 6) == 04 ? 'selected="selected"' : '' }>4</option>
									<option value="5" ${end_create_date.substring(4, 6) == 05 ? 'selected="selected"' : '' }>5</option>
									<option value="6" ${end_create_date.substring(4, 6) == 06 ? 'selected="selected"' : '' }>6</option>
									<option value="7" ${end_create_date.substring(4, 6) == 07 ? 'selected="selected"' : '' }>7</option>
									<option value="8" ${end_create_date.substring(4, 6) == 08 ? 'selected="selected"' : '' }>8</option>
									<option value="9" ${end_create_date.substring(4, 6) == 09 ? 'selected="selected"' : '' }>9</option>
									<option value="10" ${end_create_date.substring(4, 6) == 10 ? 'selected="selected"' : '' }>10</option>
									<option value="11" ${end_create_date.substring(4, 6) == 11 ? 'selected="selected"' : '' }>11</option>
									<option value="12" ${end_create_date.substring(4, 6) == 12 ? 'selected="selected"' : '' }>12</option>
								</select>월
								<select name="end_day" id="end_day">
									<option value="1" ${end_create_date.substring(6, 8) == 01 ? 'selected="selected"' : '' }>1</option>
									<option value="2" ${end_create_date.substring(6, 8) == 02 ? 'selected="selected"' : '' }>2</option>
									<option value="3" ${end_create_date.substring(6, 8) == 03 ? 'selected="selected"' : '' }>3</option>
									<option value="4" ${end_create_date.substring(6, 8) == 04 ? 'selected="selected"' : '' }>4</option>
									<option value="5" ${end_create_date.substring(6, 8) == 05 ? 'selected="selected"' : '' }>5</option>
									<option value="6" ${end_create_date.substring(6, 8) == 06 ? 'selected="selected"' : '' }>6</option>
									<option value="7" ${end_create_date.substring(6, 8) == 07 ? 'selected="selected"' : '' }>7</option>
									<option value="8" ${end_create_date.substring(6, 8) == 08 ? 'selected="selected"' : '' }>8</option>
									<option value="9" ${end_create_date.substring(6, 8) == 09 ? 'selected="selected"' : '' }>9</option>
									<option value="10" ${end_create_date.substring(6, 8) == 10 ? 'selected="selected"' : '' }>10</option>
									<option value="11" ${end_create_date.substring(6, 8) == 11 ? 'selected="selected"' : '' }>11</option>
									<option value="12" ${end_create_date.substring(6, 8) == 12 ? 'selected="selected"' : '' }>12</option>
									<option value="13" ${end_create_date.substring(6, 8) == 13 ? 'selected="selected"' : '' }>13</option>
									<option value="14" ${end_create_date.substring(6, 8) == 14 ? 'selected="selected"' : '' }>14</option>
									<option value="15" ${end_create_date.substring(6, 8) == 15 ? 'selected="selected"' : '' }>15</option>
									<option value="16" ${end_create_date.substring(6, 8) == 16 ? 'selected="selected"' : '' }>16</option>
									<option value="17" ${end_create_date.substring(6, 8) == 17 ? 'selected="selected"' : '' }>17</option>
									<option value="18" ${end_create_date.substring(6, 8) == 18 ? 'selected="selected"' : '' }>18</option>
									<option value="19" ${end_create_date.substring(6, 8) == 19 ? 'selected="selected"' : '' }>19</option>
									<option value="20" ${end_create_date.substring(6, 8) == 20 ? 'selected="selected"' : '' }>20</option>
									<option value="21" ${end_create_date.substring(6, 8) == 21 ? 'selected="selected"' : '' }>21</option>
									<option value="22" ${end_create_date.substring(6, 8) == 22 ? 'selected="selected"' : '' }>22</option>
									<option value="23" ${end_create_date.substring(6, 8) == 23 ? 'selected="selected"' : '' }>23</option>
									<option value="24" ${end_create_date.substring(6, 8) == 24 ? 'selected="selected"' : '' }>24</option>
									<option value="25" ${end_create_date.substring(6, 8) == 25 ? 'selected="selected"' : '' }>25</option>
									<option value="26" ${end_create_date.substring(6, 8) == 26 ? 'selected="selected"' : '' }>26</option>
									<option value="27" ${end_create_date.substring(6, 8) == 27 ? 'selected="selected"' : '' }>27</option>
									<option value="28" ${end_create_date.substring(6, 8) == 28 ? 'selected="selected"' : '' }>28</option>
									<option value="29" ${end_create_date.substring(6, 8) == 29 ? 'selected="selected"' : '' }>29</option>
									<option value="30" ${end_create_date.substring(6, 8) == 30 ? 'selected="selected"' : '' }>30</option>
									<option value="31" ${end_create_date.substring(6, 8) == 31 ? 'selected="selected"' : '' }>31</option>
								</select>일&nbsp;
								<input type="button" style="background: #000000; color: white;" value="검색" onclick="javascript:mobile_search_create_date()">
								<form action="/PushAdmin/mobile_page.do" id="search_create_date_form">
									<input type="hidden" name="start_create_date" id="start_create_date" value="">
									<input type="hidden" name="end_create_date" id="end_create_date" value="">
									<input type="hidden" name="type" id="type" value="mobile_search_create_date">
								</form>
							</td>
						</tr>
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