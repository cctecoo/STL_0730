<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

				<!-- 表格内容 -->
			    <table class="table table-bordered" style="margin-bottom:2px; ">
			    	
			    	<!-- 主体内容 start -->
			    	<tr>
			    		<td style="width:65px;">申请人</td>
			    		<td style="width:90px;">${work.CREATE_EMP_NAME }</td>
			    		<td style="width:65px;">申请日期</td>
			    		<td >${work.CREATE_DATE }</td>
			    	</tr>
			    	<tr>
			    		<td >所属部门</td>
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
			    		<td>开户行</td>
			    		<td colspan="3">${bankName }</td>
			    	</tr>
			    	<tr>
			    		<td>收款人</td>
			    		<td colspan="3">${bankAccountName }</td>
			    	</tr>
			    	<tr>
			    		<td>银行帐号</td>
			    		<td colspan="3">${bankAccount }</td>
			    	</tr>
			    	<tr>
			    		<td>冲销类型</td>
			    		<td>${ChongXiaoLeiXing}</td>
			    		<td>冲销金额</td>
			    		<td>${chongXiaoJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>实际付款</td>
			    		<td>${shiJiFuKuanJinE }</td>
			    		<td>报销金额</td>
			    		<td>${baoXiaoJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>付款方式</td>
			    		<td>${fuKuanFangShi}</td>
			    		<td>境内/外</td>
			    		<td>${JingNei }</td>
			    	</tr>
			    	<tr id="moneyTr">
			    		<td>币种</td>
			    		<td colspan="3">${biZhong }, 外币金额:${waiBiJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>募投项目</td>
			    		<td>${shiFouMuTou }</td>
			    		<td>单据总数</td>
			    		<td>${danJuZongShu }</td>
			    	</tr>
			    	<tr>
			    		<td>用途/事由</td>
			    		<td colspan="3">${shuoMing }</td>
			    	</tr>
			    	<tr>
			    		<td>相关流程</td>
			    		<td colspan="3">
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
			    
			    <!-- 科目内容 start -->
				
				<table id="itemTable" class="table table-bordered"> 
					<thead>
						<th style="width:35px; padding:0">序号</th>
						<th style="width:35px; padding:0">单据</th>
						<th style="">科目</th>
					</thead>
					<tbody>
						<c:if test="${costItemCount>0 }">
							<c:forEach begin="0" end="${costItemCount-1 }" varStatus="vs">
							<tr class="addedRow">
								<td>${vs.index+1}</td>
								<td>${danJuZhangShu_list[vs.index]}</td>
								<td>
									${keMu_list[vs.index]}
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
							<td>${sumDanJu }</td>
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
