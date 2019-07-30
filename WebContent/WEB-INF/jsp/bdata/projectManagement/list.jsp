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
	<!-- jsp文件头和头部 -->
	<link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link href="static/css/style.css" rel="stylesheet" />
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	<link rel="stylesheet" href="static/css/datepicker.css">

	</head>
	<body>
		<div class="container-fluid" id="main-container">
			<div id="page-content" class="clearfix">
				<div class="breadcrumbs" id="breadcrumbs">
				     &nbsp; &nbsp; 方案配置管理
					<div style="position:absolute; top:5px; right:25px;">
						<div>
							<a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
							<a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" class="btn btn-small btn-primary" style="float:left;text-decoration:none;">高级搜索 </a>
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
									<td><label>编号：</label></td>
									<td>
										<input autocomplete="off" type="text" id="CODE" name="CODE" value="" placeholder=" 编号" 
											title="编号"	/>
									</td>
									<td><label>试用对象：</label></td>
										<td>
											<select id="FITABLE" name="FITABLE">
												<option value="">全部</option>
												<c:forEach items="${depList }" var="dept" varStatus="vs">
													<option value="${dept.ID }">${dept.GRADE_NAME}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<td><label>创建日期：</label></td>
										<td>
					                        <input type="text" id="CREATE_TIMER" name="CREATE_TIMER" style="background:#fff!important;" 
					                               class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请选择年月日！" readonly="readonly"/>
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
					<table id="project_grid" class="table table-striped table-bordered table-hover">
						<thead>
							<tr>
								<th data-column-id="CODE" data-order="asc" data-width="100px" data-visible="false">编号</th>
								<th data-column-id="FORMULA_NAME" data-order="asc" data-width="15%">名称</th>
								<th data-column-id="FORMULA" data-formatter="formula">公式</th>
								<th data-column-id="FORMULA_TYPE" data-formatter="fitType" data-width="150px">适用类型</th>
								<th data-column-id="FITABLE" data-formatter="fitable" data-visible="false">试用对象</th>
								<th data-column-id="CREATE_TIMER" data-width="100px">创建时间</th>
								<th data-column-id="CREATE_USERNAME" data-width="100px">创建人</th>
								<th align="center" data-align="center" data-sortable="false" data-formatter="btns" data-width="150px">操作</th>
							</tr>
						</thead>
					</table>
				</div>
 
				<!-- PAGE CONTENT ENDS HERE -->
			  </div><!--/row-->
	
			</div><!--/#page-content-->
		</div><!--/.fluid-container#main-container-->
		
		<!-- 引入 -->
		<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
		<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
	    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
		<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
		<!-- 引入 -->
		
		<script type="text/javascript">
		//日期框
	    $(function() {
	        $('#CREATE_TIMER').datepicker({
	            format:'yyyy-mm-dd',
	            changeMonth: true,
	            changeYear: true,
	            showButtonPanel: true,
	            autoclose: true,
	            minViewMode:0,
	            maxViewMode:2,
	            startViewMode:0,
	            onClose: function(dateText, inst) {
	                var year = $("#span2 date-picker .ui-datepicker-year :selected").val();
	                $(this).datepicker('setDate', new Date(year, 1, 1));
	            }
	        });
	    });
		
		$(function() {
			$("#project_grid").bootgrid({
				ajax: true,
				url:"projectManagement/projectList.do",
				navigation:2,
				formatters:{
					formulaName: function(column, row){
						return  '<sapn title="' + row.FORMULA_NAME + '">' + row.FORMULA_NAME + '</span>';
					},
					formula: function(column, row){
						return '<sapn title="' + row.FORMULA + '">' + row.FORMULA + '</span>';
					},
					fitType: function(column, row){
						var type = row.FORMULA_TYPE;
						if('productLine'==type){
							return '产线经理等管理人员';
						}else if('dept'==type){
							return '车间主任等管理人员';
						}else{
							return '车间工人等基层人员';
						}
					},
					fitable: function(column, row){
						if(null==row.FITABLE){
							return '';
						}
						return '<span title="' + row.FITABLE + '">' + row.FITABLE + '</span>';
					},
					btns: function(column, row){
						return '<a style="cursor:pointer;margin:1px;" title="配置试用对象" onclick="configSalaryEmp('+ row.ID +');" class="btn btn-mini btn-info" data-rel="tooltip"  data-placement="left">'+
						'<i class="icon-cog"></i></a>'+
						'<a style="cursor:pointer;margin:1px;" title="编辑" onclick="edit('+ row.ID + ',' + row.PRODUCT_FORMULA_ID +');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">'+
						'<i class="icon-edit"></i></a>'+
						'<a style="cursor:pointer;margin:1px;" title="查看" onclick="view('+ row.ID +')" class="btn btn-mini btn-info" data-rel="tooltip"  data-placement="left">'+
							'<i class="icon-eye-open"></i></a>'+
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
		
		//检索
		function search2(){
			var CODE = $("#CODE").val();
			var FITABLE = $("#FITABLE").val();
			var CREATE_TIMER = $("#CREATE_TIMER").val();
			$("#project_grid").bootgrid("search", 
							{"CODE":CODE, "FITABLE":FITABLE, "CREATE_TIMER":CREATE_TIMER});
		}
		
		//新增
		function add(){
			window.location.href = "<%=basePath%>projectManagement/toAdd.do";
		}
		
		//删除
		function del(id){
			
			top.Dialog.confirm("确定要删除?",function(){
				top.jzts();
				var url = "<%=basePath%>/projectManagement/delete.do?id="+id;
				$.get(url,function(data){
					if(data=="success"){
						$("#project_grid").bootgrid("reload");
						
					}else{
						top.Dialog.alert("删除出错");
					}
				},"text");
			});
		}
		
		//配置公式的使用对象
		function configSalaryEmp(ID){
			var dialogUrl =  '<%=basePath%>dept/deptAndEmp.do?STATUS=2';
			var diag = new top.Dialog();
	        diag.Drag=true;
	        diag.Title ="人员选择";
	        diag.URL = dialogUrl;
	        diag.Width = 860;
	        diag.Height = 445;
	        diag.ShowOkButton = true;
	        diag.ShowCancelButton = false;
	        diag.OKEvent = function(){//点击确认按钮后执行操作
	        	
	        	//获取选择的员工编码
	        	var empCodes = diag.innerFrame.contentWindow.document.getElementById('EMP_CODE').value;
	        	top.Dialog.confirm('确定修改公式关联的员工关系?', function(){
	        		//保存员工的薪酬公式
		            $.ajax({
		            	type: 'post',
		            	url: '<%=basePath%>projectManagement/saveSalaryFormulaEmp.do',
		            	data: {salaryFormulaId: ID, empCodes: empCodes},
		            	success: function(data){
		            		if('success'==data){
		            			alert('操作成功');
		            		}else{
		            			alert('后台出错，请联系管理员！');
		            		}
		            	}
		            });
	        	});
	            
	            diag.close();
	            $("#project_grid").bootgrid("reload");
	        }
			//先根据公式查询出已经选择的人员列表
			$.ajax({
				type: 'post',
				url: '<%=basePath%>projectManagement/findSalaryFormulaEmpNames.do',
				data: {salaryFormulaId : ID},
				success: function(data){
					if(data!='' && data.empNames!=''){
						//如果查询到人员，则拼接到弹出窗的url后面
						diag.URL += '&EMP_NAME=' + data.EMP_NAMES + '&EMP_ID=' + data.EMP_IDS + '&EMP_CODE=' + data.EMP_CODES;
					}
					//显示选择人员的窗口
			        diag.show();
				}
			});
		}
		
		//修改
		function edit(id, productFormulaId){
			var url = "<%=basePath%>projectManagement/goEdit.do?ID="+id;
			if(productFormulaId){
				url += "&productFormulaId=" + productFormulaId;
			}
			window.location.href = url;
		}
		
		//查看
		function view(id){
			window.location.href = "<%=basePath%>projectManagement/goView.do?ID="+id;
		}
		</script>
		
		<script type="text/javascript">
		
		//全选 （是/否）
		function selectAll(){
			 var checklist = document.getElementsByName ("ids");
			   if(document.getElementById("zcheckbox").checked){
			   for(var i=0;i<checklist.length;i++){
			      checklist[i].checked = 1;
			   } 
			 }else{
			  for(var j=0;j<checklist.length;j++){
			     checklist[j].checked = 0;
			  }
			 }
		}

		
		
		//批量操作
		function makeAll(msg){
			
			if(confirm(msg)){ 
				
					var str = '';
					for(var i=0;i < document.getElementsByName('ids').length;i++)
					{
						  if(document.getElementsByName('ids')[i].checked){
						  	if(str=='') str += document.getElementsByName('ids')[i].value;
						  	else str += ',' + document.getElementsByName('ids')[i].value;
						  }
					}
					if(str==''){
						alert("您没有选择任何内容!"); 
						return;
					}else{
						if(msg == '确定要删除选中的数据吗?'){
							top.jzts();
							$.ajax({
								type: "POST",
								url: '<%=basePath%>/positionLevel/deleteAll.do?tm='+new Date().getTime(),
						    	data: {DATA_IDS:str},
								dataType:'json',
								//beforeSend: validateData,
								cache: false,
								success: function(data){
									 $.each(data.list, function(i, list){
											nextPage(${page.currentPage});
									 });
								}
							});
						}
					}
			}
		}
		
		//导出excel
		function toExcel(){
			window.location.href='<%=basePath%>/pictures/excel.do';
		}
		
		//重置
		function resetting(){
			$("#Form")[0].reset(); 
		}
		</script>
		
		<style type="text/css">
			li {list-style-type:none;}
		</style>
		<ul class="navigationTabs">
            <li><a></a></li>
            <li></li>
        </ul>
	</body>
</html>
