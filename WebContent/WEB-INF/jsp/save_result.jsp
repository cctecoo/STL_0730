<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>保存结果</title>
<meta name="description" content="overview & stats" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />

</head>
<body>
	<div id="zhongxin"></div>
	<input type="hidden" value="0" id="daoru">
	<script type="text/javascript">
		document.getElementById('zhongxin').style.display = 'none';
		
		var msg = "${msg}";
		if(msg=="success" || msg==""){
			//正常执行
		}else if(msg=="rigidSuccess"){//刚性规则导入
			document.getElementById('daoru').value = '1';
			var info = "${info}";
			alert(info);
		}else if(msg=="cityAreaSuccess"){//区域导入
			document.getElementById('daoru').value = '1';
			var info = "${info}";
			alert(info);
		}else if(msg=="saveSuccess"){
            alert("保存成功！");
        }else if(msg=="saveSucc"){
			document.getElementById('daoru').value = '1';
			var info = "${info}";
			alert(info);
		}else if(msg=="importSysUserSuccess"){
			if("${result}"==""){
				 alert("保存成功！");
			}else{
				 alert("${result}");
			}
		}else{
            alert(msg);
        }
		top.Dialog.close();
	</script>
</body>
</html>