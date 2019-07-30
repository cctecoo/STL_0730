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
	<title>采购表单</title>
</head>	
<body>
	<%@include file="app_formHead.jsp" %>
	
	<input type="hidden" name="empDeptArea" value="PUR" /><!-- 标识表单类型，用于获取编码 -->
	
				<!-- 表格内容 -->
			    <table class="table table-bordered" style="margin-bottom:2px; ">
			    	
			    	<!-- 主体内容 start -->
			    	<tr>
			    		<td style="width:95px;">申请人</td>
			    		<td>${work.CREATE_EMP_NAME }</td>
			    	</tr>
			    	<tr>
			    		<td>申请日期</td>
			    		<td >${work.CREATE_DATE }</td>
			    	</tr>
			    	<tr>
			    		<td >所属部门</td>
			    		<td>${suoZaiBuMen }</td>
			    	</tr>
			    	
			    	
			    	<tr>
			    		<td>本付款批次</td>
			    		<td>第${currentPayOrder }次付款</td>
			    	</tr>
			    	<tr>
			    		<td>付款方式</td>
			    		<td>${fuKuanFangShi }</td>
			    	</tr>
			    	<tr>
			    		<td>申请付款金额</td>
			    		<td>${shiJiFuKuanJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>金额大写</td>
			    		<td>${fuKuanDaXie }</td>
			    	</tr>
			    	<tr>
			    		<td>币种</td>
			    		<td>${biZhong }</td>
			    	</tr>
			    	<c:if test="${not empty waiBiJinE && waiBiJinE != 0 }">
				    	<tr>
				    		<td>本次外币金额</td>
				    		<td>${waiBiJinE}</td>
				    	</tr>
			    	</c:if>
			    	<tr>
			    		<td>合同已付金额</td>
			    		<td>${yiFuJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>合同未付金额</td>
			    		<td>${weiFuJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>合同总金额</td>
			    		<td>${heTongJinE }</td>
			    	</tr>
			    	<c:if test="${not empty waiBiZongJinE && waiBiZongJinE != 0 }">
				    	<tr>
				    		<td>外币总金额</td>
			    		<td>${waiBiZongJinE }</td>
				    	</tr>
			    	</c:if>
			    	<tr>
			    		<td>采购合同</td>
			    		<td>
			    			<c:forEach items="${relateFormList }" var="item" varStatus="vs" >
			    				<a class="relateFormEle" onclick="showDetail(${item.workId });" style="cursor:pointer">${item.workName }</a>
			    			</c:forEach>
				   		</td>
			    	</tr>
			    	<c:if test="${not empty fuKuanQiSuanRi}">
			    		<tr>
					   		<td>付款起算日</td>
					   		<td>${fuKuanQiSuanRi }</td>
				    	</tr>
			    	</c:if>
			    	<c:if test="${not empty YueDingFuKuanShiJian}">
				    	<tr>
				    		<td>约定付款条件</td>
					   		<td>${YueDingFuKuanShiJian }</td>
				    	</tr>
			    	</c:if>
			    	<tr>
			    		<td>有无验收单</td>
			    		<td>${youYanShouDan }</td>
			    	</tr>
			    	<c:if test="${not empty ruKuRiQi}">
				    	<tr>
				    		<td>到货入库时间</td>
					   		<td>${ruKuRiQi }</td>
				    	</tr>
			    	</c:if>
			    	<c:if test="${not empty daoPiaoRiQi}">
				    	<tr>
					   		<td>到票时间</td>
					   		<td>${daoPiaoRiQi }</td>
				    	</tr>
			    	</c:if>
			    	<c:if test="${not empty qiTaShuoMing}">
				    	<tr>
				    		<td colspan="2">付款金额与合同金额不一致原因:${qiTaShuoMing }</td>
				    	</tr>
			    	</c:if>
			    	<tr>
			    		<td colspan="2">用途/事由:${shuoMing }</td>
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
