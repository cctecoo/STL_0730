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
	<meta http-equiv="content-Type" content="text/html; charset=UTF-8">
	<!-- jsp文件头和头部 -->
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link href="static/css/style.css" rel="stylesheet" />
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	<style type="text/css">
		#main-container{padding:0;position:relative}
		#breadcrumbs{position:relative;z-index:13;border-bottom:1px solid #e5e5e5;background-color:#f5f5f5;height:37px;line-height:37px;padding:0 12px 0 0;display:block}
	</style>
	</head>
<body>
	<div class="container-fluid" id="main-container">
		<div id="page-content" class="clearfix">
			<div class="breadcrumbs" id="breadcrumbs">
			     &nbsp; &nbsp; 客户管理
				<div style="position:absolute; top:5px; right:25px;">
					<div>
						<a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
						<a data-toggle="collapse" data-parent="#accordion"
							href="#collapseTwo" class="btn btn-small btn-primary"
							style="float:left;text-decoration:none;">
							高级搜索 </a>
					</div>
					<div id="collapseTwo" class="panel-collapse collapse"
						style="position:absolute; top:32px;right:0px; z-index:999">
						<div class="panel-body">
							<form id="searchForm">
							<table>
								<tr>
									<td><label>客户编码：</label></td>
									<td><input type="text" id="customerCode" name="customerCode" /></td>
									<td><label>客户名称：</label></td>
									<td><input type="text" id="customerName" name="customerName"/></td>
								</tr>
								<tr>
                                    <td><label>描述：</label></td>
                                    <td><input type="text" id="description" name=""description""/></td>
                                </tr>
							</table>
							<div style="margin-right:30px;float: right;">
								<a class="btn-style1" onclick="searchBtn()" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a>
								<a class="btn-style2" onclick="resetting()" style="cursor: pointer;">重置</a>
								<a data-toggle="collapse" data-parent="#accordion" class="btn-style3" href="#collapseTwo">关闭</a>
							</div>
						</form>
						</div>
					</div>
				</div>
			</div>
		
			<div class="row-fluid">
				<div class="row-fluid">
					<!-- 检索  -->
					<form>
						<table id="customer_grid" class="table table-striped table-bordered table-hover">
							<thead>
								<tr>
									<th data-column-id="CUSTOMER_CODE">客户编码</th>
									<th data-column-id="CUSTOMER_NAME">客户名称</th>
									<th data-column-id="userName">创建人</th>
									<th data-column-id="DESCP">描述</th>
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
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	
	<script type="text/javascript">
		//判断是否有页码传入
		var currentPage = ('${pd.currentPage}' == '') ? 0 : '${pd.currentPage}';
		
		$(function() {
			$("#customer_grid").bootgrid({
				ajax: true,
				url:"customer/customerList.do",
				navigation:2,
				post: function(){
					var postData = new Object();
					if(currentPage>1){
						postData.currentPage = currentPage;
					}
					
					return postData;
				},
				formatters:{
					btns: function(column, row){
							return '<a style="cursor:pointer;margin:1px;" title="编辑" onclick="edit('+ row.ID +');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'+
							'<i class="icon-edit"></i></a>'+
							'<a style="cursor:pointer;margin:1px;" title="删除" onclick="del('+ row.ID +');" class="btn btn-mini btn-danger" data-rel="tooltip"  data-placement="left">'+
								'<i class="icon-trash"></i></a>'
					}
				}
			}).on("loaded.rs.jquery.bootgrid",function(e){
				currentPage = 0;//加载后重置之前传入的页码
			});
			
		});
		//重置
		function resetting(){
			$("#searchForm")[0].reset(); 
		}
		
		//回车绑定查询功能
		$(document).keyup(function(event) {
			if (event.keyCode == 13) {
				searchBtn();
				$("#collapseTwo").collapse('toggle');
			}
		});
		
		//检索
		function searchBtn(){
			var customerCode = $("#customerCode").val();
			var customerName = $("#customerName").val();
			var description = $("#description").val();
			
			$("#customer_grid").bootgrid("search", 
					{"customerCode":customerCode,"customerName":customerName,"description":description});
		}
		
		//新增
		function add(){
			top.jzts();
			var diag = new top.Dialog();
		 	diag.Drag=true;
		 	diag.Title ="新增";
	 		diag.URL = '<%=basePath%>/customer/goAdd.do';
		 	diag.Width = 400;
		 	diag.Height = 300;
		 	diag.CancelEvent = function(){ //关闭事件
				 
		 		searchBtn();
				diag.close();
		 	};
		 	diag.show();
		}
		
		//删除
		function del(id){
			top.Dialog.confirm("确定要删除?",function(){ 
				top.jzts();
				var url = "<%=basePath%>/customer/delete.do?ID="+id;
				$.get(url,function(data){
					if(data=="success"){
						//检查当前的分页页码
						currentPage = $("#customer_grid").bootgrid("getCurrentPage");
						searchBtn();
					}else if(data=="error"){
						top.Dialog.alert("删除出错");
					}
				},"text");
			})
		}
		
		//修改
		function edit(id){
		 	top.jzts();
		 	var diag = new top.Dialog();
		 	diag.Drag=true;
		 	diag.Title ="编辑";
		 	diag.URL = '<%=basePath%>/customer/goEdit.do?ID='+id;
		 	diag.Width = 400;
		 	diag.Height = 300;
		 	diag.CancelEvent = function(){ //关闭事件
				//检查当前的分页页码
				currentPage = $("#customer_grid").bootgrid("getCurrentPage");
				searchBtn();
				diag.close();
		 	};
		 	diag.show();
		}
	</script>
</body>
</html>