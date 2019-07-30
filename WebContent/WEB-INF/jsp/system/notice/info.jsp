<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
	<head>
	<base href="<%=basePath%>">
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    
    <script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
<body>
	<div style="min-width: 800px; max-width:1000px; margin:0 auto;">
		<div style="margin-left:20px; padding:0 80px 0 0;">
			<h4>
				<b><div id="title" style="text-align:center">${pd.TITLE}</div></b>
			</h4>
			<h5>
				<div style="text-align:center; margin-left:200px;">
					<c:choose>
						<c:when test="${empty pd.UPDATE_TIME}"><span>${pd.CREATE_TIME}</span></c:when>
						<c:otherwise><span>${pd.UPDATE_TIME}</span></c:otherwise>
					</c:choose>
					<span> ${pd.CREATE_USER_NAME}</span>
					<span>通知区域：${pd.AREA}</span>
				</div>
			</h5>
				
			<div id="show_content"></div>
			<input type="hidden" id="article_content" value="${pd.CONTENT}">
		
		</div>
	</div>
	<script type="text/javascript">
		$(function(){
			$("#show_content")[0].innerHTML = $("#article_content").val();
		})
	</script>
</body>
</html>