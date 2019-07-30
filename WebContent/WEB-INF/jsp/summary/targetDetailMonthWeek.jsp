<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>

<head>
	<base href="<%=basePath%>">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    

    <title>月度目标、周目标页面</title>
    <meta name="keywords" content="">
    <meta name="description" content="">

	<link href="static/summaryTask/css/bootstrap.min.css?v=3.3.5" rel="stylesheet">
    <link href="static/summaryTask/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
    <link href="static/summaryTask/css/animate.min.css" rel="stylesheet">
    <link href="static/summaryTask/css/style.min.css?v=4.0.0" rel="stylesheet">
    <link href="static/summaryTask/css/style_dailytask.css" rel="stylesheet">
    <!-- 目标模块日期 -->
	<link rel="stylesheet" href="static/css/datepicker.css" />
	<style type="text/css">
	/*修复datepicker在高版本的样式下不显示左右选择日期的箭头*/
		.icon-arrow-left:before{content:"\f060"}
		.icon-arrow-right:before{content:"\f061"}
		[class^="icon-"], [class*=" icon-"] {
		    font-family: FontAwesome;
		    font-weight: normal;
		    font-style: normal;
		    text-decoration: inherit;
		    -webkit-font-smoothing: antialiased;
		    display: inline;
		    width: auto;
		    height: auto;
		    line-height: normal;
		    vertical-align: baseline;
		    background-image: none;
		    background-position: 0 0;
		    background-repeat: repeat;
		    margin-top: 0;
		}
		[class^="icon-"]:before, [class*=" icon-"]:before {
		    text-decoration: inherit;
		    display: inline-block;
		    speak: none;
		}
	</style>
