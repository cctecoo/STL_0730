<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
	<head>
		<base href="<%=basePath%>">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,minimal-ui"></meta>
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<script src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script src="plugins/JQuery/jquery.min.js"></script>
		<link rel="stylesheet" href="plugins/Bootstrap/css/bootstrap.css" />
		<title>解除绑定确认</title>
		<style>
			body{ background:#ebebeb;}
			.btn-unbuding{width:100%; margin:0 auto;border-radius:20px;padding:6px 12px; font-size:18px; background:#32c2f7;outline:none;}
			.btn-unbuding:focus{outline:none;}
			.btn-unbuding:active:focus{outline:none;}
		</style>
	</head>
	<body>
		<img src="static/login_stl/images/unbundling-confirm.png" width="100%"/>
		<div style="text-align:center;line-height:2;font-size:16px;color:#969696;">
			是否确认解除该绑定？<br/>确认请输入“Y”<br/>
			<input type="text" id="check" style="width:70px; text-align:center; border:0; margin-top:10px; outline:none;" />
		</div>
		<div style="height:50px;"></div>
		<div style="width:70%; margin:0 auto;">
		<button  type="button" class="btn btn-info btn-unbuding" onclick="unBind()">确  认</button>
		</div>

		<script type="text/javascript" src="plugins/JQuery/jquery-1.12.2.min.js"></script>
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<script type="text/javascript" src="static/js/jquery.cookie.js"></script>
		<script type="text/javascript">
		
		function unBind(){
			if($("#check").val() != "Y"&& $("#check").val() != "y"){
					$("#check").tips({
						side:3,
		       	        msg:'请输入Y/y！',
						bg:'#ff0000',
						time:2
		       	    });
					$("#check").focus();
				return;
			}		
			if(confirm("确定解除绑定？")){
				window.location.href="<%=basePath %>app_login/unBind.do";
			}
		}
		
		</script>
	</body>
</html>