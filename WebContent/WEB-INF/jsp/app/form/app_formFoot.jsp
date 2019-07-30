<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

		    
			<input id="uploadFiles" name="uploadFiles" type="hidden" value="" /><!-- 用来保存上传的所有附件id -->
		    <div id="commentDiv" style="text-align:center;">
		    	<c:if test="${not empty attachedComments }">
			    	<span>会签</span>
			    	<table id="commentTable" class="table table-bordered" style="margin-bottom:0;" >
			    		<c:forEach items="${attachedComments }" var="workComment" varStatus="vs">
			    			<tr>
			    				<td>
			    					${workComment.STEP_NAME }，${workComment.CREATE_EMPNAME }，${workComment.CREATE_TIME }，
			    					${workComment.COMMENT_TEXT }
			    				</td>
			    			</tr>
			    		</c:forEach>
			    	</table>
		    	</c:if>
		    	
		    	<textarea id="comment" name="comment"  rows="3" cols="1" placeholder="输入会签内容" 
		    		 style="border:1px solid #ddd; "></textarea>
		    	
		    </div>
		    <input type="hidden" id="checkupType" name="checkupType" value="" />
		    <input type="hidden" id="checkupDetail" name="checkupDetail" value="" />
		    <input type="hidden" id="checkupId" name="checkupId" value="${checkupId}" />
		    
			</form>
			
			<div id="fileDiv" style="text-align:center; "><!-- 附件列表 -->
					<span>附件</span>
			    	<table id="fileTable" class="table table-bordered" style="margin-bottom:0;">
			    		<c:forEach items="${attachedFiles }" var="serverFile" varStatus="vs">
			    			<tr>
		                		<td>
		                			${serverFile.STEP_NAME }，${serverFile.CREATE_EMPNAME }，${serverFile.CREATE_DATE }上传
		                			<a style="cursor:pointer;" onclick="loadFile('${serverFile.FILENAME_SERVER}')">${serverFile.FILENAME }</a>
		                			    
		                		</td>
		                		<td>
		                			<c:if test="${serverFile.FORM_WORK_STEP_ID== currentStep.ID && 'Y'!=readonlyRepairOrder }">
		                				<a style="cursor:pointer;" onclick="removeFile(this, ${serverFile.ID})" 
		                					class="noPrint btn btn-mini btn-info delFileBtn">删除</a>
		                			</c:if>
		                			
		                		</td>
		                	</tr>
			    		</c:forEach>
			    	</table>
		    	<div id="fileBtn" class="noPrint">
		    		<input multiple type="file" id="file" name="file" 
			    		style="width:100%; line-height:25px; height:25px; border:1px solid #ccc; " />
			    	<a class="btn btn-mini btn-primary" onclick="uploadFiles();">上传</a>
		    	</div>
		    	
		    </div>
		    
		    <div id="checkupDiv" style="text-align:center; "><!-- 会审记录 -->
				<c:if test="${not empty checkupList }">
					<span>会审记录</span>
			    	<table id="checkupTable" class="table table-bordered" style="margin-bottom:0;">
			    		<c:forEach items="${checkupList }" var="checkup" varStatus="vs">
			    			<tr>
		                		<td style="word-break: break-all;">
		                			<c:if test="${ empty checkup.OPINION_TIME }">
		                				<span>未会审</span>
		                			</c:if>
		                			<span> ${checkup.EMP_NAME } 会审步骤：[${checkup.STEP_NAME }]</span>
		                			<c:if test="${not empty checkup.OPINION_TIME }">
		                				<span>${checkup.OPINION_TIME }</span>
	                    				<span> ${checkup.OPINION_TYPE }</span>
			                    		<c:if test="${not empty checkup.OPINION }">
			                    			<span> 详细意见：${checkup.OPINION }</span>
			                    		</c:if>
		                			</c:if>
		                			
		                    	</td>
		                	</tr>
			    		</c:forEach>
			    	</table>
				</c:if>
		    	<c:if test="${'mineCheck'==isFinishCheckup || 'containsMineCheck'==isFinishCheckup }">
		    		<span>会审：
				    	<input type="radio" name="opinionType" value="不通过" />不通过
		                <input type="radio" name="opinionType" value="通过" checked />通过
			    	</span>
			    	<textarea id="checkupText" name="checkupText"  rows="3" cols="1" placeholder="输入详细会审意见" 
			    		 style="border:1px solid #ddd; width:725px;">同意</textarea>
			    	<c:if test="${readonlyRepairOrder=='Y'}"><!-- 只读表单时 -->
		    			<a id="checkupBtn" class="btn btn-mini btn-primary" onclick="saveCheckup();">保存</a>
		    		</c:if>
		    	</c:if>
		    	
		    </div>
		    
			<div id="operHisDiv" style="text-align:center; "><!-- 操作历史 -->
				<span>操作历史</span>
		    	<table id="operHisTable" class="table table-bordered" >
		    		
		    	</table>
		    </div>
		    
		    <div class=" bottomFloatBtn" style="text-align:center;"><!-- 操作按钮 -->
		    	
	    		<c:if test="${not empty currentStep && currentStep.STEP_LEVEL>1}"><!-- 第一步之后的步骤，才显示退回按钮 -->
	    			<a class="btn btn-mini btn-primary" onclick="showFocusEmp();">转发</a>
	    			<a class="btn btn-mini btn-primary" onclick="showRejectStep();">选择退回</a>
	    			<a class="btn btn-mini btn-primary" onclick="reject();">退回上一步</a>
	    		</c:if>
	    		
		    	<a id="saveBtn" class="btn btn-mini btn-primary" onclick="save();">保存</a>
				<a class="btn btn-mini btn-primary" onclick="commitNext();">
					<c:choose>
						<c:when test="${currentStep.LAST_STEP=='Y' }">结束</c:when>
						<c:otherwise>转交下一步</c:otherwise>
					</c:choose>
				</a>
				<a id="cancelBtn" class="btn btn-mini btn-danger" onclick="toAppFormList();">取消</a>
		    </div>
		    
	    </div>
	    
	    <!-- 抄送人员的模态框（Modal） -->
		<div class="modal fade noPrint" id="focusEmpModal" tabindex="-1" role="dialog" aria-labelledby="focusModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content">
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		                <h4 class="modal-title" id="focusModalLabel">选择人员</h4>
		            </div>
		            <div class="modal-body" style="height:300px; text-align:center;">
		            	<!-- 选择人员 -->
		            	<form action="app_task/saveFocusEmp.do" id="focusEmpForm" method="post">
							<input id="focusEmpFormworkId" type="hidden" name="formWorkId" value="${work.ID }" />
							<input id="focusEmpFormworkStepId" type="hidden" name="formWorkStepId" value="${currentStep.ID}" />
							<input type="checkbox" value="Y" name="commited"/>仅转发，不需要回复
							<div id="focusEmpDiv" style="text-align:center; width:94%; margin: 10px auto; "></div>
							<input id="focusEmpName" type="hidden" name="focusEmpName" />
							<textarea id="focusEmpText" name="focusEmpText"  rows="3" cols="1" placeholder="请输入内容" 
			    		 		style="border:1px solid #ddd; width:90%; margin-left:5px;">转发</textarea>
						</form>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		                <button id="focusEmpBtn" type="button" class="btn btn-primary" onclick="saveFocusEmp();">提交</button>
		            </div>
		        </div><!-- /.modal-content -->
		    </div><!-- /.modal -->
		</div>
	    
	    <!-- 模态框（Modal） -->
		<div class="modal fade noPrint" id="chooseEmpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content">
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		                <h4 class="modal-title" id="myModalLabel">选择人员</h4>
		            </div>
		            <div class="modal-body" style="height:300px;">
		            
		            	<!-- 选择人员 -->
		            	<form action="app_task/saveChooseEmp.do" id="chooseEmpForm" method="post">
							<input id="chooseEmpFormworkId" type="hidden" name="formWorkId" value="${work.ID }" />
							<div id="chooseEmpDiv" style="text-align:center; width:90%; margin: 10px auto; ">
							    
							</div>
						</form>
		            
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		                <button id="chooseEmpBtn" type="button" class="btn btn-primary" onclick="saveChooseEmp();">提交</button>
		            </div>
		        </div><!-- /.modal-content -->
		    </div><!-- /.modal -->
		</div>

		<!-- 财务表单退回的模态框（Modal） -->
		<div class="modal fade noPrint" id="rejectStepModal" tabindex="-1" role="dialog" aria-labelledby="rejectStepModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content">
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		                <h4 class="modal-title" id="rejectStepModalLabel">选择退回步骤</h4>
		            </div>
		            <div class="modal-body" style="height:300px; text-align:center;">
		            	<!-- 步骤列表 -->
		            	<div id="rejectStepDiv" style="text-align:center; width:94%; margin: 10px auto; "></div>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		                <button id="rejectStepBtn" type="button" class="btn btn-primary" onclick="rejectStep();">提交</button>
		            </div>
		        </div><!-- /.modal-content -->
		    </div><!-- /.modal -->
		</div>
