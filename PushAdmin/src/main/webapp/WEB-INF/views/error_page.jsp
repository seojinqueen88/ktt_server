<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>

<%
	response.setStatus(HttpServletResponse.SC_OK);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="icon" type="image/x-icon" href="favicon.ico">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500&display=swap" rel="stylesheet">

<title>error page</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
<div>
	<h2>죄송합니다.<br>요청하신 페이지를 찾을 수 없습니다.</h2>
	<div>
		<p>방문하시려는 페이지의 주소가 잘못 입력되었거나,<br>페이지의 주소가 변경 혹은 삭제되어 요청하신 페이지를 찾을 수 없습니다.</p>
		<p>입력하신 주소가 정확한지 다시 한번 확인해 주시기 바랍니다.</p>
		<p>관련 문의사항은 고객센터에 알려주시면 친절하게 안내해 드리겠습니다.</p>
		<p>감사합니다.</p>
	</div>
</div>
</body>
</html>