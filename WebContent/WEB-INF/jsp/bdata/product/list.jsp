<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
	<head>
		<base href="<%=basePath%>">
		
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
			     &nbsp; &nbsp; 产品管理
				<div style="float:right; margin-top:5px;">
					<div>
						<a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
						<a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" class="btn btn-small btn-primary"
							style="float:left;text-decoration:none;">高级搜索 </a>
						<a class="btn btn-small btn-primary" onclick="exportExcel();" style="float:left; margin-left:5px;">导出</a>
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
								<td><label>关键字：</label></td>
								<td>
									<input autocomplete="off" type="text" name="keyword" id="keyword" value="${pd.keyword}" placeholder="产品编码、 名称、 描述" 
										title="可用于查询  产品编码、 产品名称、 描述"	style="height:30px;"/>
								</td>
								<td><label>产品类型：</label></td>
								<td>
									<select id="productType" name="productType">
										<option value="">请选择</option>
		                                <c:forEach items="${productType}" var="type">
		                                    <option value="${type.BIANMA }" >${type.NAME}</option>
		                                </c:forEach>
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
						<!-- 检索  -->
						<form action="product/list.do" method="post" name="Form" id="Form">
							<%-- <div class="nav-search" id="nav-search" style="right:5px;margin-top: 20px;" class="form-search">
								<div class="panel panel-default" style="float:left;position: absolute;z-index: 1000;">
											<div>
												<a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
												<a data-toggle="collapse" data-parent="#accordion"
														href="#collapseTwo" class="btn btn-small btn-primary"
														style="float:left;text-decoration:none;">
													高级搜索 </a>
											</div>
											<div id="collapseTwo" class="panel-collapse collapse"
													style="position:absolute;  top:32px; z-index:999">
												<div class="panel-body">
													<table>
														<tr>
															<td><label>关键字：</label></td>
															<td>
																<input autocomplete="off" type="text" name="keyword" id="keyword" value="${pd.keyword}" placeholder="产品编码、 名称、 描述" 
																	title="可用于查询  产品编码、 产品名称、 描述"	/>
															</td>
														</tr>
													</table>
													<div style="margin-top:15px; margin-right:30px; text-align:right;">
														<a class="btn-style1" onclick="search2();" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a> 
														<a class="btn-style2" onclick="resetting()" style="cursor: pointer;">重置</a>
														<a data-toggle="collapse" data-parent="#accordion" class="btn-style3" href="#collapseTwo">关闭</a>
													</div>
												</div>
											</div>
									</div>
							</div> --%>
								
								<table id="product_grid" class="table table-striped table-bordered table-hover">
									<thead>
										<tr>
											<th data-column-id="PRODUCT_CODE" data-formatter="productCode" data-width="100px" data-order="asc">编码</th>
											<th data-column-id="PRODUCT_NAME" data-formatter="productName">名称</th>
											<th data-column-id="PARENT_PRODUCT_NAME" data-width="110px">所属类别</th>
											<!-- 
											<th data-column-id="SIZE" data-formatter="gender">尺寸</th>
											<th data-column-id="MATERIAL">材料</th>
											 -->
											
											<th data-column-id="NAME"  data-width="80px">产品类型</th>
											<th data-column-id="DESCP" data-formatter="descp">描述</th>
											<th data-column-id="CREATE_EMP_NAME" data-width="120px">创建人</th>
											<th align="center" data-width="80px;" data-align="center" data-sortable="false" data-formatter="btns">操作</th>
										</tr>
									</thead>
								</table>
								
						</form>
					</div>
				</div><!--/row-->
			</div><!--/#page-content-->
		</div><!--/.fluid-container#main-container-->
		<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
		<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
		<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
		
		
		<script type="text/javascript">
			//判断是否有页码传入
			var currentPage = ('${pd.currentPage}' == '') ? 0 : '${pd.currentPage}';
		
			//返回到title的span
			function getSpanWithTitle(text){
				return '<span title="' + text + '">' + text + '</span>';
			}
			
			$(function() {
				$("#product_grid").bootgrid({
					ajax: true,
					url:"product/empList.do",
					navigation:2,
					post: function(){
						var postData = new Object();
						if(currentPage>1){
							postData.currentPage = currentPage;
						}
						
						return postData;
					},
					formatters:{
						productCode: function(column, row){
							return getSpanWithTitle(row.PRODUCT_CODE);
						},
						productName: function(column, row){
							return getSpanWithTitle(row.PRODUCT_NAME);
						},
						descp: function(column, row){
							return getSpanWithTitle(row.DESCP);
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
				}).on("loaded.rs.jquery.bootgrid",function(e){
					currentPage = 0;//加载后重置之前传入的页码
				});
				
			});
		
			$(top.changeui());
		
			function resetting(){
				$("#keyword").val(""); 
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
				var keyword = $("#keyword").val();
				var productType = $("#productType").val();
				$("#product_grid").bootgrid("search", 
						{"KEYW":keyword, "productType":productType});
			}
		
			//新增
			function add(){
				top.jzts();
				var diag = new top.Dialog();
				diag.Drag=true;
				diag.Title ="新增";
				diag.URL = '<%=basePath%>/product/toAdd.do';
				diag.Width = 450;
				diag.Height = 450;
				diag.CancelEvent = function(){ //关闭事件
					if('${page.currentPage}' == '0'){
						top.jzts();
					 	setTimeout("self.location=self.location",100);
					}else{
						$("#product_grid").bootgrid("reload");
					}
					diag.close();
				};
				diag.show();
			}
		
			//删除
			function del(id){
				//删除前检查是否有使用
				$.ajax({
					url:'<%=basePath%>product/checkProductUsed.do?id=' + id,
					type:'post',
					dataType:'text',
					success:function(data){
						if("error"==data){
							top.Dialog.alert("后台出错！");
							return;
						}else if("0"!=data){
							top.Dialog.alert("产品已关联目标，不能删除！");
							return;
						}else{
							top.Dialog.confirm("确定要删除?", function(){
								top.jzts();
								$.get(
									"<%=basePath%>/product/delete.do?id="+id,
									function(data){
										if(data=="success"){
											top.Dialog.alert("删除成功！");
											//检查当前的分页页码
											currentPage = $("#product_grid").bootgrid("getCurrentPage");
											$("#product_grid").bootgrid("reload");
										}else if(data=="error"){
											top.Dialog.alert("删除失败！");
										}
									}
								);
							});
						}
					}
				});
				
			}
		
			//修改
			function edit(id){
				top.jzts();
				var diag = new top.Dialog();
				diag.Drag=true;
				diag.Title ="编辑";
				diag.URL = '<%=basePath%>product/goEdit.do?id='+id;
				diag.Width = 450;
				diag.Height = 450;
				diag.CancelEvent = function(){ //关闭事件
					if(diag.innerFrame.contentWindow.document
							.getElementById('zhongxin').style.display == 'none'){
						//检查当前的分页页码
						currentPage = $("#product_grid").bootgrid("getCurrentPage");
						$("#product_grid").bootgrid("reload");
					}
					diag.close();
				};
				diag.show();
			}
			
		  	//excel导出
			function exportExcel(){
				top.Dialog.confirm("确定导出当前数据？", function(){
					var keyword = $("#keyword").val();
					var productType = $("#productType").val();
					var param = '?KEYW=' + keyword + '&productType=' + productType;
					window.location.href = '<%=basePath%>product/exportToExcel.do' + param;
				});
			}
		</script>
	</body>
</html>
