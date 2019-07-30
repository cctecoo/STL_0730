<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<base href="<%=basePath%>">
		<meta charset="utf-8" />
		<title></title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/style.css" rel="stylesheet" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
	
		<style type="text/css">
			input{width:90%;}
			select{width:95%;}
			#zhongxin td{height:40px;}
			#zhongxin td label{text-align:right; margin-right:10px;}
			#zx td label{text-align:left; margin-right:0px;} 
		</style>
	</head>
	<body>
		<form action="supplier/saveOrUpdate.do" name="form" id="form" method="post">
			<div id="zhongxin">
				<c:if test="${not empty result.ID}">
					<input type="hidden" name="id" id="id" value="${result.ID }" />
				</c:if>
				
				<table id="formTable" style="margin: 10px auto; width:96%;">
					<tr>
						<td style="width:130px;"><label>供应商名称：</label></td>
						<td colspan="5">
							<input type="hidden" name="displayCode" id="displayCode" value="${result.DISLAY_CODE }" />
							<input type="text" name="name" id="name" style="width:96%;" value="${result.NAME}" />
						</td>
					</tr>
					<tr>
						<td><label>供应商级别：</label></td>
						<td>
							<select id="level" name="level">
								<option value="">请选择</option>
								<option value="新供应商" <c:if test="${result.LEVEL=='新供应商' }">selected</c:if> >新供应商</option>
								<option value="一般供应商" <c:if test="${result.LEVEL=='一般供应商' }">selected</c:if> >一般供应商</option>
								<option value="战略供应商" <c:if test="${result.LEVEL=='战略供应商' }">selected</c:if> >战略供应商</option>
							</select>
						</td>
						<td style="width:100px;"><label>供应商类别：</label></td>
						<td colspan="3">${result.SUPPLY_TYPE } ${result.SUPPLY_TYPE2 } ${result.SUPPLY_TYPE3 }</td>
					</tr>
					<tr>
						<td><label>统一社会信用代码：</label></td>
						<td colspan="3"><input type="text" name="creditCode" value="${result.CREDIT_CODE}"/></td>
						<td><label>企业法人：</label></td>
						<td><input type="text" name="companyLegalPerson" value="${result.COMPANY_LEGAL_PERSON}"/></td>
					</tr>
					<tr>
						<td><label>企业性质：</label></td>
						<td><input type="text" name="companyType" value="${result.COMPANY_TYPE}"/></td>
						<td><label>纳税人类别：</label></td>
						<td><input type="text" name="taxpayerGender" value="${result.TAXPAYER_GENDER}"/></td>
						<td><label>成立时间：</label></td>
						<td><input type="text" name="foundedTime" value="${result.FOUNDED_TIME}"/></td>
					</tr>
					<tr>
						<td><label>注册地址：</label></td>
						<td colspan="3"><input type="text" name="companyAddr" value="${result.COMPANY_ADDR}"/></td>
						<td><label>注册资本：</label></td>
						<td><input type="text" name="registeredCapital" value="${result.REGISTERED_CAPITAL}"/></td>
					</tr>
					<tr>
						<td><label>企业邮箱：</label></td>
						<td colspan="3"><input type="text" name="companyEmail" value="${result.COMPANY_EMAIL}"/></td>
						<td><label>是否上市：</label></td>
						<td><input type="text" name="onMarket" value="${result.ON_MARKET}"/></td>
					</tr>
					<tr>
						<td><label>公司网址：</label></td>
						<td colspan="3"><input type="text" name="companyWebsite" value="${result.COMPANY_WEBSITE}"/></td>
						<td><label>股票代码：</label></td>
						<td><input type="text" name="stockTicker" value="${result.STOCK_TICKER}"/></td>
					</tr>
					<tr>
						<td><label>邮政编码：</label></td>
						<td><input type="text" name="postCode" value="${result.POST_CODE}"/></td>
						<td><label>电话：</label></td>
						<td><input type="text" name="companyPhone" value="${result.COMPANY_PHONE}"/></td>
						<td><label>传真：</label></td>
						<td><input type="text" name="faxNo" value="${result.FAX_NO}"/></td>
					</tr>
					<tr>
						<td><label>主要联系人：</label></td>
						<td><input type="text" name="contactName" value="${result.CONTACT_NAME}" /></td>
						<td><label>联系电话：</label></td>
						<td><input type="text" name="contactPhone" value="${result.CONTACT_PHONE}" /></td>
						<td><label>联系邮箱：</label></td>
						<td><input type="text" name="contactEmail" value="${result.CONTACT_EMAIL}"/></td>
					</tr>
					<tr>
						<td><label>银行账户：</label></td>
						<td colspan="3">
							<input type="text" name="bankAccountName" id="bankAccountName" value="${result.BANK_ACCOUNT_NAME}" />
						</td>
						<td><label>占地面积：</label></td>
						<td><input type="text" name="companyOfficeArea" value="${result.COMPANY_OFFICE_AREA}"/></td>
					</tr>
					<tr>
						<td><label>银行账号：</label></td>
						<td colspan="3">
							<input type="text" name="bankAccountNo" id="bankAccountNo" value="${result.BANK_ACCOUNT_NO}" />
						</td>
						<td><label>公司总人数：</label></td>
						<td>
							<input type="text" name="companyPersonCount" value="${result.COMPANY_PERSON_COUNT}" />
						</td>
					</tr>
					<tr>
						<td><label>开户银行：</label></td>
						<td colspan="3">
							<input type="text" name="bankName" id="bankName" value="${result.BANK_NAME}" />
						</td>
						<td><label>银行资信：</label></td>
						<td>
							<input type="text" name="bankReference" value="${result.BANK_REFERENCE}" />
						</td>
					</tr>
					<tr>
						<td><label>付款方式：</label></td>
						<td colspan="3"><input type="text" name="paymentType" value="${result.PAYMENT_TYPE}"/></td>
						<td><label>账期：</label></td>
						<td><input type="text" name="paymentDays" value="${result.PAYMENT_DAYS}"/></td>
					</tr>
					<tr>
						<td><label>知识产权：</label></td>
						<td colspan="3"><input type="text" name="intellectualProperty" value="${result.INTELLECTUAL_PROPERTY}"/></td>
						<td><label>是否高新：</label></td>
						<td><input type="text" name="highTech" value="${result.HIGH_TECH}"/></td>
					</tr>
					<tr>
						<td><label>主要产品信息：</label></td>
						<td colspan="5">
							<input type="text" name="supplyProductName" value="${result.SUPPLY_PRODUCT_NAME}"/>
						</td>
					</tr>
					<tr>
						<td><label>主要客户：</label></td>
						<td colspan="5">
							<input type="text" name="mainCustomer" value="${result.MAIN_CUSTOMER}"/>
						</td>
					</tr>
					<tr>
						<td><label>公司荣誉：</label></td>
						<td colspan="5">
							<input type="text" name="companyHonor" value="${result.COMPANY_HONOR}"/>
						</td>
					</tr>
					<tr>
						<td><label>主要竞争对手：</label></td>
						<td colspan="5">
							<input type="text" name="mainCompetitor" value="${result.MAIN_COMPETITOR}"/>
						</td>
					</tr>
					<tr>
						<td><label>近两年的销售额：</label></td>
						<td colspan="5">
							<input type="text" name="recentSaleAmount" value="${result.RECENT_SALE_AMOUNT}"/>
						</td>
					</tr>
					<tr>
						<td><label>调查产品明细：</label></td>
						<td colspan="3">
							<input type="text" name="researchProductDetail" value="${result.RESEARCH_PRODUCT_DETAIL}"/>
						</td>
						<td><label>是否生产所供产品：</label></td>
						<td>
							<input type="text" name="produceSupplyProduct" value="${result.PRODUCE_SUPPLY_PRODUCT}"/>
						</td>
					</tr>
					<tr>
						<td><label>准入产品明细：</label></td>
						<td colspan="5">
							<input type="text" name="accessProductDetail" value="${result.ACCESS_PRODUCT_DETAIL}"/>
						</td>
					</tr>
					<tr>
						<td><label>供应本公司产品：</label></td>
						<td colspan="5">
							<!-- 从供应商和bom的关联表中，查询供应的bom列表及价格信息 -->

						</td>
					</tr>
					<tr>
						<td><label>供应产品信息：</label></td>
						<td colspan="5">
							<!-- 供应产品关联的附件列表 -->

						</td>
					</tr>
					<tr>
						<td><label>公司荣誉：</label></td>
						<td colspan="5">
							<!-- 公司荣誉关联的附件列表 -->

						</td>
					</tr>
					<tr>
						<td><label>经营/营业许可：</label></td>
						<td colspan="5">
							<!-- 经营/营业许可，关联的附件列表 -->

						</td>
					</tr>
					<tr>
						<td><label>行业资质：</label></td>
						<td colspan="5">
							<!-- 经营/营业许可，关联的附件列表 -->

						</td>
					</tr>
					<tr>
						<td><label>质量认证：</label></td>
						<td colspan="5">
							<!-- 经营/营业许可，关联的附件列表 -->

						</td>
					</tr>
					<tr>
						<td><label>其它附件：</label></td>
						<td colspan="5">
							<!-- 经营/营业许可，关联的附件列表 -->

						</td>
					</tr>

					<tr>
						<td><label>初次合作年份：</label></td>
						<td>
							<input type="text" name="firstCooperateYear" id="firstCooperateYear" value="${result.FIRST_COOPERATE_YEAR}"
								   placeholder="请填写年份，如2005" />
						</td>
						<td><label>所在国家：</label></td>
						<td>
							<input type="text" name="country" value="${result.COUNTRY}" />
						</td>
						<td><label>地区(省份)：</label></td>
						<td>
							<input class="optionalInput" type="text" name="province"  value="${result.PROVINCE}" 
								placeholder="选填"/>
						</td>
					</tr>

					<tr>
						<td><label>备注：</label></td>
						<td colspan="3">
							<textarea id="remark" name="remark" style="width:96%" rows="3" cols="2" maxlength="255" >${result.REMARK}</textarea>
						</td>
					</tr>
					<tr id="btnRow">
			    		<td colspan="4" style="text-align: center;">
							<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
							<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="static/js/jquery-form.js"></script>
		
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<script>
			$(function(){
				if('${viewPage==true}'=='true'){
					//查看页面
					$("#formTable input").attr("readonly", "readonly");
					$("#btnRow").hide();
				}
			})
		
			//显示提示信息
			function showMsgText(obj, msg){
				$(obj).tips({
					msg: msg,
					side:3,
					bg:'#AE81FF',
					time:2
				})
			}
	
			//检查数据格式
			function checkInput(){
				var isNotEmpty = true;//每次检查之前重置
				//开始检查input
				$("#form input, select").each(function(index, obj){
					if(isNotEmpty){
						//跳过非必填项的检查
						var name = $(obj).attr('name');
						//判断是否为非必填
						if($(obj).hasClass('optionalInput') || $(obj).attr('type')=='hidden'){
							isNotEmpty = true;
						}else{
							var val = $(obj).val();
							//判断是否为空
							if(null==val || ''==val){
								showMsgText(obj, '请输入内容！');
								isNotEmpty = false;
							}
						}
					}
				});
				
				//检查数字格式
				if(isNotEmpty){
					//暂时不检查初次合作年份
					/*
					//初次合作年份4位数字
					var firstCooperateYear = $("#firstCooperateYear");
					var patrn = /^[0-9]{4}$/;
					isNotEmpty = patrn.test($(firstCooperateYear).val());
					if(!isNotEmpty){
						showMsgText(firstCooperateYear, '请输入四位数字的年份！');
					}else{
						var bankAccountNo = $("#bankAccountNo");
						var val = $(bankAccountNo).val().replace(/\s+/g,"");//将会替换掉所有的空格
						patrn = /^[0-9]*$/;
						isNotEmpty = patrn.test(val);
						if(!isNotEmpty){
							showMsgText(bankAccountNo, '请输入正确的银行卡号！');
						}else{
							$(bankAccountNo).val(val);
						}
					}
					*/
				}
				
				return isNotEmpty;
			}
			
			//保存
			function save(){
				if(!checkInput()){
					return;
				}
				//提交后台
				$("#form").ajaxSubmit({
					success: function(data){
						//返回后，
						$("#loadDiv").hide();
						if("error"==data.msg){
							top.Dialog.alert("后台出错，请联系管理员");
							return;
						}else if("repeatData"==data.msg){
							top.Dialog.alert("名称重复，不能保存");
							return;
						}else{
							top.Dialog.close();
						}
					},
					error: function(){
						$("#loadDiv").hide();
						top.Dialog.alert("后台出错，请联系管理员");
					}
				});
			}
		</script>
	</body>
</html>