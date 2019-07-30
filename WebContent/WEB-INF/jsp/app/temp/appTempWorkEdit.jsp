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

		<title>临时任务编辑</title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<link rel="stylesheet" href="static/css/app-style.css" />
		<link rel="stylesheet" href="static/select2/select2.min.css" />
		<!-- 引入 -->
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="static/js/jquery-form.js"></script>
		
		<style>
			#zhongxin td{height:35px;}
		    #zhongxin td label{text-align:right;}
			body {
				background: #f4f4f4;
			}
			
			.keytask table tr td {
				line-height: 1.3
			}
			 /*设置自适应框样式*/
			.test_box {
				width: 90%;
				min-height: 22px;
			    _height: 120px;
			    padding: 4px 6px; 
			    outline: 0; 
			    border: 1px solid #d5d5d5; 
			    font-size: 12px; 
			    word-wrap: break-word;
			    overflow-x: hidden;
			    overflow-y: auto;
			    _overflow-y: visible;
			}
		</style>


		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
		<script src="static/select2/select2.min.js"></script>
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
					<!-- 加载Mobile文件 -->
   		<script src="plugins/appDate/js/mobiscroll.core.js"></script>
    	<script src="plugins/appDate/js/mobiscroll.frame.js"></script>
    	<script src="plugins/appDate/js/mobiscroll.scroller.js"></script>
		<script src="plugins/appDate/js/mobiscroll.util.datetime.js"></script>
    	<script src="plugins/appDate/js/mobiscroll.datetimebase.js"></script>
    	<script src="plugins/appDate/js/mobiscroll.datetime.js"></script>
    	<script src="plugins/appDate/js/mobiscroll.frame.android.js"></script>
    	<script src="plugins/appDate/js/i18n/mobiscroll.i18n.zh.js"></script>

   		 <link href="plugins/appDate/css/mobiscroll.frame.css" rel="stylesheet" type="text/css" />
    	 <link href="plugins/appDate/css/mobiscroll.frame.android.css" rel="stylesheet" type="text/css" />
    	 <link href="plugins/appDate/css/mobiscroll.scroller.css" rel="stylesheet" type="text/css" />
    	 <link href="plugins/appDate/css/mobiscroll.scroller.android.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			if("ontouchend" in document) document.write("<script src='static/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>

		<script type="text/javascript">
		$(function(){
			$("#DEPT_ID").select2();
			$("#MAIN_EMP_ID").select2();
			$("#CHECK_PERSON").select2();
			// 初始化日期框插件内容
	    	$('#START_TIME').mobiscroll().datetime({
	            theme: 'android',
	            mode: 'scroller', 
	            display: 'modal',
	            lang: 'zh',
	            dateFormat:'yyyy-mm-dd',
	            buttons:['set', 'cancel', 'clear']
	        });
	        $('#END_TIME').mobiscroll().datetime({
	            theme: 'android',
	            mode: 'scroller', 
	            display: 'modal',
	            lang: 'zh',
	            dateFormat:'yyyy-mm-dd',
	            buttons:['set', 'cancel', 'clear']
	        });
	        //初始化页面评价人
			if("0" == $("#NEED_CHECK").val()){
				$("#checkContainer").hide();
			} else {
				$("#checkContainer").show();
				chkflag = 1;
			}
			$("#NEED_CHECK").change(function(){
				var chkflag = 0 ;
				if("0" == $("#NEED_CHECK").val())
				{
					$("#checkContainer").hide();
				} else {
					$("#checkContainer").show();
					chkflag = 1;
				}
			});
			appendEmpTr(${pd.DEPT_ID}, ${pd.MAIN_EMP_ID});
		});
		
		//任务承接部门的负责人
		function appendEmpTr(deptId, taskEmpId){
			$("#empTr").empty();
            $("#APPROVE_EMP_CODE").val("");
			//普通临时任务，选择了其它部门时或者是普通员工下达任务时显示
            if((deptId!='${pd.userDeptId}' || '${reqPd.count}'=='0') && '${reqPd.isService}'!='1' && '${reqPd.superior}'!='Y' ){
            	var deptLeaderStr = '<td><label><span style="color: red;">*</span>部门审批：</label></td>' + 
					'<td><input value="" style="width:90%;" type="text" id="APPROVE_EMP_NAME" name="APPROVE_EMP_NAME" readonly="readonly" /></td>';
				$("#empTr").append(deptLeaderStr);
            	//获取选择的部门负责人
            	$.ajax({
					//app_temp/findDeptLeader.do?deptId=' + deptId,
					url: '<%=basePath%>app_temp/findEmpLeader.do?empId=' + taskEmpId,
					type: "post",
					success: function(data){
						if("error"==data){
							alert("后台出错，请联系管理员！");
						}else if("nodata"==data){
							$("#APPROVE_EMP_NAME").focus();
							showTips("#APPROVE_EMP_NAME","没有获取到审核人，请联系管理员配置！");
						}else if(data.indexOf(",")>0){
							$("#APPROVE_EMP_NAME").val(data.split(",")[1]);
							$("#APPROVE_EMP_CODE").val(data.split(",")[0]);
						}
					}
				});
            }
		}	
		
		//下载文件
        function loadFile(fileName){
            var action = '<%=basePath%>app_temp/checkFile.do';
            var time = new Date().getTime();
            $.ajax({
                type: "get",
                dataType:"text",
                data:{"fileName": fileName, "time": time},
                url: action,
                success: function(data){
                    if(data==""){
                        alert("文件不存在！");
                        return;
                    }
                    window.location.href = '<%=basePath%>app_temp/loadFile.do?fileName=' + fileName + "&time=" + time;
                }
            });
        }
        
        function showTips(id, msg){
			$(id).tips({
				'msg':msg,
				bg:'#AE81FF',
				side:3,
				time:2
			});
		}
		
      	//检查长度是否超出
   		function checkVal(divId, inputId, length, setVal){
   			var val = $(divId).text();
   			if(val.length>length){
   				$(divId).tips({
   					side:3,
   		            msg:'长度不能超过' + length + '，请重新填写!',
   		            bg:'#AE81FF',
   		            time:1
   		        });
   				$(divId).focus();
   			}else if(setVal){
   				$(inputId).attr("value", val);
   			}
   			return val.length>length;
   		}
      	
   		//显示提示信息
		function showTips(id, msg){
			$(id).tips({
				'msg':msg,
				bg:'#AE81FF',
				side:3,
				time:2
			});
		}
        
		function checkCode(){
			//检查说明输入的字符是否过长
			if(checkVal('#taskNameDiv', '#TASK_NAME', 100, true)){
				return;
			}
			if(checkVal('#taskContectDiv', '#TASK_CONTECT', 500, true)){
				return;
			}
			if(checkVal('#completionDiv', '#COMPLETION', 500, true)){
				return;
			}
			
			if($("#TASK_NAME").val()==""){
				$("#TASK_NAME").focus();
				showTips("#TASK_NAME","任务名称不能为空！");
				return false;
			}
			
			if($("#START_TIME").val()==""){
				$("#START_TIME").focus();
				showTips("#START_TIME","开始时间不能为空！");
				return false;
			}
			
			if($("#END_TIME").val()==""){
				$("#END_TIME").focus();
				showTips("#END_TIME","完成时间不能为空！");
				return false;
			}
			
			if($("#COMPLETION").val()==""){
				$("#COMPLETION").focus();
				showTips("#COMPLETION","完成标准不能为空！");
				return false;
			}
			
			if($("#DEPT_ID").val()==""){
				$("#DEPT_ID").focus();
				showTips("#DEPT_ID","责任部门不能为空！");
				return false;
			}
			
		/* 	var val2 =  $("#DEPT_ID").find("option:selected").text();
			$("#DEPT_NAME").val(val2);	 */
			if($("#MAIN_EMP_ID").val()=="" || $("#MAIN_EMP_ID").val()==null){
				$("#MAIN_EMP_ID").focus();
				showTips("#MAIN_EMP_ID","责任人不能为空！");
				return false;
			}
			
			//检查审批人
			if($("#APPROVE_EMP_NAME")!=null && $("#APPROVE_EMP_NAME").val()==""){
				$("#APPROVE_EMP_NAME").focus();
				showTips("#APPROVE_EMP_NAME","部门审批人不能为空！");
				return false;
			}
			
		/* 	var val3 =  $("#MAIN_EMP_ID").find("option:selected").text();
			$("#MAIN_EMP_NAME").val(val3); */
		
			if($("#NEED_CHECK").val()==""){
				$("#NEED_CHECK").focus();
				showTips("#NEED_CHECK","是否评价不能为空！");
				return false;
			}
			
			if($("#NEED_CHECK").val()=="1"){
				if($("#CHECK_PERSON").val()==""){
					$("#CHECK_PERSON").focus();
					showTips("#CHECK_PERSON","评价人不能为空！");
					return false;
				}
			} else {
				$("#CHECK_PERSON").val("");
			}
			
			var id = document.getElementById("id").value;
			save();
		}
		
		//保存
		function save(){
			if("0" == $("#NEED_CHECK").val()){
				$("#CHECK_PERSON").val("");
			}
			var options = {
	            success: function(data){
	                alert("保存成功");
	                var url = '<%=basePath %>app_temp/goTemp.do?&year=${year}&KEYW=${KEYW}&KEcurrentPageYW=${currentPage}';
	                if('${isService}'=='1'){
	                   	url += '&isService=1'
	                }
					window.location.href = url;
	            },
	            error: function(data){
	                alert("保存出错");
	            }
	        };
	        $("#Form").ajaxSubmit(options);
		}
		
		//根据部门查询人员
		function queryEmp(){
			//初始化任务
			var url = "app_temp/queryEmp.do?isService=${pd.isService}";
			var DEPT_ID = $("#DEPT_ID").val();
			//appendEmpTr(DEPT_ID.split('@')[0], );
			$.ajax({
				type: "POST",
				url: url,
				data: {"DEPT_ID":DEPT_ID},
				success: function(data){
					var obj = eval('(' + data + ')');
					$("#MAIN_EMP_ID").empty();
					$("#MAIN_EMP_ID").append('<option value="@">请选择</option>');
					$.each(obj.empList, function(i, emp){
						$("#MAIN_EMP_ID").append('<option value='+emp.ID+'@'+emp.EMP_NAME+'>'+emp.EMP_NAME+'</option>');
					});
				}
			});
		}
		
		//查询任务承接人的上级领导
		function queryEmpLeader(){
			var DEPT_ID = $("#DEPT_ID").val();
			var EMP_ID = $("#MAIN_EMP_ID").val();
			appendEmpTr(DEPT_ID.split('@')[0], EMP_ID.split('@')[0])
		}
		</script>
	</head>
