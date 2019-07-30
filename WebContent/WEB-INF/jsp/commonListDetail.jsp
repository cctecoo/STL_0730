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
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	<link rel="stylesheet" href="static/css/datepicker.css" />
	<style type="text/css">
		li {list-style-type:none;}
		.btn{margin:3px;}
		
		/*设置下拉列表样式*/
		#addDiv .dropdown-menu{
			width:180px; margin-left:2px;
      	    margin-top:-3px; border-radius:0;
        }
        #addDiv .dropdown-menu li{
        	 padding:5px 10px;
        	 cursor:pointer;
        }
        #addDiv .dropdown-menu li:hover{
        	background:#448fb9;
        	color:#fff;
        }
        #addDiv:hover .dropdown-menu{
        	display: block;
        }
        #searchForm td{padding:3px;}
		.bootgrid-table td {
			white-space: normal;
		}
	</style>
	</head>
	<body>
		<div class="container-fluid" id="main-container">
			<div class="row">
				<div class="col-md-12">

					<c:if test="${pd.searchType=='formModelStepNext' || pd.searchType=='formModelStepCheckup'
					    || pd.searchType=='findFormWorkByEmpcode' }"><!-- 表单转交规则列表 -->
					<div class="nav-search" id="nav-search" style="right:5px;/*margin-top: 20px;*/" class="form-search">
						<div class="panel panel-default" style="width:98%; float:left; margin:5px auto;/*position: absolute;*/z-index: 1000;">
							<form id="searchInfoForm">
								<table>

									<tr>
										<td style="width:70px">员工:</td>
										<td>
											<input type="text" readonly id="createEmpName" name="createEmpName" onclick="deptAndEmp();"
												   placeholder="请选择" style="width:230px"/>
											<input type="hidden" id="createEmpCode" name="createEmpCode" value="noEmpcode"/>
										</td>
									</tr>

								</table>

								<div id="typeDiv" style="margin-right:30px;float: right;">
									<input type="hidden" id="showAllWork" value="mine" /><!-- 默认查询我的表单 -->
									<a class="btn btn-small btn-info active" name="mine" onclick="searchInfo();" style="cursor: pointer;">查询</a>
									<a class="btn btn-small btn-info" onclick="emptySearch()" style="cursor: pointer;">重置</a>
								</div>
							</form>

						</div>
					</div>
					</c:if>

					<table id="info_grid" style="margin-top:10px;"  class="table table-striped table-bordered table-hover">
						<thead>
							<tr>
								<th data-column-id="ID" data-type="numeric" data-identifier="true" data-width="80px">ID</th>
								<c:if test="${pd.searchType=='budgetForm' }"><!-- 预算占用列表 -->
									<th data-column-id="RELATE_MONTH" data-width="100px" data-formatter="relateMonth">发生月度</th>
									<th data-column-id="BUDGET_AMOUNT" data-width="110px">占用预算</th>
									<th data-column-id="WORK_NO" data-width="120px">任务编号</th>
									<th data-column-id="TASK_NAME" data-formatter="name" >名称</th>
									<th data-column-id="CREATE_EMP_NAME" data-width="120px">发起人</th>
								</c:if>

								<c:if test="${pd.searchType=='formModelStepNext' }"><!-- 表单转交规则列表 -->
									<th data-column-id="MODEL_STEP_NAME" data-width="120px">当前步骤</th>
									<th data-column-id="NEXT_STEP_NAME" data-width="120px">下一步骤</th>
									<th data-column-id="FORM_DISPLAY_NAME" data-width="120px">模板显示名称</th>
									<th data-column-id="FORM_TYPE" data-width="100px" >模板类型</th>
									<th data-column-id="FORM_AREA" data-width="110px">分组</th>
								</c:if>

                                <c:if test="${pd.searchType=='formModelStepCheckup'}"><!-- 表单步骤列表 -->
                                    <th data-column-id="MODEL_STEP_LEVEL" data-width="120px">步骤层级</th>
                                    <th data-column-id="MODEL_STEP_NAME" data-width="120px">步骤名称</th>
                                    <th data-column-id="FORM_DISPLAY_NAME" data-width="120px">模板名称</th>
                                </c:if>

                                <c:if test="${pd.searchType=='findFormWorkByEmpcode'}"><!-- 表单列表 -->
                                    <th data-column-id="WORK_NO" data-width="120px">任务编号</th>
                                    <th data-column-id="TASK_NAME" >名称</th>
                                    <th data-column-id="CREATE_EMP_NAME" data-width="120px">发起人</th>
                                </c:if>
								
							</tr>
						</thead>
					</table>
					
				</div>
			</div>
		</div><!--/.fluid-container#main-container-->
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
	
		<script type="text/javascript">
			//判断是否有页码传入
			var currentPage = ('${pd.currentPage}' == '') ? 0 : '${pd.currentPage}';	
		
			$(function() {
				var nowDate = new Date();
				//初始化表格
        		$("#info_grid").bootgrid({
        			navigation:2,
					ajax: true,
					url:"${pd.searchUrl}",
        			post: function(){
        				var postData = new Object();
    					if(currentPage>1){
    						postData.currentPage = currentPage;
    					}
    					//如果是查询预算占用表单列表
    					if('${pd.searchType}'=='budgetForm'){
    						postData.relateYear = '${pd.relateYear}';
        					postData.costItemCode = '${pd.costItemCode}';
        					postData.costDeptCode = '${pd.costDeptCode}';
    					}else if('${pd.searchType}'=='formModelStepNext'    //表单转交规则列表
                            || '${pd.searchType}'=='formModelStepCheckup'   //表单步骤列表（按照会审人员查询）
                            || '${pd.searchType}'=='findFormWorkByEmpcode'  //查询当前承接的以及后续有可能承接的
                        ){
                            postData.chooseEmpCode = $("#createEmpCode").val();
                        }
    					
    					return postData;
                	},
					formatters:{
						name: function(column, row){
							//名称
							var name = '';
							if('${pd.searchType}'=='budgetForm'){//预算占用的表单列表
								name = row.TASK_NAME;
							}
							var str = '<span title="' + name + '" >' + name + '</span>';
							return str;
						},
						relateMonth: function(column, row){
							return row.RELATE_YEAR + '-' + row.RELATE_MONTH;
						}
					}
				}).on("loaded.rs.jquery.bootgrid",function(e){
					currentPage = 0;//加载后重置之前传入的页码
					
				});
			});
			
			//回车绑定查询功能
			$(document).keyup(function(event) {
				if (event.keyCode == 13) {
					
	                searchInfo();
				}
			});
			
			//重置查询
			function emptySearch(){
				$("#searchInfoForm")[0].reset(); 
				searchInfo();
	        }
			
			//检索
			function searchInfo(){
				$("#info_grid").bootgrid("search", {
					"name": $("#name").val()
				});
			}
			
			//选择后，保存id
			function selecItem(id){
				$("#selectedFormWorkAmount").val(1);
				$("#selectedIds").val(id);
				top.Dialog.close();
			}
			
			//多选
			function saveSelectedRow(){
  				var selectedIds = '',
  				//选择的行
  				selectedRows = $("#info_grid").bootgrid("getSelectedRows"),
  				//获取所有的行
				rows = $("#info_grid").bootgrid("getCurrentRows");
  				
				if(selectedRows.length==0){
					top.Dialog.alert('请选择关联的数据行！');
					return;
				}
  				//循环选择的行
  				var rowCount = selectedRows.length;
				for(var i=0; i<rowCount; i++ ){
					for(var j=0; j<rows.length; j++){
						if(rows[j].ID==selectedRows[i]){
							selectedIds += rows[j].ID + ',';
						
							break;
						}
					}
				}

				//重置选择的表单
  				$("#info_grid").bootgrid("deselect", selectedRows);
				
  				selectedIds = selectedIds.substr(0, selectedIds.length-1);
  				//保存选择的行数据
				$("#selectedIds").val(selectedIds);
				top.Dialog.close();
			}

            //显示部门人员选择页面
            function deptAndEmp(){
                var url = '';
                url += '<%=basePath%>/dept/deptAndEmp.do?EMP_ID=1&STATUS=2';
                var diag = new top.Dialog();
                diag.Drag=true;
                diag.Title ="部门人员选择";
                diag.URL = url;
                diag.Width = 860;
                diag.Height = 445;
                diag.ShowOkButton = true;
                diag.ShowCancelButton = false;
                diag.OKEvent = function(){
                    //获取选择的人员
                    var empIds = diag.innerFrame.contentWindow.document.getElementById('EMP_ID').value;
                    var empCodes = diag.innerFrame.contentWindow.document.getElementById('EMP_CODE').value;
                    var empNames = diag.innerFrame.contentWindow.document.getElementById('EMP_NAME').value;
                    //设置选择的信息
                    $("#createEmpName").val(empNames);
                    $("#createEmpCode").val(empCodes);

                    diag.close();
                }
                diag.show();
            }
		</script>
	</body>
</html>
