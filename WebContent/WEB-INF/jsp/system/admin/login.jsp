<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh_CN">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
		<title>${pd.SYSNAME}</title>
		<meta charset="utf-8">
		<meta name="author" content="forework">
		<meta name="format-detection" content="telephone=no">
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta name="msapplication-tap-highlight" content="no">
		<link rel="stylesheet" type="text/css" href="static/login_stl/css/basic.css">
		<link rel="stylesheet" type="text/css" href="static/login_stl/css/less.css">
		
		<!--
		<style type="text/css">
		.login-topBg {
		    background: url(static/login_stl/images/login_img.jpg) center center no-repeat #fff;
		}
		</style>
		-->
		<style type="text/css">
			
			.loginTop{height:100px; margin-top:80px;}
			.loginCen {
			    background: url(static/login_stl/oec_img/oec_bg.jpg) center center no-repeat #fff;
			    height: 431px; min-width: 1000px;
			}
			.loginBg{width:500px; margin-left:50%;}
			.loginUser{
				background: url(static/login_stl/oec_img/login_bg_black1.png) center center repeat;
				height:300px; width:230px; margin-top:80px; padding: 0 50px;
				float:right;
			}
			.qrcode{
				margin:80px 0 0 30px; float:right; width:102px;
			}
			.userTip{
			    margin-top: 20px;
			    font-size: 10px;
			    width: 100%;
			    float: right;
			    color: #b1cdd1;
			}
			.footerText {
			    font-size: 12px;
			    /* font-family: simsun; */
			    color: #2a2a2a;
			    display: inline-block;
			}
		</style>
	</head>
	<body>
		<div class="">
			<div class="loginTop">
				<div style="text-align:center;">
					<!-- 登陆页面的日清图标 -->
					<img src="static/logo_change/stl/login_top.jpg" />
					
					<!-- 
					<img src="static/login_stl/oec_img/oec_header.png" />
					-->
				</div>
				<!-- 
				<div style="float: right; margin-top: -34px; width: 360px; font-size: 12px;">
					<span>加入收藏</span> <span>|</span> <span>登录帮助</span> <span>|</span> <span>联系我们</span>
				</div>
				 -->
			</div>
			
			<div style="background-color: #1f345f;">
			<div class="loginCen">	 
				<div class="loginBg">
					<div class="qrcode">
						<img src="static/img_logo/qrcode.jpg" style="width:102px; height:102px;" />
						<span style="font-size:10px; color:white">关注微信服务号</span>
					</div>
					
					<!-- 用户登陆区域 -->
					<div class="loginUser">
						<div style="width:86px;margin:20px auto;">
							<img src="static/login_stl/oec_img/title.png" />
						</div>
						<div class="ui-form-item loginUsername">
			             	<!-- <img src="static/login_stl/oec_img/user.png" style="margin-bottom:-14px;" /> -->
			             	<input type="username" name="loginname" id="loginname" value="" placeholder="用户名"
			             		style="width:205px;height:35px;padding:0;padding-left:20px;margin-bottom:10px; -webkit-box-shadow: 0 0 0px 175px white inset;">
			            </div>
						<div class="ui-form-item loginPassword">
							<!-- <img src="static/login_stl/oec_img/password.png" style="margin-bottom:-14px;" /> -->
							<input type="password" name="password" id="password" placeholder="密码"
								style="width:205px;height:35px;padding:0;padding-left:20px;margin-bottom:0; -webkit-box-shadow: 0 0 0px 1000px white inset;">
						</div>
						<div style="float: right;display: none;">
							<div style="float: left;">
								<input name="form-field-checkbox" id="saveid" type="checkbox" 
									onclick="savePaw();" style="padding-top: 0px;" />
							</div>
							<div style="float: left; margin-top: 3px; margin-left: 2px;">
								<font color="white">记住密码</font>
							</div>
						</div>
						<a class="btnStyle btn-register" id="to-recover" onclick="doLogin();"
							style="background: url(static/login_stl/oec_img/oecloginbtn.png) center center;height:20px;"> 
						</a>
					</div>
				
					<div class="userTip">
						温馨提示：用户密码建议每三个月修改一次，长度至少8位并包含大小写字母
					</div>
					
				</div><!-- loginBg end -->
			
			</div>
			</div>
			
			<div style="text-align:center; line-height:60px;">
				<span class="footerText">版权所有&nbsp;&nbsp;©2018 浙江司太立制药股份有限公司</span>
			</div>
		
		</div>
		<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<script type="text/javascript" src="static/js/jquery.cookie.js"></script>
		<script type="text/javascript">
			$(function() {
				var login_name = $.cookie('loginname');
				var passwd = $.cookie('password');
				if (login_name != null && passwd != null) {
					$("#loginname").val(login_name);
					$("#password").val(passwd);
					$("#saveid").attr("checked", true);
				}
			});
			
			//回车绑定登录功能
			$(document).keyup(function(event) {
				if (event.keyCode == 13) {
					$("#to-recover").trigger("click");
				}
			});
		
			//登录
			function doLogin() {
				if (check()) {
					var loginname = $("#loginname").val().trim();
					var password = $("#password").val();
					$.ajax({
						type : "POST",
						url : 'login_login.do?tm=' + new Date().getTime(),
						data : {
							"username" : loginname,
							"password" : password
						},
						dataType : 'json',
						cache : false,
						success : function(data) {
							if ("success" == data.result) {
								saveCookie();
								window.location.href = "login_index.do";
							} else if ("usererror" == data.result) {
								$("#loginname").tips({
									side : 1,
									msg : "用户名或密码有误",
									bg : '#FF5080',
									time : 15
								});
								$("#loginname").focus();
							}else if("empNotEnabled" == data.result){
								$("#loginname").tips({
									side : 1,
									msg : "用户对应的员工未启用",
									bg : '#FF5080',
									time : 15
								});
								$("#loginname").focus();
							} else {
								$("#loginname").tips({
									side : 1,
									msg : "缺少参数",
									bg : '#FF5080',
									time : 15
								});
								$("#loginname").focus();
							}
						}
					});
				}
			}
	
			//客户端校验
			function check() {
				if ($("#loginname").val().trim() == "") {
					$("#loginname").tips({
						side : 2,
						msg : '用户名不得为空',
						bg : '#AE81FF',
						time : 3
					});
					$("#loginname").focus();
					return false;
				}
	
				if ($("#password").val().trim() == "") {
					$("#password").tips({
						side : 2,
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
				if (!$("#saveid").attr("checked")) {
					$.cookie('loginname', '', {
						expires : -1
					});
					$.cookie('password', '', {
						expires : -1
					});
					$("#loginname").val('');
					$("#password").val('');
				}
			}
	
			function saveCookie() {
				if ($("#saveid").attr("checked")) {
					$.cookie('loginname', $("#loginname").val(), {
						expires : 7
					});
					$.cookie('password', $("#password").val(), {
						expires : 7
					});
				}
			}
	
		</script>
		<script>
			//TOCMAT重启之后 点击左侧列表跳转登录首页 
			if (window != top) {
				top.location.href = location.href;
			}
		</script>
	</body>
</html>