<body>
	<div class="web_title">
<!-- 		<div class="back" style="top:5px">
			<a onclick="window.history.go(-1)">
			<img src="static/app/images/left.png" /></a>
		</div> -->
		<c:if test="${msg == 'edit'}">
		临时工作编辑
		</c:if>
		<c:if test="${msg == 'view'}">
		临时工作查看
		</c:if>
		
	</div>
		<form action="<%=basePath%>app_temp/edit.do" name="Form" id="Form" method="post">
			<input type="hidden" name="attachDeptName" id="attachDeptName" />
			<input type="hidden" name="id" id="id" value="${pd.ID}" />
			<input type="hidden" name="TASK_TYPE1" id="TASK_TYPE1" value="${pd.TASK_TYPE}" />
			<input type="hidden" value="${target.ID}" id="TARGET_ID" name="TARGET_ID">
        	<input type="hidden" value="${target.TARGET_TYPE}" id="PATH_TYPE" name="PATH_TYPE">
        	<input type="hidden" value="${target.TARGET_CODE}" id="TARGET_CODE" name="TARGET_CODE">
        	<input type="hidden" id="CYCLE" name="CYCLE" value="${path.CYCLE}">
        	<input type="hidden" id="CREATE_USER" name="CREATE_USER" value="${path.CREATE_USER}">
        	<input type="hidden" id="CREATE_TIME" name="CREATE_TIME" value="${path.CREATE_TIME}">
        	<input type="hidden" id="STATUS" name="STATUS" value="${path.STATUS}">
        	<input type="hidden" id="TARGET_DEPT_ID" name="TARGET_DEPT_ID" value="${path.DEPT_ID}">
        	<input type="hidden" id="TARGET_EMP_ID" name="TARGET_EMP_ID"value="${path.EMP_ID}">
        	<input value="" type="hidden" id="APPROVE_EMP_CODE" name="APPROVE_EMP_CODE" readonly="readonly" />
			<div id="zhongxin" style="width:98%; margin:0 auto; ">
			<c:if test="${msg == 'edit'}">
			<table style="margin: 10px auto; width:98%; ">
				<tr>
					<td style="width: 80px"><label><span style="color: red;">*</span>任务编号：</label></td>
					<td>
						<input type="text" name="TASK_CODE" id="TASK_CODE" placeholder="这里输入任务编号" title="任务编号" 
							value="${pd.TASK_CODE}" readonly="readonly" style="width:90%"/>
					</td>
				</tr>
				<tr>
					<td><label><span style="color: red;">*</span>任务名称：</label></td>
					<td>
						<input type="hidden" name="TASK_NAME" id="TASK_NAME" placeholder="这里输入任务名称" title="任务名称" value="${pd.TASK_NAME}"/>
						<div id="taskNameDiv" class="test_box" contenteditable="true" 
							onkeyup="checkVal('#taskNameDiv', '#TASK_NAME', 100, false)">${pd.TASK_NAME}</div>
					</td>
				</tr>
				<tr>
					<td><label>任务描述：</label></td>
					<td>
						<input type="hidden" id="TASK_CONTECT" name="TASK_CONTECT" value="${pd.TASK_CONTECT}" />
						<div id="taskContectDiv" class="test_box" contenteditable="true" 
							onkeyup="checkVal('#taskContectDiv', '#TASK_CONTECT', 500, false)">${pd.TASK_CONTECT}</div>
					</td>
				</tr>
				
				<tr>
				<td><label><span style="color: red;">*</span>开始时间：</label></td>
				<td>
					<input type="text" name="START_TIME" id="START_TIME" style="width:90%"
						value="${pd.START_TIME}"  data-date-format="yyyy-mm-dd hh:ii" 
						placeholder="开始时间" >
				</td>
				</tr>
				
				<tr>
				<td><label><span style="color: red;">*</span>结束时间：</label></td>
					<td><input type="text" name="END_TIME" id="END_TIME" style="width:90%"
							value="${pd.END_TIME}"  data-date-format="yyyy-mm-dd hh:ii" 
							placeholder="结束时间" >
					</td>
				</tr>
				
				<tr>
					<td><label><span style="color: red;">*</span>完成标准：</label></td>
					<td>
						<input type="hidden" id="COMPLETION" name="COMPLETION" value="${pd.COMPLETION}" />
						<div id="completionDiv" class="test_box" contenteditable="true" 
							onkeyup="checkVal('#completionDiv', '#COMPLETION', 500, false)">${pd.COMPLETION}</div>
					</td>
				</tr>
				
				<tr>
					<td><label><span style="color: red;">*</span>责任部门：</label></td>
					<td>	
						<select id="DEPT_ID" name="DEPT_ID" onchange="queryEmp()" style="width:95%;">
							<c:forEach items="${deptList}" var="dept" varStatus="vs">
								<option value="${dept.ID}@${dept.DEPT_NAME}" <c:if test="${dept.ID == pd.DEPT_ID}">selected</c:if>>
									${dept.DEPT_NAME}
								</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				
				<tr>
					<td><label><span style="color: red;">*</span>责任人：</label></td>
					<td>
					  <select id="MAIN_EMP_ID" name="MAIN_EMP_ID" style="width:95%;" onchange="queryEmpLeader()">
					  	<c:forEach items="${empList}" var="emp" varStatus="vs">
							<option value="${emp.ID}@${emp.EMP_NAME}" <c:if test="${emp.ID == pd.MAIN_EMP_ID}">selected</c:if>>
								${emp.EMP_NAME}
							</option>
						</c:forEach>
					  </select>
					</td>
				</tr>
				<tr id="empTr"></tr>
				<tr>
					<td><label><span style="color: red;">*</span>是否评价：</label></td>
					<td>
						<select  name="NEED_CHECK" id="NEED_CHECK" data-placeholder="请选择是否评价" style="width:95%">
						<option value="">请选择是否评价</option> 
						<option value="0"  <c:if test="${0 == pd.NEED_CHECK}">selected</c:if>>否</option> 
						<option value="1"  <c:if test="${1 == pd.NEED_CHECK}">selected</c:if>>是</option> 
						</select>
					</td>
				</tr>
				<tr id="checkContainer">
					<td><label>评价人：</label></td>
					<td>
					  <select id="CHECK_PERSON" name="CHECK_PERSON" style="width:95%;">
					  	<c:forEach items="${allEmpList}" var="emp" varStatus="vs">
							<option value="${emp.ID}" <c:if test="${emp.ID == pd.CHECK_PERSON}">selected</c:if>>
								${emp.EMP_NAME}
							</option>
						</c:forEach>
					  </select>
					  
					</td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: center;">
						<a class="btn btn-mini btn-primary" onclick="checkCode();">确定</a>
					</td>
				</tr>
			</table>
			</c:if>
			<c:if test="${msg == 'view'}">
			<table style="margin: 10px auto; width:98%; ">
				<tr>
					<td style="width: 25%;"><label>任务编号：</label></td>
					<td>${pd.TASK_CODE }</td>
				</tr>
				<tr>
					<td><label>任务名称：</label></td>
					<td>${pd.TASK_NAME }</td>
				</tr>
				<tr>
				<td colspan="2" style="text-align:center;">${pd.START_TIME} 至 ${pd.END_TIME}</td>
				</tr>
				
				<tr>
					<td><label>完成标准：</label></td>
					<td>${pd.COMPLETION}</td>
				</tr>
				<tr>
					<td><label>任务描述：</label></td>
					<td>${pd.TASK_CONTECT }</td>
				</tr>
				<tr>
					<td><label>责任人：</label></td>
					<td>${pd.MAIN_EMP_NAME } ${pd.DEPT_NAME }</td>
				</tr>
				<!-- 
				<tr>
					<td><label>是否评价：</label></td>
					<td>
						<c:if test="${0 == pd.NEED_CHECK}">否</c:if>
						<c:if test="${1 == pd.NEED_CHECK}">是</c:if>
					</td>
				</tr>
				 -->
				
				<c:if test="${1 == pd.NEED_CHECK}">
				<tr>
					<td><label>评价人：</label></td>
					<td>
					${pd.CHECK_NAME }		  
					</td>
				</tr>
				</c:if>
				<tr>
					<td><label>附件：</label></td>
					<td>
					<c:if test="${not empty fileList }">
						<c:forEach items="${fileList }" var="file" varStatus="vs">
						<a style="cursor:pointer;color: red;" onclick="loadFile('${file.SERVER_FILENAME }')">${file.FILENAME }</a><br>
						</c:forEach>
					</c:if>
					</td>
				</tr>
			</table>
			</c:if>
			
			</div>
			<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">提交中...</h4></div>
	
			<div>
				<%@include file="../footer.jsp"%>
			</div>

		</form>
	</body>
</html>