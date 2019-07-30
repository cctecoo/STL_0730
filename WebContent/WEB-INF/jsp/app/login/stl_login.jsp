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
		<title>用户登录</title>
		<link rel="stylesheet" href="static/css/app-style.css"></link>
		<style>
			body{ background:#219bde;}
		</style>
	</head>
	<body style="height:100%; background: none">
		<div class="logo">
			<!-- <img src="static/login_new/images/stl-logo.png" /> -->
			<img src="static/login_stl/images/log_1.jpg" />
			
		</div>
		<div class="login" style="width:80%; margin:10% auto">
			<div class="login_input" >用户名：<input type="text" id="username" name="username" /></div>
			<div class="login_input" >密码：<input type="password" id="password" name="password" /></div>
			<a onclick="login()" class="button blue bigrounded" >登陆</a>
			<!-- 
			<span class="fl"><a href="#">无法登陆</a></span>
			<span class="fr"><input id="saveid" type="checkbox" onclick="savePaw()"/><a href="javascript:void(0)">记住密码</a></span>
			 -->
			
			<div id="cleaner"></div>
		</div>
		<input id="viewName" name ="viewName" type="hidden" value=${pd.viewName} />
		<input id="code" name ="code" type="hidden" value=${pd.code} />
		<div class="login_foot" style="color:black">
			©2018 浙江司太立制药股份有限公司
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
					var myViewName = $("#viewName").val();
					if(myViewName == null)
					{
						myViewName = "web";
					}
					var code = username + "," + password;
					var myCode = $("#code").val();
					if(myCode == null || myCode == '/')
					{
						myCode = "failcode";
					}
					$.ajax({
						type: "POST",
						url: 'app_login/login.do?tm='+new Date().getTime(),
				    	data: {KEYDATA:code,viewName:myViewName,code:myCode},
						success: function(data){
							if("success" == data){
								saveCookie();
								window.location.href="<%=basePath %>app_login/login_index.do?viewName="+myViewName+"&code="+myCode;
							}else if("usererror" == data){
								$("#username").tips({
									side : 1,
									msg : "用户名或密码有误",
									bg : '#FF5080',
									time : 15
								});
								$("#username").focus();
							}else if("empNotEnabled" == data){
								$("#username").tips({
									side : 1,
									msg : "用户对应的员工未启用",
									bg : '#FF5080',
									time : 15
								});
								$("#username").focus();
							}else if("existOpenId" == data){
								$("#username").tips({
									side : 1,
									msg : "该账号已绑定其他微信号",
									bg : '#FF5080',
									time : 15
								});
								$("#username").focus();
							}else if("existUser" == data){
								$("#username").tips({
									side : 1,
									msg : "该微信已绑定其他账号",
									bg : '#FF5080',
									time : 15
								});
								$("#username").focus();
							}
							else{
								$("#loginname").tips({
									side : 1,
									msg : "缺少参数",
									bg : '#FF5080',
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
						bg : '#AE81FF',
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
						bg : '#AE81FF',
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