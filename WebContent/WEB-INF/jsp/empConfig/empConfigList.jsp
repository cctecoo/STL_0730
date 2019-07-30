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
	<meta http-equiv="content-Type" content="text/html; charset=UTF-8">
	<!-- jsp文件头和头部 -->
	<link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link href="static/css/style.css" rel="stylesheet" />
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	</head>
	<body>
	
	<div class="row-fluid">		
		<table id="employee_grid" class="table table-striped table-bordered table-hover">
			<thead>
				<tr>
					<c:if test="${isAdminGroup==true}">
					<th data-column-id="EMP_CODE"  data-width="100px" >员工编号</th>
					</c:if>
					<th data-column-id="EMP_NAME" data-width="100px">姓名</th>					
					<th data-column-id="EMP_DEPARTMENT_NAME" >员工部门名称</th>
					<th data-column-id="CREATE_TIME" data-width="100px">创建时间</th>
					<th data-column-id="CREATE_USER_NAME" data-width="70px">创建人</th>
					<c:if test="${isAdminGroup==true || showDeleteBtn==true }">
						<th data-formatter="btns" data-width="50px">操作</th>
					</c:if>
					
				</tr>
				
			</thead>
			
		</table>
	</div>
	<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
		<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
		<script type="text/javascript" src="static/js/bootbox.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript">
				$("#employee_grid").bootgrid({
					ajax: true,
					url:"employee/empConfigList.do?showPage=${showPage}",
					navigation:2,
					/* selection: true,
				    multiSelect: true,
				    keepSelection: true, */			
					labels:{
						infos:"{{ctx.start}}至{{ctx.end}}条，共{{ctx.total}}条",
						refresh:"刷新",
						noResults:"未查询到数据",
						loading:"正在加载...",
						all:"全选"
					},
					formatters:{
						btns: function(column, row){
							return '<a style="cursor:pointer;margin:1px;" title="删除" onclick="del('+ row.ID +');" '
								+ 'class="btn btn-mini btn-danger" data-rel="tooltip"  data-placement="left">'
								+ '<i class="icon-trash"></i></a>';
						}
					},
					rowCount: [10, 25, 50, 100]
				});
				
				//删除
				function del(configId){
					$.ajax({
						url: '<%=basePath%>employee/deleteEmpConfig.do',
						type: 'post',
						data:{'id': configId},
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