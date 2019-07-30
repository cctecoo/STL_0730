<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		<script type="text/javascript" src="static/js/jquery-2.0.3.min.js"></script>
		<script type="text/javascript" src="plugins/zTree3.5/jquery.ztree.all.min.js"></script>
	
		<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js"></script>
		<script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"></script>
		<script type="text/javascript" src="static/js/jquery-form.js"></script>
		
		<script src="static/select2/select2.min.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>

		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		
		<script src="static/js/ajaxfileupload.js"></script><!-- 异步上传文件 -->
		
		<script type="text/javascript">
			var isFromApp = '${fromApp}'!='';
			var currentSelDeptInput = null;//用于存放当前选择的部门输入框
			$(function(){
				//日期框
				initDateTimePicker();
				//设置输入项的可读和可写
				setInputReadOrEdit();
                //加载上传的附件
                loadAttachedFiles();
				//加载操作历史
				loadOperatorHis();
			});
			
			//初始化日期
			function initDateTimePicker(){
				$('.datetimepicker').datetimepicker({ 
					//view 0:hour, 1:day, 2:month, 3:year, 4: decade 10 years
					language:'zh-CN',
					minView: 2,
					startView: 2,
				    format: 'yyyy-mm-dd',
				    autoclose: true,
				    initialDate: new Date()
				    //endDate: '${param.endDate}' 
				});
			}
			
			//返回表单的列表页
			function toAppFormList(){
				var url = 'app_task/toFormFlowList.do';
				if('${formPage}'.indexOf('purchasing') != -1){//采购表单
					 url = 'app_task/toPurchaseFormList.do'
				}
				if(''!='${clickSearch}'){
					url += '?clickSearch=${clickSearch}';
				}
				window.location.href = url;
			}
			
			//查看关联表单
			function showDetail(formWorkId){
				if(null==formWorkId || formWorkId ==''){
					return;
				}
				var url= '<%=basePath%>app_task/toViewRepairOrder.do?formWorkId=' + formWorkId
						+ '&fromApp=true';
				
				window.location.href = url;
			}
			
			//会审操作选择
			function changeOpinion(obj){
				//修改文本
				$("#btnText").text($(obj).text());
				$("#opinionType").val($(obj).text());
			}
			
			//打印
			function printdiv(printpage){ 
				var headstr = '<html><head><title></title>'
					+ '<style>'
					+ '#orderDiv table td { height: 20px; padding: 2px; text-align: center; }'
					+ '</style>'
					+ '</head>' 
					+ '<body style="width:210mm;">'; 
				var footstr = '</body>';
				var oldstr = document.body.innerHTML;
				//设置打印时的内容
				var newstr = document.body.innerHTML;
				newstr = newstr.replace(/textarea/g,"div");
				
				document.body.innerHTML = newstr;
				if('${empty attachedComments }'=='true'){//没有会签，打印时隐藏
					$("#commentDiv").hide();
				}
				if('${empty attachedFiles }'=='true'){//没有附件，打印时隐藏
					$("#fileDiv").hide();
				}
				//执行打印
				window.print();
				//打印之后在恢复原先的内容
				document.body.innerHTML = oldstr;
			}
			
			//异步上传附件
	        function uploadFiles(){
	        	//先检查是否选择文件
	        	if(!$("#file").val()){
	        		showMsgText($("#file"), "请选择文件！");
	        		return;
	        	}
	        	//异步上传请求
	        	$("#loadDiv").show();
	        	$.ajaxFileUpload({
	                url: '<%=basePath%>app_task/Upload.do',
	                secureuri: false, //是否需要安全协议，一般设置为false
	                fileElementId: 'file', //文件上传域的ID
	                dataType: 'text',
	                type: 'POST',
	                success: function(data){
	                	//上传后，显示附件列表信息
	                	var fileStr = '';
	                	var result = eval(data.replace(/<.*?>/ig,""));//ajaxFileUpload不能解析json,所以需要转化
	                	//var obj = data;//eval('('+data+')');
	                	$.each(result, function(index, serverFile){
	                		fileStr += '<tr>'
	                			+ '<td><a style="cursor:pointer;" '
	                			+ 'onclick="loadFile(\''+ serverFile.filename_server + '\')">' + serverFile.filename + '</a>'
	                			+ '<a style="cursor:pointer;" '
	                			+ 'onclick="removeFile(this)" class="btn btn-mini btn-info delFileBtn">删除</a>' 
	                			+ '<input type="hidden" name="fileName" value="' + serverFile.filename + '" />'
	                			+ '<input type="hidden" name="serverFileName" value="' + serverFile.filename_server + '" />'
	                			+ '</td>'
	                			+ '</tr>';
	                	});
	                	$("#file").val('');//清空文件上传域
	                    $("#loadDiv").hide();//隐藏提交遮罩
	                    $("#fileTable").append(fileStr);//拼接文件列表
	                },
	                error: function (data, status, e)//服务器响应失败处理函数
	                {
	                    alert(e);
	                    //toAppFormList();
	                }
	            });
	        
	        }
			
			//移除已上传的文件
	        function removeFile(obj, serverFileId){
	        	//判断是否已经保存到数据库
	        	if(serverFileId){//不为空则移除表单关联的附件表记录
	        		if(confirm('删除已上传的文件，确定继续操作')){
	        			//调用删除附件记录
	        			$.ajax({
	        				type: 'post',
	        				url: '<%=basePath%>app_task/deleteFileById.do',
	        				data:{fileId: serverFileId},
	        				success: function(data){
	        					if('success'==data){//记录删除成功则移除页面上的记录
	        						$(obj).parent().parent().remove();//点击后移除行tr元素
	        					}else{
	        						alert('后台异常，请联系管理员');
	        					}
	        				}
	        			});
	        			
	        		}
	        	}else{//没有保存到后台数据库，则直接移除页面记录
	        		$(obj).parent().parent().remove();//点击后移除行tr元素
	        	}
	        }

            //查询上传的附件
            function loadAttachedFiles(){
                //没有实例ID则不需要查询
                if(''=='${work.ID}'){
                    return;
                }
                $("#loadDiv").show();
                //调用后台服务
                $.ajax({
                    type: 'post',
                    url: '<%=basePath%>app_task/findFormWorkAttachedFile.do',
                    data: {formWorkId: '${work.ID}'},
                    success: function(data){
                        $("#loadDiv").hide();
                        if('error'==data){
                            alert('后台出错，请联系管理员');
                        }else{
                            var obj = eval('(' + data + ')');
                            appendAttachedFile(obj);
                        }
                    }
                });
            }

            //拼接上传的附件
            function appendAttachedFile(list){
                var appendStr = '';
                var stepId = 0, fileIndex = 1, zipFileName = '', isEditStep = false;
                $.each(list, function(index, item) {
                    var itemStepId = item.FORM_WORK_STEP_ID;
                    if(stepId != itemStepId){//新的步骤

                        appendStr += '</td></tr>';

                        //重置循环值
                        stepId = itemStepId, fileIndex= 1, zipFileName='';
                        isEditStep = 'Y' != '${readonlyRepairOrder}' &&  itemStepId== '${currentStep.ID }';
                        //拼接
                        appendStr += '<tr>' + '<td><span>' + (index + 1) + '.</span>'
                            + '[' + item.STEP_NAME + ']' + item.CREATE_EMPNAME + '，'
                            + item.CREATE_DATE + '上传，';
                    }else{
                        fileIndex++;
                        if(isEditStep){//编辑步骤，或不同步骤的附件
                            if(fileIndex>1){
                                appendStr += '</td></tr>';
                            }
                            //拼接
                            appendStr += '<tr>' + '<td><span>' + (index + 1) + '.</span>'
                                + '[' + item.STEP_NAME + ']' + item.CREATE_EMPNAME + '，'
                                + item.CREATE_DATE + '上传，';
                        }
                    }
                    zipFileName += ',' + item.FILENAME_SERVER;

                    //循环拼接文件
                    appendStr += '<a style="cursor:pointer;margin-left:15px;" '
                        + ' onclick="loadFile(\'' + item.FILENAME_SERVER + '\')">'
                        + item.FILENAME + '</a>';
                    //当前是可编辑步骤
                    if(isEditStep){
                        appendStr += '<a style="cursor:pointer;margin-left:5px;" '
                            + ' onclick="removeFile(this,' + item.ID + ')"'
                            + ' class="noPrint btn btn-mini btn-info delFileBtn">删除</a>';
                    }
                });

                appendStr += '</td></tr>';
                $("#fileTable").append(appendStr);
            }
			
			var isNumInput = true;//所有数字类型的输入项是否都检查合格
			var isNotEmpty = true;//所有非空类型的输入项是否都检查合格
			
			//设置输入项的可读和可写
			function setInputReadOrEdit(){
				//先设置所有的不可用
				$("#formDetail input,select,textarea").attr("disabled", "disabled");
				//设置按钮不可用
				$("#formDetail .stepLevelBtn").hide();
				//单独设置文件上传不可用
				$("#fileBtn").hide();
				$("#comment").hide();
				$("#checkupText").hide();
				$("#checkupBtn").hide();
				$("input[name='opinionType']").attr("disabled", "disabled");
				//操作按钮
				$(".bottomFloatBtn>a").hide();
				//取消按钮显示
				$("#cancelBtn").show();
				
				//设置特定字段的可写
				$("#focusEmpText").removeAttr("disabled");
				//在根据当前的节点层级设置可写
				if('Y'!='${readonlyRepairOrder}'){//处理工单的，需要设置输入项可用
					var currentStepLevel = '1';//设定当前步骤默认为1
					if(''!='${work.CURRENT_STEP_LEVEL}'){//当前步骤不为空时，重新设置
						currentStepLevel = '${work.CURRENT_STEP_LEVEL}';
					}
					$(".stepLevel_"+currentStepLevel).removeAttr("disabled");//把当前步骤的所有输入项设置为可用
					//设置按钮显示
					$(".stepLevelBtn.stepLevel_"+currentStepLevel).show();
					//会签单独设置为可用，不受步骤限制
					$("#comment").removeAttr("disabled");
					$("#comment").show();
					$("#fileBtn").show();
					if('mineCheck'=='${isFinishCheckup}'){//显示会审
						$("#checkupText").removeAttr("disabled");
						$("#checkupText").show();
						$("input[name='opinionType']").removeAttr("disabled");
					}
					//显示操作按钮
					$(".bottomFloatBtn>a").show();
					
					//特殊步骤，用步骤业务类型判断,设置为可编辑
					var specialList = findSpecialInput();
					if(specialList && specialList.length>0){
						$.each(specialList, function(index, obj){
							$(obj).removeAttr("disabled");
						});
					}
				}else if('Y'=='${checkup}'){//会审操作
					if('mineCheck'=='${isFinishCheckup}' || 'containsMineCheck'=='${isFinishCheckup}'){//显示会审
						$("#checkupText").removeAttr("disabled");
						$("#checkupText").show();
						$("#checkupBtn").show();
						$("input[name='opinionType']").removeAttr("disabled");
					}
				}else if('Y'=='${replyFocus}'){//处理转发
					//会签单独设置为可用，不受步骤限制
					$("#comment").removeAttr("disabled");
					$("#comment").show();
					$("#fileBtn").show();
					$("#saveBtn").show();
				}
			}
			
			//特殊步骤，用步骤业务类型判断
			function findSpecialInput(){
				var specialList = null;
				if('${not empty currentStep }'=='true'){
					if('${currentStep.STEP_SERVICE_TYPE=="库存确认" }'=='true'){
						//采购类，库存确认步骤可以修改库存等字段
						specialList = $("#formDetail .storeAdjust");
					}
				}
				return specialList;
			}
			
			//查询操作历史
			function loadOperatorHis(){
				//没有实例ID则不需要查询
				if(''=='${work.ID}'){
					return;
				}
				//调用后台服务
				$.ajax({
					type: 'post',
					url: '<%=basePath%>app_task/findFormWorkOperatorHistory.do',
					data: {formWorkId: '${work.ID}'},
					success: function(data){
						if('error'==data){
							alert('后台出错，请联系管理员');
						}else{
							var obj = eval('(' + data + ')');
							appendOperHis(obj);
						}
					}
				});
			}
			
			//拼接操作历史
			function appendOperHis(operHisList){
				var appendStr = '';
				$.each(operHisList, function(index, operHis){
					appendStr += '<tr>' + '<td>' + '第' + (index+1) + '步，' ;
					if('处理'!=operHis.OPERATE_TYPE){
						appendStr += '<span style="color:red;">' + operHis.OPERATE_TYPE + ' </span>';
					}
					appendStr += '[' + operHis.STEP_NAME + '] ' + '' + operHis.OPERATOR_EMP_NAME;
				
					if(null==operHis.OPERATE_START_TIME){//判断是否有操作时间，没有则不显示
						appendStr += '，未处理';
					}else{//有时间的则显示
						appendStr += '<div>' + operHis.OPERATE_START_TIME;
						if(null!=operHis.OPERATE_END_TIME){
							appendStr += '至' + operHis.OPERATE_END_TIME;
						}
						appendStr += '</div>';
					}
					appendStr += '</td>' + '</tr>';
						
				});
				$("#operHisTable").append(appendStr);
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
			
    		//退回上一步
			function reject(){
				if(confirm('确定退回上一步')){
					//把上传的文件的值存入隐藏域
					setUploadFilesVal();
					var formWorkId = $("input[name='formWorkId']").val();//实例表单id
					var currentStepId = $("input[name='currentStepId']").val();//当前步骤id
					var uploadFiles = $("input[name='uploadFiles']").val();//上传的附件
					var comment = $("#comment").val();//会签内容
					var currentStepCommentId = $("#currentStepCommentId").val();
					//显示加载
					$("#loadDiv").show();
					$.ajax({
						type: 'post',
						url: '<%=basePath%>app_task/rejectFormWorkStep.do',
						data:{
							'formWorkId': formWorkId,//实例表单id
							'currentStepId': currentStepId,//当前步骤id
							'uploadFiles': uploadFiles,//上传的附件
							'comment': comment,//会签内容
							'currentStepCommentId': currentStepCommentId
						},
						success: function(data){
							$("#loadDiv").hide();
							if('success'==data){
								toAppFormList();
							}else{
								alert('后台出错，请联系管理员');
							}
						}
						
					});
				}
			}
			
			//转交下一步
			function commitNext(){
				//调用保存
				save('commitNext');
			}
			
			//设置上传的文件的值
			function setUploadFilesVal(){
				//处理上传的文件
				var fileNameStr = '';
				var fileNameArr = $('input[name="fileName"]');
				var serverFileNameArr =  $('input[name="serverFileName"]');
				$(fileNameArr).each(function(index, obj){
					fileNameStr += $(fileNameArr[index]).val() + ',' + $(serverFileNameArr[index]).val() + ';'
				});
				$("#uploadFiles").val(fileNameStr.substring(0, fileNameStr.length-1));
			}
			
			//保存会审
			function saveCheckup(){
				if($("#checkupText").val()){
					var opinionType = $("input[name='opinionType']:checked").val();
					$.ajax({
						type: 'post',
						url: 'app_task/updateCheckup.do',
						data:{opinionType: opinionType, checkupText: $("#checkupText").val(), 
							checkupId:'${checkupId}' 
						},
						success: function(data){
							if(data=='success'){
								toAppFormList();
							}else{
								alert("后台出错，请联系管理员");
							}
						}
					});
				}else{
					showMsgText($("#checkupText"), '请输入内容！');
				}
			}
			
			//保存
			function save(commitNext){
				
				//保存时检查数字输入项
				if(!checkInputNum()){
					//alert("请输入正确格式的内容！");
					return;//输入项不符合则不保存
				}

                //会签内容的长度不超过1000
                if($("#comment").val().length>1000){
                    alert('会签内容长度最大为1000');
                    return;
                }

				//有文件没上传，则提示
				if($("#file").val()){
					alert('请先上传文件');
					return;
				}
				
				//设置隐藏域的值
				if(commitNext){
					if(!checkNotNull()){//检查文本非空项
						//alert("请输入当前步骤的内容！");
						return;
					}
					/*
					//检查限制条件
					if(!checkLimit()){
						//return;
					}
					*/
					$("#commitNext").val("commitNext");
				}else{
					$("#commitNext").val("");
				}
				//显示加载
				$("#loadDiv").show();
				//取消输入项的不可用，这样才能保存到后台
				$("#formDetail input, select, textarea").removeAttr("disabled");
				//把表单内容存入输入框
				//$("#workContent").val($("#formDetail").html());
				//把上传的文件的值存入隐藏域
				setUploadFilesVal();
				//设置会审意见
				var opinionType = $("input[name='opinionType']:checked").val();
				$("#checkupType").val(opinionType);
				$("#checkupDetail").val($("#checkupText").val());
				
				//判断是否为保存回复
				if('${replyFocus}'=='Y'){
					var formWorkId = '${work.ID}';
					var formWorkStepId = '${formWorkStepId}';
					var comment = $("#comment").val();
					var uploadFiles = $("#uploadFiles").val();
					$.ajax({
						type: 'post',
						url: 'app_task/saveReplyToFocus.do',
						data: {'formWorkId': formWorkId, 'formWorkStepId': formWorkStepId,
							'comment': comment, 'uploadFiles': uploadFiles
						},
						success: function(data){
							if(data.msg=='success'){
								toAppFormList();
							}else{
								alert('后台出错，请联系管理员');
							}
						}
					});
					return;
				}
				
				//提交后台
				$("#form1").ajaxSubmit({
					success: function(data){
						//返回后，
						$("#loadDiv").hide();
						setInputReadOrEdit();//再次禁用输入
						
						var formWorkId = '${work.ID }';
						//新增时实例id为空，返回的就是实例ID
						if(''==formWorkId){
							formWorkId = data;
						}
						//如果是转交下一步，则跳转到选择人员页面
						if(commitNext){
							//判断是否是最后一步
							if('${currentStep.LAST_STEP}'=='Y'){
								toAppFormList();//最后一步，则关闭对话框
							}
							//费用表单，人员选择页面
							findNextStepEmp(formWorkId);
						}else{//只是保存操作，可以直接跳转到编辑页面
							window.location.href = '<%=basePath%>app_task/toEditRepairOrder.do?formWorkId='+formWorkId
									+ '&pageName=${formPage}&fromApp=${fromApp}';
						}
					},
					error: function(){
						$("#loadDiv").hide();
						alert("后台出错，请联系管理员");
					}
				});
			}
			
			//显示选择抄送人员的页面
			function showFocusEmp(){
				$.ajax({
					type: 'post',
					url: '<%=basePath%>app_task/findEmpList.do',
					success: function(data){
						if('error'==data.msg){
							alert("后台出错，请联系管理员");
						}else{
							//拼接html
							var append = ''
								+ '<select id="focusEmpSel" name="focusEmp" class="chzn-select" multiple '
								+ ' style="width:88%;" data-placeholder="点击选择人员">'
								+ '<option value="">请选择</option>';
							$.each(data.empList, function(empIndex, emp){
								append += '<option value="' + emp.EMP_CODE + '">[' + emp.EMP_DEPARTMENT_NAME + ']' + emp.EMP_NAME + '</option>';
							});
							append += '</select>';
							//更新选择人员的下拉控件
							//$("#focusEmpSel").chosen("destroy");
							$("#focusEmpDiv").empty();
							$("#focusEmpDiv").append(append);
							$("#focusEmpFormworkId").val(${work.ID });
							//初始化下拉框
							$("#focusEmpSel").select2();
							
							$("focusEmpDiv>.chosen-container").css('width', '90%');
							
							$("#focusEmpModal").modal('show');
						}
					}
				});
			}
			
			//提交抄送人员
			function saveFocusEmp(){
				//检查是否选择
				if($("#focusEmpSel").val()==""){
					$("#focusEmpSel").tips({
						side:3,
			            msg:'请选择!',
			            bg:'#AE81FF',
			            time:1
			        });
					$("#focusEmpSel").focus();
					return false;
				}
				//获取选择的人员姓名
				var selEmpNames = '';
				$.each($("#focusEmpSel option:selected"), function(i, obj){
					selEmpNames += $(obj).text()+',';
				});
				if(selEmpNames!=''){
					//设置选择的人员姓名
					$("#focusEmpName").val(selEmpNames.substr(0, selEmpNames.length-1));
				}
				
				//提交
				$("#loadDiv").show();
				$("#focusEmpForm").ajaxSubmit({
					success: function(data){
						$("#loadDiv").hide();
						if("success"==data){
							toAppFormList();
						}else{
							alert('后台出错，请联系管理员！');
						}
					}
				});
			}
			
			//显示选择下一步骤人员的页面
			function showNextStepEmp(formWorkId){
				$.ajax({
					type: 'post',
					url: '<%=basePath%>app_task/findWorkStepNextList.do',
					data: {formWorkId: formWorkId},
					success: function(data){
						if('error'==data){
							alert("后台出错，请联系管理员");
						}else{
							//转换返回数据
							var obj = eval('(' + data + ')');
							//拼接html
							var append = '';
							$.each(obj.nextList, function(index, stepNext){
								append += '<div style="margin: 2px; ">' + '下一步：' + stepNext.STEP_NAME
									+ '<input type="hidden" name="nextWorkStepLevel" value="' + stepNext.NEXT_WORK_STEP_LEVEL + '" />'
									+ '<input type="hidden" name="nextFormWorkStepId" value="' + stepNext.WORK_STEP_ID + '" />'
									+ '<select class="chzn-select" name="chooseEmp" >'
									+ '<option value="">请选择人员</option>';
								$.each(stepNext.chooseEmpList, function(empIndex, emp){
									append += '<option value="' + emp.EMP_CODE + '">' + emp.EMP_NAME + '</option>';
								});
								append += '</select>' + '</div>';
							});
							//更新选择人员的下拉控件
							$(".chzn-select").chosen("destroy");
							$("#chooseEmpDiv").empty();
							$("#chooseEmpDiv").append(append);
							$("#chooseEmpFormworkId").val(formWorkId);
							//初始化下拉框
							$(".chzn-select").chosen({
								search_contains: true,
								disable_search_threshold: 10,
								max_selected_options: 10
							});
							$(".chosen-container").css('width', '220px');
							
							$("#chooseEmpModal").modal('show');
						}
					}
				});
			}
			
			//直接查询下一步骤人员
			function findNextStepEmp(formWorkId){
				$("#loadDiv").show();
				$.ajax({
					type: 'post',
					url: '<%=basePath%>app_task/findWorkStepNextList.do',
					data: {formWorkId: formWorkId},
					success: function(data){
						$("#loadDiv").hide();
						if('error'==data){
							alert("后台出错，请联系管理员");
						}else{
							//转换返回数据
							var obj = eval('(' + data + ')');
							if(obj.msg && obj.msg=='notFind'){
								top.Dialog.alert("当前步骤已经处理，请刷新后再操作");
								return;
							}
							if(obj.nextList.length==0){
								alert("没有获取到可转交的步骤，请联系当地信息部处理");
								return;
							}
							if(obj.nextList.length>1){
								alert("获取到多个可转交的步骤，请联系当地信息部处理");
								return;
							}
							
							//拼接下一步选择人员的html
							var append = '', stepNext = obj.nextList[0];
							append += '<div style="margin: 2px; ">' 
								+ '下一步：' + stepNext.STEP_NAME
								+ '<input type="hidden" name="nextWorkStepLevel" value="' + stepNext.NEXT_WORK_STEP_LEVEL + '" />'
								+ '<input type="hidden" name="nextFormWorkStepId" value="' + stepNext.WORK_STEP_ID + '" />';
							if('anyEmp' == stepNext.CHOOSE_EMP_SQL){//配置的任意选择
								append += '<input type="text" readonly id="chooseEmpName" name="chooseEmpName" '
									+ ' onclick="deptAndEmp(this);" placeholder="请选择人员" />'
									+ '<input type="hidden" id="chooseEmp" name="chooseEmp" anyEmp="anyEmp"/>';
							}else{//根据规则查询出的人员列表
								append += '<select class="chzn-select" id="chooseEmp" name="chooseEmp" >';
								//'<select id="chooseEmpSel" class="chzn-select" name="chooseEmp" >'
								if(stepNext.chooseEmpList.length>1){
									append += '<option value="">请选择人员</option>';
								}
								$.each(stepNext.chooseEmpList, function(empIndex, emp){
									append += '<option value="' + emp.EMP_CODE + '">' + emp.EMP_NAME + '</option>';
								});
								append += '</select>';
							}
							append += '</div>';
							
							//清空原有人员选择控件
							$(".chzn-select").chosen("destroy");
							$("#chooseEmpDiv").empty();
							$("#chooseEmpDiv").append(append);
							$("#chooseEmpFormworkId").removeAttr("disabled")
							$("#chooseEmpFormworkId").val(formWorkId);

							$("#chooseEmpModal").modal('show');
							//自动选择下一步人员
							if('anyEmp' != stepNext.CHOOSE_EMP_SQL){//配置了人员
								//初始化下拉框
								$(".chzn-select").chosen({
									search_contains: true,
									disable_search_threshold: 10,
									max_selected_options: 10
								});
								$(".chosen-container").css('width', '220px');
								$("#chooseEmpBtn").click();
							}
						}
					}
				});
			}
			
			//提交下一步
			function saveChooseEmp(){
				var isCommit = true;
				//检查是否选择人员
				var chooseEle = $("#chooseEmp");
				if($(chooseEle).val()==""){
					//下一步人员，为任意选择
					if($(chooseEle).attr('anyEmp')=='anyEmp'){
						chooseEle = $("#chooseEmpName");
					}
					showMsgText($(chooseEle), '请选择人员!');
					$(chooseEle).focus();
					isCommit = false;
					return false;
				}
				//提交
				if(isCommit){
					$("#loadDiv").show();
					$("#chooseEmpForm").ajaxSubmit({
						success: function(data){
							$("#loadDiv").hide();
							if("success"==data){
								toAppFormList();
							}else if("notFind"==data){
								alert('请选择下一步负责人');
							}else{
								alert('后台出错，请联系管理员！');
							}
						}
					});
				}
			}
			
			//显示选择退回步骤
			function showRejectStep(){
				//先检查是否填写退回原因
				if($("#comment").val()==''){
					$("#comment").focus();
					alert('请在会签区域填写退回原因');
					return;
				}
				//再查询可退回的步骤
				$.ajax({
					type: 'post',
					url: '<%=basePath%>app_task/findRejectStepList.do',
					data: {'formWorkId': '${work.ID }', 'currentStepId': '${currentStep.ID}'},
					success: function(data){
						if('error'==data.msg){
							alert("后台出错，请联系管理员");
						}else{
							//拼接html
							var append = ''
								+ '<select id="rejectStepSel" name="rejectStep" '
								+ ' style="width:88%;" data-placeholder="点击选择">'
								+ '<option value="">请选择</option>';
							$.each(data.stepList, function(itemIndex, item){
								append += '<option value="' + item.ID + '">[' + item.STEP_LEVEL + ']' + item.STEP_NAME 
									+ '[' + item.CURRENT_EMPNAME + ']' + '</option>';
							});
							append += '</select>';
							//更新下拉控件
							$("#rejectStepDiv").empty();
							$("#rejectStepDiv").append(append);
							//显示对话框
							$("#rejectStepModal").modal('show');
						}
					}
				});
			}
			
			//保存退回
			function rejectStep(){
				if(confirm('确定退回')){
					//把上传的文件的值存入隐藏域
					setUploadFilesVal();
					var formWorkId = $("input[name='formWorkId']").val();//实例表单id
					var currentStepId = $("input[name='currentStepId']").val();//当前步骤id
					var uploadFiles = $("input[name='uploadFiles']").val();//上传的附件
					var comment = $("#comment").val();//会签内容
					var currentStepCommentId = $("#currentStepCommentId").val();
					var rejectStepId = $("#rejectStepSel").val();//选择退回的步骤id
					//显示加载
					$("#loadDiv").show();
					$.ajax({
						type: 'post',
						url: '<%=basePath%>app_task/rejectFormWorkStep.do',
						data:{
							'formWorkId': formWorkId,//实例表单id
							'currentStepId': currentStepId,//当前步骤id
							'uploadFiles': uploadFiles,//上传的附件
							'comment': comment,//会签内容
							'currentStepCommentId': currentStepCommentId,
							'rejectStepId': rejectStepId //退回的步骤id
						},
						success: function(data){
							$("#loadDiv").hide();
							if('success'==data){
								toAppFormList();
							}else{
								alert('后台出错，请联系管理员');
							}
						}
						
					});
				}
			}
			
			//检查所有的非空项是否输入
			function checkNotNull(){
				if(!isNumInput){
					return;
				}
				isNotEmpty = true;//每次检查之前重置
				//开始检查input
				$("#formDetail input").each(function(index, obj){
					if($(obj).attr('type')!='hidden'){
						checkNotEmpty(obj, 400);
					}
				});
				//检查复选框和单选框
				if(isNotEmpty){
					isNotEmpty = checkRadioOrCheckboxVal();
				}
				//判定是否全部合格
				if(!isNotEmpty){
					return false;
				}
				return true;
			}
			
			//检查是否输入内容
			function checkNotEmpty(obj, maxLength){
				//判断输入项是否有效
				var disabled = $(obj).attr('disabled');
				//输入项不可用或者前一个校验没通过，则不进行本次检查
				if('disabled'==disabled || false==isNotEmpty){
					return true;
				}
				var val = $(obj).val();
				//判断是否为空
				if(null==val || ''==val){
					showMsgText(obj, '请输入内容！');
					isNotEmpty = false;
					return false;
				}
				//判断是否超过最大长度
				if(maxLength){
					if(val.length>maxLength){
						showMsgText(obj, '长度不能超过'+maxLength+'，请重新输入！');
						isNotEmpty = false;
						return false;
					}
				}
				return true;
			}
			
			//检查数字的输入项
			function checkNum(obj, maxNum){
				//判断输入项是否有效
				var disabled = $(obj).attr('disabled');
				
				if('disabled'==disabled || false==isNumInput){
					return;
				}
				var val = $(obj).val();
				//alert("val="+val + ",checkInputNumber="+checkInputNumber(val));
				//检查输入的是否为数字
				if(!checkInputNumber(val)){
					showMsgText(obj, '请填写整数！');
					isNumInput = false;
					return false;
				}
				//alert('maxNum='+maxNum);
				if(maxNum){//需要检查最大数值的
					//检查是否超出最大值
					if(val>maxNum){
						showMsgText(obj, '请填写不超过'+maxNum+'的数字！');
						isNumInput = false;
						return false;
					}
				}
				
				return true;
			}
			
			//检查数字格式
			function checkInputNumber(value) {
			    var patrn = /^(-)?[0-9]*$/;
			    if (patrn.test(value)) {
			        return true;
			    } else {
			        return false;
			    }
			}
			
			//检查小数的数字格式
			function checkFloatNumber(value) {
			    var patrn = /^(-)?[0-9]*(.[0-9]{1,3})?$/;
			    if (patrn.test(value)) {
			        return true;
			    } else {
			        return false;
			    }
			}
			
			//显示提示信息
			function showMsgText(obj, text){
				$(obj).tips({
					side:3,
		            msg:text,
		            bg:'#AE81FF',
		            time:1
		        });
				//$(obj).focus();
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
			
			//显示部门人员选择页面
			function deptAndEmp(obj){
		        alert('不支持此步骤的人员选择，请通过电脑端浏览器进行处理');
		    }
		</script>
