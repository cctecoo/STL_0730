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
    <meta charset="utf-8" />
    <title>评价日清日报</title>
    <meta name="description" content="overview & stats" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="static/app/css/mui.min.css" />
	<link rel="stylesheet" href="static/app/css/style.css" />
	    <!--五星评分-->
	<link href="static/summaryTask/css/star.css" rel="stylesheet">
	<script type="text/javascript" src="static/app/js/mui.min.js"></script>
	<script type="text/javascript" src="static/app/js/jquery.min.js"></script>
	<script type="text/javascript" src="static/summaryTask/js/comment.js"></script> 
	<style type="text/css">
		textarea{
			width:100%;
			height:41px;
			margin:0;
			font-size:10px; 
			overflow-y:hidden;
			border-style:none;
			background-color:white;
		}
	</style>
</head>
	<form name="dailyReportForm" id="dailyReportForm" method="post">
	<input type="text" id="daily_task_id" name="daily_task_id" value="${pd.manageId}" style="display:none">
		<div class="web_title">
			<div class="back"><a href="app_login/login_index.do"><img src="static/app/images/left.png"></a></div>
			日清日报
		</div>
		<div class="mui-content">
			<!--目标完成情况-->
			<c:if test="${!empty targetCompleteList}">
			<div class="mui-card">
				<div class="mui-card-header">
					目标完成情况
					<span class="fr">${mainDailyReport.TARGETCOMPLETEINFO}</span>
				</div>
				<div class="mui-card-content">
					<div class="mui-card-content-inner">
					<c:forEach items="${targetCompleteList}" var="target">
						<div class="col-md-4 m-b">
                            <div class="ibox float-e-margins" style="border:1px solid #ccc;">
								<div class="ibox-content" style="line-height:2.5;">
									<table style="width:100%;border-bottom:1px solid #ccc;">
										<tr>
											<td style="width:50%;padding-left:5px;"><h5>指标（元）</h5></td>
											<td>
												${target.INDEXNAME}
											</td>
										</tr>
										<tr>
											<td style="width:50%;padding-left:5px;"><h5>周目标</h5></td>
											<td>
												<h4 style="color:#43acf7;">${target.TARGETVALUE}</h4>
											</td>
										</tr>
									</table>
									<table style="width:100%;">
										<tr>
											<td style="width:50%;padding-left:5px;">
												今日完成
												<h4 style="color:#43acf7;">&yen; ${target.TODAYCOMPLETEVALUE}</h4>
											</td>
											<td>
												累计完成
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
							<td style="width:100%;">
								<textarea id="TARGETDIFFERENCE" name="TARGETDIFFERENCE" disabled>${mainDailyReport.TARGETDIFFERENCE}</textarea>
							</td>
						</tr>
					</table>
				</div>
			</div>
			</c:if>
			<!--工作完成情况-->
			<c:if test="${!empty jobCompleteList}">
			<div class="mui-card">
				<div class="mui-card-header">
					工作完成情况
				</div>
				<div class="mui-card-content">
					<div class="mui-card-content-inner">
					
						<div class="col-md-4">
                            <div class="ibox float-e-margins">
								<div class="ibox-content" style="line-height:2.5;">
									<table style="width:100%;">
									<c:forEach items="${jobCompleteList}" var="job">
										<tr>
											<td style="padding:3px 5px 0 5px;;vertical-align:top;">
												<c:if test="${job.STATE=='进行中'}">
													<span class="mui-badge mui-badge-primary" style="padding:5px;"></span>
												</c:if>
												<c:if test="${job.STATE=='已超期'}">
													<span class="mui-badge mui-badge-danger" style="padding:5px;"></span>
												</c:if>
												<c:if test="${job.STATE=='已完成'}">
													<span class="mui-badge mui-badge-primary" style="padding:5px;"></span>
												</c:if>
											</td>
											<td style="padding-left:5px;padding-right:15px;">
												${job.NAME}
											</td>
											<%-- <td>
												${job.STATE}
											</td> --%>
											<td style="text-align:right;vertical-align:top;white-space:nowrap;padding-right:5px;">
												${job.PLANCOMPLETETIME}
											</td>
										</tr>
										</c:forEach>
									</table>
									<p style="line-height:1;font-size:10px;margin-top:10px;padding-left:5px;">
										说明：${mainDailyReport.JOBCOMPLETEINFO}
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
							<td style="width:100%;"><textarea id="JOBDIFFERENCE" name="JOBDIFFERENCE" disabled>${mainDailyReport.JOBDIFFERENCE}</textarea></td>
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
									<a class="mui-navigate-right">
										<span class="mui-badge" style="background:none;">${sumTime/3600}小时</span>
										工作量
									</a>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="mui-card-footer">
					<table>
						<tr>
							<td style="white-space:nowrap;">员工自评：</td>
							<td style="width:100%;"><textarea name="EVALUATION" id="EVALUATION" disabled>${mainDailyReport.EVALUATION}</textarea></td>
						</tr>
					</table>
				</div>
			</div>
			
			<!--明日工作安排-->
			<c:if test="${!empty tomorrowTaskList}">
			<div class="mui-card">
				<div class="mui-card-header">
					明日工作安排
				</div>
				<div class="mui-card-content">
					<div class="mui-card-content-inner">
					
						<div class="col-md-4">
                            <div class="ibox float-e-margins">
								<div class="ibox-content" style="line-height:2.5;">
									<table style="width:100%;">
									<c:forEach items="${tomorrowTaskList}" var="tomorrow">
										<tr>
											<td style="padding:3px 5px 0 5px;;vertical-align:top;">
												<c:if test="${tomorrow.STATE=='进行中'}">
													<span class="mui-badge mui-badge-primary" style="padding:5px;"></span>
												</c:if>
												<c:if test="${tomorrow.STATE=='已超期'}">
													<span class="mui-badge mui-badge-danger" style="padding:5px;"></span>
												</c:if>
												<c:if test="${tomorrow.STATE=='已完成'}">
													<span class="mui-badge mui-badge-primary" style="padding:5px;"></span>
												</c:if>
											</td>
											<td style="padding-left:5px;padding-right:15px;">
												${tomorrow.NAME}
											</td>
											<%-- <td>
												${tomorrow.STATE}
											</td> --%>
											<td style="text-align:right;vertical-align:top;white-space:nowrap;padding-right:5px;">
												${tomorrow.PLANCOMPLETETIME}
											</td>
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
			<!--评价回复-->
			<div class="mui-card">
				<div class="mui-card-header">
					评价信息
					<c:if test="${mainDailyReport.status == 'YW_YSX'}">
						<span class="fr"><button type="button" class="mui-btn mui-btn-primary mui-btn-outlined" value="评价" onclick="goEvaluate()" style="width:75px;height:25px;"></button></span>
					</c:if>
				</div>
				<div class="mui-card-content">
					<div class="mui-card-content-inner">
						<div class="col-md-4">
                            <div class="ibox float-e-margins">
								<div class="ibox-content" style="line-height:2.5;">
									<table style="width:100%;">
										<c:if test="${mainDailyReport.status == 'YW_YPJ'}">
											<tr>
												<td style="padding-left:5px;">
													<h5 style="color:#43acf7;">${mainDailyReport.EMP_NAME}</h5>
												</td>
												<td class="mui-text-right">
													<h5>${mainDailyReport.SCORE_DATE}</h5>
												</td>
											</tr>
											<tr>
												<td>
													<input type="hidden" id="viewScore" value="${mainDailyReport.SCORE}">
													<div class="quiz_content" style="padding-left:0px">
														<div class="goods-comm">
															<div class="goods-comm-stars" style="padding-left:4px;">
																<span class="star_l">评分：</span>
																<div id="rate-comm-3" class="rate-comm"></div>
															</div>
														</div>
													</div>
												</td>
											</tr>
											<tr>
												<td colspan="2" style="padding-left:5px">
													${mainDailyReport.OPINION}
												</td>
											</tr>
											<tr>
												<td colspan="2">
													<hr style="border:none;border-top:1px solid #ccc;">
												</td>
											</tr>
										</c:if>
										<c:if test="${!empty evaluationList}">
											<c:forEach items="${evaluationList}" var="evaluate">
												<tr>
													<td style="padding-left:5px;">
														<h5 style="color:#43acf7;">${evaluate.CREATENAME}</h5>
													</td>
													<td class="mui-text-right">
														<h5>${evaluate.CREATETIME}</h5>
													</td>
												</tr>
												<tr>
													<td colspan="2" style="padding-left:5px">
														${evaluate.EVALUATION}
													</td>
												</tr>
												<tr>
													<td colspan="2">
														<hr style="border:none;border-top:1px solid #ccc;">
													</td>
												</tr>
											</c:forEach>
										</c:if>
									</table>
								</div>
                            </div>
                        </div>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
<script type="text/javascript">
	$(function(){
		if(document.getElementById("TARGETDIFFERENCE")!=null)
			document.getElementById("TARGETDIFFERENCE").style.height = document.getElementById("TARGETDIFFERENCE").scrollHeight + "px";
		if(document.getElementById("JOBDIFFERENCE")!=null)
			document.getElementById("JOBDIFFERENCE").style.height = document.getElementById("JOBDIFFERENCE").scrollHeight + "px";
		if(document.getElementById("EVALUATION")!=null)
			document.getElementById("EVALUATION").style.height = document.getElementById("EVALUATION").scrollHeight + "px";
	});
	$("#rate-comm-3").rater(
		 options= {
		enabled	: false,
		value	: $("#viewScore").val()
		}
	)
	function goEvaluate(){
		var daily_task_id = $("#daily_task_id").val();
		window.location="<%=basePath%>app_task/goEvaluate.do?ID="+daily_task_id;
	}
	
</script>
</html>