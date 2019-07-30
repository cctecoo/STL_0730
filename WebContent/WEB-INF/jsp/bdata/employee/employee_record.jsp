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
		<link href="static/css/style.css" rel="stylesheet" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/css/chosen.css" />
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		
		<link rel="stylesheet" href="static/css/datepicker.css" />
		
		<style type="text/css">
			input[type="checkbox"],input[type="radio"] {
				opacity:1 ;
				position: static;
				/* height:25px; */
				margin-bottom:8px;
			}
			.kpi-input{
				width:40px;
				border:none;
				/* outline:none;
				outline:medium; */
			}
			#zhongxin select{margin:5px 0;}
		</style>
	</head>
	<body>
		<form action="employee/record.do" name="employeeForm" id="employeeForm" method="post">
			<input type="hidden" name="from" id="from" value="${from}" title="页面来源" />
			<input type="hidden" name="EMP_ID" id="emp_id" value="${empRecord.EMP_ID }" title="员工ID" />
			<input type="hidden" name="EMP_CODE" value="${empRecord.EMP_CODE }" title="员工编码" />
			<input type="hidden" name="RECORD_ID" value="${empRecord.RECORD_ID }">
			<input type="hidden" name="editRecord" id="editRecord" value="N" title="是否修改档案基本信息">
			<div class="tabbable tabs-below">
				<ul class="nav nav-tabs" id="menuStatus">
					<li>
					<!-- <a data-toggle="tab"> </a> -->
					<img src="static/images/ui1.png" style="margin-top:-3px;">
					员工档案
					</li>	
					<div class="nav-search form-search" id="nav-search" style="right:5px;">
		
						<div style="float:left;" class="panel panel-default">
							<div>
								<span class="badge" style="background-color:#fee188; color: #963!important; margin-left:3px;">
									<i class="icon-info-sign">点击“保存”按钮才能生效</i>
								</span>
								<a class="btn btn-mini btn-primary" onclick="save();" 
									style="margin-right:45px;">保存</a>
								
								<c:if test="${from == 'employeeList'}">
									<a class="btn btn-mini btn-danger" onclick="goBack();" 
										style="float:left;margin-right:5px;">关闭</a>
								</c:if>
							</div>
						</div>
					</div>
				</ul>
			</div>
			<div id="zhongxin">
				<a class="btn btn-mini btn-info" onclick="showEditTable();" 
					style="margin-left:15px;">修改</a>
				<span class="badge" style="background-color:#fee188; color: #963!important; margin-left:3px;">
					<i class="icon-info-sign">点击“修改”按钮可以修改基本信息</i>
				</span>
				<table id="empRecordTb" style="margin-left: 50px; margin-top:10px;">
					<tr>
						<td style="padding-left: 30px;">
							<label>员工姓名：</label>
						</td>
						<td>
							<input type="text" name="NAME" id="name" 
							       value="${empRecord.EMP_NAME }" maxlength="32" placeholder="姓名" title="姓名" readonly/>
						</td>
						<td style="padding-left: 30px;">
							<label>手机号码：</label>
						</td>
						<td>
							<input type="text" name="EMP_PHONE" id="phone" class="editEle"
								   value="${empRecord.EMP_PHONE }" maxlength="32" placeholder="联系电话" title="联系电话" />
						</td>
						<td style="padding-left: 30px;">
							<label>其它号码：</label>
						</td>
						<td>
							<input type="text" name="EMP_PHONE_2" id="empPhone2" class="editEle"
								   value="${empRecord.EMP_PHONE_2 }" maxlength="50" />
						</td>
					</tr>
					<tr>
						<td style="padding-left: 30px;">
							<label>开户银行：</label>
						</td>
						<td>
							<input type="text" name="EMP_BANK_NAME" id="empBankName" 
							       value="${empRecord.EMP_BANK_NAME }" maxlength="100" />
						</td>
						<td style="padding-left: 30px;">
							<label>银行卡号：</label>
						</td>
						<td>
							<input type="text" name="EMP_BANK_NO" id="empBankNo" class="editEle"
								   value="${empRecord.EMP_BANK_NO }" maxlength="100" />
						</td>
						<td style="padding-left: 30px;">
							<label>员工邮箱：</label>
						</td>
						<td>
							<input type="text" name="EMP_EMAIL" id="email" class="editEle"
								   value="${empRecord.EMP_EMAIL }" maxlength="32" placeholder="员工邮箱" title="员工邮箱" />
						</td>
					</tr>
					
					<tr>
						<td style="padding-left: 30px;">
							<label>员工性别：</label>
						</td>
						<td>
							<input class="editEle" type="radio" name="EMP_GENDER" value="1"<c:if test="${empRecord.EMP_GENDER == 1}">checked="checked"</c:if>>男
							<input class="editEle" type="radio" name="EMP_GENDER" value="2"<c:if test="${empRecord.EMP_GENDER == 2}">checked="checked"</c:if>>女
						</td>
						<td style="padding-left: 30px;">
							<label>出生日期：</label>
						</td>
						<td>
							<input type="text" id="birthday" name="BIRTHDAY" style="background:#fff!important;" 
                            	class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请输入年月日！" value="${empRecord.BIRTHDAY }" onchange="jsGetAge()" readonly="readonly"/>
						</td>
						<td style="padding-left: 30px;">
							<label>年&nbsp;龄：</label>
						</td>
						<td>
							<input type="text" name="AGE" id="age" value="" maxlength="32" placeholder="年龄" title="年龄" readonly/>
						</td>
					</tr>
					<tr>
						<td style="padding-left: 30px;">
							<label>籍&nbsp;贯：</label>
						</td>
						<td colspan="5" style="width:500px">
							<input type="text" name="ADDRESS" id="address" class="editEle"
								   value="${empRecord.ADDRESS }" maxlength="200" placeholder="籍贯" title="籍贯" style="width:842px"/>
						</td>
					</tr>
					<tr>
						<td style="padding-left: 30px;">
							<label>毕业学校：</label>
						</td>
						<td>
							<input type="text" name="SCHOOL" id="school" class="editEle"
								   value="${empRecord.SCHOOL }" maxlength="32" placeholder="毕业学校" title="毕业学校"/>
						</td>
						<td style="padding-left: 30px;">
							<label>毕业时间：</label>
						</td>
						<td>
							<input type="text" id="graduate_time" name="GRADUATE_TIME" style="background:#fff!important;" 
                            	class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请输入年月日！" 
                            	value="${empRecord.GRADUATE_TIME }" readonly="readonly"/>
						</td>
						<td style="padding-left: 30px;">
							<label>学&nbsp;位：</label>
						</td>
						<td>
							<input type="text" name="DEGREE" id="degree" class="editEle"
								   value="${empRecord.DEGREE }" maxlength="32" placeholder="学位" title="学位"/>
						</td>
					</tr>
					
					<tr>
						<td style="padding-left: 30px;">
							<label>专&nbsp;业：</label>
						</td>
						<td colspan="5">
							<input type="text" name="MAJOR" id="major" style="width:842px;"class="editEle"
								   value="${empRecord.MAJOR }" maxlength="80" placeholder="专业" title="专业"/>
						</td>
					</tr>
				</table>
				<hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;" />
		        <div class="row">
		            <div class="span12">
		                <div class="span6" style="text-align: left">
		                    <h4 style="float:left; margin-right:10px;">工作经历</h4>
		                    <h4>
		                        <a style="cursor:pointer;" title="添加工作经历" onclick="add()" class='btn btn-small btn-info' 
		                        	data-rel="tooltip" data-placement="left">
		                            	添加
		                        </a>
		                        <a style="cursor:pointer;" title="删除工作经历" onclick="del()" class='btn btn-small btn-danger' 
		                        	data-rel="tooltip" data-placement="left">
		                            	移除
		                        </a>
		                    </h4>
		                </div>
		            </div>
	               <div class="span12">
	                    <!--分解表格-->
	                    <table class="table table-striped table-bordered table-hover" id="dimtable">
	                        <thead>
	                        <th class="center">                             	
	                        </th>
	                        <th class="center" style="width: 30px;">序号</th>
	                        <th class="center" style="width: 70%">工作经历</th>
	                        <th class="center" style="width: 20%">职位</th>
	                        </thead>
	                        <tbody>
	                            <c:forEach items="${expList}" var="exp" varStatus="vs">
	                                <tr>
	                                    <td>
	                                        <label>
	                                        	<span class='lbl'></span>
	                                            <input type='checkbox' name='ids'/>
											</label>
	                                        <input name='ID' type='hidden' value="${exp.ID}"/>
	                                    </td>
	                                    <td class='center' style="width: 30px;" name='vs_td'>${vs.index+1}</td>
	                                    <td style="width: 70%">
	                                        <input value='${exp.EXP}' name='EXP' style="width: 100%"/>
	                                    </td>
	                                    <td style="width: 20%">
	                                        <input value='${exp.POSITION}' name='POSITION' style="width: 100%"/>
	                                    </td>
	                                </tr>
	                            </c:forEach>
	                        </tbody>
	                    </table>
	                    <!--分解表格-->
	                </div>
              </div>  
        	</div>
        </form>
		
		<!-- 引入 -->
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
		
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
		
		<script type="text/javascript">
			$( document ).ready(function() {
			    if("${flag}" == "success"){
			    	top.Dialog.alert("保存成功");
			    }else if("${flag}" == "false"){
			    	top.Dialog.alert("保存失败");
			    }
			    //计算年龄
			    jsGetAge();
			  	//日期控件预加载
				$('.date-picker').datepicker({
		            format:'yyyy-mm-dd',
		            changeMonth: true,
		            changeYear: true,
		            showButtonPanel: true,
		            autoclose: true,
		            minViewMode:0,
		            maxViewMode:2,
		            startViewMode:0,
		            onClose: function(dateText, inst) {
		                var year = $("#span2 date-picker .ui-datepicker-year :selected").val();
		                $(this).datepicker('setDate', new Date(year, 1, 1));
		    
		            }
		        });
			  	//初始页面，不能修改档案基本信息
				$("#empRecordTb").find("input,button,textarea,select").attr("disabled", "disabled");
			});
			
			//显示编辑基本信息表格
			function showEditTable(){
				$("#editRecord").val("Y");
				$("#empRecordTb").find("input,button,textarea,select").removeAttr("disabled");
			}
	        
	        //复选框预加载
		    $('#explain_table th input:checkbox').on('click' , function(){
		        var that = this;
		        $(this).closest('table').find('tr > td:first-child input:checkbox').not(':disabled')
		                .each(function(){
		                    this.checked = that.checked;
		                    $(this).closest('tr').toggleClass('selected');
		                });
		    });
		    
		    
			//新增经历
		    function add(){
		        var ss = document.getElementsByName('ids').length + 1;
		        var shtml = "<tr>";
		        shtml += "<td><label><span class='lbl'></span><input type='checkbox' name='ids'/></label><input name='ID' type='hidden'/></td>";
		        shtml += "<td class='center' style='width: 30px;' name='vs_td'>" + ss + "</td>";
		        shtml += "<td style='width: 70%'><input value='' name='EXP' style='width: 100%'/></td>";
		        shtml += "<td style='width: 20%'><input value='' name='POSITION' style='width: 100%'/></td>";
		        shtml += "</tr>";
		       	$("#dimtable").append(shtml);
		    }
		
		    //删除经历
		    function del(){
		        var objList = document.getElementsByName('ids');
		        var status = 'false';
		        for(var i=0;i < objList.length;i++){
		            if(objList[i].checked){
		                status = 'true';
		            }
		        }
		        if(status == 'false'){
		            top.Dialog.alert("您没有勾选任何内容，不能删除");
		            $("#zcheckbox").tips({
		                side:3,
		                msg:'点这里全选',
		                bg:'#AE81FF',
		                time:8
		            });	
		            return;
		        }else {
		            bootbox.confirm("确定要删除吗?", function(result) {
		                if(result){
		                    var removeList = new Array();
		                    for(var i=0;i < objList.length;i++){
		                        if(objList[i].checked){
		                            removeList.push($(objList[i]).parents("tr"));
		                        }
		                    }
		                    for(var i=0;i < removeList.length;i++){
		                        removeList[i].remove();
		                    }
		                    $("#zcheckbox").attr("checked",false);
		                    var vsList = document.getElementsByName("vs_td");
		                    for (var i=0;i<vsList.length;i++){
		                        $(vsList[i]).html(Number(i)+1);
		                    }
		                    bootbox.hideAll();
		                }
		            })
		        }
		    }
		    
			//保存
		    function save(){
		        //移除disable,后台方可取值
		        $("#employeeForm :disabled").each(function() {
		            $(this).attr("disabled", false);
		        });
		        //检查手机号码和邮件格式
		        var phoneCheck =  /^(\d{11})$/;
				if($("#phone").val() != ""){
					if(!phoneCheck.test($("#phone").val())){
						$("#phone").tips({
							side:3,
				            msg:'请正确输入电话',
				            bg:'#AE81FF',
				            time:2
				        });
						$("#phone").focus();
						return false;
					}
				}
				var email = /^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$/;
				if($("#email").val() != ""){
					if(!email.test($("#email").val())){
						$("#email").tips({
							side:3,
				            msg:'请正确输入员工邮箱',
				            bg:'#AE81FF',
				            time:2
				        });
						$("#email").focus();
						return false;
					}
				}
		        //检查工作经历
		        var objList = document.getElementsByName('ids');
		        var expList = document.getElementsByName('EXP');
		        var positionList = document.getElementsByName('POSITION');
		        
		       	if(objList.length==0){//只有一个form外隐藏的，未添加
		       		top.Dialog.confirm("没有添加工作经历，将删除之前保存的记录，确定继续?", function(){
		       			//提交表单
		       			$("#employeeForm").submit();
		       		});
		       		//top.Dialog.alert("请至少添加一条工作经历！");
		       		//return false;
		       	}else{
		       		for(var i=0;i<expList.length;i++){
			            if(null == expList[i].value || "" == expList[i].value || 0 == Number(expList[i].value)){
			                $(expList[i]).tips({
			                    side:3,
			                    msg:'请填写工作经历！',
			                    bg:'#AE81FF',
			                    time:2
			                });
			                $(expList[i]).focus();
			                return false;
			            };
			        }
			        for(var i=0;i<positionList.length;i++){
			            if(null == positionList[i].value || "" == positionList[i].value || 0 == Number(positionList[i].value)){
			                $(positionList[i]).tips({
			                    side:3,
			                    msg:'请填写曾任岗位！',
			                    bg:'#AE81FF',
			                    time:2
			                });
			                $(positionList[i]).focus();
			                return false;
			            };
			        }
			      //提交表单
					top.Dialog.confirm("确定要修改档案信息？", function(){
						$("#employeeForm").submit();
					});
		       	}
		    }
			
			//关闭员工table页
			function goBack(){
				<%-- window.location.href = "<%=basePath%>employee/list.do"; --%>
                $(".tab_item2_selected", window.parent.document).siblings().find(".tab_close").trigger("click");
			}
			
			//计算年龄
			function jsGetAge(){ 
				var strBirthday=$("#birthday").val();
				if(""==strBirthday){
					$("#age").val("");
					return ;
				}
			    var returnAge;  
			    var strBirthdayArr=strBirthday.split("-");  
			    var birthYear = strBirthdayArr[0];  
			    var birthMonth = strBirthdayArr[1];  
			    var birthDay = strBirthdayArr[2];  
			      
			    d = new Date();  
			    var nowYear = d.getFullYear();  
			    var nowMonth = d.getMonth() + 1;  
			    var nowDay = d.getDate();  
			      
			    if(nowYear == birthYear){  
			        returnAge = 0;//同年 则为0岁  
			    }  
			    else{  
			        var ageDiff = nowYear - birthYear ; //年之差  
			        if(ageDiff > 0){  
			            if(nowMonth == birthMonth) {  
			                var dayDiff = nowDay - birthDay;//日之差  
			                if(dayDiff < 0)  
			                {  
			                    returnAge = ageDiff - 1;  
			                }  
			                else  
			                {  
			                    returnAge = ageDiff ;  
			                }  
			            }  
			            else  
			            {  
			                var monthDiff = nowMonth - birthMonth;//月之差  
			                if(monthDiff < 0)  
			                {  
			                    returnAge = ageDiff - 1;  
			                }  
			                else  
			                {  
			                    returnAge = ageDiff ;  
			                }  
			            }  
			        }  
			        else  
			        {  
			            returnAge = -1;//返回-1 表示出生日期输入错误 晚于今天  
			        }  
			    }  
			  
			    document.getElementById('age').value=returnAge;
			}
			
		</script>
		
	</body>
</html>