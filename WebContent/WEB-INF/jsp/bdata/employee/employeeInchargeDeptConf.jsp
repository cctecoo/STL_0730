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
		<link href="static/css/style.css" rel="stylesheet" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/css/chosen.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>

		
		<style>
			#zhongxin td{height:40px;}
			#zhongxin td label{text-align:right; margin-right:10px;}
			#zx td label{text-align:left; margin-right:0px;} 
			.mask{margin-top:50px; height:100%; width:100%; position:fixed; _position:absolute; 
				top:0; z-index:1000; background-color: white; opacity:0.3;} 
			.opacity{  opacity:0.3; filter: alpha(opacity=30); background-color:#000; } 
		</style>
	</head>
	<body>
	
	<div id="loadDiv" class="center mask" style="display:none"><br/><br/><br/><br/><br/>
		<img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">操作中...</h4>
	</div>
	
	<form action="employee/saveInchargeDept.do" name="form" id="form" method="post">
		<div id="zhongxin">
			<table style="width:80%; margin:0 auto;">
				<tr>
					<td><label>员工：</label></td>
					<td>
						${pd.empName}
						<input type="hidden" name="empCode" value="${pd.empCode }" /> 
					</td>
				</tr>
				<tr>
					<td><label>分管部门：</label></td>
					<td>
						<input type="text" id="relateDeptNames" name="relateDeptNames" autocomplete="off" 
								   value="${inChargeDpetNames }" onclick="showDeptTree(this)" onkeydown="return false;"/>
						<input type="hidden" id="relateDeptIds" name="relateDeptIds" value="${inChargeDeptIds}"/>
						<input type="hidden" id="relateDeptCodes" name="relateDeptCodes" value="${inChargeDeptCodes }"/>
						<div id="deptTreePanel" style="background-color:white;z-index: 1000;">
							<ul id="deptTree" class="tree"></ul>
						</div>
					</td>
				</tr>
				
		        <tr>
		    		<td colspan="2" style="text-align: center;">
		    		<c:if test="${empty type || type!='view' }">
		    			<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
		    		</c:if>
					
					<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
				</td>
				</tr>
    
			</table>
		</div>
	</form>
	
	
	<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
	<script src="static/js/bootstrap.min.js"></script>
	
	<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
	<script type="text/javascript" src="static/deptTree/deptTree.js"></script>
	
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<script type="text/javascript" src="static/js/jquery-form.js"></script>

	<script type="text/javascript">
		//部门选取控件
		$(function() {
			var setting = {
				checkable: true,
				checkType : { "Y": "", "N": "" },
				callback : {
                    click : function(){
                        deptNodeClick();
                        /*
                        var dept = deptTree.getSelectedNode();//获取选中的部门
                        var depts = deptTree.getCheckedNodes();//获取选中的部门
                        searchEmp(dept.ID);//查询对应部门的人员列表
                        $("#deptCode").val(dept.DEPT_CODE);//设置选择的部门
                        */
                    }
                }
			};
			
			$("#deptTree").deptTree(setting, ${deptTreeNodes},200, 218);
		});
		
		//显示提示信息
		function showTips(obj, msg){
			$(obj).tips({
				msg: msg,
				side:3,
				bg:'#AE81FF',
				time:2
			})
		}

		//保存
		function save(){
			$("#loadDiv").show();
			//检查产线名称是否存在重复
			$("#form").ajaxSubmit({
				success: function(data){
					$("#loadDiv").hide();
					if('success'==data){
						top.Dialog.close();
					}else{
						top.Dialog.alert('后台出错，请联系管理员');
					}
				},
				error:function(){
					$("#loadDiv").hide();
					top.Dialog.alert('后台出错，请联系管理员');
				}
			});
		}
	</script>
	
	</body>
</html>