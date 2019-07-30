<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<base href="<%=basePath%>">
<!-- jsp文件头和头部 -->
<%@ include file="top.jsp"%>
        <link rel="stylesheet" href="plugins/alertifyJS/alertify.core.css">
        <link rel="stylesheet" href="plugins/alertifyJS/alertify.default.css">
		<style type="text/css">
		.commitopacity{position:absolute; width:100%; height:100px; background:#7f7f7f; filter:alpha(opacity=50); -moz-opacity:0.8; -khtml-opacity: 0.5; opacity: 0.5; top:0px; z-index:99999;}
		.dropdown-menu .badge-success{float: right}
		.alertify-log {
            background: #438eb9;
        }
       
		</style>
        
</head>
<body onload="startWebSocket()">

	<!-- 页面顶部¨ -->
	<%@ include file="head.jsp"%>

	<div class="container-fluid" id="main-container">
		<a href="#" id="menu-toggler"><span></span></a>
		<!-- menu toggler -->

		<!-- 左侧菜单 -->
		<%@ include file="left.jsp"%>

		<div id="main-content" class="clearfix">

			<div id="jzts" style="display:none; width:100%; position:fixed; z-index:99999999;">
			<!-- <div class="commitopacity" id="bkbgjz"></div>
			<div style="padding-left: 70%;padding-top: 1px;">
				<div style="float: left;margin-top: 3px;"><img src="static/images/loadingi.gif" /> </div>
				<div style="margin-top: -5px;"><h4 class="lighter block red">&nbsp;加载中 ...</h4></div>
			</div> -->
			</div>

			<div>
				<iframe name="mainFrame" id="mainFrame" scrolling="no" frameborder="0" src="tab.do" style="margin:0 auto;width:100%;height:100%;"></iframe>
			</div>

			<!-- 换肤 -->
		<%-- 	<div id="ace-settings-container">
				<div class="btn btn-app btn-mini btn-warning" id="ace-settings-btn">
					<i class="icon-cog"></i>
				</div>
				<div id="ace-settings-box">
					<div>
						<div class="pull-left">
							<select id="skin-colorpicker" class="hidden">
								<option data-class="default" value="#438EB9"
									<c:if test="${user.SKIN =='default' }">selected</c:if>>#438EB9</option>
								<option data-class="skin-1" value="#222A2D"
									<c:if test="${user.SKIN =='skin-1' }">selected</c:if>>#222A2D</option>
								<option data-class="skin-2" value="#C6487E"
									<c:if test="${user.SKIN =='skin-2' }">selected</c:if>>#C6487E</option>
								<option data-class="skin-3" value="#D0D0D0"
									<c:if test="${user.SKIN =='skin-3' }">selected</c:if>>#D0D0D0</option>
							</select>
						</div>
						<span>&nbsp; 选择皮肤</span>
					</div>
					<div>
						<label><input type='checkbox' name='menusf' id="menusf"
							onclick="menusf();" /><span class="lbl" style="padding-top: 5px;">菜单缩放</span></label>
					</div>
				</div>
			</div> --%>
			<!--/#ace-settings-container-->

		</div>
		<!-- #main-content -->
	</div>
	<!--/.fluid-container#main-container-->
	<!-- basic scripts -->
		<!-- 引入 -->
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<!-- 引入 -->
		
		<script type="text/javascript" src="static/js/jquery.cookie.js"></script>
		<script type="text/javascript" src="static/js/myjs/menusf.js"></script>
		<script type="text/javascript" src="plugins/alertifyJS/alertify.min.js"></script>
		<script type="text/javascript">
		var count = 0;
		$(function() {
			if (typeof ($.cookie('menusf')) == "undefined") {
				$("#menusf").attr("checked", true);
				$("#sidebar").attr("class", "");
			} else {
				$("#sidebar").attr("class", "menu-min");
			}
			//setInterval("loginTime()", 1000*60);
			
		});
		
		var ws = null;
		//开启WebSocket连接
		function startWebSocket(){
			//在自己电脑部署测试
			//ws = new WebSocket("ws://localhost:8080/STL-OEC/task/msg");//在服务器部署测试//122.226.156.180:8080
			//判断浏览器是否支持消息提示
			var target = "ws://" + window.location.host + "<%=path%>/task/msg";
			ws = new WebSocket(target);
			/*
			if ('WebSocket' in window) {  
                ws = new WebSocket(target);  
            } else if ('MozWebSocket' in window) {  
                ws = new MozWebSocket(target);  
            } else {  
                alert('浏览器不支持系统消息');  
                return;  
            }  
			*/
			
			ws.onopen=function(evt){
			    console.log("opend ws");
			};
			
			ws.onmessage = function(evt){
				console.log("onmessage  ws");
			    var data = eval("("+evt.data+")");
			    //公告
			    if(data.msgType && data.msgType=='notice'){
			    	noticeUser(data);
			    }
			    //消息
				if(data.taskMsg){
					appendNotice(data);
				}
				//刷新
				if(data.command){
					refreshCount();
				}
				
			};
			
			ws.onclose = function(evt){
				console.log("关闭 ws");
				ws.close();
			}
			
			ws.onerror = function(){
				console.log("ws错误");
			}
			
			//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
		    window.onbeforeunload = function(){
    			ws.close();
		    }
		}
		
		//发送消息
		function sendMSG() {
		    var message = '123213';
		    ws.send(message);
		}
		
		//通过系统内消息提醒
		function appendNotice(data){
			/* var content = "<span style='cursor: pointer;' " + 
				"onclick='siMenu(\"z"+data.MENU_ID+"\", \"lm"+data.PARENT_ID+"\",\""+data.MENU_NAME+"\",\""+data.MENU_URL+"\")'>"+
				data.taskMsg+"</span>"; */
			//右下角弹出框	
			/* alertify.set({ delay: 600000 });//10分钟//消息持续一段时间后消失，单位ms
			alertify.log(content); */
			var content = "<li>"+
			"    <a href='javascript:void(0)' onclick='removeNotice(this);siMenu(\"z"+data.MENU_ID+"\", \"lm"+data.PARENT_ID+"\",\""+data.MENU_NAME+"\",\""+data.MENU_URL+"\")'>"+
			"        <span class='msg-body'>"+
			"            <span class='msg-title'>"+data.taskMsg+"</span>"+
			"        </span>"+
			"    </a>"+
			"</li>";
			$("#noticeList").append(content);
			$("#noticeList").append('<li style="display: none"></li>');
			count++;
			$("#noticeCount").html(count);
			$("#notice").removeClass('icon-animated-bell');
			setTimeout('$("#notice").addClass("icon-animated-bell")',500);
		}

		//移除消息
		function removeNotice(obj){
			 obj.remove();
			 count--;
			 $("#noticeCount").html(count);
		}
		
		//跳转到处理页面
		function showHandlePage(url, tabName){
			var PARENT_FRAME_ID = $(".tab_item2_selected", window.parent.document).parents('table').attr('id');
			siMenu('z', 'lm', tabName, url+'&sourcePage=summaryPage'+"&PARENT_FRAME_ID=" +PARENT_FRAME_ID);
		}
		
		//通过系统内消息提醒
		function noticeUserByAlertify(data){
			var content = '<span style="cursor: pointer;" ' + 
				' onclick="showHandlePage(\'' + data.msgUrl + '\', \'查看通知\')" >' +
				data.msgText + '</span>';
			//右下角弹出框	
			alertify.set({ delay: 600000 });//10分钟（600s）//消息持续一段时间后消失，单位ms
			alertify.log(content); 
		}
		
		//通过弹窗消息提醒
		function noticeUser(data){
			//检查浏览器是否支持
			if (window.Notification) {
				//定义消息通知函数
				var popNotice = function() {
			        if (Notification.permission == "granted") {
			            var notification = new Notification("系统消息", {
			                body: data.msgText,
			                icon: ''
			            });
			            
			            notification.onclick = function() {
			            	showHandlePage(data.msgUrl, '查看通知');
			                notification.close();    
			            };
			        }else{
			        	//不允许通知的话，则系统内提示
			        	noticeUserByAlertify(data);
			        } 
			    };
			    //根据是否允许通知弹出消息
				if (Notification.permission == "granted") {
		            popNotice();
		        } else if (Notification.permission != "denied") {
		            Notification.requestPermission(function (permission) {
		              popNotice();
		            });
		        }else{
		        	//不允许通知的话，则系统内提示
		        	noticeUserByAlertify(data);
		        }
			} else {
			    //alert('浏览器不支持通知');
			    noticeUserByAlertify(data);
			}
		}
		
		
		function cmainFrame(){
			var hmain = document.getElementById("mainFrame");
			var bheight = document.documentElement.clientHeight;
			hmain .style.width = '100%';
			hmain .style.height = (bheight  - 71) + 'px';
			//var bkbgjz = document.getElementById("bkbgjz");
			//bkbgjz .style.height = (bheight  - 41) + 'px';
			
		}
		cmainFrame();
		window.onresize=function(){  
			cmainFrame();
		};
		jzts();
		</script>
</body>
</html>
