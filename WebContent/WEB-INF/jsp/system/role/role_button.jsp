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
	<input type="hidden" id="menuId" name="menuId">
	<input type="hidden" id="menuCode" name="menuCode">
	<div style="width:30%;float: left;">
		<table>
			<tr>
				<td width="40%">
					<div id="zhongxin">
						<ul id="tree" class="tree" style="overflow:auto;" ></ul>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div style="width:30%;float: left;">
		<table>
			<tr>
				<td width="60%">
				<div>
					<ul id="tree2" class="tree" style="overflow:auto;" ></ul>
				</div>
			</td>
			</tr>
		</table>
	</div>
			
	<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green"></h4></div>
	<script type="text/javascript" src="static/js/jquery-1.5.1.min.js"></script>
	<script type="text/javascript" src="plugins//zTree/jquery.ztree-2.6.min.js"></script>
	
	<script type="text/javascript">
	top.changeui();
	var zTree;
	var zBtnTree;
	var zTreeNodes2;
	$(document).ready(function(){
		var setting = {
		    showLine: true,
		    checkable: false,
		    showIcon :true,
		    callback : {
		    	click: zTreeOnClick
		    }
		};
		var zn = '${zTreeNodes}';
		var zTreeNodes = eval(zn);
		zTree = $("#tree").zTree(setting, zTreeNodes);
		
		var setting2 ={
			showLine: true,
		    checkable: true,
		    showIcon :true,
		    async: {
                enable: true,
                type: "post",
                contentType: "application/json",
                url:"selectChildMenu.action",
                autoParam:["id"],
                dataType:"json"
        }
		};
		//alert(zn2);
		zTreeNodes2 = eval('${zBtnTreeNodes}');
		zBtnTree = $("#tree2").zTree(setting2, zTreeNodes2);
	});
	
	function zTreeOnClick(event, treeId, treeNode){
		var nodes = zBtnTree.getNodes();
		for (var i = nodes.length-1; i >= 0; i--) {
			zBtnTree.removeNode(nodes[i]);
		}
		var menuId = treeNode.id;
		$("#menuId").val(menuId);
		var menuCode = treeNode.MENU_CODE;
		$("#menuCode").val(menuCode);
		
		var roleId = "${roleId}"; 
		var url = "<%=basePath%>/role/getBtnRole.do?ROLE_ID="+roleId+"&MENU_ID="+menuId;
		$.ajax({
			type: "POST",
			async:false,
			url: url,
			success:function (data){     //回调函数，result，返回值
				zTreeNodes2 = eval('(' + data + ')');
				zBtnTree.addNodes(null, zTreeNodes2);
				
			}					
		});	
	}
	
	function Node(id,pid,name){  
        this.id=id;  
        this.pId=pid;  
        this.name=name;  
                                  
    } 
	</script>
	<script type="text/javascript">
	
		 function save(){
			   
				var nodes = zBtnTree.getCheckedNodes();
				
				var tmpNode;
				var ids = "";
				var events="";
				for(var i=0; i<nodes.length; i++){
					tmpNode = nodes[i];
					if(i!=nodes.length-1){
						ids += tmpNode.id+",";
						events += tmpNode.BUTTONS_EVENT+",";
					}else{
						ids += tmpNode.id;
						events += tmpNode.BUTTONS_EVENT;
					}
				}
				var roleId = "${roleId}";
				var url = "<%=basePath%>/role/roleButton/save.do";
				var postData;
				var menuId = $("#menuId").val();
				var menuCode = $("#menuCode").val();
				postData = {"ROLE_ID":roleId,"buttonIds":ids,"MENU_ID":menuId,"events":events,"MENU_CODE":menuCode};
				
				$("#zhongxin").hide();
				$("#zhongxin2").show();
				$.post(url,postData,function(data){
					//if(data && data=="success"){
						top.Dialog.close();
					//}
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