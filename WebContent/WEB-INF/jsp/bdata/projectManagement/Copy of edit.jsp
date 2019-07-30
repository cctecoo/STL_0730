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
		#product {
		 width:950px;
		 height:100px;
		 border:1px solid #ccc;
		 border-left:0;
		 border-right:0;
		}
		#product div#content {
		 position:relative;
		 width:850px;
		 height:100px;
		 display:inline-block;
		 overflow:hidden;
		 float:left;
		}
		#product div#content_list {
		 position:absolute;
		 width:4000px;
		}
		#product dl{
		 width:160px;
		 height:70px;
		 float:left;
		 margin:13px 4px;
		 padding:2px 2px;
		}
		
		#product dl dt,dd {
		 line-height:70px;
		 background:#4185d0;
		}
		#product dl dt,dd a {
		 color:#fff;
		}
		#product dl dt,dd a:hover {
		 color:#fff;
		 text-decoration:none;
		}
		#product dl dt img {
		 width:160px;
		 height:120px;
		 border:none;
		}
		#product dl dd {
		 text-align:center;
		}
		#product span.prev{
		 cursor:pointer;
		 display:inline-block;
		 width:30px;
		 height:100px;
		 margin-left:10px;
		 background:url(static/images/prev.png) no-repeat left center;
		 float:left;
		}
		#product span.next{
		 cursor:pointer;
		 display:inline-block;
		 width:30px;
		 height:100px;
		 margin-right:10px;
		 background:url(static/images/next.png) no-repeat left center;
		 float:right;
		}
		.pay_title{ font-size:18px; border-left:5px solid #005ba8; padding-left:10px; margin:15px 0;}
		/* .pay_option{ margin:50px 0;} */
		.pay_project{padding-top:20px;}
		.pay_project_left{ float:left;margin-right:20px;}
		.pay_project_right{ float:left;}
		.project_operator{float:left; margin-top:-3px; margin-left:50px;}
		.project_info{width:950px; height:110px; margin-top:5px; padding:10px; border:1px solid #ccc;}
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
			<div class="breadcrumbs" id="breadcrumbs" style="font-size:18px;font-weight:bold;margin-left:30px;margin-top:10px;">
				薪资方案：编辑
				<a class="btn btn-mini btn-danger" onclick="goBack();"
                       style="margin-left:780px;margin-top:5px;">返回</a>
			</div>
			
			<div id="loadDiv" class="center mask" style="display:none; text-align:center;"><br/><br/><br/><br/><br/>
		   	  	<img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">操作中...</h4>
		   	</div>
	    	<div class="page-content">
				<div class="row" >
					<div class="col-xs-12" style="margin-left:30px;">
						<div class="pay_option">
							<div class="pay_title">基础项</div>
							<div id="product">
								 <span class="prev"></span>
								 <div id="content">
									 <div id="content_list">
									 
										 <c:forEach items="${salaryList}" varStatus="vs" var="salary">
										 	<dl>
										 		<dd><a href="javascript:">${salary.NAME}</a></dd>
											</dl>
										 </c:forEach>
									 
									 </div>
								 </div>
								 <span class="next"></span>
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
									<select id="relateFormula">
										<option value="">选择已存在公式</option>
										<c:forEach items="${formulaList }" var="formula" >
											<option value="${formula.ID }">公式编号[${formula.CODE }]</option>
										</c:forEach>
									</select>
								</div>
								<div style="float:right;">
									<a href="javascript:" class="radiusbtn" style="background:#4185d0;" onClick="saveProject()">保存</a>
									<a href="javascript:" class="radiusbtn" style="background:#4185d0;" onClick="reviseProject()">删除</a>
									<a href="javascript:" class="radiusbtn" style="background:#4185d0;" onClick="deleteProject()">清空</a>
								</div>
								<div id="cleaner"></div>
								<div class="project_info"><!-- 循环时尽量不要以元素来换行，以避免出现span之间出现空白 -->
									<c:forEach items="${editList}" varStatus="vs" 
										var="edit"><c:choose><c:when test="${empty edit.BS_ID }"><span 
											class="element"><input type="text" value="${edit.ITEM_VALUE }" 
											style="width:50px;"  onblur="checkInputNumber(this)" 
											onchange="checkInputNumber(this)" /></span></c:when><c:otherwise><span 
										class="element">${edit.ITEM_VALUE}</span></c:otherwise></c:choose></c:forEach>
								</div>
								<div class="project_output" style="display:none;"></div>
								<div id="ID" style="display:none;">${pd.ID}</div>
							</div>
						</div>
		
					</div>
				</div>
		    </div>
		</div>
	</div>

	<!-- 引入 -->
	<script src="static/js/jquery-1.7.2.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<!-- 引入 -->
	
	<script type="text/javascript">
		$(function(){
		    var page = 1;
		    var i = 5; //每版放4个图片
		    //向后 按钮
		    $("span.next").click(function(){    //绑定click事件
				var content = $("div#content"); 
				var content_list = $("div#content_list");
				var v_width = content.width()/i;
				var len = content.find("dl").length;
				var page_count = Math.ceil(len)-4 ;   //只要不是整数，就往大的方向取最小的整数
				if(page_count<=0){
					page_count=1;
				}
				if( !content_list.is(":animated") ){    //判断“内容展示区域”是否正在处于动画
				  	if( page == page_count ){  //已经到最后一个版面了,如果再向后，必须跳转到第一个版面。
					 	//content_list.animate({ left : '0px'}, "slow"); //通过改变left值，跳转到第一个版面
					 	//page = 1;
				  	}else{
				 		content_list.animate({ left : '-='+v_width }, "slow");  //通过改变left值，达到每次换一个版面
					 	page++;
				 	}
				}
			});
 			//往前 按钮
 			$("span.prev").click(function(){
	   			var content = $("div#content"); 
				var content_list = $("div#content_list");
				var v_width = content.width()/i;
				var len = content.find("dl").length;
				var page_count = Math.ceil(len / i) ;   //只要不是整数，就往大的方向取最小的整数
			   	if(!content_list.is(":animated") ){    //判断“内容展示区域”是否正在处于动画
			     	if(page == 1 ){  //已经到第一个版面了,如果再向前，必须跳转到最后一个版面。
				     	//content_list.animate({ left : '-='+v_width*(page_count-1) }, "slow");
				    	//page = page_count;
				   	}else{
				    	content_list.animate({ left : '+='+v_width }, "slow");
				    	page--;
				   	}
			  	}
		    });
 			//选择已存在的公式后，加载对应的公式详情
			$("#relateFormula").change(function(){
				//选择的不是销售记录，则隐藏显示金额的行
				loadRelateFormulaDetail();
			});
		});
		
		//加载公式关联的详情信息
		function loadRelateFormulaDetail(){
			//获取选择的公式ID
			var relateFormulaId = $("#relateFormula").val();
			$.ajax({
				type: 'post',
				url: '<%=basePath%>projectManagement/findDetailByFormulaId.do',
				data: {ID: relateFormulaId},
				success: function(data){
					if('error'==data){
						alert('后台出错，请联系管理员');
					}else if(''==data){
						alert('选择公式的没有配置信息');
					}else{
						var obj = eval('(' + data + ')');
						var appendStr = '<span class="element">(</span>';
						$.each(obj, function(i, item){
							if(item.BS_ID){
								appendStr += '<span class="element">' + item.ITEM_VALUE + '</span>';
							}else{
								appendStr += '<span class="element">'
									+ '<input type="text" value="' + item.ITEM_VALUE + '" style="width:50px;" '
									+ ' onblur="checkInputNumber(this)" onchange="checkInputNumber(this)" />'
									+ '</span>';
							}
						});
						appendStr += '<span class="element">)</span>';
						$(".project_info").empty();
						$(".project_info").append(appendStr);
					}
				}
			});
		}

	</script>
		
	<script>
		//点击基础项
		$("#content_list dd").click(function(){
			var element	= $(this).text();
			//alert(element);
			$(".project_info").append('<span class="element">'+element+'</span>');
		});
		
		//点击运算符
		$(".project_operator img").click(function(){
			var operator = $(this).attr("alt");
			//alert(operator);
			$(".project_info").append('<span class="element">'+operator+'</span>');
		});
		
		//点击系数
		$("#itemParam").click(function(){
			var eleStr = '<span class="element"><input type="text" value="" style="width:50px;" ' 
				+ ' onblur="checkInputNumber(this)" onchange="checkInputNumber(this)" /></span>';
			$(".project_info").append(eleStr);
		});
				
		//检查数字格式
		function checkInputNumber(obj) {
		    var patrn = /^0.([0-9]{1,2})$/;
		    if (!patrn.test($(obj).val())) {//校验不符合格式
		    	showMsgText(obj, '请输入小于1的系数，最多包含两位小数。');
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
				
		//保存公式
		function saveProject(){
			//检查系数是否输入正确
			var isMatchNum = true;
			$(".project_info input").each(function(){
				if(!isMatchNum){
					return;
				}
				isMatchNum = checkInputNumber(this);
			});
			if(!isMatchNum){
				return ;
			}
			
			//拼接公式的内容
			$(".project_info span").each(function(){
				var info = $(this).html();
				if(info.indexOf('<input') != -1){//系数，只获取输入的值
					info = $(this).find("input").val();
				}
				$(".project_output").append(info+',');
			});
			//执行保存
			top.Dialog.confirm("保存当前方案?",function(){
				top.jzts();
				var info = $(".project_output").text();
				if(info == ''){
					top.Dialog.alert("请先配置公式再保存");
					return;
				}
				//显示加载
				$("#loadDiv").show();
				var id = $("#ID").text();
				var url = "<%=basePath%>/projectManagement/edit.do?addInfo="+encodeURI(encodeURIComponent(info))+"&ID="+id;
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
			$(".project_info span:last").remove();
		}
		
		//清空
		function deleteProject(){
			$(".project_info span").remove();
		}
		
		//返回
	    function goBack(){
	    	window.location.href = "<%=basePath%>projectManagement/list.do";
	    }
	</script>
	<body style="overflow:-Scroll;overflow-y:hidden;overflow-x:hidden"> 
	</body>
</html>
