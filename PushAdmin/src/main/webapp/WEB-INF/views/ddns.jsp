<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DDNS</title>
<!-- 2023-01-31 DDNS 항목에 access_log출력을 위한 항목 출력으로 font1 ,font2 의 글꼴 사이즈를 기존 14,13px 에서 0.875em으로 13,12px 변경 -->

<style type="text/css">
.select {
	color: #003399;
}

.select :hover {
	text-decoration: underline;
	color: #8080FF;
}

.title {
	height: 30px;
	background-color: #F6F6F6;
}

.font1 {
	font-family: 'Noto Sans KR', Tahoma;
	font-size: 14px;
}

.font2 {
	color: #555555;
	font-family: Arial;
	font-size: 13px;
}

.ui-tooltip {
	padding: 10px 20px;
	color: #fff;
	border-radius: 5px;
	background: #000;
	white-space: pre-line;
}

.ui-tooltip-content {
	/* tooltip content */
	white-space: pre-line;
}
</style>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.fileDownload/1.4.2/jquery.fileDownload.min.js" integrity="sha512-MZrUNR8jvUREbH8PRcouh1ssNRIVHYQ+HMx0HyrZTezmoGwkuWi1XoaRxWizWO8m0n/7FXY2SSAsr2qJXebUcA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<link rel="icon" type="image/x-icon" href="favicon.ico">
<%-- <script src="<c:url value="/js/jquery-3.1.0.min.js"/>"></script> --%>
<%-- <script src="<c:url value="/js/jquery-ui-1.12.0/jquery-ui.min.js"/>"></script> --%>
<%-- <script src="<c:url value="/js/jquery.fileDownload.js"/>"></script> --%>
<script type="text/javascript">

$(document).ready(function() {
	$(".check_all").click(function() {
		if($(".check_all").is(":checked")) $("input[name=select_list_ddns]").prop("checked", true);
		else $("input[name=select_list_ddns]").prop("checked", false);
	});
	
	$("input[name=select_list_ddns]").click(function() {
		var total = $("input[name=select_list_ddns]").length;
		var checked = $("input[name=select_list_ddns]:checked").length;
		
		if(total != checked) $(".check_all").prop("checked", false);
		else $(".check_all").prop("checked", true); 
	});
	 $(".fa-exclamation-circle").tooltip();
});
var childWin = new Array();
var popup_idx = 0;
var url = "${url }";
var auth = "${auth }";
var service_no = "${service_no }";

$(function()
{
	$.ajaxSetup(
	{
		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		type : "post"
	});

	$("#search_btn").click(function()
	{
		if( $("#search_type option:selected").val() == 10)
		{
			var _search_word = $("#search_word").val();
			$("#type").attr("value", "ddns_search_otp_yn");
	
			if(isNaN(_search_word))
				{
				switch(_search_word)
				{
				case "OTP 인증완료":
					$("#search_word").attr("value","3");
					break;
				case "관리자 변경":
					$("#search_word").attr("value","2");
					break;
				case "기존통합앱사용자":
					$("#search_word").attr("value","1");
					break;
				case "OTP 인증 안함":
					$("#search_word").attr("value","0");
					break;
				default:
						return false;
				 }
				}
		}else if( $("#search_type option:selected").val()  == 11)
		{
			var _search_word = $("#search_word").val();
			$("#type").attr("value", "ddns_search_otp_yn");
	
			if(isNaN(_search_word))
				{
				switch(_search_word)
				{
				case "자동등록":
					$("#search_word").attr("value","0");
					break;
				case "수동등록":
					$("#search_word").attr("value","1");
					break;
				default:
						return false;
				 }
				}
		}
		$("#search_form").submit();
	});

	$("#excel_btn").click(function()
	{
		if(url == "ddns_page.do")
			$("#excel_form").attr("action", "/PushAdmin/ddns_excel.xlsx");
		else if(url == "ddns_serviceno.do")
			$("#excel_form").attr("action", "/PushAdmin/ddns_serviceno_excel.xlsx");
		$("#excel_form").submit();
	});

	$("#excel_all_btn").click(function()
	{
		
		alert("데이터의 양에 따라 1~30초 정도의 시간이 소요될 수 있습니다.\n확인 버튼을 누르신 후 잠시만 기다려 주세요.");

		if(url == "ddns_page.do")
			$("#excel_all_form").attr("action", "/PushAdmin/ddns_excel.xlsx");
		else if(url == "ddns_serviceno.do")
			$("#excel_all_form").attr("action", "/PushAdmin/ddns_serviceno_excel.xlsx");
		 
		var $preparingFileModal = $("#preparing-file-modal");
	    $preparingFileModal.dialog({ modal: true });
	        $("#progressbar").progressbar({value: false});
	     $("#progressbar").focus();
		//$("#excel_all_form").submit();
		$.fileDownload($('#excel_all_form').prop('action'), { 
		    //preparingMessageHtml: "We are preparing your report, please wait...", 
		    //failMessageHtml: "There was a problem generating your report, please try again.", 
		    httpMethod: "POST", 
		    data: $('#excel_all_form').serialize(), 
		    successCallback: function (url) { 
		    	//alert("Sucess Download"); 
		        $preparingFileModal.dialog('close');
		    },
		    failCallback: function (responseHtml, url, error) { 
		     
		     alert("fail Download"); 
		     $preparingFileModal.dialog('close');
             $("#error-modal").dialog({ modal: true });
		    } 
		});

	});

	$("#list_all_btn").click(function()
	{
		$("#list_all_form").submit();
	});
});

