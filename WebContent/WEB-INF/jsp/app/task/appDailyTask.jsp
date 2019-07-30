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
        <title>任务详情</title>
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
        <style type="text/css">
            #zhognxin td {
                height: 35px;
            }
            
            #zhognxin td label {
                text-align: left;
                margin-right: 10px;
            }
            #zhongxin td input{
                width: 90%;
                padding: 4px 0;
            }
            .progress{
                width: 90%;
            }
            .success{
                background-color:#55b83b
            }
            .warning{
                background-color:#d20b44
            }
            .tab-content{
                padding: 0;
            }
            .nav-tabs>li>a{
                color: white;
            }
            .keytask{
                width:100%;
                padding: 0;
            }
            .keytask table{
                width:98%;
                margin:0 auto;
            }
            .keytask table tr td {
            	height:30px; 
                line-height: 1.3;
                word-break: break-word;
                overflow: visible;
                white-space: normal;
            }
            .btn-mini{
                padding: 0 2px;
            }
            .web_footer{
                z-index:11;
            }
            
            #id-input-file-1{
                width: 180px;
                position: absolute;
                left: 0;
            }
            
            #positionDailyForm{margin-top: 8px;}
            
            .ace-file-input{
                width: 90%;
                margin: 0;
                display:inline-block;
                position: relative;
                left: 0;
            }
            .ace-file-multiple{width:90%; margin:10px auto;}
			.ace-file-multiple label{ margin-top:4px; /*height:110px*/}
  			/*设置搜索框样式*/
			.select2-container--default .select2-selection--single{height:20px}
			.select2-container--default .select2-selection--single .select2-selection__rendered{line-height:20px}
			.select2-container--default .select2-selection--single .select2-selection__arrow{height:20px}
			#taskTable tr td{line-height:1.4; height:30px;}
        </style>
        <style type="text/css">
		*{margin:0;padding:0;list-style-type:none;}
		a,img{border:0;}
		body{font:12px/180% Arial, Helvetica, sans-serif;}
		/*quiz style*/
		.quiz{border:solid 1px #ccc;height:270px;width:772px;}
		.quiz h3{font-size:14px;line-height:35px;height:35px;border-bottom:solid 1px #e8e8e8;padding-left:20px;background:#f8f8f8;color:#666;position:relative;}
		.quiz_content{padding-top:10px;padding-left:20px;position:relative;height:205px;}
		.quiz_content .btm{border:none;width:100px;height:33px;background:url(static/images/btn.gif) no-repeat;margin:10px 0 0 64px;display:inline;cursor:pointer;}
		.quiz_content li.full-comment{position:relative;z-index:99;height:41px;}
		.quiz_content li.cate_l{height:24px;line-height:24px;padding-bottom:10px;}
		.quiz_content li.cate_l dl dt{float:left;}
		.quiz_content li.cate_l dl dd{float:left;padding-right:15px;}
		.quiz_content li.cate_l dl dd label{cursor:pointer;}
		.quiz_content .l_text{height:120px;position:relative;padding-left:18px;}
		.quiz_content .l_text .m_flo{float:left;width:47px;}
		.quiz_content .l_text .text{width:634px;height:109px;border:solid 1px #ccc;}
		.quiz_content .l_text .tr{position:absolute;bottom:-18px;right:40px;}
		/*goods-comm-stars style*/
		.goods-comm{height:41px;position:relative;z-index:7;}
		.goods-comm-stars{line-height:25px;padding-left:12px;height:41px;position:absolute;top:0px;left:0;width:400px;}
		.goods-comm-stars .star_l{float:left;display:inline-block;margin-right:5px;display:inline;}
		.goods-comm-stars .star_choose{float:left;display:inline-block;}
		/* rater star */
		.rater-star{position:relative;list-style:none;margin:0;padding:0;background-repeat:repeat-x;background-position:left top;float:left;}
		.rater-star-item, .rater-star-item-current, .rater-star-item-hover{position:absolute;top:0;left:0;background-repeat:repeat-x;}
		.rater-star-item{background-position: -100% -100%;}
		.rater-star-item-hover{background-position:0 -48px;cursor:pointer;}
		.rater-star-item-current{background-position:0 -48px;cursor:pointer;}
		/*.rater-star-item-current.rater-star-happy{background-position:0 -25px;}
		.rater-star-item-hover.rater-star-happy{background-position:0 -25px;}
		.rater-star-item-current.rater-star-full{background-position:0 -72px;}*/
		/* popinfo */
		.popinfo{display:none;position:absolute;top:30px;/*background:url(images/comment/infobox-bg.gif) no-repeat;*/padding-top:8px;width:192px;margin-left:-14px;}
		.popinfo .info-box{border:1px solid #f00;border-top:0;padding:0 5px;color:#F60;background:#FFF;}
		.popinfo .info-box div{color:#333;}
		.rater-click-tips{font:12px/25px;color:#333;margin-left:10px;background:url(images/comment/infobox-bg-l.gif) no-repeat 0 0;width:125px;height:34px;padding-left:16px;overflow:hidden;}
		.rater-click-tips span{display:block;background:#FFF9DD url(images/comment/infobox-bg-l-r.gif) no-repeat 100% 0;height:34px;line-height:34px;padding-right:5px;}
		.rater-star-item-tips{background:url(images/comment/star-tips.gif) no-repeat 0 0;height:41px;overflow:hidden;}
		.cur.rater-star-item-tips{display:block;}	
		.rater-star-result{color:#FF6600;font-weight:bold;padding-left:10px;float:left;}

		</style>
        <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
        
    </head>
    <body>
        <div class="web_title">
            <!-- 返回 -->
<%--             <div class="back" style="top:5px">
                <c:choose>
                    <c:when test="${empty pd.showDept }">
                        <a href="<%=basePath %>app_task/listDesk.do?loadType=${pd.loadType }">
                    </c:when>
                    <c:otherwise>
                        <a href="<%=basePath %>app_task/listBoard.do?loadType=${pd.loadType }">
                    </c:otherwise>
                </c:choose>
                
                <img src="static/app/images/left.png" /></a>
            </div> --%>
            <!-- tab页 -->
            <div class="web_menu" style="width:90%; margin-left:20px;">
                <ul id="myTab" class="nav nav-tabs">
                    <li class="active"style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#taskList" data-toggle="tab">工作列表</a></li>
	                <li style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#selfDiv" data-toggle="tab">员工自评</a></li>
	                <li style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#commentList" data-toggle="tab">批示列表</a></li>
                </ul>
           </div>
           
        </div>
        <c:if test="${pd.show!=1 &&  task.status!='YW_YPJ'}">
        	<div id="normal" class="normal" style="width: 100%; height:29px;">
                <c:if test="${pd.show==2 && (empty task.status || task.status=='YW_CG'|| task.status=='YW_YTH') }"><!-- 员工日清 -->
                    <%--<form action="app_task/saveFile.do" name="positionDailyForm" id="positionDailyForm" method="post" enctype="multipart/form-data">
	                    <input type="hidden" name="daily_task_id" id="daily_task_id" value="${task.ID}"/>
	                    <input type="file" name="file" id="id-input-file-1" style="width: 180px;"/>
	                    <a class="btn btn-mini btn-info" onclick="upload();" id="uploadBtn" data-toggle="collapse" href="#fileTab">上传附件</a>
                    </form>
                    --%>
                   
                    <a style="margin-right:85px;  position: absolute; right: 0; top: 42px; width: 30px;"
                    	class="btn btn-mini btn-info" data-toggle="collapse" href="#uploadFileTab" id="uploadBtn">附件</a>
                    <a style="margin-right:45px;  position: absolute; right: 0; top: 42px; width: 30px;"
                    	class="btn btn-mini btn-info" onclick="save('${task.ID}');" id="saveBtn">保存</a>
                    <a style="margin-right:5px;  position: absolute; right: 0; top: 42px; width: 30px;"
                    	class="btn btn-mini btn-info" onclick="submit('${task.ID}');" id="submitBtn">提交</a>
                </c:if>
<%--                 <c:if test='${pd.show==3 && status == "1"&& empty infoList}'>
                	<div id="normal" class="normal" style="width: 100%;text-align: right">
						<a class='btn btn-mini btn-primary' data-toggle="collapse" href="#commentTab" style="margin: 3px 10px;">批示和评分</a>
					</div>
                </c:if> --%>
                <c:if test="${pd.show==3 }">
                	<div id="normal" class="normal" style="width: 100%;text-align: right;position:absolute;">
					<c:if test="${task.status == 'YW_YSX'}">
		    	 		<a class="btn btn-mini btn-info" onclick="passAll();" style="margin:3px 0px">审核通过</a>
		    	 		<a class="btn btn-mini btn-info" data-toggle="collapse" href="#commonTab" style="margin:3px">审核退回</a>
		    	 	</c:if>
		    	 	<c:if test="${status == '1' && task.status == 'YW_YWB' && empty positionDailyTask.SCORE}">
		    	 		<a class='btn btn-mini btn-primary' data-toggle="collapse" href="#commentTab" style="margin:3px">批示和评分</a>
		    	 	</c:if>
		    	 	</div>
		    	 </c:if>
           	</div>
        </c:if>
        
        <div id="uploadFileTab" class="panel-collapse collapse" style="width:98%; margin:0 auto">
        	<div id="fileDiv" style="width: 98%; margin: 5px auto;">
            	<c:forEach items="${fileList }" var="perFile" varStatus="vs">
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
			            		<c:if test="${currentEmpCode == task.EMP_CODE && (task.status=='YW_CG' || task.status=='YW_YTH') }">
			            			<a style="margin-left:5px;" onclick="delFile('${perFile.ID}', this)">删除</a>
			            		</c:if>
		            		</td>
		            	</tr>
	            	</table>
            	</c:forEach>
        	</div>
    	    
        	
            <form action="app_task/saveFile.do" name="positionDailyForm" id="positionDailyForm" method="post" 
            	enctype="multipart/form-data">
            	<!-- 
            	<c:if test="${not empty task.FILENAME}">
            		<div>
            			<label style="float:left; width:80px">已上传附件：</label>
            			<a style="cursor:pointer;color:#599ad2" title="${task.FILENAME}"  
                    		onclick="loadFile('${task.FILENAME_SERVER}')">${task.FILENAME}</a>
            		</div>
           			
           		</c:if>
            	 -->
            	
            	<table style="width: 98%; margin: 5px auto;">
            		<tr>
            			<td style="width:80%">
            				<input type="hidden" name="daily_task_id" id="daily_task_id" value="${task.ID}"/>
			                <input multiple type="file" name="files" id="id-input-file-1" style="width: 180px;"/>
			                
            			</td>
            			<td>
            				<!-- 
            				<a class='btn btn-mini btn-primary' style="width:30px;margin-bottom:15px " onclick="upload();" 
            					data-toggle="collapse" href="#uploadFileTab">上传</a>
            				 -->
            				<a class='btn btn-mini btn-primary' style="width:30px;margin-bottom:15px " 
            					onclick="upload();" >上传</a>
            			</td>
            		</tr>
            	</table>
            </form>

        </div>
        
        <div id="commentTab" class="panel-collapse collapse" >
              <form action="app_task/saveManageComment.do" id="commentForm" method="post">
                  <table style="width: 98%; margin: 5px auto;">
                      <tr>
                      	<td style="width:70px;"><label>批示内容:</label></td>
                          <td>
                          	  <input type="hidden" name="commitFromPage" value="dailyTask" />
                              <input type="hidden" name="manageId" value="${task.ID}"/>
                              <input type="hidden" name="EMP_CODE" value="${task.EMP_CODE }">
                              <input type="text" name="comment" id="comment" value="通过"/>
                          </td>
                      </tr>
                      <tr>
                      	<td style="width:70px;"><label>分数:</label></td>
                      	<td>
                      	<!-- 
                      		<span class="rater-star" id= "rate-comm-1" >${projectEvent.SCORE }</span>
	                      	<input type="hidden" name="score" id="score" value="${projectEvent.SCORE}" 
	                      		maxlength="32" style="width:50px;"  readonly>
                      	 -->
	                      	<input style="margin-top:2px;" type="text" name="score" id="score" value="${projectEvent.SCORE}"
	                      		placeholder="请输入分数（50~100）" />
                      	</td>
                      </tr>
                      <tr>
                       <td colspan="2">
							<a class='btn btn-mini btn-primary' style="margin-top: 10px;margin-bottom:10px;margin-left: 70px;" 
								onclick="addComment();" >保存</a>
						</td>
					</tr>
                  </table>
              </form>
        </div>
        <div id="commonTab" class="panel-collapse collapse">
              <form action="app_task/auditAllPositionDailyTask.do?flgId=${task.ID}&status=YW_YTH&DAILY_TASK_EMP_CODE=${task.EMP_CODE}" id="commonForm" method="post">
                  <table style="width: 98%; margin: 5px auto;">
                  	<tr>
                  		<td style="width:75px;"><span style="color:red">*</span>退回意见：</td>
						<td><textarea id="OPINION" name="OPINION" rows="4" cols="2" maxlength="255"></textarea></td>
                  	</tr>
                  	<tr>
                       <td colspan="2">
							<a class='btn btn-mini btn-primary' style="margin-top: 10px;margin-bottom:10px;margin-left: 70px;" onclick="unpassAll();"
								data-toggle="collapse" href="#commonTab">确定</a>
						</td>
					</tr>
                  </table>
              </form>
        </div>
        
        
        <div id="zhongxin" style="width:98%; margin: 1px auto; border:none" class="tab-content">
        	<!-- 员工自评 -->
	        <div class="tab-pane fade" id="selfDiv" style="margin:0 auto; text-align:center">
	        	<textarea id="EVALUATION" name="EVALUATION" style="width:94%; margin:5px auto; height:70px;"
		    	 	<c:if test="${task.status!='YW_CG' && task.status!='YW_YTH'}">readonly</c:if> >${task.EVALUATION }</textarea>
	        </div>
            <!-- 员工信息 -->
            <div class="tab-pane fade in active" id="taskList">
                <div class="keytask">
				    <div>
				        <table id="taskTable" style="margin:5px auto">
				            <tr>
				            	<td style="width:50px">姓名:</td>
				                <td>${task.EMP_NAME }</td>
				                <td style="width:50px">日期:</td>
				                <td>${task.datetime }</td>
				            </tr>
				            <tr>
				               <td style="width:50px">部门:</td>
				               <td>${task.EMP_DEPARTMENT_NAME}</td>
				               <td style="width:50px">岗位:</td>
				               <td>${task.EMP_GRADE_NAME}</td>
				            </tr>
				            <tr>
				            	<td>评价人:</td>
				            	<td>
				            		<c:choose>
					         			<c:when test="${task.status=='YW_CG' || task.status=='YW_YTH'}">
					         				<select id="checkEmpCode" name="checkEmpCode" style="width:90px; height:27px">
												<option value="">请选择</option>
												<c:forEach items="${empList }" var="emp">
													<option value="${emp.EMP_CODE }" <c:if test="${emp.EMP_CODE==task.SCOREPERSON }">selected</c:if>>${emp.EMP_NAME }</option>
												</c:forEach>
											</select>
					         			</c:when>
					         			<c:otherwise>
					         				${task.CHECK_EMP_NAME}
					         			</c:otherwise>
					         		</c:choose>
				            	</td>
				            	<c:if test="${not empty task.SCORE}">
				            		<td>评分:</td>
				                	<td>${task.SCORE}</td>
				            	</c:if>
				            </tr>
				            <c:if test="${task.status=='YW_YTH'}">
				            <tr>
				                <td>退回意见：</td>
				                <td>${task.OPINION}</td>
				            </tr>
				            </c:if>
				        </table>
				    </div>
				</div>
				<!-- 工作列表 -->
                <c:choose>
                    <c:when test="${not empty detailList }">
                        <c:forEach items="${detailList }" var="empTask" varStatus="vs">
	                            
	                            <c:choose>
	                            <c:when test="${pd.show==2 && pd.allowChangTime==true && (task.status=='YW_CG'|| task.status=='YW_YTH')}">
	                            	<div class="keytask">
	                            	<table>
	                                    <tr>
	                                        <td style="width:70px">岗位职责:</td>
	                                        <td colspan="3" style="width:70%">${empTask.responsibility}</td>
	                                    </tr>
	                                    <tr>
	                                        <td style="width:70px">工作明细:</td>
	                                       <td colspan="3">
	                                    	<a onclick="changeTime($(this))" style="cursor:pointer;color: red;" >${empTask.detail}</a>
	                               			</td>
	                                		<input type="hidden" name="START_TIME_ARR" value='${empTask.START_TIME_ARR}' />
					                        <input type="hidden" name="END_TIME_ARR" value='${empTask.END_TIME_ARR}' />
	                                    </tr>
	                                    <tr>
	                                        <td style="width:60px">工作要求:</td>
	                                        <td style="width:85px" colspan="3">${empTask.requirement}</td>
	                                    </tr>
	                                    <tr>
	                                        <td style="width:60px">工作指南:</td>
	                                        <td style="width:85px" colspan="3">${empTask.guide}</td>
	                                    </tr>
	                                    <tr>
	                                    	<td style="width:60px">实际时间:</td>
	                                        <td style="width:85px">${empTask.totalTime}${empTask.unit}</td>
	                                        <td style="width:60px">标准时间:</td>
	                                        <td style="width:85px">${empTask.standard_time}${empTask.unit}</td>
	                                    </tr>
	                                    <tr>
	                                        <td>当天次数:</td>
	                                        <td colspan="3"><span>${empTask.count}</span></td>
	                                    </tr>
	                                    <!-- 
	                                     <tr>
	                                        <td>审核人:</td>
	                                        <td ><c:if test="${not empty empTask.statusName && empTask.statusName!='草稿' }">${empTask.UPDATE_USER_NAME }</c:if></td>
	                                    </tr>
	                                    <tr>
	                                        <td>状态:</td>
	                                        <td ><span>${empTask.statusName}</span></td>
	                                    </tr>
	                                     -->
	                                   
			                        	<tr>
			                        		<td>操作:</td>
			                        		<td colspan="3">
			                        			<a style="cursor:pointer;" title="维护时间" onclick="changeTimeByWorker($(this))" class='btn btn-mini btn-info' data-rel="tooltip" 
			                                    	data-placement="left"> 维护时间 <i class="icon-exchange"></i>
			                                    </a>
			                        		</td>
			                        		<input type="hidden" name="po_detail_id" value="${empTask.taskDetailID}"/>
			                        		<input type="hidden" name="detail_id" value="${empTask.ID}"/>
				                            <input type="hidden" name="START_TIME_ARR" value='${empTask.START_TIME_ARR}' />
				                            <input type="hidden" name="END_TIME_ARR" value='${empTask.END_TIME_ARR}' />
			                        	</tr>
	                                </table>
	                                </div>
	                            </c:when>
	                            <c:otherwise>
	                            	<c:if test="${not empty empTask.count}">
	                            	<div class="keytask">
	                            		<table>
		                                    <tr>
		                                        <td style="width:70px">岗位职责:</td>
		                                        <td style="">${empTask.responsibility}</td>
		                                    </tr>
		                                    <tr>
		                                        <td style="width:70px">工作明细:</td>
		                                       <td>
		                                    	<a onclick="changeTime($(this))" style="cursor:pointer;color: red;" >${empTask.detail}</a>
		                               			</td>
		                                		<input type="hidden" name="START_TIME_ARR" value='${empTask.START_TIME_ARR}' />
						                        <input type="hidden" name="END_TIME_ARR" value='${empTask.END_TIME_ARR}' />
		                                    </tr>
		                                    <tr>
		                                        <td>工作要求:</td>
		                                        <td>${empTask.requirement}</td>
		                                    </tr>
		                                    <tr>
		                                        <td>工作指南:</td>
		                                        <td>${empTask.guide}</td>
		                                    </tr>
		                                    <tr>
		                                    	<td style="width:70px">标准时间:</td>
		                                        <td>${empTask.standard_time}${empTask.unit}</td>
		                                    </tr>
		                                    <tr>
		                                    	<td>实际时间:</td>
		                                        <td>${empTask.totalTime}${empTask.unit}</td>
		                                    </tr>
		                                    <tr>
		                                        <td>当天次数:</td>
		                                        <td ><span>${empTask.count}</span></td>
		                                    </tr>
		                                    <!-- 
		                                     <tr>
		                                        <td>审核人:</td>
		                                        <td><c:if test="${not empty empTask.statusName && empTask.statusName!='草稿' }">${empTask.UPDATE_USER_NAME }</c:if></td>
		                                    </tr>
		                                    <tr>
		                                        <td>状态:</td>
		                                        <td ><span>${empTask.statusName}</span></td>
		                                    </tr>
		                                     -->
		                                   
					                        		<input type="hidden" name="po_detail_id" value="${empTask.taskDetailID}"/>
					                        		<input type="hidden" name="detail_id" value="${empTask.ID}"/>
						                            <input type="hidden" name="START_TIME_ARR" value='${empTask.START_TIME_ARR}' />
						                            <input type="hidden" name="END_TIME_ARR" value='${empTask.END_TIME_ARR}' />
		                                </table>
		                                </div>
	                            	</c:if>
	                            </c:otherwise>
	                            </c:choose>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <span>没有数据</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- 批示列表 -->
            <div class="tab-pane fade" id="commentList">
                <c:choose>
                    <c:when test="${not empty infoList}">
                        <c:forEach items="${infoList}" var="comment" varStatus="vs">
                            <div class="keytask">
                                <table>
                                    <tr>
                                        <td style="width:70px">添加时间:</td>
                                        <td><span>${comment.create_time }</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>批示内容:</td>
                                        <td><span>${comment.comments }</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>批示人:</td>
                                        <td><span>${comment.create_user }</span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr class="main_info">
                            <td colspan="100" class="center">没有相关数据</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <!-- 引入 -->
        <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
       
        <script src="static/js/bootstrap.min.js"></script>
        <script src="static/js/ace-elements.min.js"></script>
        <script src="static/js/ace.min.js"></script>
        
        <script type="text/javascript" src="static/js/jquery-form.js"></script>
        <script src="static/js/ajaxfileupload.js"></script>
        <script type="text/javascript" src="static/js/jquery.tips.js"></script>
        <script src="static/select2/select2.min.js"></script>
        
        <script type="text/javascript">
           $(function(){
                $("#id-input-file-1").ace_file_input({
                	style:'well',
                    no_file:'请选择文件',
                    btn_choose:'选择文件',
                    btn_change:'修改',
                    no_icon:'icon-cloud-upload',
                    droppable:false,
                    onchange:null,
                    thumbnail:false,
                    whitelist:'xls|xls',
                    blacklist:'gif|png|jpg|jpeg'
                });
                $("#checkEmpCode").select2();
            })
            
            //上传附件
            function upload(){
                if($("#id-input-file-1").val() == null || $("#id-input-file-1").val() == ""){
                    alert("上传文件不允许为空");
                    return false;
                }
                
                var options = {
                    success: function(data){
                    	//window.location.reload();
                        //alert("保存成功");
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
								taskId: $("#daily_task_id").val(),
								taskType: 'D'
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
										if('${currentEmpCode}'=='${task.EMP_CODE}' &&
								       			('${task.status}'=='YW_CG' || '${task.status}'=='YW_YTH')){
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
                $("#positionDailyForm").ajaxSubmit(options);
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
            
			//删除文件
			function delFile(fileId, obj){
				$.ajax({
					type: "post",
					dataType:"text",
					data:{"fileId": fileId},
					url: '<%=basePath%>app_task/deleteFileById.do',
					success: function(data){
						if(data=="error"){
							alert("后台出错，请联系管理员！");
						}else if(data=="success"){
							$("#fileTable_"+fileId).remove();
						}
					}
				});
			}
        
         	//检查字段长度
         	function checkEvaluation(){
         		if(null != $("#EVALUATION").val() && $("#EVALUATION").val().length>500){
	       			$("#EVALUATION").tips({
	       				side:3,
	       	            msg:'超出限定长度，请重新填写！',
	       	            bg:'#AE81FF',
	       	            time:2
	       	        });
	       			$("#EVALUATION").focus();
	       			return false;
	       		}
         		return true;
         	}
         	
         	//保存按钮
         	function save(manageId){
         		if($("#checkEmpCode").val()=="" && $("#EVALUATION").val()==""){
         			return;
         		}
         		if(!checkEvaluation()){
                	return false;
                }
         		//请求地址
         		var path = "<%=basePath%>app_task/savePositionDailyTask.do?daily_task_id=" + manageId;
         		if($("#EVALUATION").val()!=""){
         			path += "&EVALUATION=" + $("#EVALUATION").val();
         		}
         		if($("#checkEmpCode").val()!=""){
         			
         			if($("#checkEmpCode").val()==""){
        	    		$("#checkEmpCode").tips({
        					side:3,
        		            msg:'请选择！',
        		            bg:'#AE81FF',
        		            time:2
        		        });
        				$("#checkEmpCode").focus();
        				return false;
        	    	}
         			path += "&checkEmpCode=" + $("#checkEmpCode").val();
         			path += "&checkEmpName=" + $("#checkEmpCode option:selected").text();
         		}
         		$.ajax({
                    type: "POST",
                    async: false,
                    url: path,
                    success: function(data){
                    	if(data == "success"){
                            alert("保存成功!");
                            window.location.reload();
                        }else{
                            alert("保存失败!");
                            return;
                        }
                    }
                }); 
         	}
                       
         	//提交按钮
         	function submit(manageId){
         		if($("#id-input-file-1").val()){
    				alert('请先上传附件');
    				return;
    			}
         		if($("#checkEmpCode").val()==""){
            		$("#checkEmpCode").tips({
        				side:3,
        	            msg:'请选择评价人！',
        	            bg:'#AE81FF',
        	            time:2
        	        });
        			$("#checkEmpCode").focus();
        			return false;
            	}
            	if(!checkEvaluation()){
                	return false;
                }
                $.ajax({
                    type: "POST",
                    async: false,
                    url: "<%=basePath%>app_task/checkDetailStatus.do?manageId=" + manageId,
                    success: function(data){
                    	//判断返回结果
        				var alertMsg = '';
        				if('error'==data){
        					alertMsg = '后台出错，请联系管理员！';
        				}else if('nodata'==data){
        					alertMsg = '没有添加工作时间，不能提交！';
        				}else if(data!='0'){
        					alertMsg = '还有未结束的日清助手，不能提交！';
        				}
        				//不能提交，则返回信息
        				if(''!=alertMsg){
        					alert(alertMsg);
        					return;
        				}
        				
                        if(confirm("确定要提交？")){
                        	var EVALUATION = encodeURI(encodeURI($("#EVALUATION").val()));//自评
    						var checkEmpCode = $("#checkEmpCode").val();//评价人
                            $.ajax({
                                type: "POST",
                                async: false,
                                url: "<%=basePath%>app_task/submitInfo.do?manageId=" + manageId +"&EVALUATION=" + EVALUATION +
									"&SCOREPERSON=" + checkEmpCode,
                                success: function(data){
                                    if(data == "success"){
                                        alert("提交成功!");
                                        //window.location.reload();//这个url是add.do会在系统中重复添加日常，不能这样写
                                        window.location="<%=basePath%>app_task/listDesk.do?loadType=D";
                                    }else{
                                        alert("提交失败!");
                                        return;
                                    }
                                }
                            });
                        }
                    }
                }); 
            }
            
           	
            //添加日常工作评价
            function addComment(){
            	//评分
    			var socreMsg = '';
    			if(null == $("#score").val() || $("#score").val() == ""){
    				socreMsg = '请输入分数（50~100）';
    			}else if(!/^[5-9][0-9]$|^100$/.test($("#score").val())){
    				socreMsg = '请输入分数（50~100）';
    			}
    			if(socreMsg!=''){
    				$("#score").tips({
    					side:3,
    		            msg: socreMsg,
    		            bg:'#AE81FF',
    		            time:2
    		        });
    				$("#score").focus();
    				return false;
    			}
            	if($("#comment").val() == null || $("#comment").val() == ""){
                    $("#comment").tips({
    					side:3,
    		            msg: "请填写内容",
    		            bg:'#AE81FF',
    		            time:2
    		        });
    				$("#comment").focus();
    				return false;
                    return false;
                }
            	
            	var options = {
                        success: function(data){
                        	if(data == "success"){
                        		alert("保存成功");
                        		window.location.href="<%=basePath%>app_task/listBoard.do?loadType=D";
                        	} 
                        },
                        error: function(data){
                            alert("保存出错");
                        }
                    };
            	
            	$("#commentForm").ajaxSubmit(options);
            }
             //维护时间
    function changeTime(obj){
        var url = '<%=basePath%>app_task/showTime.do?Date=' + '<fmt:formatDate value="${task.datetime}" type="date"/>';
        url += '&START_TIME_ARR=' + $(obj).parent().siblings("input[name='START_TIME_ARR']").val();
        url += '&END_TIME_ARR=' + $(obj).parent().siblings("input[name='END_TIME_ARR']").val();
        url += '&taskStatus=${task.status}';
        //保存搜索的参数
			var param = "&manageId=${pd.manageId}";
			if('${pd.startDate}'!=''){
				param += "&startDate=" + '${pd.startDate}';
			} 
			if('${pd.endDate}'!=''){
				param += "&endDate=" + '${pd.endDate}';
			}
			if('${pd.productCode}'!=''){
				param += "&productCode=" + '${pd.productCode}';
			}
			if('${pd.projectCode}'!=''){
				param += "&projectCode=" + '${pd.projectCode}';
			}
			if('${pd.flowName}'!=''){
				param += "&flowName=" + '${pd.flowName}';
			}
			if('${pd.tempTaskName}'!=''){
				param += "&tempTaskName=" + '${pd.tempTaskName}';
			}
			param += "&show=" + '${pd.show}' + "&showDept=${pd.showDept}&loadType=${pd.loadType}";
			//保存日清工作台参数
			if('${pd.show}'==3){
				param += "&deptCode=" + '${pd.deptCode}' + "&empCode=" + '${pd.empCode}';
			}else{
				param +="&empCode=${pd.empCode}";
			}
			//保存页数
			param += "&currentPage=" + '${pd.currentPage}';
        window.location.href = url+param;
    }
		  //车间人员维护时间
		    function changeTimeByWorker(obj){
		        var url = '<%=basePath%>app_task/changeTimeByWorker.do?Date=' + '<fmt:formatDate value="${task.datetime}" type="date"/>';
		        url += '&START_TIME_ARR=' + $(obj).parent().siblings("input[name='START_TIME_ARR']").val();
		        url += '&END_TIME_ARR=' + $(obj).parent().siblings("input[name='END_TIME_ARR']").val();
		        url += '&taskStatus=${task.status}&daily_task_id=${task.ID}'+'&detail_id='+$(obj).parent().siblings("input[name='detail_id']").val();
		        url +='&ID='+$(obj).parent().siblings("input[name='po_detail_id']").val();
		        //保存搜索的参数
					var param = "&manageId=${pd.manageId}";
					if('${pd.startDate}'!=''){
						param += "&startDate=" + '${pd.startDate}';
					} 
					if('${pd.endDate}'!=''){
						param += "&endDate=" + '${pd.endDate}';
					}
					if('${pd.productCode}'!=''){
						param += "&productCode=" + '${pd.productCode}';
					}
					if('${pd.flowName}'!=''){
						param += "&flowName=" + '${pd.flowName}';
					}
					if('${pd.tempTaskName}'!=''){
						param += "&tempTaskName=" + '${pd.tempTaskName}';
					}
					param += "&show=" + '${pd.show}' + "&showDept=${pd.showDept}&loadType=${pd.loadType}";
					//保存日清工作台参数
					if('${pd.show}'==3){
						param += "&deptCode=" + '${pd.deptCode}' + "&empCode=" + '${pd.empCode}';
					}else{
						param +="&empCode=${pd.empCode}";
					}
					//保存页数
					param += "&currentPage=" + '${pd.currentPage}';
		        window.location.href = url+param;
		    }
        </script>
        <script type="text/javascript">
		// star choose
		jQuery.fn.rater	= function(options) {
			var ss = $("#score").val();
			var isUsed = true;
			/* if('${projectEvent.SCORE}' == null || '${projectEvent.SCORE}' == "" || '${projectEvent.SCORE}' == undefined ){
				isUsed = true;
			}else{
				isUsed = false;
			} */
			// 默认参数
			var settings = {
				enabled	: isUsed,
				url		: '',
				method	: 'post',
				step    : 1,
				min		: 1,
				max		: 5,
				value	: ss,
				after_click	: null,
				before_ajax	: null,
				after_ajax	: null,
				title_format: null,
				info_format	: null,
				image	: 'static/images/stars.jpg',
				imageAll :'WebRoot/static/images/stars-all.gif',
				defaultTips :false,
				clickTips :false,
				width	: 24,
				height	: 24
			}; 
			
			// 自定义参数
			if(options) {  
				jQuery.extend(settings, options); 
			}
			
			//外容器
			var container	= jQuery(this);
			
			// 主容器
			var content	= jQuery('<ul class="rater-star"></ul>');
			content.css('background-image' , 'url(' + settings.image + ')');
			content.css('height' , settings.height);
			content.css('width' , (settings.width*settings.step) * (settings.max-settings.min+settings.step)/settings.step);
			// 当前选中的
			var item	= jQuery('<li class="rater-star-item-current"></li>');
			item.css('background-image' , 'url(' + settings.image + ')');
			item.css('height' , settings.height);
			item.css('width' , 0);
			item.css('z-index' , settings.max / settings.step + 1);
			if (settings.value) {
				item.css('width' , ((settings.value-settings.min)/settings.step+1)*settings.step*settings.width);
			};
			content.append(item);
		
			
			// 星星
			for (var value=settings.min ; value<=settings.max ; value+=settings.step) {
				item	= jQuery('<li class="rater-star-item"><div class="popinfo"></div></li>');
				if (typeof settings.info_format == 'function') {
					//item.attr('title' , settings.title_format(value));
					item.find(".popinfo").html(settings.info_format(value));
					item.find(".popinfo").css("left",(value-1)*settings.width)
				}
				else {
					item.attr('title' , value);
				}
				item.css('height' , settings.height);
				item.css('width' , (value-settings.min+settings.step)*settings.width);
				item.css('z-index' , (settings.max - value) / settings.step + 1);
				item.css('background-image' , 'url(' + settings.image + ')');
				
				if (!settings.enabled) {	// 若是不能更改，则隐藏
					item.hide();
				}
				
				content.append(item);
			}
			
			content.mouseover(function(){
				if (settings.enabled) {
					jQuery(this).find('.rater-star-item-current').hide();
				}
			}).mouseout(function(){
					jQuery(this).find('.rater-star-item-current').show();
			})
			// 添加鼠标悬停/点击事件
			var shappyWidth=(settings.max-2)*settings.width;
			var happyWidth=(settings.max-1)*settings.width;
			var fullWidth=settings.max*settings.width;
			content.find('.rater-star-item').mouseover(function() {
				jQuery(this).prevAll('.rater-star-item-tips').hide();
				jQuery(this).attr('class' , 'rater-star-item-hover');
				//jQuery(this).find(".popinfo").show();
				
				/*//当3分时用笑脸表示
				if(parseInt(jQuery(this).css("width"))==shappyWidth){
					jQuery(this).addClass('rater-star-happy');
				}
				//当4分时用笑脸表示
				if(parseInt(jQuery(this).css("width"))==happyWidth){
					jQuery(this).addClass('rater-star-happy');
				}
				//当5分时用笑脸表示
				if(parseInt(jQuery(this).css("width"))==fullWidth){
					jQuery(this).removeClass('rater-star-item-hover');
					jQuery(this).css('background-image' , 'url(' + settings.imageAll + ')');
					jQuery(this).css({cursor:'pointer',position:'absolute',left:'0',top:'0'});
				}*/
			}).mouseout(function() {
				var outObj=jQuery(this);
				outObj.css('background-image' , 'url(' + settings.image + ')');
				outObj.attr('class' , 'rater-star-item');
				outObj.find(".popinfo").hide();
				//outObj.removeClass('rater-star-happy');
				jQuery(this).prevAll('.rater-star-item-tips').show();
				//var startTip=function () {
				//outObj.prevAll('.rater-star-item-tips').show();
				//};
				//startTip();
			}).click(function() {
				//jQuery(this).prevAll('.rater-star-item-tips').css('display','none');
				jQuery(this).parents(".rater-star").find(".rater-star-item-tips").remove();
				jQuery(this).parents(".goods-comm-stars").find(".rater-click-tips").remove();
				jQuery(this).prevAll('.rater-star-item-current').css('width' , jQuery(this).width());
				   if(parseInt(jQuery(this).prevAll('.rater-star-item-current').css("width"))==happyWidth||parseInt(jQuery(this).prevAll('.rater-star-item-current').css("width"))==shappyWidth){	
					jQuery(this).prevAll('.rater-star-item-current').addClass('rater-star-happy');
					}
				else{
					jQuery(this).prevAll('.rater-star-item-current').removeClass('rater-star-happy');
					}
					if(parseInt(jQuery(this).prevAll('.rater-star-item-current').css("width"))==fullWidth){	
					jQuery(this).prevAll('.rater-star-item-current').addClass('rater-star-full');
					}
				else{
					jQuery(this).prevAll('.rater-star-item-current').removeClass('rater-star-full');
					}
				var star_count		= (settings.max - settings.min) + settings.step;
				var current_number	= jQuery(this).prevAll('.rater-star-item').size()+1;
				var current_value	= settings.min + (current_number - 1) * settings.step;
				
				//显示当前分值
				if (typeof settings.title_format == 'function') {
					jQuery(this).parents().nextAll('.rater-star-result').html(current_value+'分&nbsp;'+settings.title_format(current_value));
				}
				$("#score").val(current_value);
				//jQuery(this).parents().next('.rater-star-result').html(current_value);
				//jQuery(this).unbind('mouseout',startTip)
			})
			
			jQuery(this).html(content);
			
		}
		
		// 星星打分
		$(function(){
			var options	= {
			max	: 5,
			title_format	: function(value) {
				var title = '';
				switch (value) {
					case 1 : 
						title	= '很不满意';
						break;
					case 2 : 
						title	= '不满意';
						break;
					case 3 : 
						title	= '一般';
						break;
					case 4 : 
						title	= '满意';
						break;
					case 5 : 
						title	= '非常满意';
						break;
					default :
						title = value;
						break;
				}
				return title;
			},
			info_format	: function(value) {
				var info = '';
				switch (value) {
					case 1 : 
						info	= '<div class="info-box">1分&nbsp;很不满意<div>商品样式和质量都非常差，太令人失望了！</div></div>';
						break;
					case 2 : 
						info	= '<div class="info-box">2分&nbsp;不满意<div>商品样式和质量不好，不能满足要求。</div></div>';
						break;
					case 3 : 
						info	= '<div class="info-box">3分&nbsp;一般<div>商品样式和质量感觉一般。</div></div>';
						break;
					case 4 : 
						info	= '<div class="info-box">4分&nbsp;满意<div>商品样式和质量都比较满意，符合我的期望。</div></div>';
						break;
					case 5 : 
						info	= '<div class="info-box">5分&nbsp;非常满意<div>我很喜欢！商品样式和质量都很满意，太棒了！</div></div>';
						break;
					default :
						info = value;
						break;
				}
					return info;
				}
			}
			$('#rate-comm-1').rater(options);
		});
		//批量审核通过
		function passAll(){
				if(confirm("确定通过？")){
					var url = "<%=basePath%>app_task/auditAllPositionDailyTask.do?flgId=${task.ID}&status=YW_YSX" + 
						"&DAILY_TASK_EMP_CODE=${task.EMP_CODE}";
					$.get(url,function(data){
						if(data == "success"){
							alert("审核成功！");
							window.location.reload();
						}else{
							alert("审核失败！");
						}
					},"text");
				}
				
		}
		//批量退回
		function unpassAll(){
			if($("#OPINION").val() == null || $("#OPINION").val() == ""){
                alert("退回意见不允许为空");
                return false;
            }
        	
        	var options = {
                    success: function(data){
                    	if(data == "success"){
                    		alert("保存成功");
                    		window.location.reload();
                    	} 
                    },
                    error: function(data){
                        alert("保存出错");
                    }
                };
        	
        	$("#commonForm").ajaxSubmit(options);
	     }

	</script>
        <div>
            <%@include file="../footer.jsp"%>
        </div>
    </body>
</html>