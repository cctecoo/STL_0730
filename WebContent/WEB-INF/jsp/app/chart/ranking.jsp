<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no"/>
<meta name="apple-mobile-web-app-capable" content="yes" />
<script src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script src="plugins/JQuery/jquery.min.js"></script>
<link rel="stylesheet" href="plugins/Bootstrap/css/bootstrap.css" />
<title>系统使用排名</title>
<style>
body{margin:0;}
.ranking_table{font-size:12px;padding:5px;}
.ranking_table table{width:100%;}
.ranking_table th{font-weight:normal;text-align:center;padding:10px 5px;}
.ranking_table td{padding:5px;color:#7e7c7c;}
.ranking_table td label{ text-align:center;width:100%;margin:0;color:#00a8ea;}
.progress{margin:0;margin-right:10px;margin-left:10px;height:10px;border-radius:0;background-color:#fefefe;}
</style>
					<script type="text/javascript">
						$("html").resize(function() {
						  $("#echarts").css("width","100%");
						});
					</script>
</head>

<body>
<div style="padding-left:10px;font-size:20px;margin-top:20px;margin-bottom:20px;">
<img src="static/login_stl/images/ranking.png" style="margin-top:-8px;" />&nbsp;&nbsp;&nbsp;系统使用情况排行榜
</div>
<div style="border-bottom:3px solid #f2f2f2;width:100%;"></div>
<div style="padding-left:15px;font-size:10px;margin:20px 0;">

<span style="color:#60ace0;">状元：</span><c:if test="${not empty first}">${first.EMP_DEPARTMENT_NAME}</c:if>&nbsp;&nbsp;
<span style="color:#60ace0;">榜眼：</span><c:if test="${not empty second}">${second.EMP_DEPARTMENT_NAME}</c:if>&nbsp;&nbsp;
<span style="color:#60ace0;">探花：</span><c:if test="${not empty third}">${third.EMP_DEPARTMENT_NAME}</c:if>

</div>
<div style="border-bottom:3px solid #f2f2f2;width:100%;"></div>
<div class="ranking_table">
	<table>
		<thead>
			<tr>
				<th style="width:12%;min-width:40px;">排行</th>
				<th style="width:35%;min-width:120px;">部门</th>
				<th colspan="2">指数</th>
				
			</tr>
		</thead>
		<tbody>
		<c:choose>
			<c:when test="${not empty list}">
				<c:forEach items="${list}" var="mylist" varStatus="vs">
					<tr>
						<td style="background:#f7f7f7;"><label>${vs.index+1}</label></td>
						<td style="background:#f7f7f7;">${mylist.EMP_DEPARTMENT_NAME}</td>
						<td style="background:#f7f7f7;">
							<div class="progress">
								<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width:${mylist.per}%;background-color:#b0d4ea;box-shadow:none;">&nbsp;</div>							
							</div>
						</td>
						<td   style="background:#f7f7f7;width:10%;min-width:25px;"><label>${mylist.per}%</label></td>
					</tr>	
				</c:forEach>
			</c:when> 
		</c:choose> 
		</tbody>
	</table>
</div>
</body>
</html>

