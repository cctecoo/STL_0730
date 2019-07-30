<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<base href="<%=basePath%>">
    <title>新增日清日报</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no"/>
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<link rel="stylesheet" href="static/app/css/mui.min.css" />
	<link rel="stylesheet" href="static/app/css/style.css" />
	<link rel="stylesheet" href="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.css" />
	<link rel="stylesheet" href="plugins/Bootstrap/css/bootstrap.min.css" />
	<script type="text/javascript" src="static/app/js/mui.min.js"></script>
	<script type="text/javascript" src="static/app/js/jquery.min.js"></script>
	<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>

	<style type="text/css">
		textarea{
			width:100%;
			height:41px;
			margin:0;
			font-size:10px; 
			overflow-y:hidden;
			border-style:solid #ccc;
			border-width:0px 0px 1px 0px;
		}
		.mui-card-header{font-size:14px;}
	</style>
</head>
<body style="margin-top:50px;">
	<form name="dailyReportForm" id="dailyReportForm" method="post">
	<input type="text" id="daily_task_id" name="daily_task_id" value="${task.ID}" style="display:none">
	<input type="hidden" name="targetCompleteInfo" value="${pd.targetCompleteInfo}">
	<input type="hidden" name="jobCompleteInfo" value="${pd.jobCompleteInfo}">
	<input type="hidden" name="torrowTaskInfo" value="${pd.torrowTaskInfo}">
	<input type="hidden" id="date" name="date" value="${task.datetime}">
		<div class="web_title fixed">
			<div class="back"><a onclick="deleteDailyReport()"><img src="static/app/images/left.png"></a></div>
			新增日清日报
			<span><a onclick="submitDailyReport()">提交</a></span>
		</div>
		<div class="mui-content">
			<!--目标完成情况-->
			<c:if test="${!empty pd.targetCompleteList}">
			<div class="mui-card">
				<div class="mui-card-header">
					目标完成情况
					<span class="fr">${pd.targetCompleteInfo}</span>
				</div>
				<div class="mui-card-content">
					<div class="mui-card-content-inner">
					<c:forEach items="${pd.targetCompleteList}" var="target">
						<div class="col-md-4 m-b">
                            <div class="ibox float-e-margins" style="border:1px solid #ccc;">
								<div class="ibox-content" style="line-height:2.5;">
									<table style="width:100%;border-bottom:1px solid #ccc;">
										<tr>
											<td style="width:50%;padding-left:5px;"><h5>指标（元）</h5></td>
											<td>
												<input type="hidden" name="targetINDEXNAME" value="${target.INDEXNAME}">
												<input type="hidden" name="targetDIMENSION" value="${target.DIMENSION}">
												<input type="hidden" name="targetUNITNAME" value="${target.UNIT_NAME}">
												<input type="hidden" name="targetfinishpercent" value="${target.finish_percent}">
												<input type="hidden" name="targetDIFFERENCE" value="${target.DIFFERENCE}">
												${target.INDEXNAME}
											</td>
										</tr>
										<tr>
											<td style="width:50%;padding-left:5px;"><h5>周目标</h5></td>
											<td>
												<input type="hidden" name="targetTARGETVALUE" value="${target.TARGETVALUE}">
												<h4 style="color:#43acf7;">${target.TARGETVALUE}</h4>
											</td>
										</tr>
									</table>
									<table style="width:100%;">
										<tr>
											<td style="width:50%;padding-left:5px;">
												今日完成
												<input type="hidden" name="targetTODAYCOMPLETEVALUE" value="${target.TODAYCOMPLETEVALUE}">
												<h4 style="color:#43acf7;">&yen; ${target.TODAYCOMPLETEVALUE}</h4>
											</td>
											<td>
												累计完成
												<input type="hidden" name="targetCOMPLETEVALUE" value="${target.COMPLETEVALUE}">
												<h4 style="color:#43acf7;">${target.COMPLETEVALUE}</h4>
											</td>
										</tr>
									</table>
								</div>
                            </div>
                        </div>
					</c:forEach>
					</div>
				</div>
				<div class="mui-card-footer">
					<table>
						<tr>
							<td style="white-space:nowrap;">差异分析：</td>
							<td style="width:100%;"><textarea onpropertychange="changeHeight(this);" oninput="changeHeight(this);" name="TARGETDIFFERENCE" id="TARGETDIFFERENCE" onblur="AsynchronousSave()">${task.TARGETDIFFERENCE}</textarea></td>
						</tr>
					</table>
				</div>
			</div>
			</c:if>
			<!--工作完成情况-->
			<c:if test="${!empty pd.jobCompleteList}">
			<div class="mui-card">
				<div class="mui-card-header">
					工作完成情况
				</div>
				<div class="mui-card-content">
					<div class="mui-card-content-inner">
					
						<div class="col-md-4">
                            <div class="ibox float-e-margins">
								<div class="ibox-content" style="line-height:2.5;">
								
									<table style="width:100%;line-height:1.5;">
									<c:forEach items="${pd.jobCompleteList}" var="job">
										<tr>
											<td style="padding:3px 5px 0 5px;;vertical-align:top;">
												<c:if test="${job.status=='进行中'}">
													<span class="mui-badge mui-badge-primary" style="padding:5px;"></span>
												</c:if>
												<c:if test="${job.status=='已超期'}">
													<span class="mui-badge mui-badge-danger" style="padding:5px;"></span>
												</c:if>
												<c:if test="${job.status=='已完成'}">
													<span class="mui-badge mui-badge-primary" style="padding:5px;"></span>
												</c:if>
											</td>
											<td style="padding-left:5px;padding-right:15px;padding-bottom:10px;">
												<input type="hidden" name="jobCompleteName" value="${job.JOBNAME}">
												${job.JOBNAME}
											</td>
											<%-- <td>
												<input type="hidden" name="jobCompleteStatus" value="${job.status}">
												${job.status}
											</td> --%>
											<td style="text-align:right;vertical-align:top;white-space:nowrap;padding-right:5px;font-size:10px;color:#929292;">
												<input type="hidden" name="jobCompleteEndDate" value="${job.END_DATE}">
												<input type="hidden" name="jobCompleteFinishTime" value="${job.finishTime}">
												${job.END_DATE}
											</td>
											<input type="hidden" name="jobCompleteStatus" value="${job.status}">
										</tr>
										</c:forEach>
									</table>
									<p style="line-height:1;font-size:10px;margin-top:10px;padding-left:5px;">
										说明：${pd.jobCompleteInfo}
									</p>
								</div>
                            </div>
                        </div>
                       
					</div>
				</div>
				<div class="mui-card-footer">
					<table>
						<tr>
							<td style="white-space:nowrap;">差异分析：</td>
							<td style="width:100%;"><textarea onpropertychange="changeHeight(this);" oninput="changeHeight(this);" name="JOBDIFFERENCE" id="JOBDIFFERENCE" onblur="AsynchronousSave()">${task.JOBDIFFERENCE}</textarea></td>
						</tr>
					</table>
				</div>
			</div>
			</c:if>
			<!--工作量统计与自评-->
			<div class="mui-card">
				<div class="mui-card-header">
					工作量统计与自评
				</div>
				<div class="mui-card-content">
					<div class="col-md-4">
						<div class="ibox-content">
							<ul class="mui-table-view">
								<li class="mui-table-view-cell">
									<a class="mui-navigate-right" onclick="toAddDailyDetail()">
										<span class="mui-badge" style="background:none;color:#929292;">
											<c:choose>
												<c:when test="${!empty sumTime}">
													${sumTime/3600}小时
												</c:when>
												<c:otherwise>
													输入工作量
												</c:otherwise>
											</c:choose>
										</span>
										工作量
									</a>
								</li>
							</ul>
						</div>
					</div>
					<input type="hidden" id="sumTime" value="${sumTime}">
				</div>
				<div class="mui-card-footer">
					<table>
						<tr>
							<td style="white-space:nowrap;">员工自评：</td>
							<td style="width:100%;"><textarea onpropertychange="changeHeight(this);" oninput="changeHeight(this);" name="EVALUATION" id="EVALUATION" onblur="AsynchronousSave()">${task.EVALUATION}</textarea></td>
						</tr>
					</table>
				</div>
			</div>
			
			<!--明日工作安排-->
			<c:if test="${!empty pd.tomorrowTaskList}">
			<div class="mui-card">
				<div class="mui-card-header">
					明日工作安排
				</div>
				<div class="mui-card-content">
					<div class="mui-card-content-inner">
					
						<div class="col-md-4">
                            <div class="ibox float-e-margins">
								<div class="ibox-content" style="line-height:2.5;">
								
									<table style="width:100%;line-height:1.5;">
									<c:forEach items="${pd.tomorrowTaskList}" var="tomorrow">
										<tr>
											<td style="vertical-align:top;padding:2px 5px 0 0;"><input type="checkbox" name="tomorrowCheckbox"></td>
											<td style="padding:3px 5px 0 5px;;vertical-align:top;">
												<c:if test="${tomorrow.status=='进行中'}">
													<span class="mui-badge mui-badge-primary" style="padding:5px;"></span>
												</c:if>
												<c:if test="${tomorrow.status=='已超期'}">
													<span class="mui-badge mui-badge-danger" style="padding:5px;"></span>
												</c:if>
												<c:if test="${tomorrow.status=='已完成'}">
													<span class="mui-badge mui-badge-primary" style="padding:5px;"></span>
												</c:if>
											</td>
											<td style="padding-left:5px;padding-right:15px;padding-bottom:10px;">
												<input type="hidden" name="torrowJOBNAME" value="${tomorrow.JOBNAME}">
												${tomorrow.JOBNAME}
											</td>
											<%-- <td>
												<input type="hidden" name="torrowstatus" value="${tomorrow.status}">
												${tomorrow.status}
											</td> --%>
											<td style="text-align:right;vertical-align:top;white-space:nowrap;padding-right:5px;font-size:10px;color:#929292;">
												<input type="hidden" name="torrowENDDATE" value="${tomorrow.END_DATE}">
												${tomorrow.END_DATE}
											</td>
											<input type="hidden" name="torrowstatus" value="${tomorrow.status}">
										</tr>
									</c:forEach>
									</table>
								</div>
                            </div>
                        </div>
					</div>
				</div>
			</div>
			</c:if>
			<div class="mui-card" style="padding:10px 15px;font-size:10px;">
				日报日期：
				<input type="text" name="dateTime" id="reportDatepicker" style="font-size:10px;width:100px;height:30px" value="${datetime}"/>
			</div>
			<div class="mui-card" style="padding:10px 15px;font-size:10px;">
				评价人：
				<select id="checkEmpCode" name="checkEmpCode" class="checkemp">
					<option value="">请选择</option>
					<c:forEach items="${empList }" var="emp">
						<option value="${emp.EMP_CODE }" 
							<c:if test="${emp.EMP_CODE==task.SCOREPERSON || (empty task.SCOREPERSON && emp.EMP_CODE==task.LEADER_EMPCODE) }">selected</c:if>
						>${emp.EMP_NAME }</option>
					</c:forEach>
				</select>
			</div>
		</div>
		<div>
			<!-- <button type="button" class="mui-btn mui-btn-primary mui-btn-outlined mui-icon mui-icon-plus" style="width:30%;" onclick="submitDailyReport()">
					提交</button>
			<button type="button" class="mui-btn mui-btn-primary mui-btn-outlined mui-icon mui-icon-plus" style="width:30%;" onclick="deleteDailyReport()">
					取消</button> -->
		</div>
	</form>
