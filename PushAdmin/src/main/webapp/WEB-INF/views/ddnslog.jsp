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

<title>DDNS Log</title>
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

function ddnslog_search_create_date()
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
						<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="3" align="center" class="font2">D D N S&nbsp;&nbsp;&nbsp;L O G</td>
					</tr>
					<tr height="30">
						<td></td>
					</tr>
					<tr height="0.1">
						<td colspan="3">
							<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
						</td>
					</tr>
					<tr align="center">
						<td width="20%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/ddnslog_page.do?type=${type }&sort=mac&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }&start_create_date=${start_create_date }&end_create_date=${end_create_date }'">맥 주소</span></td>
						<td width="60%" class="font1"><span>메시지</span></td>
						<td width="20%" class="select font1"><span style="cursor:pointer;" onclick="location.href='/PushAdmin/ddnslog_page.do?type=${type }&sort=create_time&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }&start_create_date=${start_create_date }&end_create_date=${end_create_date }'">시간</span></td>
					</tr>
					<tr height="0.1">
						<td colspan="3">
							<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
						</td>
					</tr>
					<c:forEach var="ddnslog_list" items="${ddnslog_list }">
						<tr align="center" height="30">
							<td>${ddnslog_list.mac }</td>
							<td>${ddnslog_list.message }</td>
							<td>${ddnslog_list.create_time }</td>
						</tr>
						<tr height="0.1">
							<td colspan="3">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
					</c:forEach>
					<tr height="30">
						<td></td>
					</tr>
					<tr>
						<td colspan="3" align="center">
							<c:if test="${start_page > 10 }">
								<a href="/PushAdmin/ddnslog_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${1 }&search_type=${search_type }&search_word=${search_word }&start_create_date=${start_create_date }&end_create_date=${end_create_date }">[맨앞]</a>
								<a href="/PushAdmin/ddnslog_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page - 10 }&search_type=${search_type }&search_word=${search_word }&start_create_date=${start_create_date }&end_create_date=${end_create_date }">[이전]</a>
							</c:if>
							<c:forEach var="a" begin="${start_page }" end="${end_page <= last_page ? end_page : last_page }">
								<c:choose>
									<c:when test="${current_page == a }">
										<a>[${a }]</a>
									</c:when>
									<c:otherwise>
										<a href="/PushAdmin/ddnslog_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${a }&search_type=${search_type }&search_word=${search_word }&start_create_date=${start_create_date }&end_create_date=${end_create_date }">[${a }]</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<c:if test="${end_page < last_page }">
								<a href="/PushAdmin/ddnslog_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page + 10 }&search_type=${search_type }&search_word=${search_word }&start_create_date=${start_create_date }&end_create_date=${end_create_date }">[다음]</a>
								<a href="/PushAdmin/ddnslog_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${last_page }&search_type=${search_type }&search_word=${search_word }&start_create_date=${start_create_date }&end_create_date=${end_create_date }">[맨뒤]</a>
							</c:if>
						</td>
					</tr>
					<tr height="30">
						<td></td>
					</tr>
					<tr height="30">
						<td></td>
						<td align="center">
							<form id="search_form" name="search_form" action="/PushAdmin/ddnslog_page.do">
								<select name="search_type" id="search_type">
									<option value=0 <c:if test="${search_type == 0}">selected</c:if>>맥 주소</option>
									<option value=1 <c:if test="${search_type == 1}">selected</c:if>>메시지</option>
								</select>
								<input id="search_word" name="search_word" style="vertical-align: 5%; width: 140px" value="${search_word }" maxlength="40">
								<input id="search_btn" type="button" style="background: #000000; color: white;" value="검색">
								<input type="hidden" name="type" id="type" value="ddnslog_search">
							</form>
						</td>
						<td align="right"> 
							<form id="excel_form" name="excel_form" action="/PushAdmin/ddnslog_excel.xlsx">엑셀 다운로드&nbsp;&nbsp;
								<input id="excel_btn" type="button" style="background: #000000; color: white;" value="현재 페이지">
								<input type="hidden" name="type" id="type" value="${type }">
								<input type="hidden" name="sort" id="sort" value="${sort }">
								<input type="hidden" name="page" id="page" value="${current_page }">
								<input type="hidden" name="direction" id="direction" value="${direction }">
								<c:choose>
									<c:when test="${type == 'ddnslog_search' }">
										<input type="hidden" name="search_type_excel" id="search_type_excel" value="${search_type }">
										<input type="hidden" name="search_word_excel" id="search_word_excel" value="${search_word }">
									</c:when>
									<c:when test="${type == 'ddnslog_search_create_date' }">
										<input type="hidden" name="start_create_date_excel" id="start_create_date_excel" value="${start_create_date }">
										<input type="hidden" name="end_create_date_excel" id="end_create_date_excel" value="${end_create_date }">
									</c:when>
								</c:choose>
								<input id="excel_all_btn" type="button" style="background: #000000; color: white;" value="전체 페이지">
							</form>
							<form id="excel_all_form" name="excel_all_form" action="/PushAdmin/ddnslog_excel.xlsx">
								<c:choose>
									<c:when test="${type == 'ddnslog' }">
										<input type="hidden" name="type" id="type" value="ddnslog_all">
									</c:when>
									<c:when test="${type == 'ddnslog_search' }">
										<input type="hidden" name="type" id="type" value="ddnslog_search_all">
										<input type="hidden" name="search_type_excel" id="search_type_excel" value="${search_type }">
										<input type="hidden" name="search_word_excel" id="search_word_excel" value="${search_word }">
									</c:when>
									<c:when test="${type == 'ddnslog_search_create_date' }">
										<input type="hidden" name="type" id="type" value="ddnslog_search_create_date_all">
										<input type="hidden" name="start_create_date_excel" id="start_create_date_excel" value="${start_create_date }">
										<input type="hidden" name="end_create_date_excel" id="end_create_date_excel" value="${end_create_date }">
									</c:when>
								</c:choose>
								<input type="hidden" name="sort" id="sort" value="${sort }">
								<input type="hidden" name="direction" id="direction" value="${direction }">
							</form>
						</td>
					</tr>
					<tr height="30">
						<td></td>
						<td align="center">시간&nbsp;&nbsp;
							<select name="start_year" id="start_year">
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
							<input type="button" style="background: #000000; color: white;" value="검색" onclick="javascript:ddnslog_search_create_date()">
							<form action="/PushAdmin/ddnslog_page.do" id="search_create_date_form">
								<input type="hidden" name="start_create_date" id="start_create_date" value="">
								<input type="hidden" name="end_create_date" id="end_create_date" value="">
								<input type="hidden" name="type" id="type" value="ddnslog_search_create_date">
							</form>
						</td>
						<td align="right">
							<input type="button" onclick="location.href='/PushAdmin/ddnslog_page.do'" style="background: #000000; color: white;" value="전체 목록">
						</td>
					</tr>
					<tr height="30">
						<td></td>
					</tr>
					<tr>
						<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="3" align="center" class="font2">P U S H&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;S E R V E R&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A D M I N I S T R A T O R</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>