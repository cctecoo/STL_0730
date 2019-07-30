<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
	<head>
	<base href="<%=basePath%>"><!-- jsp文件头和头部 -->
	<%@ include file="../../system/admin/top.jsp"%> 
	
	<!--树状图插件 -->
	<link rel="StyleSheet" href="static/css/style.css" type="text/css" />
	<link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
	<script>
		$(function(){	
			var browser_height = $(document).height();
			$("div.main-container-left").css("min-height",browser_height).css("width", 320);
			$("#deptTreePanel").css("height", browser_height-50);
			$(window).resize(function() { 
				var browser_height = $(window).height();
				$("div.main-container-left").css("min-height",browser_height);
				$("#deptTreePanel").css("height", browser_height-50);
			}); 	
			$(".m-c-l_show").click(function(){
				$(".main-container-left").toggle();
				$(".main-container-left").toggleClass("m-c-l_width");
				$(".m-c-l_show").toggleClass("m-c-l_hide"); 
				var div_width = $(".main-container-left").width();
				if($(".main-container-left").hasClass("m-c-l_width")){
					div_width = 0;
				}
				$("div.main-content").css("margin-left",div_width+2); 
			});
		});
	</script>
	
	<script type="text/javascript">
			window.jQuery || document.write("<script src='static/js/jquery-2.0.3.min.js'>"+"<"+"/script>");
		</script>
	
	<style>
		#zhongxin input[type="checkbox"],input[type="radio"] {
			opacity:1 ;
			position: static;
			height:25px;
			margin-bottom:10px;
	
		}
	 	#zhongxin td{height:40px;}
	    #zhongxin td label{text-align:right; margin-right:10px;}
	    .main-content{margin-left:320px}
	</style>

	</head>