</head>
<body class="gray-bg">
	<div class="row wrapper border-bottom white-bg page-heading" style="padding:10px 25px;">
		<div id="headerInfo" class="col-sm-10" style="line-height:30px;">
			
		</div>
		<!-- <div class="col-sm-2" style="text-align:right;">
			<button type="button" class="btn btn-outline btn-primary btn-sm">
				导出
			</button>
		</div> -->
	</div>
    <div class="wrapper wrapper-content animated fadeInUp">
        <div class="row">
            <div class="col-sm-12">
				<input type="hidden" name="queryEmpCode" id="queryEmpCode" value="${pd.queryEmpCode }" />
				<input type="hidden" name="targetCode" id="targetCode" value="${pd.targetCode }" />
				<input type="hidden" name="year" id="year" />
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>月度目标完成情况</h5>
                    </div>
                    <div class="ibox-content">
                        <div class="project-list">
                            <table class="table table-hover">
								<thead>
									<th style="width:10%" class="project-status">年份</th>
									<th style="width:15%" class="project-status">月份</th>
									<th style="align:right;" class="project-status">目标值</th>
									<th style="align:right;" class="project-status">完成值</th>
									<th style="align:right;" class="project-status">完成率</th>
									<th style="align:right;" class="project-status">差异</th>
								</thead>
                                <tbody id="monthTargetInfo">
                                </tbody>
                                <tr id="sumMonth">
                                <td colspan="2"><b>合计</b></td>
                                <td id="sumMonthTarget"></td>
                                <td id="sumMonthFinish"></td>
                                <td id="sumMonthFinishRate"></td>
                                <td id="sumMonthDifference"></td>
                                </tr>
                                </table>
                            </div>
                        </div>
                    </div>
					
					<div class="ibox">
                    <div class="ibox-title">
                        <h5 style="line-height:32px;">周目标完成情况</h5>
						
						<div class="dailytask_status" style="width:140px; display:inline-block;margin-left:25px;">
							<div class="status_list dropdown">
								<div class="initDropdown" id="queryMonth">
								</div>
								<ul class="dropdown-menu status">
									<li>01月</li>
									<li>02月</li>
									<li>03月</li>
									<li>04月</li>
									<li>05月</li>
									<li>06月</li>
									<li>07月</li>
									<li>08月</li>
									<li>09月</li>
									<li>10月</li>
									<li>11月</li>
									<li>12月</li>
								</ul>
							</div>
						</div>
                    </div>
                    <div class="ibox-content">
                        <div class="project-list">
                            <table class="table table-hover">
								<thead>
									<th style="width:10%" class="project-status">周数</th>
									<th style="width:15%" class="project-title">日期范围</th>
									<th class="project-completion">目标值</th>
									<th>完成值</th>
									<th>完成率</th>
									<th class="project-button">差异</th>
								</thead>
                                <tbody id="weekTargetInfo">
                                </tbody>
                                <tr id="sumWeek">
                                <td colspan="2"><b>合计</b></td>
                                <td id="sumWeekTarget"></td>
                                <td id="sumWeekFinish"></td>
                                <td id="sumWeekFinishRate"></td>
                                <td id="sumWeekDifference"></td>
                                <td></td>
                                </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
		
    <script src="static/summaryTask/js/jquery.min.js?v=2.1.4"></script>
    <script src="static/summaryTask/js/bootstrap.min.js?v=3.3.5"></script>
    <!-- 日历 -->
	<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
	<script>
       $(document).ready(function(){
	        $(".initDropdown").mouseenter(function(){//鼠标悬停触发事件
	        	$(this).parent(".dropdown").addClass("open");
	        	//$(this).parent(".dropdown").css("border-bottom-radius","0");
	        });
	        $(".dropdown").mouseleave(function(){//鼠标悬停触发事件
		        $(this).removeClass("open");
		        //$(this).css("border-bottom-radius","4px");
		    });
	        var date=new Date;
	        var month=date.getMonth()+1;
	        month =(month<10 ? "0"+month:month); 
	        $("#queryMonth").text(month+"月");
      	});
        
        $(".status li").click(function(){
        	var status = $(this).text();
			//alert(status);
        	$("#queryMonth").text(status);
        	$("#queryMonth").parent(".dropdown").removeClass("open");
        	$("#status").val(status);
        	loadWeekTargetInfo();
        });
      //载入内容
    	$(function(){
    		if('0'=='${queryEmpCode}'){
    			return;
    		}
    		//初始化团队日报模块
    		setTimeout("loadMonthTargetInfo()", 100);
    		//初始化团队日报模块
    		setTimeout("loadWeekTargetInfo()", 500);
    	})
      function loadMonthTargetInfo(){
    		$.ajax({
    			url: '<%=basePath%>/summaryTask/summaryTargetDetailMonth.do',
    			type: 'post',
    			data: {
    				//取员工编码
    				'queryEmpCode': $("#queryEmpCode").val(),
    				'targetCode': $("#targetCode").val(),
    			},
    			success : function(data){
    				var obj = eval('(' + data + ')');
    				if(obj.errorMsg){
    					top.Dialog.alert(obj.errorMsg);
    				}else{
    					$("#monthTargetInfo").empty();
    					if(obj.result.length >0){
    						$("#year").val(obj.result[0].yearDate);
    						setHeaderInfo(obj.result[0]);
    						if(obj.resultSum){
    							setSumNum('Month',obj.resultSum);
    						}
    						$.each(obj.result, function(i, task){
    							$("#monthTargetInfo").append(appendMonthTargetInfo(task, i));
    						});
    					}else{
    						$("#monthTargetInfo").append('没有数据');
    						$("#sumMonth").hide();
    					}
    				}
    			}
    		});
      }
      function appendMonthTargetInfo(task,i){
    	
    	var yearDate = task.yearDate;
    	var monthDate = task.monthDate;
    	var targetCount = task.targetCount.toFixed(2);
    	var finishCount = task.finishCount.toFixed(2);
    	var finishRate = 0;
    	if(task.targetCount >0){
    		finishRate = ((task.finishCount*100)/task.targetCount).toFixed(2)+'%';
    	}
    	var difference = (task.targetCount-task.finishCount).toFixed(2);
    	var append = '<tr>'+
  	    '<td>'+
  	    '<span >' + yearDate +'</span>'+
  	    '</td>'+
  	    '<td>'+
  	    '<span >' + monthDate +'</span>'+
  	    '</td>'+
  	    '<td>'+
  	    '<span >' + targetCount +'</span>'+
  	    '</td>'+
  	    '<td>'+
  	    '<span >' + finishCount +'</span>'+
  	    '</td>'+
  	    '<td>'+
  	    '<span >' + finishRate +'</span>'+
  	    '</td>'+
  	    '<td>'+
  	    '<span >' + difference +'</span>'+
  	    '</td>'+
  	    '</tr>';	    									
  			                              
  		return append;
      }
      function loadWeekTargetInfo(){
    	  
    	  var queryMonth = $("#queryMonth").text().substring(0,2);
    	  var queryDate = $("#year").val()+'-'+ queryMonth;
    	  $.ajax({
  			url: '<%=basePath%>/summaryTask/summaryTargetDetailMonthWeek.do',
  			type: 'post',
  			data: {
  				//取员工编码
  				'queryEmpCode': $("#queryEmpCode").val(),
  				'targetCode': $("#targetCode").val(),
  				'queryDate':queryDate
  			},
  			success : function(data){
  				var obj = eval('(' + data + ')');
  				if(obj.errorMsg){
  					top.Dialog.alert(obj.errorMsg);
  				}else{
  					$("#weekTargetInfo").empty();
  					if(obj.resultSum){
						setSumNum('Week',obj.resultSum);
					}
  					if(obj.result.length >0){
  						$.each(obj.result, function(i, task){
  							$("#weekTargetInfo").append(appendWeekTargetInfo(task, i));
  						});
  					}else{
  						$("#weekTargetInfo").append('没有数据');
  						$("#sumWeek").hide();
  					}
  				}
  			}
  		});
      }
      function appendWeekTargetInfo(task,i){
    	
      	var weekCount = "第"+task.weekDate+"周";
      	var timeRange = task.weekStartTime+"至"+task.weekEndTime;
      	var targetCount = task.targetCount.toFixed(2);
      	var finishCount = task.finishCount.toFixed(2);
      	var finishRate = 0;
      	if(task.targetCount >0){
      		finishRate = ((task.finishCount*100)/task.targetCount).toFixed(2)+'%';
      	}
      	var difference = (task.targetCount-task.finishCount).toFixed(2);
      	var append = '<tr>'+
    	    '<td>'+
    	    '<span >' + weekCount +'</span>'+
    	    '</td>'+
    	    '<td>'+
    	    '<span >' + timeRange +'</span>'+
    	    '</td>'+
    	    '<td>'+
    	    '<span >' + targetCount +'</span>'+
    	    '</td>'+
    	    '<td>'+
    	    '<span >' + finishCount +'</span>'+
    	    '</td>'+
    	    '<td>'+
    	    '<span >' + finishRate +'</span>'+
    	    '</td>'+
    	    '<td>'+
    	    '<span >' + difference +'</span>'+
    	    '</td>'+
    	    '</tr>';	    									
    			                              
    		return append;
      }
      function setSumNum(type,obj){
    	  
      	var sumTarget = obj.sumTarget;
      	var sumFinish = obj.sumFinish;
      	var sumFinishRate = 0;
      	if(obj.sumTarget >0){
      		sumFinishRate = ((obj.sumFinish*100)/obj.sumTarget).toFixed(2)+'%';
      	}
      	var sumDifference = (obj.sumTarget-obj.sumFinish).toFixed(2);  
      	
      	$("#sum"+type+"Target").text(sumTarget);
      	$("#sum"+type+"Finish").text(sumFinish);
      	$("#sum"+type+"FinishRate").text(sumFinishRate);
      	$("#sum"+type+"Difference").text(sumDifference);
      }
      function setHeaderInfo(obj){
    	  
      	var indexName = obj.indexName;
      	var productName = obj.productName;
      	var deptName = obj.deptName;
      	var empName = obj.empName;
      	var unitName = obj.unitName;
      	var append="<b>指标名称:"+indexName+"  &nbsp;&nbsp;&nbsp;&nbsp;"+ 
			"维度："+productName+"  &nbsp;&nbsp;&nbsp;&nbsp; "+
			"部门："+deptName+"  &nbsp;&nbsp;&nbsp;&nbsp;"+
			"责任人："+empName+"  &nbsp;&nbsp;&nbsp;&nbsp;"+
			"单位："+unitName+"</b>"
      	$("#headerInfo").append(append);
      }
    </script>
    </body>
</html>