<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<base href="<%=basePath%>">
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no"/>
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<link rel="stylesheet" href="static/app/css/mui.min.css" />
		<link rel="stylesheet" href="static/app/css/style.css" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<script type="text/javascript" src="static/app/js/mui.min.js"></script>
		<script type="text/javascript" src="static/app/js/jquery.min.js"></script>
<title></title>


<script>
$(document).ready(function(){
	$(".showlist").click(function(e){
		e.stopPropagation();
		$(".showlist_col").removeClass("hide");
		
		
	});
	$(document).click(function(){
		if(!$(".showlist_col").hasClass("hide")){
			$(".showlist_col").addClass("hide");
			
		}
	});
});	

$(document).ready(function(){
	$(".keytask").click(function(){
		//$(".dailytask_btn").hide();
		$(this).siblings().find(".dailytask_btn").hide();
		$(this).find(".dailytask_btn").toggle();
	});
});

</script>
</head>

<body>
<div class="web_title">
	<div class="back"></div>
	
	本周系统积分排名
	
	
	<!--<span>
		<a href="#">提交</a>
	</span>-->
		
</div> 
<div class="keytask"> 
<table>
			<tr>
			<td style="width:30px;line-height:3;text-align:center"><span>排名</span></td>
			<td style="text-align:center"><span>姓名</span></td>
			<td style="text-align:center"><span>部门</span></td>
			<td style="text-align:center"><span>总分</span></td>
			</tr>
			
		</table></div> 
<c:forEach items="${scoreList}" var="list">
<div class="keytask">

		<table>
			<tr>
			<td style="width:30px;line-height:3;text-align:center"><span>${list.rownum}</span></td>
			<td style="text-align:center"><span>${list.EMP_NAME}</span></td>
			<td style="text-align:center"><span>${list.DEPT_NAME}</span></td>
			<td style="text-align:center;width:55px;"><span>${list.SCORE_SUM}</span></td>
			<p style="border:0;color:#333;font-size:120%;"><i class="icon-angle-down"></i></p>
			</tr>
			
		</table>
	<div class="dailytask_btn fr">
		<table>
		<tr>
				<td>协同工作得分：</td>
				<td style="width:55px;text-align:center;"><span>${list.PROJECT_SCORE}</span></td>
		</tr>
			<tr>
				<td>日常工作得分：</td>
				<td style="text-align:center;"><span>${list.DAILY_SCORE}</span></td>
			</tr>
			<tr>
				<td>临时工作得分：</td>
				<td style="text-align:center;"><span>${list.WORKORDER_SCORE}</span></td>
			</tr>
			<tr>
				<td class="showall">服务类临时工作得分：</td>
				<td style="text-align:center;"><span>${list.WORKORDER_SERVICE_SCORE}</span></td>
			</tr>
			<tr>
				<td>流程工作得分：</td>
				<td style="text-align:center;"><span>${list.FLOW_SCORE}</span></td>
			</tr>
			<tr>
				<td>总得分：</td>
			<td style="text-align:center"><span>${list.SCORE_SUM}</span></td>
		    </tr>
		</table>
	</div>
	<div id="cleaner"></div>
</div>
</c:forEach>
</body>
</html>
