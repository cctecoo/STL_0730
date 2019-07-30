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
		<title>解除绑定失败</title>
		<style>
			body{ background:#ebebeb;}
			.btn-unbuding{width:100%; margin:0 auto;border-radius:20px;padding:6px 12px; font-size:18px; background:#32c2f7;outline:none;}
			.btn-unbuding:focus{outline:none;}
			.btn-unbuding:active:focus{outline:none;}
		</style>
		<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
		<script>
			$(document).ready(function(){
		    	$.ajax({
					type:"post",
					url:"<%=basePath %>app_login/getConfig.do",
		           	data:{"url":location.href.split('#')[0]},
		           	success:function(data){
		            	var obj = eval(data[0]);
		            	wx.config({
		                	debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
		                   	appId: obj.appId, // 必填，公众号的唯一标识
		                   	timestamp: obj.timestamp, // 必填，生成签名的时间戳
		                   	nonceStr: obj.noncestr, // 必填，生成签名的随机串
		                   	signature: obj.signature,// 必填，签名，见附录1
		                   	jsApiList: ['closeWindow'] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
		               	});
		               	wx.ready(function(){
		               		$("#complete").click(function(event) {
		               			wx.closeWindow();
							});
		               	});
		           	}
		       	});
		   	});
			
		</script>	
	</head>
  
	<body>
		<img src="static/login_stl/images/unbundling-fail.png" width="100%" />
 		<div style="width:70%; margin:0 auto;">
		<button  type="button" class="btn btn-info btn-unbuding" onclick="close()">完  成</button>
		</div>

	</body>
</html>
