<%
	String pathl = request.getContextPath();
	String basePathl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+pathl+"/";
%>
<style>
	
	/*子菜单*/
	
	.nav-list>li .submenu {
        display:none;
        list-style:none;
        margin:0;
        padding:0;
        position:relative;
        background-color:#fff;
        border-top:1px solid #e5e5e5
    }
    
    .nav-list>li .submenu>li {
        margin-left:0;
        position:relative
    }
    .nav-list>li .submenu>li>a {
        display:block;
        position:relative;
        color:#616161;
        padding:7px 0 9px 37px;
        margin:0;
        border-top:1px dotted #e4e4e4
    }
    .nav-list>li .submenu>li>a:focus {
        text-decoration:none
    }
    .nav-list>li .submenu>li>a:hover {
        text-decoration:none;
        color:#4b88b7
    }
    .nav-list>li .submenu>li.active>a {
        color:#2b7dbc
    }
    .nav-list>li .submenu>li a>[class*="icon-"]:first-child {
        display:none;
        font-size:12px;
        font-weight:normal;
        width:18px;
        height:auto;
        line-height:12px;
        text-align:center;
        position:absolute;
        left:10px;
        top:11px;
        z-index:1;
        background-color:#FFF
    }
    .nav-list>li .submenu>li.active>a>[class*="icon-"]:first-child, .nav-list>li .submenu>li:hover>a>[class*="icon-"]:first-child {
        display:inline-block
    }
    .nav-list>li .submenu>li.active>a>[class*="icon-"]:first-child {
        color:#c86139
    }
    .nav-list>li>.submenu>li:before {
        content:"";
        display:inline-block;
        position:absolute;
        width:7px;
        left:20px;
        top:17px;
        border-top:1px dotted #9dbdd6
    }
    .nav-list>li>.submenu>li:first-child>a {
        border-top:1px solid #fafafa
    }
    .nav-list>li>.submenu:before {
        content:"";
        display:block;
        position:absolute;
        z-index:1;
        left:18px;
        top:0;
        bottom:0;
        border:1px dotted #9dbdd6;
        border-width:0 0 0 1px
    }
    .nav-list>li.active>.submenu>li:before {
        border-top-color:#8eb3d0
    }
    .nav-list>li.active>.submenu:before {
        border-left-color:#8eb3d0
    }
    .nav-list li .submenu {
        overflow:hidden
    }
    .nav-list li.active>a:after {
        display:block;
        content:"";
        position:absolute!important;
        right:0;
        top:4px;
        border:8px solid transparent;
        border-width:14px 10px;
        border-right-color:#2b7dbc
    }
    .nav-list li.open>a:after {
        display:none
    }
    .nav-list li.active.open>.submenu>li.active.open>a.dropdown-toggle:after {
        display:none
    }
    .nav-list li.active>.submenu>li.active>a:after {
        display:none
    }
    .nav-list li.active.open>.submenu>li.active>a:after {
        display:block
    }
    
    .nav-list>li a>.arrow {
        display:inline-block;
        width:14px!important;
        height:14px;
        line-height:14px;
        text-shadow:none;
        font-size:18px;
        position:absolute;
        right:11px;
        top:15px;
        padding:0;
        color:white
    }
    .nav-list>li a:hover>.arrow, .nav-list>li.active>a>.arrow, .nav-list>li.open>a>.arrow {
        color:#1963aa
    }
    .nav-list>li>.submenu a>.arrow {
        right:11px;
        top:10px;
        font-size:16px;
        color:#6b828e
    }
    .nav-list>li>.submenu .open>a, .nav-list>li>.submenu .open>a:hover, .nav-list>li>.submenu .open>a:focus {
        background-color:transparent;
        border-color:#e4e4e4
    }
    .nav-list>li>.submenu li>.submenu>li>a>.arrow {
        right:12px;
        top:9px
    }
    .nav-list>li>.submenu li.open>a .arrow {
        color:#25639e
    }
    .nav-list>li>.submenu li>.submenu li.open>a {
        color:#25639e
    }
    .nav-list>li>.submenu li>.submenu li.open>a>[class*="icon-"]:first-child {
        display:inline-block;
        color:#1963aa
    }
    .nav-list>li>.submenu li>.submenu li.open>a .arrow {
        color:#25639e
    }
    .menu-min .nav-list>li>a .arrow {
        display:none
    }
    .nav-list>li>.submenu li>.submenu>li>a {
        margin-left:20px;
        padding-left:30px
    }
   
    .select2-container .select2-choice .select2-arrow b {
        background:0
    }
    .select2-container .select2-choice .select2-arrow b:before {
        font-family:FontAwesome;
        font-size:12px;
        display:inline;
        content:"\f0d7";
        color:#888;
        position:relative;
        left:5px
    }
    .select2-dropdown-open .select2-choice .select2-arrow b:before {
        content:"\f0d8"
    }
   
    #sidebar{
    	/* position:fixed; */
    	top:0;
    	left:0;
    	height:100%;
    	overflow:hidden;
    	outline:none;
    	background:#fff;
    }
   body{font-family:Chinese Quote,-apple-system,BlinkMacSystemFont,Segoe UI,PingFang SC,Hiragino Sans GB,Microsoft YaHei,Helvetica Neue,Helvetica,Arial,sans-serif !important;}
