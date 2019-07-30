<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
<base href="<%=basePath%>">
<link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css" />
<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css" />
<link type="text/css" rel="StyleSheet" href="static/css/style.css" />
<link rel="stylesheet" href="static/css/font-awesome.min.css" />
<link rel="stylesheet" href="static/css/bootgrid.change.css" />
<link rel="stylesheet" href="static/css/datepicker.css" />
<style type="text/css">
li {
	list-style-type: none;
}
.mask{margin-top:50px; height:100%; width:100%; position:fixed; _position:absolute; top:0; z-index:1000; background-color: white; opacity:0.3;} 
</style>
</head>
<body>
	<div class="container-fluid" id="main-container">
		<div id="page-content" class="clearfix">
			<div class="breadcrumbs" id="breadcrumbs">
			     <div style="float:left; margin-left:15px;">
					月份:
					<input type="text" id="relateMonth" name="relateMonth" style="background:#fff!important; height:24px;" 
						readonly="readonly" class="date-picker" data-date-format="yyyy-mm" placeholder="请选择！"/>
				</div>
				<div style="position:absolute; top:5px; left:275px;">
					
					<div>
						<c:if test="${showConfigBtn=='Y' }">
						<a class="btn btn-small btn-warning" onclick="goConfig('${showPage}');" style="margin-left:3px;float:left;">配置维护人员</a>
						</c:if>
					
						<a class="btn btn-small btn-info" onclick="showConfig('${showPage}');" style="margin-left:3px;float:left;">查看维护人员</a>
						
						<c:if test="${changePerson=='Y' || isAdminGroup}">
							<a class="btn btn-small btn-warning" onclick="configPayment();" style="margin-left:3px;float:left;">配置薪酬公式</a>
							<a class="btn btn-small btn-primary" onclick="fromExcel();" title="从EXCEL导入" style="margin-left:3px;float:left;">导入工资总额</a> 
							<a class="btn btn-small btn-primary" onclick="buildData()" title="生成薪资数据" style="margin-left:3px;float:left;">生成薪资</a>
						</c:if>
						
						<a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" class="btn btn-small btn-primary" 
							style="margin-left:3px; float:left;text-decoration:none;">高级搜索 </a>
					</div>
					<div id="collapseTwo" class="panel-collapse collapse"
						style="position:absolute;  top:32px; left:-275px; z-index:999">
						<div class="panel-body">
							<table>
								<tr>
									<td>所属部门:</td>
									<td>
										<select id="DEPT_ID" name="DEPT_ID" onchange="findEmp()">
											<option value="">全部</option>
											<c:forEach items="${deptList }" var="dept" varStatus="vs">
												<option value="${dept.ID }">${dept.DEPT_NAME}</option>
											</c:forEach>
										</select>
									</td>
									<td>人员:</td>
									<td><select name="empCode" id="empCode" data-placeholder="请选择" style="width: 170px; vertical-align:top;">
											<option value="">全部</option>
											<c:forEach items="${empList}" var="emp">
												<option id="emp_${emp.EMP_DEPARTMENT_ID }" deptId="${emp.EMP_DEPARTMENT_ID }" value="${emp.EMP_CODE}"
												<c:if test="${emp.EMP_CODE == pd.empCode }">selected</c:if>>${emp.EMP_NAME}</option>
											</c:forEach>
										</select>
									</td>

								</tr>
							</table>
							<div
								style="margin-top:15px; margin-right:30px; text-align:right;">
								<a class="btn-style1" onclick="search2();" data-toggle="collapse" data-parent="#accordion" 
									href="#collapseTwo" style="cursor: pointer;">查询</a> 
								<a class="btn-style2"onclick="resetting()" style="cursor: pointer;">重置</a>
								<a data-toggle="collapse" data-parent="#accordion" class="btn-style3" href="#collapseTwo">关闭</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="loadDiv" class="center mask" style="display:none"><br/><br/><br/><br/><br/>
	   	  	<img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">操作中...</h4>
	   	</div>
	 	<div class="row-fluid">
			
			<table id="task_grid"
				class="table table-striped table-bordered table-hover">
				<thead>
					<tr>
						<th data-column-id="EMP_CODE" data-width="120px">员工编号</th>
						<th data-column-id="EMP_NAME" data-width="150px">姓名</th>
						<th data-column-id="DEPT_NAME" data-width="180px">所属部门</th>
						<th data-column-id="FORMULA_NAME" data-width="120px" data-formatter="formulaName">公式名称</th>
						<th data-column-id="FORMULA">所属公式</th>
						<th data-column-id="YM" data-width="80px">年月</th>
						<th data-column-id="SALARY_AMOUNT" data-width="80px">绩效总额</th>
						<th data-column-id="CREATE_TIME" data-width="100px">生成日期</th>
						<th align="center" data-align="center" data-sortable="false" data-width="100px"
							data-formatter="btns">操作</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>
	
	<!--/.fluid-container#main-container-->
	<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
	<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	<script type="text/javascript" src="static/js/bootbox.min.js"></script>
	<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
	<!-- 下拉框 -->
	<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script>
	<!-- 日期框 -->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<!--提示框-->
	<script type="text/javascript">
			$(function() {
				//表格数据获取
       	 		$("#task_grid").bootgrid({
					ajax: true,
					url:"salary/taskList.do",
					navigation:2,
					formatters:{
						formulaName:function(column, row){
							return '<span title="' + row.FORMULA_NAME + '">' + row.FORMULA_NAME + '</span>'
						},
						btns: function(column, row){
							var res = row.STATUS;
							var str = '<a style="cursor:pointer;margin-left: 2px;" title="查看" onclick="view(\'' + row.ID +'\');" '
								+ 'class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">查看</a>';
							if('${changePerson}'=='Y'){
								str +=  '<a style="cursor:pointer;margin-left: 2px;" title="编辑" onclick="edit(\'' + row.ID +'\',\'' + row.POS_ID +'\');" '
								+ 'class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">编辑</a>';
							}
			                return str; 
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
				});
				//日期框
		        $('.date-picker').datepicker({
		            format:'yyyy.mm',
		            autoclose: true,
		            startViewMode:2,
		            minViewMode:1,
		            maxViewMode:1
		        }).on('changeDate', function(){
		        	search2();
		        });
			});
			
			//配置KPI模板
			function configPayment(){
				window.location.href = '<%=basePath%>projectManagement/list.do';
			}
			
			//重置
			function resetting(){
				$("#DEPT_ID").val("");
				$("#POS_ID").val("");
				$("#YM").val("");
			}
			
			//检索
			function search2(){
				var deptId = $("#DEPT_ID").val();
				var empCode = $("#empCode").val();
				var relateMonth = $("#relateMonth").val();
				$("#task_grid").bootgrid("search", 
						{"DEPT_ID":deptId, "empCode":empCode, "relateMonth":relateMonth});
			}
			
			// 查看
			function view(id){
				 top.jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="查看";
				 diag.URL = '<%=basePath%>/salary/goView.do?id='+id;
				 diag.Width = 700;
				 diag.Height = 480;
				 diag.CancelEvent = function(){ //关闭事件
					//location.replace('<%=basePath%>/salary/list.do');
					diag.close();
				 };
				 diag.show();
			}
					
			//修改
			function edit(id){
				 top.jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="编辑";
				 diag.URL = '<%=basePath%>/salary/goEdit.do?id='+id;
				 diag.Width = 700;
				 diag.Height = 480;
				 diag.CancelEvent = function(){ //关闭事件
					 $("#task_grid").bootgrid("reload");
					diag.close();
				 };
				 diag.show();
			}
			
			//打开上传excel页面
			function fromExcel(){
				 top.jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="EXCEL 导入到数据库";
				 diag.URL = 'salary/goUploadExcel.do';
				 diag.Width = 400;
				 diag.Height = 150;
				 diag.CancelEvent = function(){ //关闭事件
					 $("#task_grid").bootgrid("reload");
					 diag.close();
				 };
				 diag.show();
			}
			//生成数据
			function buildData(){
				$("#loadDiv").show();
				var url = '<%=basePath%>salary/buildSalaryData.do'; 
				$.ajax({
					type: "POST",
					url: url,
					data: {relateMonth: $("#relateMonth").val()},
					success: function(data){
						$("#loadDiv").hide();
						$("#task_grid").bootgrid("reload");
						if(data=='nodata'){
							alert('没有员工配置公式');
						}else if(data=='success'){
							alert('操作成功');
						}else if(data=='error'){
							alert('后台出错，请联系管理员');
						}else{
							alert(data);
						}
					}
				});
			}
			//查询部门员工
			function findEmp(){
				var deptId = $("#DEPT_ID").val();
				
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
					}
				});
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
					 diag.close();
				 };
				 diag.show();
			}
		</script>
</body>
</html>
