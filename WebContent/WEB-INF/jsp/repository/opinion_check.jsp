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
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<link rel="stylesheet" href="static/css/bootgrid.change.css" />
		<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
<script type="text/javascript">
	
	top.changeui();
	
	//保存
	function save(){
		if($("#roleName").val()==""){
			$("#roleName").focus();
			return false;
		}
			$("#form1").submit();
			$("#zhongxin").hide();
			$("#zhongxin2").show();
	}
	
</script>
	</head>
<body>
		<form name="form1" id="form1"  method="post">
		<input type="hidden" name="DOC_ID" id="DOC_ID" value="${pd.doc_id}"/>
		<input type="hidden" name="EMP_CODE" id="EMP_CODE" value="${pd.emp_code}"/>
			<div id="zhongxin">
			<table id="opinion_grid"
					class="table table-striped table-bordered table-hover">
				<thead>
					<tr>
						<th data-column-id="emp_name" data-width="80px">接收人</th>
						<th data-column-id="opinion" data-formatter="opinionTitle">意见</th>
						<th data-column-id="last_update_time" data-width="150px">提交意见时间</th>
					</tr>
				</thead>
			</table>
			</div>
		</form>
	
	<div id="zhongxin2" class="center" style="display:none"><img src="static/images/jzx.gif"  style="width: 50px;" /><br/><h4 class="lighter block green"></h4></div>
		<!-- 引入 -->
		<script src="static/1.9.1/jquery.min.js"></script>
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	<script type="text/javascript">
		$(function() {	
			$("#opinion_grid").bootgrid({
				ajax: true,
				url:"repository/opinionList.do?DOC_ID="+$("#DOC_ID").val(),
				formatters:{
					opinionTitle: function(column, row){
						return '<span title="' + row.opinion + '">' + row.opinion + '</span>';
					},
					substr: function(column, row){
						if(row.opinion.length>10){
							return row.opinion.substr(0,10)+"…";
						}else{
							return row.opinion;
						}
					} 
				},
				navigation:0
			});
		});
	</script>
</body>
</html>
