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
	
	<input type="hidden" name="empDeptArea" value="COT" /><!-- 标识表单类型，用于获取编码 -->
	
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
			    		<td>采购单类型</td>
			    		<td>${xiangMuLeiXing}</td>
			    	</tr>
			    	
			    	<tr><td colspan="2">供应商及合同信息</td></tr>
			    	<tr>
			    		<td>供应商名称</td>
			    		<td>${xuanDingGongYingShang }</td>
			    	</tr>
			    	<tr>
			    		<td>供应类型</td>
			    		<td>${gongYingLeiXing}，新供应商:${xinGongYingShang}</td>
			    	</tr>
			    	<tr>
			    		<td>订单总金额(元)</td>
			    		<td>${shiJiFuKuanJinE }</td>
			    	</tr>
			    	<tr>
			    		<td>币种</td>
			    		<td>${biZhong}</td>
			    	</tr>
			    	<c:if test="${not empty waiBiJinE && waiBiJinE!=0 }">
			    	<tr>
			    		<td>外币金额</td>
			    		<td>${waiBiJinE}</td>
			    	</tr>
			    	</c:if>
			    	<tr>
			    		<td>合同编号</td>
			    		<td>${heTongBianHao}</td>
			    	</tr>
			    	<tr>
			    		<td>合同名称</td>
			    		<td>${heTongMing}</td>
			    	</tr>
			    	<tr>
			    		<td colspan="2">收款人:${bankAccountName }</td>
			    	</tr>
			    	<tr>
			    		<td colspan="2">开户行:${bankName }</td>
			    	</tr>
			    	<tr>
			    		<td colspan="2">银行账号：${bankAccount }</td>
			    	</tr>
			    	<tr>
			    		<td>购买方</td>
			    		<td>${gouMaiFang}</td>
			    	</tr>
			    	
			    	<!-- 主体内容 end -->
			    </table>
			    
				<div>付款信息</div>
				<table id="itemTable" class="table table-bordered" style="margin:0">
					<tbody>
						<c:if test="${costItemCount>0 }">
							<c:forEach begin="0" end="${costItemCount-1 }" varStatus="vs">
							<tr class="rowItem_${vs.index+1 }">
								<td rowspan="2"style="width:35px; padding:0">${vs.index+1}</td>
								<td colspan="2">${heTongFuKuanRi_list[vs.index] }，付款金额:${heTongFuKuanJinE_list[vs.index] }</td>
							</tr>
							<tr class="rowItem_${vs.index+1 }">
								<td colspan="2">
									付款类型:${fuKuanLeiXing_list[vs.index] }，付款方式:${fuKuanFangShi_list[vs.index] }
									<c:if test="${not empty fuKuanBeiZhu_list[vs.index] }">，说明:${fuKuanBeiZhu_list[vs.index] }</c:if>
								</td>
							</tr>
							</c:forEach>
						</c:if>
						
					</tbody>
				</table>
				<!-- 科目内容 end -->
				
				<!-- 采购单内容 start -->
				<div id="purchaseItemTable"></div>
				<!-- 采购单 end -->
				
		    </div><!-- formDetail end -->
		    
		<%@include file="app_formFoot.jsp" %>
		<%@include file="app_formJs.jsp" %>	
	
		<div style="margin-top:90px;">
			<%@include file="../footer.jsp"%>
		</div>
		
		<script type="text/javascript">
		
			//查找对应的采购子项详情
			findPurchaseFormData('${selectedFormWorkNos}', '${selectedIndexs}', '${work.ID}');
			//查询选择的采购单数据
			function findPurchaseFormData(purchaseWorkNoStr, selectedIndexs, workId){
				if(!purchaseWorkNoStr){
					return;
				}
				if('' != purchaseWorkNoStr){
					//查询后台数据
					$.ajax({
						type: 'post',
						url: '<%=basePath%>app_task/findPurchaseFormData.do',
						data: {
							workId : workId, 
							purchaseWorkNoStr: purchaseWorkNoStr,
							purchaseItemIndexStr: selectedIndexs
						},
						success: function(data){
							if(data.msg!='success'){
								alert('查询采购单数据出错，请联系管理员');
								return;
							}
							//拼接查询到的数据
							var html = appendRelateWorkServiceItemStr(data, workId);
							$("#purchaseItemTable").append(html);
							setInputReadOrEdit();//设置是否可修改
						}
					});
				}
			}
			
			//采购-服务类表单，返回拼接的行
			function appendRelateWorkServiceItemStr(data, workId){
				var list= data.list, workItemList= data.workItemList, 
				html = '', contractPage = data.contractPage;
				var isDevice = contractPage.indexOf('purchasingDevice')==0,
				isFittings = contractPage.indexOf('purchasingFittings')==0,
				isWrapper = contractPage.indexOf('purchasingWrapper')==0,
				isService = contractPage.indexOf('purchasingService')==0;
				
				//循环采购需求单
				for(var i=0; i<list.length; i++){
					var work = list[i], relateWorkId = work.ID;
					html += '<table class="table table-bordered" style="margin:0;">'
						+ '<tr><td colspan="3">已加入-采购申请' + (i+1) + '</td></tr>';
						
					//拼接采购单信息
					html += '<tr><td colspan="3">[' + work.WORK_NO + ']' + work.TASK_NAME + '</td></tr>';
					html += '<tr><td colspan="3">'
						+ '申请:'+ work.CREATE_DATE + '，'+ work.CREATE_EMP_NAME + '，' + work.suoZaiBuMen 
						+ '，申请单类型:' + work.xiangMuLeiXing + '，采购类型:' + work.caiGouLeiXing  
						+ '</td></tr>';
					//拼接采购子项
					for(var j=0; j<work.itemCount; j++){
						var vs= {index: j}, 
						rowClassStr = 'rowItem' + relateWorkId  + '_' + (vs.index+1),
						caiGouRowNum = 0,//采购信息的合并行数量
						spcialStr = '',//采购项特殊字段 
						yuanWuPinStr = '',//设备或 配件的原物品信息
						firstRowStr = '',
						secondRowStr = '',
						cangChuStr = '';
						if(isDevice || isFittings || isWrapper){//设备,配件,原辅料及包材
							if(isDevice){//设备
								caiGouRowNum = 12;//采购信息的合并行数目
								spcialStr = '图号:' + work.tuHao_list[vs.index]
									+ '，设备位号:' + work.sheBeiWeiHao_list[vs.index]
									+ '，净重/公斤:' + work.jingZhong_list[vs.index]
									+ '，技术参数:' + work.jiShuCanShu_list[vs.index];
							}else if(isFittings){//配件
								caiGouRowNum = 12;
								spcialStr = '紧急程度:' + work.jinJiDu_list[vs.index];
							}else if(isWrapper){//包材
								caiGouRowNum = 10;
								spcialStr = '使用方:' + work.shiyongFang_list[vs.index]
									+ '，用于产品:' + work.yongYuChanPin_list[vs.index];
							}
							//设备,配件 拼接原物品信息
							if(isDevice || isFittings){
								if(work.yuanGouMaiRiQi_list[vs.index]){
									caiGouRowNum++;
									yuanWuPinStr = '<tr class="' + rowClassStr + '">'
										+ '<td>原购买日期</td>'
										+ '<td>' + work.yuanGouMaiRiQi_list[vs.index] + '</td>'
										+ '</tr>';
									caiGouRowNum++;
									yuanWuPinStr += '<tr class="' + rowClassStr + '">'
										+ '<td>原品牌</td>'
										+ '<td>'+ work.yuanPinPai_list[vs.index]+ '</td>'
										+ '</tr>';
									if(work.shiJiShiYongTianShu_list){
										caiGouRowNum++;
										yuanWuPinStr += '<tr class="' + rowClassStr + '">'
											+ '<td colspan="2">'
											+'实际使用天数:' + work.shiJiShiYongTianShu_list[vs.index]
											+ '，正常使用天数:' + work.zhengChangShiYongTianShu_list[vs.index]
											+'</td></tr>';
									}
								}
								yuanWuPinStr +=  '<tr class="' + rowClassStr + '">'
									+ '<td>新增/更换</td>'
									+ '<td>' + work.xinZengShebei_list[vs.index] + '</td>'
									+ '</tr>';
								yuanWuPinStr += '<tr class="' + rowClassStr + '">'
									+ '<td>要求到货日期</td>'
									+ '<td>' + work.yaoQiuDaoHuo_list[vs.index] + '</td>'
									+ '</tr>';
								
							}
							//拼接采购信息行
							firstRowStr = '<tr class="' + rowClassStr + '">'
								+ '<td style="width:35px;">序号</td>'
								+ '<td style="width:80px">BOM类别</td>'
								+ '<td>' + work.bomFenLei_list[vs.index] + '</td>'
								+ '</tr>';
							secondRowStr = '<tr class="' + rowClassStr + '">'
								+ '<td colspan="2">采购项:' + work.caiGouZiXiangMing_list[vs.index] + '</td>'
								+ '</tr>'
								+ '<tr><td colspan="2">' + spcialStr + '</td></tr>'
								+ '<tr class="' + rowClassStr + '">';
							//拼接品牌信息
							if(work.bomBrandName_list[vs.index]){//BOM限定品牌
                                secondRowStr += '<td>BOM限定品牌</td><td>' + work.bomBrandName_list[vs.index];
							}else{
                                secondRowStr += '<td>品牌建议</td><td>' + work.xinPinPaiOne_list[vs.index];
                                if(work.xinPinPaiTwo_list[vs.index]){//建议品牌
                                    secondRowStr += '，' + work.xinPinPaiTwo_list[vs.index]
										+ '，' + work.xinPinPaiThree_list[vs.index];
                                }
							}
							secondRowStr += '</td></tr>';
							//拼接说明
							if(work.shuoMing_list[vs.index]){
								caiGouRowNum++;
								secondRowStr += '<tr class="' + rowClassStr + '">'
									+ '<td colspan="2">需求说明:' + work.shuoMing_list[vs.index] + '</td>';
									+ '</tr>';
							}
							cangChuStr = '<tr class="' + rowClassStr + '">'
								+ '<td>核对采购量</td>'
								+ '<td>' + work.storePurchaseAmount_list[vs.index] + '</td>'
								+ '</tr>'
								+ '<tr class="' + rowClassStr + '">'
								+ '<td>可用库存</td>'
								+ '<td>' + work.storeRestAmount_list[vs.index] + '</td>'
								+ '</tr>';
							if(work.storePurchaseShuoMing_list[vs.index]){
								caiGouRowNum++;
								html += '<tr class="' + rowClassStr + '">'
									+ '<td>仓储说明</td>'
									+ '<td>'+ work.storePurchaseShuoMing_list[vs.index] + '</td>'
									+ '</tr>';
							}
							//确定行数后，再拼接
							secondRowStr = '<tr class="' + rowClassStr + '">'
								+ '<td rowspan="'+caiGouRowNum+'">' + work.addedOrderNum_list[vs.index] + '</td>'
								+ '<td>需求量</td>' 
								+ '<td>' + work.shuLiang_list[vs.index] + work.danWei_list[vs.index] + '</td>'
								+ '</tr>' 
								+ secondRowStr;
								
							var yuSuanColor = '';
							if(work.tiJiaoShengYuJinE_list[vs.index]<0){
								yuSuanColor = ' style="color:red" ';//剩余预算小于0，红色显示
							}
							
						}else if(isService){//服务
							caiGouRowNum = 6;
							//拼接采购信息行
							firstRowStr = '<tr class="' + rowClassStr + '">'
								+ '<td style="width:35px;">序号</td>'
								+ '<td style="width:100px">服务项目名称</td>'
								+ '<td>' + work.caiGouZiXiangMing_list[vs.index] + '</td>'
								+ '</tr>';
							//拼接指定供应商信息
							if(work.xinPinPaiOne_list[vs.index]){
								caiGouRowNum++;
								yuanWuPinStr += '<tr class="' + rowClassStr + '">'
									+ '<td>是否为新供应商</td><td>' + work.xinGongYingShang_list[vs.index] + '</td>'
									+ '</tr>';
								caiGouRowNum++;
								yuanWuPinStr +=  '<tr class="' + rowClassStr + '">'
									+ '<td>指定供应商</td>'
									+ '<td>'+ work.xinPinPaiOne_list[vs.index] + '</td>'
									+ '</tr>';
							}
							if(work.xinPinPaiTwo_list[vs.index]){//建议品牌
								caiGouRowNum++;
								yuanWuPinStr += '<tr class="' + rowClassStr + '">'
									+ '<td>建议供应商</td>'
									+ '<td>'+ work.xinPinPaiTwo_list[vs.index] + '，'+ work.xinPinPaiThree_list[vs.index] + '</td>'
									+ '</tr>';
							}
							if(work.shuoMing_list[vs.index]){//需求说明
								caiGouRowNum++;
								yuanWuPinStr += '<tr class="' + rowClassStr + '">' 
									+ '<td colspan="2">需求说明:' + work.shuoMing_list[vs.index] + '</td>'
									+ '</tr>';
							}
							secondRowStr = '<tr class="' + rowClassStr + '">'
								+ '<td rowspan="'+caiGouRowNum+'">' + work.addedOrderNum_list[vs.index] + '</td>'
								+ '<td>服务周期</td>'
								+ '<td>'+ work.jiHuaKaiShi_list[vs.index] + '至' + work.jiHuaJieShu_list[vs.index] + '</td>'
								+ '</tr>'
								+ '<tr class="' + rowClassStr + '">'
								+ '<td colspan="2">具体服务事项:' + work.juTiFuWuShiXiang_list[vs.index] + '</td>'
								+ '</tr>';
						}
						var yuSuanStr = '<tr class="' + rowClassStr + '">'
							+ '<td>预算科目</td>'
							+ '<td>' + work.keMu_list[vs.index] + '</td>'
							+ '</tr>'
							+ '<tr class="' + rowClassStr + '">'
							+ '<td>成本中心</td>'
							+ '<td>' + work.costDept_list[vs.index] + '</td>'
							+ '</tr>';
						yuSuanStr += '<tr class="' + rowClassStr + '">'
							+ '<td>预计金额</td>'
							+ '<td>' + work.hanShuiJinE_list[vs.index] + '</td>'
							+ '</tr>'
							+ '<tr class="' + rowClassStr + '">'
							+ '<td colspan="2">'
							+ '预算总额:' + work.budget_list[vs.index] 
							//+ '，提交前：' + work.budgetSurplus_list[vs.index]
							+ '，本次提交后剩余:<span '+ yuSuanColor + '>' 
							+ work.tiJiaoShengYuJinE_list[vs.index] + '</span></td>'
							+ '</tr>';
					
						//拼接需求行
						html += firstRowStr + secondRowStr + yuanWuPinStr + yuSuanStr + cangChuStr;
						
						//比价信息
						var itemIndexStr = 'rowItem' + relateWorkId  + '_' + work.addedOrderNum_list[vs.index];
						var caiGouHanShui = '';
						if(work.caiGouHanShui_list[vs.index]=='含税'){
							caiGouHanShui = 'checked';
						}
						//拼接比价行
						html += '<tr  class="' + rowClassStr + '">';
						var biJiaStr = '', biJiaRowNum = 5;
						biJiaStr += '<td>'
							+ '<input class="stepLevel_1 optionalInput" type="checkBox" name="caiGouHanShui' + itemIndexStr + '" '
							+ ' value="含税" ' + caiGouHanShui + ' style="width:20px"/>含税'
							+ '</td>'
							+ '<td>采购数量:' + work.caiGouShuLiang_list[vs.index] + '</td>'
							+ '</tr>';
						biJiaStr += '<tr  class="' + rowClassStr + '">'
							+ '<td>采购单价(元)</td>'
							+ '<td>' + work.caiGouDanJia_list[vs.index] + '</td>'
							+ '</tr>'
							+ '<tr  class="' + rowClassStr + '">'
							+ '<td>其他费用</td>'
							+ '<td>' + work.caiGouQiTaFeiYong_list[vs.index] + '</td>'
							+ '</tr>'
							+ '<tr  class="' + rowClassStr + '">'
							+ '<td>本项总价</td>'
							+ '<td>' + work.caiGouZongJia_list[vs.index] + '</td>'
							+ '</tr>';
						biJiaStr += '<tr  class="' + rowClassStr + '">'
							+ '<td>供应商报价</td>'
							+ '<td>' + work.caiGouShangBaoJiaOne_list[vs.index] + '，' + work.caiGouShangOne_list[vs.index] + '</td>'
							+ '</tr>';
						if(work.caiGouShangTwo_list[vs.index]){
							biJiaRowNum++;
							biJiaStr += '<tr  class="' + rowClassStr + '">'
								+ '<td>报价2</td>'
								+ '<td>' + work.caiGouShangBaoJiaTwo_list[vs.index] + '，' + work.caiGouShangTwo_list[vs.index] + '</td>'
								+ '</tr>';
						}
						if(work.caiGouShangThree_list[vs.index]){
							biJiaRowNum++;
							biJiaStr += '<tr  class="' + rowClassStr + '">'
								+ '<td>报价3</td>'
								+ '<td>' + work.caiGouShangBaoJiaThree_list[vs.index] + '，' + work.caiGouShangThree_list[vs.index] + '</td>'
								+ '</tr>';
						}	
						if(work.caiGouShangFour_list[vs.index]){
							biJiaRowNum++;
							biJiaStr += '<tr  class="' + rowClassStr + '">'
								+ '<td>报价4</td>'
								+ '<td>' + work.caiGouShangBaoJiaFour_list[vs.index] + '，' + work.caiGouShangFour_list[vs.index] + '</td>'
								+ '</tr>';
						}
						if(work.caiGouShuoMingOne_list[vs.index]){
							biJiaRowNum++;
							biJiaStr += '<tr  class="' + rowClassStr + '">'
								+ '<td>比价说明</td>'
								+ '<td>' + work.caiGouShuoMingOne_list[vs.index] + '</td>'
								+ '</tr>';
						}
						
						//最后拼接比价行
						html += '<td rowspan="'+biJiaRowNum+'">采购比价</td>' + biJiaStr;
						
					}
					html +='</table>';
					
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
