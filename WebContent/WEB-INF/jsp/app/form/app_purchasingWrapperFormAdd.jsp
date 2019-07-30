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
			    		<td>${suoZaiBuMen }, ${suoZaiGongSi }</td>
			    	</tr>
			    	<tr>
			    		<td>成本中心</td>
			    		<td>${costDeptName }</td>
			    	</tr>
			    	
			    	<tr>
			    		<td>采购类型</td>
			    		<td>${caiGouLeiXing }</td>
			    	</tr>
			    	
			    	<tr>
			    		<td>申请单类型</td>
			    		<td>${xiangMuLeiXing }</td>
			    	</tr>
			    	<tr>
			    		<td>预计总金额</td>
			    		<td>${shiJiFuKuanJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>用途/事由</td>
			    		<td>${shuoMing }</td>
			    	</tr>
			    	
			    	<!-- 主体内容 end -->
			    </table>
			    
				<div>申请采购内容</div>
				<table id="itemTable" class="table table-bordered">
					<tbody>
						<c:if test="${costItemCount>0 }">
							<c:forEach begin="0" end="${costItemCount-1 }" varStatus="vs">
							<c:if test="${vs.index<6 }">
							<tr class="rowItem_${vs.index+1 }">
								<td style="width:35px; padding:0"
								<c:choose>
									<c:when test="${currentStep.STEP_SERVICE_TYPE=='库存确认' || not empty storePurchaseAmount_list[vs.index]}">
										rowspan="11"
									</c:when>
									<c:otherwise>rowspan="8"</c:otherwise>
								</c:choose> >${vs.index+1}
								</td>
								<td colspan="2">BOM类别:${bomFenLei_list[vs.index] }</td>
							</tr>
							<tr class="rowItem_${vs.index+1 }">
								<td style="width:65px;">名称</td>
								<td>${caiGouZiXiangMing_list[vs.index] }</td>
							</tr>
							<tr class="rowItem_${vs.index+1 }">
								<td>使用方</td>
								<td>${shiyongFang_list[vs.index] }</td>
							</tr>
							<tr class="rowItem_${vs.index+1 }">
								<td>预计金额</td>
								<td>${hanShuiJinE_list[vs.index] }</td>
							</tr>
							<tr class="rowItem_${vs.index+1 }">
								<td>成本中心</td>
								<td>${costDept_list[vs.index] }</td>
							</tr>
							<tr class="rowItem_${vs.index+1 }">
								<td>预算科目</td>
								<td>${keMu_list[vs.index] }</td>
							</tr>
							<tr class="rowItem_${vs.index+1 }">
								<td colspan="2">
									预算总额:${budget_list[vs.index] }
									, 本次提交后剩余:<span 
									<c:if test="${tiJiaoShengYuJinE_list[vs.index]<'0' }">style="color:red"</c:if>
										>${tiJiaoShengYuJinE_list[vs.index]}</span>
								</td>
							</tr>
							<tr class="rowItem_${vs.index+1 }">
								<td>说明</td>
								<td>${shuoMing_list[vs.index] }</td>
							</tr>
							
							<c:if test="${currentStep.STEP_SERVICE_TYPE=='库存确认' || not empty storePurchaseAmount_list[vs.index]}">
							<tr class="rowItem_${vs.index+1 }">
								<td colspan="2">可用库存量:<input class="storeAdjust" type="text" name="storeRestAmount_${vs.index+1}" 
										value="${storeRestAmount_list[vs.index] }" style="width:110px"/>
								</td>
							</tr>
							<tr>
								<td colspan="2">仓储采购量:<input class="storeAdjust floatNumEle" type="text" name="storePurchaseAmount_${vs.index+1}" 
										value="${storePurchaseAmount_list[vs.index] }" style="width:110px"/>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<input class="storeAdjust optionalInput" type="text" name="storePurchaseShuoMing_${vs.index+1}" 
										value="${storePurchaseShuoMing_list[vs.index] }"  placeholder="仓储采购说明，选填" />
								</td>
							</tr>
							</c:if>
							
							</c:if>
							</c:forEach>
						</c:if>
						<c:if test="${costItemCount>6 }">
						<tr id="lastTr">
							<td colspan="3">
								共计 ${costItemCount } 条，手机版显示上限6条，更多详细内容请至PC端查看
							</td>
						</tr>
						</c:if>
					</tbody>
				</table>
				<!-- 科目内容 end -->
				
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
