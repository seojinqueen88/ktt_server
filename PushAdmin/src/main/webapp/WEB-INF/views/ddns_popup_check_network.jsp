<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DDNS</title>
</head>
<style type="text/css" >
.wrap-loading {
	position: fixed;
	left:0;
	right:0;
	top:0;
	bottom:0;
	background: rgba(0,0,0,0.2);
	filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000', endColorstr='#20000000');
}

.wrap-loading div {
	position: fixed;
	top:44%;
	left:46%;
}

.display-none {
	display:none;
}
</style>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
var add_html = "";
var p2p_uid = "";
var mac = "${mac }";
var url = "${url }";
var auth = "${auth }";
var service_no = "${service_no }";

$(function()
{
	check_network();
});

function check_network()
{
	$("#tbody_network").empty();

	var path = "";
	if(url == "ddns_page.do")
		path = "check_network.do";
	else if(url == "ddns_serviceno.do")
		path = "check_network_ddns_serviceno.do";

	var JSON_DATA = {"mac" : mac};

	$.ajax({
		type : "post",
		url : path,
		data : JSON.stringify(JSON_DATA),
		contentType : "application/json; charset=UTF-8",
		success : function(data) {
			var clientport_result = data.clientport_result;
			var webport_result = data.webport_result;
			var ping_result = data.ping_result;

			add_html = "";
			add_html += '<tr height="30" align="center"><td colspan="3">인터넷 네트워크 테스트 결과 : ';

			if(clientport_result || webport_result || ping_result)
				add_html += '<font color="blue">양호</font>';
			else
				add_html += '<font color="red">불량</font>';

			add_html += '</td></tr><tr height="30" align="center"><td colspan="3">영상 포트 테스트 결과 : ';

			if(clientport_result)
				add_html += '<font color="blue">양호</font>';
			else
				add_html += '<font color="red">불량</font>';

			add_html += '</td></tr><tr height="30" align="center"><td colspan="3">웹페이지 포트 테스트 결과 : ';

			if(webport_result)
				add_html += '<font color="blue">양호</font></td></tr>';
			else
				add_html += '<font color="red">불량</font></td></tr>';

			$("#tbody_network").append(add_html);
			
			check_p2p();
		},
		beforeSend:function() {
			$('.wrap-loading').removeClass('display-none');
		},
		complete:function() {
			$('.wrap-loading').addClass('display-none');
		},
		error : function(request,status,error) {
       		alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
       	}
	});
}

function check_p2p()
{
	$("#tbody_p2p").empty();

	var path = "";
	if(url == "ddns_page.do")
		path = "check_p2p.do";
	else if(url == "ddns_serviceno.do")
		path = "check_p2p_ddns_serviceno.do";

	var JSON_DATA = {"mac" : mac};
	$.ajax({
		type : "post",
		url : path,
		data : JSON.stringify(JSON_DATA),
		contentType : "application/json; charset=UTF-8",
		success : function(data) {
			p2p_uid = data.p2p_uid;
			var p2p_priority = data.p2p_priority;
			var p2p_device = data.p2p_device;

			add_html = "";

			if(p2p_uid.length > 0)
				add_html += '<tr height="30"><td width="12%"></td><td colspan="2">P2P라이선스 : ' + p2p_uid + '</td></tr>';
			else
				add_html += '<tr height="30" align="center"><td colspan="3">P2P라이선스 : 미등록</td></tr>';

			if(url == "ddns_page.do")
			{
				if(p2p_uid.length > 0)
				{
					add_html += '<tr height="30"><td></td><td width="63%">접속 우선순위 : <select id="p2p_priority_update">';

					switch(p2p_priority)
					{
					case 0:
					default:
						add_html += '<option value=0 selected>P2P 사용 안 함</option><option value=1>Auto</option><option value=2>P2P만 사용</option>';
						break;
					case 1:
						add_html += '<option value=0>P2P 사용 안 함</option><option value=1 selected>Auto</option><option value=2>P2P만 사용</option>';
						break;
					case 2:
						add_html += '<option value=0>P2P 사용 안 함</option><option value=1>Auto</option><option value=2 selected>P2P만 사용</option>';
						break;
					}

					add_html += '</select></td><td><input type="button" onclick="update_p2p_priority()" style="width: 70px; background: #000000; color: white;" value="수정" /></td></tr>';
				}
				else
				{
					add_html += '<tr height="30" align="center"><td colspan="3">접속 우선순위 : <select id="p2p_priority_add"><option value=0 selected>P2P 사용 안 함</option><option value=1>Auto</option><option value=2>P2P만 사용</option></select></td></tr>';
				}
			}

			if(p2p_uid.length > 0)
			{
				add_html += '<tr height="30"><td></td><td width="63%">장비 P2P 보유 여부 : ';

				switch(p2p_device)
				{
				case 0:
					add_html += '장비 라이선스 미보유';
					break;
				case 1:
					add_html += '장비 라이선스 보유';
					break;
				default:
					add_html += 'Unknown';
					break;
				}

				add_html += '</td><td><input type="button" onclick="check_p2p()" style="width: 70px; background: #000000; color: white;" value="갱신" /></td></tr>';
			}
			else
			{
				add_html += '<tr height="30" align="center"><td colspan="3"><input type="button" onclick="add_p2p()" style="background: #000000; color: white;" value="발급하기" /></td></tr>';
			}

			$("#tbody_p2p").append(add_html);
		},
		complete:function() {
			opener.parent.location.reload();
		},
		error : function(request,status,error) {
       		alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
       	}
	});
}

