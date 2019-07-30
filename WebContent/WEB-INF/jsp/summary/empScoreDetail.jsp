<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>

<head>
	<base href="<%=basePath%>">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    

    <title>积分明细</title>
    <meta name="keywords" content="">
    <meta name="description" content="">

	<link href="static/summaryTask/css/bootstrap.min.css?v=3.3.5" rel="stylesheet">
    <link href="static/summaryTask/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
    <link href="static/summaryTask/css/animate.min.css" rel="stylesheet">
    <link href="static/summaryTask/css/style.min.css?v=4.0.0" rel="stylesheet">
</head>
<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInRight">
        
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>积分明细</h5>
                    </div>
                   	<!-- 得分 汇总 -->
					<input type="hidden" id="dailyScore" value="${pd.sumScore[0].DAILY_SCORE}"/><!-- 日常得分 汇总 -->
					<input type="hidden" id="tempScore" value="${pd.sumScore[0].WORKORDER_SCORE}"/><!-- 临时得分 汇总 -->
					<input type="hidden" id="projectScore" value="${pd.sumScore[0].PROJECT_SCORE}"/><!-- 项目得分 汇总 -->
					<input type="hidden" id="flowScore" value="${pd.sumScore[0].FLOW_SCORE}"/><!-- 流程得分 汇总 -->
					<input type="hidden" id="sumScore" value="${pd.sumScore[0].SCORE_SUM}"/><!-- 总得分 汇总 -->
                    <div class="ibox-content">
						<div class="col-xs-7">
						 	<div class="echarts" id="echarts-radar-chart"></div>
						 </div>
						<div class="col-xs-5">
						 	<table class="table table-bordered" style="width:200px;margin-top:20px;">
								<tr>
									<td>业绩目标</td>
									<td>0</td>
								</tr>
								<tr>
									<td>流程任务</td>
									<td><fmt:formatNumber type="number" value="${pd.sumScore[0].FLOW_SCORE}"/></td>
								</tr>
								<tr>
									<td>项目任务</td>
									<td><fmt:formatNumber type="number" value="${pd.sumScore[0].PROJECT_SCORE}"/></td>
								</tr>
								<tr>
									<td>临时任务</td>
									<td><fmt:formatNumber type="number" value="${pd.sumScore[0].WORKORDER_SCORE}"/></td>
								</tr>
								<tr>
									<td>日清日报</td>
									<td><fmt:formatNumber type="number" value="${pd.sumScore[0].DAILY_SCORE}"/></td>
								</tr>
								<tr>
									<td>累计得分</td>
									<td><fmt:formatNumber type="number" value="${pd.sumScore[0].SCORE_SUM}"/></td>
								</tr>
							</table>
						 </div>
						 <div style="clear:both;"></div>
						<h5>积分历史</h5>
	                    <table class="table table-hover table-bordered" style="margin-top:20px;">
	                    	<thead>
			                	<tr>
			                    <th align="center">得分项</th>
			                    <th align="center">分值</th>
			                    <th align="center">评价人</th>
			                    <th align="center">得分时间</th>
			                	</tr>
		                	</thead>
	                  		<tbody>
	                  		
			                <!-- 循环开始 -->
			                <c:choose>
			                    <c:when test="${not empty pd.detailScore}">
			                        <c:forEach items="${pd.detailScore}" var="detailScore" varStatus="vs">
			                            <tr>
			                                <td>${detailScore.scoreName}</td>
			                                <td>${detailScore.SCORE}</td>
			                                <td>${detailScore.CHECK_EMP_NAME}</td>
			                                <td>${detailScore.SCORE_DATE}</td>
			                            </tr>
			                        </c:forEach>
			                    </c:when>
			                    <c:otherwise>
			                        <tr class="main_info">
			                            <td colspan="100" class="center" >没有相关数据</td>
			                        </tr>
			                    </c:otherwise>
			                </c:choose>
			                <!-- 循环结束 -->
			                </tbody>
	                </table>
                    </div>
                </div>
            </div>
        </div>
        
    </div>

    <script src="static/summaryTask/js/jquery.min.js?v=2.1.4"></script>
    <script src="static/summaryTask/js/bootstrap.min.js?v=3.3.5"></script>
	<script src="static/summaryTask/js/plugins/echarts/echarts-all.js"></script>
    <script>
		var d=echarts.init(document.getElementById("echarts-radar-chart")),
		h={
		//title:{text:"预算 vs 开销",subtext:"纯属虚构"},
		tooltip:{trigger:"axis"},
		//legend:{orient:"vertical",x:"right",y:"bottom",data:["预算分配","实际开销"]},
		polar:[
			{
			center:["75%","50%"],
			indicator:[
				{text:"业绩目标"},
				{text:"日清日报"},
				{text:"临时任务"},
				{text:"项目任务"},
				{text:"流程任务"},
				]
			}
			],
		calculable:!0,
		series:[
			{
			name:"员工积分",
			type:"radar",
			data:[
				{value:[0,Math.floor($("#dailyScore").val()),Math.floor($("#tempScore").val()),Math.floor($("#projectScore").val()),Math.floor($("#flowScore").val())],name:"得分"}
			]}
		]};
		d.setOption(h),
		$(window).resize(d.resize);
	</script>
</body>
</html>