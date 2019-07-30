<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		<meta charset="utf-8" />

		<title>临时任务下达</title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="<%=basePath%>plugins/font-awesome/css/font-awesome.min.css" />
		
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		
		
		<link rel="stylesheet" href="static/css/app-style.css" />
		<link rel="stylesheet" href="static/css/buttons.css" />
		
		<style>
			#zhongxin td{height:35px;}
		    #zhongxin td label{text-align:right;}
			body {
				background: #f4f4f4;
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
				height: 30px;
				line-height: 1.3;
				word-break: break-word;
	    		overflow: visible;
	    		white-space: normal;
			}
			.btn-small {
    			padding: 0 6px;
    		}
    		.button-group{display: block;}
			.button-primary{height: 40px;line-height: 40px;}
			.button-dropdown .btn-primary{
				height: 100%;
			}
			.is-below .btn-primary{
				border: 0;
				border-bottom: 1px solid #FFF;
			}
			.button-dropdown-list > li > a{
				line-height:30px;
			}
			.last{
	    			border:0;
	    	}
    		.dropdown-menu{min-width:50px;width:100px; left:-70px;}
		</style>

		<!-- 引入 -->
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="static/js/buttons.js"></script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		
		<script type="text/javascript" src="static/js/jquery-form.js"></script>
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
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
		<script type="text/javascript">
		
			if("ontouchend" in document) document.write("<script src='static/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>
	</head>
	<body>
		<div id="loadDiv" class="loadDivMask" >
			 <i class=" fa fa-spinner fa-pulse fa-4x"></i>
			 <h4 class="block">操作中...</h4>
		</div>
		
		<div class="button-group" style="width: 100%;text-align: right;">
		    <input id="searchField" type="hidden" value="all" /><!-- 默认加载查询的值 -->
			<input type="hidden" id="currentPage" value="0" />
		    <input type="hidden" id="totalPage" value="0" />
		    
			<button class="button button-primary" type="button" onclick="clickSearch('YW_CG', this);">待提交</button>
			<button class="button button-primary" type="button" onclick="clickSearch('YW_YTH', this);">已退回</button>
			<button class="button button-primary" type="button" onclick="clickSearch('YW_DSX', this);">审核中</button>
			<button class="button button-primary" type="button" onclick="clickSearch('YW_YSX', this);">已下达</button>
			<button class="button button-primary active" type="button" onclick="clickSearch('all', this);">全部</button>
	    	<!-- 
	    	<span  style="float: right;height: 40px;">
				<a class="button-dropdown" data-buttons="dropdown" 
					style="background:url(static/img/app_moreoption1.png) no-repeat; display:block; width:30px; height:30px;margin:5px 5px 0 0;">
				
				</a>
				<ul class="button-dropdown-list is-below">
					<li><a class='btn btn-small btn-primary' style="width:100%;float:right;white-space:nowrap" onclick="add();">新增</a></li>
					
					<li><a class='btn btn-small btn-primary' style="width:100%;float:right;white-space:nowrap" onclick="batchIssued();">批量下发</a></li>
					 
					<li><a class='btn btn-small btn-primary last' style="width:100%;float:right;white-space:nowrap" data-toggle="collapse" href="#searchTab">高级搜索</a></li>
				</ul>
			</span>
			-->
			<div id="btnDown" class="btn-group dropleft" style="float: right;height: 40px;">
			    <button type="button" class="dropdown-toggle btn-sm" data-toggle="dropdown" style="padding:0;border:0;background-color:white;">
			        <span class="caret" 
			        	style="background:url(static/img/app_moreoption1.png) no-repeat; display:block; width:30px; height:30px;margin:5px 5px 0 0; border:0;"></span>
			    </button>
			    <ul class="dropdown-menu" role="menu" style="">
			        <li><a class='btn btn-small btn-primary' style="width:80px;float:right;padding:5px;" onclick="add();">新增</a></li>
					<!-- 
					<li><a class='btn btn-small btn-primary' style="width:100%;float:right;white-space:nowrap" onclick="batchIssued();">批量下发</a></li>
					 -->
					<li><a class='btn btn-small btn-primary' style="width:80px;float:right;padding:5px;" data-toggle="collapse" href="#searchTab">高级搜索</a></li>
			    </ul>
			</div>
	    </div>
	    <div style="width: 98%;background:#f6f6f6;padding: 5px 1px;">
	    
	    </div>
		<!-- 查询面板 -->
		   <div id="searchTab" class="panel-collapse collapse" >
					<table style="width: 98%; margin: 5px auto;">
						<tr>
							<td style="text-align: center;"><label>完成期限:</label></td>
							<td><input type="text" name="year" id="year" class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请输入时间" readonly="readonly">
						</tr>
						<tr>
							<td><label>任务编号/名称:</label></td>
							<td><input id="KEYW" name="KEYW" style="width: 216px;" /></td>
						</tr>
						
						<tr>
						<td colspan="2">
							<a class='btn btn-mini btn-primary' style="margin-top: 10px;margin-bottom:10px;margin-left: 220px;" onclick="searching();"
								data-toggle="collapse" href="#searchTab">查询</a>
							<a class='btn btn-mini btn-primary' style="cursor: pointer;" onclick="resetting();">重置</a>
						</td>
						</tr>
					</table>
			</div>
	<!-- 任务列表 -->
			<div id="showTask">
			<input type="hidden" name="count" id="COUNT" value="${count}" />
			</div>
			
			<!-- 引入菜单页 -->
			<div>
				<%@include file="../footer.jsp"%>
			</div>
		<script type="text/javascript">
		$(function(){
			// 初始化日期框插件内容
	    	$('#year').mobiscroll().datetime({
	            theme: 'android',
	            mode: 'scroller', 
	            display: 'modal',
	            lang: 'zh',
	            dateFormat:'yyyy-mm-dd',
	            timeFormat: 'HH:ii:ss',
                timeWheels: 'hhiiss',
	            buttons:['set', 'cancel', 'clear']
	        });
	        loadData(0);
		});
		$('.button-primary').on("click",function(){
        	$(".button-primary").each(function(){
    			if($(this).hasClass("active")){
    				$(this).removeClass("active");
    			}
    		});
        	$(this).addClass("active");
        });
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
					var currentPage = $('#currentPage').val()*1+1;
					loadData(currentPage);
			  	};           
			};
		});
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
		//加载数据
		function loadData(currentPage){
			$("#loadDiv").show();
			var year = $("#year").val();
			var keyword = $("#KEYW").val();
			var status = $("#searchField").val();
			//初始化任务
			var loadDataUrl = "app_temp/loadData.do?isService=${pd.isService}&currentPage=" + currentPage +
					"&status="+status+"&year="+year+"&keyword="+keyword;
			$.ajax({
				type: "POST",
				url: loadDataUrl,
				success: function(data){
					var obj = eval('(' + data + ')');
					if(currentPage==0){
						$("#showTask").empty();
						if(obj.taskList.length==0){
							$("#showTask").append('<span>没有数据</span>');
						}
					}
					$.each(obj.taskList, function(i, task){
						apendElement(task);
					});
					$("#loadDiv").hide();
					$('#currentPage').val(obj.page.currentPage);
					$('#totalPage').val(obj.page.totalPage);
				}
			});
		}
			
		//生成任务列表数据
		function apendElement(task){
			var appendStr = '<div class="keytask">' + 
				'<div><table>' + 
				//'<tr><td style="width:70px">任务编号:</td><td colspan="2"><span>' + task.TASK_CODE + '</span></td><td style="text-align: right; width:30px; "><input style="width:20px" name="finishBox" type="checkbox" value='+task.TASK_CODE+' /><span class="lbl"></span></td></tr>' + 
				'<tr ><td style="width:25%">任务名称:</td><td colspan="3"><span style="color:orange;font-size:14px">' + task.TASK_NAME + '</span></td></tr>' + 
				'<tr style="color:grey"><td colspan="4"><span>' + task.START_TIME + '</span> 至 ' + 
				'<span style="margin-left:3px;">' + task.END_TIME + '</span></td></tr>' +
				'<tr><td>责任人:</td><td colspan="3"><span>' + task.MAIN_EMP_NAME + '</span>' +
				'<span style="margin-left:3px;">' + task.DEPT_NAME;
			//判断是否有任务审核人
			if(task.APPROVE_EMP_CODE==undefined){
				appendStr += '，未获取到审核人'//'没有部门负责人!';
        	}else if(task.APPROVE_EMP_CODE!=''){
        		appendStr += ', 任务审核:' + task.APPROVE_EMP_NAME;
        	}
			appendStr += '</span></td></tr>';
			appendStr +=
				'<tr><td>创建人:</td><td colspan="3"><span>' + task.CREATE_USER_NAME + '</span>' +
				'<span style="margin-left:3px;">' + task.CREATE_TIME + '</span></td></tr>' +
				'<tr><td>状态:</td><td><span>' + change(task.STATUS) + '</span></td><td colspan="2" style="text-align:right">' + getCommand(task) + '</td></tr>' + 
				'</table></div>' +
				'</div>';
			$("#showTask").append(appendStr);
		}
		
		//状态
		function change(status){
			if(status == 'YW_CG'){
	             return '草稿';
	        }else if(status == 'YW_YSX'){
	             return '已生效';
	        }else if(status == 'YW_DSX'){
	             return '待生效';
	        }else if(status == 'YW_YTH'){
	             return '已退回';
	        }
		}
		
		
		function getCommand(row){
			var res = row.STATUS;
			var str = '';
			var count = row.COUNT;
			//已生效或待生效
			if(res=='YW_YSX' || res=='YW_DSX'){
			    str += '<a style="cursor:pointer;" title="查看" onclick="view(\'' + row.ID +'\',\'' + row.TASK_CODE +'\');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'+
                       '<i class="fa fa-eye"></i></a>';
			  	//没有进行日清之前可以删除
                if(row.DETAIL_STATUS==null || row.DETAIL_STATUS == 'YW_CG' || row.DETAIL_STATUS == 'YW_YSX'){
                	str += '<a style="margin-left:1px" title="删除" onclick="del(\'' + row.ID +'\');" class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">'+
                    	'<i class="fa fa-trash"></i></a>';
                }
			}else{
		        str +='<a style="cursor:pointer;margin-left:3px;" title="编辑" onclick="edit(\'' + row.ID +'\',\'' + row.TASK_CODE +'\');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'+
                      '<i class="fa fa-edit"></i></a>'+
                      '<a style="cursor:pointer;margin-left:3px;" title="附件上传" onclick="uploadFile(\'' + row.ID +'\');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'+
                      '<i class="fa fa-cloud-upload"></i></a>';
                //草稿或已退回
		        if(res == 'YW_CG' || res=='YW_YTH'){
		        	if('${isService}'=='1' || '${superior}'=='Y' || (count==1 && row.APPROVE_EMP_CODE=="")){//服务类临时工作或领导给本部门下达普通临时任务
			        	str += '<a style="cursor:pointer;margin-left:3px;" title="下达" onclick="save(\'' + row.ID +'\',\'YW_YSX\',\'' + row.TASK_CODE +'\',\'' + row.MAIN_EMP_ID +'\',\'' + row.MAIN_EMP_NAME +'\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">'+
		        	       '<i class="fa fa-envelope"></i></a>';
			        }else{
			        	if(row.APPROVE_EMP_CODE==undefined){
			        		str += '<a style="cursor:pointer;margin-left:3px" title="提交" onclick="alert(\'未获取到审核人，请联系管理员配置！\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">'+
                        		'<i class="fa fa-check-square-o"></i></a>';
			        	}else{
				        	str += '<a style="cursor:pointer;margin-left:3px;" title="提交" onclick="save(\'' + row.ID +'\',\'YW_DSX\',\'' + row.TASK_CODE +'\',\'' + row.MAIN_EMP_ID +'\',\'' + row.MAIN_EMP_NAME +'\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">'+
	                        	'<i class="fa fa-check-square-o"></i></a>';
			        	}
			        }
		        }
                str += '<a style="cursor:pointer;margin-left:3px;" title="删除" onclick="del(\'' + row.ID +'\');" class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">'+
                       '<i class="fa fa-trash"></i></a>';
			}
			return str;
		}
							
		// 编辑页面
		function edit(id,taskTypeId){
			//保存搜索的参数
			var param = "";
			if($("#year").val()!=''){
				param += "&year=" + $("#year").val();
			} 
			if($("#KEYW").val()!=''){
				param += "&KEYW=" + $("#KEYW").val();
			}
			if('${count}'!=''){
				param += "&count=${count}";
			}
			if('${pd.isService}' != ''){
				param += "&isService=${pd.isService}";
			}
			if('${superior}'=='Y'){
				param += "&superior=Y";
			}
			//保存页数
			param += "&currentPage=" + $("#currentPage").val();
			window.location.href = '<%=basePath%>/app_temp/goEdit.do?id='+id+'&taskTypeId='+taskTypeId+param;
		}
			
		// 详情页面
		function view(id,taskTypeId){
			//保存搜索的参数
			var param = "";
			if($("#year").val()!=''){
				param += "&year=" + $("#year").val();
			} 
			if($("#KEYW").val()!=''){
				param += "&KEYW=" + $("#KEYW").val();
			} 
			
			//保存页数
			param += "&currentPage=" + $("#currentPage").val();
			window.location.href = '<%=basePath%>/app_temp/goView.do?id='+id+'&taskTypeId='+taskTypeId+param;
		}
		
		// 新增页面
		function add(){
			//保存搜索的参数
			var param = "currentPage=" + $("#currentPage").val();
			var isServiceVal = '${pd.isService}';
			//保存页数
			if($("#year").val()!=''){
				param += "&year=" + $("#year").val();
			} 
			if($("#KEYW").val()!=''){
				param += "&KEYW=" + $("#KEYW").val();
			} 
			if('${count}'!=''){
				param += "&count=${count}";
			}
			if(isServiceVal != ''){
				param += "&isService=" + isServiceVal;
			}
			if('${superior}'=='Y'){
				param += "&superior=Y";
			}
			
			window.location.href = '<%=basePath%>/app_temp/goAdd.do?'+param;
		}
			
		//提交任务
		function save(id,status,TASK_CODE,MAIN_EMP_ID,MAIN_EMP_NAME){
			if(confirm("确定要提交任务?")){ 
				var url = "<%=basePath%>/app_temp/update.do?id="+id+"&status="+status+"&TASK_CODE="+id+"&MAIN_EMP_ID="+MAIN_EMP_ID+"&MAIN_EMP_NAME="+MAIN_EMP_NAME;
				$.ajax({
					type: "POST",
					url: url,
					success: function(data){
						if(data == 'success'){
						location.replace('<%=basePath%>/app_temp/goTemp.do?isService=${pd.isService}');
						}else{
						alert("提交失败！");
						}
					}
				});
			}
		}
		//点击进行查询
	    function clickSearch(value, ele){
	    	$("#btnDiv button").removeClass("active");
	    	$(ele).addClass("active");
	    	$("#searchField").val(value);
	    	searching();
	    }
	    //检索
		function searching(){
			loadData(0);
		}
			
		//上传附件
	    function uploadFile(id){
               location.href = '<%=basePath%>app_temp/goAttchmentsUpload.do?id='+id;
	    }
		    
		//删除
		function del(id){
			if(confirm("确定要删除?")){
			var url = "<%=basePath%>/app_temp/delete.do?id="+id;
				$.get(url,function(data){
					if(data=="success"){
						location.replace('<%=basePath%>/app_temp/goTemp.do?isService=${pd.isService}');
					}
				});
			}
		}
			
		//批量下发临时任务
		function batchIssued(){

	        var objList = document.getElementsByName("finishBox");
			var num = 0;
			for(var i=0; i<objList.length; i++){
				if(objList[i].checked){
					num += 1;
				}
			}
			if(num == 0){
	        	alert("您没有勾选任何内容，不能下发");
	            return;
	        }else {
		        if(confirm("确定要批量下发吗？")){
		        var inputStr='';
		        for(var i=0; i<objList.length; i++){
					if(objList[i].checked){
						inputStr += objList[i].value+",";//拼接选择的节点ID
					}
				}
				if(""!=inputStr){
					inputStr = inputStr.substr(0, inputStr.length-1);
				}
		        var url = '<%=basePath%>/app_temp/batchIssued.do?status=YW_YSX&taskCodes='+inputStr;
                    $.get(
                            url,
                            function(data){
                                if(data == "success"){
                                	alert("下发成功！");
                                }else if(data == "false"){
                                	alert("下发失败！");
                                }
                                location.reload();
                            },
                            "text"
                    );
		        }
		                    
	        }
				
		}
		function resetting(){
			$("#year").val("");
			$("#KEYW").val("");
		}
	    </script>
	</body>
</html>