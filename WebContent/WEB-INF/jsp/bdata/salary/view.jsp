<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <base href="<%=basePath%>">
<title>查看</title>
<%@ include file="../../system/admin/top.jsp"%>

	<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>



<style>
#viewAll table tr{
	height: 40px;
}
</style>
  </head>
  
  <body>
    	<div id="view" style="margin-left: 10px;">
    		<div id="viewAll">
    		<h5 style="font-style: italic;font-weight: bold;">基本信息</h5><hr>
    			<table>
    				<tr>
    					<td style="width:75px;">员工编号:</td><td>${pd.EMP_CODE}</td>
    					<td>员工姓名:</td><td>${pd.EMP_NAME}</td>
    				
    					<td>所属部门:</td><td>${pd.DEPT_NAME}</td>
    				</tr>
    				<tr>
    					<td>年月:</td><td>${pd.YM}</td>
    					<td>绩效总额:</td><td>${pd.SALARY_AMOUNT}</td>
    				</tr>
    				<tr>
    					<td>绩效公式:</td><td colspan="5">${pd.FORMULA}</td>
    				</tr>
    			</table>
    		</div>
			<br>
			<br>
    		<div id="viewInfo">
    			<h5 style="font-style: italic;font-weight: bold;">工资明细</h5>
    				<table class="table table-stripted">
    				<tr>
    					<c:forEach items="${itemList }" var="item" varStatus="vs">
    						<c:if test="${item.BS_TYPE !='2' }">
    						<td>${item.BS_NAME }</td>
    						</c:if>
    						<c:if test="${item.BS_TYPE =='2' }">
    						<td><input type="hidden" value="${item.BS_NAME }"></td>
    						</c:if>
    					</c:forEach>
    				</tr>
    				<tr>
    					<c:forEach items="${itemList }" var="item" varStatus="vs">
    						<c:if test="${item.BS_TYPE !='2' }">
    						<td>${item.BS_AMOUNT }</td>
    						</c:if>
    						<c:if test="${item.BS_TYPE =='2' }">
    						<td><input type="hidden" value="${item.BS_NAME }"></td>
    						</c:if>
    					</c:forEach>
    				</tr>
    				</table>
    		</div>
    	</div>
  </body>
</html>

