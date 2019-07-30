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
		<script src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script src="plugins/JQuery/jquery.min.js"></script>
		<link rel="stylesheet" href="plugins/Bootstrap/css/bootstrap.css" />
		<title>页面开发中，请耐心等待</title>
		<style>
			body{ background:#ebebeb;}
			.btn-unbuding{width:100%; margin:0 auto;border-radius:20px;padding:6px 12px; font-size:18px; background:#32c2f7;outline:none;}
			.btn-unbuding:focus{outline:none;}
			.btn-unbuding:active:focus{outline:none;}
		</style>
	</head> 
	<body>
		<img src="static/login_stl/images/under.png" width="100%" />
 		<div style="width:70%; margin:0 auto;">
		<button  id = "complete" type="button" class="btn btn-info btn-unbuding" onclick="close()">开发中</button>
		</div>
	</body>
</html>
