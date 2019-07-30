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
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	<link rel="stylesheet" href="static/css/datepicker.css" />
	<link rel="stylesheet" href="plugins/zTree/zTreeStyle.css" />
	<link rel="stylesheet" href="static/css/chosen.css" />
	
	<style type="text/css">
		.pagination{/*隐藏分页*/
			display: none;
		}
	</style>
		
	</head>
	<body>
		<div class="container-fluid" id="main-container">
			<div class="row">
				
					<div class="col-md-12">
						<div class="nav-search" id="nav-search" style="right:5px;margin-top: 20px;" class="form-search">
							<div class="panel panel-default" style="float:left;position: absolute;z-index: 1000;">
								<div style="float:left">
									<a class="btn btn-small btn-info" onclick="add();" style="margin-left:5px; float:left;">新增</a>
								</div>
								<div style="float:left; margin-left:15px;">
									模板名称:
									<input type="text" id="kpiName" name="kpiName"  placeholder="请选择！"/>
								</div>
								
								<div id="btnDiv" style="float:left; margin-left:60px;"><!-- 页面点击查询 -开始 -->
							    	<input id="searchField" type="hidden" value="all" /><!-- 默认加载查询的值 -->
							    	<button class="btn btn-small btn-success" onclick="clickSearch('EMP_MONTH', this);">月度考核</button>
						    		<button class="btn btn-small btn-success" onclick="clickSearch('EMP_YEAR', this);">年度考核</button>
						    		
					    			<button class="btn btn-small btn-success" onclick="clickSearch('workshopEmp', this);">车间员工考核</button>
						    		<button class="btn btn-small btn-success" onclick="clickSearch('workshop', this);">车间考核</button>
						    		<button class="btn btn-small btn-success" onclick="clickSearch('QA', this);">QA考核</button>
						    		<button class="btn btn-small btn-success" onclick="clickSearch('EHS', this);">EHS考核</button>
						    		<button class="btn btn-small btn-success" onclick="clickSearch('DVC', this);">设备考核</button>
								    <button class="btn btn-small btn-info" onclick="clickSearch('all', this);">全部</button>
								</div><!-- 页面点击查询 -结束 -->
							</div>
						</div>
						<table id="task_grid" style="min-width:1000px; margin-top:50px;"  class="table table-striped table-bordered table-hover">
							<thead>
								<tr>
									<th data-column-id="CODE" data-width="100px" >模板编码</th>
									<th data-column-id="NAME" data-min-width="100px" >模板名称</th>
									<th data-column-id="MODEL_TYPE" data-formatter="modelType" data-width="150px">类型</th>
									<th data-column-id="ENABLE" data-formatter="enable" data-width="70px">状态</th>
									<th data-column-id="LAST_UPDATE_TIME"  data-width="130px">创建时间</th>
									<th data-column-id="LAST_UPDATE_EMP_NAME" data-width="120px">创建人</th>
									<th align="center" data-align="center" data-sortable="false" 
										 data-formatter="btns" data-width="100px">操作</th>
								</tr>
							</thead>
						</table>
					</div>
				
				
			</div><!-- row end -->
		</div><!--/.fluid-container#main-container-->
	<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->		
    
	<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
	
		<script type="text/javascript">
			
			//判断是否有页码传入
			var currentPage = ('${pd.currentPage}' == '') ? 0 : '${pd.currentPage}';	
			$(function() {
				//表格数据获取
				if("${pd.clickSearch}"!=""){
					$("#searchField").val('${pd.clickSearch}');
					//设置状态按钮的样式
					$("#btnDiv").find("button[name='${pd.clickSearch}']").addClass("active");
				}else{
					var searchVal = $("#searchField").val();
					$($("#btnDiv").find("button[name='"+searchVal+"']")).addClass("active");
				}
				var nowDate = new Date();
				//加载绩效列表
        		$("#task_grid").bootgrid({
        			navigation:2,
        			labels:{infos:"共{{ctx.total}}条"},
					ajax: true,
					url:"<%=basePath%>kpiModel/loadKpiModelList.do",
					selection: true,
        			multiSelect: true,
        			post: function(){
        				var postData = new Object();
    					if(currentPage>1){
    						postData.currentPage = currentPage;
    					}
    					postData.searchField = $("#searchField").val();
    					
    					return postData;
                	},
					formatters:{
						modelType: function(column, row){
							var str = '';
							if(row.IS_WORK_SHOP_MODEL=='0'){
								str += '员工考核';
							}else if(row.IS_WORK_SHOP_MODEL=='1'){
								str += '车间员工考核';
							}else if(row.IS_WORK_SHOP_MODEL=='2'){
								str += '车间考核';
							}
							if(row.MODEL_TYPE=='EMP_MONTH'){
								str += ' 月度考核'
							}else if(row.MODEL_TYPE=='EMP_YEAR'){
								str += ' 年度考核';
							}else if(row.MODEL_TYPE=='QA'){
								str += ' QA考核'
							}else if(row.MODEL_TYPE=='EHS'){
								str += ' EHS考核';
							}else if(row.MODEL_TYPE=='DVC'){
								str += ' 设备考核';
							}
							
							return str;
						},
						enable: function(column, row){
							if(row.ENABLE==1){
								return '启用';
							}
							return '未启用';
						},
						//操作按钮
						btns: function(column, row){
							//状态
							var itemStatus = row.ITEM_STATUS;
							var str = '';
							//配置考核分值
							str +='<a style="cursor:pointer;margin-left:1px" title="配置考核项" '
								+ ' onclick="confKpiScore(' + row.ID + ',\'' + row.MODEL_TYPE + '\');" '
								+ ' class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'
                            	+ '<i class="icon-cog"></i></a>';
							//编辑
							str +='<a style="cursor:pointer;margin-left:1px" title="编辑" onclick="edit(' + row.ID + ');" '
								+ 'class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'
                            	+ '<i class="icon-edit"></i></a>';
							//删除
							str += '<a style="cursor:pointer;margin-left:1px" title="删除" onclick="del(' + row.ID +');"'
	                    		+ 'class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">' 
	                        	+ '<i class="icon-trash"></i></a>';
							return str;
						}
					}
				}).on("loaded.rs.jquery.bootgrid",function(e){
					currentPage = 0;//加载后重置之前传入的页码
				});
			});

			//重置
			function emptySearch(){
				$("#searchForm")[0].reset();
			}
			
			//回车绑定查询功能
			$(document).keyup(function(event) {
				if (event.keyCode == 13) {
					search2();
					$("#collapseTwo").collapse('toggle');
				}
			});
			
			//检索
			function search2(){
				var kpiName = $("#kpiName").val();
				$("#task_grid").bootgrid("search", {
					"kpiName": kpiName
				});
			}
			
			//点击进行查询
		    function clickSearch(value, ele){
		    	$("#btnDiv button").removeClass("active");
		    	$(ele).addClass("active");
		    	$("#searchField").val(value);
		    	search2();
		    }
			
			//新增
			function add(){
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="新增";
				 diag.URL = '<%=basePath%>kpiModel/goAdd.do';
				 diag.Width = 700;
				 diag.Height = 500;
				 diag.CancelEvent = function(){ //关闭事件
					 currentPage = $("#task_grid").bootgrid("getCurrentPage");
					 search2();
					 diag.close();
				 };
				 diag.show();
			}
			
			//配置kpi分值
			function confKpiScore(modelId, modelType){
				 top.jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="配置";
				 diag.URL = '<%=basePath%>kpiModel/toModelDetail.do?modelId='+ modelId + '&modelType=' + modelType;
				 diag.Width = 900;
				 diag.Height = 600;
				 diag.CancelEvent = function(){ //关闭事件
				 	//检查当前的分页页码
					currentPage = $("#task_grid").bootgrid("getCurrentPage");
					search2();
					diag.close();
				 };
				 diag.show();
			}
			
			//修改
			function edit(id){
				 top.jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="编辑";
				 diag.URL = '<%=basePath%>kpiModel/goEdit.do?MODEL_ID='+ + id;
				 diag.Width = 700;
				 diag.Height = 500;
				 diag.CancelEvent = function(){ //关闭事件
				 	//检查当前的分页页码
					currentPage = $("#task_grid").bootgrid("getCurrentPage");
					search2();
					diag.close();
				 };
				 diag.show();
			}
			
			//删除
			function del(id){
				top.Dialog.confirm("删除后将无法恢复数据，确定要删除?",function(){ 
					top.jzts();
					var url = '<%=basePath%>kpiModel/delete.do?MODEL_ID='+ id;
					
					$.ajax({
						url: url,
						type: 'post',
						success: function(data){
							if(data=="success"){
								top.Dialog.alert("删除成功！");
								//检查当前的分页页码
								currentPage = $("#task_grid").bootgrid("getCurrentPage");
								search2();
							}else if(data=="error"){
								top.Dialog.alert("后台出错，请联系管理员！");
							}else if(data=="used"){
								top.Dialog.alert("该模板已分配，无法删除！");
							}
						}
					});
				});
			}
		</script>
	</body>
</html>
