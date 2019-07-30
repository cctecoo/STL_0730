<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="zh_CN">
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'showEmpData.jsp' starting page</title>
    
	  <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link type="text/css" rel="StyleSheet" href="static/css/dtree.css"  />
	<link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	<script type="text/javascript" src="static/js/bootbox.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->		
	<style type="text/css">
	body{background:none;}
	body:before{background:none;}
	</style>
	<style type="text/css">
		.employee_top{ border-bottom:2px solid #98c0d9; height:40px; line-height:40px; margin-bottom:15px;}
		.employee_title{float:left; margin-left:20px; border-bottom:3px solid #448fb9; height:38px; font-size:18px; color:#448fb9;}
		.employee_search{float:right;}
	</style>
  </head>
  
  <body>

  	<div class="container-fluid" id="main-container">
  		<div class="row">
  			<div class="col-md-12">
  			  	<div class="employee_top">
  					<div class="employee_title"><span  id="title"></span> </div>
  					<div style="width: 100%;text-align: right;margin-bottom: 5px;margin-top: 5px;"><a class="btn btn-small btn-info" onclick="location.href='javascript:history.go(-1);'" style="cursor: pointer;">返回</a> </div>
 			 	</div>
 			 	
					<table id="task_grid" class="table table-striped table-bordered table-hover">
						<thead>
							<tr>
							
								<th data-column-id="ORDER" data-visible="false"></th>
								<th data-column-id="EMP_CODE" data-sortable="false" data-visible="false">员工编号</th>
								<th data-column-id="EMP_NAME" data-sortable="false" data-formatter="links">员工姓名</th>
								<th data-column-id="EMP_DEPARTMENT_NAME" data-sortable="false">所属部门</th>
								<th data-column-id="LAST_SCORE" data-sortable="false">上月考核结果</th>
								<th data-column-id="SCORE" data-sortable="false">本月考核结果</th>
							</tr>
						</thead>
					</table>
				</div>
  
  		</div>
  	</div>
   
    <script type="text/javascript">
	    $(function(){
		    var url = window.location.href;
		   	var str = url.split("?")[1];
		   	var deptId = str.split("&&")[0].split("=")[1];
 			var url = "<%=basePath%>findDeptNameById.do?deptId="+deptId;
  			$.ajax({
				type: "POST",
				async:false,
				url: url,
				success:function (data){     //回调函数，result，返回值
				var obj = eval('(' + data + ')');
					$("#title").html(obj.deptName);
				}
			});

			//表格数据获取
	        $("#task_grid").bootgrid({
				ajax: true,
				url:"empTaskList.do?deptId="+deptId,
				navigation:2,
				formatters:{
					links:function(column,row){
						if('${selfdept}'=='true' || '${hasDataRole}'=='true'){//有部门的数据权限才可以查看
							var num = row.ORDER;
							if(num == 'good'){
								return '<a style="cursor:pointer;" onclick="view('+ row.ID +');" >'+row.EMP_NAME+'</a><img src="static/images/hg.png" style="width: 20px;height: 20px;">';
							}else{
								return '<a style="cursor:pointer;" onclick="view('+ row.ID +');" >'+row.EMP_NAME+'</a>';
							}
						}else{
							return row.EMP_NAME;
						}
					}
				}
			});
    	});
    	//查看员工详情
		function view(ID){
			$('#showDataFrame', parent.document).attr("src","goViewEmpDetail.do?empId="+ID); 
		}
    </script>
  </body>
</html>
