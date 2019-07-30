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
		<link href="static/css/style.css" rel="stylesheet" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/css/chosen.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
		<link rel="stylesheet" href="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.css" />
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<!-- 引入 -->
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
		<script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js"></script>
		<script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"></script>
		
		<style type="text/css">
			input[type="checkbox"],input[type="radio"] {
				opacity:1 ;
				position: static;
				margin-bottom:8px;
			}
		 #zhongxin td{height:60px;}
	     #zhongxin td {text-align:right; margin-right:10px;}
		</style>
	</head>
	<body>
		<form action="empTrain/save.do" name="employeeTrainForm" id="employeeTrainForm" method="post">
		<div class="tabbable tabs-below">
			<ul class="nav nav-tabs" id="menuStatus">
				<li>
				<img src="static/images/ui1.png" style="margin-top:-3px;">
				员工培训记录维护
				</li>
	
				<div class="nav-search" id="nav-search"
					style="right:5px;" class="form-search">
	
					<div style="float:left;" class="panel panel-default">
						<div>
							<a class="btn btn-mini btn-primary" onclick="checkEmp();" 
								style="float:left;margin-right:5px;">保存</a>
							<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();" 
								style="float:left;margin-right:5px;">关闭</a>
						</div>
					</div>
				</div>
			</ul>
		</div>
		<div id="zhongxin">
			<input type="hidden" name="ID" id="id" value="${empTrain.ID }" title="员工培训记录主键ID" />
			<table style="margin: 10px auto;">
				<tr>
					<td><font color="red">*</font>员工姓名：</td>
					<td>
						<input type="hidden" name="EMP_CODE" id="EMP_CODE" value="${empTrain.EMP_CODE}" title="参训人编码"/>
						<input type="text" name="EMP_NAME" id="EMP_NAME" value="${empTrain.EMP_NAME}" readonly="readonly" title="参训人"/>
					</td>
					<td>成绩</td>
					<td><input type="text" name="TRAIN_RESULT" id="TRAIN_RESULT" value="${empTrain.TRAIN_RESULT}" title="成绩"/></td>
				</tr>
				<tr>
					<td><font color="red">*</font>开始日期：</td>
					<td>
						<input type="text" name="START_DATE" class="startpicker" id="START_DATE" value="${empTrain.START_DATE}" readonly="readonly"/>
					</td>
					<td>结束日期：</td>
					<td>
						<input type="text" name="END_DATE" class="startpicker" value="${empTrain.END_DATE}" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td>详细时间：</td>
					<td colspan="3">
						<input type="text" name="TRAIN_DATE_STR" value="${empTrain.TRAIN_DATE_STR}" style="width:500px;"/>
					</td>
				</tr>
				<tr>
					<td><font color="red">*</font>讲授人：</td>
					<td>
<%-- 						<select class="chzn-select" data-placeholder="点击选择授课人" id="TRAIN_TEACHER" name="TRAIN_TEACHER" style="text-align:center">
							<option value=""></option>
							<c:forEach items="${employeeList}" var="employee" varStatus="vs">
								<option value="${employee.EMP_CODE}" <c:if test="${employee.EMP_CODE == empTrain.TRAIN_TEACHER}">selected</c:if> >
									${employee.EMP_NAME}
								</option>
							</c:forEach>
						</select> --%>
						<input type="text" name="TRAIN_TEACHER" id="TRAIN_TEACHER" value="${empTrain.TRAIN_TEACHER}" title="讲授人"/>
					</td>
					<td><font color="red">*</font>培训地点：</td>
					<td><input type="text" name="TRAIN_ADDRESS" id="TRAIN_ADDRESS" value="${empTrain.TRAIN_ADDRESS}" title="培训地点"/></td>
				</tr>
				<tr>
					<td><font color="red">*</font>培训形式：</td>
					<td><input type="text" name="TRAIN_MODE" id="TRAIN_MODE" value="${empTrain.TRAIN_MODE}" title="培训方式"/></td>
					<td>课时：</td>
					<td><input type="text" name="LESSON_PERIOD" id="LESSON_PERIOD" value="${empTrain.LESSON_PERIOD}" title="课时"/></td>
				</tr>
				<tr>
					<td><font color="red">*</font>培训内容：</td>
					<td colspan="3">
						<textarea id="TRAIN_CONTENT" name="TRAIN_CONTENT" style="width:500px" rows="4" cols="2" maxlength="255" title="培训内容">${empTrain.TRAIN_CONTENT}</textarea>
					</td>
				</tr>
				<tr>
					<td>岗位变动：</td>
					<td colspan="3">
						<textarea id="GRADE_CHANGE" name="GRADE_CHANGE" style="width:500px" rows="4" cols="2" maxlength="255" title="岗位变动">${empTrain.GRADE_CHANGE}</textarea>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green"></h4></div>
		</form>
	<script type="text/javascript">
		$(function(){
			 $(".chzn-select").chosen({
				no_results_text: "没有匹配结果",
				disable_search: false
			});
			$('.startpicker').datetimepicker({
				language:'zh-CN',
			    minView: 2,
			    format: 'yyyy.mm.dd',
			    autoclose: true
			});
		})
		
		function checkEmp(){
			if(checkInput("START_DATE","请选择培训时间")
					&&checkInput("TRAIN_TEACHER","请选择讲课人")
					&&checkInput("TRAIN_ADDRESS","请输入培训地点")
					&&checkInput("TRAIN_MODE","请输入培训方式")
					&&checkInput("TRAIN_CONTENT","请输入培训内容")){
				$("#employeeTrainForm").submit();
			}
		}
		//检查输入项
		function checkInput(id, msg){
			var input = $("#"+id).val();
			if(input == null || $.trim(input) == ""){
				$("#"+id).tips({
					side:3,
		            msg:msg,
		            bg:'#AE81FF',
		            time:2
		        });
				
				$("#"+id).focus();
				return false;
			}
			return true;
		}
	</script>
	</body>
</html>