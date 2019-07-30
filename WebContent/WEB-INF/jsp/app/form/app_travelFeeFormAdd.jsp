<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
	<base href="<%=basePath%>">
	<meta name="description" content="overview & stats" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>表单工作</title>
</head>	
<body>
	<%@include file="app_formHead.jsp" %>
	
	<input type="hidden" name="empDeptArea" value="FIN" /><!-- 标识财务表单 -->
	
	<%@include file="app_FeeForm.jsp" %>
	
	
	<script type="text/javascript">
		
		//特殊表单，拼接出差信息
		appendTravelInfo();
		//拼接出差字段
		function appendTravelInfo(){
			var str = ''
				+ '<tr>'
    			+ '<td>出差单号</td>'
    			+ '<td colspan="3">${chuChaiShenQingDanHao }</td>'
    			+ '</tr>'
    			+ '<tr>'
    			+ '<td>实际开始</td>'
    			+ '<td>${chuChaiKaiShiRiQi }</td>'
    			+ '<td>实际结束</td>'
    			+ '<td>${chuChaiJieShuRiQi }</td>'
    			+ '</tr>';
    		$("#moneyTr").after(str);
		}
		
	</script>
	</body>
</html>
