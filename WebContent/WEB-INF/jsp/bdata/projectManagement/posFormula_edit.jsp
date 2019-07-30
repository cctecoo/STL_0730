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
	<!-- 下拉框 -->
	<link rel="stylesheet" href="static/css/chosen.css" />
	
	<link rel="stylesheet" href="static/css/ace.min.css" />
	<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
	<link rel="stylesheet" href="static/css/ace-skins.min.css" />
	
	<style>
		input[type="checkbox"],input[type="radio"] {
			opacity:1 ;
			position: static;
			height:25px;
			margin-bottom:10px;
		}
		#zhongxin td{height:40px;}
		#zhongxin td label{text-align:right; margin-right:10px;}
	</style>
</head>

<body>
	<fmt:requestEncoding value="UTF-8" />
	<form action="positionFormula/${msg}.do" name="Form" id="Form" method="post">
		<input type="hidden" name="ID" id="ID" value="${pd.ID}"/>
		<input type="hidden" id="txtGroupsSelect" name="txtGroupsSelect" value="${txtRoleSelect}"/>
		<div id="zhongxin">
		<table style="width: 100%">			
			<tr>
				<td style="text-align: center;">
					<table style="width: 100%;" name ="groups_tweenbox"  id="groups_tweenbox" cellspacing="0" cellpadding="0" >
						<tbody>
							<tr>
								<td>可选岗位</td>
								<td></td>
								<td>已选岗位</td>
							</tr>
							<tr>
								<td style="text-align: center;">
									<select id="groupsForSelect" multiple="multiple" style="height: 600px; width: 240px">
										<c:forEach items="${posList}" var="key">
											<option value="${key.ID}" title="${key.GRADE_NAME}-${key.ATTACH_DEPT_NAME }">${key.GRADE_NAME}-${key.ATTACH_DEPT_NAME }</option>
										</c:forEach>
									</select>
								</td>
								<td style="text-align: center;">
									<div style="margin-left: 5px; margin-right: 5px">
										<button onclick="unselectedAll()" class="btn btn-primary"
											type="button" style="width: 50px;line-height:20px;" title="全取消">&lt;&lt;
										</button>
									</div>
									<div style="margin-left: 5px; margin-right: 5px; margin-top: 5px;">
										<button onclick="unselected()" class="btn btn-primary"
											type="button" style="width: 50px;line-height:20px;" title="选择">&lt;
										</button>
									</div>
									<div style="margin-left: 5px; margin-right: 5px; margin-top: 5px;">
										<button onclick="selected()" class="btn btn-primary"
											type="button" style="width: 50px;line-height:20px;" title="取消">&gt;
										</button>
									</div>
									<div style="margin-left: 5px; margin-right: 5px; margin-top: 5px">
										<button onclick="selectedAll()" class="btn btn-primary"
											type="button" style="width: 50px;line-height:20px;" title="全选">&gt;&gt;
										</button>
									</div>
								</td>
								<td style="text-align: center;">
									<select id="selectGroups" multiple="multiple" name="selectGroups" 
											style="height: 600px; width: 240px">
										<c:forEach items="${subList}" var="key">
											<option value="${key.ID}" title="${key.GRADE_NAME}-${key.ATTACH_DEPT_NAME }">${key.GRADE_NAME}-${key.ATTACH_DEPT_NAME }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td style="text-align: center;">
					<br>
					<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
					<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
				</td>
			</tr>
		</table>
		</div>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">提交中...</h4></div>
		
	</form>

		<!-- 引入 -->
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<script type="text/javascript">
		
			
			//$(top.changeui());
			$(function() {
				$("#groupsForSelect").dblclick(function() {
					selected();
				});
				$("#selectGroups").dblclick(function() {
					unselected();
				});
			});
			
			//保存
			function save(){
				$("#Form").submit();
				$("#zhongxin").hide();
				$("#zhongxin2").show();
			}
			
			function selected() {
				var selOpt = $("#groupsForSelect option:selected");
			
				selOpt.remove();
				var selObj = $("#selectGroups");
				selObj.append(selOpt);
			
				var selOpt = $("#selectGroups")[0];
				ids = "";
				for (var i = 0; i < selOpt.length; i++) {
					ids += (selOpt[i].value  + ",");
				}
			
				if (ids != "") {
					ids = ids.substring(0, ids.length - 1);
				}
				$('#txtGroupsSelect').val(ids);
				//alert($('#txtGroupsSelect').val());
			}
			
			function selectedAll() {
				var selOpt = $("#groupsForSelect option");
			
				selOpt.remove();
				var selObj = $("#selectGroups");
				selObj.append(selOpt);
			
				var selOpt = $("#selectGroups")[0];
				ids = "";
				for (var i = 0; i < selOpt.length; i++) {
					ids += (selOpt[i].value  + ",");
				}
			
				if (ids != "") {
					ids = ids.substring(0, ids.length - 1);
				}
				$('#txtGroupsSelect').val(ids);
			}
			
			function unselected() {
				var selOpt = $("#selectGroups option:selected");
				selOpt.remove();
				var selObj = $("#groupsForSelect");
				selObj.append(selOpt);
			
				var selOpt = $("#selectGroups")[0];
				ids = "";
				for (var i = 0; i < selOpt.length; i++) {
					ids += (selOpt[i].value + ",");
				}
				
				if (ids != "") {
					ids = ids.substring(0, ids.length - 1);
				}
				$('#txtGroupsSelect').val(ids);
			}
			
			function unselectedAll() {
				var selOpt = $("#selectGroups option");
				selOpt.remove();
				var selObj = $("#groupsForSelect");
				selObj.append(selOpt);
			
				$('#txtGroupsSelect').val("blank");
			}
			

		</script>
</body>
</html>