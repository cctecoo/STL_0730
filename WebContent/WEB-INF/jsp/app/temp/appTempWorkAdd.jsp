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

		<title>临时任务编辑</title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<link rel="stylesheet" href="static/css/app-style.css" />
		<link rel="stylesheet" href="static/select2/select2.min.css" />
		<!-- 引入 -->
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="static/js/jquery-form.js"></script>
		
		<style>
			#zhongxin td{height:35px;}
		    #zhongxin td label{text-align:right;}
			body {
				background: #f4f4f4;
			}
			
			.keytask table tr td {
				line-height: 1.3
			}
			 /*设置自适应框样式*/
			.test_box {
				width: 90%;
				min-height: 22px;
			    _height: 120px;
			    padding: 4px 6px; 
			    outline: 0; 
			    border: 1px solid #d5d5d5; 
			    font-size: 12px; 
			    word-wrap: break-word;
			    overflow-x: hidden;
			    overflow-y: auto;
			    _overflow-y: visible;
			}
		</style>


		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script src="static/select2/select2.min.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
		
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
					<!-- 加载Mobile文件 -->
   		<script src="plugins/appDate/js/mobiscroll.core.js"></script>
    	<script src="plugins/appDate/js/mobiscroll.frame.js"></script>
    	<script src="plugins/appDate/js/mobiscroll.scroller.js"></script>
		<script src="plugins/appDate/js/mobiscroll.util.datetime.js"></script>
    	<script src="plugins/appDate/js/mobiscroll.datetimebase.js"></script>
    	<script src="plugins/appDate/js/mobiscroll.datetime.js"></script>
    	<script src="plugins/appDate/js/mobiscroll.frame.android.js"></script>
    	<script src="plugins/appDate/js/i18n/mobiscroll.i18n.zh.js"></script>

   		 <link href="plugins/appDate/css/mobiscroll.frame.css" rel="stylesheet" type="text/css" />
    	 <link href="plugins/appDate/css/mobiscroll.frame.android.css" rel="stylesheet" type="text/css" />
    	 <link href="plugins/appDate/css/mobiscroll.scroller.css" rel="stylesheet" type="text/css" />
    	 <link href="plugins/appDate/css/mobiscroll.scroller.android.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			if("ontouchend" in document) document.write("<script src='static/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>

		<script type="text/javascript">
		$(function(){
			$("#DEPT_ID").select2();
			$("#MAIN_EMP_ID").select2();
			$("#CHECK_PERSON").select2();
		// 初始化日期框插件内容
	    	$('#START_TIME').mobiscroll().datetime({
	            theme: 'android',
	            mode: 'scroller', 
	            display: 'modal',
	            lang: 'zh',
	            dateFormat:'yyyy-mm-dd',
	            buttons:['set', 'cancel', 'clear']
	        });
	        $('#END_TIME').mobiscroll().datetime({
	            theme: 'android',
	            mode: 'scroller', 
	            display: 'modal',
	            lang: 'zh',
	            dateFormat:'yyyy-mm-dd',
	            buttons:['set', 'cancel', 'clear']
	        });
			$("#NEED_CHECK").change(function(){
				var chkflag = 0 ;
				if("0" == $("#NEED_CHECK").val()){
					$("#checkContainer").hide();
					$("#CHECK_PERSON").val("");
				} else {
					$("#checkContainer").show();
					chkflag = 1;
				}
			});
		})
		
		//检查长度是否超出
   		function checkVal(divId, inputId, length, setVal){
   			var val = $(divId).text();
   			if(val.length>length){
   				$(divId).tips({
   					side:3,
   		            msg:'长度不能超过' + length + '，请重新填写!',
   		            bg:'#AE81FF',
   		            time:1
   		        });
   				$(divId).focus();
   			}else if(setVal){
   				$(inputId).attr("value", val);
   			}
   			return val.length>length;
   		}
		
		//显示提示信息
		function showTips(id, msg){
			$(id).tips({
				'msg':msg,
				bg:'#AE81FF',
				side:3,
				time:2
			});
		}
		
		//检查输入项
		function checkCode(){
			//检查说明输入的字符是否过长
			if(checkVal('#taskNameDiv', '#TASK_NAME', 100, true)){
				return;
			}
			if(checkVal('#taskContectDiv', '#TASK_CONTECT', 500, true)){
				return;
			}
			if(checkVal('#completionDiv', '#COMPLETION', 500, true)){
				return;
			}
			
			if($("#TASK_NAME").val()==""){
				$("#TASK_NAME").focus();
				showTips("#TASK_NAME","任务名称不能为空！");
				return false;
			}
			
			if($("#START_TIME").val()==""){
				$("#START_TIME").focus();
				showTips("#START_TIME","开始时间不能为空！");
				return false;
			}
			
			if($("#END_TIME").val()==""){
				$("#END_TIME").focus();
				showTips("#END_TIME","完成时间不能为空！");
				return false;
			}
			
			if($("#COMPLETION").val()==""){
				$("#COMPLETION").focus();
				showTips("#COMPLETION","完成标准不能为空！");
				return false;
			}
			
			if($("#DEPT_ID").val()==""){
				$("#DEPT_ID").focus();
				showTips("#DEPT_ID","责任部门不能为空！");
				return false;
			}
			
		/* 	var val2 =  $("#DEPT_ID").find("option:selected").text();
			$("#DEPT_NAME").val(val2);	 */
			if($("#MAIN_EMP_ID").val()=="" || $("#MAIN_EMP_ID").val()==null){
				$("#MAIN_EMP_ID").focus();
				showTips("#MAIN_EMP_ID","责任人不能为空！");
				return false;
			}
			/*
			//检查审批人
			if($("#APPROVE_EMP_NAME")!=null && $("#APPROVE_EMP_NAME").val()==""){
				$("#APPROVE_EMP_NAME").focus();
				showTips("#APPROVE_EMP_NAME","任务审核人不能为空！");
				return false;
			}
			*/
		/* 	var val3 =  $("#MAIN_EMP_ID").find("option:selected").text();
			$("#MAIN_EMP_NAME").val(val3); */
		
			if($("#NEED_CHECK").val()==""){
				$("#NEED_CHECK").focus();
				showTips("#NEED_CHECK","是否评价不能为空！");
				return false;
			}
			
			if($("#NEED_CHECK").val()=="1"){
				if($("#CHECK_PERSON").val()==""){
					$("#CHECK_PERSON").focus();
					showTips("#CHECK_PERSON","评价人不能为空！");
					return false;
				}
			} else {
				$("#CHECK_PERSON").val("");
			}
			
			save();
		}
		
		//保存
		function save(){
			 var options = {
	             success: function(data){
	                 alert("保存成功");
	                 var url = '<%=basePath %>app_temp/goTemp.do?isService=${pd.isService}&year=${year}&KEYW=${KEYW}&KEcurrentPageYW=${currentPage}';
				 window.location.href = url;
	             },
	             error: function(data){
	                 alert("保存出错");
	             }
	         };
	         $("#Form").ajaxSubmit(options);
		}
		
		//根据部门查询人员
		function queryEmp(){
			//初始化任务
			var url = "app_temp/queryEmp.do?isService=${pd.isService}";
			var DEPT_ID = $("#DEPT_ID").val();
			
			//加载员工
			$.ajax({
				type: "POST",
				url: url,
				data: {"DEPT_ID":DEPT_ID},
				success: function(data){
					var obj = eval('(' + data + ')');
					$("#MAIN_EMP_ID").empty();
					$("#MAIN_EMP_ID").append('<option value="@">请选择</option>');
					$.each(obj.empList, function(i, emp){
						$("#MAIN_EMP_ID").append('<option value='+emp.ID+'@'+emp.EMP_NAME+'>'+emp.EMP_NAME+'</option>');
					});
				}
			});
		}
		
		//查询员工的上级领导
		function queryEmpLeader(){
			var DEPT_ID = $("#DEPT_ID").val();
			var taskEmpId = $("#MAIN_EMP_ID").val();
			$("#empTr").empty();
            $("#APPROVE_EMP_CODE").val("");
            
			//普通临时任务，选择了其它部门时或者是普通员工下达任务时显示
	        if(((DEPT_ID.split("@")[0]!='${pd.userDeptId}') || ('${pd.count}'=='0')) && ('${pd.isService}'!='1') && '${pd.superior}'!='Y' ){
	        	var deptLeaderStr = '<td><label><span style="color: red;">*</span>任务审核：</label></td>' + 
				'<td><input value="" type="text" id="APPROVE_EMP_NAME" name="APPROVE_EMP_NAME" readonly="readonly" /></td>';
				$("#empTr").append(deptLeaderStr);
				//获取选择的部门负责人
				//app_temp/findDeptLeader.do?deptId=' + DEPT_ID.split("@")[0],
	        	$.ajax({
					url: '<%=basePath%>app_temp/findEmpLeader.do?empId=' + taskEmpId.split("@")[0],
					type: "post",
					success: function(data){
						if("error"==data){
							alert("后台出错，请联系管理员！");
						}else if("nodata"==data){
							$("#APPROVE_EMP_NAME").focus();
							showTips("#APPROVE_EMP_NAME","没有获取到审核人，请联系管理员配置！");
						}else if(data.indexOf(",")>0){
							$("#APPROVE_EMP_NAME").val(data.split(",")[1]);
							$("#APPROVE_EMP_CODE").val(data.split(",")[0]);
						}
					}
				});
	        }
		}
		</script>
	</head>
