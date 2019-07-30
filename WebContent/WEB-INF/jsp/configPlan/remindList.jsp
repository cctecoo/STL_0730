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
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    

    <title>CreValue 工作台</title>
    <meta name="keywords" content="">
    <meta name="description" content="">
	<base href="<%=basePath%>"><!-- jsp文件头和头部 -->
	<link href="static/summaryTask/css/bootstrap.min.css?v=3.3.5" rel="stylesheet">
    <link href="static/summaryTask/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
    <link href="static/summaryTask/css/plugins/iCheck/custom.css" rel="stylesheet">

    <link href="static/summaryTask/css/animate.min.css" rel="stylesheet">
    <link href="static/summaryTask/css/style.min.css?v=4.0.0" rel="stylesheet">
    <style>
    	.searchCondition{
               margin-bottom: 10px;
               margin-left:10px;
           }
        .searchCondition input , .searchCondition select{
               height:30px;
               border:1px solid #aaa;
        }
        .searchCondition .initDropdown{
        	   width:170px;
        	   height:30px;
        	   line-height:30px;
        	   padding:0 7px;
        	   border:1px solid #aaa;
        }
        .searchCondition .status{
        	   width:170px;
        	   border-top:0;
        }
        .dropdown .dropdown-menu{
        	   margin:0;
        	   border-radius:0;
        }
        .dropdown .dropdown-menu li{
        	   padding:5px 10px;
        }
        .dropdown .dropdown-menu li:hover{
        	   background:#448fb9;
        	   color:#fff;
        }
    </style>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInUp">
        <div class="row">
            <div class="col-sm-12">

                <div class="ibox">
                    <div class="ibox-title">
                        <h5>消息历史记录</h5>
                        
                    </div>
                    <div class="ibox-content">
                        <div class="searchCondition">
	                        <span>工作类型： </span>
							<div class="dropdown" style="display:inline-block;">
								<div class="initDropdown" id="check">
									请选择
								</div>
								<ul class="dropdown-menu status">
									<li class="">全部工作</li>
									<li class="business">目标工作</li>
									<li class="cproject">协同工作</li>
									<li class="flow">流程工作</li>
									<li class="temp">临时工作</li>
									<li class="daily">日常工作</li>					        
							    </ul>
							    <input type="hidden" id="workType">
							</div>
							<div class="checkbox i-checks" style="display:inline-block;">
                               <label><input type="checkbox" value=""> <i></i> 只显示未读消息</label>
                           	</div>
                           	<input type="hidden" id="workStatus">
                           	<div class="ibox-tools">
	                            <a onclick="allRead()" class="btn btn-primary btn-xs">全部标记为已读</a>
	                        </div>
	                    </div>

                        <div class="project-list">
                            <table class="table table-hover">
                                <tbody>
                                	<c:forEach items="${list}" var="list">
                                    <tr>
                                        <td class="project-status" style="width:120px;">
                                            <span><i class="fa fa-circle <c:if test="${list.STATUS==1}">text-info</c:if>"></i>&nbsp;&nbsp;  ${list.type}</span>
                                        </td>
                                        <td class="project-title">
                                            <a onclick="markread(${list.STATUS},${list.ID});siMenu('remind_handle','remind_handle','日清','${list.URL}');" <c:if test="${list.STATUS==2}">style="color:#999;"</c:if>>
                                            	${list.WORK_NAME}
                                            </a>
                                        </td>
                                        <td class="project-actions">
                                            ${list.TIME}
                                        </td>
                                        <td class="project-actions">
                                            <a href="${list.URL}" onclick="markread(${list.STATUS},${list.ID});siMenu('remind_handle','remind_handle','日清','${list.URL}');" class="btn btn-white btn-sm"><i class="fa fa-folder"></i> 查看 </a>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <script src="static/summaryTask/js/jquery.min.js?v=2.1.4"></script>
    <script src="static/summaryTask/js/bootstrap.min.js?v=3.3.5"></script>
    <script src="static/summaryTask/js/plugins/iCheck/icheck.min.js"></script>
    <script>
    	$(document).ready(function(){
    		$(".i-checks").iCheck({
    			checkboxClass:"icheckbox_square-green",
    			radioClass:"iradio_square-green",
    			})
    		});
	    /*鼠标移入下拉菜单*/
    	$(document).ready(function(){
	        $(".initDropdown").mouseenter(function(){//鼠标悬停触发事件
	        	$(this).parent(".dropdown").addClass("open");
	        	//$(this).parent(".dropdown").css("border-bottom-radius","0");
	        });
	        $(".dropdown").mouseleave(function(){//鼠标悬停触发事件
		        $(this).removeClass("open");
		        //$(this).css("border-bottom-radius","4px");
		    });
	  	});
	    
	    $(".status li").click(function(){
	    	var workType = $(this).text();
	    	$("#check").text(workType);
	    	$("#check").parent(".dropdown").removeClass("open");
	    	$("#workType").val($(this).attr("class"));
	    	searchlist();
	    });
	    $('.i-checks').on('ifChanged', function(event){
	    	if(event.target.checked){
		    	$("#workStatus").val(1);
		    	//alert($("#workStatus").val())
	    	}else{
	    		$("#workStatus").val("");
	    		//alert($("#workStatus").val())
	    	}
	    	searchlist()
	    }); 
	    
	    /*条件查询*/
	    function searchlist(){
			var workStatus = $("#workStatus").val();
			var workType = $("#workType").val();
			//alert(workStatus);
			//alert(workType);
			$.ajax({
				url: 'remindRecord/record.do',
				type: 'post',
				data: {
					'STATUS': workStatus,
					'TYPE': workType
				},
				success : function(data){
					var obj = eval(data);
						$(".table tbody").empty();
						if(obj){
							$.each(obj, function(i, event){
								var type;
								if('daily'==event.TYPE){
									type = '日常任务';
								}else if('cproject'==event.TYPE){
									type = '协同任务';
								}else if('business'==event.TYPE){
									type = '目标任务';
								}else if('flow'==event.TYPE){
									type = '流程任务';
								}else if('temp'==event.TYPE){
									type = '临时任务';
								}
								
								var status_i;
								var status_text;
								if(event.STATUS==1){
									status_i = 'text-info';
									status_text = '';
								}else{
									status_i = '';
									status_text = 'style="color:#999;"';
								}
								
								var d=new Date(event.TIME);
								var year=d.getFullYear();     
					            var month= ("0" + (d.getMonth() + 1)).slice(-2);     
					            var date=("0" + d.getDate()).slice(-2);     
					            var hour=("0" + d.getHours()).slice(-2);     
					            var minute=("0" + d.getMinutes()).slice(-2);     
					            var second=("0" + d.getSeconds()).slice(-2);
					            var eventTime=year+"-"+month+"-"+date+"   "+hour+":"+minute+":"+second;
					            if(event.TIME==null){
					            	eventTime=""
					            }
					            //alert(eventTime);
								var append = '<tr><td class="project-status" style="width:120px;">'+
								  '<span><i class="fa fa-circle '+status_i+'"></i>  &nbsp;&nbsp;' +type+'</span></td>'+
								  '<td class="project-title"><a onclick="markread('+event.STATUS+','+event.ID+');siMenu(\'remind_handle\',\'remind_handle\',\'日清\',\''+event.URL+'\');"'+status_text+'>'+event.WORK_NAME+'</a></td>'+
								  '<td class="project-actions">'+eventTime+'</td>'+
								  '<td class="project-actions"><a onclick="markread('+event.STATUS+','+event.ID+');siMenu(\'remind_handle\',\'remind_handle\',\'日清\',\''+event.URL+'\');" class="btn btn-white btn-sm">'+
	                              '<i class="fa fa-folder"></i> 查看 </a></td></tr>';
								$(".table tbody").append(append);
							});
						}else{
							$(".project-list").append('没有数据');
						}
					
				}
			});
		}
		
		function markread(status,ID){
			if(status==1){
				//alert(status);
				//alert(ID);
				$.ajax({
					url: 'remindRecord/updateRead.do',
					type: 'post',
					data: {
						'status': 2,
						'ID': ID
					},
					success : function(){
						//alert("success");
					}
				});
			}
			setTimeout('searchlist()',500);
		}
		
		//一键标记已读
		function allRead(){
			$.ajax({
				url: 'remindRecord/updateAll.do',
				type: 'post',
				success : function(){
					//alert("success");
				}
			});
			setTimeout('searchlist()',500);
		}
		
		//菜单状态切换
		var fmid = "mfwindex";
		var mid = "mfwindex";
		function siMenu(id,fid,MENU_NAME,MENU_URL){
			if(id != mid){
				$("#"+mid).removeClass();
				mid = id;
			}
			if(fid != fmid){
				$("#"+fmid).removeClass();
				fmid = fid;
			}
			$("#"+fid).attr("class","active open");
			$("#"+id).attr("class","active");
			top.mainFrame.tabAddHandler(id,MENU_NAME,MENU_URL);
			if(MENU_URL != "druid/index.html"){
				jzts();
			}
		}
		
    </script>
</body>    
</html>