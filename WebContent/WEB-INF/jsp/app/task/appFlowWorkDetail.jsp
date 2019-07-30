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
				border-bottom:0px;
			}
			.keytask table{
				width:98%;
				margin:0 auto;
			}
			.keytask table tr td {
				height:30px;
				line-height: 1.3;
				word-break: break-word;
	    		overflow: visible;
	    		white-space: normal;
			}
			.btn-mini{
				padding: 0 2px;
			}
			.web_footer{
				z-index:11;
			}
			.wrapSpan{
				overflow:hidden; 
				text-overflow:ellipsis; 
				white-space:nowrap;
				width: 150px;
			}
			
			.containerDIV{
				text-align: center;
				width: 100%;
			}
			
			.flowNode{
				height: 50px;
				text-align: center;
				margin: 3px;
				display: inline-block;
				padding: 0 6px;;
				line-height: 50px;
				border-radius: 10px;
			}
			
			.gbcolor_YW_DSX{border: 1px solid #ADADAD;}
			.gbcolor_YW_YSX{background-color: #FFB752;color: white;}
			.gbcolor_YW_YJS{background-color: #5BC0DE;color: white;}
			.gbcolor_YW_YTH{background-color: #D15B47;color: white;}
			.gbcolor_YW_YWB{background-color: #438EB9;color: white;}
			
			.flow_tag{height:20px;width: 10px;border-radius: 5px;display: inline-block;vertical-align: middle;}
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
			<!-- tab页 -->
		<div class="web_menu" style="width:90%; margin-left:20px;">
			<ul id="myTab" class="nav nav-tabs">
				<li class="active" style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;"id="tab_history" href="#history" data-toggle="tab">流程历史</a></li>
				<li style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;"id="tab_image" href="#image" data-toggle="tab">流程图</a></li>
			 	<li style="width:30%;"><a id="tab_detail" style="width:100%; padding-right:0; padding-left:0;" href="#detail" data-toggle="tab">流程详情</a></li>
			</ul>
	   </div>
	</div>
		
	<div id="zhongxin" style="width:98%; margin: 10px auto; border: none" class="tab-content">
		<!-- 节点列表 -->
		<div class="tab-pane fade" id="detail">
		<c:choose>
			<c:when test="${not empty flowNodes }">
				<c:forEach items="${flowNodes }" var="node" varStatus="vs">
					<div class="keytask">
						<table>
			    			<tr>
			    				<td style="width:70px">节点名称:</td>
								<td><span>${node.NODE_NAME }</span>
								</td>
			    			</tr>
			    			<tr>
			    				<td style="width:70px">节点层级:</td>
								<td><span>${node.NODE_LEVEL }</span>
								</td>
			    			</tr>
			    			<tr>
			    				<td style="width:70px">责任部门:</td>
								<td><span>${node.DEPT_NAME }</span>
								</td>
			    			</tr>
			    			<tr>
			    				<td style="width:70px">责任人:</td>
								<td><span>${node.EMP_NAME }</span>
								</td>
			    			</tr>
			    			<!-- 
			    			<tr>
			    				<td style="width:70px">备注:</td>
								<td><span>${node.REMARKS }</span>
								</td>
			    			</tr>
			    			 -->
			    			
			    		</table>
					</div>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<span>没有流程详情数据</span>
			</c:otherwise>
		</c:choose>
		</div>
		
		<!-- 流程状态 -->
		<div id="image" class="tab-pane fade">
			<div style="position: absolute;">
				<div style="position: fixed;top: 50px;left: 3px;border: 1px solid #ADADAD;padding: 6px;">
					<div style="margin-bottom: 6px;">
						<div class="gbcolor_YW_DSX flow_tag"></div><span class="tag_title">待生效</span>
					</div>
					<div style="margin-bottom: 6px;">
						<div class="gbcolor_YW_YSX flow_tag"></div><span class="tag_title">已生效</span>
					</div>
					<div style="margin-bottom: 6px;">
						<div class="gbcolor_YW_YJS flow_tag"></div><span class="tag_title">已接收</span>
					</div>
					<div style="margin-bottom: 6px;">
						<div class="gbcolor_YW_YTH flow_tag"></div><span class="tag_title">已退回</span>
					</div>
					<div style="margin-bottom: 6px;">
						<div class="gbcolor_YW_YWB flow_tag"></div><span class="tag_title">已完毕</span>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 流程操作历史 -->
		<div class="tab-pane fade in active" id="history">
			<!-- 节点会审信息 -->
        	<div>
            	<label style="color:black">会审信息：</label>
	            <c:forEach items="${jointCheckupList }" var="checkup" varStatus="index">
	            	<div class="keytask">
		            	<table>
			             	<tr>
			             		<td style="width:20%">会审节点:</td>
			             		<td>${checkup.NODE_NAME }</td>
			             	</tr>
			             	<tr>
			             		<td style="width:20%">会审人:</td>
			             		<td>
			             			<span>${checkup.EMP_NAME }</span>
			             			<span>${checkup.OPINION_TIME }</span>
			             		</td>
			             	</tr>
		            		<tr>
			             		<td style="width:20%">操作:</td>
			             		<td>
			             			<span>${checkup.OPINION_TYPE }-</span>
			             			<span>${checkup.OPINION }</span>
			             		</td>
			             	</tr>
		            	</table>
	            	</div>
	            </c:forEach>
            </div>
            <div style="border-top:1px solid">
            	<label style="color:black">操作历史：</label>
				<div id="operHisDiv" style=""><!-- 操作历史 -->
					<table id="operHisTable" class="table table-bordered" >

					</table>
				</div>
				<%--<c:choose>
					<c:when test="${not empty flowHistory }">
						<c:forEach items="${flowHistory }" var="history" varStatus="vs">
							<div class="keytask">
								<table>
					    			
					    			<tr>
					    				<td style="width:20%">操作信息:</td>
										<td name="responsibility">
											<span>${history.OPERATOR }</span>
											<span>${history.operTime }</span>
											<span>${history.OPERA_TYPE }</span>
										</td>
					    			</tr>
					    			<c:if test="${not empty history.CURRENT_NODE_NAME }">
						    			<tr>
						    				<td style="width:20%">操作节点:</td>
											<td name=detail><span>${history.CURRENT_NODE_NAME }</span>
											</td>
						    			</tr>
					    			</c:if>
					    			<c:if test="${not empty history.NEXT_NODE_NAME }">
					    			<tr>
					    				<td style="width:70px">目标节点:</td>
										<td name="requirement"><span>${history.NEXT_NODE_NAME }</span>
										</td>
					    			</tr>
					    			</c:if>
					    			<!-- 
					    			<tr>
					    				<td style="width:70px">逾期扣分:</td>
										<td name="responsibility"><span>${history.SCORE }</span>
										</td>
					    			</tr>
					    			 -->
					    			<c:if test="${not empty history.fileList }" >
						    			<tr>
			                                <td style="width:70px">附件:</td>
			                                <td name="responsibility">
			                                <c:choose>
			                                <c:when test="${not empty history.fileList }">
			                               		    <c:forEach items="${history.fileList }" var="file" varStatus="vs">
			                            				<a style="cursor:pointer; color:#08c;" onclick="loadFile('${file.FILENAME_SERVER }')">${file.FILENAME }
			                                			</a><br>
			                            			</c:forEach>
			                            			<c:if test="${history.fileNameStr!='' }">
			                            			<br><a style="cursor:pointer;" onclick="loadAllFile('${history.fileNameStr }')" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">全部下载</a>
			                                		</c:if>
			                                </c:when>
			                                </c:choose>
			                                </td>
			                            </tr>
		                            </c:if>
		                            <c:if test="${not empty history.REMARKS }">
						    			<tr>
						    				<td style="width:70px">备注:</td>
											<td name="responsibility"><span>${history.REMARKS }</span>
											</td>
						    			</tr>
					    			</c:if>
					    		</table>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<span>没有工作明细列表数据</span>
					</c:otherwise>
				</c:choose>--%>
			</div>
		</div>
	</div>
	
	<div>
		<%@include file="../footer.jsp"%>
	</div>


		<script type="text/javascript">
			var nodes = ${nodesGson};
			$(function(){
				var maxLevel = nodes[nodes.length - 1].NODE_LEVEL;
				var startLevel = nodes[0].NODE_LEVEL;
				
				for(var i = 0; i <= maxLevel - startLevel; i++){
					$("#image").append("<div id='containerDIV_"+ (startLevel+i) +"' class='containerDIV'></div>");
					if(i != maxLevel - startLevel){
						$("#image").append("<div style='text-align:center;margin-top: 3px;'><img src='static/img/down.png'></div>");
					}
				}
				
				for(var i = 0; i < nodes.length; i++){
					var nodestr = "<div class='gbcolor_"+ nodes[i].STATUS +" flowNode'>"+ nodes[i].NODE_NAME +"</div>";
					$("#containerDIV_"+ nodes[i].NODE_LEVEL).append(nodestr);
				}
                loadOperatorHis();
			});

            //查询操作历史
            function loadOperatorHis(){
                //没有实例ID则不需要查询
                var flowWorkId = '${flowWork.ID}';
                if(''==flowWorkId){
                    return;
                }
                $("#loadDiv").show();
                //调用后台服务
                $.ajax({
                    type: 'post',
                    url: '<%=basePath%>app_task/findFlowWorkHistory.do',
                    data: {flowWorkId: flowWorkId},
                    success: function(data){
                        $("#loadDiv").hide();
                        if('error'==data){
                            top.Dialog.alert('后台出错，请联系管理员');
                        }else{
                            var obj = eval('(' + data + ')');
                            appendOperHis(obj);
                        }
                    }
                });
            }

            //拼接操作历史
            function appendOperHis(operHisList){
                var appendStr = '';
                $.each(operHisList, function(index, operHis){
                    //循环拼接历史记录
                    appendStr += '<tr><td>'
                        + '<span>' + (index+1) + '.</span>' ;
                    if('转交'!=operHis.OPERATE_TYPE){
                        appendStr += '<span style="color:red;">' + operHis.OPERATE_TYPE + ' </span>';
                    }
                    appendStr += '<span>[' + operHis.STEP_NAME + ']</span>'
                        + '<span>' + operHis.OPERATOR_EMP_NAME;

                    if(null==operHis.OPERATE_START_TIME){//判断是否有操作时间，没有则不显示
                        appendStr += '，未处理';
                    }else{//有时间的则显示
                        appendStr += '，开始：' + operHis.OPERATE_START_TIME;
                        if(null!=operHis.OPERATE_END_TIME){
                            appendStr += '，结束：' + operHis.OPERATE_END_TIME;
                        }
                    }
                    appendStr += '</span>';
                    if(null!=operHis.REMARKS){//备注
                        appendStr += '<span>，备注：' + operHis.REMARKS + '</span>';
                    }
                    //附件
                    if(null!=operHis.fileList){
                        appendStr += '<div>';
                        $.each(operHis.fileList, function(fileIndex, fileItem){
                            appendStr += '<a style="cursor:pointer;margin-left: 15px;" '
                                + ' onclick="loadFile(\'' + fileItem.FILENAME_SERVER + '\')">'
                                + fileItem.FILENAME + '</a>';
                        });
                        if(operHis.fileList.length>1){
                            appendStr += '<a style="cursor:pointer;margin-left: 5px;" '
                                + ' onclick="loadAllFile(\'' + operHis.fileNameStr + '\')" '
                                + ' class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">'
                                + '全部下载</a>';
                        };
                        appendStr +='</div>';
                    }
                    appendStr += '</td>' + '</tr>';
                });

                $("#operHisTable").append(appendStr);
            }
			
			//下载文件
            function loadFile(fileName){
                var action = '<%=basePath%>app_task/checkFile.do';
                var time = new Date().getTime();
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
                        window.location.href = '<%=basePath%>app_task/loadFile.do?fileName=' + fileName + "&time=" + time;
                    }
                });
            }
            //打包下载文件
			function loadAllFile(fileName){
				if(fileName!=''){
					var arr = fileName.split(",");
					var action = '<%=basePath%>app_task/checkFile.do';
					var flag = true;
					for(var i=0;i<arr.length;i++){
						var name = arr[i];
						$.ajax({
							async: false,
							type: "get",
							dataType:"text",
							data:{"fileName": name, "time": time},
							url: action,
							success: function(data){
								if(data==""){
									alert("文件"+name+"不存在！");
									flag = false;
								}
							}
						});
						if(flag == false){
							return;
						}
					}
					var time = new Date().getTime();
					window.location.href = '<%=basePath%>app_task/loadAllFile.do?fileName=' + fileName
						+ "&time=" + time;
				}
			}
		</script>
  </body>
</html>
