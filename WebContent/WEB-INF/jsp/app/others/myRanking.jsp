<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>

<head>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1,maximum-scale=1, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<title>积分排行</title>
<style>
html, body {
	padding: 0;
	margin: 0;
}

.w-head {
	width: 100%;
	background: #478cd7;
	color: #fff;
	height: 40px;
	line-height: 40px;
	text-align: center;
	position: fixed;
	top:0;
	font-size: 15px;
}

.w-lists {
	padding: 10px 15px;
	border-bottom: 1px solid #e0e0e0;
}

.w-listbottom {
	color: #A3A3A3;
	font-size: 12px;
	text-align: right;
	padding-top: 10px;
}

.w-up {
	color: #333;
	font-size: 12px;
	font-weight: 600;
	vertical-align: middle;
	float: right;
}

.w-down {
	color: #2FBA08;
	font-size: 12px;
	font-weight: 600;
	vertical-align: middle;
	float: right;
	padding-right: 20px;
}

.w-pmown {
	width: 75%;
	display: inline-block;
	vertical-align: middle;
	padding-left: 25px;
}

.w-pmown span {
	display: inline-block;
	width: 100%;
}

.w-pmown span:first-child {
	font-size:12px;
	font-weight: 600;
}

.w-pmown span:last-child {
	color: #A3A3A3;
	font-size: 12px;
}

.w-pmlist {
	width: 75%;
	display: inline-block;
	vertical-align: middle;
	color: #7B7B7B;
	font-size: 12px;
}

.w-pmlist span:first-child {
	margin-right: 12px;
}

.w-pmlist span:last-child {
	color: #7B7B7B;
}

.w-title {
	color: #F5F5F5;
}

.w-title span:last-child {
	float: right;
	padding-right: 12px;
}

.h-cPrev {
	padding-left: 2px;
	margin-right: 10px;
	background: url(<%=basePath %>static/summaryTask/img/h-cPrev-arrow.png)
		left center no-repeat;
}

.h-cNext {
	padding-right: 2px;
	margin-left: 10px;
	background: url(<%=basePath %>static/summaryTask/img/h-cNext-arrow.png)
		right center no-repeat;
}
</style>
</head>

