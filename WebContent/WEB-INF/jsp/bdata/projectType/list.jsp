<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
	<head>
		<base href="<%=basePath%>"><!-- jsp文件头和头部 -->
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
			     &nbsp; &nbsp; 项目类型
				<div style="position:absolute; top:5px; right:25px;">
					<div>
									<a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
												<a data-toggle="collapse" data-parent="#accordion"
														href="#collapseTwo" class="btn btn-small btn-primary"
														style="float:left;text-decoration:none;">
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
															<td><label>类型名称：</label></td>
															<td>
																<input autocomplete="off" type="text" id="TYPE_NAME" name="TYPE_NAME" value="${pd.TYPE_NAME }" placeholder="这里输入关键词" />
															</td>
															<td><label>是否需要审批：</label></td>
															<td>
																<select class="select" name="ISCHECK" id="ISCHECK" data-placeholder="请选择是否需要审批" style="vertical-align:top;z-index:999">
																	<option value="" >全部</option>
																	<option value="1" style="z-index:999">是</option>
																	<option value="0" >否</option>
																</select>
															</td>			
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
						<form action="projectType/list.do" method="post" name="Form" id="Form">
							<%-- <div class="nav-search" id="nav-search" style="right:5px;margin-top: 20px;" class="form-search">
								<div class="panel panel-default" style="float:left;position: absolute;z-index: 1000;">
											<div>
												<a class="btn btn-small btn-info" onclick="add()">新增</a>
												<a data-toggle="collapse" data-parent="#accordion"
													href="#collapseTwo" class="btn btn-small btn-primary">
													高级搜索 </a> 
											</div>
											<div id="collapseTwo" class="panel-collapse collapse" style="position:absolute; top:32px; z-index:998">
												<div class="panel-body">
													<table>
														<tr>
															<td><label>类型名称：</label></td>
															<td>
																<input autocomplete="off" type="text" id="TYPE_NAME" name="TYPE_NAME" value="${pd.TYPE_NAME }" placeholder="这里输入关键词" />
															</td>
															<td><label>是否需要审批：</label></td>
															<td>
																<select class="select" name="ISCHECK" id="ISCHECK" data-placeholder="请选择是否需要审批" style="vertical-align:top;z-index:999">
																	<option value="" >全部</option>
																	<option value="1" style="z-index:999">是</option>
																	<option value="0" >否</option>
																</select>
															</td>			
														</tr>
													</table>
													<div
														style="margin-top:15px; margin-right:30px; text-align:right;">
														<a class="btn-style1" onclick="searchE();" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"
															style="cursor: pointer;">查询</a> <a class="btn-style2"
															onclick="resetting()" style="cursor: pointer;">重置</a>
														<a data-toggle="collapse" data-parent="#accordion"
															class="btn-style3" href="#collapseTwo">关闭</a>
													</div>
												</div>
											</div>
										</div>
									</div> --%>
							<!-- <table id="table_report" class="table table-striped table-bordered table-hover">
								<thead>
									<tr>
										<th width="" class="center">序号</th>
										<th width="" class="center">项目类型名称</th>
										<th width="" class="center">项目节点层级结构</th>
										<th width="" class="center">是否需要审批</th>
										<th width="" class="center">审批人</th>
										<th width="" class="center">操作</th>
									</tr>
								</thead> -->
								
								<table id="employee_grid" class="table table-striped table-bordered table-hover">
									<thead>
										<tr>
											<th data-column-id="TYPE_NAME" data-order="asc">项目类型名称</th>
											<th data-column-id="LEVEL_FRAME">项目节点层级结构</th>
											<th data-column-id="ISCHECK" data-formatter="ischeck">是否需要审批</th>
											<th data-column-id="EMP_NAME">审批人</th>
											<th align="center" data-align="center" data-sortable="false" data-formatter="btns">操作</th>
										</tr>
									</thead>
								</table>
								
								<%-- <tbody>
								<c:choose>
									<c:when test="${not empty pTypeList}">
										<c:forEach items="${pTypeList}" var="var" varStatus="vs">									
											<tr><td class="center">${vs.index+1 }</td>
												<td>${var.TYPE_NAME }</td>
												<td>${var.LEVEL_FRAME }</td>
												<td><c:if test="${var.ISCHECK == 1 }">是</c:if>
													<c:if test="${var.ISCHECK == 0 }">否</c:if></td>
												<td>${var.EMP_NAME }</td>
												<td style="text-align: center;">
													<a style="cursor:pointer;" title="编辑" onclick="edit('${var.ID }');" class='btn btn-mini btn-info' data-rel="tooltip" data-placement="left">
				                                    <i class="icon-edit"></i>
				                                    </a>
				                                    <a style="cursor:pointer;" title="删除" onclick="del('${var.ID }');" class='btn btn-mini btn-danger' data-rel="tooltip" data-placement="left">
				                                    <i class="icon-trash"></i>
				                                    </a>
												</td>						
											</tr>						
										</c:forEach>	
									</c:when>
								</c:choose>			
								</tbody>
							</table> --%>
							
						</form>
					</div>
  				</div><!--/row-->
			</div><!--/#page-content-->
		</div><!--/.fluid-container#main-container-->
		
		<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
		<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
		
		<script type="text/javascript">
			$(function() {
				$("#employee_grid").bootgrid({
					ajax: true,
					url:"projectType/empList.do",
					navigation:2,
					formatters:{
						ischeck: function(column, row){
							var value = row.ISCHECK;
							if(value== "1"){
								return "是";
							}else if(value == "0"){
								return "否";
							}else{
								return "";
							}
						},
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
				});
				
			});
		
			$(top.changeui());
			
			//检索
			function searchE(){
				var TYPE_NAME = $("#TYPE_NAME").val();
				var ISCHECK = $("#ISCHECK").val();
				$("#employee_grid").bootgrid("search", 
						{"TYPE_NAME":TYPE_NAME,"ISCHECK":ISCHECK});
			}
			//新增
			function add(){
				 top.jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="新增";
				 diag.URL = '<%=basePath%>/projectType/goAdd.do';
				 diag.Width = 400;
				 diag.Height = 250;
				 diag.CancelEvent = function(){ //关闭事件
					 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
						 $("#employee_grid").bootgrid("reload");
					}
					diag.close();
				 };
				 diag.show();
			}
			//修改
			function edit(Id){
				 top.jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="修改";
				 diag.URL = '<%=basePath%>/projectType/goEdit.do?ID='+Id;
				 diag.Width = 400;
				 diag.Height = 250;
				 diag.CancelEvent = function(){ //关闭事件
					 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
						 $("#employee_grid").bootgrid("reload");
					}
					diag.close();
				 };
				 diag.show();
			}
			//删除
			function del(Id){
				
				if(confirm("确定删除?")){ 
					top.jzts();
					var url = "<%=basePath%>/projectType/delete.do?ID="+Id;
					$.get(url,function(data){
						if(data=="success"){
							 $("#employee_grid").bootgrid("reload");
						}
					},"text");
				}
			}
			
			function nextPage(page){ top.jzts();	if(true && document.forms[0]){
					var url = document.forms[0].getAttribute("action");
					if(url.indexOf('?')>-1){url += "&currentPage=";}
					else{url += "?currentPage=";}
					url = url + page + "&showCount=10";
					document.forms[0].action = url;
					document.forms[0].submit();
				}else{
					var url = document.location+'';
					if(url.indexOf('?')>-1){
						if(url.indexOf('currentPage')>-1){
							var reg = /currentPage=\d*/g;
							url = url.replace(reg,'currentPage=');
						}else{
							url += "&currentPage=";
						}
					}else{url += "?currentPage=";}
					url = url + page + "&showCount=10";
					document.location = url;
				}
			}
			
			function resetting(){
				$("#Form")[0].reset(); 
			}
		</script>
	</body>
</html>