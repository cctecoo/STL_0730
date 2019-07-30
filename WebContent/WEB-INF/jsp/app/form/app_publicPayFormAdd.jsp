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
	
				<!-- 表格内容 -->
			    <table class="table table-bordered" style="margin-bottom:2px; ">
			    	
			    	<!-- 主体内容 start -->
			    	<tr>
			    		<td style="width:85px;">申请人</td>
			    		<td>${work.CREATE_EMP_NAME }</td>
			    	</tr>
			    	<tr>
			    		<td>申请日期</td>
			    		<td >${work.CREATE_DATE }</td>
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
			    		<td>供应商</td>
			    		<td>${gongYingShang }</td>
			    	</tr>
			    	
			    	<tr>
			    		<td>开户行</td>
			    		<td>${bankName }</td>
			    	</tr>
			    	<tr>
			    		<td>收款人</td>
			    		<td>${bankAccountName }</td>
			    	</tr>
			    	<tr>
			    		<td>账号</td>
			    		<td>${bankAccount }</td>
			    	</tr>
			    	
			    	<tr>
			    		<td>付款日期</td>
			    		<td>${fuKuanRiQi }</td>
			    	</tr>
			    	<tr>
			    		<td>付款方式</td>
			    		<td >${fuKuanFangShi}</td>
			    	</tr>
			    	<tr>
			    		<td>冲销类型</td>
			    		<td>${ChongXiaoLeiXing}</td>
			    	</tr>
			    	<tr>
			    		<td>冲销金额</td>
			    		<td>${chongXiaoJinE }</td>
			    	</tr>
			    	
			    	<tr>
			    		<td>实际付款</td>
			    		<td>${shiJiFuKuanJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>报销金额</td>
			    		<td>${baoXiaoJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>境内/境外</td>
			    		<td>${JingNei}, 币种:${biZhong}</td>
					</tr>
					<tr>
						<td>外币汇率</td>
			    		<td>${huiLv }</td>
			    	</tr>
			    	<tr>
			    		<td>外币金额</td>
			    		<td>${waiBiJinE}</td>
			    	</tr>
			    	
			    	<tr>
			    		<td>项目类型</td>
			    		<td>${xiangMuLeiXing}</td>
			    	</tr>
			    	<tr>
			    		<td>项目号</td>
			    		<td>${xiangMuHao }</td>
			    	</tr>
			    	<tr>
			    		<td>项目名称</td>
			    		<td>${xiangMuMing }</td>
			    	</tr>
			    	
			    	<tr>
			    		<td>合同号</td>
			    		<td>${heTongHao }</td>
			    	</tr>
			    	<tr>
			    		<td>约定到货日</td>
			    		<td>${daoHuoRiQi }</td>
			    	</tr>
			    	<tr>
			    		<td>合同名称</td>
			    		<td>${heTongMing }</td>
			    	</tr>
			    	
			    	<tr>
			    		<td>募投项目</td>
			    		<td>${shiFouMuTou}</td>
			    	</tr>
			    	<tr>
			    		<td>单据总数</td>
			    		<td>${danJuZongShu }</td>
			    	</tr>
			    	<c:if test="${not empty heTongJinE}">
				    	<tr>
					   		<td>合同总金额</td>
					   		<td>${heTongJinE }</td>
						</tr>
						<tr>
				    		<td>本次付款金额</td>
					   		<td>${benCiFuKuan }</td>
				    	</tr>
				    	<tr>
					   		<td>约定付款比例</td>
					   		<td>${yueDingFuKuanBiLi }</td>
				    	</tr>
				    	<tr>
					   		<td>约定付款方式</td>
					   		<td>${yueDingFuKuanFangShi }</td>
					   	</tr>
					   	<tr>
				   			<td colspan="2">付款金额与合同金额不一致原因:${buYiZhiYuanYin }</td>
					   	</tr>
					   	<tr>
					   		<td>约定付款条件</td>
					   		<td>${YueDingFuKuanShiJian }</td>
				    	</tr>
				    	<tr>
					   		<td>付款起算日</td>
					   		<td>${fuKuanQiSuanRi }</td>
					   	</tr>
					   	<tr>
					   		<td>符合付款条件</td>
					   		<td>${fuHeFuKuan }</td>
				    	</tr>
				    	<tr>
					   		<td>到货入库时间</td>
					   		<td>${ruKuRiQi }</td>
				    	</tr>
				    	<tr>
				    		<td>到票时间</td>
				    		<td>${daoPiaoRiQi }</td>
					   	</tr>
			    	</c:if>
			    	<tr>
			    		<td>用途/事由</td>
			    		<td>${shuoMing }</td>
			    	</tr>
			    	<tr>
			    		<td>相关流程</td>
			    		<td>
			    			<c:forEach items="${relateFormList }" var="item" varStatus="vs" >
			    				<a class="relateFormEle" onclick="showDetail(${item.workId });" style="cursor:pointer">${item.workName }</a>
			    			</c:forEach>
			    			<c:forEach items="${relateFlowList }" var="item" varStatus="vs" >
			    				<a class="relateFlowEle" style="cursor:pointer">${item.flowName }</a>
			    			</c:forEach>
			    		</td>
			    	</tr>
			    	
			    	<!-- 主体内容 end -->
			    	
			    </table>
			    
			    
				<table id="itemTable" class="table table-bordered"> 
					<thead>
						<th style="width:35px; padding:0">序号</th>
						<th style="width:35px; padding:0">单据</th>
						<th style="">科目/成本中心</th>
					</thead>
					<tbody>
						<c:if test="${costItemCount>0 }">
							<c:forEach begin="0" end="${costItemCount-1 }" varStatus="vs">
							<tr class="addedRow">
								<td>${vs.index+1}</td>
								<td>${danJuZhangShu_list[vs.index]}</td>
								<td>
									${keMu_list[vs.index]} [${costDept_list[vs.index] }]
									, 预算:${budget_list[vs.index]}
									, 本次提交后剩余:<span 
									<c:if test="${tiJiaoShengYuJinE_list[vs.index]<'0' }">style="color:red"</c:if>
										>${tiJiaoShengYuJinE_list[vs.index]}</span>
									, 无税:${wuShuiJinE_list[vs.index]}, 税金:${shuiJin_list[vs.index]}
									, 冲销:${chongXiaoJinE_list[vs.index]}, 含税:${hanShuiJinE_list[vs.index]}
									, 说明:${shuoMing_list[vs.index]}
								</td>
							</tr>
							</c:forEach>
						</c:if>
						
						<tr id="lastTr">
							<td>合计</td>
							<td>${sumDanJu }</span></td>
							<td>
								无税:${sumWuShuiJinE }, 税金:${sumShuiJin }, 冲销:${sumChongXiaoJinE }, 含税:${sumHanShuiJinE }
							</td>
						</tr>
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
