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
		<title>流程明细</title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/css/chosen.css" />
		
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		
		<link rel="stylesheet" href="static/css/datepicker.css" /><!-- 日期框 -->
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<link rel="stylesheet" href="static/css/app-style.css" />
		
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
				line-height: 1.3;
				word-break: break-word;
	    		overflow: visible;
	    		white-space: normal;
			}
		</style>
		<!-- 引入 -->
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/jquery-form.js"></script>
  </head>
  
  <body>
    <div class="web_title">
			<!-- 返回 -->
<%-- 			<div class="back" style="top:5px">
			<c:if test="${pd.showDept == '' }">
			<a href="<%=basePath %>app_task/listDesk.do?&loadType=F&startDate=${pd.startDate }&endDate=${pd.endDate }&flowName=${pd.flowName }&currentPage=${pd.currentPage}">
			</c:if>
			<c:if test="${pd.showDept == '1' }">
			<a href="<%=basePath %>app_task/listBoard.do?&loadType=F&startDate=${pd.startDate }&endDate=${pd.endDate }&flowName=${pd.flowName }&currentPage=${pd.currentPage}&empCode=${pd.empCode }&deptCode=${pd.deptCode}">
			</c:if>
				<img src="static/app/images/left.png" /></a>
			</div> --%>
			节点岗位职责明细
		</div>
		
		<div id="zhongxin" style="width:98%; margin: 10px auto; border: none" class="tab-content">
		<c:choose>
		<c:when test="${not empty dutyList }">
				<c:forEach items="${dutyList }" var="dutyDetail" varStatus="vs">
					<div class="keytask">
						<table>
			    			<tr>
			    				<td style="width:70px">工作明细:</td>
								<td><span>${dutyDetail.detail }</span>
								</td>
			    			</tr>
			    			<tr>
			    				<td style="width:70px">要求:</td>
								<td><span>${dutyDetail.requirement }</span>
								</td>
			    			</tr>
			    			<tr>
			    				<td style="width:70px">所属岗位职责:</td>
								<td><span>${dutyDetail.responsibility }</span>
								</td>
			    			</tr>
			    		</table>
					</div>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<span>没有节点岗位职责明细</span>
			</c:otherwise>
			</c:choose>
			</div>
			<div style="text-align:center">
			<c:if test="${not empty file.FILENAME_SERVER }">
				<a style="cursor:pointer;" onclick="loadFile('${file.FILENAME_SERVER}')"
					title="查看附件" class='btn btn-mini btn-primary' data-rel="tooltip" data-placement="left">
					查看附件<i class="icon-eye-open"></i>
				</a>
			</c:if>
		</div>
		<div>
			<%@include file="../footer.jsp"%>
		</div>
		<script type="text/javascript">
			//下载文件
			function loadFile(fileName){
				var action = '<%=basePath%>app_task/checkFile.do';
				var time = new Date().getTime();
				var name = encodeURIComponent(fileName);//处理特殊字符
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
						window.location.href = '<%=basePath%>app_task/loadFile.do?fileName=' + name + "&time=" + time;
					}
				});
			}
		</script>
  </body>
</html>
