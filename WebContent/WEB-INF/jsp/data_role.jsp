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

<link href="static/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="static/css/font-awesome.min.css" />

<link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
<link rel="stylesheet" href="static/css/ace.min.css" />
<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
<link rel="stylesheet" href="static/css/ace-skins.min.css" />


<style type="text/css">
footer{height:50px;position:fixed;bottom:0px;left:0px;width:100%;text-align: center;}
</style>

</head>
<body>
	<div id="zhongxin" style="margin-bottom: 60px;">
		<ul id="tree" class="tree" style="overflow:auto;"></ul>
	</div>
	<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green"></h4></div>
	
	
	<script type="text/javascript" src="static/js/jquery-1.5.1.min.js"></script>
	<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
	
	<script type="text/javascript">
		$(top.changeui());
		var setting = {
			showLine: true,
			checkable: true,
			isSimpleData: true,
			treeNodeKey:"ID",
			treeNodeParentKey:"PARENT_ID",
			nameCol: "DEPT_NAME",
			checkType : { "Y": "s", "N": "s" },
		};
		
		var zTree;
		$(document).ready(function(){
			zTree = $("#tree").zTree(setting, ${zTreeNodes});
		});
	</script>
	<script type="text/javascript">
		 function save(){
			var nodes = zTree.getCheckedNodes();
			var ids = "";
			for(var i=0; i < nodes.length; i++){
				ids += nodes[i].ID+",";
			}
			
			var userId = "${userId}";
			var url = "data_role/save.do";
			var postData;
			
			postData = {"userId":userId,"deptIds":ids.substring(0, ids.length - 1) };
			
			$("#zhongxin").hide();
			$("#zhongxin2").show();
			$.post(url,postData,function(data){
				if(data == "success"){
					top.Dialog.close();
				}
			});
		}
	</script>
	<footer>
	<div style="width: 100%;" class="center">
		<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
		<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
	</div>
	</footer>
</body>
</html>