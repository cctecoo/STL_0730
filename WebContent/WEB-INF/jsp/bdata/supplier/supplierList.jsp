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
	<link type="text/css" rel="StyleSheet" href="static/css/dtree.css"  />
	<link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
	<link rel="stylesheet" href="<%=basePath%>plugins/font-awesome/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	
	<style type="text/css">
		/*设置下拉列表样式*/
		.dropdown-menu{
			width:250px; margin-left:2px;
      	    margin-top:-3px; border-radius:0;
        }
        .dropdown-menu li{
        	 padding:5px 10px;
        	 cursor:pointer;
        }
         .dropdown-menu li:hover{
        	background:#448fb9;
        	color:#fff;
        }
        #configEmpDiv:hover>.dropdown-menu{
        	display: block;
        }
        #showConfigEmpDiv:hover>.dropdown-menu{
        	display: block;
        }
        /*加载样式*/
		.loadDivMask{
			display:none;
			text-align:center; height:100%; width:100%; padding-top:20%;
			position:fixed; _position:absolute; top:0; z-index:1111; 
			background-color: #5d5555; opacity:0.4; color:white
		} 
	</style>
	</head>
	<body>
		<div id="loadDiv" class="loadDivMask" >
			 <i class=" fa fa-spinner fa-pulse fa-4x"></i>
			 <h4 class="block">操作中...</h4>
		</div>
		
		<div class="container-fluid" id="main-container">
			<div class="row">
				<div class="col-md-12">
					<div class="nav-search" id="nav-search" style="right:5px;/*margin-top: 20px;*/" class="form-search">
						<div class="panel panel-default" style="float:left; margin:10px 0;/*position: absolute;*/z-index: 1000;">
							<div style="float:left">
								
								<c:if test="${isSysAdmin==true }">
									<div id="configEmpDiv" class="dropdown" style="float:left;">
										<a class="btn btn-small btn-warning dropdown" style="margin-right:5px;float:left;">
											<i class="fa fa-cog"></i>配置维护人员
										</a>
										<ul class="dropdown-menu">
											<c:forEach items="${configPageList }" var="item">
												<li onclick="goConfig('${item.typeCode}')">${item.typeName}</li>
											</c:forEach>
									    </ul>
								    </div>
								</c:if>
								<div id="showConfigEmpDiv" class="dropdown" style="float:left;">
									<a class="btn btn-small btn-info" style="margin-right:5px;float:left;">
										<i class="fa fa-eye"></i>查看维护人员
									</a>
									<ul class="dropdown-menu">
										<c:forEach items="${configPageList }" var="item">
											<li onclick="showConfig('${item.typeCode}')">${item.typeName}</li>
										</c:forEach>
								    </ul>
								</div>
								
								<c:if test="${isSysAdmin==true || changePerson=='Y' }">
									<a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
									<a class="btn btn-small btn-info" onclick="importExcel('uploadDetail');" style="margin-right:5px;float:left;" >导入供应商详情</a>

									<a class="btn btn-small btn-info" onclick="importExcel();" style="margin-right:5px;float:left;" >导入供应商</a>
									<a class="btn btn-small btn-info" onclick="exportExcel();" style="margin-right:5px;float:left;" >导出供应商</a>
								</c:if>
								
								<a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" class="btn btn-small btn-primary" 
									style="float:left;text-decoration:none;">高级搜索 </a>
							</div>
						
							<div id="collapseTwo" class="panel-collapse collapse" style="position:absolute; top:32px; z-index:999">
								<div class="panel-body">
									<form id="searchForm">
									<table>
										<tr>
											<td style="width:80px">级别：</td>
											<td>
												<select id="level" name="level">
													<option value="">请选择</option>
													<option value="新供应商" >新供应商</option>
													<option value="一般供应商" >一般供应商</option>
													<option value="战略供应商" >战略供应商</option>
												</select>
											</td>
											<td>供应类型：</td>
		                                    <td>
		                                    	<select id="supplyType" name="supplyType">
													<option value="">请选择</option>
													<option value="办公用品供应商">办公用品供应商</option>
													<option value="原辅料供应商" >原辅料供应商</option>
													<option value="设备供应商" >设备供应商</option>
													<option value="五金配件供应商" >五金配件供应商</option>
													<option value="服务类供应商" >服务类供应商</option>
												</select>
		                                    </td>
										</tr>
										<tr>
		                                    <td style="width:80px">名称：</td>
											<td><input type="text" id="name" name="name" style="width:170px" /></td>
											
		                                    <td>所在国家：</td>
		                                    <td><input type="text" id="country" name="country" style="width:170px"/></td>
		                                </tr>
									</table>
									<div style="margin-right:30px;float: right;">
										<a class="btn-style1" onclick="searchList()" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a>
										<a class="btn-style2" onclick="resetting()" style="cursor: pointer;">重置</a>
										<a data-toggle="collapse" data-parent="#accordion" class="btn-style3" href="#collapseTwo">关闭</a>
									</div>
								</form>
								</div>
							</div>
						</div>
					</div><!-- nav-search end -->
					
					<table id="grid" class="table table-striped table-bordered table-hover">
						<thead>
							<tr>
								<th data-column-id="LEVEL" data-width="110px">级别</th>
								<th data-column-id="SUPPLY_TYPE" data-width="110px">供应类型</th>
								<th data-column-id="FIRST_COOPERATE_YEAR" data-width="100px">初次合作年份</th>
								<th data-column-id="DISLAY_CODE" data-visible="false" data-width="110px">编码</th>
								<th data-column-id="NAME" data-formatter="name">名称</th>
								<th data-column-id="COUNTRY" >所在国家</th>
								<th data-column-id="CREATE_EMP_NAME" data-width="100px">创建人</th>
								<th data-column-id="CREATE_TIME_STR" data-width="140px">创建时间</th>
								<th align="center" data-align="center" data-sortable="false" data-formatter="btns" data-width="130px">操作</th>
							</tr>
						</thead>
					</table>
					
			  	</div>
			</div>
		</div><!-- container-fluid end -->
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
				$("#grid").bootgrid({
					ajax: true,
					url:"supplier/loadList.do",
					navigation:2,
					post: function(){
						var postData = new Object();
						if(currentPage>1){
							postData.currentPage = currentPage;
						}
						postData.itemStatus='YW_YSX';
						
						return postData;
					},
					formatters:{
						name: function(column, row){
							var str = '<span title="' + row.NAME + '" >' + row.NAME +'</span>';
							return str;
						},
						btns: function(column, row){
							var str = '';
							str += '<a style="cursor:pointer;margin:1px;" title="查看" onclick="view('+ row.ID +');" class="btn btn-mini btn-info" '
								+ ' data-rel="tooltip" data-placement="left">查看</a>';
							if("${isAdminGroup==true || changePerson=='Y' }"=="true"){
								str += '<a style="cursor:pointer;margin:1px;" title="编辑" onclick="edit('+ row.ID +');" class="btn btn-mini btn-info" '
								+ ' data-rel="tooltip" data-placement="left">编辑</a>';
								str += '<a style="cursor:pointer;margin:1px;" title="删除" onclick="del('+ row.ID +');" class="btn btn-mini btn-danger" '
								+ ' data-rel="tooltip"  data-placement="left">删除</a>';
							}
							return str;
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
					searchList();
					$("#collapseTwo").collapse('toggle');
				}
			});
			
			//检索
			function searchList(){
				var name = $("#name").val();
				var level = $("#level").val();
				var supplyType = $("#supplyType").val();
				var country = $("#country").val();
				
				$("#grid").bootgrid("search", {
					"name":name, "level":level, "supplyType":supplyType, "country":country
				});
			}
			
			//显示详细信息
			function showSupplyProduct(supplierId){
				var diag = new top.Dialog();
			 	diag.Drag=true;
			 	diag.Title ="供应产品信息";
		 		diag.URL = 'supplier/toShowSupplyProduct.do?supplierId='+supplierId;
			 	diag.Width = 800;
			 	diag.Height = 420;
			 	diag.CancelEvent = function(){ //关闭事件
					diag.close();
			 	};
			 	diag.show();
			}
			
			//新增
			function add(){
				var diag = new top.Dialog();
			 	diag.Drag=true;
			 	diag.Title ="新增";
		 		diag.URL = 'supplier/toAdd.do';
			 	diag.Width = 900;
			 	diag.Height = 600;
			 	diag.CancelEvent = function(){ //关闭事件
			 		searchList();
					diag.close();
			 	};
			 	diag.show();
			}
			
			//修改
			function edit(id){
			 	var diag = new top.Dialog();
			 	diag.Drag=true;
			 	diag.Title ="编辑";
			 	diag.URL = 'supplier/toEdit.do?id='+id;
			 	diag.Width = 800;
			 	diag.Height = 450;
			 	diag.CancelEvent = function(){ //关闭事件
					//检查当前的分页页码
					//currentPage = $("#grid").bootgrid("getCurrentPage");
					searchList();
					diag.close();
			 	};
			 	diag.show();
			}
			
			//查看
			function view(id){
				var diag = new top.Dialog();
			 	diag.Drag=true;
			 	diag.Title ="查看";
			 	diag.URL = 'supplier/toView.do?id='+id;
			 	diag.Width = 800;
			 	diag.Height = 450;
			 	diag.CancelEvent = function(){ //关闭事件
					diag.close();
			 	};
			 	diag.show();
			}
			
			//删除
			function del(id){
				top.Dialog.confirm("确定要删除?",function(){ 
					top.jzts();
					var url = "supplier/delete.do";
					$.ajax({
						type: 'post',
						url: url,
						data: {'id': id},
						success: function(data){
							if(data.msg!='success'){
								top.Dialog.alert('后台出错，请联系管理员');
								return;
							}
							searchList();
						}
					});
				});
			}
			
			//打开上传excel页面
			function importExcel(type){
				//显示上传页面
				var diag = new top.Dialog();
				diag.Drag=true;
				diag.Title ="EXCEL 导入到数据库";
				diag.URL = 'common/goUploadSupplierExcel.do';
				if(type=='uploadDetail'){
                    diag.URL = 'common/goUploadSupplyDetailExcel.do';
				}
				diag.Width = 400;
				diag.Height = 250;
				diag.CancelEvent = function(){ //关闭事件
					var importMsg = diag.innerFrame.contentWindow.document.getElementById('saveResult').value;
				 	if('success'==importMsg){
				 		$("#grid").bootgrid("reload");
				 	}
					diag.close();
				};
				diag.show();
			}
			
			//导出
			function exportExcel(){
				top.Dialog.confirm('确定执行？', function(){
					window.location.href='<%=basePath%>supplier/exportItem.do';
		  		});
			}
			
		
			//配置维护人员
			function goConfig(showPage){
				 top.jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="配置维护人员";
				 diag.URL = '<%=basePath%>employee/goConfig.do?showPage=' + showPage;
				 diag.Width = 950;
				 diag.Height = 510;
				 diag.CancelEvent = function(){ //关闭事件
					 
					 diag.close();
				 };
				 diag.show();
			}
			
			//展示维护人员
			function showConfig(showPage){
				 top.jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="展示维护人员";
				 diag.URL = '<%=basePath%>employee/showConfig.do?showPage=' + showPage;
				 diag.Width = 550;
				 diag.Height = 510;
				 diag.CancelEvent = function(){ //关闭事件
					 diag.close();
				 };
				 diag.show();
			}
		</script>
	</body>
</html>