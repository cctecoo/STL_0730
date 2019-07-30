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
		<base href="<%=basePath%>"><!-- jsp文件头和头部 -->
		<link href="plugins/Bootstrap/css/bootstrap.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/navigation/assets/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/assets/css/jquery-ui-1.10.3.custom.min.css" />
		<link rel="stylesheet" href="static/assets/css/chosen.css" />
		<link rel="stylesheet" href="static/assets/css/datepicker.css" />
		<link rel="stylesheet" href="static/assets/css/bootstrap-timepicker.css" />
		<link rel="stylesheet" href="static/assets/css/daterangepicker.css" />
		<link rel="stylesheet" href="static/assets/css/colorpicker.css" />
		<link rel="stylesheet" href="static/assets/css/ace.min.css" />
		<link rel="stylesheet" href="static/assets/css/ace-rtl.min.css" />
		<link rel="stylesheet" href="static/assets/css/ace-skins.min.css" />
		<link rel="StyleSheet" href="static/css/style.css" type="text/css" />
		<link rel="stylesheet" href="static/assets/css/bootstrap-timepicker.css" />
	
		<style type="text/css">
			.f_deta{
				 width: 180px; 
				 float: left;
			}
			input[type=checkbox]+.lbl::before, input[type=radio]+.lbl::before{height:15px;min-width:15px;}
			.btn-style1{width:50px; height:30px; font-size:12px; padding:7px 12px; background:#3598dc; color:#fff;}
			.btn-style2{width:50px; height:30px; font-size:12px; padding:7px 12px; background:#888888; color:#fff;}
			.btn-style3{width:50px; height:30px; font-size:12px; padding:7px 12px; background:#5bc0de; color:#fff;}
			.employee_top{padding-top:10px; border-bottom:2px solid #98c0d9; z-index:10000;position:fixed;width:100%;background-color:white; line-height:40px; margin-bottom:15px;}
			.employee_title{float:left; margin-left:20px; border-bottom:3px solid #448fb9; height:38px; font-size:24px; color:#448fb9;}
			.employee_search{float:right;}
			.employee_search a:hover{color:#fff;}
			.pushmessage{width:100%;min-width:500px;padding-top:30px;padding-left:50px;font-size:16px; }
			.pushmessage_title{font-size:20px;padding-left:5px;border-left:5px solid #5090c1;margin-left:20px;}
			.pushmessage span{margin-right:30px;}
			.pushmessage .option{margin-bottom:30px;}
			.pushmessage .option_info{margin-bottom:30px; display:none;}
			.btn-mini{padding:0 6px;}
						
			input[type="checkbox"],input[type="radio"] {
				opacity:1 ;
				position: static;
				height:25px;
				margin-bottom:10px;
			}
		</style>
	</head>
<body>
	<fmt:requestEncoding value="UTF-8" />
	<form action="configPlan/saveRemind.do" method="post" name="configForm" id="configForm">
	<input type="hidden" name="ID" id="ID" value="${plan.ID }" title="计划ID" />
	<input type="hidden" name="MESSAGETYPE1" id="MESSAGETYPE1" value="${plan.MESSAGETYPE }" />
	<input type="hidden" name="TYPE1" id="TYPE1" value="${plan.TYPE }" />
	<input type="hidden" name="WEEK1" id="WEEK1" value="${plan.WEEK }" />
	<div class="employee_top">
			<div class="employee_title">消息通知配置</div>
			<div class="employee_search">
				<a class="btn-style1" style="margin-right:10px;cursor:pointer" onclick="save();">保存</a>
				<!-- <a class="btn-style2" style="margin-right:10px;cursor:pointer" onclick="view();">报告预览</a>
				<a class="btn-style3" style="margin-right:10px;cursor:pointer" onclick="goBack();">返回</a> -->
			</div>
			<div id="cleaner"></div>
		</div>	
	<div class="main-container-left" style="padding-top:52px;">
		<div class="m-c-l-top">
			<img src="static/images/ui1.png" style="margin-top:-5px;">配置类型
		</div>
	
		<table class="table table-striped table-hover" data-min="11" data-max="30" cellpadding="0" cellspacing="0" style="border-bottom:1px solid #ddd;">
		  <thead>
				<tr onclick="showDetail('common',$(this));" style="cursor:pointer" class="active">
					<td class="center">通用配置</td>				
				</tr>
				<tr onclick="showDetail('aim',$(this));" style="cursor:pointer">
					<td class="center">目标工作</td>				
				</tr>
				<tr onclick="showDetail('group',$(this));" style="cursor:pointer">
					<td class="center">协同工作</td>				
				</tr>
				<tr onclick="showDetail('flow',$(this));" style="cursor:pointer">
					<td class="center">流程工作</td>				
				</tr>
				<tr onclick="showDetail('temp',$(this));" style="cursor:pointer">
					<td class="center">临时工作</td>				
				</tr>
				<tr onclick="showDetail('daily',$(this));" style="cursor:pointer">
					<td class="center">日常工作</td>				
				</tr>
			</thead>										
			<tbody>					
			<!-- 开始循环 -->	
			<%-- <c:choose>
				<c:when test="${not empty varList}">
					<c:forEach items="${varList}" var="kpiModel" varStatus="vs">
						<tr onclick="showDetail('${kpiModel.ID}',$(this));" style="cursor:pointer">
							<td class='center' style="width: 30px;">
								<label>
									<input type='checkbox' name='ids' kpiid ="${kpiModel.ID}"  value="${kpiModel.ID}" /><span class="lbl"></span>
								</label>
							</td>
							<td>${kpiModel.CODE}</td>
							<td>${kpiModel.NAME}</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr class="main_info">
						<td colspan="100" class="center" >没有相关数据</td>
					</tr>
				</c:otherwise>
			</c:choose> --%>
			</tbody>
		</table>
	</div>
	
	<div class="main-content" style="margin-left:222px;padding-top:75px">
	<!-- <div class="pushmessage_title">推送规则</div> -->
		<!-- 通用配置 -->
		<div class="pushmessage" id="common">
			<div class="option">
				接收消息提醒方式：
				<br><br>
				<!-- <span style="color:#000;">推送规则</span> -->
				<input type="checkbox" class="ace" name="MESSAGETYPE" id="pc" value="pc"/>
				<span class="lbl" style="margin-top:-5px;"> </span>
				<span>PC端</span>
				<input type="checkbox" class="ace" name="MESSAGETYPE" id="weixin" value="weixin"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>  微信端</span>
				<input type="checkbox" class="ace" name="MESSAGETYPE" id="mail" value="mail"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>  邮件端</span>
			</div>
			<div class="option">
				接收消息提醒时间：
				<br><br>
				
				<div style="display:table;">
					<input type="radio" class="ace" name = "TIME" value="all"<c:if test="${plan.TIME == 'all'}">checked="checked"</c:if>/>
					<span class="lbl" style="margin-top:-8px;"></span>
					<span>  全天</span>
					<input type="radio" class="ace" name = "TIME" value="other"<c:if test="${plan.TIME == 'other'}">checked="checked"</c:if>/>
					<span class="lbl" style="margin-top:-8px;"></span>
					<span>  其他</span>
					<div class="input-group bootstrap-timepicker" style="display:table-cell;">
						<input id="STARTTIME" type="text" style="width:80px; display:table-cell;" name ="STARTTIME" value="${plan.STARTTIME }"/>				
					</div>
	                &nbsp;&nbsp; - &nbsp;&nbsp;
					<div class="input-group bootstrap-timepicker" style="display:table-cell;">
						<input id="ENDTIME" type="text" style="width:80px; display:table-cell;" name ="ENDTIME" value="${plan.ENDTIME }"/>					
					</div>
				</div>
			</div>
			<div class="option">
				接收消息提醒日期：
				<br><br>
				<input type="checkbox" class="ace" name="WEEK" id="week2" value="2"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>  周一</span>
				<input type="checkbox" class="ace" name="WEEK" id="week3" value="3"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>  周二</span>
				<input type="checkbox" class="ace" name="WEEK" id="week4" value="4"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>  周三</span>
				<input type="checkbox" class="ace" name="WEEK" id="week5" value="5"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>  周四</span>
				<input type="checkbox" class="ace" name="WEEK" id="week6" value="6"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>  周五</span>
				<input type="checkbox" class="ace" name="WEEK" id="week7" value="7"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>  周六</span>
				<input type="checkbox" class="ace" name="WEEK" id="week1" value="1"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>  周日</span>
			</div>
		</div>
		<!-- 目标工作 -->
		<div class="pushmessage" id="aim" style = "display: none">
			<div class="option">
				超期预警提醒规则：
				<br><br>
				<div style="display:table;">
				<input type="checkbox" class="ace" name="TYPE" value="businessTaskRemind" id="businessTaskRemind"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				目标工作超期前
				<input id="AIMTIME" type="text" style="width:50px;margin:0 10px;" name ="AIMTIME" value="${plan.AIMTIME }" 
					onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();"/>天
				<div class="input-group bootstrap-timepicker" style="display:table-cell;">
				<input id="AIMREMINDTIME" type="text" style="width:80px; display:table-cell;margin:0 10px;" name ="AIMREMINDTIME" value="${plan.AIMREMINDTIME }"/>
				</div>提醒
				</div>
				<br>
				提醒事项选择：
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="yeartarget,yeardepttask,monthdepttask,bmonthemptarget" id="yeartarget"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>待分解消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="businessTaskOver" id="businessTaskOver"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>工作超期消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="commitBusinessTask" id="commitBusinessTask"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>审核完成情况消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="businessTaskCheckComplete,businessReject" id="businessTaskCheckComplete"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>完成情况通过/退回消息提醒</span>
			</div>
		</div>
		<!-- 协同工作 -->
		<div class="pushmessage" id="group" style = "display: none">
			<div class="option">
				超期预警提醒规则：
				<br><br>
				<div style="display:table;">
				<input type="checkbox" class="ace" name="TYPE" value="projectTaskRemind" id="projectTaskRemind"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				协同工作超期前<input id="GROUPTIME" type="text" style="width:50px;margin:0 10px;" name ="GROUPTIME" value="${plan.GROUPTIME }" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();"/>天
				<div class="input-group bootstrap-timepicker" style="display:table-cell;">
				<input id="GROUPREMINDTIME" type="text" style="width:80px; display:table-cell;margin:0 10px;" name ="GROUPREMINDTIME" value="${plan.GROUPREMINDTIME }"/>
				</div>提醒
				</div>
				<br>
				提醒事项选择：
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="cproject" id="cproject"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>待分解消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE"  value="cprojectAudit,cprojectSign,projectAcceptance" id="cprojectAudit"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>审核/会审/验收工作消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="projectCheckComplete,projectAcceptanceCommit" id="projectCheckComplete"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>审核/验收通过消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="projectReject,projectAcceptanceUnfinish" id="projectReject"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>审核/验收不通过消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="projectTaskOver" id="projectTaskOver"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>工作超期消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="commitCreativeTask,evaluateCreativeTask" id="commitCreativeTask"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>完成情况消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="creativeTaskCheckComplete,creativeTaskReject" id="creativeTaskCheckComplete"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>完成情况通过/退回消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="evaluateCreativeTaskComplete" id="evaluateCreativeTaskComplete"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>评价完成情况消息提醒</span>
			</div>
		</div>
		<!-- 临时工作 -->
		<div class="pushmessage" id="temp" style = "display: none">
			<div class="option">
				超期预警提醒规则：
				<br><br>
				<div style="display:table;">
				<input type="checkbox" class="ace" name="TYPE" value="tempTaskRemind" id="tempTaskRemind"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				临时工作超期前<input id="TEMPTIME" type="text" style="width:50px;margin:0 10px;" name ="TEMPTIME" value="${plan.TEMPTIME }" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();"/>天
				<div class="input-group bootstrap-timepicker" style="display:table-cell;">
				<input id="TEMPREMINDTIME" type="text" style="width:80px; display:table-cell;margin:0 10px;" name ="TEMPREMINDTIME" value="${plan.TEMPREMINDTIME }"/>
				</div>提醒
				</div>
				<br>
				提醒事项选择：
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="empDailyTaskAudit" id="empDailyTaskAudit"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>审核工作消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="empDailyTask" id="empDailyTask"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>审核通过消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE"  value="empDailyTaskReject" id="empDailyTaskReject"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>审核不通过消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE"  value="tempTaskOver" id="tempTaskOver"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>工作超期消息提醒</span>
<!-- 				<br><br>
				<input type="checkbox" class="ace" name="TYPE"  value="commitTempTask" id="commitTempTask"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>审核完成情况消息提醒</span> -->
				<br><br>
				<input type="checkbox" class="ace" name="TYPE"  value="commitTempTaskReject,commitTempTaskAssess" id="commitTempTaskReject"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>完成情况通过/退回消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE"  value="commitTempTask" id="commitTempTask"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>评价完成情况消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE"  value="commitTempTaskAssess" id="commitTempTaskAssess"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>完成情况已评价消息提醒</span>
			</div>
		</div>
		<!-- 流程工作 -->
		<div class="pushmessage" id="flow" style = "display: none">
			<div class="option">
				超期预警提醒规则：
				<br><br>
				<div style="display:table;">
				<input type="checkbox" class="ace" name="TYPE" value="flowOver" id="flowOver"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				流程工作转交后<input id="FLOWTIME" type="text" style="width:50px;margin:0 10px;" name ="FLOWTIME" value="${plan.FLOWTIME }" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();"/>天
				<div class="input-group bootstrap-timepicker" style="display:table-cell;">
				<input id="FLOWREMINDTIME" type="text" style="width:80px; display:table-cell;margin:0 10px;" name ="FLOWREMINDTIME" value="${plan.FLOWREMINDTIME }"/>
				</div>提醒
				</div>
				<br>
				提醒事项选择：
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="flow,passFlow" id="passFlow"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>接收工作消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="flowReject" id="flowReject"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>退回工作消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="flowComplete" id="flowComplete"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>工作结束消息提醒</span>
			</div>
		</div>
		<!-- 日常工作 -->
		<div class="pushmessage" id="daily" style = "display: none">
			<div class="option">
				超期预警提醒规则：
				<br><br>
				<div style="display:table;">
					<input type="checkbox" class="ace" name="TYPE" value="dailyTaskRemind" id="dailyTaskRemind"/>
					<span class="lbl" style="margin-top:-8px;"></span>
					<span style="display:table-cell;padding-right:30px;"">日常工作提醒时间：</span>
					<div class="input-group bootstrap-timepicker" style="display:table-cell;">
						<input id="DAILYTIME" type="text" style="width:80px; display:table-cell;" name ="DAILYTIME" value="${plan.DAILYTIME }"/>					
					</div>
				</div>
				<br>
				提醒事项选择：
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="commitDailyTask" id="commitDailyTask"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>审核日常工作消息提醒</span>
				<br><br>
				<input type="checkbox" class="ace" name="TYPE" value="dailyTaskCheckComplete,dailyTaskReject" id="dailyTaskReject"/>
				<span class="lbl" style="margin-top:-8px;"></span>
				<span>完成情况通过/退回消息提醒</span>
			</div>
		</div>
		
	</div>	
		
</form>
		
	
	
	<!-- 引入 -->
	<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
	
	<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
	<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
	<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
	<!-- 引入 -->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
	<script src="static/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<script src="static/assets/js/date-time/bootstrap-datetimepicker.zh-CN.js"></script>
	<script src="static/assets/js/date-time/bootstrap-timepicker.min.js"></script>
	<script src="static/assets/js/date-time/moment.min.js"></script>
	<script src="static/assets/js/date-time/daterangepicker.min.js"></script>
	
	<script>
	
	</script>
	<script type="text/javascript">
	$(function(){
		var browser_height = $(window).height();
		//alert(browser_height);
		$("div.main-container-left").css("min-height",browser_height);
		$(window).resize(function() { 
		var browser_height = $(window).height();
		$("div.main-container-left").css("min-height",browser_height);
		}); 
		});
	
	
		function save(){
			//通用配置，选择了其它时间，则必须填写时间
			if ($("input:radio[name='TIME']:checked").val() == "other") {
				if($("#STARTTIME").val==''||$("#STARTTIME").val==null||$("#ENDTIME").val==''||$("#ENDTIME").val==null)
				{
					alert("请填写时间段");
					return false;
				}
			}
			$.ajax({
                type: "POST",
                url: 'configPlan/saveRemind.do',
                data:$('#configForm').serialize(),
                success: function(data) {
                	if("success" == data.biaozhi){
	                    alert("保存成功");
	                	window.location.reload();
                	}else{
                		alert("保存失败");
                	}
                },
                error:function(data) {
                	alert("保存失败");
                }
            });
		}
		
		//检索
		function search(){
			$("#Form").submit();
		}
		
		
		function showDetail(type,$obj){
			if(type == "daily")
			{
				document.getElementById("common").style.display = 'none';
				document.getElementById("flow").style.display = 'none';
				document.getElementById("group").style.display = 'none';
				document.getElementById("temp").style.display = 'none';
				document.getElementById("aim").style.display = 'none';
				document.getElementById("daily").style.display = '';
				$obj.addClass("active");
				$obj.siblings().removeClass("active");
			}
			else if(type == "common")
			{
				document.getElementById("common").style.display = '';			
				document.getElementById("flow").style.display = 'none';
				document.getElementById("group").style.display = 'none';
				document.getElementById("temp").style.display = 'none';
				document.getElementById("aim").style.display = 'none';
				document.getElementById("daily").style.display = 'none';
				$obj.addClass("active");
				$obj.siblings().removeClass("active");
			}
			else if(type == "flow")
			{
				document.getElementById("common").style.display = 'none';			
				document.getElementById("flow").style.display = '';
				document.getElementById("group").style.display = 'none';
				document.getElementById("temp").style.display = 'none';
				document.getElementById("aim").style.display = 'none';
				document.getElementById("daily").style.display = 'none';
				$obj.addClass("active");
				$obj.siblings().removeClass("active");
			} 
			else if(type == "group")
			{
				document.getElementById("common").style.display = 'none';			
				document.getElementById("flow").style.display = 'none';
				document.getElementById("group").style.display = '';
				document.getElementById("temp").style.display = 'none';
				document.getElementById("aim").style.display = 'none';
				document.getElementById("daily").style.display = 'none';
				$obj.addClass("active");
				$obj.siblings().removeClass("active");
			}
			else if(type == "temp")
			{
				document.getElementById("common").style.display = 'none';			
				document.getElementById("flow").style.display = 'none';
				document.getElementById("group").style.display = 'none';
				document.getElementById("temp").style.display = '';
				document.getElementById("aim").style.display = 'none';
				document.getElementById("daily").style.display = 'none';
				$obj.addClass("active");
				$obj.siblings().removeClass("active");
			}
			else if(type == "aim")
			{
				document.getElementById("common").style.display = 'none';			
				document.getElementById("flow").style.display = 'none';
				document.getElementById("group").style.display = 'none';
				document.getElementById("temp").style.display = 'none';
				document.getElementById("aim").style.display = '';
				document.getElementById("daily").style.display = 'none';
				$obj.addClass("active");
				$obj.siblings().removeClass("active");
			}
		}
		
		
		</script>
		
	<script type="text/javascript">

    var input = document.createElement("input");
    input.type="text" ;
    input.style.width="60px";
	input.style.padding="0px";  
    //得到当前的单元格
    var currentCell ; 
    var cHtml="";
    function editCell(event)
    {
        if(event==null) {
            currentCell=window.event.srcElement;
        }
        else{
            currentCell=event.target;
        }
        //根据Dimmacro 的建议修定下面的bug 非常感谢
        if(currentCell.tagName=="TD"){
        //用单元格的值来填充文本框的值
        input.value=currentCell.innerHTML;
        cHtml=currentCell.innerHTML;
       	//当文本框丢失焦点时调用last
        input.onblur=last;
        input.ondblclick=last;
        currentCell.innerHTML="";
        //把文本框加到当前单元格上.
        currentCell.appendChild(input);
        input.focus();
        }
    }   
    function last(){
    	//判断当前输入框中的值是不是数字
    	var inputValue=input.value.replace(/\s+/g,"");
    	var re = /^([1-9]\d{0,11}|0)(\.\d{1,2})?$/;
    	if(1){
    	//充文本框的值给当前单元格
        currentCell.innerHTML = input.value;
    	}else{
			alert("数据格式错误，小数点后最多两位!");     
			currentCell.innerHTML=cHtml;
			return;
    	}

    	
    }
    
    $('.date-picker').datepicker({autoclose:true,language:'CN'}).next().on(ace.click_event, function(){
		$(this).prev().focus();
	});
	
	$('input[name=date-range-picker]').daterangepicker().prev().on(ace.click_event, function(){
		$(this).next().focus();
	});
	
	$('#STARTTIME').timepicker({
		minuteStep: 1,
		showSeconds: true,
		showMeridian: false
	}).next().on(ace.click_event, function(){
		$(this).prev().focus();
	});
	$('#ENDTIME').timepicker({
		minuteStep: 1,
		showSeconds: true,
		showMeridian: false
	}).next().on(ace.click_event, function(){
		$(this).prev().focus();
	});
	$('#DAILYTIME').timepicker({
		minuteStep: 1,
		showSeconds: true,
		showMeridian: false
	}).next().on(ace.click_event, function(){
		$(this).prev().focus();
	});
	$('#AIMREMINDTIME').timepicker({
		minuteStep: 1,
		showSeconds: true,
		showMeridian: false
	}).next().on(ace.click_event, function(){
		$(this).prev().focus();
	});
	$('#GROUPREMINDTIME').timepicker({
		minuteStep: 1,
		showSeconds: true,
		showMeridian: false
	}).next().on(ace.click_event, function(){
		$(this).prev().focus();
	});
	$('#TEMPREMINDTIME').timepicker({
		minuteStep: 1,
		showSeconds: true,
		showMeridian: false
	}).next().on(ace.click_event, function(){
		$(this).prev().focus();
	});
	$('#FLOWREMINDTIME').timepicker({
		minuteStep: 1,
		showSeconds: true,
		showMeridian: false
	}).next().on(ace.click_event, function(){
		$(this).prev().focus();
	});

	</script>
	<script>
		$(function(){
			var str = $("#MESSAGETYPE1").val()+'';
			$(str.split(",")).each(function (i,dom){
				var str = dom;
				document.getElementById(str).checked = "checked";
				//$("input:checkbox[id='week'"+dom+"]:checked").val().prop("checked",true);  
		    });
			var str2 = $("#TYPE1").val()+'';
			$(str2.split(",")).each(function (i,dom){
				var str = dom;
				if(document.getElementById(str)!=null)
				{
					document.getElementById(str).checked = "checked";
				}
				//$("input:checkbox[id='week'"+dom+"]:checked").val().prop("checked",true);  
		    });
			var str3 = $("#WEEK1").val()+'';
			$(str3.split(",")).each(function (i,dom){
				var str = 'week'+dom;
				if(document.getElementById(str)!=null)
				{
					document.getElementById(str).checked = "checked";
				}
				//$("input:checkbox[id='week'"+dom+"]:checked").val().prop("checked",true);  
		    });
		})
	</script>
		
	</body>
</html>

