<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
	<head>
	<base href="<%=basePath%>">
	<link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/summernote-master/summernote.css"/>
    
    <script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="plugins/summernote-master/summernote.js"></script>
    <script type="text/javascript" src="plugins/summernote-master/lang/summernote-zh-CN.min.js"></script>
<body>
	<form id="saveForm" name="saveForm" action="<%=basePath%>notice/addSave.do" method="post" style="padding:5px;">
		<div style="padding:5px;">
			<table style="margin-top:20px">
				<tr>
					<td><label>发送区域：</label></td>
					<td>
						<select id="area" name="area" style="width:100px;">
							<option value="全部">全部</option>
							<c:forEach items="${areaList }" var="area">
								<option value="${area.NAME }" <c:if test="${form.FORM_AREA==area.NAME }">selected</c:if>>${area.NAME }</option>
							</c:forEach>
						</select>
					</td>
					<td><label>标题：</label></td>
					<td><input type="text" id="title" name="title" style="width:590px;"/></td>
				</tr>
			</table>
		</div>
		<div id="summernote" name="summernote" style="margin-top:20px"></div>
		<a class="btn btn-mini btn-primary" style="margin-top:5px" onclick="save();">保存</a>
		<textarea type="text" style="display:none;" name="content" id="content"></textarea>
	</form>
	
	<script type="text/javascript">
	function save(){
		if($("#title").val()==''){
			alert(请填写标题);
			return;
		}
		var sHTML = $('#summernote').summernote('code').replace(/\"/g,"'");
		$("#content").val(sHTML);
		$("#saveForm").submit();
	}
    //调用富文本编辑
    $(document).ready(function() {
        var $summernote = $('#summernote').summernote({
        	lang: 'zh-CN',
            height: 400,
            minHeight: null,
            maxHeight: null,
            focus: true,
            //调用图片上传
            callbacks: {
                onImageUpload: function (files) {
                    sendFile($summernote, files[0]);
                }
            }
        });

        //ajax上传图片
        function sendFile($summernote, file) {
            var formData = new FormData();
            formData.append("file", file);
            $.ajax({
                url: "<%=basePath%>notice/uploadImage.do",//路径是你控制器中上传图片的方法
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                type: 'POST',
                success: function (data) {
                	$summernote.summernote('editor.insertImage', data);
                }
            });
        }
    });
</script>
</body>
</html>