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
	<!-- jsp文件头和头部 -->
	<link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link href="static/css/style.css" rel="stylesheet" />
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	<link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>

	<script type="text/javascript" src='static/js/jquery-2.0.3.min.js'></script>
	<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
	<script type="text/javascript" src="static/deptTree/deptTree1.js"></script>
	<!-- 引入 -->
	<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	<script type="text/javascript">
		$(function(){	
			var browser_height = $(document).height();
			$("div.main-container-left").css("min-height",browser_height);
			$("#deptTreePanel").css("height", browser_height-50);
			$(window).resize(function() { 
				var browser_height = $(window).height();
				$("div.main-container-left").css("min-height",browser_height);
				$("#deptTreePanel").css("height", browser_height-50);
			}); 
			$(".m-c-l_show").click(function(){
				$(".main-container-left").toggle();
				$(".main-container-left").toggleClass("m-c-l_width");
				$(".m-c-l_show").toggleClass("m-c-l_hide");
				var div_width = $(".main-container-left").width();
				$("div.main-content").css("margin-left",div_width+2);
			});
			
			//初始化树控件
			var setting = {
				checkable: false,
				checkType : { "Y": "", "N": "" },
				callback: {
					click:function(){
						var dept = deptTree.getSelectedNode();
						searchByTree(dept.ID);
					}
				}
			};
			$("#deptTree").deptTree(setting,${deptTreeNodes},$(document).height()-40, 218);
			$("#deptTreePanel").attr('height', 'auto');
			$("#deptTreePanel").show();
			
		});
		
      	//点击部门树查询
		function searchByTree(deptId){
			$("#employee_grid").bootgrid("search", {"attachDeptId":deptId});
		}
      	
      	function showJobBank(){
      		top.Dialog.alert("岗位等级默认：15 ；<br>1-董事长/副董事长/总裁办主任；<br>2-总经理；3-副总经理（副总）；" +
      				"4-部长；5-副部长；6-车间主任/车间副部长；7-车间副主任；8-主任；9-副主任；10-主管");
      	}
      	
		//判断是否有页码传入
		var currentPage = ('${pd.currentPage}' == '') ? 0 : '${pd.currentPage}';
		$(function() {
			//加载列表
			$("#employee_grid").bootgrid({
				ajax: true,
				url:"positionLevel/empList.do",
				navigation:2,
				post: function(){
					var postData = new Object();
					if(currentPage>1){
						postData.currentPage = currentPage;
					}
					
					return postData;
				},
				formatters:{
					gradeName: function(column, row){
						var str = row.GRADE_NAME;
						return '<span title="' + str + '">' +  str+ '</span>';
					},
					deptName: function(column, row){
						var str = row.DEPT_NAME;
						return '<span title="' + str + '">' +  str+ '</span>';
					},
					gradeDesc: function(column, row){
						var str = row.GRADE_DESC;
						return '<span title="' + str + '">' +  str+ '</span>';
					},
					btns: function(column, row){
						return '<a style="cursor:pointer;margin:1px;" title="编辑" onclick="edit('+ row.ID +');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'+
						'<i class="icon-edit"></i></a>'+
						'<a style="cursor:pointer;margin:1px;" title="删除" onclick="del('+ row.ID +');" class="btn btn-mini btn-danger" data-rel="tooltip"  data-placement="left">'+
							'<i class="icon-trash"></i></a>'+
						'<a style="cursor:pointer;margin:1px;" title="配置岗位职责" onclick="config('+ row.ID +');" class="btn btn-mini btn-purple" data-rel="tooltip"  data-placement="left">'+
							'<i class="icon-cog"></i></a>'
					}
				},
				labels:{
					infos:"{{ctx.start}}至{{ctx.end}}条，共{{ctx.total}}条",
					refresh:"刷新",
					noResults:"未查询到数据",
					loading:"正在加载...",
					all:"全选"
				},
				rowCount: [10, 25, 50, 100]
			}).on("loaded.rs.jquery.bootgrid",function(e){
				currentPage = 0;//加载后重置之前传入的页码
			});
			
		});
		
		//回车绑定查询功能
		$(document).keyup(function(event) {
			if (event.keyCode == 13) {
				search2();
				$("#collapseTwo").collapse('toggle');
			}
		});
		
		//检索
		function search2(){
			var dept = deptTree.getSelectedNode(),
			deptId = '';
			if(null != dept){//选择了左侧的部门
				deptId = dept.ID;
			}
			var keyword = $("#keyword").val();
			$("#employee_grid").bootgrid("search", {
				"KEYW": keyword, "attachDeptId": deptId
			});
		}
		
		//重置
		function resetting(){
			$("#keyword").val(""); 
		}
		
		//新增
		function add(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="新增";
			 diag.URL = '<%=basePath%>/positionLevel/toAdd.do';
			 diag.Width = 450;
			 diag.Height = 350;
			 diag.CancelEvent = function(){ //关闭事件
				 search2();
			 	/*
				 if('${page.currentPage}' == '0'){
					 top.jzts();
					 setTimeout("self.location=self.location",100);
				 }else{
					 $("#employee_grid").bootgrid("reload");
				 }
			 	*/
				diag.close();
			 };
			 diag.show();
		}
		
		//删除
		function del(id){
			
			if(confirm("确定要删除?")){ 
				top.jzts();
				var url = "<%=basePath%>/positionLevel/delete.do?id="+id;
				$.get(url,function(data){
					if(data=="success"){
						//检查当前的分页页码
						currentPage = $("#employee_grid").bootgrid("getCurrentPage");
						$("#employee_grid").bootgrid("reload");
						
					}else if(data=="fail"){
						alert("岗位已分配到员工，不可删除");
					}else if(data=="error"){
						alert("删除出错");
					}
				},"text");
			}
		}
		
		function config(id){
			var PARENT_FRAME_ID = $(".tab_item2_selected", window.parent.document).parents('table').attr('id');
        	top.mainFrame.tabAddHandler("explain1", "配置岗位职责", "<%=basePath%>positionDuty/list.do?id=" +id + "&PARENT_FRAME_ID=" +PARENT_FRAME_ID);
			
		}
		
		//修改
		function edit(id){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="编辑";
			 diag.URL = '<%=basePath%>/positionLevel/goEdit.do?id='+id;
			 diag.Width = 450;
			 diag.Height = 350;
			 diag.CancelEvent = function(){ //关闭事件
				//$("#employee_grid").bootgrid("reload");
				//检查当前的分页页码
				currentPage = $("#employee_grid").bootgrid("getCurrentPage");
				search2();
				diag.close();
			 };
			 diag.show();
		}

		//打开上传excel页面（岗位职责）
		function fromExcel(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="EXCEL 导入到数据库";
			 diag.URL = 'positionDuty/goUploadExcel.do';
			 diag.Width = 400;
			 diag.Height = 150;
			 diag.CancelEvent = function(){ //关闭事件
				diag.close();
				location.replace("<%=basePath%>/positionLevel/list.do");
			 };
			 diag.show();
		}
		
		//excel导出岗位职责
		function exportExcel(){
			var deptId = null;
			var dept = deptTree.getSelectedNode();
			if(null!=dept){
				deptId = dept.ID;
			}
			if(null==deptId){
				top.Dialog.alert("请选择需要操作的部门");
				return false;
			}
			top.Dialog.confirm("确定导出数据？", function(){
				window.location.href = '<%=basePath%>positionDuty/exportPositionDuty.do?deptId=' + deptId;
			});
		}
		
		//打开上传excel页面（岗位）
		function fromExcel2(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="EXCEL 导入到数据库";
			 diag.URL = 'positionLevel/goUploadExcel.do';
			 diag.Width = 400;
			 diag.Height = 150;
			 diag.CancelEvent = function(){ //关闭事件
				diag.close();
				location.replace("<%=basePath%>/positionLevel/list.do");
			 };
			 diag.show();
		}

	</script>
	</head>
	<body>
	<div class="container-fluid" id="main-container">
		<div id="page-content" class="clearfix">
			<div class="row-fluid">
				<div class="main-container-left" >
					<div class="m-c-l-top">
						<img src="static/images/ui1.png" style="margin-top:-5px;">岗位管理
					</div>
					<div id="deptTreePanel" style="background-color:white;z-index: 1000;">
						<ul id="deptTree" class="tree"></ul>
					</div>
				</div>
				<div class="main-content" style="margin-left:220px">
					<div class="breadcrumbs" id="breadcrumbs">
						<div class="m-c-l_show"></div>岗位列表
						<div style="position:absolute; top:5px; right:25px;">
							<div>
								<a class="btn btn-small" style="margin-right:5px;float:left;" onclick="showJobBank()">等级规则</a>
								<a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
								<a class="btn btn-small btn-primary" onclick="fromExcel2();" style="margin-right:5px;float:left;">导入岗位</a>
								<a class="btn btn-small btn-primary" onclick="fromExcel();" style="margin-right:5px;float:left;">导入岗位职责及明细</a>
								<a class="btn btn-small btn-primary" onclick="exportExcel();" style="margin-right:5px;float:left;">导出岗位职责及明细</a>
								
								<a data-toggle="collapse" data-parent="#accordion"
									href="#collapseTwo" class="btn btn-small btn-primary"
									style="float:left;text-decoration:none;">
									高级搜索 </a>
							</div>
							<div id="collapseTwo" class="panel-collapse collapse"
								style="position:absolute;  top:32px;right:0; z-index:999">
								<div class="panel-body">
									<%-- <span class="input-icon">
										关键字：<input autocomplete="off" id="nav-search-input" type="text" name="keyword" value="${pd.keyword}" placeholder="这里输入关键词" />
										<i id="nav-search-icon" class="icon-search"></i>
									</span> --%>
									<table>
									<tr>
									<td><label style="width:100%; text-align:center;">关键字：</label></td>
									<td>
									<input autocomplete="off" type="text" id="keyword" name="keyword" value="${pd.keyword}" placeholder="编码、 名称、 描述、部门" 
										title="可用于查询  岗位编码、 岗位名称、 岗位描述、 部门名称" style="height:30px;"	/>
									</td>
									</tr>
									</table>
									<div style="margin-top:15px; margin-right:30px; text-align:right;">
										<a class="btn-style1" onclick="search2();" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a> 
										<a class="btn-style2"onclick="resetting()" style="cursor: pointer;">重置</a>
										<a data-toggle="collapse" data-parent="#accordion" class="btn-style3" href="#collapseTwo">关闭</a>
									</div>
								</div>
							</div>
						</div>
					</div>
				
					<table id="employee_grid" class="table table-striped table-bordered table-hover">
						<thead>
							<tr>
								<th data-column-id="GRADE_CODE" data-order="asc" data-width="100px">岗位编码</th>
								<th data-column-id="GRADE_NAME" data-formatter="gradeName">岗位名称</th>
								<th data-column-id="JOB_RANK" data-width="100px">岗位等级</th>
								<th data-column-id="DEPT_NAME" data-formatter="deptName">部门名称</th>
								<th data-column-id="LABOR_COST" data-visible="false">员工成本</th>
								<th data-column-id="GRADE_DESC" data-width="120px" data-formatter="gradeDesc">岗位描述</th>
								<th align="center" data-align="center" data-sortable="false" data-formatter="btns" data-width="100px">操作</th>
							</tr>
						</thead>
					</table>
				</div>
			<!-- PAGE CONTENT ENDS HERE -->
  			</div><!--/row-->
		</div><!--/#page-content-->
	</div><!--/.fluid-container#main-container-->

	</body>
</html>
