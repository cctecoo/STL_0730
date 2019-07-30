<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
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
    
    <title>日清</title>
    
	<meta name="description" content="overview & stats" />
	<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,minimal-ui" />
	<link href="static/css/bootstrap.min.css" rel="stylesheet" />
	<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/app-style.css"/>
	<!-- 下拉框 -->
	<link rel="stylesheet" href="static/css/chosen.css" />
	
	<link rel="stylesheet" href="static/css/ace.min.css" />
	<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
	<link rel="stylesheet" href="static/css/ace-skins.min.css" />
	
	<link rel="stylesheet" href="static/css/datepicker.css" />
	<!-- 日期框 -->
	<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<link rel="stylesheet" href="static/css/app-style.css" />
	<style>
		body {
			background: #f4f4f4;
		}
		.more {
			z-index: 999;
			width: 100%;
			display: none;
		}
		.more table tr td {
			padding-top: 5px;
			padding-bottom: 5px;
		}
		
		.keytask table tr td {
			line-height: 1.3
		}
		.dateStyle{
			color: #5BC0DE;
		}
	</style>
	<script type="text/javascript">
	
		$(document).ready(function(){
			// 初始化日期框插件内容
	    	$('#startDate').mobiscroll().date({
	            theme: 'android',
	            mode: 'scroller', 
	            display: 'modal',
	            lang: 'zh',
	            dateFormat:'yyyy-mm-dd',
	            buttons:['set', 'cancel', 'clear']
	        });
	        $('#endDate').mobiscroll().date({
	            theme: 'android',
	            mode: 'scroller', 
	            display: 'modal',
	            lang: 'zh',
	            dateFormat:'yyyy-mm-dd',
	            buttons:['set', 'cancel', 'clear']
	        });
	        var errorMsg = "${errorMsg}";
	   		if(errorMsg!=""){
	   			alert(errorMsg);
	   		}
	   		//默认加载目标任务
	   		var loadType = 'B';
	   		if(''!='${pd.loadType}'){
	   			loadType = '${pd.loadType}';
	   		}
	   		loadTask(loadType, 0);
		});
		
		//高级查询
		function searching(){
			loadTask($("#loadType").attr("value"), 0);
		}
		
		//查询-重置
		function resetting(){
			//$("#Form")[0].reset();
			$("#productCode").val("");
			$("#projectCode").val("");
			$("#startDate").val("");
			$("#endDate").val("");
			$("#productCodeStr").val("");
			$("#projectCodeStr").val("");
			$("#startDateStr").val("");
			$("#endDateStr").val("");
			$("#flowName").val("");
			$("#tempTaskName").val("");
		}
		
		//页面下滑
		$(document).scroll(function(){
			var scrollTop = 0;
		    var scrollBottom = 0;
		    var dch = getClientHeight();
		    var taskType = $("#taskType").val();
		    scrollTop = getScrollTop();
		    var productCode = $("#productCodeStr").val();
		    var projectCode = $("#projectCodeStr").val();
		    var startDate = $("#startDateStr").val();
		    var endDate = $("#endDateStr").val();
		    scrollBottom = document.body.scrollHeight - scrollTop;
	     	if(scrollBottom >= dch && scrollBottom <= (dch+10)){
		      	if($('#totalPage').val() < ($('#currentPage').val()*1+1)){
		      	  	return;
				};
		      	if(true && document.forms[0]){
		      		$("#zhongxin2").show();
					var currentPage = $('#currentPage').val()*1+1;
					var showCount = $('#showCount').val();
					loadTask($("#loadType").attr("value"), currentPage);
			  	};           
			};
		});
		
		//修改样式
		function setTabStyle(loadType){
			//设置显示的搜索项
			$(".taskTr").css('display', 'none');
			if(loadType=='B'){
				$("#productCode").parent().parent().css('display', '')
			}else if(loadType=='C'){
				$("#projectCode").parent().parent().css('display', '');
			}else if(loadType=='F'){
				$("#flowName").parent().parent().css('display', '');
			}if(loadType=='T'){
				$("#tempTaskName").parent().parent().css('display', '');
			}
			//设置选择的任务类型
			$(".web_menu a").each(function(){
				if(loadType== $(this).attr("name")){
					$(this).addClass("active");
				}else{
					$(this).removeClass("active");
				}
			});
		}
		
		//加载任务列表
		function loadTask(loadType, currentPage){
			$("#loadType").attr("value", loadType);
			//修改tab页样式
			setTabStyle(loadType);
			if('${pd.showDept}'=='1' ){//看板
				if('${pd.readTask}'=='1' && '${pd.selfDept}'=='none'){//没有所属部门
					alert("没有所属部门信息，不能查询数据");
					return;
				}else if('${pd.dataDept}'=='none'){
					alert("没有配置部门数据权限，不能查询数据");
					return;
				}
			}
			//初始化任务
			var loadTaskUrl = "app_performance/loadTask.do?loadType=" + loadType + "&currentPage=" + currentPage + "&MONTH=${pd.MONTH}";
			if('' != '${pd.showDept}'){//日清看板
				var deptCode = $("#deptCode").val();
				var empCode = $("#empCode").val();
				if(deptCode!=''){
					loadTaskUrl += '&deptCode=' + deptCode;
				}
				if(empCode!=''){
					loadTaskUrl += '&empCode=' + empCode;
				}
				loadTaskUrl += "&showDept=${pd.showDept}&deptCodeStr=${pd.deptCodeStr}";
			}else{//员工日清
				loadTaskUrl += "&empCode=${pd.empCode}";
			}
			//设置查询里面的参数
			var startDate = $("#startDate").val();
			var endDate = $("#endDate").val();
			var productCode = $("#productCode").val();
			var projectCode = $("#projectCode").val();
			var flowName = $("#flowName").val();
			var tempTaskName = $("#tempTaskName").val();
			if(startDate!=""){
				loadTaskUrl += "&startDate=" + startDate;
			}
			if(endDate!=""){
				loadTaskUrl += "&endDate=" + endDate;
			}
			if(productCode!=""){
				loadTaskUrl += "&productCode=" + productCode;
			}
			if(projectCode!=""){
				loadTaskUrl += "&projectCode=" + projectCode;
			}
			$.ajax({
				type: "POST",
				url: loadTaskUrl,
				success: function(data){
					var obj = eval('(' + data + ')');
					if(currentPage==0){
						$("#showTask").empty();
						if(obj.taskList.length==0){
							$("#showTask").append('<span>&nbsp;&nbsp;没有数据</span>');
						}
					}
					$.each(obj.taskList, function(i, task){
						apendElement(task, loadType);
					});
					$("#zhongxin2").hide();
					$('#currentPage').val(obj.page.currentPage);
					$('#totalPage').val(obj.page.totalPage);
				}
			});
		}
		
		//当月的日期设置颜色
		var nowDate = new Date();
		var nowMon = nowDate.getFullYear() + "-" + (nowDate.getMonth()+1);
		function getDateStyle(startDate){
			if(startDate.substring(0,7)==nowMon){
				return 'dateStyle';
			}else{
				return '';
			}
		}
		
		//生成任务列表数据
		function apendElement(task, loadType){
			if(loadType=='B'){//目标工作
				var appendStr = '<div class="keytask">' + 
					'<table style="width:99%">' + 
					'<tr><td class="w95">起止时间:</td><td><span><span class="' + getDateStyle(task.WEEK_START_DATE) + '">' + task.WEEK_START_DATE + '</span>' + ' 至 ' + 
					'<span class="' + getDateStyle(task.WEEK_END_DATE) + '">' + task.WEEK_END_DATE + '</span></span></td></tr>' + 
					'<tr><td>年度目标:</td><td><span>' + task.TARGET_NAME + '</span></td></tr>' + 
					'<tr><td>产品名称:</td><td><span>' + task.PRODUCT_NAME + '</span></td></tr>' + 
					'<tr><td>目标数量/金额:</td><td><span>' + task.WEEK_COUNT + task.UNIT_NAME + '</span></td></tr>' + 
					'<tr><td>实际进度:</td><td><span>' + task.actual_percent + '%</span></td></tr>' +
					'<tr><td>状态:</td><td><span>' + task.STATUS + '</span></td></tr>' + 
					'</table>' +
					'<div id="cleaner"></div>' + 
					'</div>';
				$("#showTask").append(appendStr);
			}
			if(loadType=='C'){//协同项目
				if(null==task.preTaskName){
					task.preTaskName = '';
				}
				var appendStr = '<div class="keytask">' +
				    '<table style="width:99%">' + 
				    '<tr><td class="w95">起止时间:</td><td><span><span class="' + getDateStyle(task.START_DATE) + '">' + task.START_DATE + '</span>' + ' 至 ' + 
				    '<span class="' + getDateStyle(task.END_DATE) + '">' + task.END_DATE + '</span></span></td></tr>' +
					'<tr><td class="w95">活动名称:</td><td><span>' + task.EVENT_NAME + '</span></td></tr>' + 
					'<tr><td class="w95">前置活动:</td><td><span>' + task.preTaskName + '</span></td></tr>' + 
					'<tr><td class="w95">节点名称:</td><td><span>' + task.NODE_TARGET + '</span></td></tr>' + 
					'<tr><td class="w95">项目名称:</td><td><span>' + task.PROJECT_NAME + '</span></td></tr>' + 
					'<tr><td class="w95">实际进度:</td><td><span>' + task.actual_percent + '%</span></td></tr>' +
					'<tr><td class="w95">状态:</td><td><span>' +task.STATUS + '</span></td></tr>' + 
					'</table>' +
					'<div id="cleaner"></div>' + 
					'</div>';
				$("#showTask").append(appendStr);
			}
			if(loadType=='F'){//流程工作
				if(null==task.OPERA_NODE){
					task.OPERA_NODE = '';
				}
				var appendStr = '<div class="keytask">' + 
					'<table style="width:99%">' + 
					'<tr><td class="w95">下发时间:</td><td><span class="' + getDateStyle(task.OPERA_TIME) + '">' + task.OPERA_TIME + '</span></td></tr>' + 
					'<tr><td class="w95">流程名称:</td><td><span>' + task.FLOW_NAME + '</span></td></tr>' + 
					'<tr><td class="w95">节点名称:</td><td><span>' + task.NODE_NAME + '</span></td></tr>' + 
					'<tr><td class="w95">节点层级:</td><td><span>' + task.NODE_LEVEL +'</span></td></tr>' + 
					'<tr><td class="w95">上一步节点:</td><td><span>' + task.OPERA_NODE +'</span></td></tr>' + 
					'<tr><td class="w95">上一步操作:</td><td><span>' + task.OPERA_TYPE +'</span></td></tr>' + 
					'<tr><td class="w95">状态:</td><td><span>' + task.STATUS_NAME + '</span></td></tr>' + 
					'</table>' + 
					'<div id="cleaner"></div>' + 
					'</div>';
				$("#showTask").append(appendStr);
			}
			if(loadType=='D'){//日常工作
				var appendStr = '<div class="keytask">' + 
					'<table style="width:99%">' + 
					'<tr><td class="w95">任务日期:</td><td><span class="' + getDateStyle(task.DATETIME) + '">' + task.DATETIME + '</span></td></tr>' + 
					'<tr><td class="w95">部门:</td><td><span>' + task.DEPT_NAME + '</span></td></tr>' + 
					'<tr><td class="w95">岗位:</td><td><span>' + task.GRADE_NAME + '</span></td></tr>' + 
					'<tr><td class="w95">承接人:</td><td><span>' + task.EMP_NAME + '</span></td></tr>' + 
					'<tr><td class="w95">状态:</td><td><span>' + task.STATUS + '</span></td></tr>' + 
					'</table>' +
					'<div id="cleaner"></div>' + 
					'</div>';
				$("#showTask").append(appendStr);
			}
			if(loadType=='T'){//临时任务
				if(task.NEED_CHECK == '1'){
					task.NEED_CHECK = '是';
				}else if(task.NEED_CHECK == '0'){
					task.NEED_CHECK = '否';
				}
				var appendStr = '<div class="keytask">' +
					'<table style="width:99%">' + 
					'<tr><td class="w95">起止时间:</td><td><span><span class="' + getDateStyle(task.START_TIME) + '">' + task.START_TIME + ' 至 ' + 
					'<span class="' + getDateStyle(task.END_TIME) + '">' + task.END_TIME + '</span></span></td></tr>' +
					'<tr><td class="w95">任务名称:</td><td><span>' + task.TASK_NAME + '</span></td></tr>' + 
					'<tr><td class="w95">完成标准:</td><td><span>' + task.COMPLETION + '</span></td></tr>' + 
					'<tr><td class="w95">创建人:</td><td><span>' + task.CREATE_USER + '</span></td></tr>' + 
					'<tr><td class="w95">需要评价:</td><td><span>' + task.NEED_CHECK +'</span></td></tr>' + 
					'<tr><td class="w95">状态:</td><td><span>' + task.statusName + '</span></td></tr>' + 
					'</table>' + 
					'<div id="cleaner"></div>' + 
					'</div>';
				$("#showTask").append(appendStr);
			}
	
		}
		
		//获取窗口可视范围的高度
		function getClientHeight(){   
		    var clientHeight=0;   
		    if(document.body.clientHeight&&document.documentElement.clientHeight){   
		         clientHeight=(document.body.clientHeight<document.documentElement.clientHeight)?document.body.clientHeight:document.documentElement.clientHeight;           
		    }else{   
		         clientHeight=(document.body.clientHeight>document.documentElement.clientHeight)?document.body.clientHeight:document.documentElement.clientHeight;       
		    }   
		    return clientHeight;   
		}
		
		function getScrollTop(){   
		    var scrollTop=0;   
		    scrollTop=(document.body.scrollTop>document.documentElement.scrollTop)?document.body.scrollTop:document.documentElement.scrollTop;           
		    return scrollTop;   
		}
		
		/* function openButton(){
			$(".keytask").click(function(){
				$(".dailytask_btn").hide();
				$(this).find(".dailytask_btn").show();
			});
		} */
		
	
		//查询部门员工
		function findEmp(){
			var deptId = "${pd.deptIdStr}";
			var deptVal = $("#deptCode").val();
			if(deptVal!=""){
				deptId = $("#deptCode").find("option:selected").attr("deptId");
			}
			//top.Dialog.alert("deptId=" + deptId + ", deptVal=" + deptVal);
			
			var path = "<%=basePath%>empDailyTask/findDeptEmp.do?deptId=" + deptId;
			$.ajax({
				type: "POST",
				url: path,
				async: false,
				success: function(data){
					if(data=='error'){
						alert("获取部门数据出错");
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
		
		function showDailyTask(id, type, show){
		var productCode = $("#productCode").val();
		var projectCode = $("#projectCode").val();
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		var url = "<%=basePath%>app_task/";
		var param = "&show="+show+"&productCode="+productCode+"&projectCode="+projectCode+"&startDate="+startDate+"&endDate="+endDate+"&currentPage=1&showCount=10";
		if(type==1){//目标工作
				url += "showTargetDetail.do?id=" + id + param;
		}else if(type==2){//重点协同活动
				url += "listCreativeEmpTask.do?eventId=" + id + param;
		}else if(type==3){//日常活动
				url+= "listManageEmpTask.do?manageId=" + id + param;
		}
		window.location.href = url;
		}
	</script>
  </head>
  
  <body>
	  <div>
	       <input type="hidden" id="loadType" value="${pd.loadType }" />
	       <input type="hidden" id="currentPage" value="0" />
	       <input type="hidden" id="totalPage" value="0" />
		   <div class="web_menu">
		       <a style="border-right: 1px solid #12e6d2" name="B" onclick="loadTask('B', 0);" >目标工作</a>
		       <a style="border-right: 1px solid #12e6d2" name="C" onclick="loadTask('C', 0);" >重点协同工作</a>
		       <a style="border-right: 1px solid #12e6d2" name="F" onclick="loadTask('F', 0);" >流程工作</a>
		       <a style="border-right: 1px solid #12e6d2" name="D" onclick="loadTask('D', 0);" >日常工作</a>
		       <a style="border-right: 1px solid #12e6d2" name="T" onclick="loadTask('T', 0);" >临时工作</a>
		   	   <div id="cleaner"></div>
		   </div>
		   <div id="normal" class="normal" style="width: 100%;text-align: right">
				<a class='btn btn-mini btn-primary' data-toggle="collapse" href="#searchTab"
					style="margin-top: 10px;margin-bottom:10px;">高级搜索</a>
				<a class="btn btn-mini btn-primary" href="javascript:history.go(-1)" style="margin-left: 8px;margin-right: 10px;">返回 </a>
		   </div>
		   <!-- 查询面板 -->
		   <div id="searchTab" class="panel-collapse collapse" >
		   		 <form action="app_task/listDesk.do?currentPage=1" method="post" name="Form" id="Form">
					<table style="width: 98%; margin: 5px auto;">
						<c:if test="${not empty pd.showDept}">
							<!-- 日清看板搜索项 -->
							<tr>
								<td style="width:70px; text-align: center;"><label>所在部门：</label></td>
								<td><select id="deptCode" name="deptCode" onchange="findEmp()" style="vertical-align: top;">
										<option value="" >全部</option>
										<c:forEach items="${deptList }" var="dept">
											<option value="${dept.DEPT_CODE }" deptId="${dept.DEPT_ID }"
											<c:if test="${dept.DEPT_CODE == pd.deptCode }">selected</c:if> >${dept.DEPT_NAME }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td style="width:100px"><label>任务对象：</label></td>
								<td><select name="empCode" id="empCode" data-placeholder="请选择" style="vertical-align:top;">
										<option value="">全部</option>
										<c:forEach items="${empList}" var="emp">
											<option id="emp_${emp.EMP_DEPARTMENT_ID }" deptId="${emp.EMP_DEPARTMENT_ID }" value="${emp.EMP_CODE}"
											<c:if test="${emp.EMP_CODE == pd.empCode }">selected</c:if>>${emp.EMP_NAME}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
						</c:if>
						<tr>
							<td style="width: 70px; text-align: center;"><label>开始时间:</label></td>
							<td><input type="text" name="startDate" id="startDate" class="date-picker" data-date-format="yyyy-mm-dd"
								placeholder="开始时间" value="${pd.startDate }"></td>
						</tr>
						<tr>
							<td style="text-align: center;"><label>结束时间:</label></td>
							<td><input type="text" name="endDate" id="endDate" class="date-picker" data-date-format="yyyy-mm-dd"
								placeholder="结束时间" value="${pd.endDate }"></td>
						</tr>
						<tr class="taskTr">
							<td style="width: 70px; text-align: center;"><label>产品名称:</label></td>
							<td><select id="productCode" name="productCode" data-placeholder="请选择产品" style="vertical-align: top;">
									<option value="">全部</option>
									<c:forEach items="${productList }" var="product">
										<option <c:if test="${product.PRODUCT_CODE == pd.productCode }">selected</c:if>
											value="${product.PRODUCT_CODE }">${product.PRODUCT_NAME}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr class="taskTr">
							<td style="text-align: center;"><label>项目名称:</label></td>
							<td><select id="projectCode" name="projectCode" data-placeholder="请选择项目" style="vertical-align: top;">
									<option value="">全部</option>
									<c:forEach items="${projectList}" var="project">
										<option
											<c:if test="${project.CODE == pd.projectCode }">selected</c:if>
											value="${project.CODE}">${project.NAME}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr class="taskTr">
							<td><label>流程名称:</label></td>
							<td><input id="flowName" name="flowName" value="${pd.flowName }" style="width:220px"/></td>
						</tr>
						<tr class="taskTr">
							<td><label title="临时任务名称">任务名称:</label></td>
							<td><input id="tempTaskName" name="tempTaskName" value="${pd.tempTaskName }" style="width:220px"/></td>
						</tr>
						
						<tr>
						<td colspan="2">
							<a class='btn btn-mini btn-primary' style="margin-top: 10px;margin-bottom:10px;margin-left: 220px;" onclick="searching();"
								data-toggle="collapse" href="#searchTab">查询</a>
							<a class='btn btn-mini btn-primary' style="cursor: pointer;" onclick="resetting();">重置</a>
						</td>
						</tr>
					</table>
				</form>
			</div>
			<!-- 任务列表 -->
			<div id="showTask">
			</div>
			<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">提交中...</h4></div>
			<!-- 引入菜单页 -->
			<div>
				<%@include file="../footer.jsp"%>
			</div>
	
   </div>
   <!-- 引入 -->
	<script type="text/javascript">
		window.jQuery
				|| document
						.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");
	</script>
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
	<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
	<!-- 下拉框 -->
	<script type="text/javascript"
		src="static/js/bootstrap-datepicker.min.js"></script>
	<!-- 日期框 -->
	<script type="text/javascript" src="static/js/bootbox.min.js"></script>
	<!-- 确认窗口 --> 

	<!-- 引入 -->

	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<!--提示框-->
	
	<!-- 加载Mobile文件 -->
	<script src="plugins/appDate/js/jquery-1.11.1.min.js"></script>
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
  </body>
</html>
