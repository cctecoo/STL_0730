<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<base href="<%=basePath%>">
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no"/>
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<link rel="stylesheet" href="static/app/css/mui.min.css" />
		<link rel="stylesheet" href="static/app/css/style.css" />
		<script type="text/javascript" src="static/app/js/mui.min.js"></script>
		<script type="text/javascript" src="static/app/js/jquery.min.js"></script>
		<title></title>
		<style>
			#reportTable{
				border-top:1px solid  #333;
				border-left:1px solid  #333;
				width:96%;
				margin : 0 auto;
			}
			#reportTable td{
				border-bottom:1px solid  #333;
				border-right:1px solid  #333;
				padding:3px 7px;
			}
		</style>
		<script>
		$(document).ready(function(){
			$(".keytask").click(function(){
				//$(".dailytask_btn").hide();
				$(this).siblings().find(".dailytask_btn").hide();
				$(this).find(".dailytask_btn").toggle();
			});
		});
		</script>
</head>
<body>
<div class="web_title">
	<div ></div>
	日常工作提交情况报表推送
</div>
	<p style="text-align: right;padding-right: 2%;margin-bottom: 0px;font-size: 12px">
		应提交: <span style="color: blue">${sumNum.ZS}</span> 未提交: <span style="color: red">${sumNum.ZS - sumNum.YTJ}</span>
	</p>

		<table id="reportTable">
		    <tr>
		           <td>姓名</td>
		           <td>所属部门</td>
		           <td>提交情况 </td>
		    </tr>
			<c:forEach items="${result}" var="list">
				<tr>
					<!-- <td class="w105">姓名：</td> -->
					<td><span>${list.EMP_NAME }</span></td>
				<!-- </tr> -->
			<!-- 	<tr> -->
					<!-- <td>所属部门：</td> -->
					<td title="${list.EMP_DEPARTMENT_NAME }">${list.EMP_DEPARTMENT_NAME }</td>
				<!-- </tr>
				<!-- <tr>
					<td>日常工作提交：</td>  -->
					<c:if test="${list.FINISH_TIME != null }">
					<td><span>已提交</span>
					
					</c:if>
					<c:if test="${list.FINISH_TIME == null }">
					<td><span>未提交</span>
					
					</c:if>
				</tr>
			</c:forEach>
		</table>

</body>
</html>