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
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<!-- ace styles -->
		<link rel="stylesheet" href="static/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />
	</head>
<body>
	<form action="salary/readExcel.do" name="Form" id="Form" method="post" enctype="multipart/form-data">
		<div id="zhongxin">
		<table style="width:95%; margin:0 auto;" >
			
			<tr>
				<td style="padding-top: 20px;"><input type="file" id="excel" name="excel" style="width:50px;" onchange="fileType(this)" /></td>
			</tr>
			<tr>
				<td style="text-align: center;">
					<a class="btn btn-mini btn-primary" onclick="save();">导入</a>
					<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
					<a class="btn btn-mini btn-success" onclick="window.location.href='<%=basePath%>/salary/downExcel.do'">下载模版</a>
				</td>
			</tr>
		</table>
		</div>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><img src="static/images/jzx.gif" /><br/><h4 class="lighter block green"></h4></div>
		
	</form>
	
	
	<!-- 引入 -->
	<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
	<script src="static/js/bootstrap.min.js"></script>
	<!-- ace scripts -->
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<script type="text/javascript">
		$(top.changeui());
		$(function() {
			//上传
			$('#excel').ace_file_input({
				no_file:'请选择EXCEL ...',
				btn_choose:'选择',
				btn_change:'更改',
				droppable:false,
				onchange:null,
				thumbnail:false, //| true | large
				whitelist:'xls|xlsx',
				blacklist:'gif|png|jpg|jpeg'
			});
			
		});
		
		//保存
        function save(){
            if($("#excel").val()==""){
                $("#excel").tips({
                    side:3,
                    msg:'请选择文件',
                    bg:'#AE81FF',
                    time:3
                });
                return false;
            }
            
            $("#Form").submit();
            $("#zhongxin").hide();
            $("#zhongxin2").show();
        }
        
        function fileType(obj){
            var fileType=obj.value.substr(obj.value.lastIndexOf(".")).toLowerCase();//获得文件后缀名
            if(fileType != '.xls' && fileType != '.xlsx'){
                $("#excel").tips({
                    side:3,
                    msg:'请上传xls或者xlsx格式的文件',
                    bg:'#AE81FF',
                    time:3
                });
                var file = $("#excel");
                file.parent().after(file.clone().val("")); 
                file.parent().remove(); 
                $('#excel').ace_file_input({
                    no_file:'请选择EXCEL ...',
                    btn_choose:'选择',
                    btn_change:'更改',
                    droppable:false,
                    onchange:null,
                    thumbnail:false, //| true | large
                    whitelist:'xls|xlsx',
                    blacklist:'gif|png|jpg|jpeg'
                });
            }
        }
	</script>
</body>
</html>