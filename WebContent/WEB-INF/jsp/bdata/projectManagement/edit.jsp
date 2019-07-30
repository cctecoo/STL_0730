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
		 overflow-y:scroll;
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
		
		.pay_title{ font-size:16px; border-left:5px solid #005ba8; padding-left:10px; margin:15px 0 5px 0;}
		/* .pay_option{ margin:50px 0;} */
		.pay_project{width:90%; }
		.pay_project_left{ float:left;margin-right:20px;}
		.pay_project_right{ float:left;}
		.project_operator{float:left; margin: 0 50px;}
		.project_info{ height:100px; margin-top:5px; padding:10px; border:1px solid #ccc;}
		.radiusbtn{ color:#fff;border-radius:25px; padding:5px 10px;}
		.radiusbtn:hover{color:#fff; text-decoration:none;}
		.radiusbtn:focus{color:#fff; text-decoration:none;}
		
		.deptSal_info{ height:80px; margin-top:5px; padding:10px; border:1px solid #ccc;}
		
		.mask{margin-top:5px; height:100%; width:100%; position:fixed; _position:absolute; 
			top:0; z-index:1000; background-color: white; opacity:0.3;} 
		.opacity{  opacity:0.7; filter: alpha(opacity=30); background-color:#000; }
	</style>
	
</head>
<body style="overflow-x:hidden">

<!---右侧部门选择--->
	<div id="main-content">
		<!---右侧表格显示--->
		<div class="main-content">
			
			
			<div id="loadDiv" class="center mask" style="display:none; text-align:center;"><br/><br/><br/><br/><br/>
		   	  	<img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">操作中...</h4>
		   	</div>
	    	<div class="page-content">
				<div class="row" >
					<div class="col-xs-12" style="margin-left:30px;">
						
						<div style="margin:10px;">
							<div>
								<label>公式名称:</label>
								<input id="formulaName" type="text" name="formulaName" value="${pd.FORMULA_NAME }" 
									style="margin:0 10px; width:300px" maxlength="50"/>
							</div>
							<div style="margin-top:10px; ">
								<label>适用类型:</label>
								<input type="radio" name="formulaType" value="productLine" 
									<c:if test="${pd.FORMULA_TYPE=='productLine' }">checked="checked"</c:if> />产线经理等管理人员
								<input type="radio" name="formulaType" value="dept" 
									<c:if test="${pd.FORMULA_TYPE=='dept' }">checked="checked"</c:if> />车间主任等管理人员
								<input type="radio" name="formulaType" value="baseEmp" 
									<c:if test="${pd.FORMULA_TYPE=='baseEmp' }">checked="checked"</c:if> />车间工人等基层人员
							</div>
						</div>
					
						<div class="pay_option">
							<div class="pay_title">点击添加基础项</div>
							<div id="content_list">
								 <c:forEach items="${salaryList}" varStatus="vs" var="salary">
								 	<dl>
								 		<dd><a href="javascript:" title="${salary.NAME}">${salary.NAME}</a></dd>
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
									<button id="btn_product" class="btn btn-small btn-info active btn-sal">配置车间产量工资</button>
							   		<button id="btn_emp" class="btn btn-small btn-info btn-sal" >配置车间工人</button>
									<c:forEach items="${operList}" varStatus="vs" var="oper">
										<button  class="btn btn-small btn-info btn-operator" alt="${oper.NAME }">
											<c:choose>
												<c:when test="${oper.NAME=='-' }"><i class="icon-minus"></i></c:when>
												<c:otherwise>${oper.NAME}</c:otherwise>
											</c:choose>
										</button>
									</c:forEach>
									<button id="itemParam" class="btn btn-small btn-info"
										title="小于1的系数，最多包含两位小数">系数</button>
								</div>
								<button class="btn btn-small btn-primary" onclick="saveProject();">保存</button>
								<button class="btn btn-small btn-primary" onclick="reviseProject();">删除</button>
								<button class="btn btn-small btn-primary" onclick="deleteProject();">清空</button>
								<button class="btn btn-small btn-danger" onclick="goBack();">返回</button>
							</div>
						</div>
						<div id="cleaner"></div>
								
						<div class="pay_project div-sal">
							<div class="pay_title">车间产量绩效工资</div>
							<div class="deptSal_info">
								<c:forEach items="${productFormulaItemList}" varStatus="vs" 
									var="edit"><c:choose><c:when test="${empty edit.BS_ID }"><span 
										class="element"><input type="text" value="${edit.ITEM_VALUE }" 
										style="width:50px;"  onblur="checkInputNumber(this)" 
										onchange="checkInputNumber(this)" /></span></c:when><c:otherwise><span 
									class="element">${edit.ITEM_VALUE}</span></c:otherwise></c:choose></c:forEach>
							</div>
							<div class="output" style="display:none;"></div>
						</div>
						
						<div class="pay_project">
							<div class="pay_title div-sal">车间工人工资(需要关联 车间产量绩效工资))</div>
							<div class="project_info"><!-- 循环时尽量不要以元素来换行，以避免出现span之间出现空白 -->
								<c:forEach items="${editList}" varStatus="vs" 
									var="edit"><c:choose><c:when test="${empty edit.BS_ID }"><span 
										class="element"><input type="text" value="${edit.ITEM_VALUE }" 
										style="width:50px;"  onblur="checkInputNumber(this)" 
										onchange="checkInputNumber(this)" /></span></c:when><c:otherwise><span 
									class="element">${edit.ITEM_VALUE}</span></c:otherwise></c:choose></c:forEach>
							</div>
							<div class="output" style="display:none;"></div>
							<div id="ID" style="display:none;">${pd.ID}</div>
						</div>
								
								
							</div>
						</div>
		
					</div>
				</div>
		    </div>
</body>

	<!-- 引入 -->
	<script src="static/js/jquery-1.7.2.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<!-- 引入 -->
	
	<script type="text/javascript">
	
		$(function(){
			showSalButton('${pd.FORMULA_TYPE}');
		})
		//判断是否显示配置车间产量绩效工资
		function showSalButton(type){
			if(type=='baseEmp'){//配置工人公式
				$(".btn-sal").show();
				$(".div-sal").show();
				$("#btn_product").addClass("active");
				$("#btn_emp").removeClass("active");
			}else{
				$(".btn-sal").hide();
				$(".div-sal").hide();
				$("#btn_product").removeClass("active");
				$("#btn_emp").addClass("active");
			}
		}
	
		//点击公式类型
		$(".formulaType").click(function(){
			showSalButton($(this).val());
		});
		//点击基础项
		$("#content_list dd").click(function(){
			var element	= $(this).text();
			//alert(element);
			$(getActiveDiv()).append('<span class="element">'+element+'</span>');
		});
		//点击运算符
		$(".btn-operator").click(function(){
			var operator = $(this).attr("alt");
			//alert(operator);
			$(getActiveDiv()).append('<span class="element">'+operator+'</span>');
		});
		//点击系数
		$("#itemParam").click(function(){
			var eleStr = '<span class="element"><input type="text" value="" style="width:50px;" ' 
				+ ' onblur="checkInputNumber(this)" onchange="checkInputNumber(this)" /></span>';
			$(getActiveDiv()).append(eleStr);
		});
		//点击配置工资按钮
		$(".btn-sal").click(function(){
			$(".btn-sal").each(function(){
				$(this).removeClass("active");
			});
			$(this).addClass("active");
		});
		//获取当前有效的公式div
		function getActiveDiv(){
			if($("#btn_product").hasClass("active")){//配置产品的产量工资计算
				return ".deptSal_info";
			}else{
				return ".project_info";
			}
		}
			
		//检查数字格式
		function checkInputNumber(obj) {
		    //var patrn = /^0.([0-9]{1,2})$/;
		    var patrn = /^(([0-9]+)|0)(.[0-9]{1,2})?$/;
		    if (!patrn.test($(obj).val())) {//校验不符合格式
		    	showMsgText(obj, '请输入系数，最多包含两位小数。');
		    	return false
		    }else{
		    	return true;
		    }
		}
				
		//显示提示信息
		function showMsgText(obj, text){
			$(obj).tips({
				side:3,
	            msg:text,
	            bg:'#AE81FF',
	            time:1
	        });
		}
		
		//检查产品公式
		function checkProductFormula(divClass){
			//检查系数是否输入正确
			var isMatchNum = true;
			$(divClass+" input").each(function(){
				if(!isMatchNum){
					return;
				}
				isMatchNum = checkInputNumber(this);
			});
			if(!isMatchNum){
				return false;
			}
			
			//拼接公式的内容
			$(divClass).next(".output").empty();
			$(divClass+" span").each(function(){
				var info = $(this).html();
				if(info.indexOf('<input') != -1){//系数，只获取输入的值
					info = $(this).find("input").val();
				}
				$(divClass).next(".output").append(info+',');
			});
			var info = $(divClass).next(".output").text();
			
			if(info == ''){
				showMsgText($(divClass), "请先配置公式再保存")
				return false;
			}
			return true;
		}
		
		//保存公式
		function saveProject(){
			var formulaType = $("input[name='formulaType']:checked").val();
			var formulaName = $("#formulaName").val();
			if(formulaName==''){
				alert('请填写名称');
				return;
			}
			var isBaseEmpFormula = formulaType=='baseEmp';
			//检查是否配置车间工人的公式
			if(isBaseEmpFormula){//配置工人公式
				//先检查是否配置了产品的公式
				if(!checkProductFormula(".deptSal_info")){
					return;
				}
			}
			if(!checkProductFormula(".project_info")){
				return;
			}
			
			//执行保存
			top.Dialog.confirm("保存当前方案?",function(){
				top.jzts();
				
				//显示加载
				$("#loadDiv").show();
				var id = $("#ID").text();
				var formulaName = $("#formulaName").val();
				var info = $(".project_info").next(".output").text();
				var url = "<%=basePath%>/projectManagement/edit.do?addInfo="+encodeURI(encodeURIComponent(info))+"&ID="+id
					+ "&formulaName=" + formulaName + "&formulaType=" + formulaType+"&productFormulaInfo=";
				if(isBaseEmpFormula){//车间工人的，需要保存产品的工资计算
					var productFormulaInfo =  $(".deptSal_info").next(".output").text();
					url +=  encodeURI(encodeURIComponent(productFormulaInfo));
				}
				$.get(url,function(data){
					$("#loadDiv").hide();
					if(data=="success"){
						window.location.href = "<%=basePath%>projectManagement/list.do";
						
					}else{
						top.Dialog.alert("方案保存失败！");
					}
				},"text");
			}); 
			
			//alert($(".project_output").text());
		}
		
		//删除
		function reviseProject(){
			$(getActiveDiv()+" span:last").remove();
		}
		
		//清空
		function deleteProject(){
			$(getActiveDiv()+" span").remove();
		}
		
		//返回
	    function goBack(){
	    	window.location.href = "<%=basePath%>projectManagement/list.do";
	    }
	</script>
	
</html>
