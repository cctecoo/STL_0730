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
    <title>评价</title>
    <meta name="description" content="overview & stats" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="static/app/css/mui.min.css" />
    <link rel="stylesheet" href="static/app/css/style.css" />
    <!--五星评分-->
	<link href="static/summaryTask/css/star.css" rel="stylesheet">
	<script type="text/javascript" src="static/app/js/mui.min.js"></script>
	<script type="text/javascript" src="static/app/js/jquery.min.js"></script>
	<script type="text/javascript" src="static/summaryTask/js/comment.js"></script> 
</head>
<body>
<div class="web_title">
	<div class="back"><a href="app_login/login_index.do"><img src="static/app/images/left.png"></a></div>
	评价
	<%-- <c:if test="${mainDailyReport.status == 'YW_YSX'}">
		<span><a onclick="saveEvaluation()">保存</a></span>
	</c:if> --%>
</div>
<div class="mui-content">
	<div class="mui-card">
		<div class="mui-card-header">
			${mainDailyReport.REPORTMAN}${mainDailyReport.datetime}日清日报
		</div>
		<div class="goods-comm" style="margin-top:15px;">
			<div class="goods-comm-stars">
				<span class="star_l">评分：</span>
				<c:if test="${mainDailyReport.status == 'YW_YSX'}">
					<div id="rate-comm-1" class="rate-comm"></div>
				</c:if>
				<c:if test="${mainDailyReport.status == 'YW_YPJ'}">
					<div id="rate-comm-2" class="rate-comm"></div>
				</c:if>
				<input type="text" id="viewScore" name="viewScore" value="${mainDailyReport.SCORE}" style="display:none">
				<input type="text" id="StarNum" name="score" value="2" style="display:none">
				<input type="text" id="manageId" name="manageId" value="${mainDailyReport.ID}" style="display:none">
				<input type="text" name="EMP_CODE" value="${mainDailyReport.EMP_CODE}" style="display:none">
			</div>
			
		</div>
		<div style="width:95%; margin:0 auto; padding-bottom:20px;">
			<c:if test="${mainDailyReport.status == 'YW_YSX'}">
				<textarea style="width:100%;margin:0 auto;height:100px;border:1px solid #ccc;" id="comment" name="comment"></textarea>
			</c:if>
			<c:if test="${mainDailyReport.status == 'YW_YPJ'}">
				<textarea style="width:100%;margin:0 auto;height:100px;border:1px solid #ccc;" disabled>${mainDailyReport.OPINION}</textarea>
			</c:if>
		</div>
		<div>
			<c:if test="${mainDailyReport.status == 'YW_YSX'}">
				<button type="button" class="mui-btn mui-btn-primary mui-btn-outlined mui-icon mui-icon-plus" style="width:100%;" onclick="saveEvaluation()">
					保存</button>
			</c:if> 
			
		</div>
	</div>
</div>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
	<script>	
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

	$("#rate-comm-2").rater(
		options= {
		enabled	: false,
		value	: $("#viewScore").val()
		}
	)
	function saveEvaluation(){
		var score = $("#StarNum").val();//评分
		var manageId = $("#manageId").val();//日报主键
		var comment = $("#comment").val();
		$.ajax({
            type: "POST",
            url: "app_task/saveManageComment.do?score="+score+"&manageId="+manageId+"&comment="+comment,
            cache: false,
            success: function (data) {
            	wx.closeWindow();
            },
            error: function(data){
            	top.Dialog.alert("评价失败!");
				return;
            }
		})
	}
</script>
</body>
</html>