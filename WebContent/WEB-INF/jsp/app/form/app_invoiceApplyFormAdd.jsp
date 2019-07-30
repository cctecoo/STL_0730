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
	<title>开票申请单</title>
</head>	
<body>
	<%@include file="app_formHead.jsp" %>
	
	<input type="hidden" name="empDeptArea" value="INV" /><!-- 标识表单类型，用于获取编码 -->
	
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
						<td>申请类型</td>
						<td>${applyType }</td>
					</tr>

			    	<tr>
			    		<td>备注</td>
			    		<td>${shuoMing }</td>
			    	</tr>
			    	
			    	<!-- 主体内容 end -->
			    </table>
			    
				<div>明细</div>
				<table id="itemTable" class="table table-bordered">
					<tbody>
						<c:if test="${costItemCount>0 }">
							<c:forEach begin="0" end="${costItemCount-1 }" varStatus="vs">
								<c:if test="${vs.index<6 }">
									<tr class="rowItem_${vs.index+1 }">
										<td style="width:35px; padding:0" rowspan="3" >${vs.index+1}</td>
										<td style="width:80px;">销售性质</td>
										<td>${saleType_list[vs.index] }</td>
									</tr>
									<tr class="rowItem_${vs.index+1 }">
										<td>开票数量</td>
										<td>${billCount_list[vs.index] }</td>
									</tr>
									<tr class="rowItem_${vs.index+1 }">
										<td>说明</td>
										<td>${shuoMing_list[vs.index] }</td>
									</tr>
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
