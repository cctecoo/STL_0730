<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
 <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>工作清单</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link type="text/css" rel="StyleSheet" href="static/css/dtree.css"  />
	<link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
	<link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	
	<link rel="stylesheet" href="static/css/datepicker.css" />
    <!-- 引入 -->
    <style type="text/css">
		#main-container{padding:0;position:relative}
		#breadcrumbs{position:relative;z-index:13;border-bottom:1px solid #e5e5e5;background-color:#f5f5f5;height:37px;line-height:37px;padding:0 12px 0 0;display:block}
		.bootgrid-table th>.column-header-anchor>.text{margin:0px 13px 0px 0px}
		
		#myTab{margin-bottom:0;}
		#myTab li{ background:#98c0d9; margin:0; border:2px solid #98c0d9;}
		#myTab > li.active{ border:2px solid #448fb9;}
		#myTab li.active a{ margin:0;box-shadow:none!important; background:#448fb9; border:0}
		#myTab li.active a:hover{ background:#448fb9; }
		#myTab li a{color:#fff; padding:12px 25px; line-height: 16px;}
		#myTab li a:hover{color:#fff; background:#98c0d9;}
		.employee_top{ border-bottom:2px solid #98c0d9; height:40px; line-height:40px; margin-bottom:15px;}
		.employee_title{float:left; margin-left:20px; border-bottom:3px solid #448fb9; height:38px; font-size:18px; color:#448fb9;}
		.employee_search{float:right;}
		.searchCondition{
               float: left;
               margin: 10px;
           }
        .searchCondition input , .searchCondition select{
               height:30px;
               border:1px solid #aaa;
        }
        .searchCondition .initDropdown{
        	   width:170px;
        	   height:30px;
        	   line-height:26px;
        	   padding:0 7px;
        	   border:1px solid #aaa;
        }
        .searchCondition .status{
        	   width:170px;
        	   border-top:0;
        }
        .dropdown .dropdown-menu{
        	   margin:0;
        	   border-radius:0;
        }
        .dropdown .dropdown-menu li{
        	   padding:5px 10px;
        }
        .dropdown .dropdown-menu li:hover{
        	   background:#448fb9;
        	   color:#fff;
        }
        .searchCondition_right{
               float: right;
               margin: 12px;
         }
         .searchCondition_right a{
         	  display:table-cell;
         	  padding:3px 7px;
         	  border:1px solid #aaa;
         	  text-decoration:none;
         	  color:#aaa;
         }
         .searchCondition_right a.active{
         	  background:#448fb9;
         	  color:#fff;
         	  border:1px solid #448fb9;
         }
           
	</style>
</head>
<body>
	<div class="container-fluid" id="main-container">
		<div id="page-content" class="clearfix">
<!-- 			<div class="employee_top">
				<div class="employee_title">工作清单</div>
				<div id="cleaner"></div>
			</div> -->
			<ul id="myTab" class="nav nav-tabs">
			<li class = "active" id="myWork"><a data-toggle="tab" onclick="clickSearch(0, this);" class = "active">我的工作</a></li>
			<c:if test="${showBtn == 'Y'}">
				<!-- 暂时取消显示，因流程中有保密流程 -->
				<!-- 
					<li id="groupWork"><a data-toggle="tab" onclick="clickSearch(1, this);" >团队工作</a></li>
				 -->
				
			</c:if>
			</ul>
			<div class="nav-search" id="nav-search" style="/* width: 0px; */float: right;margin-right: 90px;margin-top: -40px;">
				<div class="panel panel-default" style="position: absolute;">
					<div class="dropdown" style="margin-top: 3px;">
						<a class="btn btn-small btn-primary initDropdown" 
						style="text-decoration:none; height:32px; line-height:25px;border-radius:0;"
						onmouseover="displayCreateNewWork()" onmouseout="disappearCreateNewWork()">
							新建工作
						</a>
						<ul id="createNewWork" class="dropdown-menu" style="display: none;right:0;left:auto;"
						onmouseover="displayCreateNewWork()" onmouseout="disappearCreateNewWork()">
							<li onclick="createTemporaryWork()">临时工作</li>
							<li onclick="createCooperativeWork()">协同工作</li>
							<li onclick="createFlowWork()">流程工作</li>
					    </ul>
					</div>
				</div>
			</div>
			<div class="row-fluid ">
				<div >
                    <div class="searchCondition">
                        <span>状态： </span>
						<!-- <select class="chzn-select" name="status" id ="status" style="width:220px; padding-bottom:3px" onchange="toSearch();">
							<option value=''>请选择</option>
							<option value='已完成' >已完成</option>
							<option value='进行中' >进行中</option>
							<option value='超期' >超期</option>
						</select> -->
						<div class="dropdown" style="display:inline-block;">
							<div class="initDropdown" id="check">
								请选择
							</div>
							<ul class="dropdown-menu status">
								<li>全部</li>
						        <li>已完成</li>
						        <li>进行中</li>
						        <li>待处理</li>
						        <li>超期</li>						        
						    </ul>
						</div>
                    </div>
                    <div class="searchCondition" id = "time1">
                        <span>计划完成时间： </span>
                        <input class="date-picker" id="startTime" name="startTime" 
                            type="text" data-date-format="yyyy-mm-dd" style="width:170px;" onchange="toSearch();"/>
                    </div>
                    <div class="searchCondition" id = "time2">
                        <span>-</span>
                         <input class="date-picker" id="endTime" name="endTime"
                            type="text" data-date-format="yyyy-mm-dd" style="width:170px;" onchange="toSearch();"/>
                    </div>
                    <div class="searchCondition" id = "toWho" style="display:none;">
						<span style="color:#000;">员工</span>
		        		<input type="text" id="EMP_NAME" readonly="readonly" style="background: #fff!important;width: 170px;" onclick="showDeptTree(this)" />
                        <input type="hidden" id="EMP_CODE" name="EMP_CODE" value="${pdm.empCode}">
		        		<div id="deptTreePanel" style="display:none; position:absolute; background-color:white;overflow-y:auto;overflow-x:auto;height: 250px;width: 218px;border: 1px solid #CCCCCC;z-index: 1000;">
                            <ul id="deptTree" class="tree" style="overflow: auto;padding: 0;margin: 0;"></ul>
                        </div>
					</div>
                    <div class="searchCondition_right" id = "jump">
                    	<a class="active" href="workList/list.do"><i class="icon-th"></i></a>
                    	<a style="border-left:0;" href="workList/calendar.do?msg=0"><i class="icon-calendar"></i></a>
                    </div>
                   	<div class="searchCondition_right" id = "jumpGroup" style="display:none;">
                    	<a class="active" href="workList/list.do?msg=1"><i class="icon-th"></i></a>
                    	<a style="border-left:0;" href="workList/calendar.do?msg=1"><i class="icon-calendar"></i></a>
                    </div>
                </div>
				<table id="plan_grid" class="table table-striped table-bordered table-hover">
				<input type="hidden" name="msg" id="msg" value="${pd.msg }" />
				<input type="hidden" name="status" id="status" />  
					<thead>
						<tr>
								<th data-column-id="NAME" data-formatter="NAME" data-width="30%">工作名称</th>
								<th data-column-id="EMP_NAME"  data-width="10%">责任人</th>
								<th data-column-id="taskStatusName" data-width="5%">状态</th>
								<th data-column-id="taskEndDate" data-width="10%">计划完成日期</th>
								<th data-column-id="ACTUAL_TIME" data-width="10%">实际完成日期</th>
								<th align="center" data-align="center" data-sortable="false" data-formatter="btns" data-width="15%">操作</th>
						</tr>
					</thead>
				</table>
			</div>
		</div>
	</div>
	<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	<script type="text/javascript" src="static/js/bootbox.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
    <script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
    <script type="text/javascript" src="static/deptTree/deptTree.js"></script>
	<!-- 预加载js -->
	<script type="text/javascript">
		
    	$(function() {
    		var msg = $("#msg").val();
    		if(msg == "1")
    		{
    	    	$("#myWork").removeClass("active");
    	    	$("#groupWork").addClass("active");
    		}
       		$("#plan_grid").bootgrid({
				ajax: true,
				url:"workList/work.do?msg="+$("#msg").val(),
				navigation:2,
				formatters:{
					NAME:function(column, row){
						var taskType = row.taskType;
						var taskName = row.taskName;
						return '<span style="cursor:pointer;" ">' + "<"+taskType+">" +taskName+ '</span>';
					},
					btns: function(column, row){
						var state = row.taskStatusName;
						var btnStr = '';
						
						if (row.taskStatusName=='已完成'){
							btnStr += 
	                        '<a href="javascript:void(0)" onclick="showHandlePage(\'' + row.taskHandleUrl + '\')"' +
	        				'	class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">查看<i class="icon-book"></i></a>'	
						}
						else{
							btnStr += 
	                        '<a href="javascript:void(0)" onclick="showHandlePage(\'' + row.taskHandleUrl + '\')"' +
	        				'	class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">完成<i class="icon-book"></i></a>'						
						}
						
						return btnStr;
					}

				},
				labels:{
					infos:"{{ctx.start}}至{{ctx.end}}条，共{{ctx.total}}条",
					refresh:"刷新",
					noResults:"未查询到数据",
					loading:"正在加载...",
					all:"全选"
				},
				rowCount: [10, 25, 50, 100]
			});//.bootgrid("search", {"ISEXPLAIN": $("#searchField").val()});//默认加载未分解目标
    	});
    
	</script>
	<script type="text/javascript">
	
	
	    //检索
	    function toSearch(){
			var status = $("#status").val();
			var startTime = $("#startTime").val();
			var endTime = $("#endTime").val();
			var msg = $("#msg").val();
			var EMP_CODE = $("#EMP_CODE").val();
			if(startTime!=null&&startTime!=''&&endTime!=null&&endTime!=''&&(startTime>endTime))
			{
				alert("请正确填写时间区间");
				return false;
			}
			if(status!=""&&status == "全部")
			{
				status = "";
			}
			$("#plan_grid").bootgrid("search", {
				"status":status,
				"startTime":startTime,
				"endTime":endTime,
				"msg":msg,
				"EMP_CODE":EMP_CODE
			});
	    }
	    
	    //点击进行查询
	    function clickSearch(value, ele){
	    	$("#btnDiv button").removeClass("active");
	    	$(ele).addClass("active");
	    	$("#msg").val(value);
	    	if(value==1)
	    	{	    		
	    		document.getElementById("jump").style.display = 'none';
	    		document.getElementById("jumpGroup").style.display = '';
 	    		document.getElementById("time1").style.display = 'none';
	    		document.getElementById("time2").style.display = 'none'; 
	    		document.getElementById("toWho").style.display = '';
	    	}else if(value == 0)
	    	{
	    		document.getElementById("jumpGroup").style.display = 'none';
	    		document.getElementById("jump").style.display = '';
 	    		document.getElementById("time1").style.display = '';
	    		document.getElementById("time2").style.display = ''; 
	    		document.getElementById("toWho").style.display = 'none';
	    	}
	    	toSearch();
	    }
	
		//显示创建新的工作
		function displayCreateNewWork(){
			document.getElementById("createNewWork").style.display="block";
		}
		
		//隐藏创建新的工作
		function disappearCreateNewWork(){
			document.getElementById("createNewWork").style.display="none";
		}
		
		//创建临时工作
		function createTemporaryWork(){
			top.jzts();
			var diag = new top.Dialog();
			diag.Drag=true;
			diag.Title ="新增";
			diag.URL = '<%=basePath%>/workOrder/goAdd.do?isService=${isService}&count=${count}&superior=${superior}&fromPage=workList';
			diag.Width = 600;
			diag.Height = 600;
			diag.CancelEvent = function(){ //关闭事件
			 search2();
			 //$("#task_grid").bootgrid("search", {"status": $("#searchField").val()});
			 diag.close();
			};
			 diag.show();
			 
		}
		//创建临时工作需要的检索
		function search2(){
			var year = $("#year").val();
			var keyword = $("#keyword").val();
			var searchField = $("#searchField").val();
			$("#task_grid").bootgrid("search", 
					{"year":year, "keyword":keyword, "status":searchField});
		}
		
		//创建协同工作
		function createCooperativeWork(){
			top.jzts();
			var winWidth = 630;
			var winHeight = 600;
		 	var diag = new top.Dialog();
		 	diag.Drag=true;
		 	diag.Title ="新增重点协同项目";
		 	diag.URL = 'cproject/toAdd.do?workshop=0&fromPage=workList';
		 	diag.Width = winWidth;
		 	diag.Height = winHeight;
		 	diag.CancelEvent = function(){ //关闭事件
				diag.close();
		 		$("#project_grid").bootgrid("reload");
		 	};
		 	diag.show();
		}
		
		//创建日常工作
		function createDailyWork(){
			$("#addTaskBtn").hide();
	        $.ajax({
	            type: "POST",
	            url: '<%=basePath%>positionDailyTask/checkAdd.do?timeStamp=' + new Date().getTime(),
	            //2016-07-07 yangdw 修改页面新增不可用的bug，取消掉无用的参数
	            //data: {TARGET_STAGE: TARGET_STAGE, TARGET_YEAR_ID: TARGET_YEAR_ID},
	            dataType: 'json',
	            cache: false,
	            success: function (data) {
	                if("true" == data["status"]){
	                    window.location.href = "<%=basePath%>positionDailyTask/add.do" + 
	                    	"?fromPage=gridTask&show=2&parentPage=gridTask&empCode=${pd.empCode}&loadType=D";
	                }else {
	                    top.Dialog.alert("今日已经添加过行政日清，你只需要进行维护！");
	                    $("#addTaskBtn").show();
	                }
	            }
	        });
		
		}
		
		//创建流程工作
		function createFlowWork(){
			window.location.href = "<%=basePath%>flowWork/toAdd.do";
			
			//top.mainFrame.tabAddHandler("backsummarytask", '流程工作', '<%=basePath%>flowWork/list.do');
		}
		
		//跳转到处理页面
		function showHandlePage(url){
			siMenu('z', 'lm', '日清', url+'&sourcePage=summaryPage');
		}
		
		//打开新的tab页
		function siMenu(id,fid,MENU_NAME,MENU_URL){
			var fmid = "mfwindex";
			var mid = "mfwindex";
			if(id != mid){
				$("#"+mid).removeClass();
				mid = id;
			}
			if(fid != fmid){
				$("#"+fmid).removeClass();
				fmid = fid;
			}
			$("#"+fid).attr("class","active open");
			$("#"+id).attr("class","active");
			top.mainFrame.tabAddHandler(id,MENU_NAME,MENU_URL);
		}
        //初始化日期控件
        $('#startTime').datetimepicker({
            language:'zh-CN',
            startView: 2,
            minView: 2,
            maxView: 2,
            format: 'yyyy-mm-dd',
            autoclose: true
        });
      
        $('#endTime').datetimepicker({
            language:'zh-CN',
            startView: 2,
            minView: 2,
            maxView: 2,
            format: 'yyyy-mm-dd',
            autoclose: true
        });
        
        //鼠标移入下拉菜单
        $(document).ready(function(){
	        $(".initDropdown").mouseenter(function(){//鼠标悬停触发事件
	        	$(this).parent(".dropdown").addClass("open");
	        	//$(this).parent(".dropdown").css("border-bottom-radius","0");
	        });
	        $(".dropdown").mouseleave(function(){//鼠标悬停触发事件
		        $(this).removeClass("open");
		        //$(this).css("border-bottom-radius","4px");
		    });
      	});
        
        $(".status li").click(function(){
        	var status = $(this).text();
        	$("#check").text(status);
        	$("#check").parent(".dropdown").removeClass("open");
        	$("#status").val(status);
        	toSearch();
        });
        setTimeout('$("#deptTreePanel").find("input:first-child").click(function(){toSearch()});',1000);
	</script>
	<!-- 员工树-->
	<script>
        $(function() {    		
			var setting = {
		            checkable: true,
		            checkType : { "Y": "ps", "N": "ps" }
		        }
				var zTree = $("#deptTree").deptTree(setting, ${deptTreeNodes},250,218);
		});
    </script>

</body>
</html>
