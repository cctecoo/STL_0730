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
	   	
		<input type="hidden" name="empDeptArea" value="TRA" /><!-- 标识财务表单 -->
		
				<!-- 表格内容 -->
			    <table class="table table-bordered" style="margin-bottom:2px; ">
			    	
			    	<!-- 主体内容 start -->
			    	<tr>
			    		<td style="width:65px;">申请人</td>
			    		<td>${work.CREATE_EMP_NAME }</td>
			    	</tr>
			    	<tr>
			    		<td>申请日期</td>
			    		<td>${work.CREATE_DATE }</td>
			    	</tr>
			    	<tr>
			    		<td>所属部门</td>
			    		<td>${suoZaiBuMen }, ${suoZaiGongSi }</td>
			    	</tr>
			    	<tr>
			    		<td>成本中心</td>
			    		<td>${costDeptName }</td>
			    	</tr>
			    	<%--<tr>
			    		<td>邮箱/电话</td>
			    		<td>${email }, ${telPhone }</td>
			    	</tr>--%>
					<tr>
						<td>出差类型</td>
						<td>${travelType }</td>
					</tr>
			    	
			    	<tr><td colspan="2">行程</td></tr>
			    	<tr>
			    		<td>交通工具</td>
			    		<td style="padding-left: 15px;">
			    			<label class="checkbox inline">
						        <input class="stepLevel_1" type="checkbox" <c:if test="${fn:contains(vehicle, '飞机')}">checked</c:if> 
						        	name="vehicle" value="飞机"/>飞机
						    </label>
						    <label class="checkbox inline">
						        <input class="stepLevel_1" type="checkbox" <c:if test="${fn:contains(vehicle, '火车')}">checked</c:if> 
						        	name="vehicle" value="火车">火车
						    </label>
						    <label class="checkbox inline">
						        <input class="stepLevel_1" type="checkbox" <c:if test="${fn:contains(vehicle, '汽车')}">checked</c:if> 
						        	name="vehicle" value="汽车"/>汽车
						    </label>
						    <label class="checkbox inline">
						        <input class="stepLevel_1" type="checkbox" <c:if test="${fn:contains(vehicle, '其它')}">checked</c:if> 
						        	name="vehicle" value="其它">其它
						    </label>
			    		</td>
			    	</tr>
			    	<tr>
			    		<td>单程/往返</td>
			    		<td style="padding-left: 15px;">
			    			<label class="radio inline">
						        <input class="stepLevel_1" type="radio" <c:if test="${tripType=='单程'}">checked</c:if> 
						        	name="tripType" value="单程"/>单程
						    </label>
						    <label class="radio inline">
						        <input class="stepLevel_1" type="radio" <c:if test="${tripType=='往返'}">checked</c:if> 
						        	name="tripType" value="往返">往返
						    </label>
			    		</td>
			    	</tr>
			    	
			    	<tr>
			    		<td>出发地</td>
			    		<td>${departure }</td>
			    	</tr>
			    	<tr>
			    		<td>目的地</td>
			    		<td>${destination }</td>
			    	</tr>
			    	
			    	<tr>
			    		<td>出差日期</td>
			    		<td>${startDate }至${endDate }, 共${travelDays }天</td>
			    	</tr>
			    	
			    	<tr>
			    		<td>备注</td>
			    		<td>${shuoMing }</td>
			    	</tr>
			    	
			    	<!-- 主体内容 end -->
			    	
			    </table>
				
		    </div><!-- formDetail end -->
		    
		<%@include file="app_formFoot.jsp" %>
		<%@include file="app_formJs.jsp" %>	
		
		<div style="margin-top:90px;">
			<%@include file="../footer.jsp"%>
		</div>	
	
		<script type="text/javascript">
		
			//检查所有数字输入是否正确，检查是否超过最大值
			function checkInputNum(){
				return true;
			}
			
			
			//检查限制条件是否满足,返回true/false
			function checkLimit(){
				var isMatch = true;
				return isMatch;
			}	
		
			function checkRadioOrCheckboxVal(){
				//检查复选框和单选框
				return true;
			}
		</script>
	</body>
</html>