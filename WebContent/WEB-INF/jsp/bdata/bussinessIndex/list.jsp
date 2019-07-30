<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<base href="<%=basePath%>">
<!-- jsp文件头和头部 -->
		<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
		<link href="static/css/style.css" rel="stylesheet" />
		<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
		<link rel="stylesheet" href="static/css/bootgrid.change.css" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<style type="text/css">
			#main-container{padding:0;position:relative}
			#breadcrumbs{position:relative;z-index:13;border-bottom:1px solid #e5e5e5;background-color:#f5f5f5;height:37px;line-height:37px;padding:0 12px 0 0;display:block}
		</style>
</head>
<body>
	<div class="container-fluid" id="main-container">
		<div id="page-content" class="clearfix">
		<div class="breadcrumbs" id="breadcrumbs">
			     &nbsp; &nbsp; 经营指标维护
				<div style="position:absolute; top:5px; right:25px;">
					<div>
									<a class="btn btn-small btn-info" onclick="add();"
												style="margin-right: 5px; float: left;">新增</a>
												<a data-toggle="collapse" data-parent="#accordion"
													href="#collapseTwo" class="btn btn-small btn-primary" style="float:left;text-decoration:none;">
													高级搜索 </a>
								</div>
								<div id="collapseTwo" class="panel-collapse collapse"
									style="position:absolute;  top:32px;right:0; z-index:999">
									<div class="panel-body">
										<%-- <span class="input-icon">
											关键字：<input autocomplete="off" id="nav-search-input" type="text" name="keyword" value="${pd.keyword}" placeholder="这里输入关键词" />
											<i id="nav-search-icon" class="icon-search"></i>
										</span> --%>
										<table>
										<tr>
														<td><label>指标名称：</label></td>
														<td><input autocomplete="off" type="text"
															name="INDEX_NAME" id="INDEX_NAME"
															value="${pd.INDEX_NAME }" placeholder="这里输入关键词"  style="height:30px;"/></td>
														<td><label>指标编码：</label></td>
														<td><input autocomplete="off" type="text"
															name="INDEX_CODE" id="INDEX_CODE"
															value="${pd.INDEX_CODE }" placeholder="这里指标编码" style="height:30px;"/></td>
													</tr>
										</table>
										<div
											style="margin-top:15px; margin-right:30px; text-align:right;">
											<a class="btn-style1" onclick="search2();" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a> 
											<a class="btn-style2"onclick="resetting()" style="cursor: pointer;">重置</a>
											<a data-toggle="collapse" data-parent="#accordion" class="btn-style3" href="#collapseTwo">关闭</a>
										</div>
									</div>
								</div>
				</div>
		</div>
			<div class="row-fluid">
				<div class="row-fluid">
					<!-- 检索  -->
					<form action="bussinessIndex/list.do" method="post" name="Form"
						id="Form">
						<%-- <div class="nav-search" id="nav-search" style="right:5px;margin-top: 20px;" class="form-search">
								<div class="panel panel-default" style="float:left;position: absolute;z-index: 1000;">
										<div>
											<a class="btn btn-small btn-info" onclick="add();"
												style="margin-right: 5px; float: left;">新增</a> <a
												data-toggle="collapse" data-parent="#accordion"
												href="#collapseTwo" class="btn btn-small btn-primary">
												高级搜索 </a>
										</div>
										<div id="collapseTwo" class="panel-collapse collapse"
											style="position: absolute; top: 32px; z-index: 999">
											<div class="panel-body">
												<table>
													<tr>
														<td><label>指标名称：</label></td>
														<td><input autocomplete="off" type="text"
															name="INDEX_NAME" id="INDEX_NAME"
															value="${pd.INDEX_NAME }" placeholder="这里输入关键词" /></td>
														<td><label>指标编码：</label></td>
														<td><input autocomplete="off" type="text"
															name="INDEX_CODE" id="INDEX_CODE"
															value="${pd.INDEX_CODE }" placeholder="这里指标编码" /></td>
													</tr>
												</table>
												<div
													style="margin-top: 15px; margin-right: 30px; text-align: right;">
													<a class="btn-style1" onclick="searchE();" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"
														style="cursor: pointer;">查询</a> <a class="btn-style2"
														onclick="resetting()" style="cursor: pointer;">重置</a> <a
														data-toggle="collapse" data-parent="#accordion"
														class="btn-style3" href="#collapseTwo">关闭</a>
												</div>
											</div>
										</div>
								</div>
						</div> --%>
						<!-- 检索  -->
							
							<table id="busiIndex_grid" class="table table-striped table-bordered table-hover">
								<thead>
									<tr>
										<th data-column-id="INDEX_CODE" data-order="asc">指标编号</th>
										<th data-column-id="INDEX_NAME">指标名称</th>
										<th data-column-id="DESCP">备注</th>
										<th align="center" data-align="center" data-sortable="false" data-formatter="btns">操作</th>
									</tr>
								</thead>
							</table>
							
					</form>
				</div>
			</div>
		</div>
	</div>

	<!-- 引入 -->
	<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
	<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
	<script type="text/javascript" src="static/js/bootbox.min.js"></script>
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	<!-- 确认窗口 -->

	<!--引入弹窗组件end-->

	<script type="text/javascript">
		//判断是否有页码传入
		var currentPage = ('${pd.currentPage}' == '') ? 0 : '${pd.currentPage}';

		$(function() {
			$("#busiIndex_grid").bootgrid({
				ajax: true,
				url:"bussinessIndex/empList.do",
				navigation:2,
				post: function(){
					var postData = new Object();
					if(currentPage>1){
						postData.currentPage = currentPage;
					}
					
					return postData;
				},
				formatters:{
					/* gender: function(column, row){
						var value = row.EMP_GENDER;
						if(value== "1"){
							return "男";
						}else if(value == "2"){
							return "女";
						}else{
							return "";
						}
					}, */
					btns: function(column, row){
						return '<a style="cursor:pointer;margin:1px;" title="编辑" onclick="edit('+ row.ID +');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'+
						'<i class="icon-edit"></i></a>'+
						'<a style="cursor:pointer;margin:1px;" title="删除" onclick="del('+ row.ID +');" class="btn btn-mini btn-danger" data-rel="tooltip"  data-placement="left">'+
							'<i class="icon-trash"></i></a>';
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
			}).on("loaded.rs.jquery.bootgrid",function(e){
				currentPage = 0;//加载后重置之前传入的页码
			});
			
		});
		
		$(top.changeui());
		
		//回车绑定查询功能
		$(document).keyup(function(event) {
			if (event.keyCode == 13) {
				searchE();
				$("#collapseTwo").collapse('toggle');
			}
		});
		
		//检索
		function searchE(){
			var INDEX_CODE = $("#INDEX_CODE").val();
			var INDEX_NAME = $("#INDEX_NAME").val();
			
			$("#busiIndex_grid").bootgrid("search", 
					{"INDEX_CODE":INDEX_CODE,"INDEX_NAME":INDEX_NAME});
		}
		//修改
		function edit(Id){
			top.jzts();
			var diag = new top.Dialog();
			diag.Drag=true;
			diag.Title ="修改";
			diag.URL = '<%=basePath%>/bussinessIndex/goEdit.do?ID='+Id;
			diag.Width = 400;
			diag.Height = 350;
			diag.CancelEvent = function(){ //关闭事件
				if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
					//检查当前的分页页码
					currentPage = $("#busiIndex_grid").bootgrid("getCurrentPage");
					$("#busiIndex_grid").bootgrid("reload");
				}
				diag.close();
			};
			diag.show();
		}
		
		//新增
		function add(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="新增";
			 diag.URL = '<%=basePath%>/bussinessIndex/goAdd.do';
			 diag.Width = 350;
			 diag.Height = 180;
			 diag.CancelEvent = function(){ //关闭事件
				 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
					 $("#busiIndex_grid").bootgrid("reload");
				}
				diag.close();
			 };
			 diag.show();
		}
		
		//删除
		function del(id){
			//删除前检查是否有使用
			$.ajax({
				url:'<%=basePath%>bussinessIndex/checkBusiIndexUsed.do?id=' + id,
				type:'post',
				dataType:'text',
				success:function(data){
					if("error"==data){
						top.Dialog.alert("后台出错！");
						return;
					}else if("0"!=data){
						top.Dialog.alert("已关联目标，不能删除！");
						return;
					}else{
						top.Dialog.confirm("确定要删除?", function(){
							$.get(
								"<%=basePath%>/bussinessIndex/delete.do?ID="+id,
								function(data){
									if(data=="success"){
										top.Dialog.alert("删除成功！");
										//检查当前的分页页码
										currentPage = $("#busiIndex_grid").bootgrid("getCurrentPage");
										$("#busiIndex_grid").bootgrid("reload");
									}else{
										top.Dialog.alert("删除失败！");
									}
								}
							);
						}, "text");
					}
				}
			});
		}

		
		//清空
        function resetting(){
            $("#INDEX_NAME").val("");
            $("#INDEX_CODE").val("");
        }
		</script>
</body>
</html>

