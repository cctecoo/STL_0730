<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
		<base href="<%=basePath%>">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta http-equiv="content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>员工管理</title>
		<link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
		<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
		<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
		<link type="text/css" rel="StyleSheet" href="static/css/dtree.css"  />
		<link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/css/bootgrid.change.css" />
		<script type="text/javascript" src="static/js/dtree.js"></script>
		<script src="static/js/jquery-2.0.3.min.js"></script>
		<script>
			$(function(){	
				var browser_height = $(document).height();
				$("div.main-container-left").css("min-height",browser_height);
				$(window).resize(function() { 
					var browser_height = $(window).height();
					$("div.main-container-left").css("min-height",browser_height);
				}); 
				$(".m-c-l_show").click(function(){
					$(".main-container-left").toggle();
					$(".main-container-left").toggleClass("m-c-l_width");
					$(".m-c-l_show").toggleClass("m-c-l_hide"); 
					var div_width = $(".main-container-left").width();
					$("div.main-content").css("margin-left",div_width+2);
				});
			});
		</script>
		
		<style>
			#zhongxin input[type="checkbox"],input[type="radio"] {
			opacity:1 ;
			position: static;
			height:25px;
			margin-bottom:10px;
			}
		 	#zhongxin td{height:40px;}
		    #zhongxin td label{text-align:right; margin-right:10px;}
		    .container-fluid:before .row:before{display:inline;}
		    input[type=checkbox]{opacity:1 ; position: static;}
		    
		    .mask{margin-top:5px; height:100%; width:100%; position:fixed; _position:absolute; 
				top:0; z-index:1000; background-color: white; opacity:0.3;} 
			.opacity{  opacity:0.7; filter: alpha(opacity=30); background-color:#000; }
		</style>
	</head>
	<body>
	<body>
	<div class="container-fluid" id="main-container">
		<div id="page-content">
		
			<div id="loadDiv" class="center mask" style="display:none; text-align:center;"><br/><br/><br/><br/><br/>
		   	  	<img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">操作中...</h4>
		   	</div>
		   	
			<div class="row-fluid">
				<div class="main-container-left" style="height:500px; overflow-y:scroll;">
					<div class="m-c-l-top">
						<img src="static/images/ui1.png" style="margin-top:-5px;">配置人员
					</div>
					<script type="text/javascript">
				        varList = new dTree('varList','static/img','treeForm');           
				        varList.config.useIcons=true;
				        varList.add(0,-1,'组织机构','');
				        <c:forEach items="${varList}" var="var" varStatus="vs">
				        	varList.add('${var.ID}','${var.PARENT_ID}','[${var.ORDER_NUM}]${var.DEPT_NAME}','javascript:searchByTree();');
				        </c:forEach>
				        document.write(varList);
				        varList.openAll();
					</script>
				</div>
				<div class="main-content" style="margin-left:220px">
					<div class="breadcrumbs" id="breadcrumbs">
						<div class="m-c-l_show"></div> 员工
							<div style="position:absolute; top:5px; right:25px;">
					
							<div>
								<a class="btn btn-mini btn-primary" onclick="saveConfig();;" 
								style="float:left;margin-right:5px;">保存</a>
								<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();" 
								style="float:left;margin-right:5px;">关闭</a>
							</div>
						</div>
					</div>
				
					
					<table id="employee_grid" class="table table-striped table-bordered table-hover">
						<thead>
							<tr>
								<th data-column-id="EMP_CODE" data-identifier="true" data-width="100px" data-order="asc">员工编号</th>
								<th data-column-id="EMP_NAME" data-width="100px">姓名</th>					
								<th data-column-id="EMP_DEPARTMENT_NAME">员工部门名称</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
		<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
		<script type="text/javascript" src="static/js/bootbox.min.js"></script>
		<script type="text/javascript">
			$(function(){
				if("${showPage}"==""){
					alert('加载错误，请联系管理员');
					return;
				}
				$("#employee_grid").bootgrid({
					ajax: true,
					url:"employee/loadEmpConfig.do?showPage=${showPage}",
					navigation:2,
					selection: true,
				    multiSelect: true,
				    keepSelection: true
				/*
				}).on("loaded.rs.jquery.bootgrid", function (e)
    			{	
    				var currentRows = $("#employee_grid").bootgrid("getCurrentRows");
    				var selectedArr=new Array()
    				for(var i=0;i<currentRows.length;i++){
    					var temp = currentRows[i];
    					var changeCode = temp.IS_CHANGE;
    					if (changeCode == "Y"){
    						selectedArr.push(temp.EMP_CODE);	
    					}    					
    				}
    				$("#employee_grid").bootgrid("select", selectedArr);
    			*/
			    });
			});
			
			//保存
			function saveConfig(){
				var selectedRows = $("#employee_grid").bootgrid("getSelectedRows");
				if(selectedRows.length==0){
					top.Dialog.alert('请至少选择一条数据!');
					return;
				}
				//显示加载
				$("#loadDiv").show();
			
				$.ajax({
					url: '<%=basePath%>employee/saveConfig.do',
					type: 'post',
					data:{'showPage':'${showPage}','empCodeArr':selectedRows},
					success:function(data){
						//显示加载
						$("#loadDiv").hide();
						if(data=='success'){
							top.Dialog.alert('操作成功!');
							//先清空之前选择的
							$("#employee_grid").bootgrid("deselect");
							$("#employee_grid").bootgrid("reload");
						}else{
							top.Dialog.alert('操作失败!');
						}
					}
				});
			}
			
			//点击部门树查询		
			function searchByTree(){
				var deptId = varList.getSelected();
				$("#employee_grid").bootgrid("search", {"deptId":deptId});
			}
		</script>
	</body>
</html>