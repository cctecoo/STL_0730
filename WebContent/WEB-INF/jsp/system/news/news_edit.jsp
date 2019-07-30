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
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
</head>

<script type="text/javascript">
	$(top.changeui());
	//保存
	function save(){
	//alert($("#NEWS_ID").val());
		if($("#NOTICE").val()==""){
			
			$("#NOTICE").tips({
				side:3,
	            msg:'请输入名称',
	            bg:'#AE81FF',
	            time:2
	        });
			
			$("#NOTICE").focus();
			return false;
		}
		$("#Form").submit();
	}
	
</script>


<body>
	<form  action="<%=basePath%>news/save.do" name="Form" id="Form" method="post" >
		<input type="hidden" name="NEWS_ID" id="NEWS_ID" value="${pd.ID}"/>
		<input type="hidden" name="PARENT_ID" id="PARENT_ID" value="${pd.NEWS_ID }"/>
		<div id="zhongxin">
		<table>
			<tr class="info">
				<td><input type="text" name="NOTICE" id="NOTICE" placeholder="这里输入内容" value="${pd.NOTICE}" title="内容"/></td>
			</tr>

			<tr>
				<td style="text-align: center;">
					<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
					<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
				</td>
			</tr>
		</table>
		</div>
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><img src="static/images/jzx.gif" style="width: 50px;" /><br/><h4 class="lighter block green"></h4></div>
	</form>
</body>
<script type="text/javascript">
/*	var msg = '${msg}';
	if(msg == 'no'){
		//$("#BIANMA").attr("readonly",true);
	}*/

</script>
</html>