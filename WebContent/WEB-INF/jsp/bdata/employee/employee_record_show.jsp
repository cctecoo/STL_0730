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
			<div class="tabbable tabs-below">
				<ul class="nav nav-tabs" id="menuStatus">
					<li>
					<!-- <a data-toggle="tab"> </a> -->
					<img src="static/images/ui1.png" style="margin-top:-3px;">
					员工档案
					</li>
				</ul>
			</div>
			<div id="zhongxin">
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
		                </div>
		            </div>
	               <div class="span12">
	                    <!--分解表格-->
	                    <table class="table table-striped table-bordered table-hover" id="dimtable">
	                        <thead>
	                        <th class="center" style="width: 30px;">序号</th>
	                        <th class="center" style="width: 70%">工作经历</th>
	                        <th class="center" style="width: 20%">职位</th>
	                        </thead>
	                        <tbody>
	                            <c:forEach items="${expList}" var="exp" varStatus="vs">
	                                <tr>
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
			  	
			  	//初始页面，不能修改档案基本信息
				$("#zhongxin").find("input,button,textarea,select").attr("disabled", "disabled");
			});
			
			
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