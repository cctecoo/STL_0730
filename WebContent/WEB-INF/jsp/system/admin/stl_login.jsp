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
		<style type="text/css">
		.login-topBg {
		    background: url(static/logo_change/stl/login_img.jpg) center center no-repeat #fff;
		}
		</style>
	</head>
	<body>
		<div class="wrapper" style="background-color: white;">
			<div class="login-top">
				<div style="height: 60px; background-color: white;">
					<div style="margin-left: 160px;">
						<img src="static/logo_change/stl/login_top.jpg" />
					</div>
					<!-- 
					<div style="float: right; margin-top: -34px; width: 360px; font-size: 12px;">
						<span>加入收藏</span> <span>|</span> <span>登录帮助</span> <span>|</span> <span>联系我们</span>
					</div>
					 -->
				</div>
				<div class="login-topBg">
					<div class="login-topBg1">
						<div class="login-topStyle">
							<div class="login-topStyle3" id="loginStyle" style="margin-top: 75px;">
								<h3>用户平台登录</h3>
								<div class="ui-form-item loginUsername">
					             	<input type="username" name="loginname" id="loginname" value="" placeholder="用户名">
					            </div>
								<div class="ui-form-item loginPassword">
									<input type="password" name="password" id="password" placeholder="请输入密码"
										style="margin-bottom: 0; -webkit-box-shadow: 0 0 0px 1000px white inset;">
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
								<a class="btnStyle btn-register" id="to-recover" onclick="doLogin();"> 立即登录</a>
							</div>
							
							<div style="width:235px;">
								<span style="width: 288px;right: 50px;top: 350px;position: absolute;font-size: 10px;">
									温馨提示：建议系统密码每三个月修改一次，保持长度至少8位并包含字母大小写
								</span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="loginCen" style="margin-top: 55px;">
		    <div class="login-center">
		      <div class="loginCenter-moudle">
		        <div class="loginCenter-moudleLeft" style="margin-right: 60px;"> &nbsp;</div>
		        <div class="loginCenter-moudleRight" style="  width: 1067px;"> 
		          <!--第一个--> 
		          <a class="loginCenter-mStyle loginCenter-moudle1" id="moudleRemove" style=" display:block;width: 340px;">
		           <span class="moudle-img"><img src="static/login_stl/images/login_bg_01.png"></span>
		            <span class="moudle-text"> 
		            <span class="moudle-text1" style="font-family:'微软雅黑'">多维度目标管理
		</span> 
		            <span class="moudle-text2" style="font-family:'微软雅黑'">Multi-dimensional target management </span> 
		            </span>
		             </a> 
		           <!--第二个--> 
		          <a class="loginCenter-mStyle loginCenter-moudle2" style=" display:block; width: 357px;" id="moudleRemove2" > 
		          <span class="moudle-img"><img src="static/login_stl/images/login_bg_02.png"></span> 
		           <span class="moudle-text">
		            <span class="moudle-text1" style="font-family:'微软雅黑'"> 全方位高效协同 
		</span>
		            <span class="moudle-text2" style="font-family:'微软雅黑'">Full range and efficient collaboration</span> 
		           </span>
		             </a> 
		            <!--第三个--> 
		                 <a class="loginCenter-mStyle loginCenter-moudle3" style=" display:block;" id="moudleRemove3" > 
		                 <span class="moudle-img"><img src="static/login_stl/images/login_bg_03.png"></span> 
		                   <span class="moudle-text"> 
		                 <span class="moudle-text"> <span class="moudle-text1" style="font-family:'微软雅黑'">可持续驱动升级 
		</span>
		                  <span class="moudle-text2" style="font-family:'微软雅黑'">Sustainable drive upgrade&nbsp;&nbsp;&nbsp;&nbsp;</span>
		            </span>
		            </span>
		                    </a> 
		         
		             </div>
		      </div>
		    </div>
			<div class="footer">
				<span class="footerText">Copyright2015-2025 浙江司太立制药股份有限公司 版权所有</span>
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
		<script>
			var _hmt = _hmt || [];
			(function() {
			  var hm = document.createElement("script");
			  hm.src = "https://hm.baidu.com/hm.js?b0fc6f08435ea291c3bd0e5d8d4d40cf";
			  var s = document.getElementsByTagName("script")[0]; 
			  s.parentNode.insertBefore(hm, s);
			})();
		</script>
	
	</body>
</html>