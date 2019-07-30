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
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<link rel="stylesheet" href="static/css/app-style.css"/>
		
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		
		<style>
		input[type="checkbox"],input[type="radio"] {
			opacity:1 ;
			position: static;
			height:15px;
			margin-bottom:5px;
			margin-left:10px;
		}
	
		#zhongxin td{height:30px;}
	    #zhongxin td label{text-align:right;}
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
		/*上传附件样式*/
		.ace-file-multiple{width: 92%; margin-top: 10px; margin-left:10px;}
		.ace-file-multiple label.selected span:after{
			display: inline-block;
		    white-space: normal;
		    text-align: left;
		    width: 90%;
		    padding: 0 10px;
		}
		.icon-file{
			float:left;
		}
		.ace-file-multiple label:before{
			margin:0px;
		}
		.nav-tabs>li>a{
			color: white;
		}
		</style>
	</head>
<body>
	<div class="web_title">
<%-- 		<div class="back" style="top:5px">
			<c:choose>
				<c:when test="${empty reqPd.showDept }">
					<a href="<%=basePath%>app_task/listDesk.do?loadType=T">
				</c:when>
				<c:otherwise>
					<a href="<%=basePath%>app_task/listBoard.do?loadType=T">
				</c:otherwise>
			</c:choose>
			<img src="static/app/images/left.png" /></a>
		</div> --%>
		<div class="web_menu" style="width:90%; margin-left:20px;">
			<ul id="myTab" class="nav nav-tabs">
				<li class="active" style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#commit" data-toggle="tab">任务日清</a></li>
				<li style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#detail" data-toggle="tab">任务详情</a></li>
			</ul>
	   </div>
	</div>
	
	<div id="zhongxin" style="width:94%; margin: 0px auto; border: none; padding:5px; " class="tab-content">
		<!-- 任务日清 -->
		<div class="tab-pane fade in active" id="commit" >
		
			<c:if test="${reqPd.showDept!='1' && (pd.detailStatusName=='已生效' || pd.detailStatusName=='已退回')}">
				<div id="normal" class="normal" style="width: 100%; height:29px;">
		 			<a class="btn btn-mini btn-info" data-toggle="collapse" href="#uploadFileTab" id="uploadBtn"
						style="float:right; margin:3px;">上传附件</a>
				</div>
			</c:if>
	
			<!-- 上传的日清附件 -->
			<div id="fileDiv" style="width: 98%; margin: 5px auto;">
		       	<c:forEach items="${commitFileList }" var="perFile" varStatus="vs">
		       		<table id="fileTable_${perFile.ID}" style="width:100%">
			         	<tr>
			         		<td rowspan="2" style="width:20px;">${vs.index+1 }</td>
			         		<td colspan="2">
			         			<a style="cursor:pointer; color:#599ad2; margin-left:5px;" title="${perFile.FILENAME}" 
			         				onclick="loadFile('${perFile.FILENAME_SERVER}')">${perFile.FILENAME}</a>
			         		</td>
			         	</tr>
			         	<tr>
			         		<td style="width:120px;"> 上传于 ${perFile.CREATE_DATE}</td>
			         		<td>
			          		<c:if test="${currentEmpCode == pd.EMP_CODE && (pd.STATUS=='YW_YSX' || pd.STATUS=='YW_YTH') }">
			          			<a style="margin-left:5px;" onclick="delFile('${perFile.ID}', this)">删除</a>
			          		</c:if>
			         		</td>
			         	</tr>
		        	</table>
		       	</c:forEach>
		   	</div>
			<!-- 显示上传控件 -->
			<div id="uploadFileTab" class="panel-collapse collapse" style="width:98%; margin:0 auto">
		       	
		       	<form action="app_task/saveTempTaskFile.do" name="uploadFileForm" id="uploadFileForm" method="post" 
		            	enctype="multipart/form-data">
		           	<table style="width: 98%; margin: 5px auto;">
		           		<tr>
		           			<td style="width:80%">
		           				<input type="hidden" name="taskId" id="ID" value="${pd.ID }"></input>
				                <input multiple type="file" name="files" id="id-input-file-1" style="width: 180px;"/>
		           			</td>
		           			<td>
		           				<a class='btn btn-mini btn-primary' style="width:30px;margin-bottom:15px " 
		           					onclick="upload();" >上传</a>
		           			</td>
		           		</tr>
		           	</table>
		           </form>
		    </div>
		
			<form action="app_task/${msg}.do" name="completeForm" id="completeForm" method="post">
				<input type="hidden" name="ID" value="${pd.ID }"></input>
				<input type="hidden" name="REMAIN_DAY" id="REMAIN_DAY" value="${pd.REMAIN_DAY }"></input>
				<input type="hidden" name="NEED_CHECK" value="${pd.NEED_CHECK }"></input>
				<input type="hidden" name="CHECK_PERSON_CODE" value="${pd.CHECK_PERSON_CODE }" />
				<input type="hidden" name="EMP_ID" value="${pd.EMP_ID }" />
				<table style="width: 100%;">
					<tr>
						<td style="text-align: center; width: 25%;"><label>实际完成：</label></td>
						<td style="text-align: left;">
							<input type="hidden" name="REAL_COMPLETION" id="REAL_COMPLETION" placeholder="实际完成" value="${pd.REAL_COMPLETION }" />
							<div id="divCompletion" class="test_box" 
								<c:if test="${pd.detailStatusName=='已生效' || pd.detailStatusName=='已退回'}">contenteditable="true"</c:if> 
								onkeyup="checkVal('#divCompletion', '#REAL_COMPLETION', 100, false)">${pd.REAL_COMPLETION }</div>
						</td>
					</tr>
					<tr>
						<td><label>完成说明：</label></td>
						<td>
							<input type="hidden" name="DESCRIPTION" id="DESCRIPTION" placeholder="完成说明" value="${pd.DESCRIPTION }" />
							<div id="divDescription" class="test_box" 
								<c:if test="${pd.detailStatusName=='已生效' || pd.detailStatusName=='已退回'}">contenteditable="true"</c:if> 
								onkeyup="checkVal('#divDescription', '#DESCRIPTION', 100, false)">${pd.DESCRIPTION }</div>
						</td>
					</tr>
					<tr>
				        <td>
		                    <label>完成比例：</label>
		                </td>
		                <td id="eq">
		                	<c:choose>
		                		<c:when test="${pd.detailStatusName=='已生效' || pd.detailStatusName=='已退回'}">
		                			<span class="ui-slider-red">${pd.FINISH_PERCENT}</span>
		             				<input value="${pd.FINISH_PERCENT}" type="text" id="FINISH_PERCENT" name="FINISH_PERCENT" 
		             					style="width:25px;margin-left:3px; margin-top:4px; padding:0px; " readonly="readonly" />
		             				<span style="margin-top:4px;">%</span>
		             			</c:when>
		             			<c:otherwise>
		             				<div class="progress progress-success progress-striped opacity" 
		             					style="height: 24px; margin-bottom:0px; width:96%; ">
										<div class="bar" style="width: ${pd.FINISH_PERCENT }%; line-height: 24px;">
											<span style="color:black">${pd.FINISH_PERCENT }%</span>
										</div>
									</div>
		             			</c:otherwise>
		                	</c:choose>
		                </td>
					</tr>
					
					<!-- 临时工作需要评价的 -->
					<c:if test="${reqPd.NEED_CHECK == '1'}">
						<tr>
							<td><label>评价人：</label></td>
							<td>${pd.CHECK_PERSON_NAME }</td>
						</tr>
						
						<c:if test="${pd.detailStatusName!='已生效'}">
						<tr>
							<td><label>工作评价：</label></td>
							<td>
								<c:if test="${pd.detailStatusName=='已退回' || pd.detailStatusName=='已评价'}">
									<div class="test_box">${pd.QA }</div>
								</c:if>
								<!-- 提交了临时的日清，待评价的工作 -->
								<c:if test="${not empty reqPd.showDept && pd.detailStatusName=='已完毕' && isCheckPerson==true}">
									<input type="hidden" name="QA" id="QA" value="${pd.QA }" />
									<div id="divQA" class="test_box" contenteditable="true" 
										onkeyup="checkVal('#divQA', '#QA', 100, false)">${pd.QA }</div>
								</c:if>
							</td>
						</tr>
						
						<tr>
							<td><label>评价得分：</label></td>
							<td>
								<div class="radio">
	                                <label style="text-align: left;width:30px;height:25px;float:left;margin-left: 6px;">
	                                    <input name="SCORERadio" type="radio" id="optionsRadios1" value="-1"
	                                    	<c:if test="${empty reqPd.showDept || pd.detailStatusName!='已完毕' || isCheckPerson!=true}">disabled</c:if>
	                                    	<c:if test="${pd.SCORE==-1}">checked</c:if>>-1
	                                </label>
	                                <label style="text-align: left;width:30px;height:25px;float:left;margin-left: 6px;">
	                                    <input type="radio" name="SCORERadio" id="optionsRadios2" value="0"
	                                    	<c:if test="${empty reqPd.showDept || pd.detailStatusName!='已完毕' || isCheckPerson!=true}">disabled</c:if>
	                                    	<c:if test="${pd.SCORE==0}">checked</c:if>>0
	                                </label>
	                                <label style="text-align: left;width:30px;height:25px;float:left;margin-left: 6px;">
	                                    <input type="radio" name="SCORERadio" id="optionsRadios3" value="1"
	                                    	<c:if test="${empty reqPd.showDept || pd.detailStatusName!='已完毕' || isCheckPerson!=true}">disabled</c:if>
	                                    	<c:if test="${pd.SCORE==1}">checked</c:if>>1
	                                </label>
	                            </div>
	                            <input type="hidden" name="SCORE" id="SCORE" value="${pd.SCORE }">
							</td>
						</tr>
						</c:if>
						
					</c:if>
					
					<tr>
						<td colspan="2" style="text-align: center;">
							<c:choose>
								<c:when test="${(pd.detailStatusName=='已生效' || pd.detailStatusName=='已退回') || (not empty reqPd.showDept && reqPd.NEED_CHECK == '1'  && pd.detailStatusName=='已完毕' && isCheckPerson==true)}">
									<c:if test="${pd.detailStatusName=='已完毕' }">
										<a class="btn btn-mini btn-danger" onclick="sendBack();">退回</a>
									</c:if>
									<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
								</c:when>
							</c:choose>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<!-- 任务详情 -->
		<div class="tab-pane fade" id="detail">
			<table style="width: 100%;">
				<tr>
					<td style="text-align: center; width: 25%;"><label>任务名称：</label></td>
					<td style="text-align: left;">
						<div id="taskNameDiv" class="test_box">${pd.TASK_NAME}</div>
					</td>
				</tr>
				<tr>
					<td style="text-align: center;"><label>完成标准：</label></td>
					<td style="text-align: left;">
						<div class="test_box">${pd.COMPLETION }</div>
					</td>
				</tr>
				<tr>
					<td style="text-align: center;"><label>任务描述：</label></td>
					<td style="text-align: left;">
						<div class="test_box">${pd.TASK_CONTECT }</div>
					</td>
				</tr>
				
				<c:if test="${not empty fileList }">
					<tr>
						<td style="text-align: center;"><label>下达附件：</label></td>
						<td style="text-align: left;">
							<div>
								<c:forEach items="${fileList }" var="file" varStatus="vs">
								<a style="cursor:pointer;color: #599ad2;" onclick="loadFile('${file.SERVER_FILENAME }')">${file.FILENAME }</a><br>
								</c:forEach>
							</div>
						</td>
					</tr>
				</c:if>
				
			</table>
		</div>
	</div>		
		
	<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green"></h4></div>
		
	
	<!-- 引入 -->
	<link rel="stylesheet" href="static/css/jquery-ui-1.10.2.custom.min.css" />
    <script type="text/javascript" src="static/js/jquery-ui-1.10.2.custom.min.js"></script>
	<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>		
	<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <!-- 引入 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
    <script type="text/javascript" src="static/js/jquery-form.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			if($("#user_id").val()!=""){
				$("#loginname").attr("readonly","readonly");
				$("#loginname").css("color","gray");
			}
		 	if('${pd.detailStatusName}'=='已生效' || '${pd.detailStatusName}'=='已退回'){
		 		$( ".ui-slider-red" ).css({width:'70%', float:'left', margin:'10px'}).each(function() {
	                // read initial values from markup and remove that
	                var value = parseInt( $( this ).text(), 10 );
	                $( this ).empty().slider({
	                    value: value,
	                    range: "min",
	                    step: 5,
	                    min: 0,
	                    max: 100,
	                    slide: function( event, ui ) {
	                        $( "#FINISH_PERCENT" ).val( ui.value );
	                    }
	                });
	            });
		 	}
            $("#id-input-file-1").ace_file_input({
				style:'well',
				btn_choose:'上传附件',
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
        })
        
        //上传附件
        function upload(){
            if($("#id-input-file-1").val() == null || $("#id-input-file-1").val() == ""){
                alert("上传文件不允许为空");
                return false;
            }
            
            var options = {
                success: function(data){
                  	//查询上传的附件,如果上传了则显示
                  	if(data!='success'){
                  		alert(data);
                  		return;
                  	}
                  	//清空文件
                  	$(".ace-file-input").find(".remove").click();
                  	//查询保存的附件
					$.ajax({
					 	url: '<%=basePath%>app_task/checkUploadFileOnTask.do',
						data: {
							taskId: $("#ID").val(),
							taskType: 'T'
						},
					 	type: 'post',
					 	success: function(data){
							if(data){
								$("#fileDiv").empty();
								var appendStr = '';
								for(var i=0; i<data.length; i++){
									var perFile = data[i];
									appendStr += 
										'<table id="fileTable_' + perFile.ID + '" style="width:100%">' + 
										'<tr><td rowspan="2" style="width:20px;">' + (i+1) + '</td>' + 
										'<td colspan="2">' +
										'<a style="cursor:pointer; color:#599ad2; margin-left:5px;" ' + 
										'onclick="loadFile(\'' + perFile.FILENAME_SERVER + '\')">' + perFile.FILENAME + 
										'</a>' + 
										'</td></tr>'+
										'<tr><td style="width:120px;"> 上传于 ' + perFile.CREATE_DATE + '</td>' + 
										'<td>';
									if('${currentEmpCode}'=='${pd.EMP_CODE}' &&
							       			('${pd.STATUS}'=='YW_YSX' || '${pd.STATUS}'=='YW_YTH')){
										appendStr += '<a style="margin-left:5px;" onclick="delFile(\'' + perFile.ID + '\', this)">删除</a>';
									}
									appendStr += '</td></tr></table>';
								}
								$("#fileDiv").append(appendStr);
							}
						}
					});
                },
                error: function(data){
                    alert("保存出错");
                }
            };
            $("#uploadFileForm").ajaxSubmit(options);
        }
            
		//删除文件
		function delFile(fileId, obj){
			$.ajax({
				type: "post",
				dataType:"text",
				data:{"fileId": fileId},
				url: '<%=basePath%>app_task/deleteFileById.do',
				success: function(data){
					if(data=="error"){
						top.Dialog.alert("后台出错，请联系管理员！");
					}else if(data=="success"){
						$("#fileTable_"+fileId).remove();
					}
				}
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
        
		//保存
		function save(){
			if($("#id-input-file-1").val()){
				alert('请先上传附件');
				return;
			}
			
			//检查说明输入的字符是否过长
			if(checkVal('#divCompletion', '#REAL_COMPLETION', 100, true)){
				return;
			}
			if(checkVal('#divDescription', '#DESCRIPTION', 100, true)){
				return;
			}
			if(checkVal('#divQA', '#QA', 100, true)){
				return;
			}
			if($("#REAL_COMPLETION").val()==""){
				$("#divCompletion").tips({
					side:3,
		            msg:'不能为空！',
		            bg:'#AE81FF',
		            time:1
		        });
				$("#divCompletion").focus();
				return false;
			}
			if(''!='${reqPd.showDept}' && '${reqPd.NEED_CHECK}'=='1'){
				if($("#QA").val()==""){
					$("#divQA").tips({
						side:3,
			            msg:'请填写评价！',
			            bg:'#AE81FF',
			            time:1
			        });
					$("#divQA").focus();
					return false;
				}
			}
			var options = {
				success: function(data){
					$("#zhongxin").hide();
					if('${reqPd.showDept}' == ''){
						var url = '<%=basePath%>app_task/listDesk.do?loadType=T'; 
					}else{
						var url = '<%=basePath%>app_task/listBoard.do?loadType=T';
					}
				   	window.location.href = url;
		  		},
			  	error: function(data){
			  		alert("保存出错");
			  	}
		  	};
			$("#SCORE").val($('input:radio[name="SCORERadio"]:checked').val());
			$("#completeForm").ajaxSubmit(options);	
		}
		
		//下载文件
		function loadFile(fileName){
			var action = '<%=basePath%>app_task/checkFile.do';
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
					window.location.href = '<%=basePath%>app_task/loadFile.do?fileName=' + fileName + "&time=" + time;
				}
			});
		}
		
		//退回临时工作日清
		function sendBack(){
			if(checkVal('#divQA', '#QA', 100, true)){
				return;
			}
			if('${reqPd.NEED_CHECK}'=='1'){
				if($("#QA").val()==""){
					$("#divQA").tips({
						side:3,
			            msg:'请填写评价！',
			            bg:'#AE81FF',
			            time:1
			        });
					$("#divQA").focus();
					return false;
				}
			}
			if(confirm("确定退回临时工作？")){
				$("#completeForm").attr('enctype', '');
				$("#completeForm").attr('action', '<%=basePath%>app_task/sendBack.do');
				var options = {
					success: function(data){
						$("#zhongxin").hide();
						if('${reqPd.showDept}' == ''){
							var url = '<%=basePath%>app_task/listDesk.do?loadType=T'; 
						}else{
							var url = '<%=basePath%>app_task/listBoard.do?loadType=T';
						}
					   	window.location.href = url;
			  		},
				  	error: function(data){
				  		alert("保存出错");
				  	}
			  	};
				$("#completeForm").ajaxSubmit(options);	
			}
		}
	</script>
	
</body>
</html>