function connect_web(addr, webport)
{
	window.open("https://" + addr.trim() + ":" + webport.trim() + "/cgi-bin/login_chk.cgi");
}

function check_network(domain, mac)
{
	closeChildWin();
	if(url == "ddns_page.do")
		open_popup("/PushAdmin/network_ddns_page.do?url=" + url + "&domain=" + domain + "&mac=" + mac);
	else if(url == "ddns_serviceno.do")
		open_popup("/PushAdmin/network_ddns_serviceno.do?url=" + url + "&domain=" + domain + "&mac=" + mac + "&auth=" + auth + "&service_no=" + service_no);
}

function view_service_status_modify(domain, mac, service_user)
{
	closeChildWin();
	if(url == "ddns_page.do")
		open_popup("/PushAdmin/check_ddns_service_page.do?url=" + url + "&domain=" + domain + "&mac=" + mac + "&service_user=" + service_user);

}

function modify_otp_yn(id, mac , cur_otp_yn)
{
	var JSON_DATA = {"id" : id , "mac" : mac , "otp_yn" : cur_otp_yn};
	//id --> otp_yn을 수정한 ID
	//console.log("modify_otp_yn >>> mac : " + mac);
	//console.log("modify_otp_yn >>> otp_yn : " + cur_otp_yn);
	//console.log(typeof cur_otp_yn);
	if(typeof cur_otp_yn =='string' )
		cur_otp_yn = parseInt(cur_otp_yn , 10);
	switch(cur_otp_yn)
	{
	case 0:
	case 1:
	case 2:
		open_popup("/PushAdmin/modify_otp_yn.do?mac=" + mac + "&otp_yn=" + cur_otp_yn + "&id=" + id);
		break;
	default:
			alert("해당 OTP 인증은 수정할 수 없습니다.");
		break;
	}
}

function modify_access_rule(id, mac , cur_access_rule)
{
	var JSON_DATA = {"id" : id , "mac" : mac , "access_rule" : cur_access_rule};
	//id --> 수정한 ID
	if(typeof cur_access_rule =='string' )
	cur_access_rule = parseInt(cur_access_rule , 10);
	switch(cur_access_rule)
	{
	case 0:
	case 1:
	case 2:
		open_popup("/PushAdmin/modify_access_rule.do?mac=" + mac + "&access_rule=" + cur_access_rule + "&id=" + id);
		break;
	default:
			alert(" 수정할 수 없습니다. 관리자에게 문의하세요");
		break;
	}
}

function chk_service_no(serviceNo, mac)
{
	var JSON_DATA = {"mac" : mac};
	console.log("ddns_page >>> serviceNo: " + serviceNo);
		$.ajax({
			type : "post",
			url : "chk_service_no.do",
			data : JSON.stringify(JSON_DATA),
			contentType : "application/json; charset=UTF-8",
			success : function(data) {
				// console.log(data); 0-신규, 1-설변, 2-유지보수동일교체, 3-AS, 4-일반, 5-고객(영상lib), 6-고객통합앱서버, 7-기존등록
				if(serviceNo.length < 8){
					switch(data)
					{
					case 0 :
					case 1 :
					case 2 :
					case 3 :
					case 4 :
					case 5 :
					case 6 :
					case 7 :
						open_popup("/PushAdmin/chk_service_no_modify_page.do?serviceNo=" + serviceNo + "&mac=" + mac);
						break;
					default:
						alert("관리자에게 문의하세요.");						
						break;
					}
				}
				else if(serviceNo.length == 8){
					switch(data)
					{
					case 0 :
					case 1 :
					case 2 :
						alert("해당 서비스 번호는 수정할 수 없습니다.");
						break;
					case 3 :
					case 4 :
					case 5 :
					case 6 :
					case 7 :
						open_popup("/PushAdmin/chk_service_no_modify_page.do?serviceNo=" + serviceNo + "&mac=" + mac);
						break;
					default:
						alert("관리자에게 문의하세요.");						
						break;
					}
				}
				},
				error : function(request,status,error) {
		       		alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		       		console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		       	}
			});		
}

function open_popup(page_name)
{
	var winHeight = document.body.clientHeight;
	var winWidth = document.body.clientWidth;
	var winX = window.screenLeft;
	var winY = window.screenTop;

	var popX = winX + (winWidth - 600)/2;
	var popY = winY + (winHeight - 460)/2;
	childWin[popup_idx++] = window.open(page_name, "open_popup", "width=" + 600 + "px,height=" + 460 + "px,top=" + popY + ",left=" + popX);
}

function closeChildWin()
{
	for(var i = 0; i < childWin.length; i++)
	{
		if(childWin[i] && childWin[i].open && !childWin[i].closed)
			childWin[i].close();
	}
}

