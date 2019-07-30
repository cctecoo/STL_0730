<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<base href="<%=basePath%>">
	<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no"/>
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<link rel="stylesheet" href="static/app/css/mui.min.css" />
	<link rel="stylesheet" href="static/app/css/style.css" />
	<link rel="stylesheet" href="<%=basePath%>plugins/font-awesome/css/font-awesome.min.css" />
	<script type="text/javascript" src="static/app/js/mui.min.js"></script>
	<script type="text/javascript" src="static/app/js/jquery.min.js"></script>
	<title></title>
</head>
<body>

<div id="loadDiv" class="loadDivMask" >
	 <i class=" fa fa-spinner fa-pulse fa-4x"></i>
	 <h4 class="block">操作中...</h4>
</div>	

<div class="web_title">
	<div class="back"><a onclick=javascript:history.go(-1)><img src="static/app/images/left.png" /></a></div>
		消息历史
		<span><a onclick="allRead()">全部标记已读</a></span>
	</div>
<div class="screening">
	<!-- <div id="segmentedControl" class="mui-segmented-control" style="width:95%;margin:10px auto;">   
		<a class="mui-control-item mui-active" href="#item1">待办公文（8）</a>
		<a class="mui-control-item" href="#item2">已办公文</a>
	</div> -->
	<div class="status">
		<a date_status="" class="active">全部</a>
		<a date_status="1">未读</a>
		<a date_status="2">已读</a>
		<input type="hidden" id="workStatus">
	</div>
	<div class="type">
		<a date_type="" class="active">全部工作</a>
		<a date_type="business">目标工作</a>
		<a date_type="cproject">协同工作</a>
		<a date_type="flow">流程工作</a>
		<a date_type="temp">临时工作</a>
		<a date_type="daily">日常工作</a>
		<input type="hidden" id="workType">
	</div>
</div>
<div id="remind_list">
<c:forEach items="${list}" var="item">
<div class="remind" onclick="markread(${item.STATUS}, ${item.ID}, '${item.APP_URL }')">
	<a >
		<table>
			<tr>
				<td <c:if test="${item.STATUS==1}">class="i_blue"</c:if>><i class="mui-icon mui-icon-info-filled"></i></td>
				<td <c:if test="${item.STATUS==1}">class="text_grey"</c:if>>[${item.type}] &nbsp;&nbsp; ${item.WORK_NAME}
				<span>${item.APP_TIME}</span></td>
				
			</tr>
		</table>
	</a>
	<div id="cleaner"></div>
</div>
</c:forEach>
</div>
<script type="text/javascript">
	$(function(){
		//点击后查询
		$(".status a").click(function(){
			$(this).addClass("active");
			$(this).siblings().removeClass("active");
			$("#workStatus").val($(this).attr("date_status"));
			searchlist();
		});
		$(".type a").click(function(){
			$(this).addClass("active");
			$(this).siblings().removeClass("active");
			$("#workType").val($(this).attr("date_type"));
			searchlist();
		});
		if('${msg}'=='error'){
			alert('后台出错，请联系管理员');
		}
	});
	
	function searchlist(){
		var workStatus = $("#workStatus").val();
		var workType = $("#workType").val();
		$("#loadDiv").show();
		$.ajax({
			url: 'app_remindRecord/record.do',
			type: 'post',
			data: {
				'STATUS': workStatus,
				'TYPE': workType
			},
			success : function(data){
				var obj = eval(data);
				$("#remind_list").empty();
				if(obj){
					$.each(obj, function(i, event){
						var status_i;
						var status_text;
						if(event.STATUS==1){
							status_i = 'i_blue';
							status_text = 'text_grey';
						}else{
							status_i = '';
							status_text = '';
						}
						var append = '<div class="remind"><a href="'+event.APP_URL+'"><table><tr>'+
						  '<td class="'+status_i+'"><i class="mui-icon mui-icon-info-filled"></i></td>'+
						  '<td class="'+status_text+'">['+event.type+'] &nbsp;&nbsp; '+event.WORK_NAME+'<span>'+event.APP_TIME+'</span></td>'+
						  '</tr></table></a></div>';
						$("#remind_list").append(append);
					});
				}else{
					$("#remind_list").append('没有数据');
				}
				$("#loadDiv").hide();
			}
		});
	}
	
	function markread(status, ID , url){
		$("#loadDiv").show();
		if(status==1){
			//未读消息，点击后更新状态
			$.ajax({
				url: 'app_remindRecord/app_updateRead.do',
				type: 'post',
				data: {'status': 2, 'ID': ID},
				success : function(data){
					//不做处理
				}
			});
		}
		if(''!=url){
			window.location.href = url; 
		}else{
			$("#loadDiv").hide();
		}
	}
	
	//一键标记已读
	function allRead(){
		$.ajax({
			url: 'remindRecord/updateAll.do',
			type: 'post',
			success : function(){
				//alert("success");
			}
		});
		setTimeout('searchlist()',500);
	}
</script>
</body>
</html>