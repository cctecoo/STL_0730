<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

	    		<input type="hidden" name="empDeptArea" value="LEN" /><!-- 标识财务表单 -->
	    		
				<!-- 表格内容 -->
			    <table class="table table-bordered" style="margin-bottom:2px; ">
			    	
			    	<!-- 主体内容 start -->
			    	<tr>
			    		<td style="width:65px;">申请人</td>
			    		<td >${work.CREATE_EMP_NAME }</td>
			    	</tr><tr>
			    		<td >申请日期</td>
			    		<td >${work.CREATE_DATE }</td>
			    	</tr>
			    	<tr>
			    		<td>所在部门</td>
			    		<td colspan="3">${suoZaiBuMen }, ${suoZaiGongSi }</td>
			    	</tr>
			    	<tr>
			    		<td>成本中心</td>
			    		<td colspan="3">${costDeptName }</td>
			    	</tr>
			    	<%--<tr>
			    		<td>邮箱/电话</td>
			    		<td colspan="3">${email }, ${telPhone }</td>
			    	</tr>--%>
			    	<tr>
			    		<td>开户银行</td>
			    		<td colspan="3">${bankName }</td>
			    	</tr>
			    	<tr>
			    		<td>收款人</td>
			    		<td colspan="3">${bankAccountName }</td>
			    	</tr>
			    	<tr>
			    		<td>帐号</td>
			    		<td colspan="3">${bankAccount }</td>
			    	</tr>
			    	<tr>
			    		<td>借款日期</td>
			    		<td>${jieKuanRiQi }</td>
			    		<td>借款金额</td>
			    		<td>${shiJiFuKuanJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>借款用途</td>
			    		<td colspan="3">${shuoMing }</td>
			    	</tr>
			    	<tr>
			    		<td>付款方式</td>
			    		<td>${fuKuanFangShi }</td>
			    		<td>还款日期</td>
			    		<td>${huanKuanRiQi }</td>
			    	</tr>
			    	<tr>
			    		<td>还款方式</td>
			    		<td colspan="3">${huanKuanFangShi }</td>
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
		
			//检查复选框和单选框
			function checkRadioOrCheckboxVal(){
				return true;
			}
		</script>
	</body>
</html>
