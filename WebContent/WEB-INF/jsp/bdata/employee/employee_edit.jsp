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
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
    	<script src="static/js/ajaxfileupload.js"></script>
		
		<style>
		input[type="checkbox"],input[type="radio"] {
			opacity:1 ;
			position: static;
			height:25px;
			margin-bottom:10px;
		}
		#zhongxin td{height:40px;}
	#zhongxin td label{text-align:right; margin-right:10px;}
	#zx td label{text-align:left; margin-right:0px;} 
		</style>
		<script type="text/javascript">

		</script>
	</head>
<body>
	<fmt:requestEncoding value="UTF-8" />
	<form action="employee/${msg}.do" name="employeeForm" id="employeeForm" method="post">
		<input type="hidden" name="flag" id="flag" value="${msg }" title="修改页标志" />
		<input type="hidden" name="ATTACH_KPI_MODEL" id="ATTACH_KPI_MODEL" value ="${emp.ATTACH_KPI_MODEL}"/>
		<input type="hidden" name="kpiIndexTab" id="kpiIndexTab" value =""/>
		<input type="hidden" name="editFlag" id="editFlag" value="${editFlag}" title="新增修改成功标志" />
		<input type="hidden" name="ID" id="id" value="${emp.ID }" title="员工主键ID" />
		<input type="hidden" id="EMP_POSITION_CODE" name="EMP_POSITION_CODE" value="0">
		<div id="zhongxin">
			<table style="margin-left: 40px;">
				<tr>
					<td style="width:110px">
						<label><font color="red">*</font>员工编号：</label>
					</td>
					<td>
						<input type="text" name="EMP_CODE" id="emp_code" value="${emp.EMP_CODE }"
							<c:if test="${not empty emp}">readonly</c:if>
							maxlength="32" placeholder="员工编号" title="员工编号"/>
					</td>
					<td style="width:110px">
						<label><font color="red">*</font>员工姓名：</label>
					</td>
					<td>
						<input type="text" name="EMP_NAME" id="emp_name" value="${emp.EMP_NAME }" maxlength="32" placeholder="姓名" />
					</td>
				</tr>
				<tr>
					<td><label><font color="red">*</font>员工部门：</label></td>
					<td>
						<input type="text" id="EMP_DEPARTMENT_NAME" name="EMP_DEPARTMENT_NAME" autocomplete="off" 
								   value="${emp.EMP_DEPARTMENT_NAME }" onclick="showDeptTree(this)" onkeydown="return false;"/>
						<input type="hidden" id="EMP_DEPARTMENT_ID" name="EMP_DEPARTMENT_ID" value="${emp.EMP_DEPARTMENT_ID }"/>
						<div id="deptTreePanel" style="background-color:white;z-index: 1000;">
							<ul id="deptTree" class="tree"></ul>
						</div>
					</td>
					<td><label><font color="red">*</font>员工岗位：</label></td>
					<td>
						<select id="EMP_GRADE_ID" name="EMP_GRADE_ID" onchange="getLeaderEmp();">
							<option value=""></option>
							<c:forEach items="${levelList }" var="level">
								<option attachKpiModelId="${level.ATTACH_KPI_MODEL}"
										jobRank="${level.JOB_RANK }" value="${level.ID }"
											<c:if test="${emp.EMP_GRADE_ID == level.ID}">selected</c:if> >
									${level.GRADE_NAME }
								</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td><label>上级领导：</label></td>
					<td>
						<select id="LEADER_EMPCODE" name="LEADER_EMPCODE" class="chzn-select">
							<option value="">请选择</option>
						</select>
					</td>
					<td><label><font color="red">*</font>员工性别：</label></td>
					<td>
						<c:choose>
							<c:when test="${empty emp.ID }">
								<input type="radio" name="EMP_GENDER" value="1" checked="checked">男
								<input type="radio" name="EMP_GENDER" value="2" >女
							</c:when>
							<c:otherwise>
								<input type="radio" name="EMP_GENDER" value="1"<c:if test="${emp.EMP_GENDER == 1}">checked="checked"</c:if>>男
								<input type="radio" name="EMP_GENDER" value="2"<c:if test="${emp.EMP_GENDER == 2}">checked="checked"</c:if>>女
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td><label><font color="red">*</font>是否启用：</label></td>
					<td colspan="3">
						<c:choose>
							<c:when test="${empty emp.ID }">
								<input type="radio" name="ENABLED" value="1" checked="checked">是
								<input type="radio" name="ENABLED" value="0" >否
							</c:when>
							<c:otherwise>
								<input type="radio" name="ENABLED" value="1"<c:if test="${emp.ENABLED == 1}">checked="checked"</c:if>>是
								<input type="radio" name="ENABLED" value="0"<c:if test="${emp.ENABLED == 0}">checked="checked"</c:if>>否
							</c:otherwise>
						</c:choose>
						<span>未启用，则对应的用户不能登录系统</span>
					</td>
				</tr>
				<tr>
					<td><label><font color="red">*</font>展示工作：</label></td>
					<td colspan="3">
						<c:choose>
							<c:when test="${empty emp.ID }">
								<input type="radio" name="IS_SHOW_DEPT_WORK" value="Y" checked="checked">是
								<input type="radio" name="IS_SHOW_DEPT_WORK" value="N">否
							</c:when>
							<c:otherwise>
								<input type="radio" name="IS_SHOW_DEPT_WORK" value="Y"<c:if test="${emp.IS_SHOW_DEPT_WORK == 'Y'}">checked="checked"</c:if>>是
								<input type="radio" name="IS_SHOW_DEPT_WORK" value="N"<c:if test="${emp.IS_SHOW_DEPT_WORK == 'N'}">checked="checked"</c:if>>否
							</c:otherwise>
						</c:choose>
						<span>选择否，则看板中不能查看部门同事的工作</span>
					</td>
				</tr>
				
				<tr>
					<td><label>银行卡开户行：</label></td>
					<td>
						<input type="text" name="EMP_BANK_NAME"
							value="${emp.EMP_BANK_NAME }" maxlength="100" />
					</td>
					<td><label>银行卡号：</label></td>
					<td>
						<input type="text" name="EMP_BANK_NO" 
							value="${emp.EMP_BANK_NO }" maxlength="100"/>
					</td>
				</tr>
				<tr>
					<td><label>联系电话：</label></td>
					<td>
						<input type="text" name="EMP_PHONE" id="emp_phone" 
							value="${emp.EMP_PHONE }" maxlength="32" placeholder="联系电话" title="联系电话"/>
					</td>
					<td><label>员工邮箱：</label></td>
					<td>
						<input type="text" name="EMP_EMAIL" id="emp_email" 
							value="${emp.EMP_EMAIL }" maxlength="32" placeholder="员工邮箱" title="员工邮箱"/>
					</td>
				</tr>
				<tr>
					<td><label>其它联系电话：</label></td>
					<td>
						<input type="text" name="EMP_PHONE_2"
							value="${emp.EMP_PHONE_2 }" maxlength="32" />
					</td>
					<td><label>备注：</label></td>
					<td>
						<input type="text" name="EMP_REMARK" id="emp_remark"
							value="${emp.EMP_REMARK }" maxlength="32" placeholder="备注" title="备注"/>
					</td>
				</tr>
				<tr>
					<td><label>月度考核模板：</label></td>
					<td>
						${emp.ATTACH_KPI_MODEL_NAME }
						</td>
					<td><label>年度考核模板：</label></td>
					<td>${emp.ATTACH_YEAR_KPI_MODEL_NAME }</td>
				</tr>
		
		        <tr>
		    		<td colspan="4" style="text-align: center;">
						<a class="btn btn-mini btn-primary" onclick="checkEmp(this);">保存</a>&nbsp;
						<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
					</td>
				</tr>
    
			</table>
		</div>
	</form>
	<!-- 引入 -->
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
		<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
		
		<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
		<script type="text/javascript" src="static/deptTree/deptTree.js"></script>
	
	<script type="text/javascript">
			//部门选取控件
			$(function() {
				var setting = {
					checkable: false,
					checkType : { "Y": "", "N": "" },
					callback : {
	                    click : function(){
	                        deptNodeClick();
	                        getLevel();
	                    }
	                }
				};
				$.post('dept/findDeptTreeNodes.do', function(data){
					depts = data;
					$("#deptTree").deptTree(setting, depts.rows,200, 218);
				});
				//$("#deptTree").deptTree(setting, ${deptTreeNodes},200, 218);
				getLeaderEmp();
				$(".chzn-select").chosen({
					no_results_text: "没有匹配结果",
					disable_search: false,
					search_contains: true//模糊查询
				});
			});
			
			
			//根据所选部门查询员工岗位级别
			function getLevel(){
				var url = "<%=basePath%>/employee/findLevelByDeptId.do?deptId=" + $("#EMP_DEPARTMENT_ID").val();
				$.ajax({
					type: "POST",
					async:false,
					url: url,
					success:function (data){     //回调函数，result，返回值
						var obj = eval('(' + data + ')');
						var shtml = "<option value=''></option>";
						$.each(obj.list, function(i, list){
							shtml += "<option attachKpiModelId='" + list.ATTACH_KPI_MODEL + "' jobRank='" + list.JOB_RANK
								+ "' value='" +list.ID+ "' >"
								+ list.GRADE_NAME + "</option>";
						});
						
						//alert(shtml);
						$("#EMP_GRADE_ID").html(shtml);
					}
				});
			}
			
			//查询上级领导
			function getLeaderEmp(){
				//$("#LEADER_EMPCODE").empty();
				//选择岗位后，执行
				if($("#EMP_GRADE_ID").val()!=""){
				    //查询选择部门的上级领导
                    var jobRank = $("#EMP_GRADE_ID > option:selected").attr('jobRank');
					var url = '<%=basePath%>employee/findLeaderEmp.do?deptId=' + $("#EMP_DEPARTMENT_ID").val() + 
						'&jobRank=' + jobRank + '&empCode=';
					if($("#emp_code").val()==""){
						url += 'tes1';//没有员工编码时，随便传入一个，后台不使用
					}else{
						url += $("#emp_code").val();
					}
					$.ajax({
						type: "POST",
						async:false,
						url: url,
						success:function (data){
							var shtml = "<option value=''>请选择</option>";
							for(var i = 0; i < data.length; i++){
								shtml += "<option value='"+ data[i].EMP_CODE +"'>" + data[i].EMP_NAME + "</option>";
							}
							$("#LEADER_EMPCODE").html(shtml);
							//选择之前的上级领导
							$("#LEADER_EMPCODE").find("option[value='${emp.LEADER_EMPCODE}']").attr("selected",true);
							$("#LEADER_EMPCODE").trigger("chosen:updated");
						}
					});
				}
			}
						
			//员工新增验证
			function checkEmp(obj){
				if($("#emp_code").val() == ""){
					$("#emp_code").tips({
						side:3,
			            msg:'请输入员工编号',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#emp_code").focus();
					return false;
				}
				var nameCheck = /^[a-zA-Z\u4e00-\u9fa5\（\）\(\)]*$/;
				if($("#emp_name").val() == "" || !nameCheck.test($("#emp_name").val())){
					$("#emp_name").tips({
						side:3,
			            msg:'请正确输入员工姓名',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#emp_name").focus();
					return false;
				}
				if(typeof($("input:radio[name='EMP_GENDER']:checked").val()) == "undefined"){
					alert("请选择员工性别！");
					return false;
				}
				if($("#EMP_DEPARTMENT_NAME").val() == ""){
					$("#EMP_DEPARTMENT_NAME").tips({
						side:3,
			            msg:'请选择员工部门',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#EMP_DEPARTMENT_NAME").focus();
					return false;
				}
				if($("#EMP_GRADE_ID").val() == ""){
					$("#EMP_GRADE_ID").tips({
						side:3,
			            msg:'请选择员工岗位',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#EMP_GRADE_ID").focus();
					return false;
				}
				var phoneCheck = /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/;
				if($("#emp_phone").val() != ""){
					if(!phoneCheck.test($("#emp_phone").val())){
						$("#emp_phone").tips({
							side:3,
				            msg:'请正确输入电话',
				            bg:'#AE81FF',
				            time:2
				        });
						$("#emp_phone").focus();
						return false;
					}
				}
				var email = /^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$/;
				if($("#emp_email").val() != ""){
					if(!email.test($("#emp_email").val())){
						$("#emp_email").tips({
							side:3,
				            msg:'请正确输入员工邮箱',
				            bg:'#AE81FF',
				            time:2
				        });
						$("#emp_email").focus();
						return false;
					}
				}
				if(typeof($("input:radio[name='ENABLED']:checked").val()) == "undefined"){
					alert("请选择是否启用！");
					return false;
				}
				$(obj).hide();
				var url = "<%=basePath%>employee/checkEmployee.do?empCode=" +$('#emp_code').val()+ "&msg=" +$("#flag").val()+ "&id=" +$("#id").val();
				$.get(url, function(data){
					if(data == "true"){
						save();
					}else{
	                    alert("该员工编号已存在！");
	                    $("#emp_code").focus();
                        $(obj).show();
	                    return;
	                }
				},"text");
			}
			
			//保存
			function save(){
                //设置岗位关联的月度考核模板
                var attachKpiModelId = $("#EMP_GRADE_ID > option:selected").attr('attachKpiModelId');
                if(null == attachKpiModelId || '' == attachKpiModelId || 'undefined'==attachKpiModelId){
                    attachKpiModelId = 0;//岗位没有关联考核模板时，设置为0；
                }
                $("#ATTACH_KPI_MODEL").val(attachKpiModelId);

                //提交
                $("#employeeForm").submit();
			}
	</script>
	
</body>
</html>