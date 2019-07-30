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
		<style>
			/*设置自适应框样式*/
			.test_box {
				width: 330px;
				min-height: 22px;
			    _height: 120px;
			    padding: 4px 6px; 
			    outline: 0; 
			    border: 1px solid #d5d5d5; 
			    font-size: 12px; 
			    word-wrap: break-word;
			    overflow-x: hidden;
			    overflow-y: auto;
			    _overflow-y: visible;
			}
		</style>
		
		<!-- 引入 -->
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		
<script type="text/javascript">
	
	top.changeui();

	//检查长度是否超出
	function checkVal(divId, inputId, length, setVal){
		var val = $(divId).text();
		if(val.length>length){
			$(divId).tips({
				side:3,
	            msg:'长度不能超过' + length + '，请重新填写!',
	            bg:'#AE81FF',
	            time:1
	        });
			$(divId).focus();
		}else if(setVal){
			$(inputId).attr("value", val);
		}
		return val.length>length;
	}
	
	//保存
	function save(){
		if($("#roleName").val()==""){
			$("#roleName").focus();
			return false;
		}
		//检查说明输入的字符是否过长
		if(checkVal('#divInput', '#OPINION', 255, true)){
			return;
		}
		$("#form1").submit();
		$("#zhongxin").hide();
		$("#zhongxin2").show();
	}
	
</script>
	</head>
<body>
		<form action="repository/saveOpinion.do" name="form1" id="form1"  method="post">
		<input type="hidden" name="DOC_ID" id="DOC_ID" value="${pd.doc_id}"/>
		<input type="hidden" name="EMP_CODE" id="EMP_CODE" value="${pd.emp_code}"/>
			<div id="zhongxin">
			<table style="margin:10px auto">
				<tr>
					<td>
						<input type="hidden" name="OPINION" id="OPINION" value="${pd.opinion}" placeholder="这里输入意见" title="意见" />
						<div id="divInput" class="test_box" contenteditable="true" placeholder="这里输入意见"
							 onkeyup="checkVal('#divInput', '#OPINION', 255, false)"></div>
					</td>
					
				</tr>
				<tr>
					<td style="text-align: center;">
						<a style="margin-top:10px" class="btn btn-mini btn-primary" onclick="save();">保存</a>
						<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
					</td>
				</tr>
			</table>
			</div>
		</form>
	
	<div id="zhongxin2" class="center" style="display:none"><img src="static/images/jzx.gif"  style="width: 50px;" /><br/><h4 class="lighter block green"></h4></div>
		
</body>
</html>
