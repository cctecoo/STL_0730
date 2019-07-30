<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta http-equiv="content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link type="text/css" rel="stylesheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
		<link type="text/css" rel="stylesheet" href="static/css/style.css"/>
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<base href="<%=basePath%>">
		<style type="text/css">
			.container{width: 100%;}
			.col-md-12{padding: 0;}
		
			.startBtn{
				height: 30px;
				width: 90px;
			}
			
			.workTimer{
				border: 1px solid #cecece;
				height: 120px;
				width: 240px;
				float: left;
				text-align: center;
				margin: 6px;
			}
			.workTimer .workTitle{
				height: 100%;
				width: 120px;
				float: left;
				line-height: 120px;
				border-right: 1px solid #cecece;
				white-space:nowrap;
				text-overflow:ellipsis;
				overflow: hidden;
			}
			.workTimer .timerDIV{
				float: left;
				height: 60px;
				width: 118px;
				line-height: 60px;
				border-bottom: 1px solid #cecece;
			}
			.workTimer .startDIV{
				height: 60px;
				width: 118px;
				float: left;
				line-height: 60px;
			}
		</style>
	</head>
	<body>
		<div class="container">
			<div class="row">
				<div class="col-md-12" id="commonTimer">
					<div class="m-c-l-top">
						<img style="margin-top:-5px;" src="static/images/ui1.png">常用日清助手
					</div>
					<c:forEach items="${commonDutys}" var="duty">
						<div id="workTimer_${duty.ID}" class="workTimer">
							<div class="workTitle" title="${duty.detail }">
								${duty.detail }
							</div>
							<div id="opera_${duty.ID}" style="position: absolute;bottom: 10px;margin-left: 36px;display: none;">
								<a href="javascript:void(0)" onclick="addCollection(${duty.ID})">添加收藏</a>
							</div>
							<div id="opera_${duty.ID}" style="position: absolute;bottom: 10px;margin-left: 36px;">
								<a href="javascript:void(0)" onclick="removeCollection(${duty.ID})">移除收藏</a>
							</div>
							<div class="timerDIV" id="timer_${duty.ID}">
								00:00
							</div>
							<div class="startDIV">
								<input class="btn" id="startBtn_${duty.ID}" type="button" onclick="startWork('${duty.ID}')" value="启动工作">
								<input type="button" class="btn btn-danger" id="endBtn_${duty.ID}" onclick="endWork('${duty.ID}')" style="display: none;" value="结束工作">
								<input type="hidden" id="timeId_${duty.ID}">
							</div>
						</div>
					</c:forEach>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12" id="allTimer">
					<div class="m-c-l-top">
						<img style="margin-top:-5px;" src="static/images/ui1.png">日清助手
					</div>
					<c:forEach items="${dutys}" var="duty">
						<div id="workTimer_${duty.ID}" class="workTimer">
							<div class="workTitle" title="${duty.detail }">
								${duty.detail }
							</div>
							<div id="opera_${duty.ID}" style="position: absolute;bottom: 10px;margin-left: 36px;">
								<a href="javascript:void(0)" onclick="addCollection(${duty.ID})">添加收藏</a>
							</div>
							<div id="opera_${duty.ID}" style="position: absolute;bottom: 10px;margin-left: 36px;display: none;">
								<a href="javascript:void(0)" onclick="removeCollection(${duty.ID})">移除收藏</a>
							</div>
							<div class="timerDIV" id="timer_${duty.ID}">
								00:00
							</div>
							<div class="startDIV">
								<input class="btn" id="startBtn_${duty.ID}" type="button" onclick="startWork('${duty.ID}')" value="启动工作">
								<input type="button" class="btn btn-danger" id="endBtn_${duty.ID}" onclick="endWork('${duty.ID}')" style="display: none;" value="结束工作">
								<input type="hidden" id="timeId_${duty.ID}">
							</div>
						</div>
					</c:forEach>
				</div>
			</div>
		</div>
		<script type="text/javascript" src="plugins/JQuery/jquery-1.12.2.min.js"></script>
		<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script type="text/javascript">
			var timer;
			function startWork(id){
				var doms = $(".startDIV .btn-danger");
				for(var i = 0; i < doms.length; i++){
					if(doms[i].style.display != "none"){
						alert("请先结束现有任务");
						return false;
					}
				}
				
				$.post(
					"positionDailyTask/startDailyTask.do",
					{"detailid":id},
					function(data){
						if(data != ""){
							var s = 0;
							var m = 0;
							$("#startBtn_" + id).hide();
							$("#endBtn_" + id).show();
							$("#timeId_"+id).val(data);
							
							timer = setInterval(function setTime(){
								if(++s < 10){
									s = "0" + s;
								}else if(s == 60){
									s = "00";
									m++;
								}
								
								if(m < 10){
									$('#timer_'+id).html("0"+m+":"+s);
								}else{
									$('#timer_'+id).html(m+":"+s);
								}
							},1000);
						}else{
							alert("任务启动失败");
						}
					}
				);
			}
			
			function endWork(id){
				var time = $("#timeId_"+id).val();
				if(time != ''){
					$.post(
						"positionDailyTask/endDailyTask.do",
						{"timeId":time},
						function(data){
							if(data != ""){
								$("#endBtn_" + id).hide();
								$("#startBtn_" + id).show();
								clearTimeout(timer);
								$('#timer_' + id).html("00:00");
								$("#timeId_" + id).val("");
							}else{
								alert("任务终止失败");
							}
						}
					);
				}
			}
			
			function addCollection(id){
				$.post(
					"positionDuty/addCollection.do",
					{"id":id},
					function(data){
						if(data == 1){//添加收藏成功
							var obj = $("#workTimer_"+id).clone();
							obj.children().eq(1).css("display","none");
							obj.children().eq(2).css("display","block");
							$("#workTimer_"+id).remove();
							$("#commonTimer").append(obj);
						}else{
							alert("添加收藏失败");
						}
					}
				);
			}

			function removeCollection(id){
				$.post(
					"positionDuty/removeCollection.do",
					{"id":id},
					function(data){
						if(data == 1){//移除收藏成功
							var obj = $("#workTimer_"+id).clone();
							obj.children().eq(1).css("display","block");
							obj.children().eq(2).css("display","none");
							$("#workTimer_"+id).remove();
							$("#allTimer").append(obj);
						}else{
							alert("移除收藏失败");
						}
					}
				);
			}
		</script>
	</body>	
</html>