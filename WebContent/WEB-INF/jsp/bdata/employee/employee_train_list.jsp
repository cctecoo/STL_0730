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
		<!-- jsp文件头和头部 -->
		<link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
		<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
		<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
		<link href="static/css/style.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/css/bootgrid.change.css" />
		<link rel="stylesheet" href="static/css/chosen.css" />
		
		<link rel="stylesheet" href="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.css" />
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
		input[type=checkbox]{opacity:1 ; position: static;}
	</style>

	</head>
	<body>
		<div class="container-fluid" id="main-container">
			<div id="page-content" class="clearfix">
				<div class="breadcrumbs" id="breadcrumbs">
				    员工培训记录管理
					<div style="position:absolute; top:5px; right:25px;">
						<div>
							<a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
							<c:if test="${changePerson=='Y' || roleId=='0'}">
								<a class="btn btn-small btn-primary" onclick="fromExcel();" style="margin-right:5px;float:left;">导入培训记录</a>
							</c:if>
							<c:if test="${showConfigBtn=='Y' }">
								<a class="btn btn-small btn-danger" onclick="batchDelete();" style="margin-right:5px;float:left;">批量删除</a>
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
												<select class="chzn-select" name="empCode" id="empCode" data-placeholder="请选择" style="width: 156px; vertical-align:top;">
													<option value="">全部</option>
													<c:forEach items="${empList}" var="emp">
														<option value="${emp.EMP_CODE}" >${emp.EMP_NAME}</option>
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr>
											<td><label>培训日期：</label></td>
											<td><input type="text" id="startpicker" name="trainDate" readonly autocomplete="off"/></td>
			                                <td><label>讲授人：</label></td>
			                                <td><input type="text" id="trainTeacher" name="trainTeacher"/></td>
		                              	</tr>
									</table>
									<div style="margin-right:30px;float: right;">
										<a class="btn-style1" onclick="searchBtn()" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a>
										<a class="btn-style2" onclick="resetting()" style="cursor: pointer;">重置</a>
										<a data-toggle="collapse" data-parent="#accordion" class="btn-style3" href="#collapseTwo">关闭</a>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			
			
				<div class="row-fluid">
					<form>
						<input type="hidden" name="USER_CODE" id="USER_CODE" value="${EMP_CODE}"/>
						<table id="employee_train_grid" class="table table-striped table-bordered table-hover">
							<thead>
								<tr>
									<c:if test="${showConfigBtn=='Y' }">
										<th data-column-id="ID" data-identifier="true" data-width="50px">ID</th>
									</c:if>
									<th data-column-id="EMP_NAME" data-width="70px">员工姓名</th>
									<th data-column-id="EMP_DEPARTMENT_NAME" data-width="120px">员工部门</th>
									<th data-column-id="START_DATE" data-formatter="startDate" data-width="100px">培训日期</th>
									<th data-column-id="TRAIN_DATE_STR" data-formatter="trainDateStr">详细时间</th>
									<th data-column-id="TRAIN_CONTENT" data-formatter="trainContent">培训内容</th>
									<th data-column-id="TRAIN_TEACHER" data-width="70px">讲授人</th>
									<th data-column-id="TRAIN_ADDRESS" data-formatter="trainAddress">培训地点</th>
									<th data-column-id="TRAIN_MODE" data-width="100px" data-formatter="trainMode">培训形式</th>
									<th data-column-id="LESSON_PERIOD" data-width="50px" data-formatter="lessonPeriod">课时</th>
									<th data-column-id="TRAIN_RESULT" data-width="50px">成绩</th>
									<th data-column-id="GRADE_CHANGE" data-formatter="gradeChange">岗位变动</th>
									<th data-column-id="STATUS_NAME" data-width="80px">状态</th>
									<th align="center" data-align="center" data-sortable="false" data-formatter="btns" data-width="80px">操作</th>
								</tr>
							</thead>
						</table>
					</form>
	  			</div>
		
			</div>
		</div>
		
		<!-- 引入 -->
		
		<!-- 
		<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		 -->
		 
		<script src="static/js/jquery-1.7.2.js"></script>
		
		<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
		<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		
		<script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js"></script>
		<script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"></script>
		<script type="text/javascript" src="plugins/chosen/chosen.jquery.min.js"></script><!-- 可搜索的下拉框 -->
		<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
		
		
		<script type="text/javascript">
		//判断是否有页码传入
		var currentPage = ('${pd.currentPage}' == '') ? 0 : '${pd.currentPage}';
		
		$(function() {
			$('#startpicker').datetimepicker({
				language:'zh-CN',
			    minView: 2,
			    format: 'yyyy-mm-dd',
			    autoclose: true
			});
			//下拉列表组件
			$(".chzn-select").chosen({search_contains:true}); 
			$(".chzn-select-deselect").chosen({allow_single_deselect:true});
			
			//加载记录
			$("#employee_train_grid").bootgrid({
				ajax: true,
				selection: true,
				multiSelect: true,
				url:"empTrain/empTrainList.do?showPage=${showPage}",
				navigation:2,
				post: function(){
					var postData = new Object();
					if(currentPage>1){
						postData.currentPage = currentPage;
					}
					
					return postData;
				},
				formatters:{
					startDate: function(column, row){
						var dateStr = row.START_DATE + (row.END_DATE==undefined ? "" : ":" + row.END_DATE);
						return '<span title="' + dateStr + '">' + dateStr + '</span>'
					},
					trainDateStr: function(column, row){
						return '<span title="' + row.TRAIN_DATE_STR + '">' + row.TRAIN_DATE_STR + '</span>';
					},
					trainContent: function(column, row){
						return '<span title="' + row.TRAIN_CONTENT + '">' + row.TRAIN_CONTENT + '</span>';
					},
					trainAddress: function(column, row){
						return '<span title="' + row.TRAIN_ADDRESS + '">' + row.TRAIN_ADDRESS + '</span>';
					},
					trainMode: function(column, row){
						return '<span title="' + row.TRAIN_MODE + '">' + row.TRAIN_MODE + '</span>';
					},
					lessonPeriod: function(column, row){
						if(null==row.LESSON_PERIOD){
							return '';
						}
						return '<span title="' + row.LESSON_PERIOD + '">' + row.LESSON_PERIOD + '</span>';
					},
					gradeChange: function(column, row){
						if(null==row.GRADE_CHANGE){
							return '';
						}
						return '<span title="' + row.GRADE_CHANGE + '">' + row.GRADE_CHANGE + '</span>';
					},
					btns: function(column, row){
						if(row.EMP_CODE == $("#USER_CODE").val() && row.STATUS == 'YW_CG'){
							return '<a style="cursor:pointer;margin:1px;" title="编辑" onclick="edit('+ row.ID +');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'+
								'<i class="icon-edit"></i></a>'+
							'<a style="cursor:pointer;margin:1px;" title="删除" onclick="del('+ row.ID +');" class="btn btn-mini btn-danger" data-rel="tooltip"  data-placement="left">'+
								'<i class="icon-trash"></i></a>' + 
							'<a style="cursor:pointer;margin:1px;" title="提交 " onclick="submit('+ row.ID +');" class="btn btn-mini btn-warning" data-rel="tooltip"  data-placement="left">'+
								'<i class="icon-envelope"></i></a>';
						}else if('${changePerson}' == 'Y'){
							return '<a style="cursor:pointer;margin:1px;" title="编辑" onclick="edit('+ row.ID +');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'+
								'<i class="icon-edit"></i></a>'+
							'<a style="cursor:pointer;margin:1px;" title="删除" onclick="del('+ row.ID +');" class="btn btn-mini btn-danger" data-rel="tooltip"  data-placement="left">'+
								'<i class="icon-trash"></i></a>';
						}
					}
				}
			}).on("loaded.rs.jquery.bootgrid",function(e){
				currentPage = 0;//加载后重置之前传入的页码
			});
			
		});
		
		//重置
		function resetting(){
			$("#searchForm")[0].reset(); 
		}
		
		//检索
		function searchBtn(){
			var deptId = $("#deptId").val();
			var empCode = $("#empCode").val();
			var trainDate = $("#startpicker").val();
			var trainTeacher = $("#trainTeacher").val();
			
			$("#employee_train_grid").bootgrid("search", 
					{"deptId":deptId, "empCode":empCode, "trainDate":trainDate, "trainTeacher":trainTeacher});
		}
		
		//点击部门树查询
		function searchByTree(){
			var deptId = varList.getSelected();
			$("#employee_train_grid").bootgrid("search", {"empDeptId":deptId});
		}
		
		//回车绑定查询功能
		$(document).keyup(function(event) {
			if (event.keyCode == 13) {
				searchBtn();
				$("#collapseTwo").collapse('toggle');
			}
		});
		
		//新增
		function add(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="新增";
			 diag.URL = '<%=basePath%>/empTrain/goAdd.do';
			 diag.Width = 650;
			 diag.Height = 600;
			 diag.CancelEvent = function(){ //关闭事件
				 searchBtn();
				diag.close();
			 };
			 diag.show();
		}
		
		//删除
		function del(id){
			top.Dialog.confirm("确定要删除?",function(){ 
				top.jzts();
				var url = "<%=basePath%>/empTrain/delete.do?ID="+id;
				$.get(url,function(data){
					if(data=="success"){
						//检查当前的分页页码
						currentPage = $("#employee_train_grid").bootgrid("getCurrentPage");
						searchBtn();
					}else if(data=="error"){
						top.Dialog.alert("删除出错");
					}
				},"text");
			})
		}
		
		function batchDelete(){
			//var selectedRows = $("#employee_train_grid").bootgrid("getSelectedRows");
			//页面上点击复选框 选择的行后选中的，直接用bootgrid获取不到，只能用js去获取
			var selectedRows = new Array();
			$("#employee_train_grid").find("tr > td input[type='checkbox']:checked").each(function(){
				selectedRows.push($(this).parent().parent().attr('data-row-id'));
			});
			if(selectedRows.length==0){
				top.Dialog.alert("请选择要操作的行");
				return;
			}
			top.Dialog.confirm("确定要批量删除选择的"+selectedRows.length+"记录?",function(){ 
				top.jzts();
				var url = "<%=basePath%>empTrain/batchDelete.do?idArr=" + selectedRows;
				$.get(url,function(data){
					if(data=="success"){
						//检查当前的分页页码
						currentPage = $("#employee_train_grid").bootgrid("getCurrentPage");
						searchBtn();
					}else if(data=="error"){
						top.Dialog.alert("删除出错");
					}
				},"text");
			})
		}
		
		//修改
		function edit(id){
			top.jzts();
			var diag = new top.Dialog();
			diag.Drag=true;
			diag.Title ="编辑";
			diag.URL = '<%=basePath%>/empTrain/goEdit.do?ID='+id;
			diag.Width = 650;
			diag.Height = 600;
			diag.CancelEvent = function(){ //关闭事件
				//检查当前的分页页码
				currentPage = $("#employee_train_grid").bootgrid("getCurrentPage");
				searchBtn();
				diag.close();
			};
			diag.show();
		}
		
		//提交培训记录
		function submit(id){
			top.Dialog.confirm("提交后将不能修改，确定提交？", function(){
				$.ajax({
					url:'<%=basePath%>empTrain/submit.do?time=' + (new Date()),
					type:'post',
					data:{'ID':id},
					success:function(data){
						if(data=='success'){
							$("#employee_train_grid").bootgrid("reload")
							top.Dialog.alert("提交成功");
							
						}else{
							top.Dialog.alert("提交失败");
						}
					}
				});
			});
		}
		
		//打开上传excel页面（岗位职责）
		function fromExcel(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="EXCEL 导入到数据库";
			 diag.URL = 'empTrain/goUploadExcelTrain.do';
			 diag.Width = 400;
			 diag.Height = 150;
			 diag.CancelEvent = function(){ //关闭事件
				 searchBtn();
				diag.close();
			 };
			 diag.show();
		}
		
		//重置
		function resetting(){
			$("#keyword").val(""); 
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
