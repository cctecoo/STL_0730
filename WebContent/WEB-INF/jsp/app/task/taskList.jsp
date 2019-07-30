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
    
    <title><c:if test="${pd.showDept==1}">日清看板</c:if><c:if test="${pd.showDept!=1}">日清工作台</c:if></title>
    
	<meta name="description" content="overview & stats" />
	<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,minimal-ui" />
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
	<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
	<link rel="stylesheet" href="<%=basePath%>plugins/font-awesome/css/font-awesome.min.css" />
	
	<!-- 下拉框 -->
	<link rel="stylesheet" href="static/css/chosen.css" />
	
	<link rel="stylesheet" href="static/css/ace.min.css" />
	<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
	<link rel="stylesheet" href="static/css/ace-skins.min.css" />
	
	<link rel="stylesheet" href="static/css/datepicker.css" />
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
		.keytask{
			width: 98%;
			padding: 0;
			margin: 0 auto;
		}
		.keytask table{
			width: 96%;
			margin: 0 auto;
		}
		.keytask table tr td {
			line-height: 2;
			word-break: break-word;
    		overflow: visible;
    		white-space: normal;
		}
		.dateStyle{
			color: #5BC0DE;
		}
		.text_grey{color:grey;}
		.btnStyle{color:#3cc0f1; border:1px solid #3cc0f1; padding:2px 4px; }
	</style>

  </head>
  <body>
	<div id="loadDiv" class="loadDivMask" >
		 <i class=" fa fa-spinner fa-pulse fa-4x"></i>
		 <h4 class="block">操作中...</h4>
	</div>	
	
	  <div>
	       <input type="hidden" id="loadType" value="${pd.loadType }" />
	       <input type="hidden" id="wxStatus" value="${pd.wxStatus }" />
	       <input type="hidden" id="currentPage" value="0" />
	       <input type="hidden" id="totalPage" value="0" />
		   <div class="web_menu">
		       
		       <div class="showlist" style="width:35%;color:#fff;float:left;padding:7px 1px; text-align:center;border-right:1px solid #12e6d2;">
		       		<span style="font-size:120%;">目标工作 </span>    <i class="fa fa-caret-down"></i>
		       	</div>
		       <div class="showlist1" style="width:35%;color:#fff;float:left;padding:7px 1px; text-align:center;">
		       		<span style="font-size:120%;">全部状态  </span>     <i class="fa fa-caret-down"></i>
		       	</div>
		       <div id="normal" class="normal" style="width: 100%;text-align: right">
		   		    <shiro:hasPermission name="listTask:add()">
						<c:if test="${addAvailable == true }">
							<a id="addTaskBtn" class="btn btn-mini btn-info" onclick="addPositionDailyTask()" style="width:10%;padding:6px 4px;">
								<i class="fa fa-plus"></i>
							</a>
						</c:if>
					</shiro:hasPermission>
					<a class='btn btn-mini btn-primary' style="width:10%;padding:6px 4px;" data-toggle="collapse" href="#searchTab">
						<i class="fa fa-search"></i>
					</a>
		   		</div>
		   		<div id="cleaner"></div>
		       	<div class="showlist_col hide" style="background:#478cd7; float: left;width: 35%;left:0%; padding: 0 1px;">
			   		<a style="width:100%; padding:6px 1px;" name="B" onclick="loadTask('B', 0);" >目标工作</a>
			       	<a style="width:100%; padding:6px 1px;" name="C" onclick="loadTask('C', 0);" >重点协同工作</a>
			       	<a style="width:100%; padding:6px 1px;" name="F" onclick="loadTask('F', 0);" >流程工作</a>
					<a style="width:100%; padding:6px 1px;" name="D" onclick="loadTask('D', 0);" >日常工作</a>
					<a style="width:100%; padding:6px 1px;" name="T" onclick="loadTask('T', 0);" >临时工作</a>
			    </div>
			    <div id="btnDiv" class="showlist1_col hide" style="background:#478cd7;left:35%; float: left;width:35%">
			    </div>
		       		
		   </div>
		   <!-- 查询面板 -->
		   <div id="searchTab" class="panel-collapse collapse" >
				<form action="app_task/listDesk.do?currentPage=1" method="post" name="Form" id="Form">
					<table style="width: 98%; margin: 5px auto;">
						<c:if test="${not empty pd.showDept}">
							<!-- 日清看板搜索项 -->
							<tr>
								<td><label>所在部门:</label></td>
								<td><select id="deptCode" name="deptCode" onchange="findEmp()" style="vertical-align: top;width:95%">
										<option value="" >全部</option>
										<c:forEach items="${deptList }" var="dept">
											<option value="${dept.DEPT_CODE }" deptId="${dept.DEPT_ID }"
											<c:if test="${dept.DEPT_CODE == pd.deptCode }">selected</c:if> >${dept.DEPT_NAME }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td><label>任务对象:</label></td>
								<td><select name="empCode" id="empCode" data-placeholder="请选择" style="vertical-align:top;width:95%">
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
							<td><label>开始时间:</label></td>
							<td><input type="text" name="startDate" id="startDate" class="date-picker" data-date-format="yyyy-mm-dd"
								placeholder="开始时间" value="${pd.startDate }" style="width:95%;height:30px;box-sizing: border-box"></td>
						</tr>
						<tr>
							<td><label>结束时间:</label></td>
							<td><input type="text" name="endDate" id="endDate" class="date-picker" data-date-format="yyyy-mm-dd"
								placeholder="结束时间" value="${pd.endDate }" style="width:95%;height:30px;box-sizing: border-box"></td>
						</tr>
						<tr class="taskTr">
							<td><label>产品名称:</label></td>
							<td><select id="productCode" name="productCode" data-placeholder="请选择产品" style="vertical-align: top;width:95%">
									<option value="">全部</option>
									<c:forEach items="${productList }" var="product">
										<option <c:if test="${product.PRODUCT_CODE == pd.productCode }">selected</c:if>
											value="${product.PRODUCT_CODE }">${product.PRODUCT_NAME}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr class="taskTr">
							<td><label>项目名称:</label></td>
							<td><select id="projectCode" name="projectCode" data-placeholder="请选择项目" style="vertical-align: top;width:95%">
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
							<td><input id="flowName" name="flowName" value="${pd.flowName }" style="width:95%"/></td>
						</tr>
						<tr class="taskTr">
							<td><label title="临时任务名称">任务名称:</label></td>
							<td><input id="tempTaskName" name="tempTaskName" value="${pd.tempTaskName }" style="width:95%"/></td>
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
			<c:choose>
				<c:when test="${not empty pd.showDept }"><!-- 看板 -->
					<input id="clickSearch" type="hidden" value="check" />
				</c:when>
				<c:otherwise>
					<input id="clickSearch" type="hidden" value="needHandle" />
				</c:otherwise>
			</c:choose>
			<!-- 任务列表 -->
			<div id="showTask">
			</div>
			
			<!-- 引入菜单页 -->
			<div>
				<%@include file="../footer.jsp"%>
			</div>
	
   </div>
   
  </body>
  
  	<!-- 引入 -->
	<script src="plugins/appDate/js/jquery-1.11.1.min.js"></script>
	<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
	<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
	<!-- 下拉框 -->
	<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script>
	<!-- 日期框 -->
	<script type="text/javascript" src="static/js/bootbox.min.js"></script>
	<!-- 确认窗口 --> 

	<!-- 引入 -->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<!--提示框-->
	
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
	   		//加载任务
	   		loadTask(loadType, 0);
	   		//初始化任务状态
	   		initClickDivEvent();
		});
		var initLoad = true;//标识初始化加载任务
		
		//高级查询
		function searching(){
			loadTask($("#loadType").attr("value"), 0);
		}
		
		//点击进行查询
	    function clickSearch(value, ele){
	    	var taskname = $(ele).html();
			//设置背景颜色
			$(".showlist1_col a").removeClass("active");
			$(ele).addClass("active");
			$(".showlist1 span").html(taskname);
			//设置点击查询
	    	$("#clickSearch").val(value);
	    	searching();
	    }
		
		//查询-重置
		function resetting(){
			//$("#Form")[0].reset();
			$("#deptCode").val("");
			$("#empCode").val("");
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
		      		$("#loadDiv").show();
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
			$("#addTaskBtn").css('display','none');
			if(loadType=='B'){
				$("#productCode").parent().parent().css('display', '')
			}else if(loadType=='C'){
				$("#projectCode").parent().parent().css('display', '');
			}else if(loadType=='F'){
				$("#flowName").parent().parent().css('display', '');
			}if(loadType=='T'){
				$("#tempTaskName").parent().parent().css('display', '');
			}if(loadType=='D'){
				$("#addTaskBtn").css('display','inline-block');
			}
			//设置选择的任务类型
			$(".showlist_col > a").each(function(){
				if(loadType== $(this).attr("name")){
					$(this).addClass("active");
					$(".showlist span").html($(this).text());
				}else{
					$(this).removeClass("active");
				}
			});
		}
		
		//设置点击查询按钮
		function setClickBtn(loadType){
			var btnDivHtml = "";
			//设置点击加载的默认值
			if('${pd.showDept}'=='1' ){//看板
				$("#clickSearch").val("check");
			}else{//工作台
				$("#clickSearch").val("needHandle");
			}
			//定义状态按钮
			var nowBtn = '<a name="now" id="now" style="width:100%; padding:6px 1px;" ' +
				'onclick="clickSearch(\'now\',this);" >前后3周工作</a>';
			var needHandleBtn = '<a name="needHandle" id="needHandle" style="width:100%; padding:6px 1px;" ' + 
				'onclick="clickSearch(\'needHandle\', this);" title="到下周日为止">进行中</a>';
			var checkBtn = '<a name="check" id="check" style="width:100%; padding:6px 1px;" ' + 
				'onclick="clickSearch(\'check\', this);" title="有未审核的日清">待审核/待评价</a>';
			var endedBtn = '<a name="ended" id="ended" style="width:100%; padding:6px 1px;" ' + 
				'onclick="clickSearch(\'ended\', this);" >已完成/已评价</a>';
			var allBtn = '<a name="all"  id="all" style="width:100%; padding:6px 1px;" ' + 
				'onclick="clickSearch(\'all\', this);">全部</a>';
			var handledBtn = '<a name="handled" id="handled" style="width:100%; padding:6px 1px;" ' + 
				'onclick="clickSearch(\'handled\', this);">已转交</a>';
			var jointCheckedBtn = '<a name="jointChecked" id="jointChecked" style="width:100%; padding:6px 1px;" ' + 
				'onclick="clickSearch(\'jointChecked\', this);">已会签</a>';
			//拼接任务状态按钮组
			btnDivHtml +=  nowBtn + needHandleBtn;
			if(loadType=='B' || loadType=='C' || loadType=='D' || loadType=='T'){//目标工作
				btnDivHtml +=  checkBtn + endedBtn;
			}else if(loadType=='F'){//流程工作
				btnDivHtml +=  handledBtn + endedBtn;
				if('${pd.showDept}'!='1' ){//工作台
					btnDivHtml += jointCheckedBtn;
				}
			}
			btnDivHtml += allBtn;
			//重新设置点击查询按钮
			$("#btnDiv").empty();
			$("#btnDiv").append(btnDivHtml);
			//设置点击加载的默认值
			if('${pd.clickSearch}'!='' ){
				$("#clickSearch").val('${pd.clickSearch}');
			}else{
				if('${pd.showDept}'=='1' ){//看板
					$("#clickSearch").val("check");
					if(loadType=='F'){//流程在看板里默认显示全部
						$("#clickSearch").val("all");
					}
				}else{
					$("#clickSearch").val("needHandle");
				}
			}
			//设置按钮的显示文本
			if(loadType=='F'){
				$("#btnDiv").find("[name='now']").attr('title', '最近7天工作').text('最近7天工作');
				$("#btnDiv").find("[name='needHandle']").attr('title', '未接收或未转交').text('待处理');
				$("#btnDiv").find("[name='ended']").text('已结束流程');
			}
			if(loadType=='D'){
				$("#btnDiv").find("[name='now']").attr('title', '最近7天工作').text('最近7天工作');
				$("#btnDiv").find("[name='needHandle']").text('待提交');
			}
			//设置状态按钮的样式
			$("#btnDiv").find("[name='"+$("#clickSearch").val()+"']").addClass("active");
			//$(".showlist1 span").html($(".showlist1_col a .active").html());
			//设置选择的任务类型
			$("#btnDiv > a").each(function(){
				if($(this).hasClass("active")){
					$(".showlist1 span").html($(this).html());
				}
			});
		}
		
		//加载任务列表
		function loadTask(loadType, currentPage){
			if(loadType != $("#loadType").attr("value") || initLoad){
				//设置点击查询
				setClickBtn(loadType);
				initLoad = false;
				$("#loadType").attr("value", loadType);
				//修改tab页样式
				setTabStyle(loadType);
			}
			//检查权限
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
			var loadTaskUrl = "app_task/loadTask.do?currentUser=${pd.currentUser}&loadType=" + loadType + "&currentPage=" + currentPage + 
					"&checkEmpCode=${pd.checkEmpCode}&selfDeptCode=${pd.selfDeptCode}";
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
			if(flowName!=""){
				loadTaskUrl += "&flowName=" + flowName;
			}
			if(tempTaskName!=""){
                loadTaskUrl += "&tempTaskName=" + tempTaskName;
            }
			//工作状态查询			
			var clickSearch = $("#clickSearch").val();
			if($("#wxStatus").val()!=null&&$("#wxStatus").val()!="")
			{
				clickSearch = $("#wxStatus").val();			
				var taskname = $("#ended").html();
				//alert(taskname);
				//设置背景颜色
				$(".showlist1_col a").removeClass("active");
				$("#ended").addClass("active");
				$(".showlist1 span").html(taskname);
				$("#wxStatus").val("");
			}
			if(clickSearch!=""){
                loadTaskUrl += "&clickSearch=" + clickSearch;
            }
			//加载前显示
			$("#loadDiv").show();
			$.ajax({
				type: "POST",
				url: loadTaskUrl,
				success: function(data){
					var obj = eval('(' + data + ')');
					if(currentPage==0){
						$("#showTask").empty();
						if(obj.taskList.length==0){
							$("#showTask").append('<span>没有数据</span>');
						}
					}
					$.each(obj.taskList, function(i, row){
						apendElement(row, loadType);
					});
					$("#loadDiv").hide();
					$('#currentPage').val(obj.page.currentPage);
					$('#totalPage').val(obj.page.totalPage);
				}
			});
		}
		
		//当月的日期设置颜色
		var nowDate = new Date();
		var nowMon = nowDate.getFullYear() + "-" + (nowDate.getMonth()+1);
		function getDateStyle(startDate){
			
			if(startDate && startDate.substring(0,7)==nowMon){
				return 'dateStyle';
			}else{
				return '';
			}
		}
		
		//临时工作-确认完成
		function complete(Id, needCheck){
			$.ajax({
				url: '<%=basePath%>app_task/checkTempTaskIsdeleteByDetailId.do?ID='+Id,
				type: 'post',
				success: function(data){
					if("Y"==data){
						alert('任务已删除！请刷新页面');
					}else{
						window.location.href = '<%=basePath%>/app_task/toTempTask.do?ID=' + Id + '&NEED_CHECK=' + needCheck + "&showDept=${pd.showDept}";
					}
				}
			});
		}
		
		//跳转到日清,type=1:目标工作, type=2:协同项目, type=3:岗位日常; show=1:查看, show=2:员工日清, show=3:日清批示
		function showDailyTask(id, type, show){
			//保存搜索的参数
			var param = "";
			if($("#startDate").val()!=''){
				param += "&startDate=" + $("#startDate").val();
			} 
			if( $("#endDate").val()!=''){
				param += "&endDate=" + $("#endDate").val();
			}
			if( $("#productCode").val()!=''){
				param += "&productCode=" + $("#productCode").val();
			}
			if( $("#projectCode").val()!=''){
				param += "&projectCode=" + $("#projectCode").val();
			}
			if( $("#flowName").val()!=''){
				param += "&flowName=" + $("#flowName").val();
			}
			if( $("#tempTaskName").val()!=''){
				param += "&tempTaskName=" + $("#tempTaskName").val();
			}
			param += "&show=" + show + "&showDept=${pd.showDept}&loadType=" + $("#loadType").val();
			//保存日清工作台参数
			if(show==3){
				param += "&deptCode=" + $("#deptCode").val() + "&empCode=" + $("#empCode").val();
			}else{
				param +="&empCode=${pd.empCode}";
			}
			//保存页数
			param += "&currentPage=" + $("#currentPage").val();
			//拼接请求路径
			var url = "<%=basePath%>app_task/";
			if(type==1){//周工作
				url += "listBusinessEmpTask.do?weekEmpTaskId=" + id + param;
			}else if(type==2){//创新活动
				url += "listCreativeEmpTask.do?eventId=" + id + param;
			}else if(type==3){//行政活动
				url+= "empDailyTaskInfo.do?manageId=" + id + param;
			}else{
				alert("未知的任务类型，无法查看");
				return ;
			}
			window.location.href = url;
		}
		
		//返回流程的节点名称
		function getNode(row){
			var str = "";
			if(row.LATE=="true" && row.FLOW_STATUS_NAME!='已终止'){
				//增加提示图标
				str += '<span class="fa fa-clock-o" style="color: #f55273; font-size:16px" onclick="showTips(this, \'超过1天没有接收\')"></span>';
			}
			if(row.STATUS_NAME == '已完毕'){
				return '<a style="cursor:pointer; color:orange;font-size:14px" onclick="showNodeDetail(\'' + row.ID +'\');">' + row.NODE_NAME + '</a>';
			}else{
				return str + '<span style="color:orange;font-size:14px">' + row.NODE_NAME + '</span>';
			}
		}
		
		//返回操作按钮
		function getCommand(row, loadType){
			var showType = 1 ;
			if(loadType=='C'){
				showType = 2;
			}else if(loadType=='D'){
				showType = 3;
			}
			if(''=='${pd.showDept}'){//员工查看和日清
				if(loadType=='T'){//临时工作
					return 	'<a style="cursor:pointer;line-height:1.5;" title="日清" onclick="complete(\'' + row.ID +'\',\'' + row.NEED_CHECK +'\');" ' + 
						'class="btnStyle" data-rel="tooltip" data-placement="left">日清</a>';
				}else if(loadType=='F'){//流程工作
					//返回操作按钮
					var btnStr = '';
					//会审按钮
					var jointCheckupBtn = '<a style="cursor:pointer; margin-left:2px;" title="会审" onclick="handleFlowTask(' + row.ID + ', ' + row.FLOW_ID + ', \'jointCheckup\',' + row.SCORE + ');" ' + 
					'class="btn btn-mini btn-warning" data-rel="tooltip" data-placement="left">会审</a>';
					//拼接操作按钮
					if(row.FLOW_STATUS_NAME=='已终止'){
						btnStr += '流程已结束';
					}else{
						//定义操作按钮
						var receiveBtn = '<a style="cursor:pointer; margin-left:2px;" title="接收" onclick="handleFlowTask(' + row.ID + ', ' + row.FLOW_ID + ', \'receive\',' + row.SCORE + ');" ' + 
							'class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">接收</a>';
						var backBtn = '<a style="cursor:pointer; margin-left:2px;" title="退回" onclick="handleFlowTask(' + row.ID + ', ' + row.FLOW_ID + ', \'back\',' + row.SCORE + ');" ' +
							'class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">退回</a>';
						var nextBtn = '<a style="cursor:pointer; margin-left:2px;" title="下一步" onclick="handleFlowTask(' + row.ID + ', ' + row.FLOW_ID + ', \'next\',' + row.SCORE + ');" ' + 
							'class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">转交</a>'
						var endBtn = '<a style="cursor:pointer; margin-left:2px;" title="结束" onclick="handleFlowTask(' + row.ID + ', ' + row.FLOW_ID + ', \'end\',' + row.SCORE + ');" ' + 
							'class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">结束</a>';
						var cancelBtn = '<a style="cursor:pointer; margin-left:2px;" title="撤回" onclick="handleFlowTask(' + row.ID + ', ' + row.FLOW_ID + ', \'cancel\',' + row.SCORE + ');" ' + 
							'class="btn btn-mini btn-warning" data-rel="tooltip" data-placement="left">撤回</a>';
						
						if('${pd.currentUser}'==row.EMP_CODE){//责任人是登陆人的才可以进行流程的操作
							if(row.STATUS_NAME=='已生效'){
								btnStr += receiveBtn;
								if(row.NODE_LEVEL>1){//第一步之后才能退回
									btnStr += backBtn;
								}
							}else if(row.STATUS_NAME=='已接收'){
								if(row.NODE_LEVEL<row.maxLevel){//最后一步之前可以选择下一步
									btnStr += nextBtn;
								}
								btnStr += backBtn + endBtn;
							}else if(row.STATUS_NAME=='已退回' || row.STATUS_NAME=='已撤回'){
								btnStr += receiveBtn;
							}else if(row.STATUS_NAME=='已完毕' && row.nextNodeStatus=='YW_YSX'){
								btnStr += cancelBtn;
							}
						}
					}
					//会审
					if('${pd.currentUser}'==row.CHECKUP_EMP_CODE && row.OPINION_TYPE==null){//会审人是登陆人的，只能填写意见
						btnStr += jointCheckupBtn;
					}
					
					return btnStr;
				}else{//目标工作，项目工作，日常工作
					if(row.STATUS=='已完毕' || row.STATUS=='已评价'){
						return '<a style="cursor:pointer;" title="查看日清" onclick="showDailyTask(' + row.ID + ', ' + showType + ', 1)" ' + 
							'class="btnStyle" data-rel="tooltip" data-placement="left">查看日清<i class="fa fa-eye"></i></a>';
					}else if(row.STATUS=='已生效'){
						//项目工作，前置活动没完成则不能进行日清
						if(loadType=='C' && null!=row.RELATEEVENTS && ''!=row.RELATEEVENTS && row.preTask_percent<'100'){
							return '<a style="cursor:pointer;line-height:1.5;" title="日清" onclick="javascript: alert(\'前置活动任务[' + row.preTaskName + ']未完成\')"' + 
								'class="btnStyle" data-rel="tooltip" data-placement="left">日清</a>';
						}else{
							return '<a style="cursor:pointer;line-height:1.5;" title="日清" onclick="showDailyTask(' + row.ID + ', ' + showType + ', 2)" ' +
								'class="btnStyle" data-rel="tooltip" data-placement="left">日清</a>';
						}
					}else if(loadType=='D' && (row.STATUS=='草稿'||row.STATUS=='已退回')){//日常任务-草稿状态
						return '<a style="cursor:pointer;line-height:1.5;" title="日清" onclick="showDailyTask(' + row.ID + ', ' + showType + ', 2)" ' +  
							'class="btnStyle" data-rel="tooltip" data-placement="left">日清</a>';
					}else{
						return '';
					}
				}
			}else{//日清看板
				var btnText = "查看日清";
				if(loadType=='T'){//临时工作
					if('${pd.currentUser}'==row.CHECK_PERSON_CODE && row.statusName=='已完毕'){
						btnText = "评价工作";
					}
					//返回操作按钮
					if(row.statusName=='已完毕' || row.statusName=='已评价'){
						return 	'<a style="cursor:pointer;" title="' + btnText + '" onclick="complete(\'' + row.ID +'\',\'' + row.NEED_CHECK +'\');" ' + 
							'class="btnStyle" data-rel="tooltip" data-placement="left">' + btnText + '<i class="fa fa-book"></i></a>';
					}
				}else{//其他任务
					var show = 1;
					if(loadType=='C'){//重点协同工作
						if(row.STATUS!='已评价' && '${pd.currentUser}'==row.CHECK_EMP_CODE){
							show = 3;
							if(row.finish_percent!=row.actual_percent){
								btnText = "审核活动";
							}else if(row.actual_percent==100){
								btnText = "评价活动";
							}
						}
					}else if(loadType=='D'){//日常工作
						if(row.STATUS!='已评价' && '${pd.currentUser}'==row.SCOREPERSON){
							btnText = "审核工作";
							show = 3;
							if(row.STATUS=='已完毕'){
								btnText = "评价工作";
							}
						}
					}else{//目标工作
						if(row.STATUS=='已生效' && '${pd.currentUser}'==row.CHECK_EMP_CODE){
							btnText = "员工日清";
							show = 3;
						}else{
							btnText = "查看日清";
							show = 1;
						}
						/*
						//普通员工查看本部门工作页面;自己也只能查看日清，领导中没有配置岗位等级，或者不是员工上级领导的只能查看
						if('${pd.readTask }' == '1' || '${selfEmpCode}'==row.EMP_CODE || '${pd.positionLevel}'=='' || '${pd.positionLevel}'>=row.JOB_RANK ){
							btnText = "查看日清";
							show = 1;
						}else{//领导查看下属部门工作页面
							btnText = "员工日清";
							show = 3;
						}
						*/
					}
					//返回操作按钮
					if(row.STATUS=='已完毕' || row.STATUS=='已生效' || row.STATUS=='已评价'){
						return '<a style="cursor:pointer;" title="' + btnText + '" onclick="showDailyTask(' + row.ID + ',' + showType + ' , ' + show + ')" ' + 
							'class="btnStyle" data-rel="tooltip" data-placement="left">' + btnText + '<i class="fa fa-book"></i></a>';
					}
				}
				return '';
			}
		}
		
		//状态
		function getStatusName(row, loadType){
			var statusColor = '';
			var name = '';
			if(loadType=='C'){
				if(row.STATUS=='已生效' && null!=row.SCORE && row.SCORE!=''){
					row.STATUS = '已评价';
				}
				return '<span>' + row.STATUS + '</span>';
			}else if(loadType=='F'){
				name = row.STATUS_NAME;
				//流程工作
				if(row.STATUS_NAME=='已生效'){
					statusColor = 'orange';
					name = '未接收';
				}else if(row.STATUS_NAME=='已接收'){
					statusColor = 'lightblue';
				}else if(row.STATUS_NAME=='已完毕'){
					statusColor = 'green';
					name = '已转交';
				}else if(row.STATUS_NAME=='已退回' || row.STATUS_NAME=='已撤回'){
					statusColor = 'red';
				}
			}else if(loadType=='D'){
				name = row.STATUS;
				//日常工作
				if(name=='草稿'){
					statusColor = 'green';
				}else if(name=='已生效'){
					statusColor = 'lightblue';
				}else if(name=='已审核'){
					statusColor = 'orange';
				}
			}else if(loadType=='T'){
				name = row.statusName;
				//临时工作
				if(name == '已生效'){
					statusColor = 'green';
				}else if(name == '已完毕'){
					statusColor = 'lightblue';
				}else if(name == '已评价'){
					statusColor = 'orange';
				}else if(name=='已退回'){
					statusColor = 'red';
				}
			}
			var statusStr = '<span style="color:' + statusColor + ';font-weight: bold;">' + name + '</span>';
			if( ''!='${pd.showDept}' && loadType=='F' && row.FLOW_STATUS_NAME=='已终止' ){
				statusStr = '<span style="color:' + statusColor + ';font-weight: bold;">' + name + '-流程结束</span>'
			}
			return statusStr;
		}
		
		//改变逾期扣分
		function changeScore(row){
			if(row.STATUS_NAME!='已完毕'&&row.FLOW_STATUS_NAME!='已终止'){
				var score = row.SCORE;
				score = score.substring(1);	
				return score;
			}else{
				return '0';
			}
		}
		
		//提示
		function showTips(ele, text){
			$(ele).tips({
				side:3,
	            msg:text,
	            bg:'#AE81FF',
	            time:1
	        });
		}
		
		//进度条
		function getProgressBar(progressStyle, width, barStyle){
			var barWidth = width;
			if(barWidth>100){
				barWidth = 100;
			}
			return '<div class="progress ' + progressStyle + '" style="height:20px; margin:0px;' +
				' background-color: #dadada; border: 1px solid #ccc;">' + 
				'<div class="progress-bar ' + barStyle + '" role="progressbar" aria-valuenow="60" aria-valuemin="0" ' +
				'aria-valuemax="100" style="width: ' +barWidth + '%; text-align: center">' + 
				'<span style="color: black">' + width + '%</span></div></div>';
		}
		
		//生成任务列表数据
		function apendElement(row, loadType){
			if(loadType=='B'){//目标工作
				//返回的任务列表
				var appendStr = '<div class="keytask"><div><table>';
				appendStr += '<tr style="color:grey"><td style="width:20%"><span >起止时间:</span></td><td colspan="3"><span><span class="' + getDateStyle(row.WEEK_START_DATE) + '">' + 
					row.WEEK_START_DATE + '</span>' + ' 至 ' + '<span class="' + getDateStyle(row.WEEK_END_DATE) + '">' + row.WEEK_END_DATE + '</span></span></td></tr>'; 
				appendStr +='<tr><td style="width:20%"><span>年度目标:</span></td><td colspan="3"><span style="color:orange;font-size:14px">';
				//增加提示图标
				if(row.actual_percent < row.plan_percent && row.WEEK_COUNT!=0){//进度滞后
					appendStr += '<span class="fa fa-star-o" style="color: #f55273; font-size:16px" onclick="showTips(this, \'实际进度落后于计划\')"></span>';
				}
				appendStr += row.TARGET_NAME + '</span></td></tr>';
				appendStr += '<tr><td><span >产品名称:</span></td><td colspan="3"><span style="color:black">' + (row.PRODUCT_NAME==undefined? '':row.PRODUCT_NAME) + '</span></td></tr>';
				//appendStr += '<tr><td><span >目标数量/金额:</span></td><td><span>' + row.WEEK_COUNT + row.UNIT_NAME + '</span></td></tr>'; 
				appendStr += '<tr><td><span >计划进度:</span></td><td colspan="3"><span>' + 
					getProgressBar('progress-striped', row.plan_percent, 'progress-bar-info') + '</span></td></tr>';
				//设置进度条
				var barStyle = 'progress-bar-success';//进度条样式
				if(row.actual_percent < row.plan_percent){//实际进度小于计划进度，进度条样式改为‘警告’
					barStyle = 'progress-bar-warning';
				}
				appendStr += '<tr><td><span>实际进度:</span></td><td  colspan="3"><span>' + getProgressBar('', row.actual_percent, barStyle) + '</span></td></tr>';
				if('${pd.showDept}'!=''){
					appendStr += '<tr><td><span >承接人:</span></td><td colspan="3"><span>' + row.EMP_NAME + '</span><span style="margin-left:3px">' + row.DEPT_NAME + '</span></td></tr>';
				}
				appendStr += '<tr><td><span >状态:</span></td><td><span>' + row.STATUS + '</span></td><td colspan="2" style="text-align:right">' + getCommand(row, loadType) + '</td></tr>'; 
				appendStr += '</table></div></div>';
				$("#showTask").append(appendStr);
			}
			if(loadType=='C'){//协同项目
				if(null==row.preTaskName){
					row.preTaskName = '';
				}
				var appendStr = '<div class="keytask">' +
				    '<div><table>' + 
				    '<tr><td style="width:70px">起止时间:</td><td colspan="3"><span><span class="' + getDateStyle(row.START_DATE) + '">' + row.START_DATE + '</span>' + ' 至 ' + 
				    '<span class="' + getDateStyle(row.END_DATE) + '">' + row.END_DATE + '</span></span></td></tr>' +
					'<tr><td>活动名称:</td><td colspan="3"><span style="color:orange;font-size:14px">';
				//增加提示图标
				if(row.actual_percent < row.plan_percent && row.STATUS!='已终止'){//进度滞后
					appendStr += '<span class="fa fa-star-o" style="color: #f55273; font-size:16px" onclick="showTips(this, \'实际进度落后于计划\')"></span>';
				}
				appendStr += row.EVENT_NAME + '</span></td></tr>' + 
					//'<tr><td>前置活动:</td><td colspan="3"><span>' + row.preTaskName + '</span></td></tr>' + 
					'<tr><td>节点名称:</td><td colspan="3"><span style="color:black">' + row.NODE_TARGET + '</span></td></tr>' + 
					'<tr><td>项目名称:</td><td colspan="3"><span style="color:black">' + row.PROJECT_NAME + '</span></td></tr>';
				appendStr += '<tr><td><span >计划进度:</span></td><td colspan="3"><span>' +
				getProgressBar('progress-striped', row.plan_percent, 'progress-bar-info') + '</span></td></tr>';
				//设置进度条
				var barStyle = 'progress-bar-success';//进度条样式
				if(row.actual_percent < row.plan_percent){//实际进度小于计划进度，进度条样式改为‘警告’
					barStyle = 'progress-bar-warning';
				}
				appendStr += '<tr><td>实际进度:</td><td colspan="3"><span>' + getProgressBar('', row.actual_percent, barStyle) + '</span></td></tr>';
				if('${pd.showDept}'!=''){
					appendStr += '<tr><td>承接人:</td><td colspan="3"><span>' + row.EMP_NAME + '</span><span style="margin-left:3px">' + row.DEPT_NAME + '</span></td></tr>';
				}
				appendStr += '<tr><td>状态:</td><td><span>' +row.STATUS + '</span></td><td colspan="2" style="text-align:right">' + getCommand(row, loadType) + '</td></tr>' + 
					'</table></div></div>';
				$("#showTask").append(appendStr);
			}
			if(loadType=='F'){//流程工作
				if(null==row.OPERA_NODE){
					row.OPERA_NODE = '';
				}
				var appendStr = '<div class="keytask">' + 
					'<table>' + 
					'<tr><td style="width:20%">下发时间:</td><td colspan="3"><span class="' + getDateStyle(row.OPERA_TIME) + '">' + row.OPERA_TIME + '</span></td></tr>' + 
					'<tr><td colspan="4"><a style="cursor:pointer;color:#1685d4;" onclick="showFlowDetail(\'' + row.FLOW_ID +'\');">' + row.FLOW_NAME + '</a></td></tr>' + 
					'<tr><td>节点名称:</td><td colspan="3">'+ getNode(row) + '</td></tr>' + 
					'<tr><td>节点层级:</td><td colspan="3"><span>' + row.NODE_LEVEL +'</span></td></tr>' + 
					//'<tr><td>上一步节点:</td><td colspan="4"><span>' + row.OPERA_NODE +'</span></td></tr>' + 
					//'<tr><td>上一步操作:</td><td colspan="4"><span>' + row.OPERA_TYPE +'</span></td></tr>'
					'';
				if('${pd.showDept}'!=''){
					appendStr += '<tr><td>承接人:</td><td  colspan="3"><span>' + row.EMP_NAME + '</span>' + 
						'<span style="margin-left:5px;">' + row.DEPT_NAME + '</span></td></tr>';
				}
				//appendStr +='<tr><td>逾期扣分:</td><td>' + changeScore(row) + '</td></tr>'; 
				appendStr +='<tr><td>状态:</td><td>' + getStatusName(row, loadType) + '</td>' + 
					'<td colspan="2" style="text-align:right">' + getCommand(row, loadType) + '</td></tr>' + 
					'</table></div>';
				$("#showTask").append(appendStr);
			}
			if(loadType=='D'){//日常工作
				var appendStr = '<div class="keytask">' + 
					'<table>' + 
					'<tr><td>任务日期:</td><td colspan="3"><span class="' + getDateStyle(row.DATETIME) + '">' + row.DATETIME + '</span></td></tr>' + 
					'<tr><td>承接人:</td><td colspan="3"><span>' + row.EMP_NAME + '</span>' + 
					'<span style="margin-left:5px;">' + row.DEPT_NAME + '</span></td></tr>' + 
					'<tr><td>岗位:</td><td colspan="3"><span>' + row.GRADE_NAME + '</span></td></tr>' + 
					'<tr><td>状态:</td><td>' + getStatusName(row, loadType) + '</td>' + 
					'<td colspan="2" style="text-align:right">' + getCommand(row, loadType) + '</td></tr>' + 
					'</table></div>';
				$("#showTask").append(appendStr);
			}
			if(loadType=='T'){//临时任务
				if(row.NEED_CHECK == '1'){
					row.needCheck = '是';
				}else if(row.NEED_CHECK == '0'){
					row.needCheck = '否';
				}
				var appendStr = '<div class="keytask">' +
					'<table>' + 
					'<tr><td style="width:25%">任务名称:</td><td colspan="3"><span style="color:orange;font-size:14px">';
				if( row.statusName=='已生效' && (nowDate.getTime() > (new Date(row.END_TIME)).getTime()) ){
					appendStr += '<span class="fa fa-clock-o" style="color: #f55273; font-size:16px" onclick="showTips(this, \'超出任务结束时间\')"></span>';
				}
				appendStr += row.TASK_NAME + '</span></td></tr>' + 
					'<tr><td colspan="4"><span><span class="' + getDateStyle(row.START_TIME) + '">' + row.START_TIME + ' 至 ' + 
					'<span class="' + getDateStyle(row.END_TIME) + '">' + row.END_TIME + '</span></span></td></tr>' +
					'<tr><td>完成标准:</td><td colspan="3"><span>' + row.COMPLETION + '</span></td></tr>' + 
					'<tr><td>创建人:</td><td colspan="3"><span>' + row.CREATE_USER + '</span>';
				var taskType = "常规类";
				if(row.isService == '1'){
					taskType = "服务类"
				}	
				appendStr += '<span style="margin-left:5px">' + taskType + '</span></td></tr>';
				
				appendStr += '<tr><td>需要评价:</td><td colspan="3"><span>' + row.needCheck +'</span></td></tr>';
				if('${pd.showDept}'!=''){
					appendStr += '<tr><td>承接人:</td><td colspan="3"><span>' + row.EMP_NAME + '</span>'+
					   '<span style="margin-left:5px">' + row.DEPT_NAME + '</span></td></tr>';
				}
				appendStr += '<tr><td>状态:</td><td>' +  getStatusName(row, loadType) + '</td>' + 
					'<td colspan="2" style="text-align:right">' + getCommand(row, loadType) + '</td></tr>' + 
					'</table></div>';
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
	
		//查询部门员工
		function findEmp(){
			var deptId = "${pd.deptIdStr}";
			var deptVal = $("#deptCode").val();
			if(deptVal!=""){
				deptId = $("#deptCode").find("option:selected").attr("deptId");
			}
			//alert("deptId=" + deptId + ", deptVal=" + deptVal);
			
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
		
		//处理流程工作
		function handleFlowTask(nodeId, flowId, handleType, score){
			if('receive'==handleType){
				$.ajax({
					type: 'POST',
					url: '<%=basePath%>app_task/findSubFlowModel.do',
					data: {"nodeId" : nodeId},
					dataType: 'text',
					success: function(data){
						if("error"==data){
							alert("查询节点下对应的子流程出错");
						}else{
							if("0"==data){
								if(confirm("确认接收?")){
									$.ajax({
										type: 'POST',
										url: '<%=basePath%>app_task/receiveFlowWork.do',
										data: {"nodeId":nodeId, "flowId":flowId, "handleType":handleType, "score" : score},
										dataType: 'text',
										success: function(data){
											if("success"==data){
												//alert("已接收");
												var currentPage = $('#currentPage').val()*1+1;
												$("#showTask").empty();
												loadTask("F", currentPage);
											}else{
												alert("接收出错");
											}
										}
									});
								}
							}else{
								showHandleDialog(nodeId, flowId, handleType, score);
							}
						}
					}
				});
			}else if('cancel'==handleType){//撤回操作
				if(confirm("确定撤回？")){
					$.ajax({
						type: 'post',
						url: '<%=basePath%>app_task/recallFlowWork.do',
						data: {"nodeId":nodeId, "flowId":flowId, "handleType":handleType, "score" : score},
						dataType: 'text',
						success: function(data){
							if("noData"==data){
								alert("没有查询到节点数据！");
							}else if("nodeStatusError"==data){
								alert("当前节点状态不能撤回！");
							}else if("nextNodeStatusError"==data){
								alert("下一节点状态不能撤回！");
							}else if("flowStatusError"==data){
								alert("流程状态为已终止，不能撤回！");
							}else if("success"==data){
								var currentPage = $('#currentPage').val()*1+1;
								$("#showTask").empty();
								loadTask("F", currentPage);
							}else if("error"==data){
								alert("后台出错，请联系管理员！");
							}
						}
					});
				}
			}else{
				showHandleDialog(nodeId, flowId, handleType, score);
			}
		}
		
		//处理流程工作
		function showHandleDialog(nodeId, flowId, handleType, score){
			//保存搜索的参数
			var param = "";
			if($("#startDate").val()!=''){
				param += "&startDate=" + $("#startDate").val();
			} 
			if( $("#endDate").val()!=''){
				param += "&endDate=" + $("#endDate").val();
			}
			if( $("#flowName").val()!=''){
				param += "&flowName=" + $("#flowName").val();
			}
			//保存页数
			param += "&currentPage=" + $("#currentPage").val();
		 	window.location.href = '<%=basePath%>app_task/toHandleFlowTask.do?nodeId=' + nodeId + '&flowId=' + flowId + '&handleType=' + handleType + '&score=' + score + param;
		}
		
		//查询流程详情
		function showFlowDetail(flow_id){
			//保存搜索的参数
			var param = "";
			if($("#startDate").val()!=''){
				param += "&startDate=" + $("#startDate").val();
			} 
			if( $("#endDate").val()!=''){
				param += "&endDate=" + $("#endDate").val();
			}
			if( $("#flowName").val()!=''){
				param += "&flowName=" + $("#flowName").val();
			}
			if('${pd.showDept}'=='1'){
			param += "&deptCode=" + $("#deptCode").val()+"&empCode=" + $("#empCode").val();;
			}
			//保存页数
			param += "&currentPage=" + $("#currentPage").val();
			param += "&showDept=${pd.showDept}";
		location.href = '<%=basePath%>app_task/showDetail.do?ID=' + flow_id+param;
		}
		
		//查询节点岗位职责明细
		function showNodeDetail(workNodeId){
			//保存搜索的参数
			var param = "";
			if($("#startDate").val()!=''){
				param += "&startDate=" + $("#startDate").val();
			} 
			if( $("#endDate").val()!=''){
				param += "&endDate=" + $("#endDate").val();
			}
			if( $("#flowName").val()!=''){
				param += "&flowName=" + $("#flowName").val();
			}
			if('${pd.showDept}'=='1'){
			param += "&deptCode=" + $("#deptCode").val()+"&empCode=" + $("#empCode").val();;
			}
			//保存页数
			param += "&currentPage=" + $("#currentPage").val();
			param += "&showDept=${pd.showDept}";
			location.href = '<%=basePath%>app_task/showNodeDetail.do?workNodeId=' + workNodeId+param;
		}
		
		function addPositionDailyTask(){
	        $.ajax({
	            type: "POST",
	            url: '<%=basePath%>app_task/checkAdd.do?timeStamp=' + new Date().getTime(),
	            dataType: 'json',
	            cache: false,
	            success: function (data) {
	                if("true" == data["status"]){
	                    window.location.href = "<%=basePath%>app_task/add.do" + 
	                    	"?fromPage=gridTask&show=2&parentPage=gridTask&empCode=${pd.empCode}&loadType=D";
	                }else {
	                    alert("今日已经添加过行政日清，你只需要进行维护！")
	                }
	            }
	        });

	    }
	</script>
	<script>
	//初始化点击查询
	function initClickDivEvent(){
		//点击工作类型
		$(".showlist").click(function(e){
			e.stopPropagation();
			//设置工作类型样式
			if($(".showlist_col").hasClass("hide")){
				$(".showlist_col").removeClass("hide");
			}else{
				$(".showlist_col").addClass("hide");
			}
			//隐藏任务状态
			if(!$(".showlist1_col").hasClass("hide")){
				$(".showlist1_col").addClass("hide");
			}
		});
		//点击状态
		$(".showlist1").click(function(e){
			e.stopPropagation();
			//设置任务状态样式
			if($(".showlist1_col").hasClass("hide")){
				$(".showlist1_col").removeClass("hide");
			}else{
				$(".showlist1_col").addClass("hide");
			}
			//隐藏工作类型
			if(!$(".showlist_col").hasClass("hide")){
				$(".showlist_col").addClass("hide");
			}
		});
		//点击页面
		$(document).click(function(){
			if(!$(".showlist_col").hasClass("hide")){
				$(".showlist_col").addClass("hide");
			}
			if(!$(".showlist1_col").hasClass("hide")){
				$(".showlist1_col").addClass("hide");
			}
		});
		//选择工作类型
		$(".showlist_col a").click(function(){
			var taskname = $(this).html();
			//alert(taskname);
			$(".showlist span").html(taskname);
		});
		//选择状态
		$(".showlist1_col a").click(function(){
			var taskname = $(this).html();
			//alert(taskname);
			//设置背景颜色
			$(".showlist1_col a").removeClass("active");
			$(this).addClass("active");
			$(".showlist1 span").html(taskname);
		});
	}
</script>
  
</html>