function add_p2p()
{
	var path = "";
	var p2p_priority = 0;

	if(url == "ddns_page.do")
	{
		if("${login_member.member_auth }" != 2)
		{
			alert("권한이 없습니다.");
			return false;
		}

		path = "add_p2p.do";
		p2p_priority = parseInt($("#p2p_priority_add").val(), 10);
	}
	else if(url == "ddns_serviceno.do")
	{
		path = "add_p2p_ddns_serviceno.do";
		p2p_priority = 2;
	}

	var JSON_DATA = {"mac" : mac, "p2p_priority" : p2p_priority};
	$.ajax({
		type : "post",
		url : path,
		data : JSON.stringify(JSON_DATA),
		contentType : "application/json; charset=UTF-8",
		success : function(data) {
			console.log(data);
			switch(data)
			{
			case "success":
				alert("발급되었습니다.");
				check_p2p();
				break;
			case "nop2puid":
				alert("남은 P2P라이선스가 없습니다.");
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

function update_p2p_priority()
{
	if(url == "ddns_page.do" && "${login_member.member_auth }" != 2)
	{
		alert("권한이 없습니다.");
		return false;
	}

	var JSON_DATA = {"p2p_uid" : p2p_uid, "p2p_priority" : $("#p2p_priority_update").val()};
	$.ajax({
		type : "post",
		url : "update_p2p_priority.do",
		data : JSON.stringify(JSON_DATA),
		contentType : "application/json; charset=UTF-8",
		success : function(data) {
			switch(data)
			{
			case "success":
				alert("수정되었습니다.");
				check_p2p();
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
	<div class="wrap-loading display-none"><div><img src="img/loading.gif" style="width: 50px; height: 50px;"/></div></div>
	<center>
		<table width="100%">
			<tr>
				<td width="15%"></td>
				<td height="50">
					<font color="#00A2E8" style="font-weight: bold;">
						※ 인터넷 네트워크 불량시 : 고객 인터넷 점검 요청<br>
						※ 영상 포트 불량시 : P2P 발급하기를 통한 라이선스 발급<br>
						※ 웹페이지 포트는 불량여부 상관없음(생략)
					</font>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<table align="center" border="0" width="90%">
						<tr height="0.1">
							<td colspan="3">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<tr height="50" align="center" style="font-size: 20px; font-weight: 500;">
							<td colspan="3"><c:out value="${domain }" /></td>
						</tr>
						<tbody id="tbody_network"></tbody>
						<tr height="0.1">
							<td colspan="3">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<tbody id="tbody_p2p"></tbody>
						<tr height="0.1">
							<td colspan="3">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<tr>
							<td height="20"></td>
						</tr>
						<tr>
							<td colspan="3" align="center">
								<input type="button" onclick="window.close()" style="background: #000000; color: white;" value="닫기" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</center>
</body>
</html>