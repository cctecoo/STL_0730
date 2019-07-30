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
		<link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/css/chosen.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		    <!-- ace styles -->
    	<link rel="stylesheet" href="static/assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style" />
    	<script src="static/js/ajaxfileupload.js"></script>
    	<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
    	<script type="text/javascript" src="static/deptTree/deptTree.js"></script>
		
		<style>
		input[type="checkbox"],input[type="radio"] {
			opacity:1 ;
			position: static;
			height:25px;
			margin-bottom:10px;
		}
		#zhongxin td{height:40px;}
	#zhongxin td label{text-align:right; margin-right:10px;}
	#zx td label{text-align:left; margin-right:0px;} 
		</style>
		<script type="text/javascript">

		</script>
	</head>
<body>
	<fmt:requestEncoding value="UTF-8" />
	<form action="repository/save.do" name="repositoryForm" id="repositoryForm" method="post">
		<input type="hidden" name="flag" id="flag" value="${msg}"/>
		<input type="hidden" name="daoru" id="daoru" value="0"/>
		<input type="hidden" name="DOCUMENT" id="document"/>
		
		<div id="zhongxin">
			<table style="margin-left: 40px;"><br>
				<input type="hidden" id="DOC_TYPE" name="DOC_TYPE" value="${pd.DOC_TYPE}"/>
				<input type="hidden" id="DEPT_CLASSIFY" name="DEPT_CLASSIFY" value="${pd.DEPT_CLASSIFY}" />
				<tr>
		        	<td><label>接收人员：</label></td>
		        	<td>
		        		<input type="text" id="EMP_NAME" readonly="readonly" style="background: #fff!important;" onclick="showDeptTree(this)"/>
                        <input type="hidden" id="EMP_ID" name="EMP_ID" >
                        <input type="hidden" id="EMP_CODE" name="EMP_CODE" >
		        		<div id="deptTreePanel" style="display:none; position:absolute; background-color:white;overflow-y:auto;overflow-x:auto;height: 250px;width: 218px;border: 1px solid #CCCCCC;z-index: 1000;">
                            <ul id="deptTree" class="tree" style="overflow: auto;padding: 0;margin: 0;"></ul>
                        </div>
		        	</td>
		        </tr>
				<tr>
					<td><label>文档说明：</label>    </td>
					<td> <textarea rows="5" cols="60" id="REMARK" name="REMARK"></textarea> </td>
		        </tr>
				<tr id="zx">
					<td><label>文档上传：</label>    </td>
					<td> <input multiple type="file" id="id-input-file-1"  name="id-input-file-1"/></td>
		        </tr>
		        
		        <tr>
			    	<td colspan="2" style="text-align: center;">
						<a class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp;
						<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
					</td>
				</tr>
    
			</table>
		</div>		
	</form>
	<!-- 引入 -->
	<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
	
	<script type="text/javascript">
		$(top.changeui());
		
		//保存
		
		
		function save(){
			if($("#id-input-file-1").val() == null || $("#id-input-file-1").val() == ""){
				top.Dialog.alert("上传文件不允许为空");
				return false;
			}
			if($("#REMARK").val().length>200){
				top.Dialog.alert("字数超过限制，最多输入200字");
				return false;
			}
			if($("#DOC_TYPE").val()=="1" && (deptTreeInner == null ||deptTreeInner.val()== null || deptTreeInner.val()=="")){
				top.Dialog.alert("下发人员必选");
				return false;
			}
			$.ajaxFileUpload({
                url: '<%=basePath%>repository/Upload.do',
                secureuri: false, //是否需要安全协议，一般设置为false
                fileElementId: 'id-input-file-1', //文件上传域的ID
                dataType: 'text',
                type: 'POST',
                success: function(data){
					
                	$("#document").val(data);
            		$("#repositoryForm").submit();
					$("#zhongxin").hide();                   	                    
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    alert(e);
                    top.Dialog.close();
                }
            });		            		            
		}
		

        
        $(function() {
			$("#id-input-file-1").ace_file_input({
				style:'well',
				btn_choose:'选择',
				btn_change:'修改',
				no_icon:'icon-cloud-upload',
				droppable:true,
				onchange:null,
				thumbnail:'small',
				before_change:function(files, dropped) {
					
					return true;
				}
				
			}).on('change', function(){
				
			});
		
			var setting = {
		            checkable: true,
		            checkType : { "Y": "ps", "N": "ps" }/*,
		            callback : {
		                beforeClick: function(treeId, treeNode){
		                
		                },
		                click: function(event, treeId, treeNode, msg){
		                	if(treeNode.isParent){
		                		var childNodes = treeNode.nodes;
		                		for(var i = 0; i < childNodes.length; i++){
		                			childNodes[i].checked=true;
		                			deptTree.updateNode(childNodes[i]);
		                		}
		                	} 
		                }
		            }
		            */
		        }
				var zTree = $("#deptTree").deptTree(setting, ${deptTreeNodes},250,218);
				//zTree.expandAll(false);
		});
	</script>
	
</body>
</html>