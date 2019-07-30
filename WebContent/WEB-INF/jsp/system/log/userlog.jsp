<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
		<base href="<%=basePath%>">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>用户操作日志</title>
		<link rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
		<link rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
		<link rel="StyleSheet" href="static/css/style.css"/>
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/css/bootgrid.change.css" />
		<link rel="stylesheet" href="static/css/datepicker.css">
		<style type="text/css">
			.form-control{
				border-radius: 0;
			}
		</style>
	</head>
	<body>
		<fmt:requestEncoding value="UTF-8" />
		<div class="container-fluid" id="main-container">
			<div class="row">
				<div class="col-md-12">
					<div class="panel-body" style="position: absolute;border: 0;z-index: 1000;width: 98%;">
						<table>
							<tr>
								<td>操作对象：</td>
								<td><input type="text" class="form-control" style="height: 30px;" id="operObj" name="operObj"></td>
								<td>操作类型：</td>
								<td>
									<select class="form-control" name="logType" id="logType">
										<option value=""></option>
										<option value="add"><fmt:message key="userlog.type.add" /></option>
										<option value="delete"><fmt:message key="userlog.type.delete" /></option>
										<option value="update"><fmt:message key="userlog.type.update" /></option>
									</select>
								</td>
								<td>
								操作时间：
								</td>
								<td>
								<input class="date-picker"
										id="selTime" name="selTime" type="text"
										data-date-format="yyyy-mm-dd"/>
								</td>
								<td>
								操作人员：
								</td>
								<td>
								<input type="text" id="empName" name="empName"/>
								</td>
								<td>
									<button type="button" class="btn btn-primary btn-sm" 
										style="border-radius: 4px;" onclick="search()">查询</button>
								</td>
							</tr>
						</table>
					</div>
					<table id="log_grid" class="table table-striped table-bordered table-hover" style="margin-top: 60px">
						<thead>
							<tr>
								<th data-column-id="oper_date" data-order="desc" data-width="150px">操作时间</th>
								<th data-column-id="NAME" data-width="120px">操作人</th>
								<th data-column-id="logType" data-formatter="gender" data-width="80px">操作类型</th>
								<th data-column-id="operObj" data-width="150px">操作对象</th>
								<th data-column-id="content" data-formatter="content">操作内容</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
		<script type="text/javascript" src="plugins/JQuery/jquery-1.12.2.min.js"></script>
		<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
		<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script>
		<script type="text/javascript">
			$(function(){
			//日期框
			$('.date-picker')
					.datepicker(
							{
								format : 'yyyy-mm-dd',
								changeMonth : true,
								changeYear : true,
								showButtonPanel : true,
								autoclose : true,
								minViewMode : 0,
								maxViewMode : 2,
								startViewMode : 0,
								onClose : function(dateText, inst) {
									var year = $(
											"#span2 date-picker .ui-datepicker-year :selected")
											.val();
									$(this).datepicker('setDate',
											new Date(year, 1, 1));
								}
							});
				$("#log_grid").bootgrid({
					ajax: true,
					url:"userlog/logList.do",
					formatters:{
						gender: function(column, row){
							var value = row.logType;
							var result;
							if(value == "add"){
								result = "<fmt:message key='userlog.type.add'/>";
							}else if(value == "delete"){
								result = "<fmt:message key='userlog.type.delete'/>";
							}else if(value == "update"){
								result = "<fmt:message key='userlog.type.update'/>";
							}
							return result;
						},
						content: function(column, row){
							var str = '<span title="' + row.content + '">' + row.content + '</span>';
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
					rowCount: [10, 25, 50, 100],
					navigation:2
				});
			});
			
			//检索
			function search(){
				$("#log_grid").bootgrid("search", {
					"operObj":$("#operObj").val(), 
					"logType":$("#logType").val(),
					"selTime":$("#selTime").val(),
					"empName":$("#empName").val()
				});
			}
		</script>
	</body>
</html>