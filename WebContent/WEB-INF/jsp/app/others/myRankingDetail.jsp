<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1, user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<script type="text/javascript" src="static/app/js/mui.min.js"></script>
		
		<title>积分明细</title>
<style>
html, body {
	padding: 0;
	margin: 0;
}

.w-head {
	width: 100%;
	background: #478cd7;
	color: #fff;
	height: 40px;
	line-height: 40px;
	text-align: center;
	position: fixed;
	top:0;
	font-size: 15px;
}
.back {
    position: absolute;
    top: 10px;
    left: 5px;
}
.w-listtop {
	color: #272727;
	font-size: 12px;
}

.w-listtop span:last-child {
	display: inline-block;
	float: right;
}

.w-listtop span:first-child {
	display: inline-block;
	width: 90%;
	line-height: 2;
}

.w-list {
	padding: 5px 15px;
	border-bottom: 1px solid #e0e0e0;
}

.w-listbottom {
	color: #A3A3A3;
	font-size: 12px;
	text-align: right;
	padding-top: 10px;
}
</style>
</head>
	<body>
		<div class="w-head">
		<div class="back"><a onclick="history.go(-1)"><img src="<%=basePath %>static/app/images/left.png"></a></div>			
		<span>积分明细</span>
		</div>
		<div class="w-content" style="padding-left: 2%;padding-right: 2%;margin-top: 40px;">
				<c:forEach items="${rankingDetailList}" var="detail" varStatus="status">
				<div class="w-list">
				<div class="w-listtop">
					<span>${detail.scoreName}</span>
					<span style="color: #000;">${detail.SCORE}</span>
				</div>
				<div class="w-listbottom">${detail.SCORE_DATE}</div>
				</div>
				</c:forEach>
	</body>
</html>
