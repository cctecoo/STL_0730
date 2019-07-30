<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
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
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<link rel="stylesheet" href="static/assets/css/font-awesome.css" />
		<link rel="stylesheet" href="static/assets/css/ace.css" />
		<style>
			input[type="checkbox"], input[type="radio"] {
				opacity: 1;
				position: static;
				height: 25px;
				margin-bottom: 10px;
			}
			
			#zhongxin td {
				height: 40px;
			}
			
			#zhongxin td label {
				text-align: right;
				margin-right: 10px;
			}
			
			#zx td label {
				text-align: left;
				margin-right: 0px;
			}
		</style>
	</head>
	<body>
		<form action="bussinessIndex/${msg}.do" name="indexForm" id="indexForm" method="post">
			<input type="hidden" name="flag" id="flag" value="${msg}" /> 
			<input type="hidden" name="ID" id="id" value="${pd.ID }" />
			<div id="zhongxin">
				<table style="margin-left: 40px;">
					<tr>
						<td><label><span style="color: red">*</span>指标编码：</label></td>
						<td>
							<input type="text" name="INDEX_CODE" id="index_code"
								value="${pd.INDEX_CODE }" maxlength="100" <c:if test="${msg == 'edit'}">readonly="readonly"</c:if> placeholder="请输入指标编码" />
						</td>
					</tr>
					<tr>
						<td><label><span style="color: red">*</span>指标名称：</label></td>
						<td><input type="text" name="INDEX_NAME" id="index_name"
							value="${pd.INDEX_NAME }" maxlength="100" placeholder="请输入名称"
							title="名称" /></td>
					</tr>
					<tr>
						<td><label>备注：</label></td>
						<td><input type="text" name="DESCP" id="descp"
							value="${pd.DESCP}" maxlength="100" placeholder="请输入指标描述"
							title="指标描述" /></td>
					</tr>
					<tr>
						<td colspan="2" style="text-align: center;"><a
							class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp; <a
							class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<!-- 引入 -->
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript">
			$(top.changeui());
			
			//保存
			function save(){
				if($("#index_code").val().trim() == ""){
					$("#index_code").tips({
						side:3,
			            msg:'请输入指标编码',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#index_code").focus();
					return false;
				}
				if($("#index_name").val().trim() == ""){
					$("#index_name").tips({
						side:3,
			            msg:'请输入指标名称',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#index_name").focus();
					return false;
				}
				
				if($("#id").val() == null || $("#id").val() == ""){	
					var a = 0;
				}else{
					var a = $("#id").val();
				}
				var url = "<%=basePath%>/bussinessIndex/checkIndexCode.do?index_code="
						+ $("#index_code").val()
						+ "&msg="
						+ $("#flag").val()
						+ "&id=" + a;
				$.get(url, function(data) {
					if (data == "true") {
						$("#indexForm").submit();
						$("#zhongxin").hide();
					} else {
						top.Dialog.alert("该编号已存在！");
					}
				}, "text");
			}
		</script>
	</body>
</html>