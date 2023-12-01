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

<title>Register</title>
<script>
function copy_to_clipboard() {
	var val = '<c:out value="${mobile.token_id}"/>';
	  const t = document.createElement("textarea");
	  document.body.appendChild(t);
	  t.value = val;
	  t.select();
	  document.execCommand('copy');
	  document.body.removeChild(t);
  //console.log('Copied!');
}
</script>
</head>
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
<!-- 							<td width="25%"></td> -->
							<td width="15%"></td>
							<td width="20%">제조사</td>
							<td>${register.maker }</td>
						</tr>
						<tr>
							<td></td>
							<td>장치 분류</td>
							<td>${register.eqcat }</td>
						</tr>
						<tr>
							<td></td>
							<td>모델명</td>
							<td>${register.model }</td>
						</tr>
						<tr>
							<td></td>
							<td>맥 주소</td>
							<td>${register.register_mac }</td>
						</tr>
						<tr>
							<td></td>
							<td>도메인</td>
							<td>${register.domain }</td>
						</tr>
						<tr>
							<td></td>
							<td>시스템 ID</td>
							<td>${register.system_id }</td>
						</tr>
						<tr height="0.1">
							<td colspan="3">
								<hr size="0.1" color="CDCBCB" style="border-bottom: medium;">
							</td>
						</tr>
						<tr>
							<td></td>
							<td>푸시 토큰</td>
							<td style="cursor:pointer;word-break:break-all" onClick="copy_to_clipboard()" id="token_id">${mobile.token_id }</td>
						</tr>
						<tr>
							<td></td>
							<td>모바일 종류</td>
							<td>
								<c:choose>
									<c:when test="${mobile.mobile_type == 1}">Android</c:when>
									<c:when test="${mobile.mobile_type == 2}">iOS</c:when>
									<c:otherwise>${mobile.mobile_type}</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>언어</td>
							<td>
								<c:choose>
									<c:when test="${mobile.lang_cd == 1}">Korean</c:when>
									<c:when test="${mobile.lang_cd == 2}">English</c:when>
									<c:otherwise>${mobile.lang_cd}</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>앱 종류</td>
							<td>
								<c:choose>
									<c:when test="${mobile.app_num == 10}">OCT INAPP</c:when>
									<c:when test="${mobile.app_num == 9}">OCT Plus</c:when>
									<c:when test="${mobile.app_num == 7}">Sea Black Box</c:when>
									<c:when test="${mobile.app_num == 6}">Olleh CCTV Telecop</c:when>
									<c:when test="${mobile.app_num == 0}"></c:when>
									<c:otherwise>${mobile.app_num}</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>앱 버전</td>
							<td>${mobile.app_ver }</td>
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
							<td colspan="3" align="center">
								<input type="button" onclick="window.close()" style="background: #000000; color: white;" value="확인" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</center>
</body>
</html>