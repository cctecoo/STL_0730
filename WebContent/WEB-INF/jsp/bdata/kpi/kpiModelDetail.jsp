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
		<base href="<%=basePath%>"><!-- jsp文件头和头部 -->
		<%@ include file="../../system/admin/top.jsp"%> 
		
		<link rel="StyleSheet" href="static/css/style.css" type="text/css" />
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/css/chosen.css" />

		<style type="text/css">
			.f_deta{
				 width: 180px; 
				 float: left;
			}
			/*设置自适应框样式*/
			.test_box {
				width: 400px;
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
			.test_box:focus{
			    box-shadow: 0 0 0 2px rgba(245,153,66,0.3);
    			color: #838182;
    			border-color: #f59942;
    			background-color: #FFF;
			}
		</style>
	</head>
<body>
	<fmt:requestEncoding value="UTF-8" />
	<form action="kpiModel/saveKpiSocre.do" method="post" name="userForm" id="userForm">
	
		<div>
			<div class="breadcrumbs" id="breadcrumbs">
			
				<div class="m-c-l_show"></div> <div id="subjectName"></div>
				
				<div style="position:absolute; top:0px; right:25px;">
					<a class="btn btn-mini btn-primary" onclick="saveScore();">保存模板里的考核项</a>
					<a class="btn btn-mini btn-primary" onclick="fromExcel();"
					   title="模板中原有的考核项将移除" style="margin-right:90px;">导入考核项到模板</a>
				</div>
			</div>
		</div>
	
		<!-- 详情 -->
		<div class="main-content" style="width:100%;">
			
			<table>
				<c:if test="${pd.modelType=='EMP_YEAR' }">
				<!-- 年度考核模板才显示 -->
				<tr>
					<td style="width:100px">关联员工</td>
					<td>
						<select multiple class="chzn-select" id="guanLianRen" data-placeholder="请选择" style="width:544px;">
							<option value=""></option>
					  		<c:forEach items="${empList}" var="emp">
					  			<option value="${emp.EMP_CODE }" title="${emp.EMP_DEPARTMENT_NAME }"
					  				<c:if test="${emp.isSelected }">selected</c:if>
					  				>${emp.EMP_NAME }</option>
					  		</c:forEach>
					  	</select>
					  	<a class="btn btn-mini btn-primary" onclick="saveRelateEmp();">仅保存关联的员工</a>
					</td>
				</tr>
				</c:if>
				
				<tr>
					<td colspan="2">
						<table id="editTable" class="table table-striped table-bordered" style="" data-min="11" data-max="30" >
						  <thead>
							<tr>
							  <th style="width:100px;">KPI编号</th>
							  <th style="width:150px;">KPI类型</th>
							  <th style="width:150px;">KPI名称</th>
							  <th style="width:420px;">KPI标准</th>
							  <th style="width:60px;">KPI分值</th>
							</tr>
						  </thead>
						  <tbody id="showDetail">
						    
						  </tbody>
						</table>
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
	<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
	<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
	<!-- 引入 -->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
	<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
	<script type="text/javascript">
		$(function() {
			//显示选择人员的下拉列表
			$(".chzn-select").chosen({
				no_results_text: "没有匹配结果",
				disable_search: false,
				search_contains: true//模糊查询
			});
			showDetail(${pd.modelId});
		})
		
		
		//显示模版关联的KPI信息
		function showDetail(id, $obj){
			
			var url = "<%=basePath%>/kpiModel/modelDetail.do?ID="+id;
			$.ajax({
				type: "POST",
				async:false,
				url: url,
				success:function (data){     //回调函数，result，返回值
					var obj = eval('(' + data + ')');					
					var shtml = "";
					$("#subjectName").html('模板名称：' + obj.pd.NAME);
					$.each(obj.list, function(i, list){
						var standardIndexId = 'index' + i + '_kpiStandard';
						var scoreIndexId = 'index' + i + '_kpiScore';
						var title = '上次更新' + list.LAST_UPDATE_TIME + ' ' + list.LAST_UPDATE_EMP_NAME;
					 	shtml += 
					 		'<tr  class="record" title="' + title + '">' + 
					 		'<td>' + list.KPI_CODE + '</td>' + 
					 		'<td>' + list.KPI_TYPE + '</td>' +
					 		'<td>' + list.KPI_NAME + '</td>' +
					 		'<td>' +
				 			'<input type="hidden" name="kID" id ="kID" style="width:1px" value="' + list.ID + '" />' +
					 		'<input type="hidden" name="' + standardIndexId + '" id="' + standardIndexId + '" ' +
					 		'style="width:90%;color:black;;padding:0;"'+
					 		' value="' + list.PREPARATION2 + '" maxlength="400" placeholder="考核标准" />' +
							'<div id="div' + standardIndexId + '" class="test_box" contenteditable="true" ' +
							' onkeyup="checkVal(this, \'#' + standardIndexId + '\', 400, false)">' + list.PREPARATION2 + '</div>' +
					 		'</td>' + 
					 		'<td>' + 
					 		'<input type="text" name ="' + scoreIndexId + '" id="' + scoreIndexId + '" class="score" ' +
			 				'style="width:100%; height:30px; color:black;padding:0;"' + 
			 				' onkeyup="checkScore(this)" onblur = "getSum();" value="' + list.PREPARATION3 + '" />' +
					 		'</td>' +  
					 		'</tr>';
					});
					shtml +='<tr><th colspan="5">合计：<span id="sumsCore"></span></th></tr>';
					$("#showDetail").html(shtml);
					
					getSum();
				}					
			},"text");
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
		
		//检查输入的分数
		function checkScore(obj){  
            var c=$(obj);
            var v= $(obj).val();
            if(/[^\d]/.test(v)){//替换非数字字符 
            	showTipsMsg($(obj), '请填写数字')
            	return false;
            }
            return true;
         }
		
        //计算合计
		function getSum(){
			var count = 0;
			$(".score").each(function(){
				if($(this).val()==null||$(this).val()=="")
				{
					$(this).val(0);
				}
				count = parseInt(count)+parseInt($(this).val());
			});
			$("#sumsCore").text(count);
		}
        
        //保存
		function saveScore(){
			//检查模板总分
			/*
			getSum();
			var scoreCount = $("#count").val();
			if(scoreCount!=100){
				alert("模板总分为100，请重新填写");
				return;
			}*/
			//检查输入的kpi标准
			var isInputMatch = true;
			$(".test_box").each(function(){
				if(isInputMatch){
					if(checkVal(this, $(this).prev(), 400, true)){
						isInputMatch = false;
					}
				}
			});
			if(!isInputMatch){
				return;
			}
			
			//检查输入的分数是否为数字
			var isIntScore = true;
			$(".score").each(function(){
				if(isIntScore){
					if(!checkScore(this)){
						isIntScore = false;
						showTipsMsg($(this), '请填写数字');
					}
				}
			});
			if(!isIntScore){
				return;
			}
			$("#userForm").submit();
		}
		
        //配置关联的员工
        function saveRelateEmp(){
        	$.ajax({
        		type: 'post',
        		url: 'kpiModel/saveRelateEmp.do',
        		data: {'yearKpiModelId' : '${pd.modelId}', 'relateEmpCodes': $("#guanLianRen").val()},
        		success: function(data){
        			if(data.msg=='success'){
        				top.Dialog.alert('保存成功');
        			}else{
        				top.Dialog.alert('后台出错，请联系管理员');
        			}
        		}
        	});
        }
        
		//显示提示信息
		function showTipsMsg(obj, msgText){
			$(obj).tips({
				side:3,
	            msg:msgText,
	            bg:'#AE81FF',
	            time:1
	        });
			$(obj).focus();
		}
		
		//导出excel
		function toExcel(){
			window.location.href='<%=basePath%>/bdbudgetmodel/excel.do';
		}
		
		//打开上传excel页面
		function fromExcel(){
			top.jzts();
			var diag = new top.Dialog();
			diag.Drag=true;
			diag.Title ="EXCEL 导入到数据库";
			diag.URL = '<%=basePath%>common/goUploadKpiModelExcel.do?MODEL_ID=${pd.modelId}';
			diag.Width = 400;
			diag.Height = 150;
			diag.CancelEvent = function(){ //关闭事件
				window.location.reload();
				diag.close();
			};
			diag.show();
		}
		
	</script>
		
	</body>
</html>

