<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <base href="<%=basePath%>">
    
   
    <c:if test="${showPage=='formFLowStop' }">
 		 <title>财务表单</title>
 	</c:if>
 	<c:if test="${showPage=='formPurchaseStop' }">
 		 <title>采购表单</title>
 	</c:if>
    
	<meta name="description" content="overview & stats" />
	<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,minimal-ui" />
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
	<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
	<link rel="stylesheet" href="<%=basePath%>plugins/font-awesome/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/app-style.css"/>
	<!-- 下拉框 -->
	<link rel="stylesheet" href="static/css/chosen.css" />
	
	<link rel="stylesheet" href="static/css/ace.min.css" />
	<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
	<link rel="stylesheet" href="static/css/ace-skins.min.css" />
	
	<link rel="stylesheet" href="static/css/datepicker.css" />
	<style>
		body {
			background: #f4f4f4;
		}
		.more {
			z-index: 999;
			width: 100%;
			display: none;
		}
		.more table tr td {
			padding-top: 5px;
			padding-bottom: 5px;
		}
		.keytask{
			width: 98%;
			padding: 0;
			margin: 0 auto;
		}
		.keytask table{
			width: 96%;
			margin: 0 auto;
		}
		.keytask table tr td {
			line-height: 2;
			word-break: break-word;
    		overflow: visible;
    		white-space: normal;
		}
		.dateStyle{
			color: #5BC0DE;
		}
		.text_grey{color:grey;}
		.btnStyle{color:#3cc0f1; border:1px solid #3cc0f1; padding:2px 4px; }
		.web_menu a{width:100%}
		
	</style>

  </head>
  
	<body style="background-color:white;">
  	
  	<div id="loadDiv" class="loadDivMask" >
		<i class=" fa fa-spinner fa-pulse fa-4x"></i>
		<h4 class="block">操作中...</h4>
	</div>	
		<div>
			<input type="hidden" id="loadType" value="${pd.loadType }" />
			<input type="hidden" id="wxStatus" value="${pd.wxStatus }" />
			<input type="hidden" id="currentPage" value="0" />
			<input type="hidden" id="totalPage" value="0" />
			<div class="web_menu">
		       
				<div class="showlist1" style="width:90%;color:#fff;float:left;padding:7px 0px; text-align:center;">
		       		<span id="clickText" style="font-size:120%;">全部状态</span><span class="caret"></span>
		       	</div>
		       	<div id="normal" class="normal" style="width: 10%; float: right">
					<a class='btn btn-mini btn-primary' style="width:100%;padding:6px 4px;" data-toggle="collapse" href="#searchTab">
						<i class="fa fa-search"></i>
					</a>
		   		</div>
		   		<div id="cleaner"></div>
		       
			    <div id="btnDiv" class="showlist1_col hide" style="background:#478cd7;left:30%; float: left;width:35%">
					<input id="clickSearch" type="hidden" value="needHandle" /><!-- 默认加载查询的值 -->
					<a name="needHandle" onclick="clickSearch('needHandle', this);">待处理工作</a>
					<a name="focusToMe" onclick="clickSearch('focusToMe', this);">转发给我的</a>
					<a name="checkupToMe" onclick="clickSearch('checkupToMe', this);">我会审的</a>
		    		<a name="recentHandled" onclick="clickSearch('recentHandled', this);">三天内处理的</a>
		    		<a name="handled" onclick="clickSearch('handled', this);">已处理工作</a>
		    		
		    		<a name="normal" onclick="clickSearch('normal', this);">进行中</a>
	    			<a  name="ended" onclick="clickSearch('ended', this);">已结束</a>
		    		<c:if test="${showPage=='repairOrderStop' }">
		    			<a name="outSource" onclick="clickSearch('outSource', this);">委外工作</a>
		    		</c:if>
		    		
				    <a name="all" onclick="clickSearch('all', this);">全部状态</a>
			    </div>
		       		
		   </div>
		   <!-- 查询面板 -->
		   <div id="searchTab" class="panel-collapse collapse" >
				<form action="app_task/listDesk.do?currentPage=1" method="post" name="Form" id="Form">
					<table style="width: 98%; margin: 5px auto;">
						
						<tr>
							<td style="padding-top:5px;"><label>开始时间:</label></td>
							<td><input type="text" name="startDate" id="startDate" class="date-picker" data-date-format="yyyy-mm-dd"
								placeholder="开始时间" value="${pd.startDate }" style="width:95%;height:21px;box-sizing: border-box"></td>
						</tr>
						<tr>
							<td style="padding-top:5px;"><label>结束时间:</label></td>
							<td><input type="text" name="endDate" id="endDate" class="date-picker" data-date-format="yyyy-mm-dd"
								placeholder="结束时间" value="${pd.endDate }" style="width:95%;height:21px;box-sizing: border-box"></td>
						</tr>
						
						<tr >
							<td style="padding-top:5px;"><label>任务编号/名称:</label></td>
							<td><input id="keyword" name="keyword" value="${pd.keyword }" style="width:95%;height:21px;"/></td>
						</tr>
						<tr>
							<td colspan="2" style="padding-top:5px;">
								<select id="searchModel" style="width:96%">
									<option value="">请选择任务类型</option>
									<c:forEach items="${formModelList }" var="par" varStatus="vs">
										<option value="${par.ID }" >[${par.FORM_TYPE}]${par.FORM_DISPLAY_NAME}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
						<td colspan="2">
							<a class='btn btn-mini btn-primary' style="margin-top: 10px;margin-bottom:10px;margin-left: 220px;" 
								onclick="search2();" data-toggle="collapse" href="#searchTab">查询</a>
							<a class='btn btn-mini btn-primary' style="cursor: pointer;" onclick="emptySearch();">重置</a>
						</td>
						</tr>
					</table>
				</form>
			</div>
			
			<!-- 任务列表 -->
			<div id="showTask">
			</div>
			
			<!-- 引入菜单页 -->
			<div>
				<%@include file="../footer.jsp"%>
			</div>
	
   </div>
   	<!-- 引入 -->
	<script src="plugins/appDate/js/jquery-1.11.1.min.js"></script>
	<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
	<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
	<!-- 下拉框 -->
	<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script>
	<!-- 日期框 -->
	<script type="text/javascript" src="static/js/bootbox.min.js"></script>
	<!-- 确认窗口 --> 

	<!-- 引入 -->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<!--提示框-->
	
	<!-- 加载Mobile文件 -->
	
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
	<script type="text/javascript">
	
		$(document).ready(function(){
			// 初始化日期框插件内容
	    	$('#startDate').mobiscroll().date({
	            theme: 'android',
	            mode: 'scroller', 
	            display: 'modal',
	            lang: 'zh',
	            dateFormat:'yyyy-mm-dd',
	            buttons:['set', 'cancel', 'clear']
	        });
	        $('#endDate').mobiscroll().date({
	            theme: 'android',
	            mode: 'scroller', 
	            display: 'modal',
	            lang: 'zh',
	            dateFormat:'yyyy-mm-dd',
	            buttons:['set', 'cancel', 'clear']
	        });
	        var errorMsg = "${msg}";
	   		if(errorMsg!=""){
	   			alert(errorMsg);
	   		}
	   		//设置状态按钮的样式
			if("${pd.clickSearch}"!=""){
				$("#clickSearch").val('${pd.clickSearch}');
			}
	   		
			//设置状态按钮的样式
			var selectedEle = $("#btnDiv").find("[name='"+$("#clickSearch").val()+"']")[0];
			$(selectedEle).addClass("active");
			$("#clickText").html($(selectedEle).html());
			
			//点击状态区域，显示状态列表
			$(".showlist1").click(function(e){
				e.stopPropagation();
				//设置任务状态样式
				if($(".showlist1_col").hasClass("hide")){
					$(".showlist1_col").removeClass("hide");
				}else{
					$(".showlist1_col").addClass("hide");
				}
			});
			//点击页面
			$(document).click(function(){
				if(!$(".showlist1_col").hasClass("hide")){
					$(".showlist1_col").addClass("hide");
				}
			});
	   		//加载任务
	   		loadTask(0);
		});
		
		//高级查询
		function search2(){
			loadTask(0);
		}
		
		//点击进行查询
	    function clickSearch(value, ele){
			//设置背景颜色
			$(".showlist1_col a").removeClass("active");
			$(ele).addClass("active");
			$("#clickText").html($(ele).html());
			//设置点击查询
	    	$("#clickSearch").val(value);
	    	search2();
	    }
		
		//查询-重置
		function emptySearch(){
			$("#Form")[0].reset();
			$("#startDate").val('');
			$("#endDate").val('');
		}
		
		//获取窗口可视范围的高度
		function getClientHeight(){   
		    var clientHeight=0;   
		    if(document.body.clientHeight&&document.documentElement.clientHeight){   
		         clientHeight=(document.body.clientHeight<document.documentElement.clientHeight)?document.body.clientHeight:document.documentElement.clientHeight;           
		    }else{   
		         clientHeight=(document.body.clientHeight>document.documentElement.clientHeight)?document.body.clientHeight:document.documentElement.clientHeight;       
		    }   
		    return clientHeight;   
		}
		
		function getScrollTop(){   
		    var scrollTop=0;   
		    scrollTop=(document.body.scrollTop>document.documentElement.scrollTop)?document.body.scrollTop:document.documentElement.scrollTop;           
		    return scrollTop;   
		}
		
		//页面下滑
		$(document).scroll(function(){
			var scrollTop = 0;
		    var scrollBottom = 0;
		    var dch = getClientHeight();
		    scrollTop = getScrollTop();
		    scrollBottom = document.body.scrollHeight - scrollTop;
	     	if(scrollBottom >= dch && scrollBottom <= (dch+10)){
		      	if($('#totalPage').val() < ($('#currentPage').val()*1+1)){
		      	  	return;
				};
		      	if(true && document.forms[0]){
		      		$("#loadDiv").show();
					var currentPage = $('#currentPage').val()*1+1;
					var showCount = $('#showCount').val();
					loadTask(currentPage);
			  	};           
			};
		});
		
		
		//加载任务列表
		function loadTask(currentPage){
			
			//设置查询里面的参数
			var startDate = $("#startDate").val();
			var endDate = $("#endDate").val();
			var keyword = $("#keyword").val();
			var clickSearch = $("#clickSearch").val();
			var searchModel = $("#searchModel").val();
			//初始化任务
			var loadTaskUrl = "app_task/loadFormWorkList.do?currentPage=" + currentPage;
			
			//加载前显示
			$("#loadDiv").show();
			$.ajax({
				type: "POST",
				url: loadTaskUrl,
				data:{
					"startDate":startDate, "endDate":endDate,
					"keyword":keyword, "workStatus":clickSearch,
					"searchModel": searchModel, "showPage": '${showPage}',
					"showAllWork": 'mine', "isFromApp": true
				},
				success: function(data){
					var obj = data;
					if(currentPage==0){
						$("#showTask").empty();
						if(obj.taskList.length==0){
							$("#showTask").append('<span>没有数据</span>');
						}
					}
					$.each(obj.taskList, function(i, row){
						apendElement(row);
					});
					$("#loadDiv").hide();
					$('#currentPage').val(obj.page.currentPage);
					$('#totalPage').val(obj.page.totalPage);
				}
			});
		}
		
		//生成任务列表数据
		function apendElement(row){
			//工作单的状态名称
			var name = row.WORK_STATUS_NAME;
			var str =  '<a style="cursor:pointer;" title="查看" onclick="view(' + row.ID + ',\'' + row.PAGE_NAME + '\');" '
				+ 'class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'
            	+ '查看</a>';
			//先判断工作单的状态
            if(name == '进行中'){
				//判断当前的处理人
				if(row.IS_MY_WORK=='myWork'){
					str +='<a style="cursor:pointer;margin-left:1px" title="处理" '
						+ ' onclick="edit(' + row.ID + ',\'' + row.PAGE_NAME + '\',' + row.STEP_ID + ');" '
						+ 'class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'
                    	+ '处理</a>';
                    //第一步时，当前处理人可以删除
                    if(row.CURRENT_STEP_LEVEL==1){
                    	str += '<a style="cursor:pointer;margin-left:1px" title="删除" '
                    		+ ' onclick="del(' + row.ID + ', \'DEL\''  + ',' + row.STEP_ID +');"'
                    		+ 'class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">' 
                        	+ '删除</a>';
                    }
				}else if(row.IS_MY_CHECK=='myCheck'){//当前用户需要会审
					str +='<a style="cursor:pointer;margin-left:1px" title="会审" '
						+ ' onclick="checkup(' + row.ID + ',\'' + row.PAGE_NAME + '\',' + row.STEP_ID + ');" '
						+ 'class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'
                    	+ '会审</a>';
				}else if(row.IS_MY_FOCUS!='no'){//当前用户需要回复转发
					str +='<a style="cursor:pointer;margin-left:1px" '
						+ ' onclick="replyFocus(' + row.ID + ',\'' + row.PAGE_NAME + '\',' + row.STEP_ID + ');" '
						+ 'class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'
                    	+ '回复</a>';
				}
				
				if('${changePerson}'=='Y'){//可中止工单人员
					str +='<a style="cursor:pointer;margin-left:1px" title="中止" '
						+ ' onclick="stop(' + row.ID + ',' + row.STEP_ID + ');" '
						+ 'class="btn btn-mini btn-warning" data-rel="tooltip" data-placement="left">'
	                	+ '中止</a>';
				}
				if('${currentUser}'==row.PREV_NODE_USERNAME && row.CURRENT_NODE_ACCEPTED=='no'){//当前节点未处理，则上一步骤操作人可撤回
					str +='<a style="cursor:pointer;margin-left:1px" title="撤回" '
					+ ' onclick="recallback(' + row.ID + ',' + row.STEP_ID + ',' + row.FROM_WORKSTEP_ID + ');" '
					+ ' class="btn btn-mini btn-warning" data-rel="tooltip" data-placement="left">'
                	+ '撤回</a>';
				}
			}
			
			//状态名称
            var statusColor = '';
            if(name == '进行中'){
            	statusColor = 'green';
            }else if(name == '已结束'){
            	statusColor = 'red';
            }else if(name == '已删除'){
            	statusColor = 'orange';
            }
			var statusStr = '<span style="color:' + statusColor + ';font-weight: bold;">' + name + '</span>';

            //当天支付
			var specialStr = '';
            if(row.WORK_STATUS='NORMAL' && row.WORK_PRIORITY=='70'){
                //优先级为70；则增加图标显示
                specialStr += '<span class="label label-warning">当天支付</span>';
            }

			var currentEmpName = '';
			if(row.CURRENT_EMP_NAME){
				currentEmpName = row.CURRENT_EMP_NAME;
			}
			//返回的任务列表
			var appendStr = '<div class="keytask"><div><table>'
				+ '<tr><td style="width:50px"><span>任务:</span></td>'
				+ '<td colspan="3">'
				+ specialStr
                + '<span>[' + row.WORK_NO + ']</span>'
				+ '<span>' + row.TASK_NAME + '</span>'
				+ '</td></tr>'
				+ '<tr><td><span >转交:</span></td>'
				+ '<td colspan="3"><span>' + row.STEP_UPDATE_TIME + '</span>'
				+ 	'<span style="margin-left:8px;">' + currentEmpName + '</span></td></tr>'
				//+ '<tr><td><span >类型:</span></td><td colspan="3"><span>' + row.WORK_TITLE + '</span></td></tr>'
				+ '<tr><td><span >发起:</span></td><td colspan="3"><span>' + row.CREATE_TIME + '</span>'
				+ 	'<span style="margin-left:8px;">' + row.CREATE_EMP_NAME + '</span>' + '</td></tr>'
				+ '<tr><td>' + statusStr + '</td>'
				+ 	'<td colspan="3" style="text-align:right"><div id="btnDiv">' + str + '</div></td></tr>'
				+ '</table></div></div>';
			$("#showTask").append(appendStr);
		}
		
		//提示
		function showTips(ele, text){
			$(ele).tips({
				side:3,
	            msg:text,
	            bg:'#AE81FF',
	            time:1
	        });
		}
		
		//处理
		function edit(formWorkId, pageName, formWorkStepId){
			//检查是否处于会审状态
			$.ajax({
				type: 'post',
				url: '<%=basePath%>app_task/isCheckupFinish.do',
				data:{'formWorkId': formWorkId, 'formWorkStepId': formWorkStepId },
				success: function(data){
					var msg = data.msg;
					if('finish'==msg || 'mineCheck'==msg){
						var url = '<%=basePath%>app_task/toEditRepairOrder.do?formWorkId='+formWorkId + '&fromApp=true'
								 + '&pageName=' + pageName + '&formWorkStepId=' + formWorkStepId;
						//判断状态查询
						var clickSearch = $("#clickSearch").val();
						if(null !==clickSearch && ''!=clickSearch){
							url += '&clickSearch=' + clickSearch;
						}
						window.location.href = url;
					}else if('error'==msg){
						alert('后台出错，请联系管理员！');
					}else if('notFinish'==msg){
						alert(data.notFinishEmpNames + '在当前步骤的会审未完成，不能转交');
					}
				}
			});
		}
		
		//删除
		function del(formWorkId, type, formWorkStepId){
			var text = "删除";
			var isStop = type=='STOP';
			var url = '<%=basePath%>app_task/deleteFormWork.do?formWorkId=' + formWorkId + '&fromApp=true';
			url += '&type=' + type + '&formWorkStepId=' + formWorkStepId;
			if(isStop){
				text = "中止";
			}
			confirm("确定执行"+text+"操作?",function(){ 
				$.ajax({
					url: url,
					type: 'post',
					success: function(data){
						if('success'==data){
							search2();
							alert('执行成功！');
						}else{
							alert('后台出错，请联系管理员！');
						}
					}
				});
			});
		}
		
		//中止
		function stop(formWorkId, formWorkStepId){
			del(formWorkId, 'STOP', formWorkStepId);
		}
		
		//撤回
		function recallback(formWorkId, currentStepId, fromStepId){
			$.ajax({
				type: 'post',
				url: '<%=basePath%>app_task/recallback.do',
				data: {'formWorkId': formWorkId, 'currentStepId': currentStepId, 'fromStepId': fromStepId},
				success: function(data){
					if(data.msg=='success'){
						search2();
					}else if(data.msg=='error'){
						alert('后台出错，请联系管理员！');
					}else if(data.msg=='handled'){
						alert('当前节点已处理，不能撤回');
						search2();
					}
				}
			});
		}
		
		//会审
		function checkup(formWorkId, pageName){
			view(formWorkId, pageName, 'checkup')
		}
		
		//处理转发
		function replyFocus(formWorkId, pageName, formWorkStepId){
			view(formWorkId, pageName, 'replyFocus', formWorkStepId)
		}
		
		// 查看
		function view(formWorkId, pageName, viewType, formWorkStepId){
			//跳转的路径
			var url = '<%=basePath%>app_task/toViewRepairOrder.do?formWorkId=' + formWorkId
				+ '&pageName=' + pageName + '&fromApp=true';
			//判断状态查询
			var clickSearch = $("#clickSearch").val();
			
			if(null !==clickSearch && ''!=clickSearch){
				url += '&clickSearch=' + clickSearch;
			}
			
			if('checkup'==viewType){//会审
				url += '&checkup=true';
			}else if('replyFocus'==viewType){//回复转发
				url += '&replyFocus=true&formWorkStepId='+formWorkStepId;
			}
			window.location.href = url;
		}
	</script>
  </body>
</html>
