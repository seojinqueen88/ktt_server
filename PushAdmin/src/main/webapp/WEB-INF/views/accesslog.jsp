<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap" rel="stylesheet">

<title>ACCESS Log</title>

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
	$("#list_all_btn").click(function(){
		$("#list_all_form").submit();
	});
	$("#excel_all_btn").click(function() {
		alert("데이터의 양에 따라 1~30초 정도의 시간이 소요될 수 있습니다.\n확인 버튼을 누르신 후 잠시만 기다려 주세요.");
		$("#excel_all_form").submit();
	});
});


function search_time_type_change(e)
{
	 
 switch(e.value)
 {
	case '0': 
		document.getElementById('id_accesslog_search_create_date').disabled = true;
	break;
	default:
		document.getElementById('id_accesslog_search_create_date').disabled = false;
	break;
 }
 //console.log(e.value);
// console.log(typeof e.value);
}

function accesslog_search_create_date()
{
	var start_create_date = document.getElementById("start_create_date");
	var start_year = document.getElementById("start_year");
	var start_month = document.getElementById("start_month");
	var start_month_str;
	var start_day = document.getElementById("start_day");
	var start_day_str;
	var sel_search_time_type =  document.getElementById("sel_search_time_type");
	if(sel_search_time_type.value == '0')
	return false;
	if(start_month.value.length < 2)
		start_month_str = "0" + start_month.value;
	else
		start_month_str = start_month.value;

	if(start_day.value.length < 2)
		start_day_str = "0" + start_day.value;
	else
		start_day_str = start_day.value;
	 
	start_create_date.value = start_year.value + start_month_str + start_day_str;
	document.getElementById("search_time_type").value = sel_search_time_type.value;
	 
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
</head>
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
						<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="10" align="center" class="font2">ACCESS &nbsp;&nbsp;&nbsp;L O G</td>
					</tr>
					<tr height="30">
						<td colspan="10"></td>
					</tr>
					<tr height="0.1">
						<td colspan="10">
							<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
						</td>
					</tr>

					<tr align="center">
					<td   ></td>
						<td width="25%" class="font1">
							<span>MAC ADDRESS</span>
						</td>

						<td width="15%" class="select font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/accesslog_page.do?type=${type}&sort=req_date&access_log_type=${access_log_type }&direction=${direction.equals('desc') ? 'asc' : 'desc' }&mac_address=${mac_address }'">TYPE</span>						
						</td>
						<td width="20%" class="font1">
							<span>
								<c:choose>
									<c:when test="${(access_log_type).equals('0')}">APP ACCESS ID</c:when>
									<c:when test="${(access_log_type).equals('1')}">CMS ACCESS ID</c:when>
									<c:when test="${(access_log_type).equals('2')}">DEVICE ACCESS TPYE - 장비</c:when>
									<c:when test="${(access_log_type).equals('3')}">DEVICE ACCESS TPYE - 웹뷰어</c:when>							
									<c:otherwise> 
									ID/TYPE
									           </c:otherwise>
								</c:choose>
							</span>
						</td>
						 <td width="20%" class="font1">
							<span > 	<c:choose>
									<c:when test="${(access_log_type).equals('0')}">REG TYPE</c:when>
									<c:when test="${(access_log_type).equals('1')}">REG TYPE</c:when>
									<c:when test="${(access_log_type).equals('2')}">PROTOCOL TYPE</c:when>
									<c:when test="${(access_log_type).equals('3')}">PROTOCOL TYPE</c:when>
									<c:otherwise> ACCESS TYPE        </c:otherwise>
								</c:choose> 	</span>
						</td>
	
						<td width="20%" class="select font1">																																	 
							<span style="cursor: pointer;" onclick="location.href='/PushAdmin/accesslog_page.do?type=${type}&sort=req_date&access_log_type=${access_log_type }&direction=${direction.equals('desc') ? 'asc' : 'desc' }&mac_address=${mac_address }'">DATE</span>
						</td>
 
					</tr>
					<tr height="0.1">
						<td colspan="10">
							<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
						</td>
					</tr>
					<c:forEach var="accesslog_list" items="${accesslog_list }">
						<tr align="center" height="25">
						<td></td>
							<td>${accesslog_list.mac_address}</td>
							<td>
									<c:choose>
									<c:when test="${accesslog_list.client_access_log_req_type == 0}">APP</c:when>
									<c:when test="${accesslog_list.client_access_log_req_type== 1}">CMS</c:when>
									<c:when test="${accesslog_list.client_access_log_req_type== 2}">장비 </c:when>
									<c:when test="${accesslog_list.client_access_log_req_type== 3}">웹뷰어 </c:when>
									 <c:when test="${accesslog_list.client_access_log_req_type < 0}">UNKOWN</c:when>
									<c:otherwise>${accesslog_list.client_access_log_req_type}</c:otherwise>
								</c:choose>
							</td>

							<c:choose>
								<c:when test="${not empty accesslog_list.req_id && accesslog_list.req_id != ''}">
								<td>
									<c:choose>
									<c:when test="${access_log_type == 2 || access_log_type == 3}">
									 <c:choose>
				
										<c:when test="${accesslog_list.req_id ==0}" > 장비 </c:when>
										<c:when test="${accesslog_list.req_id ==1}" > 웹뷰어 </c:when>
										<c:otherwise>${accesslog_list.api_type}</c:otherwise>
									</c:choose>
									</c:when>
										<c:otherwise>${accesslog_list.req_id}</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
									<c:when test="${access_log_type == 0}">
									<c:choose>
									<c:when test="${accesslog_list.api_type == 0}" > 자동등록 </c:when>
									<c:when test="${accesslog_list.api_type == 1}" > 수동등록 </c:when>
									<c:when test="${accesslog_list.api_type == 2}" > SmartEyesPro </c:when>
									<c:otherwise>${accesslog_list.api_type}</c:otherwise>
									</c:choose>
									
									</c:when>
									<c:when test="${access_log_type == 1}">
									<c:choose>
									<c:when test="${accesslog_list.api_type ==0}" > GiGaEyesPro </c:when>
									<c:when test="${accesslog_list.api_type ==1}" > Olleh CCTV </c:when>
									<c:when test="${accesslog_list.api_type ==2}" > CMS LITE </c:when>
									<c:otherwise>${accesslog_list.api_type}</c:otherwise>
									</c:choose>
									
									</c:when>
									<c:when test="${access_log_type== 2}">
										${accesslog_list.api_type}
									</c:when>
									<c:when test="${access_log_type < 0}">${accesslog_list.api_type}</c:when>
									<c:otherwise>${accesslog_list.api_type} </c:otherwise>
								</c:choose>
									</td>
									<fmt:formatDate var="app_date" value="${accesslog_list.req_date}" type="DATE" pattern="yyyy-MM-dd HH:mm:ss" />
									<td>${app_date }</td>
								</c:when>
								<c:otherwise>
									<td></td>
									<td></td>
								</c:otherwise>
							</c:choose>
						  
						</tr>
						<tr height="0.1">
							<td colspan="10">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
					</c:forEach>
					<tr height="20">
						<td colspan="10"></td>
					</tr>
					<tr>
						<td colspan="6" align="center">
							<c:if test="${start_page > 10 }">			
								<a href="/PushAdmin/accesslog_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${1 }&access_log_type=${access_log_type }&mac_address=${mac_address}">[맨앞]</a>
								<a href="/PushAdmin/accesslog_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page - 10 }&access_log_type=${access_log_type }&mac_address=${mac_address }">[이전]</a>					
							</c:if>
							<c:forEach var="a" begin="${start_page }" end="${end_page <= last_page ? end_page : last_page }">
								<c:choose>
									<c:when test="${current_page == a }">
										<a>[${a }]</a>
									</c:when>
									<c:otherwise>
										<a href="/PushAdmin/accesslog_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${a }&access_log_type=${access_log_type }&mac_address=${mac_address }">[${a }]</a>
										
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<c:if test="${end_page < last_page }">
								<a href="/PushAdmin/accesslog_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${start_page + 10 }&access_log_type=${access_log_type }&mac_address=${mac_address }">[다음]</a>
								<a href="/PushAdmin/accesslog_page.do?type=${type }&sort=${sort }&direction=${direction }&page=${last_page }&access_log_type=${access_log_type }&mac_address=${mac_address }">[맨뒤]</a>
							</c:if>
						</td>
					</tr>
					<tr height="20">
						<td colspan="5"></td>
					</tr>
					<tr height="22">
						<td colspan="4" align="right">
							<form id="search_form" name="search_form" action="/PushAdmin/accesslog_page.do">
								<input type="hidden" name="type" id="type" value="accesslog">
								<input type="hidden" name="sort" id="sort" value="${sort }"> 
								<input type="hidden" name="direction" id="direction" value="${direction }">
								<input type="hidden" name="page" id="page" value="${current_page }"> 														 
															 
								<select name="access_log_type" id="access_log_type" onChange="this.form.submit()">
									<option value=0 <c:if test="${access_log_type == 0}">selected</c:if>>APP ACCESS </option>
									<option value=1 <c:if test="${access_log_type == 1}">selected</c:if>>CMS ACCESS</option>
									<option value=2 <c:if test="${access_log_type == 2}">selected</c:if>>[장비] DEVICE PROTOCOL </option>
									<option value=3 <c:if test="${access_log_type == 3}">selected</c:if>>[웹뷰어] DEVICE PROTOCOL </option>
									<option value=5 <c:if test="${access_log_type == 5}">selected</c:if>>ALL </option>
					
								</select>

								<input type="hidden" name="mac_address" id="mac_address" value="${mac_address}" >
							</form>
						</td>
						<td colspan="3" align="right">
							<form id="excel_form" name="excel_form" action="/PushAdmin/accesslog_excel.xlsx">엑셀 다운로드&nbsp;&nbsp; 
								<input id="excel_btn" type="button" style="background: #000000; color: white;" value="현재 페이지">
								 <input type="hidden" name="type" id="type" value="${type }"> 
								 <input type="hidden" name="sort" id="sort" value="${sort }"> 
								 <input type="hidden" name="page" id="page" value="${current_page }"> 
								 <input type="hidden" name="direction" id="direction" value="${direction }">
								
							<c:if test="${type == 'accesslog' }">
									<input type="hidden" name="search_type_excel" id="search_type_excel" value="${search_type }">
							</c:if>
							
								<input  type="hidden" name="mac_address" id="mac_address" value="${mac_address}" >
								<input type="hidden" name="access_log_type" id="access_log_type" value="${access_log_type}">
								
								<input id="excel_all_btn" type="button" style="background: #000000; color: white;" value="전체 페이지">
									
							</form>
							<form id="excel_all_form" name="excel_all_form" action="/PushAdmin/accesslog_excel.xlsx">
							 <c:choose>
									<c:when test="${type == 'accesslog' }">
										<input type="hidden" name="type" id="type" value="accesslog_all">
									</c:when>
							 </c:choose>
								<input type="hidden" name="sort" id="sort" value="${sort }"> 
								<input type="hidden" name="direction" id="direction" value="${direction }">
								<input type="hidden" name="mac_address" id="mac_address" value="${mac_address}" >
								<input type="hidden" name="access_log_type" id="access_log_type" value="${access_log_type}">
							</form>
						</td>
					</tr>

					<tr height="22">
						<td colspan="9" align="right">
						
						
						<form id="list_all_form" name="list_all_form" action="/PushAdmin/accesslog_page.do">
								<input id="list_all_btn" type="button" style="background: #000000; color: white;" value="전체 목록">
								<input type="hidden" name="access_log_type" id="search_type" value="${5}">
								<input type="hidden" name="type" id="type" value="accesslog">
								<input type="hidden" name="mac_address" id="mac_address" value="${mac_address}" >	
							</form>	
									
							<!--
							<form id="excel_all_form" name="excel_all_form" action="/PushAdmin/accesslog_excel.xlsx">
							<input type="button" onclick="location.href='/PushAdmin/accesslog_excel.do'" style="background: #000000; color: white;" value="전체 목록">
							</form>
							-->
						</td>
					</tr>
					<tr height="30">
						<td colspan="5"></td>
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