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
	<meta http-equiv="content-Type" content="text/html; charset=UTF-8">
	<!-- jsp文件头和头部 -->
	<link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link href="static/css/style.css" rel="stylesheet" />
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	
	<link rel="stylesheet" href="static/assets/css/ace.css" />
	<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
	<link rel="stylesheet" href="static/css/ace-skins.min.css" />
	
	<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<!-- 引入 -->
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
		
	<style type="text/css">
		 #zhongxin td{height:60px;}
	     #zhongxin td {text-align:right; margin-right:10px;}
	</style>
	</head>
<body>
	<form action="customer/save.do" name="customerForm" id="customerForm" method="post">
		<div class="tabbable tabs-below">
			<ul class="nav nav-tabs" id="menuStatus">
				<li>
				<img src="static/images/ui1.png" style="margin-top:-3px;">
				客户信息维护
				</li>
	
				<div class="nav-search" id="nav-search"
					style="right:5px;" class="form-search">
	
					<div style="float:left;" class="panel panel-default">
						<div>
							<a class="btn btn-mini btn-primary" onclick="checkEmp();" 
								style="float:left;margin-right:5px;">保存</a>
							<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();" 
								style="float:left;margin-right:5px;">关闭</a>
						</div>
					</div>
				</div>
			</ul>
		</div>
		<div id="zhongxin">
			<input type="hidden" name="ID" id="id" value="${customer.ID }" title="客户主键ID" />
			<input type="hidden" name="mesg" id="mesg" value="${mesg}"/>
			<table style="margin: 10px auto;">
				<tr>
					<td><label><span style="color: red">*</span>客户编码：</label></td>
					<td>
						<input type="text" name="CUSTOMER_CODE" id="CUSTOMER_CODE" style="width:220px" value="${customer.CUSTOMER_CODE}" title="客户编码" <c:if test="${mesg == 'edit'}">readonly</c:if>/>
					</td>
				</tr>
				<tr>
					<td><label><span style="color: red">*</span>客户名称：</label></td>
					<td><input type="text" name="CUSTOMER_NAME" id="CUSTOMER_NAME" style="width:220px" value="${customer.CUSTOMER_NAME}" title="客户名称"/></td>
				</tr>
				<tr>
					<td><label>描述：</label></td>
					<td colspan="3">
						<textarea id="DESCP" name="DESCP" style="width:220px" rows="4" cols="2" maxlength="255" title="描述">${customer.DESCP}</textarea>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green"></h4></div>
	</form>
	<script type="text/javascript">
		function checkEmp(){
			if(checkInput("CUSTOMER_CODE","请输入客户编码")
					&&checkInput("CUSTOMER_NAME","请输入客户名称")){
				var mesg = $("#mesg").val();
				if(mesg == "add"){
					var customerCode = $("#CUSTOMER_CODE").val();
					var url = "<%=basePath%>/customer/checkCustomerCode.do?customerCode=" + customerCode;
					$.get(url,function(data){
						if(data=="0"){
							$("#customerForm").submit();
						}else{
							top.Dialog.alert("客户编码不能重复，请重新输入");
							return false;
				        }
					},"text");
				}else
					$("#customerForm").submit();
			}
		}
		//检查输入项
		function checkInput(id, msg){
			var input = $("#"+id).val();
			if(input == null || $.trim(input) == ""){
				$("#"+id).tips({
					side:3,
		            msg:msg,
		            bg:'#AE81FF',
		            time:2
		        });
				
				$("#"+id).focus();
				return false;
			}
			return true;
		}
	</script>
</body>
</html>