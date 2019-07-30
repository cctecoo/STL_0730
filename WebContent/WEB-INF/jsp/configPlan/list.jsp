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
    <title>推送计划</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link type="text/css" rel="StyleSheet" href="static/css/dtree.css"  />
	<link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	
	<link rel="stylesheet" href="static/css/datepicker.css" />
    <!-- 引入 -->
    <style type="text/css">
		#main-container{padding:0;position:relative}
		#breadcrumbs{position:relative;z-index:13;border-bottom:1px solid #e5e5e5;background-color:#f5f5f5;height:37px;line-height:37px;padding:0 12px 0 0;display:block}
		.bootgrid-table th>.column-header-anchor>.text{margin:0px 13px 0px 0px}
	</style>
</head>
<body>
	<div class="container-fluid" id="main-container">
		<div id="page-content" class="clearfix">
			<div class="breadcrumbs" id="breadcrumbs" style="">
			     &nbsp; &nbsp; <span style="margin-left:20px; float:left; font-size:15px">公司年度经营目标</span>
			    <div id="btnDiv" style="float:left; margin-left:150px;">
			    	<input id="searchField" type="hidden" value="2" />
		    		<button class="btn btn-small btn-danger" onclick="clickSearch(0, this);">运行中</button>
		    		<button class="btn btn-small btn-warning" onclick="clickSearch(1, this);">已停用</button>
				    <button class="btn btn-small btn-info active" onclick="clickSearch(2, this);">全部</button>
			    </div>
			</div>
			<div class="row-fluid ">
				<table id="plan_grid" class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th data-column-id="NAME" data-formatter="NAME">计划名称</th>
							<th data-column-id="START_DATE" data-width="80px">开始日期</th>
							<th data-column-id="DORULE" data-formatter="DORULE" data-width="200px">执行规则</th>
							<th align="center" data-align="center" data-width="110px" data-sortable="false" data-formatter="btns" >操作</th>
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
	<script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
	<!-- 预加载js -->
	<script type="text/javascript">
		
    	$(function() {
       		$("#plan_grid").bootgrid({
				ajax: true,
				url:"configPlan/planList.do",
				navigation:2,
				selection: true,
       			multiSelect: true,
				formatters:{
					NAME:function(column, row){
						var str = row.VIEWNAME;
						if(str == "chart")
						{
							str = "销售分析";
						}else if(str == "ranking")
						{
							str = "系统使用情况";
						}
						else if(str == "report")
						{
							str = "日常工作提交情况";
						}
						else if(str == "timeout")
						{
							str = "超期工作";
						}
						else if(str == "weeklysummary")
						{
							str = "本周系统积分排名情况";
						}
						return '<span style="cursor:pointer;" ">' + str +"推送计划"+ '</span>';						
					},
					DORULE:function(column, row){
						var rule = row.RULE;
						if(rule=='1'){
							return '<span style="cursor:pointer;">'  +"每天"+ row.DAYTIME + '</span>';
						}else if(rule=='2'){
							var week = row.DAY_FOR_WEEK;
							var result = "";
							$(week.split(",")).each(function (i,dom){
								if(dom != "1"&&dom != 1)
								{
									if(result !="")
									{
										result = result +","+ (dom - 1); 
									}else
									{
										result = (dom - 1);
									}									
								}
								else
								{
									result = result+",日";
								}
				            });
							return '<span style="cursor:pointer;">'  +"每周"+ result + " " + row.WEEKTIME + '</span>';
						}else if(rule=='3'){
							return '<span style="cursor:pointer;">'  +"每月"+row.DAY_FOR_MONTH +"号"+ row.MONTHTIME + '</span>';
						} 
					},
					btns: function(column, row){
						var btnStr = '';
						btnStr += '<button title="编辑" onclick="edit(\'' + row.VIEWNAME +'\');" class="btn btn-mini btn-primary" >'+
                        '<i class="icon-edit"></i></button>'+
						'<button style="margin-left:1px;" title="删除" onclick="del(\'' + row.ID +'\');" class="btn btn-mini btn-danger" >'+
                        '<i class="icon-trash"></i></button>';
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
			var status = $("#searchField").val();
			$("#plan_grid").bootgrid("search", {
				"status":status
			});
	    }
	    
	    //点击进行查询
	    function clickSearch(value, ele){
	    	$("#btnDiv button").removeClass("active");
	    	$(ele).addClass("active");
	    	$("#searchField").val(value);
	    	toSearch();
	    }
	
		function edit(viewName){
			var viewName = viewName;
			top.mainFrame.tabAddHandler("explain1", "配置推送计划", "<%=basePath%>/configPlan/goConfigPlan.do?viewName=" +viewName);
		}
		
		
		function del(id){
			var viewName
			if(confirm("确定要删除?")){ 
				top.jzts();
				var url = "<%=basePath%>/configPlan/delete.do?ID="+id;
				$.get(url,function(data){
					if(data=="success"){
						$("#plan_grid").bootgrid("reload");						
					}else if(data=="error"){
						alert("删除出错");
					}
				},"text");
			}
		}
	</script>
	<!-- 按钮功能 -->

</body>
</html>