</style>
		
		<!-- 本页面涉及的js函数，都在head.jsp页面中     -->
		<div id="sidebar" class="">
				<!-- 
				<img src="static/img/admin.png">
				 -->
				<div id="sidebar-shortcuts">

					<%-- <div id="sidebar-shortcuts-large">

						<button class="btn btn-small btn-success" onclick="changeMenu();" title="切换菜单" ><i class="icon-pencil"></i></button><!-- style="padding:0 15px;"-->

						 <button class="btn btn-small btn-info" title="" onclick="window.open('<%=basePathl%>static/UI_new');"><i class="icon-eye-open"></i></button>

						<button class="btn btn-small btn-warning" title="数据字典" id="adminzidian" onclick="zidian();" ><i class="icon-book"></i></button> 
						
						<button class="btn btn-small btn-danger" title="菜单管理" id="adminmenu" onclick="menu();" ><i class="icon-folder-open"></i></button>
						
					</div> --%>

					<!-- <div id="sidebar-shortcuts-mini">
						<span class="btn btn-success"></span>

						<span class="btn btn-info"></span>

						<span class="btn btn-warning"></span>

						<span class="btn btn-danger"></span>
					</div> -->

				</div><!-- #sidebar-shortcuts -->


				<ul id="menuUl" class="nav nav-list">

					<li class="active" id="mfwindex">
					  <a href="login_index.do"><i class="icon-dashboard"></i><span> 工作台</span></a>
					</li>

					<script type="text/javascript">
						$.ajax({
							type: 'post',
							url: 'findMenuList.do',
							success: function(data){
								if(data.msg=='success'){
									if(data.menuList){
										var html = appendMenu2(data.menuList);
										$("#menuUl").append(html);
									}
								}else{
									top.Dialog.alert('获取菜单失败');
								}
							}
						});
						
						function appendMenu2(menuList, level){
							var html = '';
							if(null==level){//目录所在的层级
								level = 1;
							}
							//循环处理菜单
							for(var i=0; i<menuList.length; i++){
								var menu = menuList[i];
								//当前菜单有权限时
								if(menu.hasMenu==true){
									var menuUrl = menu.menu_URL, menuIcon = '';
									//判断菜单的图标
									if(level==1){
										menuIcon = 'icon-desktop';
										if(null!=menu.menu_ICON && menu.menu_ICON!=''){//菜单图标
											menuIcon = menu.menu_ICON;
										}
									}else{
										menuIcon ='icon-double-angle-right';
									}
									
									//拼接第一级菜单
									html += '<li id="lm"'+ menu.menu_ID+ '">';
									if(menu.subMenu && menu.subMenu.length>0){//有下一级菜单
										html += '<a class="dropdown-toggle" href="#" ><i class="' + menuIcon + '"></i>'
											+ '<span>' + menu.menu_NAME + '</span><b class="arrow icon-angle-down"></b>'
											+ '</a>';
										//拼接第二级菜单
										html += '<ul class="submenu">';
										html += appendMenu2(menu.subMenu, level+1);
										html += '</ul>';
									}else{//没有下一级菜单
										if(menu.menu_URL=='#'){//没有菜单url，跳转到待开发页面
											menu.menu_URL = 'toErrorDevelop.do';
										}
										html += '<a style="cursor:pointer;" target="mainFrame" '
											+ ' onclick="siMenu(\'lm' + menu.menu_ID + '\',\'lm' + menu.menu_ID + '\',\'' + menu.menu_NAME + '\',\'' + menu.menu_URL + '\')">'
											+ '<i class="' + menuIcon + '"></i>'
											+ '<span>' + menu.menu_NAME + '</span>'
				                        	+ '</a>';
									}
									html += '</li>';
								}
							}
							return html;
						}
						
						function appendMenu(menuList){
							var html = '';
							for(var i=0; i<menuList.length; i++){
								var menu = menuList[i];
								//当前菜单有权限时
								if(menu.hasMenu==true){
									var menuUrl = menu.MENU_URL, menuIcon = 'icon-desktop';
									if(menu.MENU_ICON){//菜单图标
										menuIcon = menu.MENU_ICON;
									}
									//拼接第一级菜单
									html += '<li id="lm"'+ menu.MENU_ID+ '">';
									if(menu.subMenu){//有下一级菜单
										html += '<a class="dropdown-toggle" href="#" ><i class="' + menuIcon + '"></i>'
											+ '<span>' + menu.MENU_NAME + '</span><b class="arrow icon-angle-down"></b>'
											+ '</a>';
										//拼接第二级菜单
										html += '<ul class="submenu">';
										for(var j=0; j<menu.subMenu; j++){
											var sub = menu.subMenu[j];
											if(sub.hasMenu){//有权限
												
												if(sub.subMenu){//有下一级菜单
													html += '<li>'
														+ '<a href="#" class="dropdown-toggle"><i class="icon-double-angle-right"></i>'
														+ sub.MENU_NAME + '<b class="arrow icon-angle-down"></b>'
														+ '</a>';
													//拼接下一级菜单
													html += '<ul class="submenu">';
													for(var k=0; k<sub.subMenu.length; k++){
														var newSub = sub.subMenu[k];
														if(newSub.hasMenu==true){//有权限
															if(newSub.MENU_URL){
																html += '<li id="z' + newSub.MENU_ID + '">'
																	+ ' <a style="cursor:pointer;" target="mainFrame" '
																	+ 'onclick="siMenu(\'z' + newSub.MENU_ID + '\',\'lm' + sub.MENU_ID + '\',\'' + newSub.MENU_NAME  + '\',\'' + newSub.MENU_URL + '\')">';
															}else{
																html += '<li><a href="javascript:void(0);"><i class="icon-double-angle-right"></i>' + newSub.MENU_NAME + '</a></li>';
															}
														}
													}
													html += '</ul></li>';
												}else{//没有下一级菜单
													if(sub.MENU_URL){
														html += '<li id="z' + sub.MENU_ID + '">'
															+ ' <a style="cursor:pointer;" target="mainFrame" '
															+ ' onclick="siMenu(\'z' + sub.MENU_ID + '\',\'lm' + menu.MENU_ID + '\',\'' + sub.MENU_NAME + '\',\'' + sub.MENU_URL + '\')">'
															+ '<i class="icon-double-angle-right"></i>' + sub.MENU_NAME + '</a>'
															+ '</li>';
													}else{
														html += ' <li><a href="javascript:void(0);"><i class="icon-double-angle-right"></i>' + sub.MENU_NAME + '</a></li>';
													}
												}
											}
										}
										html += '</ul>';
									}else{//没有下一级菜单
										if(menu.MENU_URL=='#'){//没有菜单url
											html += '<a class="dropdown-toggle" href="#" ><i class="' + menuIcon + '"></i>'
											+ '<span>' + menu.MENU_NAME + '</span><b class="arrow icon-angle-down"></b>'
											+ '</a>';
										}else{
											html += '<a style="cursor:pointer;" target="mainFrame" '
												+ ' onclick="siMenu(\'lm' + menu.MENU_ID + '\',\'lm' + menu.MENU_ID + '\',\'' + menu.MENU_NAME + '\',\'' + menu.MENU_URL + '\')">'
												+ '<i class="' + menuIcon + '"></i>'
												+ '<span>' + menu.MENU_NAME + '</span>'
					                        	+ '</a>';
										}
									}
									html += '</li>';
								}
							}
							return html;
						}
					</script>

				</ul><!--/.nav-list-->

				<div id="sidebar-collapse"><i class="icon-double-angle-left"></i></div>

			</div><!--/#sidebar-->

