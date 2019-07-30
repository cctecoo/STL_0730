<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<base href="<%=basePath %>" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,minimal-ui"></meta>
		<title>我的信息</title>
		<link rel="stylesheet" href="static/app/css/style.css"></link>
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<style>
			body{ background:#f4f4f4;}
			.tasklist_info{
				width:96%;
				padding:2% 1%;
			}
			.tasklist_info img{
				width:90%;
			}
			.tasklist_info table{
				padding-left:1%;
				width:100%;
			}
			.appcenter td {padding:5px;}
		</style>
	</head>
	
	<body>
		<div class="web_title">
			工作台
			<span style="top:13px;">
				<a href="app_remindRecord/list.do"><i class="icon-bell-alt" style="font-size:135%;"></i></a>
				<!-- <a href="app_login/logout.do"><i class="icon-signout" style="font-size:135%;"></i></a> -->
			</span>
		</div>
		<img src="static/img/appcenter.png" width="100%" />
		<div class="tasklist_info" style="margin:0;margin-bottom:3%;width:98%;box-shadow:0 2px 4px rgba(0,0,0,.1)">
			<table>
				<tr>
					<td rowspan="4" style="width:30%"><img src="static/img/user.png" /></td>
					<th colspan="2">${user.NAME }</th>
				</tr>
				<tr>
					<td style="width:70px;"><label>部门：</label></td>
					<td>${user.deptName }</td>
				</tr>
				<tr>
					<td><label>员工编号：</label></td>
					<td>${user.NUMBER }</td>
				</tr>
				<tr>
					<td><label>所属岗位：</label></td>
					<td>${user.PASSWORD }</td>
				</tr>
			</table>
			<div id="cleaner"></div>
		</div>
		<div class="appcenter" style="box-shadow:0 2px 4px rgba(0,0,0,.1);background: white; height:100%">
			<span style="padding:10px; display:block;">常用功能</span>
			<table cellspacing="0">
				<c:forEach items="${appIndexMenuList }" var="menu" varStatus="vs">
					<c:if test="${vs.count%4==1}"><tr></c:if>
					<c:if test="${menu.hasMenu }">
						<td style="width:25%;">
							<a class="" href="${menu.MENU_URL }">
								<img src="static/img/dd_UI/${menu.MENU_CODE }.png" width="55%" />
								<br/>
								${menu.MENU_NAME }
							</a>
						</td>
					</c:if>
					<c:if test="${vs.count%4==0}"></tr></c:if>
				</c:forEach>
				<c:if test="${fn:length(appIndexMenuList)%4!=0 }">
					<c:forEach begin="1" end="${4-fn:length(appIndexMenuList)%4 }">
						<td style="width:25%;">
						</td>
					</c:forEach>
					</tr>
				</c:if>
			</table>
		</div>
		
		<div style="backgroud:white">
			<form action="app_login/logout.do" >
				<input type="submit" value="注&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;销" 
					style="width: 100%;margin-top:15px;
						height: 45px;border: 0;background-color: #DD0000;font-size: 16px;color: white;" />
			</form>
		</div>
		<input type="text" id="msg" name="msg" value="${pd.msg}" style="display:none">
	</body>
	<script type="text/javascript" src="static/app/js/jquery.min.js"></script>
	<script type="text/javascript">
		$(function(){
			if($("#msg").val()!=null && $("#msg").val()!=''){
				alert("今日已经添加过日清日报，不能再次添加！")
			}
		})
	</script>
</html>