</body>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"></script>
	<script>	
	//时间控件初始化
    $('#reportDatepicker').datetimepicker({
		language:'zh-CN',
	    minView: 3,
	    startView:2,
	    format: 'yyyy-mm-dd',
	    startDate:'${minDate}',
	    endDate:'${maxDate}',
	    autoclose: true
	});
		$(document).ready(function(){
	    	$.ajax({
				type:"post",
				url:"<%=basePath %>app_login/getConfig.do",
	           	data:{"url":location.href.split('#')[0]},
	           	success:function(data){
	            	var obj = eval(data[0]);
	            	wx.config({
	                	debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
	                   	appId: obj.appId, // 必填，公众号的唯一标识
	                   	timestamp: obj.timestamp, // 必填，生成签名的时间戳
	                   	nonceStr: obj.noncestr, // 必填，生成签名的随机串
	                   	signature: obj.signature,// 必填，签名，见附录1
	                   	jsApiList: ['closeWindow'] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
	               	});
	           	}
	       	});
	   	});
		
	</script>
<script type="text/javascript">
	function toAddDailyDetail(){
		var daily_task_id = $("#daily_task_id").val();
		var date = $("#date").val();
		window.location="<%=basePath%>app_task/toAddDailyDetail.do?daily_task_id="+daily_task_id+"&date="+date;
	}
	
	function submitDailyReport(){
		if($("#checkEmpCode").val() == null || $("#checkEmpCode").val() == ''){
			 alert("没有评价人,请联系管理员配置!");
			 return;
		}
		if($("#EVALUATION").val() == null || $("#EVALUATION").val() == ''){
			 alert("请输入自评!");
			 return;
		}
/* 		if($("#sumTime").val()==null || $("#sumTime").val()=='' || $("#sumTime").val()<=0.00){
			alert("工作量不能为空，请重新填写再提交。");
			return;
		} */
		var cannotsave = false;
		//检查改日期的日报是否已经提交过
		$.ajax({
            type: "POST",
            url: 'positionDailyTask/checkOneDayAdd.do?dateTime='+$("#reportDatepicker").val(),
			data:formdata,
            cache: false,
            async: false,
            success: function (data) {
            	if("false" == data["status"] && null != data["state"] && "YW_YSX" == data["state"]){
            		alert($("#reportDatepicker").val()+"已经添加过日报，不能再增加！");
            		cannotsave = true;
            	}
            }
		});
		if(cannotsave){
			return false;
		}
		
		var count = 0;
		$("input[name='tomorrowCheckbox']").each(function(i){
			if($(this).prop("checked")==false){
				$(this).parents("tr").remove();
			}else{
				count++;
			}
		});
		var torrowTaskInfo = $("#torrowTaskInfo").val()+",需完成工作"+count+"条 ";
		$("#torrowTaskInfo").val(torrowTaskInfo);
		var formdata = $("#dailyReportForm").serialize();
		$.ajax({
            type: "POST",
            url: 'app_task/submitDailyReport.do',
			data:formdata,
            cache: false,
            success: function (data) {
            	var EVALUATION = encodeURI(encodeURI($("#EVALUATION").val()));//自评
				var checkEmpCode = $("#checkEmpCode").val();//评价人
				var manageId = $("#daily_task_id").val();
				var submitUrl = "<%=basePath%>app_task/submitInfo.do?manageId=" + manageId +"&EVALUATION=" + EVALUATION +
					"&SCOREPERSON=" + checkEmpCode;
				
				$.ajax({
					type: "POST",
					url: submitUrl,
					async: false,
					success: function(data){
						if(data == "success"){
							wx.closeWindow();
						}else{
							top.Dialog.alert("提交失败!");
							return;
						}
					}
				});
            }
        }); 
	}
	function deleteDailyReport(){
		var daily_task_id = $("#daily_task_id").val();
		window.location="<%=basePath%>app_login/login_index.do";
		<%-- $.ajax({
			type: "POST",
			url: "app_task/deleteDailyReport.do"+"?daily_task_id="+daily_task_id,
			async: false,
			success: function(data){
				var obj = eval('(' + data + ')');
				if(obj.result == "success"){
					window.location="<%=basePath%>app_login/login_index.do";
					
				}else{
					top.Dialog.alert("删除失败!");
					return;
				}
			}
		}); --%>
	}
	
	function changeHeight(obj){
		obj.style.height=obj.scrollHeight + 'px';
	}
	
	//异步保存差异分析和自评
	function AsynchronousSave(){
		var daily_task_id = $("#daily_task_id").val();
		var param = "daily_task_id="+daily_task_id;
		var TARGETDIFFERENCE = "";
		var JOBDIFFERENCE = "";
		var EVALUATION = "";
		if(document.getElementById("TARGETDIFFERENCE")!=null){
			TARGETDIFFERENCE = encodeURI(encodeURI($("#TARGETDIFFERENCE").val()));
		}
		if(document.getElementById("JOBDIFFERENCE")!=null){
			JOBDIFFERENCE = encodeURI(encodeURI($("#JOBDIFFERENCE").val()));
		}
		if(document.getElementById("EVALUATION")!=null){
			EVALUATION = encodeURI(encodeURI($("#EVALUATION").val()));
		}
		param += "&TARGETDIFFERENCE="+TARGETDIFFERENCE+"&JOBDIFFERENCE="+JOBDIFFERENCE+"&EVALUATION="+EVALUATION;
		$.ajax({
			type: "POST",
			url: "app_task/asynchronousSave.do?"+param,
			async: false,
			success: function(data){
				if(data == "success"){

				}else{
					top.Dialog.alert("保存失败!");
					return;
				}
			}
		});
	}

</script>
</html>