<body>
	<input type="hidden" id="queryEmpCode" value="${queryEmpCode}"/>
	<div class="w-head">
		<div class="h-cmonthTab" id="h_cmonthJs">
			<a class="h-cPrev">&nbsp;</a> <span class="h-cNow"><span
				class="h-cYear">2020</span>年<span class="h-cMonth">2</span>月</span> <a
				class="h-cNext">&nbsp;</a>
		</div>
	</div>
	<div class="w-content" style="padding-left:  10%;padding-right:  10%;margin-top: 40px;">
		<a href="javascript:void(0)" onclick="showEmpScoreInfo(${queryEmpCode})">
		<div class="w-lists">
			<span class="w-pmown"> <span style="color: #000;">${empName }</span> <span id="ownranking">第一名</span>
			</span> <span class="w-up" style="font-size: 14px;color:blue;border: 0px solid #FE5500;border-radius:25px;padding: 5px;" id="ownscore">50</span>
		</div>
		</a>
		<div style="background: #F5F5F5;height: 8px;">
		</div>
		<div id="emp-score-list">
			<div class="w-lists">
				<span class="w-pmlist"> <span>1</span> <span>曹操</span>
				</span> <span class="w-up">50</span>
			</div>
		</div>
		
	</div>
	<script src="<%=basePath %>static/summaryTask/js/jquery.min.js?v=2.1.4"></script>
	<script type="text/javascript">
			$(function(){
				//页面加载初始化年月
			    var mydate = new Date();
			    $(".h-cNow .h-cYear").html(mydate.getFullYear());
			    $(".h-cNow .h-cMonth").html(mydate.getMonth()+1);
			    
			     //日历上一月
			    $("#h_cmonthJs .h-cPrev").click(function(){
			        var mm = parseInt($(".h-cNow .h-cMonth").html());
			        var yy = parseInt($(".h-cNow .h-cYear").html());
			        if( mm == 1){//返回12月
			            $(".h-cNow .h-cYear").html(yy-1);
			            $(".h-cNow .h-cMonth").html(12);
			        }
			        else{//上一月
			            $(".h-cNow .h-cMonth").html(mm-1);
			        }
			        searchRanking();
			    })
			    
			    //日历下一月
			    $("#h_cmonthJs .h-cNext").click(function(){
			        var mm = parseInt($(".h-cNow .h-cMonth").html());
			        var yy = parseInt($(".h-cNow .h-cYear").html());
			        if( mm == 12){//返回12月
			            $(".h-cNow .h-cYear").html(yy+1);
			            $(".h-cNow .h-cMonth").html(1);
			        }else{//上一月
			        	$(".h-cNow .h-cMonth").html(mm+1);
			        }
			        searchRanking();
			    })
			    searchRanking();
			});

	function searchRanking(){
		var queryMonth = $(".h-cNow .h-cYear").html()+'-'+$(".h-cNow .h-cMonth").html();;
		
		$.ajax({
			url: '<%=basePath%>/summaryTask/summaryTaskScore.do',
			type: 'post',
			data: {
				//取员工编码
				'queryEmpCode': $("#queryEmpCode").val(), 
				//取年月
				'queryMonth': queryMonth,
				//只获取前30名
				'showNum': 30
			},
			success : function(data){
				var obj = eval('(' + data + ')')
				if(obj.errorMsg){
					top.Dialog.alert(obj.errorMsg);
				}else{
					//$("#emp-score-list").empty();
					/* 显示自己的排名和分数 */
					var a=document.getElementById ("ownranking");
            		a.innerHTML = "第"+obj.queryEmpOrder+"名";
            		var b=document.getElementById ("ownscore");
            		b.innerHTML = obj.queryEmpScore;

					if(obj.result){
						$("#emp-score-list").empty();
						$.each(obj.result, function(i, task){
							$("#emp-score-list").append(appendSummaryTaskScore(task, obj));
						});
						
					}else{
						$("#emp-score-list").append('没有数据');
					}
				}
			}
		});
	}
	
	//拼接积分排名情况
	function appendSummaryTaskScore(task, obj){
		var name = task.EMP_NAME;
		var score = task.SCORE_SUM;
		var code = task.EMP_CODE;
		var textClass = '';
		var textStyle = '';
		var id= '';
		if (task.rownum == 1) {
				rownumtxt = '第一名';
				textStyle = 'style="background-color:#43acf7;color:#FFF;border-radius:25px;height: 20px;width: 20px;display: inline-block;text-align: center;line-height: 20px;"';
			} else if (task.rownum == 2) {
				rownumtxt = '第二名';
				textStyle = 'style="background-color:#74c2f9;color:#FFF;border-radius:25px;height: 20px;width: 20px;display: inline-block;text-align: center;line-height: 20px;"';
			} else if (task.rownum == 3) {
				rownumtxt = '第三名';
				textStyle = 'style="background-color:#97d1fb;color:#FFF;border-radius:25px;height: 20px;width: 20px;display: inline-block;text-align: center;line-height: 20px;"';
			} else {
				textClass = ''
				textStyle = 'style="height: 20px;width: 20px;display: inline-block;text-align: center;line-height: 20px;"';
			}

			var append ='<a href="javascript:void(0)" onclick="showEmpScoreInfo(\''+ code + '\')">'+
				 		'<div class="w-lists">'+
						 '<span class="w-pmlist"> <span '+textStyle+'>'+task.rownum+'</span>'+
						 '<span>'+name+'</span>'+
						 '</span> <span class="w-up">'+score+'</span>'+
						 '</div>'+
						 '</a>'
			return append;
		}
		//点击穿透到员工积分明细页面
		function showEmpScoreInfo(code)
		{
			var code = code;
			var queryMonth = $(".h-cNow .h-cYear").html()+'-'+$(".h-cNow .h-cMonth").html();;
			window.location.href="<%=basePath%>app_remindRecord/goAppEmpScoreInfo.do?month="+ queryMonth +"&queryEmpCode=" + code;
		}
		//阿拉伯数字转换为简写汉字
		function Arabia_To_SimplifiedChinese(Num) {
			for (i = Num.length - 1; i >= 0; i--) {
				Num = Num.replace(",", "")//替换Num中的“,”
				Num = Num.replace(" ", "")//替换Num中的空格
			}
			if (isNaN(Num)) { //验证输入的字符是否为数字
				//alert("请检查小写金额是否正确");
				return;
			}
			//字符处理完毕后开始转换，采用前后两部分分别转换
			part = String(Num).split(".");
			newchar = "";
			//小数点前进行转化
			for (i = part[0].length - 1; i >= 0; i--) {
				if (part[0].length > 10) {
					//alert("位数过大，无法计算");
					return "";
				}//若数量超过拾亿单位，提示
				tmpnewchar = ""
				perchar = part[0].charAt(i);
				switch (perchar) {
				case "0":
					tmpnewchar = "零" + tmpnewchar;
					break;
				case "1":
					tmpnewchar = "一" + tmpnewchar;
					break;
				case "2":
					tmpnewchar = "二" + tmpnewchar;
					break;
				case "3":
					tmpnewchar = "三" + tmpnewchar;
					break;
				case "4":
					tmpnewchar = "四" + tmpnewchar;
					break;
				case "5":
					tmpnewchar = "五" + tmpnewchar;
					break;
				case "6":
					tmpnewchar = "六" + tmpnewchar;
					break;
				case "7":
					tmpnewchar = "七" + tmpnewchar;
					break;
				case "8":
					tmpnewchar = "八" + tmpnewchar;
					break;
				case "9":
					tmpnewchar = "九" + tmpnewchar;
					break;
				}
				switch (part[0].length - i - 1) {
				case 0:
					tmpnewchar = tmpnewchar;
					break;
				case 1:
					if (perchar != 0)
						tmpnewchar = tmpnewchar + "十";
					break;
				case 2:
					if (perchar != 0)
						tmpnewchar = tmpnewchar + "百";
					break;
				case 3:
					if (perchar != 0)
						tmpnewchar = tmpnewchar + "千";
					break;
				case 4:
					tmpnewchar = tmpnewchar + "万";
					break;
				case 5:
					if (perchar != 0)
						tmpnewchar = tmpnewchar + "十";
					break;
				case 6:
					if (perchar != 0)
						tmpnewchar = tmpnewchar + "百";
					break;
				case 7:
					if (perchar != 0)
						tmpnewchar = tmpnewchar + "千";
					break;
				case 8:
					tmpnewchar = tmpnewchar + "亿";
					break;
				case 9:
					tmpnewchar = tmpnewchar + "十";
					break;
				}
				newchar = tmpnewchar + newchar;
			}
			//替换所有无用汉字，直到没有此类无用的数字为止
			while (newchar.search("零零") != -1 || newchar.search("零亿") != -1
					|| newchar.search("亿万") != -1 || newchar.search("零万") != -1) {
				newchar = newchar.replace("零亿", "亿");
				newchar = newchar.replace("亿万", "亿");
				newchar = newchar.replace("零万", "万");
				newchar = newchar.replace("零零", "零");
			}
			//替换以“一十”开头的，为“十”
			if (newchar.indexOf("一十") == 0) {
				newchar = newchar.substr(1);
			}
			//替换以“零”结尾的，为“”
			if (newchar.lastIndexOf("零") == newchar.length - 1) {
				newchar = newchar.substr(0, newchar.length - 1);
			}
			return newchar;
		}
	</script>
</body>

</html>