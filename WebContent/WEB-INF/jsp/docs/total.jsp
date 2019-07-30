<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>使用指南</title>
    <link href="plugins/Bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .panel-group{max-height:770px;overflow: auto;}
        .panel-heading{padding:5px;}
        .leftMenu{margin:0px;}
        .leftMenu .panel-heading{font-size:14px;position:relative;cursor:pointer;}/*转成手形图标*/
        .leftMenu .panel-heading span{position:absolute;right:10px;top:12px;margin-top:10px;}
        .leftMenu .submenu {font-size:16px;position:relative;cursor:pointer;padding-left:15px;}/*转成手形图标*/
        .leftMenu .submenu-group{padding-left:15px;}
        .leftMenu .submenu span{top:0px;}

        .list-group{margin-bottom:0}
        .list-group-item{
            border:none;
            padding:5px 15px;
        }
        .leftMenu a{
            color:#314659;
        }
        .leftMenu a:focus, .leftMenu a:hover {
            text-decoration: none;
            color: #1890ff;
        }
    </style>

</head>
<body>

    <div class="container-fluid">
        <div class="row flex-xl-nowrap">
            <div class="col-12 col-md-3 col-xl-2 bd-sidebar">

                <!--
                <form class="bd-search d-flex align-items-center">
                    <input type="search" class="form-control" id="search-input" placeholder="Search..." aria-label="Search for..." autocomplete="off">
                    <button class="btn btn-link bd-search-docs-toggle d-md-none p-0 ml-3" type="button"
                            data-toggle="collapse" data-target="#bd-docs-nav" aria-controls="bd-docs-nav"
                            aria-expanded="false" aria-label="Toggle docs navigation">
                    </button>
                </form>
                -->
                <div class="panel-group table-responsive" role="tablist">

                    <div class="leftMenu">
                        <!-- 利用data-target指定要折叠的分组列表 -->
                        <div class="panel-heading" id="collapseListGroupHeading0" data-toggle="collapse"
                             data-target="#collapseListGroup0" role="tab" >
                            <h4 class="">
                                常见问题汇总
                            </h4>
                            <span class="glyphicon glyphicon-chevron-up right"></span>
                        </div>

                        <!-- .panel-collapse和.collapse标明折叠元素 .in表示要显示出来 -->
                        <div id="collapseListGroup0" class="panel-collapse collapse in" role="tabpanel"
                             aria-labelledby="collapseListGroupHeading0">
                            <ul class="list-group">
                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/FAQ-dept.md">常见问题-组织架构</a>
                                </li>

                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/FAQ-02-project.md">常见问题-项目</a>
                                </li>

                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/FAQ-03-budget.md">常见问题-预算管理</a>
                                </li>

                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/FAQ-04-finance.md">常见问题-财务表单</a>
                                </li>

                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/FAQ-05-purchase.md">常见问题-采购表单</a>
                                </li>
                            </ul>
                        </div>

                    </div>

                    <div class="leftMenu">
                        <div class="panel-heading" >
                            <h4 class="">
                                <a href="document/toDocs.do#started/01-summary.md">工作台</a>
                            </h4>
                        </div>
                    </div>

                    <div class="leftMenu">
                        <div class="panel-heading" >
                            <h4 class="">
                                <a href="document/toDocs.do#started/02-task.md">日清工作看板</a>
                            </h4>
                        </div>
                    </div>

                    <div class="leftMenu">
                        <div class="panel-heading" >
                            <h4 class="">
                                <a href="document/toDocs.do#started/03-task.md">待处理工作</a>
                            </h4>
                        </div>
                    </div>
                    <!--
                    <div class="leftMenu">
                        <div class="panel-heading" id="collapseListGroupHeading1" data-toggle="collapse"
                             data-target="#collapseListGroup1" role="tab" >
                            <h4 class="">
                                业务数据管理
                            </h4>
                            <span class="glyphicon glyphicon-chevron-down right"></span>
                        </div>


                        <div id="collapseListGroup1" class="panel-collapse collapse" role="tabpanel"
                             aria-labelledby="collapseListGroupHeading1">
                            <ul class="list-group">
                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/常见问题汇总.md">产品管理</a>
                                </li>
                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/常见问题汇总.md">单位维护</a>
                                </li>
                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/常见问题汇总.md">经营指标维护</a>
                                </li>
                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/常见问题汇总.md">KPI指标库</a>
                                </li>
                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/常见问题汇总.md">流程模板管理</a>
                                </li>
                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/常见问题汇总.md">表单模板管理</a>
                                </li>
                            </ul>
                        </div>

                    </div>

                    <div class="leftMenu">
                        <div class="panel-heading" id="collapseListGroupHeading2" data-toggle="collapse"
                             data-target="#collapseListGroup2" role="tab" >
                            <h4 class="">
                               综合功能管理
                            </h4>
                            <span class="glyphicon glyphicon-chevron-up right"></span>
                        </div>
                        <div id="collapseListGroup2" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="collapseListGroupHeading2">
                            <ul class="list-group">
                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/常见问题汇总.md">维修工单管理</a>
                                </li>
                                <li class="list-group-item">
                                    <a href="document/toDocs.do#started/常见问题汇总.md">一般流程管理</a>
                                </li>
                            </ul>
                        </div>
                    </div>


                    <div class="leftMenu">
                        <div class="panel-heading" id="collapseListGroupHeading3" data-toggle="collapse"
                             data-target="#collapseListGroup3" role="tab" >
                            <h4 class="">
                                人力资源管理
                            </h4>
                            <span class="glyphicon glyphicon-chevron-down right"></span>
                        </div>
                        <div id="collapseListGroup3" class="panel-collapse collapse" role="tabpanel" aria-labelledby="collapseListGroupHeading3">
                            <div class="submenu panel-heading" data-toggle="collapse"
                                 data-target="#collapseListGroup3-1" role="tab">
                                组织架构管理
                                <span class="glyphicon glyphicon-chevron-down right"></span>
                            </div>

                            <div id="collapseListGroup3-1" class="panel-collapse collapse" role="tabpanel" aria-labelledby="collapseListGroup3">

                                <ul class="submenu-group list-group">
                                    <li class="list-group-item">
                                        <a href="document/toDocs.do#deptStructure/dept.md">部门管理</a>
                                    </li>
                                    <li class="list-group-item">
                                        <a href="document/toDocs.do#deptStructure/position.md">岗位管理</a>
                                    </li>
                                    <li class="list-group-item">
                                        <a href="document/toDocs.do#deptStructure/employee.md">员工管理</a>
                                    </li>
                                </ul>
                            </div>

                        </div>
                    </div>
                    -->

                </div>

            </div>

            <main id="main" class="col-12 col-md-9 col-xl-8 py-md-3 pl-md-5 bd-content" role="main"></main>

        </div>
    </div>

    <script src="static/js/jquery-1.9.1.min.js"></script>
    <script src="plugins/marked/lib/marked.js"></script>
    <script src="plugins/Bootstrap/js/bootstrap.js"></script>
    <script>
        $(function(){
            //marked插件的基本配置
            marked.setOptions({
                renderer: new marked.Renderer(),
                gfm: true,
                tables: true,
                breaks: false,
                pedantic: false,
                sanitize: false,
                smartLists: true,
                smartypants: false
            });
            //设置点击分组后，图标变换方向
            $(".panel-heading").click(function(e){
                /*切换折叠指示图标*/
                $(this).find("span").toggleClass("glyphicon-chevron-down");
                $(this).find("span").toggleClass("glyphicon-chevron-up");
            });
        });

        //var navLinks = document.querySelectorAll('nav a');
        var currentPage = 'started/FAQ-dept.md';
        var currentHash = '';

        function hashChange(clickPage) {
            //获取当前页面的路径
            var hash = location.hash.slice(1);

            if (!hash) {
                hash = 'started/FAQ-dept.md';
            }
            //以#号分割
            var uri = hash.split('#');

            if (uri[0].match(/^\//)) {//以/开头时
                currentPage = uri[0].slice(1);
                if (uri.length > 1) {
                    currentHash = uri[1];
                } else {
                    currentHash = '';
                }
            } else {
                currentPage = uri[0];
                currentHash = uri[0];
            }

            //获取文件内容
            fetchPage(currentPage, currentHash);

            //根据文件，设置左侧导航树的展开及颜色
            if(clickPage==true){
                //设置左侧树结构中，对应菜单的颜色
                var str = 'document/toDocs.do#'+currentPage;
                $('.leftMenu a').css('color', '#314659');
                $('.leftMenu a[href=\''+str+'\']').css('color', '#1890ff');
            }

            /*
            var url = currentPage + (currentHash ? '#' + currentHash : '');
            var fullUrl = window.location.origin + '/' + url;

            navLinks.forEach(function(link) {
                link.className = link.href === fullUrl ? 'selected' : '';
            });

            history.replaceState('', document.title, url);
            */
        }

        //获取md文件
        function fetchPage(page, anchor){
            $.ajax({
                type:"get",
                url : 'document/loadMdFile.do',
                data:{'pageName' : page},
                async : false,
                dataType:"text",
                success : function(response,status,request) {
                    //设置文件内容
                    $('#main').html(marked(response));

                    if (!anchor) {
                        return;
                    }

                    var hashElement = document.getElementById(anchor);
                    if (hashElement) {
                        hashElement.scrollIntoView();
                    }
                }
            });
        }

        window.addEventListener('hashchange', function (e) {
            e.preventDefault();
            hashChange(true);
        });

        hashChange();

    </script>
</body>
</html>