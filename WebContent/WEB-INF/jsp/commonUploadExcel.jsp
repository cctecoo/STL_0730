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
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />
		<!--树状图插件 -->
		<link type="text/css" rel="stylesheet" href="<%=basePath%>plugins/zTree3.5/zTreeStyle.css"/>
		
		<style type="text/css">
			.mask{ height:100%; width:100%; position:fixed; _position:absolute; 
				top:0; z-index:1000; background-color: white; opacity:0.3;} 
			.opacity{  opacity:0.3; filter: alpha(opacity=30); background-color:#000; } 
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
		</style>
		
	</head>
	<body>
		<div id="loadDiv" class="center mask" style="display:none"><br/><br/><br/><br/><br/>
			<img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">操作中...</h4>
		</div>
		<input type="hidden" id="saveResult" />
		<form action="${savePath }" name="Form" id="Form" method="post" enctype="multipart/form-data">
			<input type="hidden" name="selectModelId" value="${selectModelId }" />
			<div id="zhongxin">
				<table style="width:95%; margin:0 auto;" >
					<c:if test="${not empty costBudgetImport }"><!-- 预算导入，需要输入特定参数 -->
						<tr>
							<td colspan="2" style="padding-top: 5px;">
								<span>预算关联年度</span>
								<select id="importYear" name="importYear">
									<option value="now">${currentYear }</option>
									<option value="next">${currentYear+1 }</option>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="padding-top: 5px;">
								<span>根级成本中心</span>
								<select id="importCostDept" name="importCostDept">
									<option value="">请选择</option>
									<c:forEach items="${costDeptList }" var="costDept">
										<option value="${costDept.CODE }">${costDept.NAME } [${costDept.CODE }]</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="padding-top: 5px;">
								<span>根级财务科目</span>
								<select id="importCostItem" name="importCostItem">
									<option value="">请选择</option>
									<c:forEach items="${costItemList }" var="costItem">
										<option value="${costItem.CODE }">${costItem.NAME } [${costItem.CODE }]</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="padding-top: 5px;">
								<span>预算关联月度</span>
								<select id="importMonth" name="importMonth">
									<option value="">请选择</option>
									<c:forEach begin="1" end="12" step="1" var="m">
										<option value="${m }">${m }月份</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</c:if>
					
					<c:if test="${not empty rootItemCode }"><!-- 导入科目，成本中心，bom时，选择了根级目录 -->
						<tr style="display:none">
							<td colspan="2" style="padding-top: 5px;">
								<span>根级目录编码</span>
								<input id="rootItemCode" name="rootItemCode" value="${rootItemCode }" />
							</td>
						</tr>
					</c:if>
					
					<c:if test="${not empty importPurchaseItem }"><!-- 导入采购项 -->
						<!-- 显示成本中心树 -->
				    	<div id="treePanelCostDept" class="treePanel">
							<ul id="costDeptTree" class="ztree" style="height: 85%;"></ul>
						</div>
						<tr>
							<td><span>分摊成本中心:</span></td>
							<td style="padding-top: 5px;">
								<input class="stepLevel_1" type="hidden" id="costDeptCode" name="costDeptCode" />
								<input class="stepLevel_1" type="text" name="costDept" onclick="showCostDeptTree(this)" style="width:270px;"/>
							</td>
						</tr>
						
						<!-- 显示科目树 -->
				    	<div id="treePanel" class="treePanel">
							<ul id="costItemTree" class="ztree" style="height: 85%;"></ul>
						</div>
						<tr>
							<td><span>分摊科目:</span></td>
							<td style="padding-top: 5px;">
								
								<input class="stepLevel_1" type="hidden" id="keMuCode" name="keMuCode" />
								<input class="stepLevel_1" type="text" name="keMu" onclick="showRowTree(this)" style="width:270px;"/>
							</td>
						</tr>
						<tr>
							<td colspan="2"><input type="checkBox" name="findcostItemByName" value="findcostItemByName" style="opacity:1"/>
								<span style="margin-left: 20px;">以物料名制定的预算（上面的分摊科目，选择任意一项物料对应的科目即可）</span>
							</td>
						</tr>
					</c:if>
					
					<tr>
						<td colspan="2" style="padding-top: 20px;">
							<input type="file" id="excel" name="excel" style="width:50px;" onchange="fileType(this)" />
						</td>
					</tr>
					<tr>
						<td colspan="2" style="text-align: center;">
							<a class="btn btn-mini btn-primary" onclick="save();">导入</a>
							<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
							<c:if test="${not empty downloadPath}">
								<a class="btn btn-mini btn-success" onclick="window.location.href='<%=basePath%>${downloadPath }'">下载模版</a>
							</c:if>
							
						</td>
					</tr>
				</table>
			</div>
			<div id="zhongxin2" class="center" style="display:none"><br/><img src="static/images/jzx.gif" /><br/><h4 class="lighter block green"></h4></div>
		</form>
		
		<!--[if !IE]> -->
		<script type="text/javascript">
			window.jQuery || document.write("<script src='static/assets/js/jquery.js'>"+"<"+"/script>");
		</script>
		<!-- <![endif]-->
		<!--[if IE]>
		<script type="text/javascript">
		 	window.jQuery || document.write("<script src='static/assets/js/jquery1x.js'>"+"<"+"/script>");
		</script>
		<![endif]-->
		<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
		<script src="static/js/ajaxfileupload.js"></script>
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<script src="static/js/ajaxfileupload.js"></script>
		<script type="text/javascript" src="static/js/jquery-form.js"></script>
		
		<!-- 树插件js -->
		<script type="text/javascript" src="plugins/zTree3.5/jquery.ztree.all.min.js"></script>
		<script type="text/javascript">
			$(top.changeui());
			$(function() {
				initExcel();
				//显示科目树
				if('${importPurchaseItem}'=='true'){
					$.fn.zTree.init($("#costItemTree"), rowTreeSettingCostItem);
					$.fn.zTree.init($("#costDeptTree"), rowTreeSettingCostDept);
				}
			});
			
			function initExcel(){
				$('#excel').ace_file_input({
					no_file:'请选择EXCEL ...',
					btn_choose:'选择',
					btn_change:'更改',
					droppable:false,
					onchange:null,
					thumbnail:false, //| true | large
					whitelist:'xls|xlsx',
					blacklist:'gif|png|jpg|jpeg'
				});
			}
			
			var selectedInputTree = null;//科目
			var selectedCostDept = null;//成本中心
			//行内树配置
			var rowTreeSettingCostItem = {
				data: {
					simpleData: {
						enable: true
					},
					key: {  
			            title: "description"  
			        }
				},
				view: {
					selectedMulti: false
				},
				async: {
					enable: true,
					url:"costItem/findCostItemTreeDatas.do?isNocheckParent=true",
					autoParam:["id"]
				},
				callback: {
					beforeClick: beforeClickCostItem,
					onClick: onClickCostItem
				}
			}
			
			function beforeClickCostItem(treeId, treeNode) {//点击科目之前
				var check = (treeNode && !treeNode.isParent);
				if (!check) alert("只能选择末级");
				return check;
			}
			
			function onClickCostItem(){//点击科目之后
				var zTree = $.fn.zTree.getZTreeObj("costItemTree"),
				nodes = zTree.getSelectedNodes(true),
				v = "",
				codes = "";
				for (var i=0, l=nodes.length; i<l; i++) {
					//v += nodes[i].fullName + ",";
					var code = nodes[i].id;
					//查询选择的完整名称
					$.ajax({
						async: false,
						type: 'post',
						url: 'costItem/findFullNameByCode.do',
						data: {'code': code},
						success: function(data){
							if(data.msg=='success'){
								//拼接名称
								v += data.fullName + ",";
							}
						}
					});
					codes = nodes[i].id + ",";
				}
				if (v.length > 0 ){
					 v = v.substring(0, v.length-1);
					 codes = codes.substring(0, codes.length-1);
				}
				//设置名称
				$(selectedInputTree).val(v);
				$(selectedInputTree).prev().val(codes);
				//选择后，隐藏树
				hideRowTree();
			}
			
			function showRowTree(obj){//显示编辑行中的科目树
				selectedInputTree = $(obj);
				var objOffset = $(obj).offset();
				$("#treePanel").css({
					left:(objOffset.left) + "px", 
					top:objOffset.top + selectedInputTree.outerHeight() + "px",
					height: 180, width:220,
					'z-index': 1
				}).slideDown("fast");
				$("body").bind("mousedown", onBodyDown);
			}
			
			function hideRowTree() {//隐藏科目树
				$("#treePanel").fadeOut("fast");
				$("body").unbind("mousedown", onBodyDown);
			};
			
			function onBodyDown(event) {//页面点击时，隐藏树
				if (!( event.target.id == "treePanel" || $(event.target).parents("#treePanel").length>0)) {
					hideRowTree();
				}
			}
			
			//成本中心树设置
			var rowTreeSettingCostDept = {
				data: {
					simpleData: {
						enable: true
					},
					key: {  
			            title: "description"  
			        }
				},
				view: {
					selectedMulti: false
				},
				async: {
					enable: true,
					url:"costDept/findCostDeptTreeDatas.do?isNocheckParent=true",
					autoParam:["id"]
				},
				callback: {
					beforeClick: beforeClickCostDept,
					onClick: onClickCostDept
				}
			};
			function beforeClickCostDept(treeId, treeNode) {//点击成本中心之前
				var check = (treeNode && !treeNode.isParent);
				if (!check) alert("只能选择末级");
				return check;
			}
			
			function onClickCostDept(){//点击成本中心之后
				var zTree = $.fn.zTree.getZTreeObj("costDeptTree"),
				nodes = zTree.getSelectedNodes(true),
				v = "",
				codes = "";
				
				for (var i=0; i<nodes.length; i++) {
					var code = nodes[i].id;
					//查询选择的完整名称
					$.ajax({
						async: false,
						type: 'post',
						url: 'costDept/findFullNameByCode.do',
						data: {'code': code},
						success: function(data){
							if(data.msg=='success'){
								//拼接名称
								v += data.fullName + ",";
							}
						}
					});
					codes += nodes[i].id + ",";
				}
				if (v.length > 0 ){
					 v = v.substring(0, v.length-1);
					 codes = codes.substring(0, codes.length-1);
				}
				//设置名称
				$(selectedCostDept).val(v);
				$(selectedCostDept).prev().val(codes);
				//隐藏选择树
				hideCostDeptMenu();
			}
			
			//显示成本中心
			function showCostDeptTree(obj) {
				selectedCostDept = $(obj);
				var objOffset = $(obj).offset();
				$("#treePanelCostDept").css({
					left:(objOffset.left) + "px", 
					top: selectedCostDept.offset().top + selectedCostDept.outerHeight() + "px",
					height: 180, width:220,
					'z-index': 1
				}).slideDown("fast");

				$("body").bind("mousedown", onCostDeptBodyDown);
			}
			function hideCostDeptMenu() {
				$("#treePanelCostDept").fadeOut("fast");
				$("body").unbind("mousedown", onCostDeptBodyDown);
			}
			
			function onCostDeptBodyDown(event) {
				if (!( event.target.id == "treePanelCostDept" || $(event.target).parents("#treePanelCostDept").length>0)) {
					hideCostDeptMenu();
				}
			}
			
			//保存
			function save(){
				if($("#excel").val()=="" ){
					$("#excel").tips({
						side:3,
			            msg:'请选择文件',
			            bg:'#AE81FF',
			            time:3
			        });
					return false;
				}
				//预算导入时检查
				if('${not empty costBudgetImport}'=='true'){
					if($("#importCostDept").val()==''){
						top.Dialog.alert('请选择根级成本中心');
						return;
					}else if($("#importCostItem").val()==''){
						top.Dialog.alert('请选择根级财务科目');
						return;
					}
				}else if('${not empty importPurchaseItem }'=='true'){
					//导入采购项
					if($("#costDeptCode").val()==''){
						top.Dialog.alert('请选择成本中心');
						return;
					}
					if($("#keMuCode").val()==''){
						top.Dialog.alert('请选择科目');
						return;
					}
				}
				
				top.Dialog.confirm("是否继续导入操作？", function(){
					$("#loadDiv").show();
					if('${not empty isAjaxUpload}'=='true'){//异步上传
						/*//异步上传文件
						$.ajaxFileUpload({
			                url: $("#Form").attr("action"),
			                secureuri: false, //是否需要安全协议，一般设置为false
			                fileElementId: 'excel', //文件上传域的ID
			                dataType: 'text',
			                type: 'POST',
			                success: function(data){
			                	$("#loadDiv").hide();
			                	var result = data.replace(/<.*?>/ig,"");//ajaxFileUpload不能解析json,所以需要转化
			            */
						$("#Form").ajaxSubmit({
							dataType: 'text',
							success: function(data){
			                	$("#loadDiv").hide();
			                	//var result = data.replace(/<.*?>/ig,"");//ajaxFileUpload不能解析json,所以需要转化
			                	var result = data;
								if('noFile'==result){
									alert('没有获取到上传的文件');
								}else if('notMatchFile'==result){
									alert('模板第一行标题不匹配，请导入系统指定格式的模板');
								}else if('error'==result){
									alert('后台出错，请联系管理员');
								}else if('success'!=result){
									if(result.indexOf('"msg":') != -1){
										result = eval('('+data+')');
										if(result.msg){//有返回信息的
											if('success'!=result.msg){
												alert(result.msg);
											}
										}
									}else{
										alert(result);
									}
								}
			                	//保存导入成功的结果
			                	$("#saveResult").val(data);
			                	setTimeout(1000,top.Dialog.close());
			                },
			                error: function (data, status, e){//服务器响应失败处理函数
			                	$("#loadDiv").hide();
			                	top.Dialog.close();
								top.Dialog.alert('后台出错，请联系管理员');
			                }
						});	
					}else{
						$("#Form").submit();
						$("#zhongxin").hide();
						$("#zhongxin2").show();
					}
				});
				
			}
			
			function fileType(obj){
				var fileType=obj.value.substr(obj.value.lastIndexOf(".")).toLowerCase();//获得文件后缀名
			    if(fileType != '.xls' && fileType != '.xlsx'){
			    	$("#excel").tips({
						side:3,
			            msg:'请上传xls或者xlsx格式的文件',
			            bg:'#AE81FF',
			            time:3
			        });
			    	var file = $("#excel");
					file.parent().after(file.clone().val("")); 
					file.parent().remove();
					initExcel();
			    }
			}
		</script>
	</body>
</html>