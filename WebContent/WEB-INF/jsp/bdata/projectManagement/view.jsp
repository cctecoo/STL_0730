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
	<!-- jsp文件头和头部 -->
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
	<link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
	<link href="static/css/style.css" rel="stylesheet" />
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/bootgrid.change.css" />
	
	<style>
		#content_list {
		 width:90%;
		 height:200px;
		 padding: 0 10px;
		 border:1px solid #ccc;
		 position:relative;
		 overflow:scroll;
		}
		#content_list dl{
		 width:120px;
		 height:54px;
		 float:left;
		 margin:8px 4px;
		 padding:2px 2px;
		}
		#content_list dl:hover {
		 background-color:#31b0d5;
		 cursor: pointer;
		}
		#content_list dl dd {
		 text-align:center;
		 height:100%;
		 padding:5px;
		 background:#5bc0de;
		}
		#content_list dd a {
		 color:#fff;
		 text-decoration:none;
		 font-weight:bold;
		}
		.pay_title{ font-size:16px; border-left:5px solid #005ba8; padding-left:10px; margin:15px 0;}
		/* .pay_option{ margin:50px 0;} */
		.pay_project{padding-top:20px;}
		.pay_project_left{ float:left;margin-right:20px;}
		.pay_project_right{width:90%; float:left;}
		.project_operator{float:left; margin: 0 50px;}
		.project_info{ height:110px; margin-top:5px; padding:10px; border:1px solid #ccc;}
		.radiusbtn{ color:#fff;border-radius:25px; padding:5px 10px;}
		.radiusbtn:hover{color:#fff; text-decoration:none;}
		.radiusbtn:focus{color:#fff; text-decoration:none;}
		
		.mask{margin-top:5px; height:100%; width:100%; position:fixed; _position:absolute; 
			top:0; z-index:1000; background-color: white; opacity:0.3;} 
		.opacity{  opacity:0.7; filter: alpha(opacity=30); background-color:#000; } 
	</style>
	
</head>
<body>

<!---右侧部门选择--->
	<div id="main-content">
		<!---右侧表格显示--->
		<div class="main-content">
			
	    	<div class="page-content">
				<div class="row" >
					<div class="col-xs-12" style="margin-left:30px;">
					
						<div style="margin:10px;">
							<div>
								<label>公式名称:</label>
								<input id="formulaName" type="text" name="formulaName" value="${pd.FORMULA_NAME }" 
									style="margin:0 10px; width:300px" maxlength="50" disabled="disabled"/>
							</div>
							<div style="margin-top:10px; ">
								<label>适用类型:</label>
								<input type="radio" name="formulaType" value="productLine" disabled="disabled"
									<c:if test="${pd.FORMULA_TYPE=='productLine' }">checked="checked"</c:if> />产线经理等管理人员
								<input type="radio" name="formulaType" value="dept" disabled="disabled"
									<c:if test="${pd.FORMULA_TYPE=='dept' }">checked="checked"</c:if> />车间主任等管理人员
								<input type="radio" name="formulaType" value="baseEmp" disabled="disabled"
									<c:if test="${pd.FORMULA_TYPE=='baseEmp' }">checked="checked"</c:if> />车间工人等基层人员
							</div>
						</div>
						
						<div class="pay_option">
							<div class="pay_title">基础项</div>
							<div id="content_list">
								 <c:forEach items="${salaryList}" varStatus="vs" var="salary">
								 	<dl>
								 		<dd><a>${salary.NAME}</a></dd>
									</dl>
								 </c:forEach>
							 </div>
						</div>
						<div id="cleaner"></div>
						
						<div class="pay_project">
							<div class="pay_title">方案配置</div>
							<div class="pay_project_left"></div>
							<div class="pay_project_right">
								<div style="font-size:18px; float:left;"></div>
								<div class="project_operator">
									<c:forEach items="${operList}" varStatus="vs" var="oper">
									 <c:if test="${oper.NAME == '+' }">
									 	<img src="static/images/operator_01.png" alt="${oper.NAME}">
									 </c:if>
									 <c:if test="${oper.NAME == '-' }">
									 	<img src="static/images/operator_02.png" alt="${oper.NAME}">
									 </c:if>
									 <c:if test="${oper.NAME == '*' }">
									 	<img src="static/images/operator_03.png" alt="${oper.NAME}">
									 </c:if>
									 <c:if test="${oper.NAME == '/' }">
									 	<img src="static/images/operator_04.png" alt="${oper.NAME}">
									 </c:if>
									 <c:if test="${oper.NAME == '(' }">
									 	<img src="static/images/operator_05.png" alt="${oper.NAME}">
									 </c:if>
									 <c:if test="${oper.NAME == ')' }">
									 	<img src="static/images/operator_06.png" alt="${oper.NAME}">
									 </c:if>
									</c:forEach>
									<span id="itemParam" style="padding: 0px 4px 4px 4px; color: white; background-color: #4185d0; "
										title="小于1的系数，最多包含两位小数">系数</span>
								</div>
								
								<div style="">
									<a class="btn-danger radiusbtn" style="cursor:pointer" onclick="goBack();" >返回</a>
								</div>
								
								<div id="cleaner"></div>
								<div class="project_info">
									<span class="element">${pd.FORMULA}</span>
								</div>
								<div class="project_output" style="display:none;"></div>
							</div>
						</div>
		
					</div>
				</div>
		    </div>
		</div>
	</div>

	<!-- 引入 -->
	<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
	<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/jquery-1.7.2.js"></script>
	<!-- 引入 -->
	
	<script type="text/javascript">
		
		//返回
	    function goBack(){
    		window.location.href = "<%=basePath%>projectManagement/list.do";
	    }
	</script>
	<body style="overflow:-Scroll;overflow-y:hidden;overflow-x:hidden"> 
	</body>
</html>
