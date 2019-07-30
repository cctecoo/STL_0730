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
    <link type="text/css" rel="stylesheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css" />
    <link rel="stylesheet" href="static/css/font-awesome.min.css" />
    <style type="text/css">
		.container{width: 100%;}
	</style>
    <script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<body>
	<input type="hidden" id="sysUser" name="sysUser" value="${sysUser}"/>
	<div class="container-fluid" id="main-container">
		<div class="row">
			<div class="col-md-12">
				<div class="nav-search" id="nav-search" style="right:5px;margin-top: 20px;" class="form-search">
					<div class="panel panel-default" style="float:left;position: absolute;z-index: 1000;">
						<div>
							<a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
							<a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" class="btn btn-small btn-primary" style="float:left;text-decoration:none;">高级搜索 </a>
						</div>
						<div id="collapseTwo" class="panel-collapse collapse" style="position:absolute; top:32px; z-index:999">
							<div class="panel-body">
								<form id="searchForm">
									<table>
 										<tr>
											<td><label>公告标题：</label></td>
											<td><input type="text" id="noticeTitle" name="noticeTitle" /></td>
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
				<table id="notice_grid" class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th data-column-id="TITLE" data-width="140px" data-formatter="info">标题</th>
							<th data-column-id="STATUS" data-formatter="statusName" data-width="80px">状态</th>
							<th data-column-id="AREA" data-width="120px">通知区域</th>
							<th data-column-id="CREATE_USER" data-formatter="createUser" data-width="80px">创建人</th>
							<th data-column-id="CREATE_TIME" data-width="80px">创建时间</th>
							<th align="center" data-align="center" data-formatter="oper" data-width="120px" data-sortable="false">操作</th>
						</tr>
					</thead>
				</table>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		$("#notice_grid").bootgrid({
			ajax: true,
			selection: true,
			multiSelect: true,
			navigation: 2,
			url:"notice/noticeList.do",
			labels:{
				infos:"{{ctx.start}}至{{ctx.end}}条，共{{ctx.total}}条",
				refresh:"刷新",
				noResults:"未查询到数据",
				loading:"正在加载...",
				all:"全选"
			},
			formatters:{
				info:function(column, row){
					return '<a style="cursor:pointer;" title="'+row.TITLE+'" onclick="info('+ row.ID +');">'+row.TITLE+'</a>';
				},
				oper:function(column,row){
					var operStr = "";
					if(row.STATUS=='YW_CG' && $("#sysUser").val()==row.CREATE_USER){
						operStr += '<a style="cursor:pointer;" title="发布" class="btn btn-mini btn-info" '
								+'onclick="publish('+ row.ID +');"><i class="icon-envelope"></i></a>'
								+'<a style="cursor:pointer;margin-left: 3px;" title="删除" class="btn btn-mini btn-danger" '
								+'onclick="deleteNotice('+ row.ID +');"><i class="icon-trash"></i></a>';
					}else if(row.STATUS=='YW_YSX'){
						operStr += '<a style="cursor:pointer;" title="查看" class="btn btn-mini btn-info" '
							+'onclick="info('+ row.ID +');"><i class="icon-eye-open"></i></a>'
					}
					return operStr;
				},
				createUser:function(column,row){
					return row.CREATE_NAME;
				},
				statusName:function(column,row){
					return row.STATUS_NAME;
				}
			}
		});
		
		function searchBtn(){
			$("#notice_grid").bootgrid("search", {
				"noticeTitle":$("#noticeTitle").val()
			});
		}
		
		//重置
		function resetting(){
			$("#searchForm")[0].reset(); 
		}
		
		function add(){
			top.jzts();
		 	var diag = new top.Dialog();
		 	diag.Drag=true;
		 	diag.Title ="新增公告信息";
		 	diag.URL = 'notice/toAdd.do';
		 	diag.Width = 850;
		 	diag.Height = 700;
		 	diag.CancelEvent = function(){ //关闭事件
				diag.close();
		 		$("#notice_grid").bootgrid("reload");
		 	};
		 	diag.show();
		}
		
		function publish(id){
			top.jzts();
		 	top.Dialog.confirm("是否要发布该公告？",function(){
				 $.ajax({
                       url:"notice/publish.do",
                       type:"post",
                       data:{"id":id},
                       success:function(data){
                           if(data == "success"){
                               top.Dialog.alert("发布成功");
                               $("#notice_grid").bootgrid("reload");
                           }else{
                           	   top.Dialog.alert("发布失败");
                           }
                       }
                   });
			 })
		}
		
		function deleteNotice(id){
			 top.Dialog.confirm("是否确认删除公告？",function(){
				 $.ajax({
                        url:"notice/delete.do",
                        type:"post",
                        data:{"id":id},
                        success:function(data){
                            if(data == "success"){
                            	top.Dialog.alert("操作成功");
                                $("#notice_grid").bootgrid("reload");
                            }else{
                            	top.Dialog.alert("操作失败");
                            }
                        }
                    });
			 })
		}
		
		function info(id){
			top.jzts();
		 	var diag = new top.Dialog();
		 	diag.Drag=true;
		 	diag.Title ="公告信息详情";
		 	diag.URL = 'notice/toNoticeInfo.do?id='+id;
		 	diag.Width = 850;
		 	diag.Height = 700;
		 	diag.CancelEvent = function(){ //关闭事件
				diag.close();
		 	};
		 	diag.show();
		}
	</script>
</body>
</html>