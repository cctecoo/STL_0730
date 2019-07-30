<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<base href="<%=basePath%>">  
    <title>发送消息</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,minimal-ui"></meta>
	<title>发送消息</title>
	<link rel="stylesheet" href="static/css/app-style.css"></link>
	<script src="plugins/JQuery/jquery.min.js"></script>
	<link rel="stylesheet" href="plugins/Bootstrap/css/bootstrap.css" />
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<style>
		body{ background:#ebebeb;}
		.btn-unbuding{width:100%; margin:0 auto;border-radius:20px;padding:6px 12px; font-size:18px; background:#32c2f7;outline:none;}
		.btn-unbuding:focus{outline:none;}
		.btn-unbuding:active:focus{outline:none;}
	</style>
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
		
	<script type="text/javascript" src="plugins/JQuery/jquery-1.12.2.min.js"></script>
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<script type="text/javascript" src="static/js/jquery.cookie.js"></script>
	<script type="text/javascript">
	

 		function addMsg() {
			$.ajax({
				type : "POST",
				url : 'app_login/sendMessage.do',
				success : function(data) {
					if ("success" == data) {
						alert("发送成功");
					} else {
						alert("发送失败");
					}
				}

			});
		} 
 		function addChart() {
			$.ajax({
				type : "POST",
				url : 'app_login/sendChart.do',
				success : function(data) {
					if ("success" == data) {
						alert("发送成功");
					} else {
						alert("发送失败");
					}
				}

			});
		}

		function addRanking() {
			$.ajax({
				type : "POST",
				url : 'app_login/sendRanking.do',
				success : function(data) {
					if ("success" == data) {
						alert("发送成功");
					} else {
						alert("发送失败");
					}
				}

			});
		} 
	</script>

</head>

<body>
	
	<div style="height:50px;">
	<button type="button" class="btn btn-info btn-unbuding" onclick="addMsg()">发送模板消息</button>
	</div>
	<div style="height:50px;">
	<button type="button" class="btn btn-info btn-unbuding" onclick="addRanking()">推送系统使用排名</button>
	</div>
	<div style="height:50px;">
	<button type="button" class="btn btn-info btn-unbuding" onclick="addChart()">推送销售分析</button>
	</div>



</body>



</html>
