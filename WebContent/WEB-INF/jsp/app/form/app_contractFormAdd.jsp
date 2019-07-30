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
	
		<input type="hidden" name="empDeptArea" value="CON" /><!-- 标识财务表单 -->
				
				<!-- 表格内容 -->
			    <table class="table table-bordered" style="margin-bottom:2px; ">
			    	
			    	<!-- 主体内容 start -->
			    	<tr>
			    		<td style="width:95px;">申请人</td>
			    		<td >${work.CREATE_EMP_NAME }</td>
			    	</tr>
			    	<tr>
			    		<td >申请日期</td>
			    		<td >${work.CREATE_DATE }</td>
			    	</tr>
			    	<tr>
			    		<td >所属部门</td>
			    		<td >${suoZaiBuMen }</td>
			    	</tr>
			    	<tr>
			    		<td>合同类型</td>
			    		<td>${heTongLeiXing }</td>
			    	</tr><tr>
			    		<td >甲方</td>
			    		<td>${jiaFang }</td>
			    	</tr><tr>
			    		<td>乙方</td>
			    		<td>${yiFang }</td>
			    	</tr>
			    	<tr>
			    		<td>合同使用部门</td>
			    		<td>${shiYongBuMen }</td>
			    	</tr>
			    	<tr>
			    		<td>合同总金额(元)</td>
			    		<td>${jinE }</td>
			    	</tr>
			    	<tr>
			    		<td>付款方式</td>
			    		<td>${fuKuanFangShi }</td>
			    	</tr>
			    	<tr>
			    		<td>制式合同</td>
			    		<td>${zhiShi }</td>
			    	</tr>
			    	<tr>
			    		<td>合同编号</td>
			    		<td>${heTongBianHao }</td>
			    	</tr>
			    	<tr>
			    		<td>用途/事由</td>
			    		<td>${shuoMing }</td>
			    	</tr>
			    	
			    	<!-- 主体内容 end -->
			    </table>
			    
		    </div><!-- formDetail end -->
		    
		<%@include file="app_formFoot.jsp" %>
		<%@include file="app_formJs.jsp" %>
		
		<div  style="margin-top:90px;">
			<%@include file="../footer.jsp"%>
		</div>
	
		<script type="text/javascript">
			
			//检查所有数字输入是否正确，检查是否超过最大值
			function checkInputNum(){
				return true;
			}
			
			//检查限制条件是否满足,返回true/false
			function checkLimit(){
				return true;
			}
			
			function checkRadioOrCheckboxVal(){
				//检查复选框和单选框
				return true;
			}
			
		</script>
	</body>
</html>
