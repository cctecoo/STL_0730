<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
	<base href="<%=basePath%>">
	<meta http-equiv="content-Type" content="text/html; charset=UTF-8">
	<!-- jsp文件头和头部 -->
	<link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link href="static/css/style.css" rel="stylesheet" />
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	<link rel="stylesheet" href="static/css/chosen.css" />
	<style type="text/css">
		.chosen-container-single .chosen-single{/*设置可搜索下拉框的样式*/
			width:156px;
			height:30px;
		}
		.chosen-container-single .chosen-drop{/*设置可搜索下拉框的样式*/
			width:156px;
			height:30px;
		}
		.chosen-container .chosen-results{
			width: 156px;
		    border: 1px solid;
		    background-color: white;
		}
		.chosen-container .chosen-results li {
			padding:1px
		}
		.breadcrumbs ul li{
			height:20px;
			text-align:left;
		}
	</style>
	</head>
	<body>
		<div class="container-fluid" id="main-container">
			
			<div id="page-content" class="clearfix">
				<div class="breadcrumbs" id="breadcrumbs">
				     &nbsp; &nbsp; 员工档案管理
					<div style="position:absolute; top:5px; right:25px;">
						<div>
							<c:if test="${changePerson=='Y' || isSysAdmin=='Y' }">
								<!-- 
								<a class="btn btn-small btn-primary" onclick="showImport();" title="从EXCEL导入" 
									style="margin-right:5px;float:left;">导入附加信息</a>
								 -->
								<a class="btn btn-small btn-primary" onclick="showRecordImport();" title="从EXCEL导入" 
									style="margin-right:5px;float:left;">导入档案</a>
								<a class="btn btn-small btn-primary" onclick="exporRecord();" title="导出记录" 
									style="margin-right:5px;float:left;">导出档案</a>
							</c:if>
							<c:if test="${showConfigBtn == 'Y'}">
								<a class="btn btn-small btn-warning" onclick="goConfig('${showPage}');" style="margin-right:5px;float:left;">配置维护人员</a>
						    </c:if>
						    <a class="btn btn-small btn-info" onclick="showConfig('${showPage}');" style="margin-right:5px;float:left;">查看维护人员</a>
							<a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" class="btn btn-small btn-primary"
								style="float:left;text-decoration:none;">高级搜索 </a>
						</div>
						<div id="collapseTwo" class="panel-collapse collapse" style="position:absolute; top:32px;right:0px; z-index:999">
							<div class="panel-body">
								<form id="searchForm">
									<table>
										<tr>
											<td style="width:100px"><label>员工部门：</label></td>
											<td>
												<select class="chzn-select" id="deptId" name="deptId" onchange="findEmp()" style="width: 156px;">
													<option value="" >全部</option>
													<c:forEach items="${deptList }" var="dept">
														<option value="${dept.ID }" >${dept.DEPT_NAME }</option>
													</c:forEach>
												</select>
											</td>
											<td style="width:100px"><label>员工姓名：</label></td>
											<td>
												<select class="chzn-select" name="empCode" id="empCode" data-placeholder="请选择" 
													style="width: 156px; vertical-align:top;">
													<option value="">全部</option>
													<c:forEach items="${empList}" var="emp">
														<option value="${emp.EMP_CODE}">${emp.EMP_NAME}</option>
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr>
			                                <td><label>毕业学校：</label></td>
			                                <td style="width:200px;"><input type="text" id="school" name="school"/></td>
			                                <td style="width:100px"><label>档案录入：</label></td>
											<td>
												<select name="hasRecord" id="hasRecord" data-placeholder="请选择" 
													style="width: 156px; vertical-align:top;">
													<option value="">全部</option>
													<option value="Y">是</option>
													<option value="N">否</option>
												</select>
											</td>
		                              	</tr>
									</table>
									<div style="margin-right:30px;float: right;">
										<a class="btn-style1" onclick="searchBtn()" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a>
										<a class="btn-style2" onclick="resetting1()" style="cursor: pointer;">重置</a>
										<a data-toggle="collapse" data-parent="#accordion" class="btn-style3" href="#collapseTwo">关闭</a>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			
			
				<div class="row-fluid">
					<!-- 检索  -->
					<form>
						<table id="employee_record_grid" class="table table-striped table-bordered table-hover">
							<thead>
								<tr>
									<th data-column-id="EMP_NAME" data-width="100px">员工姓名</th>
									<th data-column-id="EMP_DEPARTMENT_NAME" data-width="300px">员工部门</th>
									<th data-column-id="RECORD_ID"data-formatter="existRecord" data-width="100px" >档案录入</th>
									<th data-column-id="GRADUATE_TIME" data-formatter="graduatetime" data-width="300px">毕业时间</th>
									<th data-column-id="SCHOOL" >毕业学校</th>
									<th align="center" data-align="center" data-sortable="false" data-formatter="btns" data-width="100px">操作</th>
								</tr>
							</thead>
						</table>
					</form>
	  			</div>
		
			</div>
		</div>
		
		
		<!-- 引入 -->
		
		<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
		<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
		<script type="text/javascript" src="plugins/chosen/chosen.jquery.min.js"></script><!-- 可搜索的下拉框 -->
		<!-- 引入 -->
		
		<script type="text/javascript">
		//判断是否有页码传入
		var currentPage = ('${pd.currentPage}' == '') ? 0 : '${pd.currentPage}';
		
		$(function() {
			//下拉列表组件
			$(".chzn-select").chosen({search_contains: true}); 
			$(".chzn-select-deselect").chosen({allow_single_deselect:true});
			$("#employee_record_grid").bootgrid({
				ajax: true,
				url:"employee/empRecordList.do?showPage=${showPage}",
				navigation:2,
				post: function(){
					var postData = new Object();
					if(currentPage>1){
						postData.currentPage = currentPage;
					}
					
					return postData;
				},
				formatters:{
					existRecord: function(column, row){
						if(row.RECORD_ID){
							return '是';
						}else{
							return '否';
						}
					},
				 	graduatetime: function(column, row){
				 		if(row.GRADUATE_TIME==undefined){
				 			return '';
				 		}
						var dateStr = row.GRADUATE_TIME
						return '<span title="' + dateStr + '">' + dateStr + '</span>'
					},
					btns: function(column, row){
						//自己的可以编辑//可以维护档案的人员
						if(row.EMP_CODE == '${pd.EMP_CODE}' || '${changePerson}'=='Y'){
							return '<a style="cursor:pointer;margin:1px;" title="编辑" onclick="edit('+ row.ID +');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'+
							'<i class="icon-edit"></i></a>';
						}else{
							return '<a style="cursor:pointer;margin:1px;" title="查看" onclick="show('+ row.ID +');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'+
							'<i class="icon-eye-open"></i></a>'
						} 
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
		
		//重置
		function resetting1(){
			$("#searchForm")[0].reset(); 
		}
		
		
		//检索
		function searchBtn(){
			var deptId = $("#deptId").val();
			var empCode = $("#empCode").val();
			var school = $("#school").val();
			var deptmentname = $("#deptmentname").val();
			var hasRecord = $("#hasRecord").val();
			$("#employee_record_grid").bootgrid("search", 
				{"deptId" : deptId, "empCode" : empCode, "name" : name, "school" : school, "deptmentname" : deptmentname
				, "hasRecord" : hasRecord
			});
		}
		
		//回车绑定查询功能
		$(document).keyup(function(event) {
			if (event.keyCode == 13) {
				searchBtn();
				$("#collapseTwo").collapse('toggle');
			}
		});
		
		//导入附加信息
		function showImport(){
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="EXCEL 导入到数据库";
				diag.URL = 'common/goUploadEmpOtherInfoExcel.do';
				diag.Width = 400;
				diag.Height = 150;
				diag.CancelEvent = function(){ //关闭事件
					
					diag.close();
				};
			 diag.show();
		}
		
		//打开上传excel页面
		function showRecordImport(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="EXCEL 导入员工档案到数据库";
			 diag.URL = 'employee/goUploadExcelRecord.do';
			 diag.Width = 400;
			 diag.Height = 150;
			 diag.CancelEvent = function(){ //关闭事件
				diag.close();
				$("#employee_record_grid").bootgrid("reload");
			 };
			 diag.show();
		}
		
		//导出我创建的记录
		function exporRecord(){
			top.Dialog.confirm('确定执行操作', function(){
				window.location.href = "<%=basePath%>employee/exporRecord.do";
			});
		}
		
		//查看
		function show(empId){
			top.jzts();
			var diag = new top.Dialog();
			diag.Drag=true;
			diag.Title ="查看";
			diag.URL = '<%=basePath%>/employee/goRecordShow.do?EMP_ID='+empId;
			diag.Width = 1050;
			diag.Height = 500;
			diag.CancelEvent = function(){ //关闭事件
				//检查当前的分页页码
				currentPage = $("#employee_record_grid").bootgrid("getCurrentPage");
				//searchBtn();
				diag.close();
			};
			diag.show();
		}
		
		//编辑
		function edit(empId){
			top.jzts();
			var diag = new top.Dialog();
			diag.Drag=true;
			diag.Title ="编辑";
			diag.URL = '<%=basePath%>/employee/goEditEmpRecord.do?EMP_ID=' + empId;
			diag.Width = 1050;
			diag.Height = 500;
			diag.CancelEvent = function(){ //关闭事件
				//检查当前的分页页码
				currentPage = $("#employee_record_grid").bootgrid("getCurrentPage");
				searchBtn();
				diag.close();
			};
			diag.show();
		}
		
		
		//配置维护人员
		function goConfig(showPage){
			top.jzts();
			var diag = new top.Dialog();
			diag.Drag=true;
			diag.Title ="配置维护人员";
			diag.URL = '<%=basePath%>employee/goConfig.do?showPage=' + showPage;
			diag.Width = 950;
			diag.Height = 510;
			diag.CancelEvent = function(){ //关闭事件
				//检查当前的分页页码
				currentPage = $("#employee_record_grid").bootgrid("getCurrentPage");
				//searchBtn();
				diag.close();
			};
			diag.show();
		}
		
		//展示维护人员
		function showConfig(showPage){
			top.jzts();
			var diag = new top.Dialog();
			diag.Drag=true;
			diag.Title ="展示维护人员";
			diag.URL = '<%=basePath%>employee/showConfig.do?showPage=' + showPage;
			diag.Width = 550;
			diag.Height = 510;
			diag.CancelEvent = function(){ //关闭事件
				//检查当前的分页页码
				currentPage = $("#employee_record_grid").bootgrid("getCurrentPage");
				//searchBtn();
				diag.close();
			};
			diag.show();
		}
		
		//查询部门员工
		function findEmp(){
			var deptId = $("#deptId").val();
			var path = "<%=basePath%>empDailyTask/findDeptEmp.do?deptId=" + deptId;
			$.ajax({
				type: "POST",
				url: path,
				async: false,
				success: function(data){
					if(data=='error'){
						top.Dialog.alert("获取部门数据出错");
					}
					var obj = eval('(' + data + ')');
					//更新员工
					$("#empCode").empty();
					$("#empCode").append('<option value="">全部</option>');
					$.each(obj, function(i, emp){
						$("#empCode").append('<option value="' + emp.EMP_CODE + '">' + emp.EMP_NAME + '</option>');
					});
					$("#empCode").chosen("destroy");
					$("#empCode").chosen();
				}
			});
		}
		
		</script>

	</body>
</html>