<body>
	<div class="web_title">
<!-- 		<div class="back" style="top:5px">
			<a onclick="window.history.go(-1)">
			<img src="static/app/images/left.png" /></a>
		</div> -->
		临时工作新增
	</div>
		<form action="<%=basePath%>app_temp/edit.do" name="Form" id="Form" method="post">
		    <!-- 保存部分参数 -->
		    <input type="hidden" id="APPROVE_EMP_CODE" name="APPROVE_EMP_CODE" value="" readonly="readonly" />
		    <input type="hidden" name="count" value="${pd.count }"/>
		    <input type="hidden" name="isService" value="${pd.isService}"/>
		    <input type="hidden" name="superior" value="${pd.superior }"/>
		    
			<div id="zhongxin" style="width:98%; margin:0 auto; ">
			<table style="margin: 10px auto; width:98%; ">
				<tr>
					<td style="width:80px"><label><span style="color: red;">*</span>任务名称：</label></td>
					<td><input type="hidden" name="TASK_NAME" id="TASK_NAME" style="width:90%"
							placeholder="这里输入任务名称" title="任务名称" />
						<div id="taskNameDiv" class="test_box" contenteditable="true" 
							onkeyup="checkVal('#taskNameDiv', '#TASK_NAME', 100, false)">${pd.TASK_NAME}</div>
					</td>
				</tr>
				<tr>
					<td><label>任务描述：</label></td>
					<td><input type="hidden" id="TASK_CONTECT" name="TASK_CONTECT" style="width:90%" />
						<div id="taskContectDiv" class="test_box" contenteditable="true" 
							onkeyup="checkVal('#taskContectDiv', '#TASK_CONTECT', 500, false)">${pd.TASK_CONTECT}</div>
					</td>
				</tr>
				
				<tr>
				<td><label><span style="color: red;">*</span>开始时间：</label></td>
				<td>
					<input type="text" name="START_TIME" id="START_TIME" style="width:90%"
		    			data-date-format="yyyy-mm-dd hh:ii" placeholder="开始时间" >
				</td>
				</tr>
				
				<tr>
				<td>
					<label><span style="color: red;">*</span>结束时间：</label></td>
					<td>
						<input type="text" name="END_TIME" id="END_TIME" style="width:90%" 
					 		data-date-format="yyyy-mm-dd hh:ii" placeholder="结束时间" >
					</td>
				</tr>
				
				<tr>
					<td><label><span style="color: red;">*</span>完成标准：</label></td>
					<td><input type="hidden" id="COMPLETION" name="COMPLETION" style="width:90%" />
						<div id="completionDiv" class="test_box" contenteditable="true" 
							onkeyup="checkVal('#completionDiv', '#COMPLETION', 500, false)">${pd.COMPLETION}</div>
					</td>
				</tr>
				
				<tr>
					<td><label><span style="color: red;">*</span>责任部门：</label></td>
					<td>	
						<select id="DEPT_ID" name="DEPT_ID" onchange="queryEmp()" style="width:95%">
							<c:forEach items="${deptList}" var="dept" varStatus="vs">
								<option value="${dept.ID}@${dept.DEPT_NAME}">
									${dept.DEPT_NAME}
								</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				
				<tr>
					<td><label><span style="color: red;">*</span>责任人：</label></td>
					<td>
					  <select id="MAIN_EMP_ID" name="MAIN_EMP_ID" style="width:95%">
				  		<c:forEach items="${empList}" var="emp" varStatus="vs">
							<option value="${emp.ID}@${emp.EMP_NAME}">
								${emp.EMP_NAME}
							</option>
						</c:forEach>
					  </select>
					</td>
				</tr>
				<tr id="empTr"></tr>
				<tr>
					<td><label><span style="color: red;">*</span>是否评价：</label></td>
					<td>
						<select  name="NEED_CHECK" id="NEED_CHECK" data-placeholder="请选择是否评价" style="width:95%">
							<option value="">请选择是否评价</option> 
							<option value="0" >否</option> 
							<option value="1" >是</option> 
						</select>
					</td>
				</tr>
				<tr id="checkContainer" style="display: none;">
					<td><label>评价人：</label></td>
					<td>
					  <select id="CHECK_PERSON" name="CHECK_PERSON" style="width:95%">
					  	<c:forEach items="${allEmpList}" var="emp" varStatus="vs">
							<option value="${emp.ID}">${emp.EMP_NAME}</option>
						</c:forEach>
					  </select>
					  
					</td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: center;">
						<a class="btn btn-mini btn-primary" onclick="checkCode();">确定</a>
					</td>
				</tr>
			</table>
			</div>
			<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">提交中...</h4></div>
	
			<div>
				<%@include file="../footer.jsp"%>
			</div>

		</form>
	</body>
</html>