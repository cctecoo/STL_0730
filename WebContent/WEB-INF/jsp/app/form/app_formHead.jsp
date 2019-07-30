<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<link rel="stylesheet" href="static/css/app-style.css" />

	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
	<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
	
	<link rel="stylesheet" href="static/css/ace.min.css" />
	<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
	<link rel="stylesheet" href="static/css/ace-skins.min.css" />
	
	
	<link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
	<link rel="stylesheet" href="<%=basePath%>plugins/font-awesome/css/font-awesome.min.css" />
	<link rel="stylesheet" href="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.css" />
	
	<!-- 下拉框 -->
	<link rel="stylesheet" href="static/select2/select2.min.css" />
	
	<!--树状图插件 -->
	<link type="text/css" rel="stylesheet" href="plugins/zTree3.5/zTreeStyle.css"/>
	
	<style type="text/css">
		/*设置样式*/
		#formDetail{margin-top:10px;}
		#formDetail input[disabled], input[readonly], select[disabled], textarea[disabled]{
			color:black;
		}
		#formDetail input, select, textarea{
			color:black;
		}
		#orderDiv{padding-bottom:1px;}
		#orderDiv table td{
			height:20px;
			padding:2px;
			text-align: left;
		}
		#form1 table td{
			word-break: break-all;
		}
		#orderDiv input[type="text"], #orderDiv textarea{
			width:100%;
			/* border:0; */
			padding:0;
			margin:0;
		}
		#orderDiv select{
			width:100%;
			height: 21px; 
			padding: 0px;
		}
		
		.chosen-container{margin-left: 5px;}
		.chosen-container-single .chosen-single{height:22px; padding:2px; }
		.chosen-container-multi .chosen-choices li.search-field input[type="text"]{height:24px;}
		.modal.fade{z-index:-1050}
		.modal.fade.in{z-index:1050}
		#formDetail input[disabled], input[readonly], select[disabled], textarea[disabled]{
			background-color: white !important;
		}
		input[type="checkbox"],input[type="radio"] {
			opacity:1 ;
			position: static;
			padding:0;margin:0;
		}
		.bottomFloatBtn{
			width:100%; position:fixed; bottom:50px;background:white;
    		height: 50px;
		}
		.topFloatBtn{
			position:fixed; top:0;
		}
		.fileStyle{
			border: 1px solid #ccc;
			width: 370px;
		}
		.radio.inline, .checkbox.inline{
			height:20px;
			padding:0; 
			margin:0 10px;
		}
		.treePanel{
			display: none;
			position: absolute;
			overflow: auto;
			height: 200px;
			width: 200px;
			border: 1px solid #CCCCCC;
			background-color:white;
			z-index: 100000;
		}
		.delFileBtn{float:right; margin-right:5px;}
		.chzn-select{
			position: relative;
   	 		z-index: 1;
   	 		opacity:1;
   	 		visibility: visible;
		}
	</style>
		
	<!-- 打印时生效的样式 -->
	<style media=print>
		.noPrint {
			display: none;
		}
		.showBorder{border: 1px black}
		#orderDiv table, #orderDiv table td{border-color:black}
		#comment {
			display: none !important;
		}
		#fileBtn{
			display: none !important;
		}
	</style>

		<div id="loadDiv" class="loadDivMask" >
			 <i class=" fa fa-spinner fa-pulse fa-4x"></i>
			 <h4 class="block">操作中...</h4>
		</div>
	   	
		<div id="orderDiv" class="showBorder" style="width:98%; margin: 1px auto; ">
			<form action="app_task/saveOrUpdate.do" id="form1" method="post">
				<!-- 用来保存信息的隐藏域 -->
				<input type="hidden" name="formWorkId" value="${work.ID }" />
				<input type="hidden" name="formWorkNo" value="${work.WORK_NO }" />
	    		<input type="hidden" name="currentStepId" value="${currentStep.ID}" />
	    		<input type="hidden" name="currentStepLevel" value="${currentStep.STEP_LEVEL }" />
	    		<input type="hidden" name="isLastStep" value="${currentStep.LAST_STEP}" />
	    		
	    		<input type="hidden" name="workContent" value="" id="workContent" />
	    		<input type="hidden" name="commitNext" value="" id="commitNext" />
	    		
	    		<c:choose>
		    		<c:when test="${empty work || empty work.FORM_MODEL_ID }">
		    			<input type="hidden" name="formModelId" value="${formModel.ID }" /><!-- 用于区分表单 -->
		    		</c:when>
		    		<c:otherwise>
		    			<input type="hidden" name="formModelId" value="${work.FORM_MODEL_ID }" /><!-- 用于区分表单 -->
		    		</c:otherwise>
	    		</c:choose>
	    		<input type="hidden" name="pageName" value="${formModel.FORM_PAGE }" /><!-- 模版关联页面 -->
	    		
	    		<input type="hidden" name="taskName" value="${work.WORK_NAME }"/>
	    		
	    		<!-- 只在第一次保存的时候写入实例的字段值表form_work_item -->
	    		<c:choose>
	    			<c:when test="${empty work.ID }">
	    				<input type="hidden" name="workName" value="${work.WORK_NAME }" />
	    				<input type="hidden" name="workTitle" value="${work.WORK_TITLE }" />
	    			</c:when>
	    			<c:otherwise>
	    				<input type="hidden" name="workName" value="${work.WORK_NAME }" />
	    			</c:otherwise>
	    		</c:choose>
	    	
	    	<!-- 显示部门树 -->
	    	<input class="stepLevel_1 dept-tree" type="hidden" id="selDept" readonly="readonly" value=""/>
	    	
	    	<!-- 显示科目树 -->
	    	<div id="treePanel" class="treePanel">
				<ul id="costItemtree" class="ztree" style="height: 85%;"></ul>
			</div>
	    	
	    	<!-- 表单详情 -->
			<div id="formDetail">
				<div style="text-align: center;">
					<!-- 显示模版名称 -->
					<span style="font-size: 15px;">
					<c:choose>
		    			<c:when test="${empty work.ID }">${formModel.FORM_DISPLAY_NAME }</c:when>
		    			<c:otherwise>${work.WORK_TITLE }</c:otherwise>
		    		</c:choose>
	    			</span>
	    			<span style="margin-left:10px; font-weight:100; ">编号：${work.WORK_NO}</span>
				</div>
				