/* DDNS 장비 선택 삭제
 * 
 */
function checkList(){
	var cnt = $("input[name='select_list_ddns']:checked").length;
	var arr = new Array();
	$("input[name='select_list_ddns']:checked").each(function(){
		arr.push($(this).attr('value'));
	});
	var obj = new Object();
	obj.mac= arr;
	
	
	if(cnt == 0)
	{
		alert("선택된 장비가 없습니다.");
	}
	else
	{
		alert("선택된 장비의 mac 목록: \n" + arr.join("\n") + "\n 선택된 장비는 총   " + cnt + " 대 입니다.");
		var chk = confirm("삭제하시겠습니까?");
		if(chk == true){
			console.log("mac: "+ obj.mac +"여기까지");
			console.log("선택된 장비가 삭제됩니다! >>>> ajax 시작");
			$.ajax({
				type : 'POST',
				url : 'push_ddns_user_delete_service.do',
				data : JSON.stringify(obj),
				dataType : 'text',
				contentType : 'application/json; charset=UTF-8',
				success : function(data) {
						
						switch(data)
						{
						case "success" :
							alert("삭제가 완료되었습니다.");
							location.reload();
							window.close();
							break;
						case "failed" :
							alert("삭제에 실패하였습니다.");
							break;
						case "checked" :
							alert("관리자를 통한 확인이 필요합니다.");
							break;
						case "null-checked" :
							alert("mac이 확인되지 않습니다.");
							break;
						case "failed-length" :
							alert("mac 값이 기존 형식과 다릅니다.");
							break;
						default:
							alert(data);
							break;
						}
					},
					error : function(request,status,error) {
			       		alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			       		console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			       	}
				});
		}
		else 
		{
			alert("취소되었습니다.");
		}
	}
}
</script>

