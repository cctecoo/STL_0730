<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
	<head>
		<base href="<%=basePath%>">
		<meta charset="utf-8" />
		<title></title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/css/chosen.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<!--提示框-->
    	<link rel="stylesheet" href="static/assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style" />
    	<link rel="stylesheet" href="static/assets/css/font-awesome.css" />
		<style>
			input[type="checkbox"],input[type="radio"] {
				opacity:1 ;
				position: static;
				height:25px;
				margin-bottom:10px;
			}
			
			#zhongxin td{height:40px;}
			#zhongxin td label{text-align:right; margin-right:10px;}
			#zx td label{text-align:left; margin-right:0px;} 
		</style>
	</head>
	<body>
		<fmt:requestEncoding value="UTF-8" />
		<form action="unit/${msg}.do" name="unitForm" id="unitForm" method="post">
			<input type="hidden" name="flag" id="flag" value="${msg}"/>
			<input type="hidden" name="ID" id="id" value="${pd.ID }"/>
			<div id="zhongxin">
				<table style="width:90%; margin:10px auto">
					<tr>
						<td><label><span style="color:red">*</span>单位编码：</label></td>
						<td>
							<c:if test="${msg == 'save'}">
								<input type="text" name="UNIT_CODE" id="unit_code" value="${pd.UNIT_CODE }" 
									maxlength="32" placeholder="请输入单位编码"/>
							</c:if>
							<c:if test="${msg == 'edit'}">
								<input type="text" name="UNIT_CODE" id="unit_code" value="${pd.UNIT_CODE }" maxlength="32" readonly="readonly"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<td><label><span style="color:red">*</span>单位名称：</label></td>
						<td>
							<input type="text" name="UNIT_NAME" id="unit_name" value="${pd.UNIT_NAME }" 
								maxlength="32" placeholder="请输入名称" title="名称" />
						</td>
					</tr>
					<tr>
						<td><label><span style="color:red">*</span>单位类型：</label></td>
						<td>
							<select name="UNIT_TYPE_NAME">
								<option value="金额" <c:if test="${pd.UNIT_TYPE_NAME=='金额' }">selected</c:if>>金额</option>
								<option value="重量" <c:if test="${pd.UNIT_TYPE_NAME=='重量' }">selected</c:if>>重量</option>
							</select>
						</td>
					</tr>
					<tr>
						<td><label><span style="color:red">*</span>基准单位：</label></td>
						<td>
							<select id="baseUnitCode" name="BASE_UNIT_CODE" onchange="resetBaseCount();">
								<option value="">请选择</option>
                                <c:forEach items="${unitList}" var="baseUnit">
                                    <option value="${baseUnit.UNIT_CODE }" 
                                    	<c:if test="${baseUnit.UNIT_CODE == pd.BASE_UNIT_CODE }">selected</c:if> 
                                    >${baseUnit.UNIT_NAME}</option>
                                </c:forEach>
	                        </select>
						</td>
					</tr>
					<tr>
						<td><label><span style="color:red">*</span>转为基准的数量：</label></td>
						<td>
							<input type="text" name="CONVERT_BASE_COUNT" id="convertBaseCount" value="${pd.CONVERT_BASE_COUNT}" />
						</td>
					</tr>
					<tr>
						<td><label>备注：</label></td>
						<td>
							<input type="text" name="DESCP" id="descp" value="${pd.DESCP}" 
								maxlength="32" placeholder="请输入指标描述" title="指标描述" />
						</td>
					</tr>
			        <tr>
				    	<td colspan="2" style="text-align: center;">
							<a class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp;
							<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<!-- 引入 -->
		<script src='static/js/jquery-1.9.1.min.js'></script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<script type="text/javascript">
			$(top.changeui());
			
			//改变基准单位时，需要重置基准数量
			function resetBaseCount(){
				if($("#baseUnitCode").val()=='${pd.UNIT_CODE }'){
					$("#convertBaseCount").val(1);
					$("#convertBaseCount").attr("readonly", "readonly");
				}else{
					$("#convertBaseCount").val(0);
					$("#convertBaseCount").removeAttr("readonly");
				}
			}
			
			//保存
			function save(){
				if($("#unit_code").val().trim() == ""){
					$("#unit_code").tips({
						side:3,
			            msg:'请输入指标编码',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#unit_code").focus();
					return false;
				}
				
				if($("#unit_name").val().trim() == ""){
					$("#unit_name").tips({
						side:3,
			            msg:'请输入指标名称',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#unit_name").focus();
					return false;
				}
				//检查是否选择基准单位
				if($("#baseUnitCode").val() == ""){
					$("#baseUnitCode").tips({
						side:3,
			            msg:'请选择基准单位',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#baseUnitCode").focus();
					return false;
				}else{
					var regx = /^[0-9]{1,10}(.[0-9]{1,4})?$/;
					var converCount = $("#convertBaseCount").val();
					if(converCount == "" || converCount == "0" || !regx.test(converCount)){
						$("#convertBaseCount").tips({
							side:3,
				            msg:'请填写数字(可包含最多四位小数)',
				            bg:'#AE81FF',
				            time:2
				        });
						$("#convertBaseCount").focus();
						return false;
					}
				}
				
				if($("#id").val() == null || $("#id").val() == ""){	
					var a = 0;
				}else{
					var a = $("#id").val();
				}
				var url = "<%=basePath%>/unit/checkIndexCode.do?unit_code=" +$("#unit_code").val()+ "&msg=" +$("#flag").val()+ "&id=" + a;
				$.get(url, function(data){
					if(data == "true"){
						$("#unitForm").submit();
						$("#zhongxin").hide();						            		            
					}else{
			            top.Dialog.alert("该编号已存在！");
			            top.Dialog.close();
	                }
				},"text");
			}
		</script>
	</body>
</html>