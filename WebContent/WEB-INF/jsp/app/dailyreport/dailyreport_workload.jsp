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
    <title>添加工作时间</title>
    <meta name="description" content="overview & stats" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="static/app/css/mui.min.css" />
    <link rel="stylesheet" href="static/app/css/style.css" />
    <!--滑块插件-->
	<link href="static/summaryTask/css/plugins/ionRangeSlider/ion.rangeSlider-2.0.3.css" rel="stylesheet">
	<link href="static/summaryTask/css/plugins/ionRangeSlider/ion.rangeSlider.skinHTML5.css" rel="stylesheet">
	
	<script type="text/javascript" src="static/app/js/mui.min.js"></script>
	<script type="text/javascript" src="static/app/js/jquery.min.js"></script>
	<!--滑块插件-->
	<script src="static/summaryTask/js/plugins/ionRangeSlider/ion.rangeSlider.js"></script>
	<script src="static/summaryTask/js/plugins/ionRangeSlider/moment.js"></script>
</head>
<body style="margin-top:50px;">

		<div class="web_title fixed">
			<div class="back"><a onclick="goDailyDetail()"><img src="static/app/images/left.png"></a></div>
			添加工作时间
			<span><a onclick="goDailyDetail()">提交</a></span>
		</div>
		<div class="mui-content">
			<div class="mui-card">
				<div class="mui-card-header">
					${pd.detailName}
				</div>
				<div style="padding:15px 20px;">
					<input id="detailName" type="hidden" value="${pd.detailName}"/>
					<input id="dailyDetailID" type="hidden" value="${pd.dailyDetailID}"/>
					<input id="detail_id" type="hidden" value="${pd.detail_id}"/>
					<input id="daily_task_id" type="hidden" value="${pd.daily_task_id}"/>
					<input type="hidden" id="date" name="date" value="${pd.date}">
					<input type="hidden" name="count" id="count" value="${pd.count}"/>
					<input class="start" type="hidden" value="00:00"/>
					<input class="end" type="hidden" value="23:59"/>
					<div id="ionrange_1"></div>
				</div>
				<div style="width:90%; margin:0 auto; padding-bottom:20px;">
					<button type="button" class="mui-btn mui-btn-primary mui-btn-outlined mui-icon mui-icon-plus" style="width:100%;" onClick="addTime()">
					添加</button>
				</div>
				<table class="workload_list" style="width:90%;margin:0 auto;font-size:12px;line-height:2;">
					<c:if test="${!empty timeList}">
					<c:forEach items="${timeList}" var="time">
						<tr>
							<td style="white-space:nowrap;">${pd.detailName}：</td>
							<td style="width:100%;">${time.start_time} - ${time.end_time}  
							<span onclick="deleteTime(this,${time.ID})" style="padding-left:20px;color:red;cursor:pointer;"><i class="mui-icon mui-icon-close" style="font-size:14px;"></i></span></td>
						</tr>
					</c:forEach>
					</c:if>
				</table>
			</div>
		</div>
		
		<script>
			//滑块插件
			$("div#ionrange_1").ionRangeSlider({
				values:["00:00","00:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","24:00"],
				type:"double",
				grid: false,
				grid_num: 100,
				onChange: function (data) {
					$(".start").val(data.from_value);
					$(".end").val(data.to_value);
				}
			});
			
			function addTime(){
				var startTime = $(".start").val();
				var endTime = $(".end").val();
				var detailName = $("#detailName").val(); //职责名称
				var dailyDetailID = $("#dailyDetailID").val();//日报工作明细ID
				var detail_id = $("#detail_id").val();//职责ID
				var daily_task_id = $("#daily_task_id").val();//日报ID
				var count = $("#count").val();
				var date = $("#date").val();
				$.ajax({
					type: "POST",
					url: "app_task/addTime.do"+"?startTime="+startTime+"&endTime="+endTime
							+"&detailName="+detailName+"&dailyDetailID="+dailyDetailID
							+"&detail_id="+detail_id+"&daily_task_id="+daily_task_id+"&count="+count+"&date="+date,
					async: false,
					success: function(data){
						var obj = eval('(' + data + ')');
						if(obj.result == "success"){
							var str = '<tr><td style="white-space:nowrap;">'+detailName+'：</td><td style="width:100%;">'+ startTime + '-' + endTime + 
							'<span onclick="deleteTime(this,'+obj.ID+')" style="padding-left:20px;color:red;cursor:pointer;"><i class="mui-icon mui-icon-close" style="font-size:14px;"></i></span></td></tr>'
							$(".workload_list").append(str);
							$("#dailyDetailID").val(obj.ID);
							$("#count").val(obj.count);
						}else{
							top.Dialog.alert("添加时间失败!");
							return;
						}
					}
				});
			};
			$(".closelist").click(function(){
				$(".workload_dropdown").fadeOut();
			});
			function deleteTime(obj,ID){
				var daily_task_id = $("#daily_task_id").val();
				$.ajax({
					type: "POST",
					url: "app_task/deleteTime.do"+"?ID="+ID+"&daily_task_id="+daily_task_id,
					async: false,
					success: function(data){
						if(data == "success"){
							$(obj).parents("tr").remove();
							
						}else{
							top.Dialog.alert("添加时间失败!");
							return;
						}
					}
				});
			}
			
			function goDailyDetail(){
				var daily_task_id = $("#daily_task_id").val();
				var date = $("#date").val();
				window.location="<%=basePath%>app_task/toAddDailyDetail.do?daily_task_id="+daily_task_id+"&date="+date;
			}
		</script>
	
</body>
</html>