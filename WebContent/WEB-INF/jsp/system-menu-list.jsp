
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no"/>
		<meta name="apple-mobile-web-app-capable" content="yes" />
		
		<link rel="stylesheet" href="plugins/Bootstrap/css/bootstrap.css" />
		<title>系统菜单结构</title>
	</head> 
	<body>
		<div style="background-color:white; width:100%; height:100%; min-height:500px; text-align:center;">
			<img src="static/login_stl/images/menuList.png" style="max-width:90%; max-height:90%; margin: 5% auto;" />
		</div>
		
	</body>
</html>