</head>
<!-- 2023-01-31 DDNS 항목에 access_log출력을 위한 항목 출력으로 body의 글꼴 사이즈를 기존 1em (top.jsp) 에서 0.875em으로 변경 //SJ 0.875 ->1 변경 -->
<body style="font-family: 'Noto Sans KR', sans-serif; font-size: 1em;">
	<!-- 파일 생성중 보여질 진행막대를 포함하고 있는 다이얼로그 입니다. -->
	<div title="Data Download" id="preparing-file-modal" style="display: none;">
		<div id="progressbar" style="width: 100%; height: 22px; margin-top: 20px;"></div>
	</div>

	<!-- 에러발생시 보여질 메세지 다이얼로그 입니다. -->
	<div title="Error" id="error-modal" style="display: none;">
		<p>생성실패.</p>
	</div>
	<table width="100%">
		<tr height="50">
			<td></td>
		</tr>
		<c:if test="${url.equals('ddns_page.do') }">
			<tr>
				<td><jsp:include page="top.jsp" /></td>
			</tr>
		</c:if>
		<tr>
			<td>
				<table border="0" width="100%" style="border-collapse: collapse;">
					<tr>
						<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="14" align="center" class="font2">D D N S</td>
					</tr>
					<!--<tr height="30">
										<td colspan="11"></td>
										<td>
											<a target='_blank' href="/PushAdmin/ddnslog_page.do"><b>Goto DDNS
													Log</b></a>
										</td>
									</tr> --!>
									
									<tr height="0.1">
										<td colspan="14">
											<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
										</td>
									</tr>
									<tr align="center">
										<td width="4%" class="title font1"><span>No.</span></td>
										<td width="10%" class="select title font1"><span style="cursor: pointer;"
												onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=domain&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">도메인</span>
										</td>
										<td width="5%" class="select title font1"><span style="cursor: pointer;"
												onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=maker&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">제조사</span>
										</td>
										<td width="5%" class="select title font1"><span style="cursor: pointer;"
												onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=empty2&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">모델</span>
										</td>
										<td width="7%" class="select title font1"><span style="cursor: pointer;"
												onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=addr&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">외부
												IP</span></td>
										<td width="5%" class="select title font1"><span style="cursor: pointer;"
												onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=port&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">포트</span>
										</td>
										<td width="8%" class="select title font1"><span style="cursor: pointer;"
												onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=last_access_master_key_time&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">정책획득
												</span></td>
										<td width="9%" class="select title font1"><span style="cursor: pointer;"
												onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=p2p_uid&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">P2P
												INFO </span></td>
										<td width="8%" class="select title font1"><span style="cursor: pointer;"
												onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=p2p_device&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">장비
												P2P 보유 여부</span></td>
										<td width="5%" class="select title font1"><span style="cursor: pointer;"
												onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=regtime&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">등록일</span>
										</td>
										<td width="7%" class="select title font1"><span style="cursor: pointer;"
												onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=register_type&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">등록
												타입</span></td>
										<%-- <td width="10%" class="select title font1"><span style="cursor:pointer;"
												onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=empty1&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">IP
												갱신</span>
							</td> --%>
							<td width="9%" class="select title font1"><span style="cursor: pointer;"
									onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=empty1&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">IP 갱신 (IP 할당)</span></td>
							<td width="8%" class="select title font1"><span style="cursor: pointer;"
									onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=app_access_id&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">APP ACCESS</span></td>
							<td width="9%" class="select title font1"><span style="cursor: pointer;"
									onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=cms_access_id&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">CMS ACCESS</span></td>
						</tr>
						<tr align="center">

							<td class="title">
								<!-- 20220121 장비 삭제/서비스 상태 변경 기능 계정 권한 확인 추가 START -->
					<c:if test="${login_member.member_auth == 2 }">
						<input type="checkbox" id="allCheckBox" class="check_all" onclick="allChecked(this)">
					</c:if>
					<!-- END -->
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=jumin&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">맥 주소/로그인 정책</span>
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=eqcat&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">장비</span>
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=empty3&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">버전</span>
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=privateip&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">내부 IP</span>
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=webport&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">웹 포트</span>
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=service_no&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">서비스 번호</span>
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=service_open&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">서비스 개통 구분</span>
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=service_user&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">DDNS 상태</span>
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=tel2&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">UPnP</span>
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=employee_no&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">사원/앱ID</span>
					</td>
					<!-- 						<td class="title font1"><span>IP 활성</span></td> -->
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=otp_yn&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">OTP 인증</span>
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=device_accesslog_type_t0&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">장비 ACCESS</span>
					</td>
					<td class="select title font1">
						<span style="cursor: pointer;" onclick="location.href='/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=device_accesslog_type_t1&direction=${direction == 'desc' ? 'asc' : 'desc' }&search_type=${search_type }&search_word=${search_word }'">웹뷰어 ACCESS</span>
					</td>
					</tr>
					<tr height="0.1">
						<td colspan="14">
							<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
						</td>
					</tr>
					<c:forEach var="ddns_list" items="${ddns_list }">
						<tr align="center" height="30">
							<td>
								<c:out value="${ddns_list.row_idx }" />
							</td>
							<td class="select select_list_domain">
								<span style="cursor: pointer; white-space: nowrap;" onclick="check_network('${ddns_list.domain }', '${ddns_list.jumin }')"><c:out value="${ddns_list.domain }" /></span>
							</td>
							<td style="white-space: nowrap;">
								<c:out value="${ddns_list.maker }" />
							</td>
							<td style="white-space: nowrap;">
								<c:out value="${ddns_list.empty2 }" />
							</td>
							<td style="white-space: nowrap;">
								<c:out value="${ddns_list.addr }" />
							</td>
							<td style="white-space: nowrap;">
								<c:out value="${ddns_list.port }" />
							</td>
							<td>
								<c:choose>
								<c:when test="${not empty ddns_list.last_access_master_key_time && ddns_list.last_access_master_key_time != ''}">
								<fmt:formatDate var="last_access_master_key_time" value="${ddns_list.last_access_master_key_time}" type="DATE" pattern="yyyy-MM-dd HH:mm:ss" />
								 <c:out value= "${last_access_master_key_time}"/>
								</c:when>
								<c:otherwise> </c:otherwise>
								</c:choose>
							</td>
								<c:choose>
							
							<c:when test="${not empty ddns_list.p2p_uid && ddns_list.p2p_uid != ''}">
				
								<c:choose>
									<c:when test="${ddns_list.p2p_priority == 2}"><td title="P2P만 사용"> <c:out value="${ddns_list.p2p_uid }" /> </td></c:when>
									<c:when test="${ddns_list.p2p_priority == 1}"><td title="Auto">     <c:out value="${ddns_list.p2p_uid }" /> </td></c:when>
									<c:when test="${ddns_list.p2p_priority == 0}"><td title="P2P 사용 안 함">     <c:out value="${ddns_list.p2p_uid }" /> </td></c:when>
									<c:otherwise> <td title ="P2P 우선순위${ddns_list.p2p_priority}">    <c:out value="${ddns_list.p2p_uid }" /></td></c:otherwise>
								</c:choose>
								</c:when>
								<c:otherwise>
								 <td>
									<c:choose>
									<c:when test="${ddns_list.p2p_priority == 2}">P2P만 사용</c:when>
									<c:when test="${ddns_list.p2p_priority == 1}">Auto</c:when>
									<c:when test="${ddns_list.p2p_priority == 0}">P2P 사용 안 함</c:when>
									<c:otherwise>${ddns_list.p2p_priority}</c:otherwise>	</c:choose>
								</td> </c:otherwise>
								</c:choose>
								
							<td>
								<c:choose>
									<c:when test="${ddns_list.p2p_device == 1}">장비 UID 보유</c:when>
									<c:when test="${ddns_list.p2p_device == 0}">장비 UID 미보유</c:when>
									<c:otherwise>${ddns_list.p2p_device}</c:otherwise>
								</c:choose>
							</td>
							<td>${ddns_list.regtime }</td>
							<td style="white-space: nowrap; font-size: medium;">
								<c:choose>
									<c:when test="${ddns_list.register_type == 7}">7 기존 등록</c:when>
									<c:when test="${ddns_list.register_type == 6}">6 고객 통합 앱 서버</c:when>
									<c:when test="${ddns_list.register_type == 5}">5 고객 (영상 lib)</c:when>
									<c:when test="${ddns_list.register_type == 4}">4 일반</c:when>
									<c:when test="${ddns_list.register_type == 3}">3 AS</c:when>
									<c:when test="${ddns_list.register_type == 2}">2 유지보수 동일 교체</c:when>
									<c:when test="${ddns_list.register_type == 1}">1 설변</c:when>
									<c:when test="${ddns_list.register_type == 0}">0 신규</c:when>
									<c:otherwise>${ddns_list.register_type}</c:otherwise>
								</c:choose>
							</td>
							<%-- 							<td>${ddns_list.empty1 }</td> --%>
							<c:set var="ip_status" value="IP-STATUS"></c:set>
							<c:set var="log_status" value="APP_DEVICEINFO"></c:set>
							<c:choose>

								<c:when test="${(ddns_list.ip_status).equals('BAD')}">
									<c:set var="ip_status" value="IP할당: BAD&#10;LOG :"></c:set>
									<fmt:formatDate var="log_status_date" value="${ddns_list.log_call_kttddns_serviceno_to_app_deviceinfo}" type="DATE" pattern="yyyy-MM-dd HH:mm:ss" />

									<td style="color: red;" title="${ip_status}${log_status_date}" class="fas fa-exclamation-circle">${ddns_list.empty1 }</td>
								</c:when>
								<c:when test="${(ddns_list.ip_status).equals('GOOD')}">
									<c:set var="ip_status" value="IP할당 GOOD&#10;LOG :"></c:set>
									<fmt:formatDate var="log_status_date" value="${ddns_list.log_call_kttddns_serviceno_to_app_deviceinfo}" type="DATE" pattern="yyyy-MM-dd HH:mm:ss" />

									<td style="color: blue;" title="${ip_status}${log_status_date}" class="fas fa-exclamation-circle">${ddns_list.empty1 }</td>
								</c:when>
								<c:otherwise>
									<td></td>
								</c:otherwise>
							</c:choose>
							<c:remove var="ip_status" />
							<c:remove var="log_status_date" />
							<c:choose>
						<c:when test="${not empty ddns_list.app_access_id && ddns_list.app_access_id != ''}">
						 	<td title="${ddns_list.app_date}"> 
						 	
						 	<a target ="_blank" href="/PushAdmin/accesslog_page.do?type=accesslog&sort=req_id&direction=desc&page=1&access_log_type=0&mac_address=${ddns_list.jumin}">
						 	 ${ddns_list.app_access_id } </a> </td>
						
						 <!--	<fmt:formatDate  var="app_date" value="${ddns_list.app_date}" type="DATE" pattern="yyyy-MM-dd HH:mm:ss"/>
							<td style=" white-space: nowrap;">${app_date } 	</td> -->
							</c:when>
							   <c:otherwise>
							 <td></td> 
							 </c:otherwise>
							 </c:choose>
						<c:choose>
							 <c:when test="${not empty ddns_list.cms_access_id && ddns_list.cms_access_id != ''}">
						 	<td title="${ddns_list.cms_date}"> 
						 	<a target ="_blank" href="/PushAdmin/accesslog_page.do?type=accesslog&sort=req_id&direction=desc&page=1&access_log_type=1&mac_address=${ddns_list.jumin}">
							${ddns_list.cms_access_id } </a> </td>
						  
							 </c:when>
							 <c:otherwise>
							 <td></td> 
							 </c:otherwise>
						</c:choose>

						</tr>
						<tr align="center" height="30">
							<td>
								<!-- 20220121 장비 삭제/서비스 상태 변경 기능 계정 권한 확인 추가 -->
								<c:if test="${login_member.member_auth == 2 }">
									<input type="checkbox" class="select_list_ddns" name="select_list_ddns" value="${ddns_list.jumin } ">
								</c:if>
								<!-- END -->
							</td>
							<td font-size="93%">${ddns_list.jumin } 
							 
								<c:choose>
								<c:when test="${login_member.member_auth == 2 }">
								/ <a href="javascript:void(0)"  onclick="modify_access_rule('${login_member.member_id}', '${ddns_list.jumin}', '${ddns_list.access_rule}')">

								<c:choose>
									<c:when test="${ddns_list.access_rule ==0 }">전체허용</c:when>
									<c:when test="${ddns_list.access_rule ==1 }">올레,통합앱</c:when>
									<c:when test="${ddns_list.access_rule ==2}">통합앱</c:when>
									<c:otherwise>${ddns_list.access_rule}</c:otherwise>
								</c:choose>
								</a>
								</c:when>
								<c:otherwise>
								<c:choose>
									<c:when test="${ddns_list.access_rule ==0 }">전체허용</c:when>
									<c:when test="${ddns_list.access_rule ==1 }">올레,통합앱</c:when>
									<c:when test="${ddns_list.access_rule ==2}">통합앱</c:when>
									<c:otherwise>${ddns_list.access_rule}</c:otherwise>
								
								</c:choose>
								</c:otherwise>
							</c:choose>
							
								</td>
							<td>${ddns_list.eqcat }</td>
							<td>${ddns_list.empty3 }</td>
							<td>${ddns_list.privateip }</td>
							<c:choose>
								<c:when test="${url.equals('ddns_serviceno.do') }">
									<td>${ddns_list.webport }</td>
								</c:when>
								<c:otherwise>
									<td class="select">
										<span style="cursor: pointer;" onclick="connect_web('${ddns_list.addr }', '${ddns_list.webport }')">${ddns_list.webport }</span>
									</td>
								</c:otherwise>
							</c:choose>
							<!-- service_no 빈칸을 클릭하여 창 open -->
							<c:choose>
								<c:when test="${login_member.member_auth == 2 }">
									<td class="select" onclick="chk_service_no('${ddns_list.service_no}', '${ddns_list.jumin }')">
										<span style="cursor: pointer;"> <c:choose>
												<c:when test="${fn:length(ddns_list.service_no) < 8 }">미등록</c:when>
												<c:otherwise>${ddns_list.service_no}</c:otherwise>
											</c:choose>
										</span>
									</td>
								</c:when>
								<c:otherwise>
									<td>
										<c:choose>
											<c:when test="${fn:length(ddns_list.service_no) < 8 }">미등록</c:when>
											<c:otherwise>${ddns_list.service_no}</c:otherwise>
										</c:choose>
									</td>
								</c:otherwise>
							</c:choose>
							<!-- END -->
							<td>
								<c:choose>
									<c:when test="${ddns_list.service_open == 2}">OSS 개통 처리</c:when>
									<c:when test="${ddns_list.service_open == 1}">장비 개통 처리</c:when>
									<c:when test="${ddns_list.service_open == 0}">개통 안됨</c:when>
									<c:otherwise>${ddns_list.service_open}</c:otherwise>
								</c:choose>
							</td>
							<td class="select">
								<!-- 20220121 장비 삭제/서비스 상태 변경 기능 계정 권한 확인 추가 START -->
								<c:choose>
									<c:when test="${login_member.member_auth == 2 }">
										<span style="cursor: pointer;" onclick="view_service_status_modify('${ddns_list.domain }', '${ddns_list.jumin }', '${ddns_list.service_user}')"> <c:choose>
												<c:when test="${ddns_list.service_user == 1}">서비스 중</c:when>
												<c:when test="${ddns_list.service_user == 0}">서비스 중단</c:when>
												<c:otherwise>${ddns_list.service_user}</c:otherwise>
											</c:choose>
										</span>
									</c:when>
									<c:otherwise>
										<span style="cursor: pointer;"> <c:choose>
												<c:when test="${ddns_list.service_user == 1}">서비스 중</c:when>
												<c:when test="${ddns_list.service_user == 0}">서비스 중단</c:when>
												<c:otherwise>${ddns_list.service_user}</c:otherwise>
											</c:choose>
										</span>
									</c:otherwise>
								</c:choose>
								<!-- END -->

							</td>
							<td>${ddns_list.tel2 }</td>
							<td>${ddns_list.employee_no }</td>
							<%-- 							<c:choose> --%>
							<%-- 								<c:when test="${(ddns_list.ip_status).equals('BAD')}"> --%>
							<%-- 									<td style="color: red;">${ddns_list.ip_status }</td> --%>
							<%-- 								</c:when> --%>
							<%-- 								<c:when test="${(ddns_list.ip_status).equals('GOOD')}"> --%>
							<%-- 									<td>${ddns_list.ip_status }</td> --%>
							<%-- 								</c:when> --%>
							<%-- 								<c:otherwise> --%>
							<!-- 									<td></td> -->
							<%-- 								</c:otherwise> --%>
							<%-- 							</c:choose> --%>
							<c:choose>
								<c:when test="${login_member.member_auth == 2 }">
									<td class="select">
										<span style="cursor: pointer;" onclick="modify_otp_yn('${login_member.member_id}', '${ddns_list.jumin}', '${ddns_list.otp_yn}')"> <c:choose>
												<c:when test="${ddns_list.otp_yn == 3}">3 OTP 인증완료</c:when>
												<c:when test="${ddns_list.otp_yn == 2}">2 관리자 변경</c:when>
												<c:when test="${ddns_list.otp_yn == 1}">1 기존통합앱사용자</c:when>
												<c:when test="${ddns_list.otp_yn == 0}">0 OTP 인증 안함</c:when>
												<c:otherwise>${ddns_list.otp_yn}</c:otherwise>
											</c:choose>
										</span>
									</td>

								</c:when>
								<c:otherwise>
									<td>
										<c:choose>
											<c:when test="${ddns_list.otp_yn == 3}">3 OTP 인증완료</c:when>
											<c:when test="${ddns_list.otp_yn == 2}">2 관리자 변경</c:when>
											<c:when test="${ddns_list.otp_yn == 1}">1 기존통합앱사용자</c:when>
											<c:when test="${ddns_list.otp_yn == 0}">0 OTP 인증 안함</c:when>
											<c:otherwise>${ddns_list.otp_yn}</c:otherwise>
										</c:choose>
									</td>
								</c:otherwise>

							</c:choose>
							
						<!--		<c:choose>
						 <c:when test="${not empty ddns_list.app_access_id && ddns_list.app_access_id != ''}">
						 	 <td class="select">	<span><c:choose>
								 	<c:when test="${ddns_list.app_register_type == 1}"><a href="/PushAdmin/accesslog_page.do" style="text-decoration-line: none;" >수동등록</a></c:when>
									<c:when test="${ddns_list.app_register_type == 0}"><a href="/PushAdmin/accesslog_page.do"  style="text-decoration-line: none;">자동등록</a></c:when>
									<c:otherwise>${ddns_list.app_register_type }</c:otherwise>
								</c:choose></span>
								</td>
						 	
							 </c:when>
							 <c:otherwise>
							 <td></td>
							 </c:otherwise>
						</c:choose> -->
						
						<c:choose>
							 <c:when test="${not empty ddns_list.device_accesslog_type_t0 && ddns_list.device_accesslog_type_t0 != ''}">
						 	<td title="${ddns_list.device_protocol_date_t0}">
						 	<a target ="_blank" href="/PushAdmin/accesslog_page.do?type=accesslog&sort=req_id&direction=desc&page=1&access_log_type=2&mac_address=${ddns_list.jumin}">
							 ${ddns_list.device_accesslog_type_t0 } </a> </td>
						  
							 </c:when>
							 <c:otherwise>
							 <td></td> 
							 </c:otherwise>
						</c:choose>
						
							<c:choose>
							 <c:when test="${not empty ddns_list.device_accesslog_type_t1 && ddns_list.device_accesslog_type_t1 != ''}">
						 	<td title="${ddns_list.device_protocol_date_t1}">
						 	<a target ="_blank" href="/PushAdmin/accesslog_page.do?type=accesslog&sort=req_id&direction=desc&page=1&access_log_type=3&mac_address=${ddns_list.jumin}">
							 ${ddns_list.device_accesslog_type_t1 } </a> </td>
						  
							 </c:when>
							 <c:otherwise>
							 <td></td> 
							 </c:otherwise>
						</c:choose>
						</tr>
						<tr height="0.1">
							<td colspan="14">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
					</c:forEach>
					<tr height="30">
						<td></td>
					</tr>
					<tr>
						<td colspan="14" align="center">
							<c:if test="${start_page > 10 }">
								<a href="/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=${sort }&direction=${direction }&page=${1 }&search_type=${search_type }&search_word=${search_word }">[맨앞]</a>
								<a href="/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=${sort }&direction=${direction }&page=${start_page - 10 }&search_type=${search_type }&search_word=${search_word }">[이전]</a>
							</c:if>
							<c:forEach var="a" begin="${start_page }" end="${end_page <= last_page ? end_page : last_page }">
								<c:choose>
									<c:when test="${current_page == a }">
										<a>[${a }]</a>
									</c:when>
									<c:otherwise>
										<a href="/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=${sort }&direction=${direction }&page=${a }&search_type=${search_type }&search_word=${search_word }">[${a }]</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<c:if test="${end_page < last_page }">
								<a href="/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=${sort }&direction=${direction }&page=${start_page + 10 }&search_type=${search_type }&search_word=${search_word }">[다음]</a>
								<a href="/PushAdmin/${url }?type=${type }&auth=${auth }&service_no=${service_no }&sort=${sort }&direction=${direction }&page=${last_page }&search_type=${search_type }&search_word=${search_word }">[맨뒤]</a>
							</c:if>
						</td>
					</tr>
					<tr height="30">
						<td></td>
					</tr>
					<tr height="30">
						<td colspan="7"></td>
						<td colspan="4">
							<form id="search_form" name="search_form" action="/PushAdmin/${url }">
								<select name="search_type" id="search_type">
									<option value=0 <c:if test="${search_type == 0}">selected</c:if>>도메인</option>
									<option value=1 <c:if test="${search_type == 1}">selected</c:if>>제조사</option>
									<option value=2 <c:if test="${search_type == 2}">selected</c:if>>모델</option>
									<option value=3 <c:if test="${search_type == 3}">selected</c:if>>외부 IP</option>
									<option value=4 <c:if test="${search_type == 4}">selected</c:if>>P2P 라이선스</option>
									<option value=5 <c:if test="${search_type == 5}">selected</c:if>>등록 타입</option>
									<option value=6 <c:if test="${search_type == 6}">selected</c:if>>맥 주소</option>
									<option value=7 <c:if test="${search_type == 7}">selected</c:if>>버전</option>
									<option value=8 <c:if test="${search_type == 8}">selected</c:if>>사원/앱ID</option>
									<c:if test="${url.equals('ddns_page.do') }">
										<option value=9 <c:if test="${search_type == 9}">selected</c:if>>서비스 번호</option>
										<option value=10 <c:if test="${search_type == 10}">selected</c:if>>OTP 인증</option>
										<option value=11 <c:if test="${search_type == 11}">selected</c:if>>APP ACCESS ID</option>
										<option value=12 <c:if test="${search_type == 12}">selected</c:if>>CMS ACCESS ID</option>
										<option value=11 <c:if test="${search_type == 13}">selected</c:if>>DEVICE/녹화기</option>
										<option value=12 <c:if test="${search_type == 14}">selected</c:if>>DEVICE/웹뷰어</option>
									</c:if>
								</select>
								<input id="search_word" name="search_word" style="vertical-align: 5%; width: 140px" value="${search_word }" maxlength="40"> <input id="search_btn" type="button" style="background: #000000; color: white;" value="검색">
								<c:choose>
									<c:when test="${url.equals('ddns_serviceno.do') }">
										<input type="hidden" name="type" id="type" value="ddns_serviceno_search">
										<input type="hidden" name="auth" id="auth" value="${auth }">
										<input type="hidden" name="service_no" id="service_no" value="${service_no }">
									</c:when>
									<c:otherwise>
										<input type="hidden" name="type" id="type" value="ddns_search">
									</c:otherwise>
								</c:choose>
							</form>
						</td>
						<c:choose>
							<c:when test="${url.equals('ddns_serviceno.do') }">
								<td colspan="4"></td>
							</c:when>
							<c:otherwise>
								<td colspan="4" align="right">
									<form id="excel_form" name="excel_form">
										엑셀 다운로드&nbsp;&nbsp; <input id="excel_btn" type="button" style="background: #000000; color: white;" value="현재 페이지"> <input type="hidden" name="type" id="type" value="${type }"> <input type="hidden" name="sort" id="sort" value="${sort }"> <input type="hidden" name="page" id="page" value="${current_page }"> <input type="hidden" name="direction" id="direction" value="${direction }">
										<c:if test="${type == 'ddns_search' || type == 'ddns_serviceno_search'|| type=='ddns_search_otp_yn' }">
											<input type="hidden" name="search_type_excel" id="search_type_excel" value="${search_type }">
											<input type="hidden" name="search_word_excel" id="search_word_excel" value="${search_word }">
										</c:if>
										<c:if test="${url.equals('ddns_serviceno.do') }">
											<input type="hidden" name="auth" id="auth" value="${auth }">
											<input type="hidden" name="service_no" id="service_no" value="${service_no }">
										</c:if>
										<input id="excel_all_btn" type="button" style="background: #000000; color: white;" value="전체 페이지">
									</form>
									<form id="excel_all_form" name="excel_all_form">
										<c:choose>
											<c:when test="${type == 'ddns' }">
												<input type="hidden" name="type" id="type" value="ddns_all">
											</c:when>
											<c:when test="${type == 'ddns_search' }">
												<input type="hidden" name="type" id="type" value="ddns_search_all">
											</c:when>
											<c:when test="${type == 'ddns_serviceno' }">
												<input type="hidden" name="type" id="type" value="ddns_serviceno_all">
											</c:when>
											<c:when test="${type == 'ddns_serviceno_search' }">
												<input type="hidden" name="type" id="type" value="ddns_serviceno_search_all">
											</c:when>
											<c:when test="${type == 'ddns_search_otp_yn'}">
												<input type="hidden" name="type" id="type" value="ddns_serach_otp_yn_all">
											</c:when>
										</c:choose>
										<c:if test="${type == 'ddns_search' || type == 'ddns_serviceno_search' || type=='ddns_search_otp_yn' }">
											<input type="hidden" name="search_type_excel" id="search_type_excel" value="${search_type }">
											<input type="hidden" name="search_word_excel" id="search_word_excel" value="${search_word }">
										</c:if>
										<c:if test="${url.equals('ddns_serviceno.do') }">
											<input type="hidden" name="auth" id="auth" value="${auth }">
											<input type="hidden" name="service_no" id="service_no" value="${service_no }">
										</c:if>
										<input type="hidden" name="sort" id="sort" value="${sort }"> <input type="hidden" name="direction" id="direction" value="${direction }">
									</form>
								</td>
							</c:otherwise>
						</c:choose>
					</tr>
					<tr height="30" align="right">

						<td colspan="14">

							<form id="list_all_form" name="list_all_form" action="/PushAdmin/${url }">
								<input id="list_all_btn" type="button" style="background: #000000; color: white;" value="전체 목록">
								<c:if test="${url.equals('ddns_serviceno.do') }">
									<input type="hidden" name="auth" id="auth" value="${auth }">
									<input type="hidden" name="service_no" id="service_no" value="${service_no }">
								</c:if>
							</form>
						</td>
					</tr>
					<tr height="30" align="right">
						<td colspan="14">
							<!-- 20220121 장비 삭제/서비스 상태 변경 기능 계정 권한 확인 추가 START -->
							<c:if test="${login_member.member_auth == 2 }">
								<input type="button" onclick="checkList()" value="장비 삭제" style="background: #000000; color: white;">
							</c:if>
							<!-- END -->
						</td>
					</tr>
					<tr height="30">
						<td></td>
					</tr>
					<tr>
						<td style="background-color: #F6F6F6; border: 0px; top: 5px;" height="30px" colspan="14" align="center" class="font2">P U S H&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;S E R V E R&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A D M I N I S T R A T O R</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>