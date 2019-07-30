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
    <meta name="keywords" content="H+后台主题,后台bootstrap框架,会员中心主题,后台HTML,响应式后台">
    <meta name="description" content="H+是一个完全响应式，基于Bootstrap3最新版本开发的扁平化主题，她采用了主流的左右两栏式布局，使用了Html5+CSS3等现代技术">

    <link rel="shortcut icon" href="favicon.ico">
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
    <link href="static/summaryTask/css/style.min.css?v=4.0.0" rel="stylesheet"><base target="_blank">

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
		.project-actions{width:90px;}
		body{
		    font-family: Avenir,Chinese Quote,-apple-system,BlinkMacSystemFont,Segoe UI,PingFang SC,Hiragino Sans GB,Microsoft YaHei,Helvetica Neue,Helvetica,Arial,sans-serif;
		}
	</style>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content">
        <div class="row">
            <div class="col-sm-8">
				<div class="ibox float-e-margins" id="iboxSummaryTask">
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
                            <a data-toggle="collapse" data-parent="#ibox" href="#iboxOne">
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
					<div class="collapse in" id="iboxOne">
						<div class="ibox-content" >
							<div id="summaryBusinessTask"></div>
							<div style="clear:both;"></div>
						</div>
					</div>
				</div><!--ibox-->
				
				<div class="ibox float-e-margins" id="iboxUnfinish">
					<div class="ibox-title">
						<h5>待办事项</h5> <!-- 待分解、待审核等 -->
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-map-o"></i></span>
						<div class="ibox-tools">
							<span style="padding:0 10px;cursor:pointer" onclick="goscheduleList()">进入待办事项</span>
							<a data-toggle="collapse" data-parent="#ibox" href="#iboxTwo" >
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
					<div class="collapse in" id="iboxTwo">
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
								onclick="changelimit(this)" type="button">展开</button>
						</div>
					</div><!--ibox-->
				</div><!-- ibox -->
				
				<div class="ibox float-e-margins" id="iboxEmpTask">
					<div class="ibox-title">
						<h5>工作清单</h5> 
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-reorder"></i></span>
						<div class="ibox-tools">
							<span style="padding:0 10px;cursor:pointer" onclick="goWorkList()">进入工作清单</span>
							<a data-toggle="collapse" data-parent="#ibox" href="#iboxThree">
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
				
					<div class="collapse in" id="iboxThree">
						<div class="ibox-content">
							<div class="project-list">
	                            <table class="table table-hover">
	                                <tbody id="empTaskTbody">
	                                    
									</tbody>
								</table>
							</div>
							<button id="loadEmpTaskIcon" class="btn btn-primary btn-xs" style = "float:right; margin-top: -10px;" 
								onclick="changelimit(this)" type="button">展开</button>
						</div>
	                </div><!--iboxThree-->
				</div><!-- ibox -->
				
				<div class="ibox float-e-margins" id="ibox">
					<div class="ibox-title">
						<h5>维修工单</h5> 
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-th-list"></i></span>
						<div class="ibox-tools">
							<span style="padding:0 10px;cursor:pointer" onclick="goRepairOrderList()">进入维修工单</span>
							<a data-toggle="collapse" data-parent="#ibox" href="#iboxRepairOrderList" >
								<i class="fa fa-chevron-up"></i>
							</a>
						</div>
					</div>
					<div class="collapse in" id="iboxRepairOrderList">
						<div class="ibox-content">
							<div class="project-list">
		                        <table class="table table-hover">
		                            <tbody id="repairOrderListTbody">
		                                   
									</tbody>
								</table>
							</div>
							<!-- <a  style="padding:0 10px; float:right"
								><i class="fa fa-chevron-down"></i></a> -->
							<button id="loadRepairOrderListIcon" class="btn btn-primary btn-xs" style = "float:right; margin-top: -10px;" 
								type="button">展开</button>
						</div>
					</div><!--ibox-->
				</div><!-- ibox -->
				
				<div class="ibox float-e-margins" id="ibox">
					<div class="ibox-title">
						<h5>表单工作</h5> 
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-th"></i></span>
						<div class="ibox-tools">
							<a data-toggle="collapse" data-parent="#ibox" href="#iboxFormWorkList" >
								<i class="fa fa-chevron-up"></i>
							</a>
						</div>
					</div>
					<div class="collapse in" id="iboxFormWorkList">
						<div class="ibox-content">
							<div class="project-list">
		                        <table class="table table-hover">
		                            <tbody id="formWorkListTbody">
		                                   
									</tbody>
								</table>
							</div>
							<!-- <a  style="padding:0 10px; float:right"
								><i class="fa fa-chevron-down"></i></a> -->
							<button id="loadFormWorkListIcon" class="btn btn-primary btn-xs" style = "float:right; margin-top: -10px;" 
								type="button">展开</button>
						</div>
					</div><!--ibox-->
				</div><!-- ibox -->
				
			</div><!--col-sm-8-->
			<div class="col-sm-4">
			
				<div class="ibox float-e-margins" id="ibox" >
                   <div class="ibox-title">
						<h5>公司公告</h5> 
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-newspaper-o"></i></span>
						<div class="ibox-tools">
							<a data-toggle="collapse" data-parent="#ibox" href="#iboxMsg" >
								<i class="fa fa-chevron-up"></i>
							</a>
						</div>
					</div>
					
                    <div class="collapse in" id="iboxMsg">
						<div class="ibox-content">
							<div class="project-list">
		                        <table class="table table-hover">
		                            <tbody id="msgListTbody">
		                                   
									</tbody>
								</table>
							</div>
							<button id="loadMsgListIcon" class="btn btn-primary btn-xs" style = "float:right; margin-top: -10px;" 
								type="button">展开</button>
						</div>
					</div><!--ibox-->
				</div><!--ibox-->
				
				<div class="ibox float-e-margins" id="ibox">
					<div class="ibox-title">
						<h5>工作日清</h5> 
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-calendar"></i></span>
						<div class="ibox-tools">
							<%-- <span style="padding:0 10px;" onclick="goDailyList()>进入日清主页</span> --%>
							<a data-toggle="collapse" data-parent="#ibox" href="#iboxFive">
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
					<div class="collapse in" id="iboxFive">
						<div class="ibox-content">
							<table id="positionTaskTips" style="margin-left:10px;">
								<tr>
								<td class="commitTask" style="width:32px;height:20px;"></td>
								<td style="padding:0 10px;">已交</td>
								<td class="unCommitTask" style="width:32px;height:20px;"></td>
								<td style="padding:0 10px;">未交</td>
								<!-- <td class="delayCommitTask" style="width:32px;height:20px;"></td>
								<td style="padding:0 10px;">补交</td> -->
								</tr>
							</table>
							<!--日历控件-->
							 <div id="index_calendar"></div>
							<!--日历控件结束-->	
						</div>
	                </div>
				</div><!--ibox-->
				
				<div class="ibox float-e-margins" id="ibox" style="display:none">
                    <div class="ibox-title" style="height:80px">
						<h5>榜上有名(前30)</h5>
						<span class="label" style="background:#fff; color:#5e5e5e; margin-top:-1px;"><i class="fa fa fa-bar-chart-o"></i></span>
                        <div class="ibox-tools">
                            <input type="text" id="queryMonth" style="margin-right:20px;padding:0 10px;width:90px;background:#fff!important;" 
                              readonly="readonly" onchange="loadTaskScore();"/>
                            <a data-toggle="collapse" data-parent="#ibox" href="#iboxFour">
                                <i class="fa fa-chevron-up"></i>
                            </a>
                        </div>
                        <div style="clear:both;"></div>
                        <div class="m-t" style="text-align:center;">
	                    <span style="margin-right:50px;" id="ownranking">我的排名</span>
						<span id="ownscore">我的积分</span>
						</div>
                    </div>
                    
                    
					<div class="collapse in" id="iboxFour">
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
							onclick="changelimit(this)" type="button">展开</button>	
						</div>
					</div>
				</div><!--ibox-->
				
			</div><!--col-sm-4-->
			<!--<button onClick="LoginQueryAccount()">load</button>
			<div class="rightdiv"></div>-->
		</div><!-- row -->
	</div><!-- wrapper -->
	
	
	<!-- 系统通知的模态框（Modal） -->
		<div class="modal fade" id="modal" aria-labelledby="modalLabel" tabindex="-1" role="dialog" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content">
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		                <h4 class="modal-title" id="modalLabel">未查看的系统通知(7天内发布)</h4>
		            </div>
		            <div class="modal-body" style="height:300px; text-align:center;">
		            	
		            	<!-- 显示内容 -->
		            	<div class="project-list">
	                        <table class="table table-hover">
	                            <tbody id="needNoticeListTbody">
	                                   
								</tbody>
							</table>
						</div><!-- 显示内容end -->
						
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		            </div>
		        </div><!-- /.modal-content -->
		    </div><!-- /.modal -->
		</div>
	
    <script src="static/summaryTask/js/jquery.min.js?v=2.1.4"></script>
    <script src="static/summaryTask/js/bootstrap.min.js?v=3.3.5"></script>
	
	<!-- 日历 -->
	<script type="text/javascript" src="static/summaryTask/js/DatePicker/calendar.js"></script>
	<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
	
	<script></script>
</body>

</html>