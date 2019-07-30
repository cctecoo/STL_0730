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
			    		<td>关联付款单</td>
			    		<td>
			    			<c:forEach items="${relateFormList }" var="item" varStatus="vs" >
			    				<a class="relateFormEle" onclick="showDetail(${item.workId });" style="cursor:pointer">${item.workName }</a>
			    			</c:forEach>
			    		</td>
			    	</tr>
			    	<tr>
			    		<td>供应商全称</td>
			    		<td>${bankAccountName }</td>
			    	</tr>
			    	<tr>
			    		<td>付款方式</td>
			    		<td>${fuKuanFangShi2 }</td>
			    	</tr>
			    	<tr>
			    		<td>开户行</td>
			    		<td>${bankName }</td>
			    	</tr>
			    	<tr>
			    		<td>银行账号</td>
			    		<td>${bankAccount }</td>
			    	</tr>
			    	<tr>
			    		<td>合计付款金额</td>
			    		<td>${shiJiFuKuanJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>合计金额大写</td>
			    		<td>${fuKuanDaXie }</td>
			    	</tr>
			    	<tr>
			    		<td>备注</td>
			    		<td>${qiTaShuoMing }</td>
			    	</tr>
			    	<tr>
			    		<td>用途/事由</td>
			    		<td>${shuoMing }</td>
			    	</tr>
			    	
			    	<!-- 主体内容 end -->
			    </table>
			    
			    <div>付款单内容</div>
				<table id="paymentItemTable" class="table table-bordered">
				
				</table>
			    
		    </div><!-- formDetail end -->
		    
		<%@include file="app_formFoot.jsp" %>
		<%@include file="app_formJs.jsp" %>	
	
		<div style="margin-top:90px;">
			<%@include file="../footer.jsp"%>
		</div>
		
		<script type="text/javascript">
		
			//查询关联的付款单信息
			findPaymentForSameSupplier('${relatePaymentWorkNo}');
			//查询选择的表单数据
			function findPaymentForSameSupplier(formWorkNoStr){
				//关联的表单
				if('' != formWorkNoStr){
					//查询后台数据
					$.ajax({
						type: 'post',
						url: '<%=basePath%>app_task/findFormWorkInfoById.do',
						data: {searchType: 'purchasePaymentInfo', formWorkNoStr : formWorkNoStr},
						success: function(data){
							$("#selectedSameSupplier").val('false');
							if(data.msg=='notFind'){
								alert('选择的付款单不是同一供应商付款，请重新选择');
								return;
							}else if(data.msg!='success'){
								alert('查询数据出错，请联系管理员');
								return;
							}
							
							//拼接查询到的数据
							if(data.list.length>0){
								var html = appendPayitem(data.list);
								$("#paymentItemTable").empty();
								$("#paymentItemTable").append(html);
							}
						}
					});
				}
			}
			//拼接付款单信息
			function appendPayitem(list){
				var html = '';
				for(var i=0; i<list.length; i++){
					var work = list[i],
					vs= {index: i}, 
					rowClassStr = 'rowItem' + work.ID;
					
					html += '<tr class="' + rowClassStr + '">'
						+ '<td>付款单-' + (i+1) + '</td>'
						+ '<td>表单编号:' + work.WORK_NO + '，表单名称:' + work.TASK_NAME + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td style="width:80px">申请日期</td><td>' + work.CREATE_DATE + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>申请人</td><td>' + work.CREATE_EMP_NAME + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>申请部门</td><td>' + work.suoZaiBuMen + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>采购单类型</td><td>' + work.xiangMuLeiXing + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>采购合同</td>'
						+ '<td>';
					if(null != work.relateFormList && work.relateFormList.length>0){
						for(var j=0; j<work.relateFormList.length; j++){
							var item = work.relateFormList[j];
							html += '<a onclick="showDetail(' + item.workId + ');" style="cursor:pointer">'
							+ item.workName + '</a>';
						}
					}
					html += '</td></tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>合同编号</td><td>' + work.heTongBianHao + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>合同名称</td><td>' + work.heTongMing + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>合同总金额</td><td>' + work.heTongJinE + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>已付金额</td><td>' + work.yiFuJinE + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>未付金额</td><td>' + work.weiFuJinE + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>外币总金额</td><td>' + work.waiBiZongJinE + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>币种</td><td>' + work.biZhong + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>已到货金额</td><td>' + work.daoHuoJinE + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>本付款批次</td><td>第' + work.currentPayOrder + '次付款</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>本次外币金额</td><td>' + work.waiBiJinE + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>付款方式</td><td>' + work.fuKuanFangShi + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>申请付款金额</td><td class="shenQingFuKuan">' + work.shiJiFuKuanJinE + '</td>'
						+ '</tr>'
						+ '<tr class="' + rowClassStr + '">'
						+ '<td>金额大写</td><td colspan="3">' + work.fuKuanDaXie + '</td>'
						+ '</tr>'
						;
				}
				
				return html;
			}
		
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
