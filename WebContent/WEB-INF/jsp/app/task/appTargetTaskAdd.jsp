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

		<title>新增日清</title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		
		
		<link rel="stylesheet" href="static/css/app-style.css" />
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/select2/select2.min.css" />
		
		<style>
			#zhongxin td{height:35px;}
		    #zhongxin td label{text-align:right; }
		    .ace-file-multiple label{width:94%; margin-top:4px; }
			body {
				background: #f4f4f4;
			}
			
			.keytask table tr td {
				line-height: 1.3
			}
			.ace-file-multiple label{}
			 /*设置自适应框样式*/
			.test_box {
				width: 220px;
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
			.ace-file-multiple label.selected span:after{
				display: inline-block;
			    white-space: normal;
			    text-align: left;
			    width: 90%;
			    padding: 0 10px;
			}
			.ace-file-multiple .remove{
				right:0px;
			}
			.icon-file{
				float:left;
			}
			.ace-file-multiple label:before{
				margin:0px;
			}
		</style>

		<!-- 引入 -->
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/jquery-form.js"></script>
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		
		<script src="static/select2/select2.min.js"></script>
		
		<script type="text/javascript">
			if("ontouchend" in document) document.write("<script src='static/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>

		<script type="text/javascript">	
			
		jQuery(function($) {
			$("#id-input-file-1").ace_file_input({
				style:'well',
				btn_choose:'选择',
				btn_change:'修改',
				no_icon:'icon-cloud-upload',
				droppable:true,
				onchange:null,
				thumbnail:'small',
				before_change:function(files, dropped) {
					
					return true;
				}
				
			}).on('change', function(){
				
			});
			$("#checkEmpCode").select2();
		});
		
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

		//保存
		function check(){
			if($("#checkEmpCode").val()==""){
	    		$("#checkEmpCode").tips({
					side:3,
		            msg:'请选择审核人！',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#checkEmpCode").focus();
				return false;
	    	}
			//保存选择的审核人姓名
			if($("#checkEmpCode option").size()>0){
				$("#checkEmpName").val($("#checkEmpCode option:selected").text());
			}
			//检查本次完成工作量
			var regNum =  /^(-)?\d+(\.\d{1,4})?$/;
			var dailyCountMsg = "";
			if($("#dailyCount").val() == "" || null == $("#dailyCount").val()){
				dailyCountMsg = "不能为空";
			}else if(!regNum.test($("#dailyCount").val())){
				dailyCountMsg = "只可填入数字，最多四位小数";
			}
			if(dailyCountMsg!=""){
				$("#dailyCount").tips({
					side:3,
		            msg:dailyCountMsg,
		            bg:'#AE81FF',
		            time:2
		        });
				$("#dailyCount").focus();
				return false;
			}
			//检查说明输入的字符是否过长
			if(checkVal('#divAnalysis', '#analysis', 255, true)){
				return;
			}
			if(checkVal('#divMeasure', '#measure', 255, true)){
				return;
			}
			//本次工作量小于计划量时，差异分析和关差措施不能为空
			if($("#dailyCount").val()<${pd.taskCount}){
				var analysisEmpty = $("#analysis").val()=="" || $("#analysis").val()==null;
				var measureEmpty = $("#measure").val()=="" || $("#measure").val()==null;
				if(analysisEmpty){
					$("#divAnalysis").tips({
						side:3,
			            msg:'请填写差异分析',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#divAnalysis").focus();
					return false;
				}else if(measureEmpty){
					$("#divMeasure").tips({
						side:3,
			            msg:'请填写关差措施',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#divMeasure").focus();
					return false;
				}
			}
			$("#zhongxin2").show();
			var options = {
				success: function(data){
					if("error"==data){
						alert("保存出错");
					}else if("success"==data){
						alert("保存成功");
					    $("#zhongxin2").hide();
					    var url = '<%=basePath%>app_task/listBusinessEmpTask.do?show=${pd.show}&loadType=${pd.loadType}&weekEmpTaskId=${pd.weekTaskId}';
						window.location.href = url;
					}
		  		},
			  	error: function(data){
			  		alert("保存出错");
			  	}
		  	};
			$("#Form").ajaxSubmit(options);
		}
		
		</script>
	</head>
<body>
	<div class="web_title">
<%-- 		<div class="back" style="top:5px">
			<a href="<%=basePath%>app_task/listBusinessEmpTask.do?show=${pd.show}&loadType=${pd.loadType}&weekEmpTaskId=${pd.weekTaskId}">
			<img src="static/app/images/left.png" /></a>
		</div> --%>
		新增日清
	</div>
		<form action="<%=basePath%>app_task/saveTargetTask.do" name="Form" id="Form" method="post"
			enctype="multipart/form-data">
			<input type="hidden" id="taskCount" value="${pd.taskCount }" />
			<input type="hidden" id="weekCount" name="weekCount" value="${pd.weekCount }" />
			<input type="hidden" name="weekTaskId" value="${pd.weekTaskId }" />
			<input type="hidden" name="endDate" value="${pd.endDate }" />
			<div id="zhongxin" style="width:98%; margin:0 auto; ">
			<table style="margin: 10px auto; width:98%; ">
				<tr>
					<td style="width:26%"><label>周任务量：</label></td>
					<td>
						<input type="text" 
							value="${pd.weekCount }(${task.UNIT_NAME })" readonly="readonly" style="width:90%" />
					</td>
				</tr>
				<tr>
					<td style="width:20%"><label>审核人：</label></td>
					<td style="width:70%">
						
						<c:choose>
							<c:when test="${empty task.CHECK_EMP_CODE }">
								<input type="hidden" id="checkEmpName" name="checkEmpName" value="${task.CHECK_EMP_NAMWE }" />
								<select class="chzn-select" id="checkEmpCode" name="checkEmpCode"
									style="width:96%; padding:4px 6px; height:30px">
									<option value="">请选择</option>
									<c:forEach items="${checkEmpList }" var="emp">
										<option value="${emp.EMP_CODE }" >${emp.EMP_NAME }</option>
									</c:forEach>
								</select>
							</c:when>
							<c:otherwise>
								<input type="text" id="checkEmpName" name="checkEmpName" value="${task.CHECK_EMP_NAME }" readonly="readonly"/>
								<input type="hidden" id="checkEmpCode" name="checkEmpCode" value="${task.CHECK_EMP_CODE }" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td><label>本次完成：</label></td>
					<td><input type="text" name="dailyCount" id="dailyCount" onchange="getCount()"
						placeholder="这里输入本次完成的工作量(${task.UNIT_NAME })" style="width:90%"/></td>
				</tr>
				
				<c:if test="${task.TARGET_TYPE == 'XSH' }">
	                <tr>
	                    <td><label>客户名称：</label></td>
	                    <td><input type="text" name="customName" id="customName" style="width:90%"/></td>
	                </tr>
                    <tr>
	                    <td><label>产品名称：</label></td>
	                    <td>
	                        <input type="text"  readonly="readonly" style="width:90%" value="${task.PRODUCT_NAME}"/>
	                    </td>
	                </tr>
	                <tr>
	                    <td><label>销售量(吨)：</label></td>
	                    <td>
	                    <input type="text" id="MONEY_COUNT" name="MONEY_COUNT" style="width:33%" onchange="getCount()"/>
	                	单价：
	                    <input type="text" name="price" id="price" readonly="readonly" style="width:30%"/></td>
	                </tr>
	            </c:if>
				
				<tr>
					<td><label>差异分析：</label></td>
					<td>
						<input type="hidden" name="analysis" id="analysis" placeholder="这里输入差异分析" />
						<div id="divAnalysis" class="test_box" contenteditable="true" 
							onkeyup="checkVal('#divAnalysis', '#analysis', 255, false)" style="width:90%"></div>
					</td>
				</tr>
				<tr>
					<td><label>关差措施：</label></td>
					<td>
						<input type="hidden" name="measure" id="measure" placeholder="这里输入关差措施" />
						<div id="divMeasure" class="test_box" contenteditable="true"
							onkeyup="checkVal('#divMeasure', '#measure', 255, false)" style="width:90%"></div>
					</td>
				</tr>
				<tr>
					<td><label>上传附件：</label></td>
					<td><input type="file" name="file" id="id-input-file-1" style="width:90%"/></td>
				</tr>
				
				<tr>
					<td colspan = "2" style="text-align: center;">
						<a class="btn btn-mini btn-primary" onclick="check();">保存</a>
					</td>
				</tr>
			</table>
			</div>
			<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">提交中...</h4></div>
	
			<div>
				<%@include file="../footer.jsp"%>
			</div>

		</form>
		<script type="text/javascript">
	        function getCount(){
	            var dailyCountVal = $("#dailyCount").val();
	            var moneyCountVal = $("#MONEY_COUNT").val();
	            if(moneyCountVal=='' || moneyCountVal==0){
	            	 $("#price").val('');
	            }else if((dailyCountVal / moneyCountVal) != "Infinity"){
	                $("#price").val(dailyCountVal / moneyCountVal);
	            }
	        }
	    </script>
	</body>
</html>