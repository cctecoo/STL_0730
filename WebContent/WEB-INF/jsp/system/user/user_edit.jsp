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
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/css/chosen.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		
		<style type="text/css">
			#zhongxin input{width:300px}
			#zhongxin select{width:314px;}
		</style>
		
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script type="text/javascript">
	$(top.changeui());
	$(document).ready(function(){
		if($("#user_id").val()!=""){
			$("#loginname").attr("readonly","readonly");
			$("#loginname").css("color","gray");
		}
		//单选框
		$(".chzn-select").chosen(); 
		$("#role_id").next().find(".chosen-results");//.css("height","75px");
		$(".chzn-select-deselect").chosen({allow_single_deselect:true}); 
		
	});
	
	//选择员工编号后，获取相应信息
	function selectNumber(){
		var empNum = $(".chzn-select").val();
		$("#name").val("");
		$("#deptName").val("");
		$("#deptId").val("");
		$("#PHONE").val("");
		$("#EMAIL").val("");
		$.post(
			"employee/findEmpByCode.do",
			{"code": empNum},
			function(data){
				$("#name").val(data.EMP_NAME);
				$("#deptName").val(data.EMP_DEPARTMENT_NAME);
				$("#deptId").val(data.EMP_DEPARTMENT_ID);
				$("#PHONE").val(data.EMP_PHONE);
				$("#EMAIL").val(data.EMP_EMAIL);
			}
		);
	}
	
	//保存
	function save(){
		if($("#role_id").val()==""){
			$("#role_id").tips({
				side:3,
	            msg:'选择角色',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#role_id").focus();
			return false;
		}
		if($("#loginname").val()=="" || $("#loginname").val()=="此用户名已存在!"){
			
			$("#loginname").tips({
				side:3,
	            msg:'输入用户名',
	            bg:'#AE81FF',
	            time:2
	        });
			
			$("#loginname").focus();
			$("#loginname").val('');
			$("#loginname").css("background-color","white");
			return false;
		}else{
			$("#loginname").val(jQuery.trim($('#loginname').val()));
		}
		
		if($("#NUMBER").val()==""){
			
			$("#NUMBER").tips({
				side:3,
	            msg:'输入编号',
	            bg:'#AE81FF',
	            time:3
	        });
			$("#NUMBER").focus();
			return false;
		}
		
		if($("#user_id").val()=="" && $("#password").val()==""){
			
			$("#password").tips({
				side:3,
	            msg:'输入密码',
	            bg:'#AE81FF',
	            time:2
	        });
			
			$("#password").focus();
			return false;
		}
		if($("#password").val()!=$("#chkpwd").val()){
			
			$("#chkpwd").tips({
				side:3,
	            msg:'两次密码不相同',
	            bg:'#AE81FF',
	            time:3
	        });
			
			$("#chkpwd").focus();
			return false;
		}
		if($("#name").val()==""){
			
			$("#name").tips({
				side:3,
	            msg:'输入姓名',
	            bg:'#AE81FF',
	            time:3
	        });
			$("#name").focus();
			return false;
		}
		/*
		var myreg = /^(((13[0-9]{1})|159)+\d{8})$/;
		if($("#PHONE").val()==""){
			
			$("#PHONE").tips({
				side:3,
	            msg:'输入手机号',
	            bg:'#AE81FF',
	            time:3
	        });
			$("#PHONE").focus();
			return false;
		}else if($("#PHONE").val().length != 11 && !myreg.test($("#PHONE").val())){
			$("#PHONE").tips({
				side:3,
	            msg:'手机号格式不正确',
	            bg:'#AE81FF',
	            time:3
	        });
			$("#PHONE").focus();
			return false;
		}
		
		if($("#EMAIL").val()==""){
			
			$("#EMAIL").tips({
				side:3,
	            msg:'输入邮箱',
	            bg:'#AE81FF',
	            time:3
	        });
			$("#EMAIL").focus();
			return false;
		}else if(!ismail($("#EMAIL").val())){
			$("#EMAIL").tips({
				side:3,
	            msg:'邮箱格式不正确',
	            bg:'#AE81FF',
	            time:3
	        });
			$("#EMAIL").focus();
			return false;
		}
		*/
		
		if($("#user_id").val()==""){
			hasU();
		}else{
			$("#userForm").submit();
			$("#zhongxin").hide();
			$("#zhongxin2").show();
		}
	}
	
	function ismail(mail){
		return(new RegExp(/^(?:[a-zA-Z0-9]+[_\-\+\.]?)*[a-zA-Z0-9]+@(?:([a-zA-Z0-9]+[_\-]?)*[a-zA-Z0-9]+\.)+([a-zA-Z]{2,})+$/).test(mail));
	}
	
	//判断用户名是否存在
	function hasU(){
		var USERNAME = $("#loginname").val();
		var url = "user/hasU.do?USERNAME="+USERNAME+"&tm="+new Date().getTime();
		$.get(url,function(data){
			if(data=="error"){
				//$("#loginname").css("background-color","#D16E6C");
				
				//setTimeout("$('#loginname').val('此用户名已存在!')",500);
				$("#loginname").tips({
					side:3,
		            msg:'此用户名已存在!',
		            bg:'#AE81FF',
		            time:3
		        });
				$("#loginname").focus();
				return false;
			}else{
				$("#userForm").submit();
				$("#zhongxin").hide();
				$("#zhongxin2").show();
			}
		});
	}
	
	//判断邮箱是否存在
	function hasE(USERNAME){
		var EMAIL = $("#EMAIL").val();
		var url = "user/hasE.do?EMAIL="+EMAIL+"&USERNAME="+USERNAME+"&tm="+new Date().getTime();
		$.get(url,function(data){
			if(data=="error"){
				
				$("#EMAIL").tips({
					side:3,
		            msg:'邮箱已存在',
		            bg:'#AE81FF',
		            time:3
		        });
				
				setTimeout("$('#EMAIL').val('')",2000);
				
			}
		});
	}
	
	//判断编码是否存在
	function hasN(USERNAME){
		var NUMBER = $("#NUMBER").val();
		var url = "user/hasN.do?NUMBER="+NUMBER+"&USERNAME="+USERNAME+"&tm="+new Date().getTime();
		$.get(url,function(data){
			if(data=="error"){
				
				$("#NUMBER").tips({
					side:3,
		            msg:'编号已存在',
		            bg:'#AE81FF',
		            time:3
		        });
				
				setTimeout("$('#NUMBER').val('')",2000);
				
			}
		});
	}
	
</script>
	</head>
<body>
	<form action="user/${msg }.do" name="userForm" id="userForm" method="post">
		<input type="hidden" name="USER_ID" id="user_id" value="${pd.USER_ID }"/>
		<div id="zhongxin">
		<table style="width:90%; margin:10px auto;">
			<tr>
				<td><span style="color: red; width:100px;">*</span>用户名：</td>
				<td><input type="text" name="USERNAME" id="loginname" value="${pd.USERNAME }" maxlength="32" placeholder="这里输入用户名" title="用户名"/></td>
			</tr>
			<tr>
				<td><span style="color: red;">*</span>员工编号：</td>
				<td>
					<c:choose>
						<c:when test="${fx=='head' }">
							<input type="text" name="NUMBER" id="NUMBER" value="${pd.NUMBER }" placeholder="请选择员工编号" title="员工编号" readonly="readonly"/>
						</c:when>
						<c:otherwise>
							<select class="chzn-select" onChange="selectNumber()" name="NUMBER" id="NUMBER" data-placeholder="请选择员工编号" style="vertical-align:top;">
								<option value=""></option>
								<c:forEach items="${numbers}" var="result">
									<option value="${result.EMP_CODE}" <c:if test="${result.EMP_CODE == pd.NUMBER }">selected</c:if>>${result.EMP_CODE}</option>
								</c:forEach>
							</select>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<td>姓名：</td>
				<td>
					<c:choose>
						<c:when test="${fx=='head' }">
							<input type="text" name="NAME" id="name"  value="${pd.NAME }" readonly="readonly" placeholder="这里输入姓名" title="姓名"/></td>
						</c:when>
						<c:otherwise>
							<input type="text" name="NAME" id="name"  value="${pd.NAME }"  readonly="readonly" maxlength="32" placeholder="这里输入姓名" title="姓名"/></td>
						</c:otherwise>
					</c:choose>
			</tr>
			<tr>
				<td>部门</td>
				<td>
					<input type="text" name="DEPT_NAME" id="deptName"  value="${pd.DEPT_NAME }" title="部门" readonly="readonly"/>
					<input type="hidden" name="DEPT_ID" id="deptId"  value="${pd.DEPT_ID }"/>
				</td>
			</tr>
			<tr>
				<td><span style="color: red;">*</span>手机号</td>
				<td><input type="number" name="PHONE" id="PHONE"  value="${pd.PHONE }" readonly="readonly"  maxlength="32" placeholder="这里输入手机号" title="手机号"/></td>
			</tr>
			<tr>
				<td><span style="color: red;">*</span>邮箱</td>
				<td><input type="email" name="EMAIL" id="EMAIL"  value="${pd.EMAIL }" readonly="readonly" maxlength="32" placeholder="这里输入邮箱" title="邮箱" /></td>
			</tr>
			<c:if test="${fx != 'head'}">
				<c:if test="${pd.ROLE_ID != '1'}">	
					<tr class="info">
						<td><span style="color: red;">*</span>角色：</td>
						<td style="vertical-align:top;"> 
						 	<select class="chzn-select" name="ROLE_ID" id="role_id" data-placeholder="请选择角色" >
								<option value=""></option>
								<c:forEach items="${roleList}" var="role">
									<option value="${role.ROLE_ID }" <c:if test="${pd.ROLE_ID==role.ROLE_ID}">selected</c:if>>${role.ROLE_NAME }</option>
								</c:forEach>
						  	</select>
						</td>
					</tr>
				</c:if>
				<c:if test="${pd.ROLE_ID == '1'}">
					<input name="ROLE_ID" id="role_id" value="1" type="hidden" />
				</c:if>
			</c:if>
			<c:if test="${fx == 'head'}">
				<input name="ROLE_ID" id="role_id" value="${pd.ROLE_ID }" type="hidden" />
			</c:if>
			<tr>
				<td><span style="color: red;">*</span>密码：</td>
				<td><input type="password" name="PASSWORD" id="password"  maxlength="32" placeholder="输入密码" title="密码"/></td>
			</tr>
			<tr>
				<td><span style="color: red;">*</span>确认密码：</td>
				<td><input type="password" name="chkpwd" id="chkpwd"  maxlength="32" placeholder="确认密码" title="确认密码" /></td>
			</tr>
			
			<tr>
				<td>备注：</td>
				<td><input type="text" name="BZ" id="BZ"value="${pd.BZ }" placeholder="这里输入备注" maxlength="64" title="备注"/></td>
			</tr>
			<tr>
				<td style="text-align: center;" colspan="2">
					<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
					<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
				</td>
			</tr>
		</table>
		</div>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green"></h4></div>
		
	</form>
	

</body>
</html>