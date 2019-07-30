<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<base href="<%=basePath%>">
		<meta charset="utf-8" />
		<title></title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		
<script type="text/javascript">
	
	
	top.changeui();
	
	//保存
	function save(){
		if($("#buttonsName").val()==""){
			$("#buttonsName").focus();
			return false;
		}else if($("#buttonsEvent").val()==""){
			$("#buttonsEvent").focus();
			return false;
		}
			$("#form1").submit();
			$("#zhongxin").hide();
			$("#zhongxin2").show();
	}
	
</script>
	</head>
<body>
		<form action="buttons/edit.do" name="form1" id="form1"  method="post">
		<input type="hidden" name="BUTTONS_ID" id="id" value="${pd.BUTTONS_ID}"/>
			<div id="zhongxin">
			<table>
				<tr>
					<td><input type="text" name="BUTTONS_NAME" id="buttonsName" value="${pd.BUTTONS_NAME}" placeholder="这里输入按钮名称" title="按钮名称" /></td>
				</tr>
				<tr>
					<td><input type="text" name="BUTTONS_EVENT" id="buttonsEvent" value="${pd.BUTTONS_EVENT}" placeholder="这里输入按钮事件" title="按钮事件"/></td>
				</tr>
				<tr>
					<td><input type="text" name="BUTTONS_ORDER" id="buttonsOrder" value="${pd.BUTTONS_ORDER}" placeholder="这里输入按钮排序" title="按钮排序"/></td>
				</tr>
				<tr>
					<td><input type="text" name="DESCRIPTION" id="description" value="${pd.DESCRIPTION}" placeholder="这里输入描述" title="描述"/></td>
				</tr>
				<tr>
					<td>
						<input type="checkbox" name="ENABLED" id="enabled" class="ace-switch ace-switch-4" value="${pd.ENABLED}" <c:if test="${pd.ENABLED == 1 }">checked="checked"</c:if> onclick="this.value=(this.value==0)?1:0"/>
						<span class="lbl"></span>
					</td>
				</tr>
				<tr>
					<td style="text-align: center;">
						<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
						<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
					</td>
				</tr>
			</table>
			</div>
		</form>
	
	<div id="zhongxin2" class="center" style="display:none"><img src="static/images/jzx.gif"  style="width: 50px;" /><br/><h4 class="lighter block green"></h4></div>
		<!-- 引入 -->
		<script src="static/1.9.1/jquery.min.js"></script>
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		
	<script type="text/javascript">
	$(function(){
		//initCheckbox();
		});	
	
	function initCheckbox(){
		if(document.getElementById("enabled").value == 1 ){
			document.getElementById("enabled").checked = true;
		}else{
			document.getElementById("enabled").checked = false;
		}
	}
	</script>
</body>
</html>
