<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
	<head>
		<base href="<%=basePath%>">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,minimal-ui"></meta>
		<title>用户绑定</title>
		<link rel="stylesheet" href="static/css/app-style.css"></link>
		<script src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script src="plugins/JQuery/jquery.min.js"></script>
		<link rel="stylesheet" href="plugins/Bootstrap/css/bootstrap.css" />
		<style>
			body{ background:#ebebeb;}
			.btn-unbuding{width:100%; margin:0 auto;border-radius:20px;padding:6px 12px; font-size:18px; background:#32c2f7;outline:none;}
			.btn-unbuding:focus{outline:none;}
			.btn-unbuding:active:focus{outline:none;}
			.bundling{width:85%;margin:0 auto;padding:10px 15px;background:#f8f8f8;}
			.bundling input{border:0;padding:3px 10px;margin:3px 0 3px 20px; border-left:1px solid #ccc; background:#f8f8f8; outline:none;}
		</style>
	</head>
	<body style="height:100%;" >
			<!-- <img src="static/login_new/images/stl-logo.png" /> -->
			<img src="static/login_stl/images/bundling.png" width="100%" />			
			<div class="bundling" >账号：<input type="text" id="username" name="username" placeholder="请输入信息化日清账号"/></div>
			<div class="bundling" >密码：<input type="password" id="password" name="password" placeholder="请输入信息化日清密码"/></div>
			<!-- 
			<span class="fl"><a href="#">无法登陆</a></span>
			<span class="fr"><input id="saveid" type="checkbox" onclick="savePaw()"/><a href="javascript:void(0)">记住密码</a></span>
			 -->
			<div style="height:50px;"></div>
			<div style="width:70%; margin:0 auto; text-align:center;">
				<button  type="button" class="btn btn-info btn-unbuding" onclick="login()">确认绑定</button>
				<br/><br/>
				无法绑定？<span style="color:#32c2f7;">请联系管理员</span>
			</div>
		<script type="text/javascript" src="plugins/JQuery/jquery-1.12.2.min.js"></script>
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<script type="text/javascript" src="static/js/jquery.cookie.js"></script>
		<script type="text/javascript">
			$(function() {
				var username = $.cookie('username');
				var password = $.cookie('password');
				if (typeof(username) != "undefined"
						&& typeof(password) != "undefined") {
					$("#username").val(username);
					$("#password").val(password);
					$("#saveid").attr("checked", true);
				}
			});
		
			function login(){
				if(check()){
					var username = $("#username").val();
					var password = $("#password").val();
					var code = username + "," + password;
					$.ajax({
						type: "POST",
						url: 'app_login/login_bind.do?tm='+new Date().getTime(),
				    	data: {KEYDATA:code},
						success: function(data){
							if("success" == data){
								saveCookie();
								window.location.href="<%=basePath %>app_login/bind.do";
							}else if("usererror" == data){
								$("#username").tips({
									side : 1,
									msg : "用户名或密码有误",
									bg : '#ff0000',
									time : 15
								});
								$("#username").focus();
							}else if("empNotEnabled" == data){
								$("#username").tips({
									side : 1,
									msg : "用户对应的员工未启用",
									bg : '#ff0000',
									time : 15
								});
								$("#username").focus();
							}else if("existOpenId" == data){
								$("#username").tips({
									side : 1,
									msg : "该账号已绑定其他微信号",
									bg : '#ff0000',
									time : 15
								});
								$("#username").focus();
							}
							else{
								$("#loginname").tips({
									side : 1,
									msg : "缺少参数",
									bg : '#ff0000',
									time : 15
								});
								$("#username").focus();
							}
						}
					});
				}
			}
		
			//客户端校验
			function check() {
				if ($("#useranme").val() == "") {
					$("#useranme").tips({
						side : 1,
						msg : '用户名不得为空',
						bg : '#ff0000',
						time : 3
					});
					$("#useranme").focus();
					return false;
				} else {
					$("#useranme").val(jQuery.trim($('#useranme').val()));
				}
	
				if ($("#password").val() == "") {
					$("#password").tips({
						side : 1,
						msg : '密码不得为空',
						bg : '#ff0000',
						time : 3
					});
					$("#password").focus();
					return false;
				}
				return true;
			}
			
			function savePaw() {
				if (!$("#saveid").is(':checked')) {
					$.cookie('username', '', {
						expires : -1
					});
					$.cookie('password', '', {
						expires : -1
					});
					$("#username").val('');
					$("#password").val('');
				}
			}

			function saveCookie() {
				if ($("#saveid").is(':checked')) {
					$.cookie('username', $("#username").val(), {
						expires : 7
					});
					$.cookie('password', $("#password").val(), {
						expires : 7
					});
				}
			}
			function quxiao() {
				$("#username").val('');
				$("#password").val('');
			}
		</script>
	</body>
</html>