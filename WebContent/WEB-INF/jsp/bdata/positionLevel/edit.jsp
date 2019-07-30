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
		<%@ include file="../../system/admin/top.jsp"%> 
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/css/chosen.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		
		<link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
		<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
		<script type="text/javascript" src="static/deptTree/deptTree.js"></script>
		<style type="text/css">
			.chosen-results{
				height:50px;
			}
		</style>
		
<script type="text/javascript">
	top.changeui();
	//保存
	function save(){
		$("#form1").submit();
		$("#zhongxin").hide();
		$("#zhongxin2").show();
	}
	
	function checkCode(){
		if($("#gradeCode").val()==""){
			$("#gradeCode").tips({
				side:3,
	            msg:'请输入',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#gradeCode").focus();
			return false;
		}
		if($("#gradeName").val()==""){
			$("#gradeName").tips({
				side:3,
	            msg:'请输入',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#gradeName").focus();
			return false;
		}
		if($("#jobRank").val()==""){
			$("#jobRank").tips({
				side:3,
	            msg:'请输入',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#jobRank").focus();
			return false;
		}
		if($("#jobRank").val()<1){
			$("#jobRank").tips({
				side:3,
	            msg:'请输入大于0的数字',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#jobRank").focus();
			return false;
		}
		if($("#laborCost").val()==""){
			$("#laborCost").tips({
				side:3,
	            msg:'请输入',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#laborCost").focus();
			return false;
		}
		//var val =  $("#attachDeptId").find("option:selected").text();
		var val =  $("#attachDeptId").val();
		if(val==""){
			$("#attachDeptId").tips({
				side:3,
	            msg:'请选择',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#deptip").attr("hidden", false);
			return false;
		}else{
			$("#deptip").attr("hidden", true);
		}
		$("#attachDeptName").val(val);	
		//关联KPI模板赋值
		var selKPI = $("#attachKpiModelList").find("option:selected").val();
		$("#attachKpiModel").val(selKPI);
		
		var gradeCode = document.getElementById("gradeCode").value;
		var gradeName = document.getElementById("gradeName").value;
		var id = document.getElementById("id").value;
		//alert(icnum);
		top.jzts();

		var url = "<%=basePath%>/positionLevel/checkCode.do?gradeCode="+gradeCode+"&id="+id;
		$.get(url,function(data){
			if(data == "true"){
				$("#codetip").attr("hidden", true);
				save();
			}else{
				$("#codetip").attr("hidden", false);
				//$("#gradeCode").focus();
				//$("#gradeName").focus();
				$("#gradeCode").tips({
					side:3,
		            msg:'岗位编码已存在',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#gradeCode").focus();
				return false;
	        }
		},"text");
	}
	

	var setting = {
		checkable: false,
		checkType : { "Y": "", "N": "" }
	};
	
	function showJobBank(){
		top.Dialog.alert("岗位等级默认：15 ；<br>1-董事长/副董事长/总裁办主任；<br>2-总经理；3-副总经理（副总）；" +
			"4-部长；5-副部长；6-车间主任/车间副部长；7-车间副主任；8-主任；9-副主任；10-主管");
  	}
</script>
<style>
#zhongxin td{height:40px;}
	     #zhongxin td label{text-align:right; margin-right:10px;}
</style>
	</head>
<body>
		<form action="positionLevel/edit.do" name="form1" id="form1"  method="post">
			<input type="hidden" name="attachDeptName" id="attachDeptName" />
			<input type="hidden" name="attachKpiModel" id="attachKpiModel" />
			<input type="hidden" name="id" id="id" value="${pd.ID}" />
			<div id="zhongxin" align="center" style="margin-top:20px;">
			<table>
				<tr>
					<td><label><font style="color:red">*</font>岗位编码：</label></td>
					<td><input type="text" name="gradeCode" id="gradeCode" placeholder="这里输入岗位编码" title="岗位编码" value="${pd.GRADE_CODE}"/></td>
				</tr>
				<tr>
					<td><label><font style="color:red">*</font>岗位名称：</label></td>
					<td><input type="text" name="gradeName" id="gradeName" placeholder="这里输入岗位名称" title="岗位名称" value="${pd.GRADE_NAME}"/></td>
				</tr>
				<tr>
					<td><label><font style="color:red">*</font>岗位等级：</label></td>
					<td><input type="text" name="jobRank" id="jobRank" placeholder="这里输入岗位等级" title="岗位等级" value="${pd.JOB_RANK}" style="ime-mode:disabled" 
						onkeydown="if(event.keyCode==13)event.keyCode=9" onkeypress="if ((event.keyCode<48 || event.keyCode>57)) event.returnValue=false"/></td>
				</tr>
				
				<tr>
					<td><label><font style="color:red">*</font>所属部门：</label></td>
					<td>	
						<input onkeydown="return false;" autocomplete="off" id="attachDeptId" name="attachDeptId" onclick="showDeptTree(this)"
							 type="text" placeholder="点击选择所属部门" value="${pd.ATTACH_DEPT_NAME }"/>
						<input type="hidden" name="DEPT_ID" value="${pd.ATTACH_DEPT_ID}">
						
						<div id="deptTreePanel" style="background-color:white;z-index: 1000;">
							<ul id="deptTree" class="tree"></ul>
						</div>
						<!-- 
						<select name="attachDeptId" id="attachDeptId" 
						data-placeholder="请选择所属部门" style="vertical-align:top;" size="5" >
						<option value=""></option>
						<c:forEach items="${deptList}" var="dept">
							<option value="${dept.ID}" <c:if test="${dept.ID == pd.ATTACH_DEPT_ID }">selected</c:if>>${dept.DEPT_NAME }</option>
						</c:forEach>
						</select> -->
						<!-- <p id="deptip" class="tip" hidden="true"><span>提示：请选择所属部门</span></p>
						<p id="codetip" class="tip" hidden="true"><span>提示：编码重复,请重新输入</span></p> -->
					</td>
				</tr>
				
				<tr style="display:none">
					<td><label>*员工成本：</label></td>
					<td><input type="text" name="laborCost" id="laborCost" placeholder="这里输入员工成本" title="员工成本" value="${pd.LABOR_COST}"/
					onkeyup="changeNumber(this)" onafterpaste="this.value=this.value.replace(/\D/g,'')"></td>
				</tr>
				
				
				<tr>
					<td><label>月度考核模板：</label></td>
					<td>	
						<select class="chzn-select" name="attachKpiModelList" id="attachKpiModelList" 
							data-placeholder="请选择考核模板" style="vertical-align:top;">
						<option value="0"></option>
						<c:forEach items="${kpiList}" var="kpi">
							<c:if test="${kpi.MODEL_TYPE=='EMP_MONTH' }">
								<option value="${kpi.ID}" <c:if test="${kpi.ID == pd.ATTACH_KPI_MODEL }">selected</c:if>>${kpi.NAME }</option>
							</c:if>
						</c:forEach>
						</select>
					</td>
				</tr>
				
				<!-- 
				<tr>
					<td><label>年度考核模板：</label></td>
					<td>	
						<select class="chzn-select" name="attachYearKpiModel" id="attachYearKpiModel" 
							data-placeholder="请选择考核模板" style="vertical-align:top;">
						<option value="0"></option>
						<c:forEach items="${kpiList}" var="kpi">
							<c:if test="${kpi.MODEL_TYPE=='EMP_YEAR' }">
								<option value="${kpi.ID}" <c:if test="${kpi.ID == pd.ATTACH_YEAR_KPI_MODEL_ID }">selected</c:if>>${kpi.NAME }</option>
							</c:if>
						</c:forEach>
						</select>
					</td>
				</tr>
				 -->
				
				
				<tr>
					<td><label>岗位描述：</label></td>
					<td><input type="text" name="gradeDesc" id="gradeDesc" placeholder="这里输入岗位描述" title="描述" value="${pd.GRADE_DESC}"/></td>
				</tr>
			
				<tr>
					<td colspan="2" style="text-align: center;">
						<a class="btn btn-mini btn-info" onclick="showJobBank()">等级规则</a>
						<a class="btn btn-mini btn-primary" onclick="checkCode();">保存</a>
						<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
					</td>
				</tr>
			</table>
			</div>
		</form>
	
	<div id="zhongxin2" class="center" style="display:none"><img src="static/images/jzx.gif" style="width: 50px;" /><br/><h4 class="lighter block green"></h4></div>
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
		<script type="text/javascript">
$(function() {
	//单选框
	$(".chzn-select").chosen();
	$(".chzn-select").next().find(".chosen-results").css("height","75px");
	$(".chzn-select-deselect").chosen({allow_single_deselect:true});

	 $("#deptTree").deptTree(setting, ${deptTreeNodes},200, 220);			
});
	function changeNumber(objTxt){
		objTxt.value=objTxt.value.replace(/\D/g,'');
	}
</script>
</body>

</html>