<body>
	<div class="container-fluid" id="main-container">
		<div id="page-content" class="clearfix">
	  		<div class="row-fluid">
	  		
				<div class="main-container-left" style="">
					<div class="m-c-l-top">
						<img src="static/images/ui1.png" style="margin-top:-5px;">部门管理
						<a class="btn btn-mini btn-primary" onclick="fromExcel();" title="从EXCEL导入" style="margin-left:90px;">导入</a>
					</div>
					<div >
						<input autocomplete="off" id="dept_id" onclick="showDeptTree(this)" type="hidden" value="${pd.DEPT_NAME }" placeholder="点击选择承接部门" />
						
						<input type="hidden" name="deptCode" id="deptCode" value="${pd.DEPT_CODE}">
						<div id="deptTreePanel" style="background-color:white;z-index: 1000;">
							<ul id="deptTree" class="tree"></ul>
						</div>
					</div>
					<form action="dept/list.do" method="post" name="Form" id="Form">				
					<!-- <table>
						<tr>
						<td style="vertical-align:top;"><a class="btn btn-mini btn-primary" onclick="fromExcel();" title="从EXCEL导入">导入部门信息</a></td>
						</tr>
					</table> -->
					
						<div class="left"><!-- style="width:18%;border: 1px solid #DDDDDD;float:left;" -->
						</div>  
					</form>
				</div>
				
				<div class="main-content" style="margin-left:320px">
				<div class="breadcrumbs" id="breadcrumbs">
					<div class="m-c-l_show"></div>部门管理详情
					<span class="badge" style="background-color:#fee188; color: #963!important; margin-left:3px;">
						<i class="icon-info-sign">部门负责人可以审批下达给本部门的普通临时任务</i>
					</span> 
					<div style="position:absolute; top:0px; right:25px;">
						
						<a class="btn btn-mini btn-info" id = "a1" onclick="save();" style="display:none">保存</a>
						<a class="btn btn-mini btn-danger" id = "a2" onclick="checkEmp();" style="display:none">删除</a>
						<a class="btn btn-mini btn-primary" id = "a3" onclick="add();" style="display:none">新增下级部门</a>
						
						<shiro:hasPermission name="dept:add()">
						<a class="btn btn-mini btn-primary" onclick="addr();">新增根级部门</a>
						</shiro:hasPermission>
					</div>
				</div>
		

	<form action="dept/edit.do" method="post" name="Form" id="editForm">
		<input type="hidden" name="ID" id="id" value="${pd.ID }"/>
		<input type="hidden" name="myflag" id="myflag" value="${myflag }"/>	
		<input type="hidden" name="IS_FUNCTIONAL_DEPT" id="IS_FUNCTIONAL_DEPT" value=1>
		<input type="hidden" name="IS_PREPARE_DEPT" id="IS_PREPARE_DEPT" value=1>	
		<input type="hidden" name="DEPT_LEADER_ID" id="DEPT_LEADER_ID" value="${pd.DEPT_LEADER_ID }"/>	
	<div id="zhongxin" style="margin:20px; margin-left:100px;"><!-- style="width:48%;border: 1px solid #DDDDDD;margin-left:20px;padding:10px;float:left;" -->
		<table>
			<tr>
				<td><label>部门编码：</label></td>
				<td><input type="text" name="DEPT_CODE" id="dept_code" value="${pd.DEPT_CODE }" maxlength="32" title="部门编码"/></td>
			</tr>
			<tr>
				<td><label>部门名称：</label></td>
				<td><input type="text" name="DEPT_NAME" id="dept_name" value="${pd.DEPT_NAME }" maxlength="32" title="部门名称" /></td>
			</tr>
			<tr>
				<td><label>部门标识：</label></td>
				<td><input type="text" name="DEPT_SIGN" id="dept_sign" value="${pd.DEPT_SIGN }" maxlength="32" title="部门标识"/></td>
			</tr>
			<c:if test="${pd.PARENT_ID!=0 }">
			<tr>
				<td><label>上一级部门：</label></td>
				<td><input type="text" id="PARENT_NAME" value="${pd.PARENT_NAME }" maxlength="32" title="上一级部门" readonly/></td>			
			</tr>
			</c:if>
			<input type="hidden" name="PARENT_ID" id="parent_id" value="${pd.PARENT_ID }" /></td>
			<tr>
				<td><label>部门负责人：</label></td>
				<td><input <c:if test='${not empty pd.DEPT_LEADER_ID }'>value="${pd.DEPT_LEADER_NAME}"</c:if> type="text" name="DEPT_LEADER_NAME" id="DEPT_LEADER_NAME" 
					style="background:white!important;" readonly="readonly" onclick="deptAndEmp()"/>
			</tr>
			<tr>
				<td><label>排序：</label></td>
				<td><input type="number" name="ORDER_NUM" id="order_num" placeholder="这里输入序号" value="${pd.ORDER_NUM}" title="序号"/></td>
			</tr>
			<tr>
				<td><label>部门职能：</label></td>
				<td><select  name="FUNCTION" id="FUNCTION" data-placeholder="部门职能">
					<c:forEach items="${functionList}" var="function">
						<option value="${function.BIANMA}" <c:if test="${function.BIANMA == pd.FUNCTION}">selected="selected"</c:if>>${function.NAME}</option>										
					</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td><label>所属分公司：</label></td>
				<td><select  name="AREA" id="AREA" data-placeholder="所属分公司">
					<c:forEach items="${areaList}" var="area">										
						<option value="${area.BIANMA}" <c:if test="${area.BIANMA == pd.AREA}">selected="selected"</c:if>>${area.NAME}</option>	
					</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td><label>是否启用：</label></td>
				<td><input type="radio" name="ENABLED" id="ENABLED1" value="1"<c:if test="${pd.ENABLED == 1}">checked="checked"</c:if>>是
					<input type="radio" name="ENABLED" id="ENABLED0" value="0"<c:if test="${pd.ENABLED == 0}">checked="checked"</c:if>>否
				</td>
			</tr>
			<tr>
				<td><label>分管副总：</label></td>
				<td><input type="text" id="managerEmpName" value="" readonly="readonly" />
				</td>
			</tr>
			<%-- <tr>
				<td style="text-align: center;">
					<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
					<a class="btn btn-mini btn-primary" onclick="del('${pd.ID}');">删除</a>
					<c:if test="${pd.ID != null }">
					<a class="btn btn-mini btn-primary" onclick="add('${pd.ID}');">新增下级部门</a>
					</c:if>
				</td>
			</tr> --%>
		</table>
		</div>
