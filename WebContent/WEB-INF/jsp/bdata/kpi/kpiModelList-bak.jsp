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
	<script>
	$(function(){
		/*
		var browser_height = $(document).height();
		$("div.main-container-left").css("min-height",browser_height);
		$(window).resize(function() { 
			var browser_height = $(window).height();
			$("div.main-container-left").css("min-height",browser_height);
		}); 
		*/
	});
	</script>
	
	<script>
	$(function(){	
		$(".m-c-l_show").click(function(){
		$(".main-container-left").toggle();
		$(".main-container-left").toggleClass("m-c-l_width");
		$(".m-c-l_show").toggleClass("m-c-l_hide"); 
		});
	});
	</script>
	<script>
		$(function(){	
				
					$(".m-c-l_show").click(function() { 
					var div_width = $(".main-container-left").width();
					$("div.main-content").css("margin-left",div_width+2); 
					}); 
		});
				</script>
		<style type="text/css">
			.f_deta{
				 width: 180px; 
				 float: left;
			}
			/*设置自适应框样式*/
			.test_box {
				width: 500px;
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
	<form action="kpiModel/list.do" method="post" name="userForm" id="userForm">
	
		<div>
			<div class="breadcrumbs" id="breadcrumbs">
			
				<div style="float:left">
					<a class="btn btn-mini btn-info" onclick="add();">新增模板</a>
					<a class="btn btn-mini btn-primary" onclick="edit();">修改模板</a>
					<a class="btn btn-mini btn-danger" onclick="del();">删除模板</a>
				</div>
				
				<div class="m-c-l_show"></div> <div id="subjectName"></div>
				
				<div style="position:absolute; top:0px; right:25px;">
					<a class="btn btn-mini btn-primary" onclick="saveScore();">保存KPI</a>
					<a class="btn btn-mini btn-primary" onclick="fromExcel();" title="从EXCEL导入" style="margin-right:90px;">导入KPI</a>
				</div>
			</div>
		</div>
		
		<div class="main-container-left" style="height:600px; overflow:scroll;">
			<div class="m-c-l-top">
				<img src="static/images/ui1.png" style="margin-top:-5px;">KPI模板
			</div>
	
			<table class="table table-striped table-bordered table-hover" data-min="11" data-max="30" >
		  	<thead>
				<tr>
					<th class="center" style="width: 20%"></th>
					<th style="width: 20%">编号</th>
					<th>模板名称</th>
				</tr>
			</thead>										
			<tbody>					
			<!-- 开始循环 -->	
			<c:choose>
				<c:when test="${not empty varList}">
					<c:forEach items="${varList}" var="kpiModel" varStatus="vs">
						<tr onclick="showDetail('${kpiModel.ID}',$(this));" style="cursor:pointer"
							title="上次更新 ${kpiModel.LAST_UPDATE_TIME } ${kpiModel.LAST_UPDATE_EMP_NAME }">
							<td class='center' style="width: 30px;">
								<label>
									<input type='checkbox' name='ids' kpiid ="${kpiModel.ID}"  value="${kpiModel.ID}" /><span class="lbl"></span>
								</label>
							</td>
							<td>${kpiModel.CODE}</td>
							<td>${kpiModel.NAME}</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr class="main_info">
						<td colspan="100" class="center" >没有相关数据</td>
					</tr>
				</c:otherwise>
			</c:choose>
			</tbody>
		</table>
	</div>
	
	<!-- 详情 -->
	<div class="main-content" style="margin-left:222px">
		
	
		<table id="editTable" class="table table-striped table-bordered" style="width:99%" data-min="11" data-max="30" >
		  <thead>
			<tr>
			  <th style="width:60px;">KPI编号</th>
			  <th style="min-width:100px;">KPI类型</th>
			  <th >KPI名称</th>
			  <th >KPI标准</th>
			  <th style="width:60px;">KPI分值</th>
			</tr>
		  </thead>
		  <tbody id="showDetail">
		    
		  </tbody>
		</table>
	</div>	
		
</form>
		
	<!-- 返回顶部  -->
	<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse">
		<i class="icon-double-angle-up icon-only"></i>
	</a>
	
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
	<script type="text/javascript">

		//检索
		function search(){
			//top.jzts();
			$("#Form").submit();
		}
		
		//新增
		function add(){
			 //top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="新增";
			 diag.URL = '<%=basePath%>/kpiModel/goAdd.do';
			 diag.Width = 550;
			 diag.Height = 400;
			 diag.CancelEvent = function(){ //关闭事件
				diag.close();
				location.replace("<%=basePath%>/kpiModel/list.do");
			 };
			 diag.show();
		}
		
		//删除
		function del(){
			var count = $(":checkbox[name='ids']:checked").size();
			if (count != 1) {
				alert("请选择且仅可选择一条数据！");
				return false;
			}
			bootbox.confirm("确定要删除吗?", function(result) {
				if(result) {
					//top.jzts();
					var url = "<%=basePath%>/kpiModel/delete.do?MODEL_ID="+$(":checkbox[name='ids']:checked").val();
					$.ajax({
						url: url,
						type: 'post',
						success: function(data){
							if(data=="success"){
								alert("删除成功！");
								//top.jzts();
								setTimeout("self.location.reload()",100);
							}else if(data=="error"){
								alert("后台出错，请联系管理员！");
							}else if(data=="used"){
								alert("该模板已分配，无法删除！");
								//top.jzts();
								//setTimeout("self.location.reload()",100);
							}
						}
					});
				}
			});
		}
		
		//修改
		function edit(){
			var count = $(":checkbox[name='ids']:checked").size();
			if (count != 1) {
				alert("请选择且仅可选择一条数据！");
				return false;
			}
			//top.jzts();
			var diag = new top.Dialog();
			diag.Drag=true;
			diag.Title ="编辑";
			diag.URL = '<%=basePath%>/kpiModel/goEdit.do?MODEL_ID='+$(":checkbox[name='ids']:checked").val();
			diag.Width = 550;
			diag.Height = 400;
			diag.CancelEvent = function(){ //关闭事件
				diag.close();
				location.replace("<%=basePath%>/kpiModel/list.do");
			};
			diag.show();
		}
		
		//显示模版关联的KPI信息
		function showDetail(id,$obj){
			$("[kpiid]").prop("checked",false); 
			//$("[kpiid]").attr('checked',false);
			var url = "<%=basePath%>/kpiModel/modelDetail.do?ID="+id;
			$.ajax({
				type: "POST",
				async:false,
				url: url,
				success:function (data){     //回调函数，result，返回值
					var obj = eval('(' + data + ')');					
					var shtml = "";
					 $("#subjectName").html(obj.pd.NAME);
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
					 $obj.parent().find("tr").each(function(){
                        $(this).css("background-color","white");
                    });
                    $obj.css("background-color","#f1f1f1");					
					$("[kpiid= '"+id+"']").prop('checked',true);
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
			//TODO检查
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
			var count = $(":checkbox[name='ids']:checked").size();
			if (count != 1) {
				alert("请选择导入的模板！");
				return false;
			}
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="EXCEL 导入到数据库";
			 diag.URL = '<%=basePath%>common/goUploadKpiModelExcel.do?MODEL_ID='+$(":checkbox[name='ids']:checked").val();
			 diag.Width = 400;
			 diag.Height = 150;
			 diag.CancelEvent = function(){ //关闭事件
				diag.close();
			 };
			 diag.show();
		}
		
	</script>
		
	</body>
</html>

