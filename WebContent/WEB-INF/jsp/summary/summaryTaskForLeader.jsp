<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    

    <title>CreValue 工作台</title>
    <meta name="keywords" content="">
    <meta name="description" content="">

	<link href="static/summaryTask/css/bootstrap.min.css?v=3.3.5" rel="stylesheet">
    <link href="static/summaryTask/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
	
	<!-- Morris -->
    <link href="static/summaryTask/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">

    <!-- Gritter -->
    <link href="static/summaryTask/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
	
	<!-- 日历 -->
	<link href="static/summaryTask/js/DatePicker/calender.css" rel="stylesheet">
	
	<!-- 目标模块日期 -->
	<link rel="stylesheet" href="static/css/datepicker.css" />

    <link href="static/summaryTask/css/animate.min.css" rel="stylesheet">
    <link href="static/summaryTask/css/style.min.css?v=4.0.0" rel="stylesheet">

	<style type="text/css">
		/*修复datepicker在高版本的样式下不显示左右选择日期的箭头*/
		.icon-arrow-left:before{content:"\f060"}
		.icon-arrow-right:before{content:"\f061"}
		[class^="icon-"], [class*=" icon-"] {
		    font-family: FontAwesome;
		    font-weight: normal;
		    font-style: normal;
		    text-decoration: inherit;
		    -webkit-font-smoothing: antialiased;
		    display: inline;
		    width: auto;
		    height: auto;
		    line-height: normal;
		    vertical-align: baseline;
		    background-image: none;
		    background-position: 0 0;
		    background-repeat: repeat;
		    margin-top: 0;
		}
		[class^="icon-"]:before, [class*=" icon-"]:before {
		    text-decoration: inherit;
		    display: inline-block;
		    speak: none;
		}
		
		/*删除tbody多余的边框*/
		.table>tbody+tbody{border:0;}
		
		/*下拉菜单样式*/
		#targetIndexBtn{
        	   width:80px;
        	   height:25px;
        	   line-height:25px;
        	   padding:0 5px;
        	   color:#fff;
        	   background:#43acf7;
        	   text-align:center;
        }
        .dropdown .dropdown-menu{
        	   margin:0;
        	   border-radius:0;
        	   width:80px;
        	   min-width:80px;
        }
        .dropdown .dropdown-menu li{
        	   padding:5px 10px;
        	   text-align:center;
        }
        .dropdown .dropdown-menu li:hover{
        	   background:#448fb9;
        	   color:#fff;
        }
	</style>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content">
        <div class="row">
            <div class="col-sm-8">
				<!-- <div class="ibox float-e-margins" id="iboxSummaryTask">
                    <div class="ibox-title">
						<h5>业绩目标</h5> 
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-bar-chart-o"></i></span>
                        <div class="ibox-tools">
							<div class="btn-group" id="businessTaskBtn">
                                <button name="year" class="btn btn-primary btn-xs" type="button">年</button>
                                <button name="month" class="btn btn-white btn-xs" type="button">月</button>
                                <button name="week" class="btn btn-white btn-xs" type="button">周</button>
                            </div>
                            <input type="text" id="queryDateSpan" style="padding:0 10px;width:90px;background:#fff!important;vertical-align:top;" 
                               readonly="readonly" onchange="loadTargetTask();"/>
                            <a data-toggle="collapse" data-parent="#ibox" href="#iboxBusinessTask">
                                <i class="fa fa-chevron-up"></i>
                            </a>
                            <a class="dropdown-toggle" data-toggle="dropdown" href="index.html#">
                                <i class="fa fa-wrench"></i>
                            </a>
                            <ul class="dropdown-menu dropdown-user">
                                <li><a href="index.html#">选项1</a>
                                </li>
                                <li><a href="index.html#">选项2</a>
                                </li>
                            </ul>
                            <a class="close-link">
                                <i class="fa fa-times"></i>
                            </a>
                        </div>
                    </div>
					<div class="collapse in" id="iboxBusinessTask">
						<div class="ibox-content" >
							<div id="summaryBusinessTask"></div>
							<div style="clear:both;"></div>
						</div>
					</div>
				</div>ibox -->
				
				<div class="ibox float-e-margins">
                    <div class="ibox-title">
						<h5>目标看板</h5> 
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-bar-chart-o"></i></span>
                        <div class="ibox-tools">
                       		<span style="padding:0 10px;cursor:pointer" onclick="goTargetDetail()">进入目标明细</span>
                            <a data-toggle="collapse" data-parent="#ibox" href="#iboxTatget">
                                <i class="fa fa-chevron-up"></i>
                            </a>
                        </div>
                    </div>
					<div class="collapse in" id="iboxTatget">
						<div class="ibox-content" >
							<div class="col-xs-5">
								<div class="status_list dropdown">
									<div class="initDropdown" id="targetIndexBtn"><i class="fa fa-sort-down" style="padding-left:10px;vertical-align:text-top;"></i></div>
									<ul class="dropdown-menu status" id="statusList" style="left:0;">
									</ul>
								</div>
								<!-- <div class="btn-group" id="targetIndexBtn">
									<button name="销售额" class="btn btn-primary btn-xs" type="button">销售额</button>
	                                <button name="利润额" class="btn btn-white btn-xs" type="button">利润额</button>
	                                <button name="生产量" class="btn btn-white btn-xs" type="button">生产量</button>
	                                <button name="采购量" class="btn btn-white btn-xs" type="button">采购量</button>
	                            </div> -->
								<div class="echarts" id="echarts-gauge-chart"></div>
							</div>
							<div class="col-xs-7">
								<div class="btn-group" style="float:right;" id="targetTimeBtn">
	                                <button name="thisMonth" class="btn btn-primary btn-xs" type="button">本月</button>
	                                <button name="lastMonth" class="btn btn-white btn-xs" type="button">上月</button>
	                                <button name="thisYear" class="btn btn-white btn-xs" type="button">本年</button>
	                                <button name="lastYear" class="btn btn-white btn-xs" type="button">去年</button>
	                            </div>
								<div class="echarts" id="target-bar-chart"></div>
							</div>
							<div style="clear:both;"></div>
						</div>
					</div>
				</div><!--ibox-->
				
				<div class="ibox float-e-margins" id="iboxProjectInfo">
					<div class="ibox-title">
						<h5>项目进度</h5> 
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-bar-chart-o"></i></span>
						<div class="ibox-tools">
							<div class="btn-group" id="proProcessBtn">
                                <button name="all" class="btn btn-primary btn-xs" type="button">全部</button>
                                <button name="underWay" class="btn btn-white btn-xs" type="button">进行中</button>
                                <button name="overtime" class="btn btn-white btn-xs" type="button">超期</button>
                            </div>
							<span style="padding:0 10px;cursor:pointer" onclick="goProjectList()">进入协同主页</span>
							<a data-toggle="collapse" data-parent="#ibox" href="#iboxProProcess" >
								<i class="fa fa-chevron-up"></i>
							</a>
							<!--<a class="dropdown-toggle" data-toggle="dropdown" href="index.html#">
								<i class="fa fa-wrench"></i>
							</a>
							<ul class="dropdown-menu dropdown-user">
								<li><a href="index.html#">选项1</a>
								</li>
								<li><a href="index.html#">选项2</a>
								</li>
							</ul>
							<a class="close-link">
								<i class="fa fa-times"></i>
							</a>-->
						</div>
					</div>
					<div class="collapse in" id="iboxProProcess">
						<div class="ibox-content">
							<div class="project-list">
		                        <table class="table table-hover">
		                        <thead>
			                        <tr>
				                        <th>状态</th>
				                        <th>项目名称</th>
				                        <th>项目进度</th>
				                        <th>承接部门</th>
				                        <th>负责人</th>
			                        </tr>
		                        </thead>
		                            <tbody id="projectListTbody">
		                                   
									</tbody>
								<tr>
		                        <td colspan="5" style="text-align:center;">
		                        <div style="border-top:3px solid #1c84c6;width:30px;height:6px;display:inline-block;margin-right:10px;"></div>计划进度
		                        <div style="border-top:3px solid #23c6c8;width:30px;height:6px;display:inline-block;margin-right:10px;margin-left:25px;"></div>实际进度
		                        </td>
		                        </tr>	
								</table>
							</div>
							<!-- <a  style="padding:0 10px; float:right"
								><i class="fa fa-chevron-down"></i></a> -->
							<button id="loadProjectListIcon" class="btn btn-primary btn-xs" style = "float:right; margin-top: -10px;" 
							onclick="loadAllProjectList()" type="button">展开</button>
						</div>
					</div><!--ibox-->
				</div><!-- ibox -->
				
				<div class="ibox float-e-margins" id="iboxFlowWork">
					<div class="ibox-title">
						<h5>流程中心</h5> 
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-bar-chart-o"></i></span>
						<div class="ibox-tools">
							<span style="padding:0 10px;cursor:pointer" onclick="goFlowWork()">进入流程主页</span>
							<a data-toggle="collapse" data-parent="#ibox" href="#iboxFlow" >
								<i class="fa fa-chevron-up"></i>
							</a>
							<!--<a class="dropdown-toggle" data-toggle="dropdown" href="index.html#">
								<i class="fa fa-wrench"></i>
							</a>
							<ul class="dropdown-menu dropdown-user">
								<li><a href="index.html#">选项1</a>
								</li>
								<li><a href="index.html#">选项2</a>
								</li>
							</ul>
							<a class="close-link">
								<i class="fa fa-times"></i>
							</a>-->
						</div>
					</div>
					<div class="collapse in" id="iboxFlow">
						<div class="ibox-content">
							<div class="project-list">
		                        <table class="table table-hover">
		                        <tr>
		                        <td>流程名称</td>
		                        <td>发起人</td>
		                        <td>开始日期</td>
		                        <td>已执行天数</td>
		                        <td>当前节点</td>
		                        <td>节点负责人</td>
		                        <td>状态</td>
		                        </tr>
		                            <tbody id="flowTaskTbody">
		                                   
									</tbody>
								</table>
							</div>
							<!-- <a  style="padding:0 10px; float:right"
								><i class="fa fa-chevron-down"></i></a> -->
							<button id="loadFlowWorkIcon" class="btn btn-primary btn-xs" style = "float:right; margin-top: -10px;" 
							onclick="loadAllFlowWork()" type="button">展开</button>
						</div>
					</div><!--ibox-->
				</div><!-- ibox -->
				
				<div class="ibox float-e-margins" id="iboxUnfinish">
					<div class="ibox-title">
						<h5>待办事项</h5> 
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-bar-chart-o"></i></span>
						<div class="ibox-tools">
							<span style="padding:0 10px;cursor:pointer" onclick="goscheduleList()">进入待办主页</span>
							<a data-toggle="collapse" data-parent="#ibox" href="#iboxUnfin" >
								<i class="fa fa-chevron-up"></i>
							</a>
							<!--<a class="dropdown-toggle" data-toggle="dropdown" href="index.html#">
								<i class="fa fa-wrench"></i>
							</a>
							<ul class="dropdown-menu dropdown-user">
								<li><a href="index.html#">选项1</a>
								</li>
								<li><a href="index.html#">选项2</a>
								</li>
							</ul>
							<a class="close-link">
								<i class="fa fa-times"></i>
							</a>-->
						</div>
					</div>
					<div class="collapse in" id="iboxUnfin">
						<div class="ibox-content">
							<div class="project-list">
		                        <table class="table table-hover">
		                            <tbody id="unfinishTaskTbody">
		                                   
									</tbody>
								</table>
							</div>
							<!-- <a  style="padding:0 10px; float:right"
								><i class="fa fa-chevron-down"></i></a> -->
							<button id="loadUnfinishTaskIcon" class="btn btn-primary btn-xs" style = "float:right; margin-top: -10px;" 
							onclick="changelimit()" type="button">展开</button>
						</div>
					</div><!--ibox-->
				</div><!-- ibox -->
				<div class="ibox float-e-margins" id="iboxEmpTask">
				<div class="ibox-title">
					<h5>工作清单</h5> 
					<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-bar-chart-o"></i></span>
					<div class="ibox-tools">
						<span style="padding:0 10px;cursor:pointer" onclick="goWorkList()">进入工作清单</span>
						<a data-toggle="collapse" data-parent="#ibox" href="#iboxEmpTa">
							<i class="fa fa-chevron-up"></i>
						</a>
						<!--<a class="dropdown-toggle" data-toggle="dropdown" href="index.html#">
							<i class="fa fa-wrench"></i>
						</a>
						<ul class="dropdown-menu dropdown-user">
							<li><a href="index.html#">选项1</a>
							</li>
							<li><a href="index.html#">选项2</a>
							</li>
						</ul>
						<a class="close-link">
							<i class="fa fa-times"></i>
						</a>-->
					</div>
				</div>
				
				<div class="collapse in" id="iboxEmpTa">
					<div class="ibox-content">
						<div class="project-list">
                            <table class="table table-hover">
                                <tbody id="empTaskTbody">
                                    
								</tbody>
							</table>
						</div>
						<button id="loadEmpTaskIcon" class="btn btn-primary btn-xs" style = "float:right; margin-top: -10px;" 
							type="button">展开</button>
					</div>
                </div><!--iboxThree-->
				</div><!-- ibox -->
			</div><!--col-sm-8-->
			<div class="col-sm-4">
				
				<div class="ibox float-e-margins" id="iboxTaskScore">
                    <div class="ibox-title" style="height:80px">
						<h5>榜上有名(前30)</h5>
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-bar-chart-o"></i></span>
                        <div class="ibox-tools">
                            <input type="text" id="queryMonth" style="margin-right:20px;padding:0 10px;width:90px;background:#fff!important;" 
                              readonly="readonly" onchange="loadTaskScore();"/>
                            <a data-toggle="collapse" data-parent="#ibox" href="#iboxTaskSco">
                                <i class="fa fa-chevron-up"></i>
                            </a>
                        </div>
                        <div style="clear:both;"></div>
                        <div class="m-t" style="text-align:center;">
	                    <span style="margin-right:50px;" id="ownranking">我的排名</span>
						<span id="ownscore">我的积分</span>
						</div>
                    </div>
                    
                    
					<div class="collapse in" id="iboxTaskSco">
						<div class="ibox-content" >
							<div class="project-list" >
							<!--隐藏员工编码（来自Logincontroller），便于后边排名取员工编码  -->
							<input type="hidden" id="queryEmpCode" value="${queryEmpCode}"/>
							
	                            <table class="table table-hover">
	                                <tbody id="emp-score-list">
	                                    
									</tbody>
								</table>
							</div>
							<button id="changelimit" class="btn btn-primary btn-xs" style = "float:right; margin-top: -10px;" 
							onclick="changelimit()" type="button">展开</button>	
						</div>
					</div>
				</div><!--ibox-->
				
				<div class="ibox float-e-margins" id="iboxTeamScore">
                    <div class="ibox-title">
						<h5>团队日报</h5>
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-bar-chart-o"></i></span>
                        <div class="ibox-tools">
                            <div class="btn-group" id="teamDailyBtn">
                                <button name="today" class="btn btn-primary btn-xs" type="button">当日</button>
                                <button name="thisMonth" class="btn btn-white btn-xs" type="button">月度</button>
                            </div>
                            <span style="padding:0 10px;cursor:pointer" onclick="goTeamReportPage()">进入日报主页</span>
                            <a data-toggle="collapse" data-parent="#ibox" href="#iboxTeam">
                                <i class="fa fa-chevron-up"></i>
                            </a>
                        </div>
                    </div>
                    
                    
					<div class="collapse in" id="iboxTeam">
						<div class="ibox-content" >
							<div class="echarts" id="echarts-bar-chart"></div>
						 	<div class="pie_chart_block">
								 <div class="col-xs-9">
								 	<div class="echarts" id="echarts-pie-chart"></div>
								 </div>
								 <div id="teamDailyInfo" class="col-xs-3" style="margin-top:60px;">
								 </div>
								 <div style="clear:both;"></div>
							 </div>	
						</div>
					</div>
				</div><!--ibox-->
				
				<div class="ibox float-e-margins" id="iboxDailyClear">
					<div class="ibox-title">
						<h5>工作日清</h5> 
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-bar-chart-o"></i></span>
						<div class="ibox-tools">
							<span style="padding:0 10px;">进入日清主页</span>
							<a data-toggle="collapse" data-parent="#ibox" href="#iboxDailyCl">
								<i class="fa fa-chevron-up"></i>
							</a>
							<!--<a class="dropdown-toggle" data-toggle="dropdown" href="index.html#">
								<i class="fa fa-wrench"></i>
							</a>
							<ul class="dropdown-menu dropdown-user">
								<li><a href="index.html#">选项1</a>
								</li>
								<li><a href="index.html#">选项2</a>
								</li>
							</ul>
							<a class="close-link">
								<i class="fa fa-times"></i>
							</a>-->
						</div>
					</div>
					<div class="collapse in" id="iboxDailyCl">
						<div class="ibox-content">
							<table id="positionTaskTips" style="margin-left:10px;">
								<tr>
								<td class="commitTask" style="width:32px;height:20px;"></td>
								<td style="padding:0 10px;">已交</td>
								<td class="unCommitTask" style="width:32px;height:20px;"></td>
								<td style="padding:0 10px;">未交</td>
								<td class="delayCommitTask" style="width:32px;height:20px;"></td>
								<td style="padding:0 10px;">补交</td>
								</tr>
							</table>
							<!--日历控件-->
							 <div id="index_calendar"></div>
							<!--日历控件结束-->	
						</div>
	                </div>
				</div><!--ibox-->
				
				
				

			
			</div><!--col-sm-4-->
			<!--<button onClick="LoginQueryAccount()">load</button>
			<div class="rightdiv"></div>-->
		</div><!-- row -->
	</div><!-- wrapper -->
    <script src="static/summaryTask/js/jquery.min.js?v=2.1.4"></script>
    <script src="static/summaryTask/js/bootstrap.min.js?v=3.3.5"></script>
	
	<!-- 日历 -->
	<script type="text/javascript" src="static/summaryTask/js/DatePicker/calendar.js"></script>
	<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
	
	<!-- echarts图表 -->
	<script src="static/summaryTask/js/plugins/echarts/echarts-all.js"></script>
	
	<script>
			
	$(document).ready(function(){
        $(".initDropdown").mouseenter(function(){//鼠标悬停触发事件
        	$(this).parent(".dropdown").addClass("open");
        });
        $(".dropdown").mouseleave(function(){//鼠标悬停触发事件
	        $(this).removeClass("open");
	    });
        $.ajax({
			url: '<%=basePath%>/summaryTask/initIndexList.do',
			type: 'post',
			success : function(data){
					var obj = eval(data);
					$("#statusList").empty();
					if(data){
						$("#targetIndexBtn").prepend(data[0].INDEX_NAME);
						initTargetBoard();
						$.each(data, function(i, task){
							$("#statusList").append('<li onclick="changeType(this)" value="'+task.INDEX_NAME+'">'+task.INDEX_NAME+'</li>');
						});
					} 
			}
		}); 
  	});
	//下拉选择事件
	 function changeType(obj){
     	var status = $(obj).text();
     	$(obj).parent(".status").prev().text(status);
     	$(obj).parent(".status").prev().parent(".dropdown").removeClass("open");
     	loadTargetBoard();
     }
	
	//载入内容
	$(function(){
		if('0'=='${queryEmpCode}'){
			return;
		}
		//初始化目标模块
		//initBusinessTask();
		//setTimeout("loadTargetTask('init')", 100);
		//加载待处理事项模块
		setTimeout("loadUnfinishTask(1, 6)", 200);
		//初始化积分模块
		initTaskScore();
		setTimeout("loadTaskScore()", 300);
		//加载工作清单模块
		setTimeout("loadEmpTaskList(1,10)", 400);
		//加载日清模块
		initPositionTaskCalendar();
		setTimeout("loadPositionTask()", 500);
		//初始化项目进度模块
		initProjectProcess();
		//加载流程中心
		setTimeout("loadFlowWork()", 600);
		//初始化团队日报模块
		initTeamDaily();
		//初始化团队日报模块
		//initTargetBoard();
	})
	
	//初始化目标
	function initBusinessTask(){
		//初始化日期
		initBusinessTaskDatePicker($('#queryDateSpan'));
		//点击目标模块按钮，修改对应按钮样式并加载数据
		$("#businessTaskBtn > button").click(function(){
			//设置点击后的按钮样式
			$("#businessTaskBtn .btn-primary").addClass("btn-white");
			$("#businessTaskBtn .btn-primary").removeClass("btn-primary");
			$(this).removeClass("btn-white");
			$(this).addClass("btn-primary");
			//重新初始化日期
			$("#queryDateSpan").datepicker('remove');
			initBusinessTaskDatePicker($('#queryDateSpan'));
			loadTargetTask('click');
		});
	} 
	
	//初始化目标模块的日期控件
	function initBusinessTaskDatePicker(obj){
		var queryDateType = $("#businessTaskBtn .btn-primary").attr('name');
		var dateFormat = '';
		var mode = 2;
		var initVal = $(obj).val()==""? new Date() : new Date($(obj).val());
		if('year'==queryDateType){
			dateFormat = 'yyyy';
			mode = 2;
		}else if('month'==queryDateType){
			dateFormat = 'yyyy/mm';
			mode = 1;
		}else if('week'==queryDateType){
			dateFormat = 'yyyy/mm/dd';
			mode = 0;
		}
		$(obj).datepicker({
			format: dateFormat,
            showButtonPanel: false,
            todayBtn: false,
            autoclose: true,
            minViewMode: mode,
            maxViewMode: 2,
            startViewMode: mode
        }).datepicker('setDate', initVal)
        .datepicker('update');
	} 
	
	//加载目标工作的汇总分析
	function loadTargetTask(type){
		var queryDateType = $("#businessTaskBtn .btn-primary").attr('name');
		var queryDate = $("#queryDateSpan").val();
		$.ajax({
			url: '<%=basePath%>/summaryTask/summaryBusinessTask.do',
			type: 'post',
			data: {
				'queryEmpCode':'${queryEmpCode}', 
				'queryDateType':queryDateType, 
				'queryDate': queryDate
			},
			success : function(data){
				var obj = eval('(' + data + ')')
				if(obj.errorMsg){
					top.Dialog.alert(obj.errorMsg);
				}else{
					$("#summaryBusinessTask").empty();
					if(obj.result){
						$.each(obj.result, function(i, task){
							$("#summaryBusinessTask").append(appendSummaryBusinessTask(task, obj));
						});
						
						if(obj.result.length==1){
							var append = '<div class="col-sm-6">' +
							  '	<div class="float-e-margins" style="border:1px solid #e7eaec">' +
							  '	 <div class="ibox-title" style="border:none;">' + 
							  '  </div>' + 
							  '  <div class="ibox-content" style="text-align: center; border-top: none;">' + 
							  '   <h2 class="no-margins">无其他目标</h2>' +
							  '  </div>' + 
							  ' </div>' +
							  '</div>';
							$("#summaryBusinessTask").append(append);
						}
					}else{
						if('init'==type){
							$("#iboxSummaryTask").hide();
						}else{
							$("#summaryBusinessTask").append('没有数据');
						}
					}
				}
			}
		});
	}
	
	//初始化日期控件（积分排名）
	function initScoreDatePicker(obj){
		var mode = 1;
		var initVal = $(obj).val()==""? new Date() : new Date($(obj).val());
		$(obj).datepicker({
			format: 'yyyy-mm',
            showButtonPanel: false,
            todayBtn: false,
            autoclose: true,
            minViewMode: mode,
            maxViewMode: 2,
            startViewMode: mode
        }).datepicker('setDate', initVal)
        .datepicker('update');
	}
	
	//初始化积分排名
	function initTaskScore(){
		//初始化日期
		initScoreDatePicker($('#queryMonth'));
	}
	
	//加载分数排名
	function loadTaskScore(){
		$.ajax({
			url: '<%=basePath%>/summaryTask/summaryTaskScore.do',
			type: 'post',
			data: {
				//取员工编码
				'queryEmpCode': $("#queryEmpCode").val(), 
				//取年月
				'queryMonth': $("#queryMonth").val(),
				//只获取前30名
				'showNum': 30
			},
			success : function(data){
				var obj = eval('(' + data + ')')
				if(obj.errorMsg){
					top.Dialog.alert(obj.errorMsg);
				}else{
					$("#emp-score-list").empty();
					/* 显示自己的排名和分数 */
					var a=document.getElementById ("ownranking");
            		a.innerHTML = "我的排名  "+obj.queryEmpOrder; 
            		var b=document.getElementById ("ownscore");
            		b.innerHTML = "我的分数  "+obj.queryEmpScore;

					if(obj.result){
						$.each(obj.result, function(i, task){
							$("#emp-score-list").append(appendSummaryTaskScore(task, obj));
						});
					}else{
						$("#emp-score-list").append('没有数据');
					}
				}
			}
		});
	}	
	//点击展开按钮显示所有排名
	function changelimit(){
		$("#changelimit").hide();
		$(".nolimit10").css("display","table-row");
	}
	
	//拼接积分排名情况
	function appendSummaryTaskScore(task, obj){
		var rownumtxt = '';
		var name = task.EMP_NAME;
		var score = task.SCORE_SUM;
		var code = task.EMP_CODE;
		var textClass = '';
		var textStyle = '';
		var limit10 = '';
		var id= '';
		var class_limit10 ='';
		if(task.rownum==1){
		rownumtxt = '第一名';
		textClass='badge badge-primary'
		textStyle='';
		}else if(task.rownum==2) {
		rownumtxt = '第二名';
		textClass='badge badge-primary'
		textStyle='style="background-color:#74c2f9;"';
		}else if(task.rownum==3) {
		rownumtxt = '第三名';
		textClass='badge badge-primary'
		textStyle='style="background-color:#97d1fb;"';
		}else {
		textClass=''
		rownumtxt=task.rownum;
		}
		if(task.rownum<=10){
		limit10 = 'table-row';
		class_limit10 ='limit10';
		}else{
		limit10 = 'none';
		class_limit10 ='nolimit10'
		}
		
		
		var append = '<tr class="'+class_limit10 +'" style="display: '+limit10+'">'+
		'<td class="project-status" style="text-align:center;">'+
		'<span class="'+textClass+'"'+textStyle+'>'+task.rownum+
	    '</td>'+
	    '<td class="project-title">'+
	    '<a href="javascript:void(0)" onclick="showEmpScoreInfo(\'' + code + '\')">'+name+'</a>'+
	    '</td>'+
	    '<td class="project-completion">'+
	    '<small>当前得分：'+score+'</small>'+
	    '<div class="progress progress-mini">'+
	    '<div style="width:'+score+'%;" class="progress-bar progress-bar-success"></div>'+
	    '</div>'+
	    '</td>'+
	    '</tr>';	    									
			                              
	                                    
		return append;
	}
	
	//拼接目标汇总情况
	function appendSummaryBusinessTask(task, obj){
		var textClass = 'success';
		var riseText = '增长';
		var riseIconClass = 'fa-level-up';
		if(task.finishCountRisePercent<0){
			textClass = 'info';
			riseText = '下降';
			riseIconClass = 'fa-bolt';
		}
		var append = '<div class="col-sm-6">' +
				  '	<div class="float-e-margins" style="border:1px solid #e7eaec">' +
				  '	 <div class="ibox-title" style="border:none;">' + 
				  '   <span class="label label-' + textClass + ' pull-right">' + obj.queryDateTypeText + '</span>' + 
				  '   <h4>' + task.indexName + '(' +  task.targetCount + task.unitName +')' +
				  '	  </h4>' +
				  '  </div>' + 
				  '  <div class="ibox-content">' + 
				  '   <h3 class="no-margins text-' + textClass + '">完成率' + task.finishCountRate + '%</h3>' +
				  '   <h3 class="no-margins text-' + textClass + '">完成量' + task.finishCount + '</h3>' +
				  '   <div class="stat-percent font-bold text-' + textClass + '">同比上年' + riseText + task.finishCountRisePercent + '%' + 
				  ' 	<i class="fa ' + riseIconClass + '" ></i>' + 
				  '   </div>' + 
				  '  </div>' + 
				  ' </div>' +
				  '</div>';
		return append;
	}
	
	//加载待处理事项
	function loadUnfinishTask(pageNo, pageSize){
		$("#loadUnfinishTaskIcon").hide();
		$.ajax({
			url: '<%=basePath%>/summaryTask/summaryUnfinishTask.do',
			type: 'post',
			data: {
				'queryEmpCode': '${queryEmpCode}',
				'pageNo': pageNo,
				'pageSize': pageSize
			},
			success : function(data){
				var obj = eval('(' + data + ')')
				if(obj.errorMsg){
					top.Dialog.alert(obj.errorMsg);
				}else{
					$("#unfinishTaskTbody").empty();
					//正常返回
					if(obj.result){
						$.each(obj.result, function(i, task){
							$("#unfinishTaskTbody").append(appendUnfinishTask(i, task));
						});
						if(obj.hasNext){
							$("#loadUnfinishTaskIcon").show();
							$("#loadUnfinishTaskIcon").attr('onclick', 'loadUnfinishTask(' + (obj.pageNo) + ',' + obj.totalResult + ' )');
						}
						
					}else{
						$("#unfinishTaskTbody").append('暂无待办');
					}
				}
			}
		});
	}
	
	//拼接待处理事项
	function appendUnfinishTask(i, task){
		var append = 
			'<tr>' + 
			' <td><span >' + (i+1) + '</td>' + 
        	' <td class="project-status" style="width: 80px;">' +
        	'  <span">' + task.taskStatusName +'</span>' + 
        	' </td>' +
            ' <td class="project-title">' + 
            '  <a href="javascript:void(0)" onclick="clickTask(\'' + task.taskHandleUrl + '\')">' +task.tasktype+'      |      '+ task.taskName + '</a>' + 
            ' </td>' + 
            ' <td class="project-people">' + task.taskDate + 
            ' </td>' + 
            ' <td class="project-actions">' +
        	'  <a href="javascript:void(0)" onclick="clickTask(\'' + task.taskHandleUrl + '\')"' +
        	'	class="btn btn-white btn-sm"><i class="fa fa-folder"></i> 去处理 </a>' + 
        	' </td>' + 
        	'</tr>';
        return append;
	}
	
	//加载工作清单
	function loadEmpTaskList(pageNo, pageSize){
		$("#loadEmpTaskIcon").hide();
		$.ajax({
			url: '<%=basePath%>/summaryTask/summaryTaskList.do',
			type: 'post',
			data: {
				'queryEmpCode': '${queryEmpCode}',
				'pageNo': pageNo,
				'pageSize': pageSize
			},
			success : function(data){
				var obj = eval('(' + data + ')')
				if(obj.errorMsg){
					top.Dialog.alert(obj.errorMsg);
				}else{
					$("#empTaskTbody").empty();
					//正常返回
					if(obj.result){
						$.each(obj.result, function(i, task){
							$("#empTaskTbody").append(appendEmpTask(i, task));
						});
						if(obj.hasNext){
							$("#loadEmpTaskIcon").show();
							$("#loadEmpTaskIcon").attr('onclick', 'loadEmpTaskList(' + (obj.pageNo) + ',' + obj.totalResult + ' )');
						}
						
					}else{
						$("#empTaskTbody").append('今日暂无工作安排');
					}
				}
			}
		});
	}
	
	//拼接员工的工作清单
	function appendEmpTask(i, task){
		var statusClass = '';
		if('进行中'==task.taskStatusName){
			statusClass = 'info';
		}else if('已完成'==task.taskStatusName){
			statusClass = 'navy';
		}else if('超期'==task.taskStatusName){
			statusClass = 'danger';
		}
		var append = 
			'<tr>' + 
			' <td><span >' + (i+1) + '</td>' + 
        	' <td class="project-status" style="width:75px;">' +
        	'  <span >' + task.taskType +'</span>' + 
        	' </td>' +
            ' <td class="project-title">' + 
            '  <a href="javascript:void(0)" onclick="showHandlePage(\'' + task.taskHandleUrl + '\')">' + task.taskName + '</a>' + 
            '  <br/><small>创建于 ' + task.taskCreateDate + '</small>' +
            ' </td>' + 
            ' <td class="project-completion" style="width:80px;">' +
            '  <i class="fa fa-circle text-' + statusClass + '"></i> ' + task.taskStatusName + 
            ' </td>' + 
            ' <td class="project-actions">' +
        	'  <a href="javascript:void(0)" onclick="showHandlePage(\'' + task.taskHandleUrl + '\')"' +
        	'	class="btn btn-white btn-sm"><i class="fa fa-folder"></i> 日清 </a>' + 
        	' </td>' + 
        	'</tr>';
        return append;
	}
	
	//跳转到处理页面
	function showHandlePage(url){
		var PARENT_FRAME_ID = $(".tab_item2_selected", window.parent.document).parents('table').attr('id')
		siMenu('z', 'lm', '日清', url+'&sourcePage=summaryPage'+"&PARENT_FRAME_ID=" +PARENT_FRAME_ID);
		/*
		var diag = new top.Dialog();
		diag.Drag=true;
		diag.Title ='日清';
		diag.URL =  url;
		diag.Width = 1000;
		diag.Height = 700;
		diag.CancelEvent = function(){
		 
			diag.close();
		};
		diag.show();
		*/
	}
	
	//点击后，根据菜单url打开新的tab页
	function clickTask(url){
		$.ajax({
			url:"menu/findByUrl.do",
			data:{"url":url},
			type:"post",
			success:function(data){
			var PARENT_FRAME_ID = $(".tab_item2_selected", window.parent.document).parents('table').attr('id')
				/* siMenu("z"+data.MENU_ID, "lm"+data.PARENT_ID, '待办事项', url+"&PARENT_FRAME_ID=" +PARENT_FRAME_ID); */
				top.mainFrame.tabAddHandler("backsummarytask", '待办事项', url+"&PARENT_FRAME_ID=" +PARENT_FRAME_ID+"&fromPage=summaryPage");
		        //top.mainFrame.tabAddHandler('z'+data.MENU_ID, 'lm'+data.PARENT_ID, data.MENU_NAME, url);
			}
		});
	}
	
	//打开新的tab页
	function siMenu(id,fid,MENU_NAME,MENU_URL){
		var fmid = "mfwindex";
		var mid = "mfwindex";
		if(id != mid){
			$("#"+mid).removeClass();
			mid = id;
		}
		if(fid != fmid){
			$("#"+fmid).removeClass();
			fmid = fid;
		}
		$("#"+fid).attr("class","active open");
		$("#"+id).attr("class","active");
		top.mainFrame.tabAddHandler(id,MENU_NAME,MENU_URL);
	}
	
	//初始化日清模块的日历控件
	var positionTaskCal;
	function initPositionTaskCalendar(){
		var calendarWidth = $('#index_calendar').width();
		var calendarHeight = $('#index_calendar').height();
		positionTaskCal = $('#index_calendar').calendar({
	        width: calendarWidth,
	        //height: 320,
	        isSelectToday: false,
	        showMarkday: false,
	        /*
	        data: [
				{
				    date: '2017/06/15',
				    value: '已交',
				    dayType: 'commitTask'
				},
				{
				    date: '2017/06/18',
				    value: '未交',
				    dayType: 'unCommitTask'
				},
				{
				    date: '2017/06/20',
				    value: '补交',
				    dayType: 'delayCommitTask'
				},
				{
				    date: '2017/06/21',
				    value: '',
				    dayType: ''
				},
	        ],
	        */
	        date: new Date(),
	        onSelected: function (view, day, data) {
	            //切换月份时，再次加载数据
	            if('month'==view){
	            	loadPositionTask();
	            }
	        },
	        selectedDay: function (d, type){
	        	//选中日期
	        	if(type!=''){//直接在日期上点击其它月份的日期，需要再次加载数据
	        		loadPositionTask();
	        	}
	        },
	        clickArrowDate: function(type, y, m){
	        	//点击日期的左右箭头
	        	loadPositionTask();
            }
	    });
		
		$(".calendar-d .view-month").hide();
		$(".calendar-d .view-month").show(0.6);
	}
	
	//加载日清模块数据
	function loadPositionTask(){
		var queryPosDate = $("#iboxFive #index_calendar .calendar-hd >a").text();
		queryPosDate = queryPosDate.substr(0, queryPosDate.length-4)+'/1';
		$.ajax({
			url: '<%=basePath%>/summaryTask/summaryPositionTask.do',
			type: 'post',
			data: {
				'queryEmpCode': '${queryEmpCode}',
				'queryDailyDate': queryPosDate
			},
			success : function(data){
				var obj = eval('(' + data + ')')
				if(obj.errorMsg){
					top.Dialog.alert(obj.errorMsg);
				}else{
					//正常返回
					if(obj.result){
						var myArray = new Array();
						$.each(obj.result, function(i, task){
							var textClass = "";
							if('未提交'==task.statusname){
								textClass = 'unCommitTask';
							}else if('已提交'==task.statusname){
								textClass = 'commitTask';
							}else if('补交'==task.statusname){
								textClass = 'delayCommitTask';
							}
							var objInArray = {
								date : task.date,
								value : task.statusname,
								dayType : textClass
							}
							myArray.push(objInArray);
						});						
						if(myArray){
							positionTaskCal.data('calendar').setData(myArray);
						}
					}
				}
			}
		});
	}
	
	
	function goWorkList()
	{
		siMenu('workList', 'workList', '工作清单', "workList/list.do?msg=0");
	}
	//待办事项点击进入待办主页
	function goscheduleList()
	{
		siMenu('scheduleList', 'scheduleList', '待办事项', "scheduleList/list.do?msg=0");
	}
	
	//初始化项目进度
	function initProjectProcess(){
		//点击项目进度模块按钮，修改对应按钮样式并加载数据
		$("#proProcessBtn > button").click(function(){
			//设置点击后的按钮样式
			$("#proProcessBtn .btn-primary").addClass("btn-white");
			$("#proProcessBtn .btn-primary").removeClass("btn-primary");
			$(this).removeClass("btn-white");
			$(this).addClass("btn-primary");
			loadProjectProcess();
		});
		loadProjectProcess();
	}
	
	
	//加载项目进度
	function loadProjectProcess(){
		var queryProStatus = $("#proProcessBtn .btn-primary").attr('name');
		$("#loadProjectListIcon").hide();
		$.ajax({
			url: '<%=basePath%>/summaryTask/summaryTaskProjectProcess.do',
			type: 'post',
			data: {
				//取员工编码
				'queryEmpCode': $("#queryEmpCode").val(),
				'statusType':queryProStatus
			},
			success : function(data){
				var obj = eval('(' + data + ')')
				if(obj.errorMsg){
					top.Dialog.alert(obj.errorMsg);
				}else{
					$("#projectListTbody").empty();
					if(obj.result){
						if(obj.result.length > 4){
							$("#loadProjectListIcon").show();
						}
						$.each(obj.result, function(i, task){
							$("#projectListTbody").append(appendProjectProcess(task, i));
						});
					}else{
						$("#projectListTbody").append('没有数据');
					}
				}
			}
		});
	}	
	
	//拼接项目进度
	function appendProjectProcess(task, i){
		
		var proStatus = task.proStatus;
		var proName = task.proName;
		var planProcess = task.planProcess;
		var realProcess = task.realProcess;
		var deptName = task.deptName;
		var manager = task.manager;
		
		var limit4 = '';
		var class_limit4 ='';
		if(i<=3){
		limit4 = 'table-row';
		class_limit4 ='limit4';
		}else{
		limit4 = 'none';
		class_limit4 ='nolimit4'
		}
		if('进行中'==proStatus){
			statusColor = 'info';
		}else if('超期'==proStatus){
			statusColor = 'danger';
		}
		
		
		var append = '<tr class="'+class_limit4 +'" style="display: '+limit4+'">'+
		'<td>'+
		'<i class="fa fa-circle text-' + statusColor + '"></i>  <span >' + proStatus +'</span>'+
		'</td>'+
	    '<td class="project-title">'+
		'  <a href="javascript:void(0)" onclick="showProjectProcessInfo(\'' + task.id + '\')">' + proName + '</a>' + 
	    '</td>'+
	    '<td>'+
	    '<div class="progress progress-mini" style="width:120px;float:left;">'+
	    '<div style="width:'+planProcess+'%;" class="progress-bar progress-bar-success"></div>'+
	    '</div><span style="float:left;margin-left:15px;">'+planProcess+'%</span>'+
	    '<div class="cleaner"></div>'+
	    '<div class="progress progress-mini" style="width:120px;float:left;">'+
	    '<div style="width:'+realProcess+'%;" class="progress-bar progress-bar-info"></div>'+
	    '</div><span style="float:left;margin-left:15px;">'+realProcess+'%</span>'+
	    '</td>'+
	    '<td>'+
	    '<span >' + deptName +'</span>'+
	    '</td>'+
	    '<td>'+
	    '<span >' + manager +'</span>'+
	    '</td>'+
	    '</tr>';	    									
			                              
		return append;
	}
	//点击跳转到协同任务明细
	function showProjectProcessInfo(id)
	{
		siMenu('showProjectDetail', 'showProjectDetail', '项目明细', "cproject/nodesList.do?PROJECT_ID=" + id);
	}
	//点击进入协同主页跳转到协同工作管理列表
	function goProjectList()
	{
		siMenu('projectManage', 'projectManage', '项目管理', "cproject/findManageList.do");
	}
	//点击展开显示全部项目进度
	function loadAllProjectList()
	{
		$("#loadProjectListIcon").hide();
		$(".nolimit4").css("display","table-row");
	}
	
	//加载流程中心信息
	function loadFlowWork(){
		$("#loadFlowWorkIcon").hide();
		$.ajax({
			url: '<%=basePath%>/summaryTask/summaryTaskFlowWork.do',
			type: 'post',
			data: {
				//取员工编码
				'queryEmpCode': $("#queryEmpCode").val(),
			},
			success : function(data){
				var obj = eval('(' + data + ')')
				if(obj.errorMsg){
					top.Dialog.alert(obj.errorMsg);
				}else{
					$("#flowTaskTbody").empty();
					if(obj.result){
						if(obj.result.length > 3){
							$("#loadFlowWorkIcon").show();
						}
						$.each(obj.result, function(i, task){
							$("#flowTaskTbody").append(appendFlowWork(task, i));
						});
					}else{
						$("#flowTaskTbody").append('没有数据');
					}
				}
			}
		});
	}
	//拼接流程中心内容
	function appendFlowWork(task, i){
		
		var flowName = task.flowName;
		var originator = task.originator;
		var startDate = task.startDate;
		var executionTime = task.executionTime;
		var nowNode = task.nowNode;
		var nodeManager = task.nodeManager;
		var status = task.status;
		
		var limit3 = '';
		var class_limit3 ='';
		if(i<=2){
		limit3 = 'table-row';
		class_limit3 ='limit3';
		}else{
		limit3 = 'none';
		class_limit3 ='nolimit3'
		}
		
		
		var append = '<tr class="'+class_limit3 +'" style="display: '+limit3+'">'+
		'<td class="project-title">'+
		'  <a href="javascript:void(0)" onclick="showFlowWorkInfo(\'' + task.flowId + '\')">' + flowName + '</a>' + 
		'</td>'+
	    '<td>'+
	    '<span >' + originator +'</span>'+
	    '</td>'+
	    '<td>'+
	    '<span >' + startDate +'</span>'+
	    '</td>'+
	    '<td>'+
	    '<span >' + executionTime +'</span>'+
	    '</td>'+
	    '<td>'+
	    '<span >' + nowNode +'</span>'+
	    '</td>'+
	    '<td>'+
	    '<span >' + nodeManager +'</span>'+
	    '</td>'+
	    '<td>'+
	    '<span >' + status +'</span>'+
	    '</td>'+
	    '</tr>';	    									
			                              
		return append;
	}
	//点击展开显示全部流程信息
	function loadAllFlowWork()
	{
		$("#loadFlowWorkIcon").hide();
		$(".nolimit3").css("display","table-row");
	}
	//点击跳转到流程信息明细
	function showFlowWorkInfo(id)
	{
		siMenu('showFlowDetail', 'showFlowDetail', '流程明细', "flowWork/showDetail.do?ID="+id);
	}
	//点击跳转到流程列表
	function goFlowWork(id)
	{
		siMenu('showFlowList', 'showFlowList', '流程管理', "flowWork/list.do");
	}
	//点击穿透到员工积分明细页面
	function showEmpScoreInfo(code)
	{
		var code = code;
		var dateMonth = $("#queryMonth").val();
		siMenu('showFlowList', 'showFlowList', '积分明细', "score/goEmpScoreInfo.do?month="+ dateMonth +"&queryEmpCode=" + code);
	}
	
	//初始化团队日报
	function initTeamDaily(){
		//点击团队日报的本日/本月按钮，修改对应按钮样式并加载数据
		$("#teamDailyBtn > button").click(function(){
			//设置点击后的按钮样式
			$("#teamDailyBtn .btn-primary").addClass("btn-white");
			$("#teamDailyBtn .btn-primary").removeClass("btn-primary");
			$(this).removeClass("btn-white");
			$(this).addClass("btn-primary");
			loadTeamDaily();
		});
		loadTeamDaily();
	}
	//加载团队日报
	function loadTeamDaily(){
		
		var queryTeamDaily = $("#teamDailyBtn .btn-primary").attr('name');
		//$("#loadProjectListIcon").hide();
		var Url = '';
		if('today'==queryTeamDaily){
			Url = '<%=basePath%>/summaryTask/summaryTeamToday.do';
		}else if('thisMonth'==queryTeamDaily){
			Url = '<%=basePath%>/summaryTask/summaryThisMonth.do';
		}
		$.ajax({
			url: Url,
			type: 'post',
			data: {
				//取员工编码
				'queryEmpCode': $("#queryEmpCode").val(),
				'statusType':queryTeamDaily
			},
			success : function(data){
				var obj = eval('(' + data + ')')
				if(obj.errorMsg){
					top.Dialog.alert(obj.errorMsg);
				}else{
					//$("#projectListTbody").empty();
					if(obj){
						echartsTeamDaily(obj,queryTeamDaily);
					}else{
						top.Dialog.alert("加载团队日报数据出错");
					}
				}
			}
		});
	}	
	//
	function echartsTeamDaily(obj,queryTeamDaily)
	{
		if('today'==queryTeamDaily){
			$(".pie_chart_block").show();
			$("#echarts-bar-chart").hide();
			$("#teamDailyInfo").empty();
			$("#teamDailyInfo").append("应交："+obj.shouldSubmitNum+"<br><br>已交："+obj.submittedNum+"<br><br>未交："+obj.notSubmitNum+"<br><br>");
			var l=echarts.init(document.getElementById("echarts-pie-chart")),
			u={
				//title:{text:"应交：20  实交：12  未交：8",x:"center"},
				tooltip:{
					trigger:"item",
					formatter:"{a} <br/>{b} : {c} ({d}%)"
					},
				legend:{orient:"horizontal",x:"left",data:["已提交","未提交"]},
				calculable:!0,
				series:[{
					name:"填报数量",
					type:"pie",
					radius:"55%",
					center:["50%","50%"],
					data:[
						{
							value:obj.submittedNum,
							name:"已提交",
							itemStyle:{
								normal:{
									color:'#3498DB',
									label:{textStyle:{color:'#3498DB'}},
									labelLine:{lineStyle:{color:'#3498DB'}}
								}
							}
						},
						{
							value:obj.notSubmitNum,
							name:"未提交",
							itemStyle:{
								normal:{
									color:'#FFA847',
									label:{textStyle:{color:'#FFA847'}},
									labelLine:{lineStyle:{color:'#FFA847'}}
								}
							}
						}
					]
				}]
			};
			l.setOption(u),
			$(window).resize(l.resize);
		}else if('thisMonth'==queryTeamDaily){
			$(".pie_chart_block").hide();
			$("#echarts-bar-chart").show();
			var weekList = new Array();
			var submitedList = new Array();
			var noSubmitList = new Array();
			$.each(obj.result, function(i, task){
				weekList[i]= "第"+task.WEEK+"周";
				submitedList[i] = task.rateWeek.toFixed(2);
				noSubmitList[i] = (100.0-task.rateWeek).toFixed(2);
			});
			var t=echarts.init(document.getElementById("echarts-bar-chart")),
			n={
				//title:{text:"月度填报率"},
				tooltip:{trigger:"axis"},
				legend:{data:["已填报","未填报"]},
				grid:{x:30,x2:40,y2:24},
				calculable:!0,
				xAxis:[
					{
					type:"category",
					data:weekList
					}
					],
				yAxis:[
					{type:"value"}
					],
				series:[
					{
						name:"已填报",
						type:"bar",
						stack: '填报率',
						data:submitedList,
						itemStyle:{normal:{color:'#3498DB'}}
					},
					{
						name:"未填报",
						type:"bar",
						stack: '填报率',
						data:noSubmitList,
						itemStyle:{normal:{color:'#FFA847'}}
					}
					]
				};
				t.setOption(n),
				window.onresize=t.resize;
		}
	}
	//点击跳转到团队日清主页
	function goTeamReportPage()
	{
		siMenu('listDailyReport', 'listDailyReport', '日清报告主页', "positionDailyTask/listDailyReport.do?fromTab=teamReportPage");
	}
	//初始化目标看板
	function initTargetBoard(){
		//点击目标时间按钮，修改对应按钮样式并加载数据
		$("#targetTimeBtn > button").click(function(){
			//设置点击后的按钮样式
			$("#targetTimeBtn .btn-primary").addClass("btn-white");
			$("#targetTimeBtn .btn-primary").removeClass("btn-primary");
			$(this).removeClass("btn-white");
			$(this).addClass("btn-primary");
			loadTargetBoard();
		});
		loadTargetBoard();
	}
	//加载目标看板主页
	function loadTargetBoard()
	{
		var queryTargetIndex = $("#targetIndexBtn").text();
		var queryTargetTime = $("#targetTimeBtn .btn-primary").attr('name');
		$.ajax({
			url: '<%=basePath%>/summaryTask/summaryTaskTargetBoard.do',
			type: 'post',
			data: {
				//取员工编号;取目标看板的查询条件-维度/时间段
				'queryEmpCode': $("#queryEmpCode").val(),
				'queryTargetIndex': queryTargetIndex,
				'queryTargetTime':queryTargetTime
			},
			success : function(data){
				var obj = eval('(' + data + ')')
				if(obj.errorMsg){
					top.Dialog.alert(obj.errorMsg);
				}else{
					//$("#projectListTbody").empty();
					if(obj){
						echartsTargetBoard(obj);
					}else{
						top.Dialog.alert("加载目标看板数据出错");
					}
				}
			}
		});
	}
	//
	function echartsTargetBoard(obj){
		
		var dateTypeList = new Array();//右侧列表横轴时间列表
		var targetList = new Array();//目标值列表
		var finishList = new Array();//完成值列表
		var rateList = new Array();//完成率列表
		$.each(obj.resultDetail, function(i, task){
			if('monthWeek'==obj.dateType){
				dateTypeList[i]= "第"+task.week+"周";
			}else if('yearMonth'==obj.dateType){
				dateTypeList[i]= task.month+"月";
			}
			targetList[i] = task.targetCount.toFixed(2);
			finishList[i] = task.finishCount.toFixed(2);
			if(task.targetCount > 0 ){
				rateList[i] = (task.finishCount*100/task.targetCount).toFixed(2);
			}else{
				rateList[i] = 0;
			}
		});
		var targetCount = obj.resultSum.targetCount;
		var finishCount = obj.resultSum.finishCount;
		var finishRate = 0;
		if(targetCount > 0 ){
			finishRate = ((finishCount*100)/targetCount).toFixed(2);
		}else{
			targetCount=1;
			finishRate=0;
		}
		//echarts图表配置
		var a=echarts.init(document.getElementById("target-bar-chart")),
			b={
				//title:{text:"某地区蒸发量和降水量"},
				tooltip:{trigger:"axis"},
				legend:{
					data:['目标值','完成值','完成率'],
					x:'center',
					y:200
				},
				grid:{x:30,x2:50,y:30,y2:70},
				calculable:!0,
				xAxis:[
					{
					type:"category",
					data:dateTypeList
					}
					],
				yAxis: [
				        {
				            type: 'value',
				            name: '目标',
				            min: 0,
				            //max: 250,
				            interval: 50,
				            axisLabel: {
				                formatter: '{value} '
				            }
				        },
				        {
				            type: 'value',
				            name: '完成率',
				            min: 0,
				            max: 100,
				            interval: 5,
				            axisLabel: {
				                formatter: '{value} %'
				            }
				        }
				    ],
				series:[
					{
					name:"目标值",
					type:"bar",
					data:targetList,
					itemStyle:{normal:{color:'#43acf7'}}
					},
					{
			            name:'完成值',
			            type:'bar',
			            data:finishList,
			            itemStyle:{normal:{color:'#1c84c6'}}
			        },
					{
		            name:'完成率',
		            type:'line',
		            yAxisIndex: 1,
		            data:rateList,
		            itemStyle:{normal:{color:'#ff9f0f'}}
			        }
					//{name:"降水量",type:"bar",data:[2.6,5.9,9,26.4,28.7,70.7,175.6,182.2,48.7,18.8,6,2.3]}
					]
				};
				a.setOption(b),
				window.onresize=a.resize;
				
				var e=echarts.init(document.getElementById("echarts-gauge-chart")),
				f={
					tooltip : {
						formatter: "{a} <br/>{b} : {c}"
					},
					toolbox: {
						feature: {
							restore: {},
							saveAsImage: {}
						}
					},
					series: [
						{
							name: '销售额',
							type: 'gauge',
							min:0,
							max:targetCount, //目标值
							splitNumber:5,
							axisLine: {            // 坐标轴线
				                show: true,        // 默认显示，属性show控制显示与否
				                lineStyle: {       // 属性lineStyle控制线条样式
				                    color: [[0.2, '#fb4c55'],[0.4, '#ff9f0f'],[0.8, '#23c6c8'],[1, '#1c84c6']], 
				                    width: 30
				                }
				            },
							startAngle: 180,
				            endAngle: 0,
				            radius : 120,
				            center : ['50%', 155],
							detail: {
								formatter:finishRate+'%',
								offsetCenter: [0, 10]
								},
							data: [{value:finishCount , name: '完成量'}]//实际值
						}
					]
				};
				e.setOption(f),
				$(window).resize(e.resize);
	}
	//点击跳转到团队日清主页
	function goTargetDetail()
	{
		var code = $("#queryEmpCode").val();
		siMenu('targetDetail', 'targetDetail', '目标明细', "summaryTask/goTargetDetail.do?queryEmpCode="+code);
	}
</script>
</body>

</html>