</form>
				</div>
			</div>
		</div>
	</div>
		<!-- 引入 -->
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
		<script type="text/javascript" src="static/deptTree/deptTree1.js"></script>
		<!-- 引入 -->
		
		<script type="text/javascript">
		
			$(document).ready(function() {
				$("#dept_id").trigger("click");
			}); 
			//初始化树控件
			var setting = {
				checkable: false,
				checkType : { "Y": "", "N": "" },
				callback: {
					click:function(){
						var dept = deptTree.getSelectedNode();
						deptTreeInner.val(dept.DEPT_NAME);
						$("#deptCode").val(dept.DEPT_CODE);
						if(deptTreeInner.next()){
							deptTreeInner.next().val(dept.ID);
						}
						findDetail(dept.ID);
						<%-- location.replace('<%=basePath%>/dept/list.do?ID=' +dept.ID); --%>
					}
				}
			};
			
			$("#deptTree").deptTree(setting,${deptTreeNodes},$(document).height()-40, 318);
			$("#deptTreePanel").attr('height', 'auto');
			
			//选择部门查询部门信息
			function findDetail(id){
				var url = "<%=basePath%>/dept/findDetail.do?ID="+id;
				$.ajax({
					type: "POST",
					async:false,
					url: url,
					success:function (data){     //回调函数，result，返回值
						var obj = eval('(' + data + ')');
						$("#dept_code").val(obj.pd.DEPT_CODE);
						$("#dept_name").val(obj.pd.DEPT_NAME);
						$("#dept_sign").val(obj.pd.DEPT_SIGN);
						$("#PARENT_NAME").val(obj.pd.PARENT_NAME);
						if(obj.pd.DEPT_LEADER_ID!=undefined){//部门负责人不存在时，不显示名称
							$("#DEPT_LEADER_NAME").val(obj.pd.DEPT_LEADER_NAME);
						}else{
							$("#DEPT_LEADER_NAME").val("");
						}
						$("#parent_id").val(obj.pd.PARENT_ID);
						$("#order_num").val(obj.pd.ORDER_NUM);
						$("#AREA").val(obj.pd.AREA);
						$("#FUNCTION").val(obj.pd.FUNCTION);
						$("#id").val(obj.pd.ID);
						$("#myflag").val(obj.myflag);
						$("#managerEmpName").val(obj.pd.GENERAL_MANAGER_EMPNAME);

						if(obj.pd.ENABLED == 1)
						{
							$("#ENABLED1").trigger("click");
						}else
						{
							$("#ENABLED0").trigger("click");
						}
						//如果选中部门，保存、删除、新增下级部门按钮就会显示
						if(obj.myflag  == "1")
						{
							document.getElementById("a1").style.display = "inline-block";
							document.getElementById("a2").style.display = "inline-block";
							document.getElementById("a3").style.display = "inline-block";
						}
	 				}			
				},"text");
				
			}			
		
		//检索       
		function search(){
			top.jzts();
			$("#Form").submit();
		}
		
		//新增下级部门
		function add(){
			 var Id = $("#id").val();
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="新增下级部门";
			 diag.URL = '<%=basePath%>/dept/goAdd.do?ID='+Id;
			 diag.Width = 460;
			 diag.Height = 510;
			 diag.CancelEvent = function(){ //关闭事件
				setTimeout("self.location=self.location",100);
				diag.close();
			 };
			 diag.show();
		}
		
		//新增根级部门
		function addr(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="新增根级部门";
			 diag.URL = '<%=basePath%>/dept/goAddr.do';
			 diag.Width = 460;
			 diag.Height = 470;
			 diag.CancelEvent = function(){ //关闭事件
				setTimeout("self.location=self.location",100);
				diag.close();
			 };
			 diag.show();
		}
		function checkEmp(){
			var Id = $("#id").val();
			var urle = "<%=basePath%>/dept/checkEmp.do?ID="+Id;
			$.get(urle,function(data){
				if(data=="0"){
					del(Id);
				}else{
					alert("本部门下建有员工，不可删除！");
					return false;
				}
			});
		}
		//删除
		function del(Id){
			
			if(confirm("确定要删除?")){ 
				top.jzts();				
				var url = "<%=basePath%>/dept/delete.do?ID="+Id+"&tm="+new Date().getTime();
				$.get(url,function(data){
					if(data=="success"){
						alert("删除成功!");
						setTimeout("self.location=self.location",100);
					}
				},"text");
			}
		}
		
		//修改
		function edit(Id){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="编辑";
			 diag.URL = '<%=basePath%>/dept/goEdit.do?ID='+Id;
			 diag.Width = 600;
			 diag.Height = 465;
			 diag.CancelEvent = function(){ //关闭事件
				 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
					// nextPage(${page.currentPage});
				}
				diag.close();
			 };
			 diag.show();
		}
		 function deptAndEmp(){
	            var url = '';
	            url += '<%=basePath%>/dept/deptAndEmp.do?TARGET_DEPT_ID=&DEPT_ID=';
	            url += $('#id').val() + '&DEPT_NAME=' + $('#dept_name').val() + '&EMP_NAME=';
	            url += $('#DEPT_LEADER_NAME').val() + '&EMP_ID=' + $('#DEPT_LEADER_ID').val() + '&STATUS=1';
	           var diag = new top.Dialog();
	            diag.Drag=true;
	            diag.Title ="选择责任人";
	            diag.URL = url;
	            diag.Width = 860;
		        diag.Height = 445;
	            diag.ShowOkButton = true;
	            diag.ShowCancelButton = false;
	            diag.OKEvent = function(){
	                $('#DEPT_LEADER_NAME').val(diag.innerFrame.contentWindow.document.getElementById('EMP_NAME').value);
	                $('#DEPT_LEADER_ID').val(diag.innerFrame.contentWindow.document.getElementById('EMP_ID').value);
	                diag.close();
	            }
	            diag.show();
	    }
		//保存
		function save(){
			if($("#order_num").val()<=0)
			{
				top.Dialog.alert("请输入正整数");
				return false;
			}
			$("#editForm").submit();
		}
		</script>
		<script type="text/javascript">
		
		//全选 （是/否）
		function selectAll(){
			 var checklist = document.getElementsByName ("ids");
			   if(document.getElementById("zcheckbox").checked){
			   for(var i=0;i<checklist.length;i++){
			      checklist[i].checked = 1;
			   } 
			 }else{
			  for(var j=0;j<checklist.length;j++){
			     checklist[j].checked = 0;
			  }
			 }
		}

		//批量操作
		function makeAll(msg){
			
			if(confirm(msg)){ 
				
					var str = '';
					for(var i=0;i < document.getElementsByName('ids').length;i++)
					{
						  if(document.getElementsByName('ids')[i].checked){
						  	if(str=='') str += document.getElementsByName('ids')[i].value;
						  	else str += ',' + document.getElementsByName('ids')[i].value;
						  }
					}
					if(str==''){
						alert("您没有选择任何内容!"); 
						return;
					}else{
						if(msg == '确定要删除选中的数据吗?'){
							top.jzts();
							$.ajax({
								type: "POST",
								url: '<%=basePath%>/bdata/deleteAll.do?tm='+new Date().getTime(),
						    	data: {DATA_IDS:str},
								dataType:'json',
								//beforeSend: validateData,
								cache: false,
								success: function(data){
									 $.each(data.list, function(i, list){
											nextPage(${page.currentPage});
									 });
								}
							});
						}
					}
			}
		}
		
		//导出excel
		function toExcel(){
			window.location.href='<%=basePath%>/dept/excel.do';
		}
		
		function nextPage(page){ top.jzts();	if(true && document.forms[0]){
				var url = document.forms[0].getAttribute("action");
				if(url.indexOf('?')>-1){url += "&currentPage=";}
				else{url += "?currentPage=";}
				url = url + page + "&showCount=10";
				document.forms[0].action = url;
				document.forms[0].submit();
			}else{
				var url = document.location+'';
				if(url.indexOf('?')>-1){
					if(url.indexOf('currentPage')>-1){
						var reg = /currentPage=\d*/g;
						url = url.replace(reg,'currentPage=');
					}else{
						url += "&currentPage=";
					}
				}else{url += "?currentPage=";}
				url = url + page + "&showCount=10";
				document.location = url;
			}
		}
		
		//打开上传excel页面
		function fromExcel(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="EXCEL 导入到数据库";
			 diag.URL = 'dept/goUploadExcel.do';
			 diag.Width = 400;
			 diag.Height = 150;
			 diag.CancelEvent = function(){ //关闭事件
				diag.close();
				window.location.href='<%=basePath%>/dept/list.do';
			 };
			 diag.show();
		}
		</script>
	
</body>
</html>

