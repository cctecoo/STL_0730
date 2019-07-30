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
		
		<link rel="stylesheet" href="static/css/datepicker.css" /><!-- 日期框 -->
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>		

	</head>
<body>
	<fmt:requestEncoding value="UTF-8" />
	<form action="positionDuty/${msg}.do" name="Form" id="Form" method="post">
	<input type="hidden" name="id" id="id" value="${pd.id}"/>
	<input type="hidden" name="ID" id="ID" value="${pd.ID}"/>
	<input type="hidden" name="msg" id="msg" value="${msg}"/>
	<input type="hidden" name="GRADE_CODE" id="GRADE_CODE" value="${pd.GRADE_CODE}"/>
		<div id="zhongxin">
		<br>

		<table style="margin:0 auto;">
			<tr>
				<td style="text-align: center;">岗位职责：</td>
				<td style="text-align: left;" ><input type="text" name="responsibility" id="responsibility" value="${pd.responsibility}" style="color:black;" maxlength="32" placeholder="岗位职责" title="岗位职责" /></td>
			</tr>
			<tr>
				<td style="text-align: center;" colspan="2">
					<br>
					<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
					<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
				</td>
			</tr>
		</table>

		</div>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">提交中...</h4></div>
		
	</form>
	
	
		<!-- 引入 -->
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
		<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
		<script type="text/javascript">


		//保存
		function save(){			
			if($("#responsibility").val()==""){
			
				$("#responsibility").tips({
					side:3,
		            msg:'请填写岗位职责',
		            bg:'#AE81FF',
		            time:2
		        });
				
				$("#responsibility").focus();
				return false;
			}
			else{
				var url = "<%=basePath%>positionDuty/checkDuty.do?responsibility=" +$('#responsibility').val()+ "&GRADE_CODE=" +$('#GRADE_CODE').val()+ "&msg=" +$('#msg').val()+ "&ID=" +$('#ID').val();
				$.get(url, function(data){
					if(data == "true"){
						$("#Form").submit();
						$("#zhongxin").hide();
					}else{
	                    alert("该职责已存在！");
	                    $("#emp_code").focus();
	                    return;
	                }
				},"text");

			}
		}
		
		
		</script>

</body>
</html>