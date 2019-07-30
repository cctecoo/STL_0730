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
    <title>待办事项</title>
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
						        <li>待分解</li>
						        <li>已退回</li>
						        <li>待审核</li>
						        <li>待评价</li>	
						        <li>待验收</li>					        
						    </ul>
						</div>
                    </div>
                    <div class="searchCondition" id = "time1">
                        <span>计划完成时间： </span>
                        <input class="date-picker" id="startTime" name="startTime" 
                            type="text" data-date-format="yyyy-mm-dd" style="width:170px;" onchange="clickSearch(this);"/>
                    </div>
                    <div class="searchCondition" id = "time2">
                        <span>-</span>
                         <input class="date-picker" id="endTime" name="endTime"
                            type="text" data-date-format="yyyy-mm-dd" style="width:170px;" onchange="clickSearch(this);"/>
                    </div>
                    <%-- <div class="searchCondition" id = "toWho" ">
						<span style="color:#000;">申请人</span>
		        		<input type="text" id="EMP_NAME" readonly="readonly" style="background: #fff!important;width: 170px;" onclick="showDeptTree(this)" />
                        <input type="hidden" id="EMP_CODE" name="EMP_CODE" value="${pdm.empCode}">
		        		<div id="deptTreePanel" style="display:none; position:absolute; background-color:white;overflow-y:auto;overflow-x:auto;height: 250px;width: 218px;border: 1px solid #CCCCCC;z-index: 1000;">
                            <ul id="deptTree" class="tree" style="overflow: auto;padding: 0;margin: 0;"></ul>
                        </div>
					</div> --%>
                </div>
				<table id="plan_grid" class="table table-striped table-bordered table-hover">
				<input type="hidden" name="msg" id="msg" value="${pd.msg }" />
				<input type="hidden" name="status" id="status" />  
					<thead>
						<tr>
								<th data-column-id="taskStatusName" data-width="5%">待办类型</th>
								<th data-column-id="taskName" data-formatter="NAME" data-width="30%">工作名称</th>
								<th data-column-id="EMP_NAME"  data-width="10%"data-formatter="emp_name">申请人</th>
								<th data-column-id="taskDate" data-width="10%">申请日期</th>
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
		//列表展示
    	$(function() {
    		var msg = $("#msg").val();
    		if(msg == "1")
    		{
    	    	$("#myWork").removeClass("active");
    	    	$("#groupWork").addClass("active");
    		}
       		$("#plan_grid").bootgrid({
				ajax: true,
				url:"scheduleList/schedule.do?msg="+$("#msg").val(),
				navigation:2,
				formatters:{
					emp_name:function(column, row){
						var taskType = row.taskType;
						var EMP_NAME = row.EMP_NAME;
						return '<span style="cursor:pointer;" >' +EMP_NAME+ '</span>';
					},
					NAME:function(column, row){
						var taskType = row.tasktype;
						var taskName = row.taskName;
						return '<span style="cursor:pointer;" >' + '<'+taskType+'>' +taskName+ '</span>';
					},
					btns: function(column, row){
						var btnStr = '';
						btnStr += 
						/* <a style="cursor:pointer;"  data-rel="tooltip" data-placement="left">日清<i class="icon-book"></i></a> */
                        '<a href="javascript:void(0)" onclick="clickTask(\'' + row.taskHandleUrl + '\')"' +
        				'	class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">去处理<i class="icon-book"></i></a>'						
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
	    function clickSearch(ele){
	    	$("#btnDiv button").removeClass("active");
	    	$(ele).addClass("active"); 		
 	    		document.getElementById("time1").style.display = '';
	    		document.getElementById("time2").style.display = ''; 
	    	toSearch();
	    }
	    
		//去处理按钮链接跳转，点击后，根据菜单url打开新的tab页
		function clickTask(url){
			$.ajax({
				url:"menu/findByUrl.do",
				data:{"url":url},
				type:"post",
				success:function(data){
				var PARENT_FRAME_ID = $(".tab_item2_selected", window.parent.document).parents('table').attr('id')
					/* siMenu("z"+data.MENU_ID, "lm"+data.PARENT_ID, '待办事项', url+"&PARENT_FRAME_ID=" +PARENT_FRAME_ID); */
					top.mainFrame.tabAddHandler("backsummarytask", '待办事项', url+"&PARENT_FRAME_ID=" +PARENT_FRAME_ID+"&fromPage=summaryPage");
			        //top.mainFrame.tabAddHandler('z'+data.MENU_ID, 'lm'+data.PARENT_ID, data.MENU_NAME, url);
				}
			});
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
