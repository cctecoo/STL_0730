<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
	<base href="<%=basePath%>">
	<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,minimal-ui" />
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/datepicker.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	<link rel="stylesheet" href="static/css/app-style.css"/>
	
	<style>
		.keytask table tr td label{
			font-size:14px;
		}
		.keytask {
			padding:4px;
		}
		.perbody table tr td {
			padding-top: 5px;
			padding-bottom: 5px;
			
		}
	
		td,th{font-size:12px; color:#585858;}
		th{background:#f7f8fa;}
		.modal-backdrop{ z-index:99;}
		input[type=checkbox]{opacity:1; position:inherit;}
		#myTab{margin-bottom:0;}
		#myTab li{ background:#98c0d9; margin:0; border:2px solid #98c0d9;}
		#myTab > li.active{ border:2px solid #448fb9;}
		#myTab li.active a{ margin:0;box-shadow:none!important; background:#448fb9; border:0}
		#myTab li.active a:hover{ background:#448fb9; }
		#myTab li a{color:#fff; padding:12px 25px; line-height: 16px;}
		#myTab li a:hover{color:#fff; background:#98c0d9;}
		.tab-content{ padding:0; border:0;}
		.employee_top{ border-bottom:2px solid #98c0d9; height:40px; line-height:40px; margin-bottom:15px;}
		.employee_title{float:left; margin-left:20px; border-bottom:3px solid #448fb9; height:38px; font-size:18px; color:#448fb9;}
		.employee_search{float:right;}
		.progress:after{ line-height:20px!important;}
		
		.bootgrid-header{
			height:30px;
			margin: 5px 10px;
		}
		.bootgrid-footer{
			height:30px;
		}
		.success{
			background-color:#55b83b
		}
		.warning{
			background-color:#d20b44
		}
		.b{
			color:red
		}
		.bootgrid-table th>.column-header-anchor>.text{
			margin: 0px;
		}
		.btn{
			margin-right: 2px;
		}
	</style>
	<!-- 引入 -->
	<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
	<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
	<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
	<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script>
	<!-- 加载Mobile文件 -->
	<script src="plugins/appDate/js/jquery-1.11.1.min.js"></script>
   	<script src="plugins/appDate/js/mobiscroll.core.js"></script>
    <script src="plugins/appDate/js/mobiscroll.frame.js"></script>
    <script src="plugins/appDate/js/mobiscroll.scroller.js"></script>
	
	<script src="plugins/appDate/js/mobiscroll.util.datetime.js"></script>
    <script src="plugins/appDate/js/mobiscroll.datetimebase.js"></script>
    <script src="plugins/appDate/js/mobiscroll.datetime.js"></script>

    <script src="plugins/appDate/js/mobiscroll.frame.android.js"></script>
    <script src="plugins/appDate/js/i18n/mobiscroll.i18n.zh.js"></script>

    <link href="plugins/appDate/css/mobiscroll.frame.css" rel="stylesheet" type="text/css" />
    <link href="plugins/appDate/css/mobiscroll.frame.android.css" rel="stylesheet" type="text/css" />
    <link href="plugins/appDate/css/mobiscroll.scroller.css" rel="stylesheet" type="text/css" />
    <link href="plugins/appDate/css/mobiscroll.scroller.android.css" rel="stylesheet" type="text/css" />
	<!-- 引入 -->
	
	<script type="text/javascript">
	//页面初始化
	$(function(){
		var errorMsg = "${errorMsg}";
		if(errorMsg!=""){
			alert(errorMsg);
		}
		//加载任务
		//loadTask('${pd.loadType}');
		getdate();
	})
	
	//修改tab页样式
	function setTabStyle(loadType){
		$("#loadType").attr("value", loadType);
		
			$("#nav-search").css('width', '0px');
			$("#addTaskBtn").css('display','none');
		
		//$(".gridDiv").hide();//隐藏所有列表
		//$("#gridDiv_"+loadType).show();//重新显示加载的类型
		//var tabList = $("#myTab").children();
		$("#myTab li a").each(function(){
			//alert("loadType=" + loadType + "," + $(this).attr("name") + "," + (loadType== $(this).attr("name")))
			if(loadType== $(this).attr("name")){
				$(this).parent().addClass("active");
			}else{
				$(this).parent().removeClass("active");
			}
		});
		$("#myTabContent > .active").removeClass("active in");
		$("#"+loadType+"Task").addClass("active in");
	}
	
	//加载任务列表
	function loadTask(loadType){
		//修改tab页样式
		setTabStyle(loadType);
		//初始化任务表格
		$("#task_grid_"+loadType).bootgrid({
			ajax: true,
			url:"performance/listTaskForGrid.do?empCode=${pd.empCode}&MONTH=${pd.MONTH}&loadType=" + loadType,
			formatters:{
				id: function(column, row){
					return row.ID;
				},
				//目标数量
				weekCount: function(column, row){
					return row.WEEK_COUNT + " " + row.UNIT_NAME;
				},
				//实际进度
				actualPercent: function(column, row){
					var barWidth = row.actual_percent;//进度条宽度
					var barStyle = 'success';//进度条样式
					if(row.actual_percent>100){//实际进度大于100时，进度条宽度设为100，防止宽度超出
						barWidth = 100;
					}else if(row.actual_percent < row.plan_percent){//实际进度小于计划进度，进度条样式改为‘警告’
						barStyle = 'warning';
					}
					//返回进度条
					return '<div class="progress" style="height:20px; margin:0px; background-color: #dadada; border: 1px solid #ccc;">' + 
						'<div class="progress-bar ' + barStyle + '" role="progressbar" aria-valuenow="60" aria-valuemin="0" ' +
						'aria-valuemax="100" style="width: ' + barWidth + '%; text-align: center">' + 
						'<span style="color: black">' + row.actual_percent + '%</span></div></div>';
				},
				//进度滞后
				isDelay: function(column, row){
					if(row.actual_percent < row.plan_percent){
						return '<span style="color:red">是</span>';
					}else{
						return "否";
					}
				},
				//是否评价-临时工作
				assess: function(columen,row){
					if(row.NEED_CHECK == '1'){
						return '是';
					}else if(row.NEED_CHECK == '0'){
						return '否';
					}
				},
				//流程名称-流程工作
				flowName: function(column, row){
					return '<a onclick="">' + row.FLOW_NAME + '</a>';
				}
			}
		});
	}
	
	//查询部门员工
	function findEmp(){
		var deptId = "${pd.deptIdStr}";
		var deptVal = $("#deptCode").val();
		if(deptVal!=""){
			deptId = $("#deptCode").find("option:selected").attr("deptId");
		}
		//top.Dialog.alert("deptId=" + deptId + ", deptVal=" + deptVal);
		
		var path = "<%=basePath%>performance/findDeptEmp.do?deptId=" + deptId;
		$.ajax({
			type: "POST",
			url: path,
			async: false,
			success: function(data){
				if(data=='error'){
					top.Dialog.alert("获取部门数据出错");
				}
				var obj = eval('(' + data + ')');
				//更新员工
				$("#empCode").empty();
				$("#empCode").append('<option value="">全部</option>');
				$.each(obj, function(i, emp){
					$("#empCode").append('<option value="' + emp.EMP_CODE + '">' + emp.EMP_NAME + '</option>');
				});
			}
		});
	}
	
	//查询
	function searchTask(){
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		var productName = $("#productName").val();
		var projectName = $("#projectName").val();
		var loadType = $("#loadType").val();
		$("#task_grid_"+loadType).bootgrid("search", 
			{"startDate":startDate, "endDate":endDate, "productName":productName,
			"projectName":projectName});
	}
	
	//查询-重置
	function resetting(){
		$("#Form")[0].reset();
	}
	
	//跳转到日清,type=1:周工作,type=2:创新活动,type=3:行政;show=1:查看,show=2:日清,show=3:日清批示
	function showDailyTask(id, type, show){
		var url = "<%=basePath%>empDailyTask/";
		var param = "&show=" + show + "&showDept=${pd.showDept}&currentPage=${page.currentPage}&showCount=${page.showCount}" + 
			"&deptCode=${pd.deptCode}&empCode=${pd.empCode}&productCode=${pd.productCode}&projectCode=${pd.projectCode}" + 
			"&startDate=${pd.startDate}&endDate=${pd.endDate}&status=${pd.status}&parentPage=gridTask&loadType=" + $("#loadType").val();
		if(type==1){//周工作
			url += "listBusinessEmpTask.do?weekEmpTaskId=" + id + param;
		}else if(type==2){//创新活动
			url += "listCreativeEmpTask.do?eventId=" + id + param;
		}else if(type==3){//行政活动
			url+= "listManageEmpTask.do?manageId=" + id + param;
		}else{
			top.Dialog.alert("未知的任务类型，无法查看");
			return ;
		}
		window.location.href = url;
	}

    function savePerf(PERF_ID,MONTH,EMP_CODE){
    	
    	var score = "";
		$(document).find("[name = 'score']").each(function(){
			if($(this).val()==null||$(this).val()=="")
			{
				$(this).val(0);
			}
			score = score+$(this).val()+",";
		});
		
		var pdId = "";
		$(document).find("[name = 'pdId']").each(function(){
			if($(this).val()==null||$(this).val()=="")
			{
				$(this).val(0);
			}
			pdId = pdId+$(this).val()+",";
		});
		
		var lId = "";
		$(document).find("[name = 'lId']").each(function(){
			if($(this).val()==null||$(this).val()=="")
			{
				$(this).val(0);
			}
			lId = lId+$(this).val()+",";
		});
    	
    	
    	totalScore = $("#totalScore").val();
    	var url = "<%=basePath%>/app_performance/savePerf.do?SCORE="+score+"&PDID="+pdId+"&LID="+lId+"&PERF_ID="+PERF_ID+"&MONTH="+MONTH+"&EMP_CODE="+EMP_CODE+"&totalScore="+totalScore;
    	
    	$.get(url,function(data){
			if(data=="success"){
				alert("保存成功！");
				location.replace("<%=basePath%>/app_performance/list.do");
			}else{
				alert("保存失败！");
			}
		},"text");
    }
    
    
    $("#score").keyup(function(){  
        var c=$(this);  
        if(/[^\d]/.test(c.val())){//替换非数字字符  
          var temp_amount=c.val().replace(/[^\d]/g,'');  
          $(this).val(temp_amount);  
        }  
     })
	
	function control(e,o,score){
        var v= o.value|0;
        if(v<=0){
            o.value='';
            o.focus();
        }else if(v>score){
        	alert("实际得分不能大于预设分值！");
        	o.value='';
            o.focus()
        }
    };
	
	function getdate(){
		var list=$(document).find("[name = 'score']");			
		var count = 0;
		$(document).find("[name = 'score']").each(function(){
			if($(this).val()==null||$(this).val()=="")
			{
				$(this).val(0);
			}
			count = parseInt(count)+parseInt($(this).val());
		});
		$("#totalScore").val(count);
	}
	
	function goback(){
		window.location.href = "<%=basePath%>/app_performance/list.do";
	}
	
	function gotask(){
		window.location.href = "<%=basePath%>/app_performance/listDesk.do?MONTH=${pd.MONTH}&empCode=${pd.empCode}";
	}
	
</script>

</head>
<body>
		<div >
		<!-- <div class="employee_top">
			<div class="employee_title">
				绩效管理
			</div>
			<div style="text-align: right;margin-right:5px;">
				<a  class="btn btn-small btn-primary" onclick="gotask()">查看工作 </a>
				<a  class="btn btn-small btn-primary" onclick="goback()">返回 </a>
			</div>
			
			<div id="cleaner"></div>
		</div> -->
		
		<div class="web_title">
			<!-- 返回 -->
<%-- 			<div class="back" style="top:5px">
				<a href="<%=basePath%>/app_performance/list.do">
				<img src="static/app/images/left.png" /></a>
			</div> --%>
			<!-- tab页 -->
			<div style="width:90%; margin-left:20px;">
				<label style="margin-top:5px;font-size:14px;">绩效管理</label>
		   </div>
		   <div id="normal" class="normal" style="width: 100%;text-align: right">
			   <c:if test="${flg == 1}">
					<c:if test="${pd.SELF != 1}">
						<a class="btn btn-mini btn-primary" onclick="savePerf('${pd.PERF_ID }','${pd.MONTH }','${pd.EMP_CODE }')" style="margin: 5px 10px 0 0;">保存 </a>
					</c:if>
				</c:if>
				<a class="btn btn-mini btn-info" onclick="gotask();" style="margin: 5px 10px 0 0;">查看工作</a>
		   </div>
		</div>
		<!-- tab页 -->
		
		<div class="perbody">
			<c:choose>
				<c:when test="${not empty kpiList}">
					<table style="margin-left:3%;margin-top:4px;">
						<tr>
							<td><label style="font-size:14px">合计：</label></td>
							<td>
								<input type="text" id="totalScore" style = "width:40px;margin-bottom:4px" value="${pd.SCORE }" readonly/>
							</td>
						</tr>
					</table>
					<c:forEach items="${kpiList}" var="kpiList" varStatus="vs">
					
					<div class="keytask" style="width:98%;margin-left:5px;">
					<table style="width:100%">
						<tr>
							<%-- <td><label>序号：</label>${vs.index+1}</td> --%>
							<td style="display: none;">${kpiList.ID }</td>
							<td colspan="2"><label>考核项：</label>${kpiList.KPI_NAME }</td>
						</tr>
						<tr>
							<td colspan="2"><label>考核标准：</label>${kpiList.PREPARATION2 }</td>
						</tr>
						<tr>
							<td><label>百分比：</label><fmt:formatNumber type="percent" value="${kpiList.PERCENT }"/></td>
							<td><label>分值：</label>${kpiList.PREPARATION3 }</td>
						</tr>	
						<tr>
							<td colspan="2"><label>实际得分：</label>
								<c:choose>
									<c:when test="${kpiList.sqlFlg == '1' }">
										<input type="text" name = "score" id = "score"  style = "width:40px;color:black" onkeyup="control(event,this,${kpiList.PREPARATION3})" onblur = "getdate();"  value="${kpiList.SCORE }" 
										<c:if test="${flg != 1}">readonly</c:if>>
									</c:when>
									<c:otherwise>
										<input type="text" name = "score" id = "score"  style = "width:40px;color:black" onkeyup="control(event,this)" onblur = "getdate();"  value="${kpiList.SCORE }" readonly>
									</c:otherwise>
								</c:choose>
								<input type="hidden" name = "pdId" id = "pdId"   value=${kpiList.PD_ID }>
								<input type="hidden" name = "lId" id = "lId"   value=${kpiList.LID }>
							</td>
						</tr>
					</table>
					</div>	
						
					</c:forEach>
				</c:when>
				<c:otherwise>
					<table>
					<tr class="main_info">
						<td colspan="100" class="center" >没有相关数据</td>
					</tr>
					</table>
				</c:otherwise>
			</c:choose>
			
		</div>
		<div>
			<%@include file="../footer.jsp"%>
		</div>	
			
		</div><!-- /span -->
	
		
</body>
</html>
