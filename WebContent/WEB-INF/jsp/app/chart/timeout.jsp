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
	 超期任务汇总
	<!--<span>
		<a href="#">提交</a>
	</span>-->
		
</div>
<c:forEach items="${list}" var="list"  varStatus="status">
<div class="keytask">

		<table>
			<tr>
		    <td style="width:30px;line-height:3;text-align:center"><span> ${status.index +1 } </span></td> 
			<c:if test="${list.project == 'null' }">
					<td><span >临时工作</span>
					</c:if>
			<c:if test="${list.project != 'null' }">
					<td><span >协同工作</span>
					</c:if>
			<td style="text-align:center"><span>超期${list.days}天</span></td>
			<td style="text-align:center"><span>${list.name}</span></td>
			<p style="border:0;color:#333;font-size:120%;"><i class="icon-angle-down"></i></p>
			</tr>
			
		</table>
	<div class="dailytask_btn fr">
		<table>
		
			<tr>
				<td style="width:85px">工作名称：</td>
				<c:if test="${list.project == 'null' }">
				<td class="showall"><span>${list.activity}</span></td>
				</c:if>
				<c:if test="${list.project != 'null' }">
				<td class="showall"><span>${list.project}（${list.activity}）</span></td>
				</c:if>
			</tr>
			<tr>
				<td>承接人：</td>
				<td><span>${list.name}</span></td>
			</tr>
			<tr>
				<td class="showall">任务有效期：</td>
				<td class="showall"><span>${list.START_TIME}-${list.END_TIME}</span></td>
			</tr>
		</table>
	</div>
	<div id="cleaner"></div>
</div>
</c:forEach>
     <div> 
     <c:if test="${empty list }">
	 太好了！今天没有超期任务
	 </c:if>	
     </div> 
    <p  <c:if test="${empty list }">style="font-size:10px;display: none" </c:if>> 备注：目前只包含协同工作、临时工作超期提醒</p>
</body>
</html>
