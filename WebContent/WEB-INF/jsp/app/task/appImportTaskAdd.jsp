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
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/select2/select2.min.css" />
		
		<link rel="stylesheet" href="static/css/app-style.css" />
		
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
			.ace-file-multiple{width:90%; margin:10px auto;}
			.ace-file-multiple label{ margin-top:4px; /*height:110px*/}
		</style>


	</head>
	<body style="margin-bottom:20px">
		<div class="web_title">
	<%-- 		<div class="back" style="top:5px">
				<a href="<%=basePath%>app_task/listCreativeEmpTask.do?show=${pd.show}&showDept=${pd.showDept}&loadType=${pd.loadType }&startDate=${pd.startDate }&endDate=${pd.endDate }&projectCode=${pd.projectCode }&eventId=${pd.projectEventId }">
				<img src="static/app/images/left.png" /></a>
			</div> --%>
			新增日清
		</div>
		<c:choose>
			<c:when test="${not empty splitList }">
				<span id="splitSpan" style="margin-bottom:4px;">选择完成的活动分解项：</span>
				<c:forEach items="${splitList }" var="split" varStatus="vs">
				    <div class="keytask" style="border-bottom: 0px; width:90%">
				    	<table style="">
				    		<tr>
			    				<td style="width:30%">名称：</td>
								<td name="splitName" style="width:60%"><span>${split.NAME }</span>
								</td>
				    		</tr>
				    		<tr>
			    				<td>进度分解：</td>
								<td name="percent"><span>${split.PERCENT_SPLIT }</span>
								</td>
				    		</tr>
				    		<!-- 
				    		<tr>
			    				<td style="width:70px">成本分解:</td>
								<td><span>${split.COST_SPLIT }</span>
								</td>
				    		</tr>
				    		 -->
				    		
				    		<tr>
			    				<td>备注：</td>
								<td><span>${split.DESCP }</span>
								</td>
								<td style="text-align: right;"><input name="finishBox" type="checkbox" value="${split.ID }" />
									<span class="lbl"></span>
								</td>
				    		</tr>
				    	</table>
				    </div>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<span>没有分解列表数据</span>
			</c:otherwise>
		</c:choose>
		<form action="<%=basePath%>app_task/saveImportTask.do" name="Form" id="Form" method="post"
			enctype="multipart/form-data" style="border-top:1px solid #ccc">
			<input type="hidden" id="taskCount" value="${pd.taskCount }" />
			<input type="hidden" name="projectEventId" value="${pd.projectEventId }" />
			<input type="hidden" name="endTime" value="${pd.endTime }" />
			<input type="hidden" id="finishPercent" name="finishPercent" />
			<input type="hidden" id="eventSplitIds" name="eventSplitIds" />
			<input type="hidden" id="splitNames" name="splitNames" />
			<input type="hidden" name="fileStr" id="fileStr" />
			
			<table id="dataTable" style="width: 98%; margin: 3px auto;">
				<tr>
					<td style="width:20%"><label>审核人：</label></td>
					<td style="width:70%">
						${taskApproveEmp.checkEmpName }
						<input type="hidden" id="checkEmpName" name="checkEmpName" value="${taskApproveEmp.checkEmpName }" />
						<input type="hidden" id="checkEmpCode" name="checkEmpCode" value="${taskApproveEmp.checkEmpCode }" />
						
					</td>
				</tr>
				<tr>
					<td><label>工作结果填报/备注：</label></td>
					<td>
						<input type="hidden" name="taskDesc" id="taskDesc" placeholder="这里输入" />
						<div id="divTaskDesc" class="test_box" contenteditable="true" style="width:86%"
							onkeyup="checkVal('#divTaskDesc', '#taskDesc', 1000, false)"></div>
					</td>
				</tr>
				<tr>
					<td><label>差异分析：</label></td>
					<td>
						<input type="hidden" name="analysis" id="analysis" placeholder="这里输入差异分析" />
						<div id="divAnalysis" class="test_box" contenteditable="true" style="width:86%"
							onkeyup="checkVal('#divAnalysis', '#analysis', 255, false)"></div>
					</td>
				</tr>
				<tr>
					<td><label>关差措施：</label></td>
					<td>
						<input type="hidden" name="measure" id="measure" placeholder="这里输入关差措施" />
						<div id="divMeasure" class="test_box" contenteditable="true" style="width:86%"
							onkeyup="checkVal('#divMeasure', '#measure', 255, false)"></div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<input style="width:90%; margin:10px auto; " multiple type="file" id="file" name="file" />
					</td>
				</tr>
				
				<tr>
					<td colspan = "2" style="text-align: center;">
						<a class="btn btn-mini btn-primary" onclick="check();">保存</a>
					</td>
				</tr>
			</table>
		</form>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/>
			<img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">提交中...</h4>
		</div>
		<div>
			<%@include file="../footer.jsp"%>
		</div>
			
	</body>
	
	<!-- 引入 -->
	<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
	<script type="text/javascript" src="static/js/jquery-form.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<script src="static/select2/select2.min.js"></script>
	<script src="static/js/ajaxfileupload.js"></script>
	<script type="text/javascript">
		if("ontouchend" in document) document.write("<script src='static/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
	</script>

	<script type="text/javascript">	
			
		jQuery(function($) {
			$("#file").ace_file_input({
				style:'well',
				btn_choose:'选择文件',
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
			/*
			if('${taskApproveEmp.EMP_NAME}'==''){
				$("#checkEmpCode").select2();
			}
			*/
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
			//检查审核人
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
			
			//计算选择的完成进度
			var checklist = document.getElementsByName("finishBox");
			var percentList = document.getElementsByName("percent");
			var splitNameList = document.getElementsByName("splitName");
			var eventSplitIds = "";//选择的活动分解项ID
			var percent = 0;//完成比例
			var splitNames = "";//完成的活动名称
			
			for(var i=0; i<checklist.length; i++){
				if(checklist[i].checked){
					eventSplitIds += "," + checklist[i].value;
					percent += parseFloat(percentList[i].innerText);
					splitNames += "," + splitNameList[i].innerText;
				}
			}
			
			//没有选择分解项时返回
			if(percent==0){
				$("#splitSpan").tips({
					side:3,
		            msg:'请至少选择一个活动分解项！',
		            bg:'#AE81FF',
		            time:2
		        });
				return;
			}
			
			if(eventSplitIds!=""){
				eventSplitIds = eventSplitIds.substring(1);
				splitNames = splitNames.substring(1);
			}
			$("#finishPercent").attr("value", percent);
			$("#eventSplitIds").attr("value", eventSplitIds);
			$("#splitNames").attr("value", splitNames);
			//检查说明输入的字符是否过长
			if(checkVal('#divAnalysis', '#analysis', 255, true)){
				return;
			}
			if(checkVal('#divMeasure', '#measure', 255, true)){
				return;
			}
			
			//活动超期时，差异分析和关差措施不能为空
			if('${isDelay}'=='1'){
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
			
			//设置异步保存参数
			var options = {
   				success: function(data){
   					alert("保存成功");
   				    $("#zhongxin2").hide();
   				    var url = '<%=basePath%>app_task/listCreativeEmpTask.do?show=${pd.show}&showDept=${pd.showDept}'
   				    		+ '&loadType=${pd.loadType }&startDate=${pd.startDate }&endDate=${pd.endDate }'
   				    		+ '&projectCode=${pd.projectCode }&eventId=${pd.projectEventId }';
   					window.location.href = url;
   		  		},
   			  	error: function(data){
   			  		alert("保存出错")
   			  	}
   		  	};
			$("#zhongxin2").show();
			if(""!=$("#file").val()){
				//有附件
				$.ajaxFileUpload({
	                url: '<%=basePath%>app_task/Upload.do',
	                secureuri: false, //是否需要安全协议，一般设置为false
	                fileElementId: 'file', //文件上传域的ID
	                dataType: 'text',
	                type: 'POST',
	                success: function(data){
	                	$("#zhongxin2").hide();
	                	var result = data;
	                	$("#fileStr").val(result);
	                	
            			$("#Form").ajaxSubmit(options);               	                    
	                },
	                error: function (data, status, e){//服务器响应失败处理函数
	                	$("#zhongxin2").hide();
	                    alert(e);
	                    console.log(data);
	                    top.Dialog.close();
	                }
            	});
			}else{//没有附件，直接保存
				$("#zhongxin2").hide();
				$("#Form").ajaxSubmit(options);
			}
		}
		
	</script>
</html>