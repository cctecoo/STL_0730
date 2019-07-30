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
    <title>新增工作</title>
    <meta name="description" content="overview & stats" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="static/app/css/mui.min.css" />
    <link rel="stylesheet" href="static/app/css/style.css" />

	<script type="text/javascript" src="static/app/js/mui.min.js"></script>
	<script type="text/javascript" src="static/app/js/jquery.min.js"></script>
</head>
<body style="margin-top:40px;">
	<form action="app_task/saveDailyDetails.do" name="dailyReportForm" id="dailyReportForm" method="post">
	<input type="hidden" id="ID" name="ID" value="${ID}">
	<input type="hidden" id="date" name="date" value="${date}">
	<div class="web_title fixed">
		<div class="back"><a onclick="goAddDaily()"><img src="static/app/images/left.png"></a></div>
		新增工作
		<span><a onclick="goAddDaily()">提交</a></span>
	</div>
	<div class="mui-content">
	    <ul class="mui-table-view" style="margin:0;">
            <c:forEach items="${detailList}" var="detail">
				<input type="hidden" name="detail_id" id="detail_id" value="${detail.ID}"/>
				<li class="mui-table-view-cell">
					<a class="mui-navigate-right" onclick="goAddDetailTime('${detail.ID}','${ID}','${detail.detail}','${detail.taskDetailID}','${date}')">
                    <span class="mui-badge mui-badge-inverted">
                    	<c:if test="${detail.totalTime != null}">
                    		${detail.totalTime/60}小时
                    	</c:if>
                    	<c:if test="${detail.totalTime == null}">
                    		输入起止时间
                    	</c:if>
                    </span>
                    	${detail.detail}
                	</a>
				</li>
			</c:forEach>
			<li style="text-align:right;padding-right:25px;line-height:40px;">
                		合计：${sumTime/3600}小时
        	</li>
        </ul>
	</div>
	</form>
	<script type="text/javascript">
		function goAddDetailTime(detail_id,daily_task_id,detailName,dailyDetailID,date){
			window.location="<%=basePath%>app_task/goAddDetailTime.do?detail_id="+detail_id
					+"&daily_task_id="+daily_task_id+"&detailName="+detailName+"&dailyDetailID="+dailyDetailID+"&date="+date;
		}
		function goAddDaily(){
			window.location = "<%=basePath%>app_task/add.do?fromPage=dailyTaskReport&show=2&parentPage=gridTask&loadType=D";
		}
	</script>
</body>
</html>