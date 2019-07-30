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
		<title></title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	</head> 
<body>
		
<div class="container-fluid" id="main-container">



<div id="page-content" class="clearfix">
						
  <div class="row-fluid">


	<div class="row-fluid">
	
			<!-- 检索  -->
			<form action="kaohe/mlist.do" method="post" name="kaoheForm" id="kaoheForm">
			<table>
				<tr>
					<td>
						<span class="input-icon">
							<input autocomplete="off" id="nav-search-input" type="text" name="name" value="${pd.name}" placeholder="培训课程名" />
							<i id="nav-search-icon" class="icon-search"></i>
						</span>
					</td>
					<td><input class="span10 date-picker" name="lastLoginStart" id="lastLoginStart"  value="${pd.year}" type="text" data-date-format="yyyy" readonly="readonly" style="width:88px;" placeholder="年度" title="年度"/></td>
					<td> <button class="btn btn-mini btn-light" onclick="search();" title="检索"><i id="nav-search-icon" class="icon-search"></i></button> </td>
				
				<td>  <a class="btn btn-small btn-success" onclick="add();">新增</a> </td>
				</tr> 
			</table>
			<!-- 检索  -->
		
		
			<table id="table_report" class="table table-striped table-bordered table-hover">
				
				<thead>
					<tr>
						<th>序号</th>
						<th>培训课程名</th>
						<th>培训类型</th>
						<th>培训人</th>
						<th>课时</th>
						<th>培训日期</th>
						<th>内容</th>
						<th>标准</th>
						<th>分值</th>
						<th>考核人</th>
						<th>操作</th>
					</tr>
				</thead>
										
				<tbody>
					
				<!-- 开始循环 -->	
				<c:choose>
					<c:when test="${not empty varsList}">
						<c:forEach items="${varsList}" var="course" varStatus="vs">
							<tr>
								<td>${course.id }</td>
								<td>${course.course_name }</td>
								<td>${course.course_type_name }</td>
								<td>${course.course_teacher }</td>
								<td>${course.course_hour }</td>
								<td>${course.course_comment }</td>
								<td>${course.course_standard }</td>
								<td>${course.course_name}</td>
								<td>${course.course_score}</td>
								<td>${course.check_person}</td>
								<td>
								<a class='btn btn-mini btn-info' title="编辑" onclick="edit('${course.id}');"><i class='icon-edit'></i></a>
								<a class='btn btn-mini btn-danger' title="删除" onclick="del('${course.id}');"><i class='icon-trash'></i></a>
								<a class='btn btn-mini btn-info' title="学员成绩" onclick="sel('${course.id}');"><i class='icon-edit'></i></a>
								</td>
							</tr>
						
						</c:forEach>
					
					</c:when>
					<c:otherwise>
						<tr class="main_info">
							<td colspan="10" class="center">没有相关数据</td>
						</tr>
					</c:otherwise>
				</c:choose>
					
				
				</tbody>
			</table>
			
		<div class="page-header position-relative">
		<table style="width:100%;">
			<tr>
				<td style="vertical-align:top;"></td>
				<td style="vertical-align:top;"><div class="pagination" style="float: right;padding-top: 0px;margin-top: 0px;">${page.pageStr}</div></td>
			</tr>
		</table>
		</div>
		</form>
	</div>
 
 
 
 
	<!-- PAGE CONTENT ENDS HERE -->
  </div><!--/row-->
	
</div><!--/#page-content-->
</div><!--/.fluid-container#main-container-->
		<!-- 返回顶部  -->
		<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse">
			<i class="icon-double-angle-up icon-only"></i>
		</a>
		
		<!-- 引入 -->
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
		<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
		<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
		<!-- 引入 -->
		
		<!--引入弹窗组件start-->
		<script type="text/javascript" src="static/js/attention/zDialog/zDrag.js"></script>
		<script type="text/javascript" src="static/js/attention/zDialog/zDialog.js"></script>
		<!--引入弹窗组件end-->
		
		<script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
		<script type="text/javascript">
		
		$(top.changeui());
		
		//检索
		function search(){
			top.jzts();
			$("#kaoheForm").submit();
		}
		
		</script>
		
		<script type="text/javascript">
		
		$(function() {
			
			//日期框
			$('.date-picker').datepicker();
			
			//下拉框
			$(".chzn-select").chosen(); 
			$(".chzn-select-deselect").chosen({allow_single_deselect:true}); 
			
			//复选框
			$('table th input:checkbox').on('click' , function(){
				var that = this;
				$(this).closest('table').find('tr > td:first-child input:checkbox')
				.each(function(){
					this.checked = that.checked;
					$(this).closest('tr').toggleClass('selected');
				});
					
			});
			
		});
		
		//新增
		function add(){
			
			window.location.href="<%=basePath%>/kaohe/toEdit.do";
			return ;
		}
		
		//修改
		function edit(id){
			//alert(id);
			window.location.href='<%=basePath%>/kaohe/toEdit.do?ID='+id;
			return ;
		}
		
		//删除
		function del(id){
			bootbox.confirm("确定要删除吗?", function(result) {
				if(result) {
					top.jzts();
					var url = "kaohe/del.do?ID="+id+"&tm="+new Date().getTime();
					$.get(url,function(data){
						window.location.href='<%=basePath%>kaohe/mlist.do';
					});
				}
			});
		}
		
		</script>
		
	</body>
</html>

