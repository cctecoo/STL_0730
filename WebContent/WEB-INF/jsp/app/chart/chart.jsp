<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<base href="<%=basePath%>">
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no"/>
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<script src="bootstrap-3.3.7/js/bootstrap.min.js"></script>
		<script src="static/assets/js/jquery-1.10.2.min.js"></script>
		<link href="plugins/Bootstrap/css/bootstrap.min.css" rel="stylesheet" />
		<style>
		body{margin:0px;}
		</style>
		<title>销售分析</title>
	</head>
	<body>
		<div style="color:#929292;font-size:13px;line-height:1.5;">
		<span style="line-height:2.5;">报告！截止到今日，</span><br/>
		销售总量：<span style="color:#0393cf;font-weight:bold;">${allProduct.actual_count}</span>  吨<br/>
		销售总额：<span style="color:#b30202;font-weight:bold;">${allProduct.actual_money}</span>  万元
		</div>
		<div id="echarts" style="width:100%;height:240px;"></div>
		<div style="border-bottom:1px solid #ccc;width:85%;margin:10px auto;"></div>
		<div style="color:#6b6b6b;font-size:15px;text-align:center;margin-top:20px;">以下是各产品销量分析</div>
		<script src="static/js/echarts.common.min.js"></script>
		<script>
			var myChart = echarts.init(document.getElementById('echarts'));
			var option  = {
			    title : {
			        text: '年度总量分析',
					y:5,
			        //subtext: '年度总量'
					textStyle:{
						fontSize: 15,
						fontWeight: 'normal',
						color: '#333',
						baseline:'bottom'
					}
			    },
			    grid:{
			    	left:65
			    },
			    legend: {
			        data:['计划','实际'],
					y:'bottom',
					itemWidth:7,
					itemHeight:7
			    },
			    //calculable : true,
			    xAxis : [
			        {
			            type : 'category',
			            data : ['数量','金额'],
						axisLine:{
							show:false
						},
						axisTick:{
							show:false
						}
			        }
			    ],
			    yAxis : [
			        {
			            type : 'value',
						axisLine:{
							show:false
						},
						axisTick:{
							show:false
						}
			        }
			    ],
			    series : URL
			        {
			            name:'计划',
			            type:'bar',
						barWidth:30,
			            data:[${allProduct.aim_count}, ${allProduct.aim_money}],
						itemStyle: {
							normal: {
								color:'#4f81bd',
								label:{
									show : true,
									position: 'top'
								}
							}
						}
			        },
			        {
			            name:'实际',
			            type:'bar',
						barWidth:30,
			            data:[${allProduct.actual_count}, ${allProduct.actual_money}],
						itemStyle: {
							normal: {
								color:'#c0504d',
								label:{
									show : true,
									position: 'top'
								}
							}
						}
			        }
			    ]
			};
			myChart.setOption(option);
			</script>
			<c:choose>
				<c:when test="${not empty everyProduct}">
					<c:forEach items="${everyProduct}" var="everylist" varStatus="vs">
						<script>
						var count = 'echarts'+ ${vs.index+1};
						var oDiv = document.createElement("div");
						oDiv.id = count;
						document.body.appendChild(oDiv);
						document.getElementById(count).style.height = "240px";
						/* var myChart2 = document.getElementById(count);
						myChar2.style.height = "240px"; */
						var myChart1 = echarts.init(document.getElementById(count));
						var option1  = {
						    title : {
						        text:  '${everylist.PRODUCT_NAME}',
								x:'center',
								y:10,
								textStyle:{
									fontSize: 15,
									fontWeight: 'normal',
									color: '#809ed3'
								}
						    },
						    grid:{
						    	left:65
						    },
						    
						    legend: {
						        data:['计划','实际'],
								y:'bottom',
								itemWidth:7,
								itemHeight:7
						    },
						    //calculable : true,
						    xAxis : [
						        {
						            type : 'category',
						            data : ['数量','金额'],
									axisLine:{
										show:false
									},
									axisTick:{
										show:false
									}
						        }
						    ],
						    yAxis : [
						        {
						            type : 'value',
									axisLine:{
										show:false
									},
									axisTick:{
										show:false
									}
						        }
						    ],
						    series : [
						        {
						            name:'计划',
						            type:'bar',
									barWidth:30,
						            data:[${everylist.aim_count}, ${everylist.aim_money}],
									itemStyle: {
										normal: {
											color:'#4f81bd',
											label:{
												show : true,
												position: 'top'
											}
										}
									}
						        },
						        {
						            name:'实际',
						            type:'bar',
									barWidth:30,
						            data:[${everylist.actual_count}, ${everylist.actual_money}],
									itemStyle: {
										normal: {
											color:'#c0504d',
											label:{
												show : true,
												position: 'top'
											}
										}
									}
						        }
						    ]
						};
						myChart1.setOption(option1);
					</script>
					<script type="text/javascript">
						$("html").resize(function() {
						  $("#echarts").css("width","100%");
						});
					</script>
				</c:forEach>
			</c:when> 
		</c:choose> 
	</body>
</html>