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
	<link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	<link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>

	<style>
	    input[type=checkbox]{opacity:1 ; position: static;}
	</style>
	
	</head>
	<body>
	<div class="container-fluid" id="main-container">
		<div id="page-content">
			<div class="row-fluid">
				<div class="main-container-left" >
					<div class="m-c-l-top">
						<img src="static/images/ui1.png" style="margin-top:-5px;">员工管理
					</div>
					<div id="deptTreePanel" style="background-color:white;z-index: 1000;">
						<ul id="deptTree" class="tree"></ul>
					</div>
				</div>
				<div class="main-content" style="margin-left:220px">
					<div class="breadcrumbs" id="breadcrumbs">
						<div class="m-c-l_show"></div> 员工管理详情
							<div style="position:absolute; top:5px; right:25px;">
					
							<div>
								<a class="btn btn-small btn-warning" onclick="setSupportService('Y')" title="添加服务支持后，可以给这些员工下达服务类临时工作"
									 style="margin-right:5px;float:left;">添加服务支持</a>
								<a class="btn btn-small btn-warning" onclick="setSupportService('N')" title="移除服务支持后，将不能该该员工下达服务类临时工作" style="margin-right:5px;float:left;">移除服务支持</a>
								<a class="btn btn-small btn-warning" onclick="updateEmpInfo();" title="通过表格更新员工信息" style="margin-right:5px;float:left;">通过表格更新员工信息</a>
								<a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
								<a class="btn btn-small btn-primary" onclick="fromExcel();" title="从EXCEL导入" 
									style="margin-right:5px;float:left;">导入</a>
								<a class="btn btn-small btn-primary" onclick="exportEmployee();" title="导出员工数据" 
									style="margin-right:5px;float:left;">导出</a>
								<!-- 
								<a class="btn btn-small btn-primary" onclick="fromExcel1();" title="从EXCEL导入" style="margin-right:5px;float:left;">导入档案</a>
								 -->
								
								<a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" class="btn btn-small btn-primary" style="float:left;text-decoration:none;">高级搜索 </a>
							</div>
							<div id="collapseTwo" class="panel-collapse collapse" style="position:absolute; top:32px; right:0; z-index:999">
								<div class="panel-body">
									<form id="searchForm">
										<table>
											<tr>
												<td><label>员工编码：</label></td>
												<td><input type="text" id="empCode" name="EMP_CODE" style="height:30px;"/></td>
												<td><label>姓名：</label></td>
												<td><input type="text" id="empName" name="EMP_NAME" style="height:30px;"/></td>
											</tr>
											<tr>
												<td><label>岗位名称：</label>
												<td><input type="text" id="empGradeName"/></td>
												<td><label>启用：</label></td>
												<td>
													<select name="ENABLED" id="enabled" style="width:156px;">
														<option value="">全部</option>
														<option value="1" selected>是</option>
														<option value="0">否</option>
													</select>
												</td>
											</tr>
										</table>
										<div style="margin-right:30px;float: right;">
											<a class="btn-style1" onclick="search2();" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a>
											<a class="btn-style2" onclick="resetting()" style="cursor: pointer;">重置</a>
											<a data-toggle="collapse" data-parent="#accordion" class="btn-style3" href="#collapseTwo">关闭</a>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
				
					
					<table id="employee_grid" class="table table-striped table-bordered table-hover">
						<thead>
							<tr>
								<th data-column-id="EMP_CODE" data-identifier="true" data-width="100px" data-order="asc">员工编号</th>
								<th data-column-id="EMP_NAME" data-width="70px">姓名</th>
								<!-- 
								<th data-column-id="EMP_GENDER" data-width="70px" data-formatter="gender">性别</th>
								 -->
								<th data-column-id="ENABLED" data-width="70px" data-formatter="enable">启用</th>
								<th data-column-id="IS_SUPPORT_SERVICE" data-width="70px" data-formatter="supportService">服务支持</th>
								<th data-column-id="IS_SHOW_DEPT_WORK" data-width="70px" data-formatter="showDeptWork">展示工作</th>
								<!-- 
								<th data-column-id="EMP_EMAIL" data-width="120px">员工邮箱</th>
								<th data-column-id="EMP_PHONE" data-width="120px">联系电话</th>
								 -->
								<th data-column-id="LEADER_EMPNAME" data-width="100px">上级领导</th>
								<th data-column-id="EMP_GRADE_NAME" data-formatter="empGradeName">岗位名称</th>
								<th data-column-id="EMP_DEPARTMENT_NAME">员工部门名称</th>
								<!-- 
								<th data-column-id="EMP_REMARK">备注</th>
								 -->
								<th align="center" data-align="center" data-width="100px" data-sortable="false" data-formatter="btns">操作</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>

	<script src="static/js/jquery-2.0.3.min.js"></script>
	
	<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	<script type="text/javascript" src="static/js/bootbox.min.js"></script>
	
	<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
	<script type="text/javascript" src="static/deptTree/deptTree1.js"></script>
	
	<script>
		$(function(){
			//左右分页，可以调整宽度
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
		
		//判断是否有页码传入
		var currentPage = ('${pd.currentPage}' == '') ? 0 : '${pd.currentPage}';
		$(function(){
			$("#employee_grid").bootgrid({
				ajax: true,
				url:"employee/empList.do",
				navigation:2,
				selection: true,
			    multiSelect: true,
			    post: function(){
			    	var postData = new Object();
					if(currentPage>1){
						postData.currentPage = currentPage;
					}
					postData.ENABLED = 1;
					
					return postData;
			    },
				formatters:{
					gender: function(column, row){
						var value = row.EMP_GENDER;
						if(value== "1"){
							return "男";
						}else if(value == "2"){
							return "女";
						}else{
							return "";
						}
					},
					enable: function(column, row){
						var value = row.ENABLED;
						if(value=="1"){
							return "是";
						}else{
							return "否";
						}
					},
					supportService:function(column, row){
						if(row.IS_SUPPORT_SERVICE=='Y'){
							return "是";
						}else{
							return "否";
						}
					},
					showDeptWork: function(column, row){
						if(row.IS_SHOW_DEPT_WORK=='Y'){
							return "是";
						}else{
							return "否";
						}
					},
					empGradeName: function(column, row){
						return '<span title="' + row.EMP_GRADE_NAME + '">' + row.EMP_GRADE_NAME + '</span>';
					},
					btns: function(column, row){
						var str = ''
						str += '<a style="cursor:pointer;margin:1px;" title="编辑" onclick="edit('+ row.ID +');" '
							+ ' class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'
							+ ' <i class="icon-edit"></i></a>';
					
						str += '<a style="cursor:pointer;margin:1px;" title="配置分管部门"'
							+ ' onclick="confInchargeDept(\''+ row.EMP_CODE + '\',\'' + row.EMP_NAME +'\');" '
							+ ' class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'
							+ ' <i class="icon-cog"></i></a>';
							
						return str;
					}
				}
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
			if(null != dept){
				deptId = dept.ID;
			}
			var emp_code = $("#empCode").val();
			var emp_name = $("#empName").val();
			var enabled = $("#enabled").val();
			var empGradeName = $("#empGradeName").val();
			$("#employee_grid").bootgrid("search", {
				"ID": deptId, "EMP_CODE":emp_code, "EMP_NAME":emp_name
				, "ENABLED":enabled, "empGradeName": empGradeName
			});
		}
		
		function searchByTree(deptId){
			$("#employee_grid").bootgrid("search", {"ID":deptId});
		}
		
		//新增员工
		function add(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="新增员工";
			 diag.URL = "<%=basePath%>/employee/goAddEmp.do?";
			 diag.Width = 800;
			 diag.Height = 500;
			 diag.CancelEvent = function(){ //关闭事件
				 search2();
				diag.close();
			 };
			 diag.show();
		}
		
		//修改
		function edit(id){
			var diag = new top.Dialog();
			diag.Drag=true;
			diag.Title ="编辑";
			diag.URL = '<%=basePath%>employee/goEditEmp.do?ID='+id;
			diag.Width = 800;
			diag.Height = 500;
			diag.CancelEvent = function(){ //关闭事件
				//检查当前的分页页码
				currentPage = $("#employee_grid").bootgrid("getCurrentPage");
				search2();
				diag.close();
			};
			diag.show();
		}
		
		//配置分管部门
		function confInchargeDept(empCode, empName){
			var diag = new top.Dialog();
			diag.Drag=true;
			diag.Title ="配置分管部门";
			diag.URL = '<%=basePath%>employee/toConfInchargeDept.do?empCode=' + empCode +'&empName=' + empName;
			diag.Width = 500;
			diag.Height = 500;
			diag.CancelEvent = function(){ //关闭事件
				diag.close();
			};
			diag.show();
		}
		
		//更新员工信息
		function updateEmpInfo(){
			top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="更新员工信息";
			 diag.URL = 'employee/goUpdateEmpInfo.do';
			 diag.Width = 400;
			 diag.Height = 150;
			 diag.CancelEvent = function(){ //关闭事件
				diag.close();
				location.replace("<%=basePath%>/employee/list.do");
			 };
			 diag.show();
		}
		
		//员工档案编辑
		function view(id){
			top.mainFrame.tabAddHandler(1, "编辑员工档案", "<%=basePath%>/employee/goRecord.do?EMP_ID=" + id);
		}
		
		//删除
		function del(id){
			bootbox.confirm("确定要删除该记录吗?", function(result) {
				if(result) {
					var url = "employee/delete.do?ID="+id;
					$.get(url,function(data){
						if(data == "success"){
							alert("删除员工成功！");
							//检查当前的分页页码
							currentPage = $("#employee_grid").bootgrid("getCurrentPage");
							$("#employee_grid").bootgrid("reload");
						}
					},"text");
				}
			});
		}
		
		//打开上传excel页面
		function fromExcel(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="EXCEL 导入到数据库";
			 diag.URL = 'employee/goUploadExcel.do';
			 diag.Width = 400;
			 diag.Height = 150;
			 diag.CancelEvent = function(){ //关闭事件
				diag.close();
				location.replace("<%=basePath%>/employee/list.do");
			 };
			 diag.show();
		}
		
		//打开上传excel页面
		function fromExcel1(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="EXCEL 导入到数据库";
			 diag.URL = 'employee/goUploadExcelRecord.do';
			 diag.Width = 400;
			 diag.Height = 150;
			 diag.CancelEvent = function(){ //关闭事件
				diag.close();
				location.replace("<%=basePath%>/employee/list.do");
			 };
			 diag.show();
		}
		
		//重置
		function resetting(){
			$("#searchForm")[0].reset(); 
		}
		
		//导出员工
		function exportEmployee(){
			top.Dialog.confirm("确定导出员工数据？", function(){
				var emp_code = $("#empCode").val();
				var emp_name = $("#empName").val();
				var enabled = $("#enabled").val();
				window.location.href = "<%=basePath%>employee/exportEmployee.do?EMP_CODE=" + emp_code + 
						"&EMP_NAME=" + emp_name + "&ENABLED=" + enabled;
			});
		}
		
		//设置服务支持
		function setSupportService(isSupportService){
			var selectedRows = $("#employee_grid").bootgrid("getSelectedRows");
			if(selectedRows.length==0){
				top.Dialog.alert('请至少选择一条数据!');
				return;
			}
			$.ajax({
				url: '<%=basePath%>employee/setSupportService.do',
				type: 'post',
				data:{'isSupportService':isSupportService, 'empCodeArr':selectedRows},
				success:function(data){
					if(data=='success'){
						top.Dialog.alert('操作成功!');
						$("#employee_grid").bootgrid("reload");
					}else{
						top.Dialog.alert('操作失败!');
					}
				}
			});
		}
	
	</script>
	
	</body>
</html>