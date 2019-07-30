<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<base href="<%=basePath%>">
		<meta charset="utf-8" />
		<title>推送计划</title>
		<meta name="keywords" content="" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="description" content="" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />

		<!-- basic styles -->
		<link href="plugins/Bootstrap/css/bootstrap.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/navigation/assets/css/font-awesome.min.css" />
		<link rel="stylesheet" href="static/assets/css/jquery-ui-1.10.3.custom.min.css" />
		<link rel="stylesheet" href="static/assets/css/chosen.css" />
		<link rel="stylesheet" href="static/assets/css/datepicker.css" />
		<link rel="stylesheet" href="static/assets/css/bootstrap-timepicker.css" />
		<link rel="stylesheet" href="static/assets/css/daterangepicker.css" />
		<link rel="stylesheet" href="static/assets/css/colorpicker.css" />
		<link rel="stylesheet" href="static/assets/css/ace.min.css" />
		<link rel="stylesheet" href="static/assets/css/ace-rtl.min.css" />
		<link rel="stylesheet" href="static/assets/css/ace-skins.min.css" />
		<link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>

		<script src="static/assets/js/ace-extra.min.js"></script>
		<script type="text/javascript" src="plugins/JQuery/jquery-1.12.2.min.js"></script>
		
		<style>
			input[type=checkbox]+.lbl::before, input[type=radio]+.lbl::before{height:15px;min-width:15px;}
			.btn-style1{width:50px; height:30px; font-size:12px; padding:7px 12px; background:#3598dc; color:#fff;}
			.btn-style2{width:50px; height:30px; font-size:12px; padding:7px 12px; background:#888888; color:#fff;}
			.btn-style3{width:50px; height:30px; font-size:12px; padding:7px 12px; background:#5bc0de; color:#fff;}
			.employee_top{padding-top:10px; border-bottom:2px solid #98c0d9; z-index:10000;position:fixed;width:100%;background-color:white; line-height:40px; margin-bottom:15px;}
			.employee_title{float:left; margin-left:20px; border-bottom:3px solid #448fb9; height:38px; font-size:24px; color:#448fb9;}
			.employee_search{float:right;}
			.employee_search a:hover{color:#fff;}
			.pushmessage{width:100%;min-width:500px;padding-top:30px;padding-left:50px;font-size:16px; }
			.pushmessage_title{font-size:20px;padding-left:5px;border-left:5px solid #5090c1;margin-left:20px;}
			.pushmessage span{margin-right:30px;}
			.pushmessage .option{margin-bottom:30px;}
			.pushmessage .option_info{margin-bottom:30px; display:none;}
			.btn-mini{padding:0 6px;}
			
			
			input[type="checkbox"],input[type="radio"] {
				opacity:1 ;
				position: static;
				height:25px;
				margin-bottom:10px;
			}
		</style>
</head>
	<body>	
	<form action="configPlan/saveConfig.do" name="configPlanForm" id="configPlanForm" method="post">
		<input type="hidden" name="ID" id="viewName" value="${plan.ID }" title="计划ID" />
		<input type="hidden" name="viewName" id="viewName" value="${pd.viewName }" title="对应报表" />
		<input type="hidden" name="flag" id="flag" value="${flag}" title="对应新增还是修改" />		
		<input type="hidden" name="DAY_FOR_WEEK" id="DAY_FOR_WEEK" value="${plan.DAY_FOR_WEEK}" title="对应新增还是修改" />		
		<div id="page-content">
		<div class="employee_top">
			<c:if test="${pd.viewName == 'chart'}">
			<div class="employee_title">销售分析推送计划</div>
			</c:if>
			<c:if test="${pd.viewName == 'ranking'}">
			<div class="employee_title">系统使用情况推送计划</div>
			</c:if>
			<c:if test="${pd.viewName == 'report'}">
			<div class="employee_title">日常工作提交情况推送计划</div>
			</c:if>
			<c:if test="${pd.viewName == 'timeout'}">
			<div class="employee_title">各类工作超期情况推送计划</div>
			</c:if>
			<c:if test="${pd.viewName == 'weeklysummary'}">
			<div class="employee_title">本周系统积分排名推送计划</div>
			</c:if>
			<div class="employee_search">
				<a class="btn-style1" style="margin-right:10px;cursor:pointer" onclick="save();">保存</a>
				<a class="btn-style2" style="margin-right:10px;cursor:pointer" onclick="view();">报告预览</a>
				<a class="btn-style3" style="margin-right:10px;cursor:pointer" onclick="goBack();">返回</a>
			</div>
			<div id="cleaner"></div>
		</div>			
		<div  style="padding-top:75px">
			<div class="col-xs-8" style="position:inherit;">
			<div class="pushmessage_title">消息模板</div>
				<div class="pushmessage">
					<div style="width:300px; height:250px;  border:1px solid #ccc; margin-bottom:30px; display:inline-block;">
						<textarea style="width:100%;height:100%;display:block;" name="MODEL" >${plan.MODEL}</textarea>
					</div>
					<div style="width:300px; height:250px;  padding:50px 0 0 50px; margin-bottom:30px; display:inline-block;">
						<table>
							<th>可用变量列表</th>
							<c:if test="${pd.viewName == 'chart'}">
								<tr><td>{user} 接受对象（姓名）</td></tr>
								<tr><td>{duty} 接受对象职务</td></tr>
								<tr><td>{sales} 销售数量</td></tr>
								<tr><td>{salesAmount} 销售金额量</td></tr>
							</c:if>
							<c:if test="${pd.viewName == 'ranking'}">
								<tr><td>{user} 接受对象（姓名）</td></tr>
								<tr><td>{duty} 接受对象职务</td></tr>
								<tr><td>{first} 第一名部门名称</td></tr>
								<tr><td>{second} 第二名部门名称</td></tr>
								<tr><td>{third} 第三名部门名称</td></tr>
							</c:if>
							<c:if test="${pd.viewName == 'report'}">
								<tr><td>{duty} 接受所属部门</td></tr>
								<tr><td>{date} 日期</td></tr>
							</c:if>
							<c:if test="${pd.viewName == 'timeout'}">
								<tr><td>{duty} 接受所属部门</td></tr>
								<tr><td>{date} 日期</td></tr>
							</c:if>
							<c:if test="${pd.viewName == 'weeklysummary'}">
								<tr><td>{duty} 接受所属部门</td></tr>
								<tr><td>{date} 截止日期</td></tr>
								<tr><td>{dates} 起始日期</td></tr>
							</c:if>
						</table>
					</div>
				</div>
			<div class="pushmessage_title">推送规则</div>
				<div class="pushmessage">
					<div <c:if test="${pd.viewName == 'report'||pd.viewName =='timeout'||pd.viewName =='weeklysummary'}">style="display: none"</c:if>class="option">
						<span style="color:#000;">推送规则</span>
						<input  type="radio" class="ace ace" id= "ace1" name="rule" value="1"<c:if test="${plan.RULE == 1}">checked="checked"</c:if>/>
						<span class="lbl" style="margin-top:-5px;"> </span>
						<span>每天</span>
						<input  type="radio" class="ace ace" id= "ace2" name="rule" value="2"<c:if test="${plan.RULE == 2}">checked="checked"</c:if>/>
						<span class="lbl" style="margin-top:-5px;"> </span>
						<span>每周</span>
						<input  type="radio" class="ace ace" id= "ace3" name="rule" value="3"<c:if test="${plan.RULE == 3}">checked="checked"</c:if>/>
						<span class="lbl" style="margin-top:-5px;"> </span>
						<span>每月</span>
					</div>
					
					<div class="option_info ace1_show" style="display:block;">
						请设置每天发送时间
						<br><br>
						<div style="display:table;">
						<span style="color:#000;display:table-cell;padding-right:30px;">推送时间</span>
							<div class="input-group bootstrap-timepicker" style="display:table-cell;">
							<input id="timepicker1" type="text" class="form-control" style="width:220px; display:table-cell;" name ="DAYTIME" value="${plan.DAYTIME }"/>
							<span class="input-group-addon" style="width:50px;height:34px;display:table-cell;">
								<i class="icon-time bigger-110"></i>
							</span>
							</div>
						</div>
						
						<div >
						<br>
						<span style="color:#000;">截止到：</span>
						<input type="radio" class="ace" name = "DATA_TYPE" value="1"<c:if test="${plan.DATA_TYPE == 1}">checked="checked"</c:if>/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  当天</span>
						<input type="radio" class="ace" name = "DATA_TYPE" value="2"<c:if test="${plan.DATA_TYPE == 2}">checked="checked"</c:if>/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  昨天</span>
						</div>
					</div>
					
					<div class="option_info ace2_show">
						请设置每周发送时间
						<br><br>
						<span style="color:#000;">推送日期</span>
						<input type="checkbox" class="ace" name="week" id="week2" value="2"/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  周一</span>
						<input type="checkbox" class="ace" name="week" id="week3" value="3"/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  周二</span>
						<input type="checkbox" class="ace" name="week" id="week4" value="4"/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  周三</span>
						<input type="checkbox" class="ace" name="week" id="week5" value="5"/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  周四</span>
						<input type="checkbox" class="ace" name="week" id="week6" value="6"/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  周五</span>
						<input type="checkbox" class="ace" name="week" id="week7" value="7"/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  周六</span>
						<input type="checkbox" class="ace" name="week" id="week1" value="1"/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  周日</span>
						<br><br>
						
						<div style="display:table;">
						<span style="color:#000;display:table-cell;padding-right:30px;">推送时间</span>
							<div class="input-group bootstrap-timepicker">
							<input id="timepicker2" type="text" class="form-control" style="width:220px; display:table-cell;" name ="WEEKTIME" value="${plan.WEEKTIME }"/>
							<span class="input-group-addon" style="width:50px;display:table-cell;">
								<i class="icon-time bigger-110"></i>
							</span>
							</div>
						</div>
						
						<div <c:if test="${pd.viewName == 'report'||pd.viewName =='timeout'||pd.viewName =='weeklysummary'}">style="display: none"</c:if>>
						<br>
						<span style="color:#000;">截止到：</span>
						<input type="radio" class="ace" name = "DATA_TYPE" value="3"<c:if test="${plan.DATA_TYPE == 3}">checked="checked"</c:if>/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  本周</span>
						<input type="radio" class="ace" name = "DATA_TYPE" value="4"<c:if test="${plan.DATA_TYPE == 4}">checked="checked"</c:if>/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  上周</span>
						</div>
					</div>
					
					<div class="option_info ace3_show">
						请设置每月发送时间
						<br><br>
						<div style="display:table;">
						<span style="color:#000;">推送日期</span>
<%-- 						<input type="text" class="form-control" style="width:220px; display:table-cell;" name ="month" value="${plan.DAY_FOR_MONTH }"/>
						<span class="input-group-addon" style="width:50px;display:table-cell;">
							<i class="icon-calendar bigger-110"></i>
						</span> --%>
							<select class="chzn-select" id="searchType"  name="month" style="width:220px; padding-bottom:3px" onchange="selectSearchType();">
								<option value=''>请选择</option>
								<option value='1' <c:if test="${1 == plan.DAY_FOR_MONTH}">selected</c:if>>1</option>
								<option value='2' <c:if test="${2 == plan.DAY_FOR_MONTH}">selected</c:if>>2</option>
								<option value='3' <c:if test="${3 == plan.DAY_FOR_MONTH}">selected</c:if>>3</option>
								<option value='4' <c:if test="${4 == plan.DAY_FOR_MONTH}">selected</c:if>>4</option>
								<option value='5' <c:if test="${5 == plan.DAY_FOR_MONTH}">selected</c:if>>5</option>
								<option value='6' <c:if test="${6 == plan.DAY_FOR_MONTH}">selected</c:if>>6</option>
								<option value='7' <c:if test="${7 == plan.DAY_FOR_MONTH}">selected</c:if>>7</option>
								<option value='8' <c:if test="${8 == plan.DAY_FOR_MONTH}">selected</c:if>>8</option>
								<option value='9' <c:if test="${9 == plan.DAY_FOR_MONTH}">selected</c:if>>9</option>
								<option value='10' <c:if test="${10 == plan.DAY_FOR_MONTH}">selected</c:if>>10</option>
								<option value='11' <c:if test="${11 == plan.DAY_FOR_MONTH}">selected</c:if>>11</option>
								<option value='12' <c:if test="${12 == plan.DAY_FOR_MONTH}">selected</c:if>>12</option>
								<option value='13' <c:if test="${13 == plan.DAY_FOR_MONTH}">selected</c:if>>13</option>
								<option value='14' <c:if test="${14 == plan.DAY_FOR_MONTH}">selected</c:if>>14</option>
								<option value='15' <c:if test="${15 == plan.DAY_FOR_MONTH}">selected</c:if>>15</option>
								<option value='16' <c:if test="${16 == plan.DAY_FOR_MONTH}">selected</c:if>>16</option>
								<option value='17' <c:if test="${17 == plan.DAY_FOR_MONTH}">selected</c:if>>17</option>
								<option value='18' <c:if test="${18 == plan.DAY_FOR_MONTH}">selected</c:if>>18</option>
								<option value='19' <c:if test="${19 == plan.DAY_FOR_MONTH}">selected</c:if>>19</option>
								<option value='20' <c:if test="${20 == plan.DAY_FOR_MONTH}">selected</c:if>>20</option>
								<option value='21' <c:if test="${21 == plan.DAY_FOR_MONTH}">selected</c:if>>21</option>
								<option value='22' <c:if test="${22 == plan.DAY_FOR_MONTH}">selected</c:if>>22</option>
								<option value='23' <c:if test="${23 == plan.DAY_FOR_MONTH}">selected</c:if>>23</option>
								<option value='24' <c:if test="${24 == plan.DAY_FOR_MONTH}">selected</c:if>>24</option>
								<option value='25' <c:if test="${25 == plan.DAY_FOR_MONTH}">selected</c:if>>25</option>
								<option value='26' <c:if test="${26 == plan.DAY_FOR_MONTH}">selected</c:if>>26</option>
								<option value='27' <c:if test="${27 == plan.DAY_FOR_MONTH}">selected</c:if>>27</option>
								<option value='28' <c:if test="${28 == plan.DAY_FOR_MONTH}">selected</c:if>>28</option>
							</select>
						</div>
						<br>
						<div style="display:table;">
						<span style="color:#000;display:table-cell;padding-right:30px;">推送时间</span>
							<div class="input-group bootstrap-timepicker">
							<input id="timepicker3" type="text" class="form-control" style="width:220px; display:table-cell;" name ="MONTHTIME" value="${plan.MONTHTIME }"/>
							<span class="input-group-addon" style="width:50px;display:table-cell;">
								<i class="icon-time bigger-110"></i>
							</span>
							</div>
						</div>
						<br>
						<span style="color:#000;">截止到：</span>
						<input type="radio" class="ace" name = "DATA_TYPE" value="5"<c:if test="${plan.DATA_TYPE == 5}">checked="checked"</c:if>/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  本月</span>
						<input type="radio" class="ace" name = "DATA_TYPE" value="6"<c:if test="${plan.DATA_TYPE == 6}">checked="checked"</c:if>/>
						<span class="lbl" style="margin-top:-8px;"></span>
						<span>  上月</span>
					</div>
					<div class="option" style="display:table;">
						<span style="color:#000;">推送对象</span>
<%-- 						<input type="text" class="form-control" style="width:220px; display:table-cell;" name="object" value="${plan.object }"/>
						<span class="input-group-addon" style="width:50px;display:table-cell;">
							<i class="icon-user bigger-110"></i>
						</span> --%>
		        		<input type="text" id="EMP_NAME" readonly="readonly" style="background: #fff!important;" onclick="showDeptTree(this)" value="${pdm.empName}"/>
                        <input type="hidden" id="EMP_ID" name="EMP_ID" value="${pdm.empId}">
		        		<div id="deptTreePanel" style="display:none; position:absolute; background-color:white;overflow-y:auto;overflow-x:auto;height: 250px;width: 218px;border: 1px solid #CCCCCC;z-index: 1000;">
                            <ul id="deptTree" class="tree" style="overflow: auto;padding: 0;margin: 0;"></ul>
                        </div>
					</div>
					<div class="option" style="display:table;">
						<span style="color:#000;">启用日期</span>
						<input class="form-control date-picker" type="text" data-date-format="yyyy-mm-dd" style="width:220px;display:table-cell;" id ="START_DATE" name="START_DATE" value="${plan.START_DATE }"/>
						<span class="input-group-addon" style="width:50px;display:table-cell;">
							<i class="icon-calendar bigger-110"></i>
						</span>
					</div>
					<div class="option" style="display:table;">
						<span style="color:#000;">失效日期</span>
						<input class="form-control date-picker" type="text" data-date-format="yyyy-mm-dd" style="width:220px;display:table-cell;" id ="END_DATE" name="END_DATE" value="${plan.END_DATE }"/>
						<span class="input-group-addon" style="width:50px;display:table-cell;">
							<i class="icon-calendar bigger-110"></i>
						</span>
					</div>
				</div>
			</div><!--col-xs-8-->
			<div class="col-xs-4">
			  <div style="width:300px; height:620px; margin-top:50px; background:url(static/img/iphone.png); background-size:100% 100%;visibility:hidden;" id ="view">
			  	<iframe src="app_chart/${pd.viewName}.do" id="iphoneshow" style="width:252px; height:462px;border:0;margin-left:24px;margin-top:81px;"></iframe>
			  </div>
			</div>
			</div><!--row-->
		</div><!--page-content-->
		</form>
		<script src="static/assets/js/jquery-1.10.2.min.js"></script>
		<script src="static/assets/js/bootstrap.min.js"></script>
		<script src="static/assets/js/typeahead-bs2.min.js"></script>

		<!-- page specific plugin scripts -->

		

		<!-- ace scripts -->
		
		<script src="static/assets/js/jquery-ui-1.10.3.custom.min.js"></script>
		<script src="static/assets/js/jquery.ui.touch-punch.min.js"></script>
		<script src="static/assets/js/chosen.jquery.min.js"></script>
		<script src="static/assets/js/fuelux/fuelux.spinner.min.js"></script>
		<script src="static/assets/js/date-time/bootstrap-datepicker.min.js"></script>
		<script src="static/assets/js/date-time/bootstrap-datetimepicker.zh-CN.js"></script>
		<script src="static/assets/js/date-time/bootstrap-timepicker.min.js"></script>
		<script src="static/assets/js/date-time/moment.min.js"></script>
		<script src="static/assets/js/date-time/daterangepicker.min.js"></script>
		<script src="static/assets/js/bootstrap-colorpicker.min.js"></script>
		<script src="static/assets/js/jquery.knob.min.js"></script>
		<script src="static/assets/js/jquery.autosize.min.js"></script>
		<script src="static/assets/js/jquery.inputlimiter.1.3.1.min.js"></script>
		<script src="static/assets/js/jquery.maskedinput.min.js"></script>
		<script src="static/assets/js/bootstrap-tag.min.js"></script>
		<script src="static/assets/js/ace-elements.min.js"></script>
		<script src="static/assets/js/ace.min.js"></script>
		<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
    	<script type="text/javascript" src="static/deptTree/deptTree.js"></script>
    	<script>
    	
    	
        $(function() {
        	document.getElementsByName("rule")[1].checked="checked";
        	document.getElementsByName("DATA_TYPE")[2].checked="checked";
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
		<script>
			$('.date-picker').datepicker({autoclose:true,language:'CN'}).next().on(ace.click_event, function(){
					$(this).prev().focus();
				});
				
				$('input[name=date-range-picker]').daterangepicker().prev().on(ace.click_event, function(){
					$(this).next().focus();
				});
				
				$('#timepicker1').timepicker({
					minuteStep: 1,
					showSeconds: true,
					showMeridian: false
				}).next().on(ace.click_event, function(){
					$(this).prev().focus();
				});
				$('#timepicker2').timepicker({
					minuteStep: 1,
					showSeconds: true,
					showMeridian: false
				}).next().on(ace.click_event, function(){
					$(this).prev().focus();
				});
				$('#timepicker3').timepicker({
					minuteStep: 1,
					showSeconds: true,
					showMeridian: false
				}).next().on(ace.click_event, function(){
					$(this).prev().focus();
				});
		</script>
		<script>
			$(function(){
				if($("#ace1").is(':checked')){
					$(".ace1_show").show();
					$(".ace2_show").hide();
					$(".ace3_show").hide();
				}
				if($("#ace2").is(':checked')){
					$(".ace1_show").hide();
					$(".ace2_show").show();
					$(".ace3_show").hide();
				}
				if($("#ace3").is(':checked')){
					$(".ace1_show").hide();
					$(".ace2_show").hide();
					$(".ace3_show").show();
				}
				var str = $("#DAY_FOR_WEEK").val()+'';
				$(str.split(",")).each(function (i,dom){
					var str = 'week'+dom;
					document.getElementById(str).checked = "checked";
					//$("input:checkbox[id='week'"+dom+"]:checked").val().prop("checked",true);  
	            });
			});
			
			$("#ace1").click(function(){
				//alert($(this).val());
				if($(this).is(':checked')){
					$(".ace1_show").show();
					$(".ace2_show").hide();
					$(".ace3_show").hide();
				}
			})
			$("#ace2").click(function(){
				//alert($(this).val());
				if($(this).is(':checked')){
					$(".ace1_show").hide();
					$(".ace2_show").show();
					$(".ace3_show").hide();
				}
			})
			$("#ace3").click(function(){
				//alert($(this).val());
				if($(this).is(':checked')){
					$(".ace1_show").hide();
					$(".ace2_show").hide();
					$(".ace3_show").show();
				}
			})
		</script>
		<script type="text/javascript">
			function view(){
				//预览界面显示
				$("#view").css('visibility','visible');
			}
			
			function save(){
				//推送规则完整性验证
				if (typeof($("input:radio[name='rule']:checked").val()) == "undefined"||$("#START_DATE").val() == ""||$("#END_DATE").val() == ""||$("#MODEL").val() == "") {
					alert("推送规则填写不全");
					return false;
				}
				else
				{
					//如果选择按日推送
					if($("input:radio[name='rule']:checked").val() == "1")
					{
						if($("#DAYTIME").val() == "")
						{
							alert("请填写推送时间");
							return false;
						}
						if($("input:radio[name='DATA_TYPE']:checked").val() != "1"&&$("input:radio[name='DATA_TYPE']:checked").val() != "2")
						{
							alert("请选择推送数据");
							return false;
						}
					}
					//选择按周推送
					else if($("input:radio[name='rule']:checked").val() == "2")
					{
						if($("#WEEKTIME").val() == "")
						{
							alert("请填写推送时间");
							return false;
						}
						if($("input:radio[name='DATA_TYPE']:checked").val() != "3"&&$("input:radio[name='DATA_TYPE']:checked").val() != "4")
						{
							alert("请选择推送数据");
							return false;
						}
						if(typeof($("input:checkbox[name='week']:checked").val()) == "undefined"){
							alert("请选择推送日期！");
							return false;
						}
					}
					//选择按月推送
					else if($("input:radio[name='rule']:checked").val() == "3")
					{
						if($("#MONTHTIME").val() == "")
						{
							alert("请填写推送时间");
							return false;
						}
						if($("input:radio[name='DATA_TYPE']:checked").val() != "5"&&$("input:radio[name='DATA_TYPE']:checked").val() != "6")
						{
							alert("请选择推送数据");
							return false;
						}
						if($("#searchType").val() == ""){
							alert("请选择推送日期！");
							return false;
						}
					}
					
				}
				if($("#EMP_ID").val() == "")
				{
					alert("请至少选择一个推送对象");
					return false;
				}
				if($("#START_DATE").val()>$("#END_DATE").val())
				{
					alert("失效日期必须在开始日期之后");
					return false;
				}

				$.ajax({
	                type: "POST",
	                url: 'configPlan/saveConfig.do',
	                data:$('#configPlanForm').serialize(),
	                success: function(data) {
	                	/* alert(data);
	                	if("success" == data){ */
	                    	alert("保存成功");
	                	/* } */
	                },
	                error:function(data) {
	                	alert("保存失败");
	                }
	            });
				//$("#configPlanForm").submit();				
			}
			
			
			
			function goBack(){
				$(".tab_item2_selected", window.parent.document).siblings().find(".tab_close").trigger("click");
			}
		</script>
		
</body>
</html>