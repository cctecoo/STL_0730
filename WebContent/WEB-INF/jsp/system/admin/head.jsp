<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String pathh = request.getContextPath();
	String basePathh = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+pathh+"/";
%>
<style>
	/*设置下拉列表样式*/
	.dropdown{width:170px;}
	.dropdown-menu{
		width:300px; margin-left:2px;
  	    margin-top:-3px; border-radius:0;
    }
	
    /*下拉列表样式*/
    .dropdown-menu li{
    	 padding:5px 10px;
    	 cursor:pointer;
    }
    
    /*鼠标悬浮之后样式*/
    .dropdown-menu li:hover{
    	background-color: #f4f9fc!important;
    	color:#fff;
    }
	.dropdown-menu>li>a:hover {
    	background-color: transparent!important;
    	color: #555;
	}
	
	/*显示下拉列表*/
    #msgDiv:hover>.dropdown-menu{
    	display: block;
    }
    #taskDiv:hover>.dropdown-menu{
    	display: block;
    }
    #userDiv:hover>.dropdown-menu{
    	display: block;
    }
    
    /*设置按钮样式*/
    .btn-tip{
    	background: transparent !important;
    	border-color: transparent;
    	padding:0; width: 94%;
    }
</style>
<div class="navbar navbar-inverse">
		  <div class="navbar-inner">
		   <div class="container-fluid">
			  <a class="brand" href="login_index.do">
				  <small>
					  <!-- 登陆后，主页显示的日清图片 -->
					  <img style="height:45px;" src="static/login_new/images/stl-logo.png">
					 <!--  
					  <img style="height:45px;" src="static/logo_change/logo.png">
					  -->
				  </small>
			  </a>

			  <!-- 右上角显示的任务信息 -->
			  <div class="nav ace-nav pull-right" style="padding-right:10px;">
				  <div style="float: left;">
					  <!-- 显示系统使用帮助 -->
					  <a class="btn btn-tip" onclick="showFaqTab();">
						  <i class="icon icon-question-sign"></i>
						  <span>使用指南</span>
					  </a>
				  </div>

				<div id="msgDiv" class="dropdown" style="float:left;">
					<a class="btn btn-tip">
						<i id="notice" class="icon-bell-alt icon-animated-bell"></i>
                        <span>未读消息</span>
                        <span id="noticeCount" class="badge badge-success">0</span>
					</a>
					<ul id="noticeList" class="dropdown-menu">
				    </ul>
				</div>
				<div id="taskDiv" class="dropdown" style="float:left;">
					<a class="btn btn-tip" >
						<i class="icon-envelope-alt icon-animated-vertical icon-only"></i>
                        <span>新的工作</span>
                        <span id="msgCount" class="badge badge-success">0</span>
					</a>
					<ul id="msgList" class="dropdown-menu">
				    </ul>
				</div>
				<div id="userDiv" class="dropdown" style="float:left;">
					<a class="btn btn-tip" >
						<!-- 
						<img alt="mfw" src="static/avatars/user.jpg" class="nav-user-photo" />
						 -->
						<span id="user_info" style="min-width:70px; max-width:120px; text-align:center; position:relative">
						</span>
						<i class="icon-caret-down"></i>
					</a>
					<!-- 
						width: 180px;
    					margin-right: 10px;
					 -->
					<ul id="user_menu" class="dropdown-menu" style="width:170px;">
						<c:if test="${user.role.ROLE_ID=='1' || user.role.PARENT_ID=='1' }">
							<li style="padding-left:10px; margin-top:-5px;">
								<button class="btn btn-small btn-success" onclick="changeMenu();" title="切换菜单" ><i class="icon-pencil"></i></button><!-- style="padding:0 15px;"-->
								
								<c:if test="${user.role.ROLE_ID=='1'}">
								<button class="btn btn-small btn-warning" title="数据字典" id="adminzidian" onclick="zidian();" ><i class="icon-book"></i></button> 
								
								<button class="btn btn-small btn-danger" title="菜单管理" id="adminmenu" onclick="menu();" ><i class="icon-folder-open"></i></button>
								</c:if>
							</li>
							<c:if test="${user.role.ROLE_ID=='1'}">
							<li id="systemset"><a onclick="editSys();" style="cursor:pointer;"><i class="icon-cog"></i> 系统设置</a></li>
							</c:if>
						</c:if>
						
						<li><a onclick="editUserH();" style="cursor:pointer;"><i class="icon-user"></i> 修改资料</a></li>
						
						<li class="divider"></li>
						<li><a href="logout.do"><i class="icon-off"></i> 退出</a></li>
					</ul>
				</div>
			</div>
			  
		   </div><!--/.container-fluid-->
		  </div><!--/.navbar-inner-->
		</div><!--/.navbar-->
	
	
		<script type="text/javascript">
			$(function() {
				getUname();
				//登陆以后，在设定的间隔时间后，启动定时刷新任，,refreshInterval为后台设定的分钟数（比如10分钟）后，启动定时任务来不断更新登陆时间
				var mills = 1000*60*${refreshInterval};
				setTimeout(function(){
					setInterval(function(){
						getLoginTime(1);
					}, mills);
				}, mills);
				//setTimeout("setInterval('getLoginTime(1)', 1000*60*${refreshInterval})", );
				refreshCount();
			});

			//打开使用帮助
			function showFaqTab(){
                window.open('document/toDocs.do');
			}
			
			//刷新当前任务数
			function refreshCount(){
				$.ajax({
                    type: "post",
                    url: "countTask.do",
                    success: function (data) {
                    	//拼接新的工作
                    	$("#msgCount").html(data.taskMsgCount);
                    	$("#msgList").empty(); 
                    	
                     	for(var i = 0; i < data.taskMsg.length; i++){
                    		if(data.taskMsg[i].count > 0){
                    			var content = "<li>"+
	                    			"    <a href='javascript:void(0)' onclick='clickTaskMsg(\""+data.taskMsg[i].url+"\")'>"+
	                    			"        <span class='msg-body'>"+
	                    			"            <span class='msg-title'>"+data.taskMsg[i].NAME+"</span>"+
	                    			"        </span>"+
	                    			"        <span class='badge badge-success'>"+data.taskMsg[i].count+"</span>"+
	                    			"    </a>"+
	                    			"</li>";
                    			$("#msgList").append(content);
                    		}
                    	} 
                     	$("#msgList").append('<li style="display: none"></li>');
                     	
                     	//拼接消息
                    	$("#noticeCount").html(data.recordCount);
                    	$("#noticeList").empty();
                    	
                    	var recordList_length = "";
                    	if(data.recordList.length<3){
                    		recordList_length=data.recordList.length
                    	}else{
                    		recordList_length=3
                    	}
                    	//alert(recordList_length);
                    	for(var i = 0; i < recordList_length; i++){
                    			var content = "<li>"+
	                    			"    <a href='javascript:void(0)' onclick='clickRecordMsg(\""+data.recordList[i].URL+"\",\""+data.recordList[i].ID+"\")'>"+
	                    			"        <span class='msg-body' style='max-width:none;'>"+
	                    			"            <span class='msg-title'>"+data.recordList[i].WORK_NAME+"</span>"+
	                    			"        </span>"+
	                    			"    </a>"+
	                    			"</li>";
                    			$("#noticeList").append(content);
                    	}
                    	var remindlist = '<li style="text-align:center;">'
                    		+ '<a onclick="siMenu(\'lm9999\',\'lm9999\',\'消息历史记录\',\'remindRecord/list.do\')">查看全部消息</a>'
                    		+ '</li>';
                    	$("#noticeList").append(remindlist);
                    	$("#noticeList").append('<li style="display: none"></li>');
                    }
                });
			}
			
			//任务通知点击事件
			function clickTaskMsg(url){
				$.ajax({
					url:"menu/findByUrl.do",
					data:{"url":url},
					type:"post",
					success:function(data){
						siMenu("z"+data.MENU_ID, "lm"+data.PARENT_ID, data.MENU_NAME, url);
					}
				});
			}
			
			//未读消息通知点击事件
			function clickRecordMsg(url,id){
				$.ajax({
					url: 'remindRecord/updateRead.do',
					type: 'post',
					data: {
						'status': 2,
						'ID': id
					},
					success : function(){
						refreshCount();
						$.ajax({
							url:"menu/findByUrl.do",
							data:{"url":url},
							type:"post",
							success:function(data){
								siMenu("z"+data.MENU_ID, "lm"+data.PARENT_ID, data.MENU_NAME, url);
							}
						});
					}
				});
			}
			
			var oldLevel = 0;
			
			function getLoginTime(first){
				var url = "getLoginTime.do";
				if(first==0){
					url += "?first=1";
				}
				$.ajax({
	                type: "POST",
	                async: true,
	                url: url,
	                success:function (data) {
	                	var level = "";
	                	var req=16+4*data;
	                	var result=(Math.sqrt(req)-4)/2/10;
                		var i = result.toString().split(".");
                		level = Number(i[0])+1;
                		if(oldLevel==level){
                			return;
                		}
                		oldLevel = level;
                		//alert(oldLevel==level);
	                	//$("#loginTime").text("在线等级："+level+"级");
	                	var levelMsg = '';
	                	var sunLevel = parseInt(level/16);
	                	var moonLevel = parseInt((level%16)/4);
	                	var starLevel = (level%4);
	                	for(var i=0; i<sunLevel; i++){
	                		levelMsg += '<img src="static/images/sun.png" />';
	                	}
	                	for(var i=0; i<moonLevel; i++){
	                		levelMsg += '<img src="static/images/moon.png" />';
	                	}
	                	for(var i=0; i<starLevel; i++){
	                		levelMsg += '<img src="static/images/star.png" />';
	                	}
	                	$("#user_info small").empty();
	                	$("#user_info small").html(levelMsg);
	                	$("#user_info small").attr("title", "在线等级：" +level + "级");
	                	//alert("sunLevel=" + sunLevel +"," + moonLevel + "," + starLevel);
	                	 /* if(data<=100){
	                		$("#loginTime").text("在线等级：1级");
	                	}else if(100<data<=500){
	                		$("#loginTime").text("在线等级：2级");
	                	}else if(500<data<=2500){
	                		$("#loginTime").text("在线等级：3级");
	                	}else if(2500<data<=12500){
	                		$("#loginTime").text("在线等级：4级");
	                	}else if(12500<data){
	                		$("#loginTime").text("在线等级：5级");
	                	} */
	                	//$("#loginTime").text("累计在线时长："+data+"分钟");
	                }
	                
	            });
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
		
			var USER_ID;
		
			function getUname(){
				$.ajax({
					type: "POST",
					url: '<%=basePathh%>/head/getUname.do?tm='+new Date().getTime(),
			    	data: encodeURI(""),
					dataType:'json',
					//beforeSend: validateData,
					cache: false,
					success: function(data){
						 $.each(data.list, function(i, list){
							 //登陆者资料
							 $("#user_info").html('<small>Welcome</small> '+list.NAME+'');
							 getLoginTime(0);
							 USER_ID = list.USER_ID;//用户ID
							 hf(list.SKIN)//皮肤
						 });
					}
				});
			}
			
			function hf(b){
				
				var a=$(document.body);
				a.attr("class",a.hasClass("navbar-fixed")?"navbar-fixed":"");
				if(b!="default"){
					a.addClass(b)
				}if(b=="skin-1"){
					$(".ace-nav > li.grey").addClass("dark")
				}else{
					$(".ace-nav > li.grey").removeClass("dark")
				}
				if(b=="skin-2"){
						$(".ace-nav > li").addClass("no-border margin-1");
						$(".ace-nav > li:not(:last-child)").addClass("white-pink")
						.find('> a > [class*="icon-"]').addClass("pink").end()
						.eq(0).find(".badge").addClass("badge-warning")
				}else{
						$(".ace-nav > li").removeClass("no-border").removeClass("margin-1");
						$(".ace-nav > li:not(:last-child)").removeClass("white-pink")
						.find('> a > [class*="icon-"]').removeClass("pink").end()
						.eq(0).find(".badge").removeClass("badge-warning")
				}
				if(b=="skin-3"){
					$(".ace-nav > li.grey").addClass("red").find(".badge").addClass("badge-yellow")
				}else{
					$(".ace-nav > li.grey").removeClass("red").find(".badge").removeClass("badge-yellow")
				}
			}
			
			//修改个人资料
			function editUserH(){
				 jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="个人资料";
				 diag.URL = '<%=basePathh%>/user/goEditU.do?USER_ID='+USER_ID+'&fx=head';
				 diag.Width = 450;
				 diag.Height = 450;
				 diag.CancelEvent = function(){ //关闭事件
					diag.close();
				 };
				 diag.show();
			}
			
			//系统设置
			function editSys(){
				 jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="系统设置";
				 diag.URL = '<%=basePathh%>/head/goSystem.do';
				 diag.Width = 600;
				 diag.Height = 596;
				 diag.CancelEvent = function(){ //关闭事件
					diag.close();
				 };
				 diag.show();
			}
		
			//代码生成
			function productCode(){
				 jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="代码生成器";
				 diag.URL = '<%=basePathh%>/head/goProductCode.do';
				 diag.Width = 800;
				 diag.Height = 450;
				 diag.CancelEvent = function(){ //关闭事件
					changeui();
					diag.close();
				 };
				 diag.show();
			}
		
			//数据字典
			function zidian(){
				 jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="数据字典";
				 diag.URL = '<%=basePathh%>/dictionaries.do?PARENT_ID=0';
				 diag.Width = 850;
				 diag.Height = 500;
				 diag.CancelEvent = function(){ //关闭事件
					diag.close();
				 };
				 diag.show();
				 
			}
		
			//菜单
			function menu(){
				 jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title ="菜单编辑";
				 diag.URL = '<%=basePathh%>/menu.do';
				 diag.Width = 1050;
				 diag.Height = 600;
				 diag.CancelEvent = function(){ //关闭事件
					diag.close();
				 };
				 diag.show();
				 
			}
			
			//切换菜单
			function changeMenu(){
				window.location.href='<%=basePathh%>login_index.do?changeMenu=yes';
			}
			
			//清除加载进度
			function changeui(){
				$("#jzts").hide();
			}
			
			//显示加载进度
			function jzts(){
				$("#jzts").show();
			}
			
			//左侧菜单滚动条
			$(document).ready(function() {  
			    $("#sidebar").niceScroll({
			    	cursorcolor: "#ccc",//#CC0071 光标颜色
			    	autohidemode : true // 是否隐藏滚动条
			    });
			});
			
			function handleTask(url){
				jzts();
                var diag = new top.Dialog();
                diag.Drag=true;
                diag.Title ="任务处理";
                diag.URL = '<%=basePathh%>/menu.do';
                diag.Width = 1050;
                diag.Height = 600;
                diag.CancelEvent = function(){ //关闭事件
                   diag.close();
                };
                diag.show();
			}
		</script>
