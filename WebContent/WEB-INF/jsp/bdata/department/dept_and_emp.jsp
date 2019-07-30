<%--
  Created by IntelliJ IDEA.
  User: yangdw
  Date: 2016/3/21
  Time: 17:40
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
    <title>责任部门责任人</title>
    <base href="<%=basePath%>">
    <meta charset="utf-8" />
    <meta name="description" content="overview & stats" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="static/css/bootstrap.min.css" rel="stylesheet" />
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="static/assets/css/font-awesome.min.css" />
    <!-- 下拉框 -->
    <link rel="stylesheet" href="static/css/chosen.css" />
    <link rel="stylesheet" href="static/css/ace.min.css" />
    <link rel="stylesheet" href="static/css/ace-responsive.min.css" />
    <link rel="stylesheet" href="static/css/ace-skins.min.css" />
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <!--提示框-->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>

    <!--树状图插件 -->
    <link rel="StyleSheet" href="static/css/dtree.css" type="text/css" />
    <script type="text/javascript" src="static/js/dtree.js"></script>
    <!--树状图插件 -->
    <link rel="StyleSheet" href="static/css/style.css" type="text/css" />
    <link rel="stylesheet" href="static/css/css.css">
    <style type="text/css">
    	.eoffice{margin: 20px auto;}
    </style>
    
    <!--jquery滚动条 -->
    <script src="static/assets/js/jquery.nicescroll.js"></script>
</head>
<body>
	<!-- 保存页面选择的人员信息 -->
	<input type="hidden" id = "DEPT_NAME" value="${DEPT_NAME}">
	<input type="hidden" id = "DEPT_CODE" value="${DEPT_CODE }">
	<input type="hidden" id = "DEPT_ID" value="${DEPT_ID}">
	<input type="hidden" id = "EMP_NAME" value="${EMP_NAME}">
	<input type="hidden" id = "EMP_CODE" value="${EMP_CODE}">
	<input type="hidden" id = "EMP_ID" value="${EMP_ID}">

    <div id="DeptAndEmp">
        <div class="eoffice" style="background-color: #fff; margin:0; border:0;">
            <!---eoffice左侧选择部门--->
            <div class="tabbable tabs-below office_tab" style="width:250px">
                <!-- 
                <ul class="nav nav-tabs" id="myTab2" style="border-bottom:1px solid #d9d9d9; margin:0;display:none">
                    <li class="active" style="width:100px"><a data-toggle="tab">部门</a></li>
                </ul>
                 -->

                <div class="tab-content office_tabcontent" id="deptList1" style="overflow: auto;height: 443px;padding:0;">
                </div>
            </div>

            <!---eoffice右侧选择姓名---->
            <div class="eoffice_right" style="width:608px;">
                <c:if test="${'2' == STATUS}">
                    <div class="eoffice_right_bg" style="height:39px;">员工
                            <div class="allclear fr"><i class="icon-trash">清空</i></div>
                            <div class="allselect fr"><i class="icon-check">全选</i></div>
                    </div>
                </c:if>
                <div class="">
                    <div class="user_list_main" style="overflow-y:scroll;width:100%;">
                        <ul>
                            <c:forEach items="${empList}" var="var" varStatus="vs">
                                <li empId = '${var.ID}' id="user_list" onclick="clickEvent($(this))">
                                    <c:if test="${'1' == STATUS}">
                                        <c:if test="${var.ID == EMP_ID || var.EMP_CODE == EMP_CODE}">
                                            <a class='selected_tip' href='javascript:void(0)'><i class='icon-check-circle'></i></a>
                                        </c:if>
                                    </c:if>
                                    <c:if test="${'2' == STATUS}">
                                        <c:forEach items="${fn:split(EMP_ID,',')}" var="empVar" varStatus="empVs">
                                            <c:choose>
                                            	<c:when test="${var.ID == empVar}">
                                            		<a class='selected_tip' href='javascript:void(0)'><i class='icon-check-circle'></i></a>
                                            	</c:when>
                                            	<c:otherwise>
                                            		<c:forEach items="${fn:split(EMP_CODE,',')}" var="empCodeVar" varStatus="empCodeVs">
			                                            <c:if test="${var.EMP_CODE == empCodeVar}">
			                                                <a class='selected_tip' href='javascript:void(0)'><i class='icon-check-circle'></i></a>
			                                            </c:if>
			                                        </c:forEach>
                                            	</c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </c:if>
                                    ${var.EMP_NAME}
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
                <div class="eoffice_right_bg">已选择</div>
                <div class=""><div class="selected_user" style="overflow-y:scroll;margin:0; height:165px"></div></div>
            </div>

            <div class="cleaner"></div>
            
        </div>
    </div>

    <script>
        //隐藏div中的滚动条
        $(".user_list_main").niceScroll({
            cursoropacitymax:0,
        });
        $(".selected_user").niceScroll({
            cursoropacitymax:0,
        });
    </script>
    <script>
        $(document).ready(function(){
            //user_list指向li同时给<a>添加hover
            $("li#user_list").mouseover(function(){
                $(this).find(".selected_tip").addClass("hover");
            });
            $("li#user_list").mouseout(function(){
                $(this).find(".selected_tip").removeClass("hover");
            });
        });
    </script>

    <script>
        $(document).ready(function(){

            //传输文字并添加<a>标签
            $("li #user_list").click(function(){
                clickEvent($(this));
            });

            //取消选中、remove <a>标签
            $(".selected_user").delegate("li", "click", function(){
                $("#EMP_NAME").val("");
                $("#EMP_ID").val("");
                $(this).remove();
                var name = $(this).text();
                $("li#user_list").each(function(){
                    if($.trim($(this).text()) == name){
                        $(this).children("a").remove();
                    }
                });
                makeEmpList();
            });
            
          	//全选
            $(".allselect").click(function(){
                //$(".selected_user").children("li").remove();
                $("li#user_list").children("a").remove();
                $("li#user_list").each(function(){
                	var empId = $(this).attr("empId");
                	var empCode = $(this).attr("empcode");
                	var empName = $.trim($(this).text());
                	var deptName = $(this).attr("deptName");
                	//判断是否选择
                	var isExist = false;
                	$(".selected_user").children("li").each(function(){
                		var selEmpId = $(this).attr("empid");
                		if(!isExist){
                			isExist = selEmpId==empId;
                		}
                	});
                	//没选择过的，才拼接上
                	if(!isExist){
                		$(".selected_user").append (selectedEmp(empId, empName, empCode, deptName));
                	}
                	$(this).prepend(selectedTip());
                });
                makeEmpList();
            });

            //清空
            $(".allclear").click(function(){
                $(".selected_user").children("li").remove();
                $("li#user_list").children("a").remove();
                makeEmpList();
            });

            //拼接部门树
            var shtml = '';
            varList = new dTree('varList','static/img','treeForm');
            varList.config.useIcons=true;
            varList.add('${ParentId}',-1,'责任部门','');
            <c:forEach items="${deptList}" var="var" varStatus="vs">
            varList.add('${var.ID}','${var.PARENT_ID}','${var.DEPT_NAME}',
            		"javascript:getEmp('${var.ID}','${var.DEPT_NAME}', '${var.DEPT_CODE}')",'','','','',true);
            </c:forEach>
            shtml += varList;
            $('#deptList1').append(shtml);

            //var selector = "[href=\'javascript:getEmp('" + $("#DEPT_ID").val() + "','" + $("#DEPT_NAME").val() + "')\']";
           // $("[href]").each.removeClass('node');
            /*
            $("[href]").each(function(){
            	$(this).removeClass('node');
            })
            $(selector)[0].removeClass('node');
            $(selector)[0].removeClass('nodeSel');
            $(selector)[0].toggleClass('nodeSel');
            */
			//初始化时，在已选择中拼接员工
			if('1' == '${STATUS}'){//单选
				if("" != $("#EMP_NAME").val() && 0 != $("#EMP_NAME").length ){
                    $(".selected_user").append(selectedEmp($("#EMP_ID").val(), $("#EMP_NAME").val(), $("#EMP_CODE").val()));
                }
			}
            if('2' == '${STATUS}'){//多选
            	if("" != $("#EMP_NAME").val() && 0 != $("#EMP_NAME").length ){
                    var arrEmpId = $("#EMP_ID").val().split(',');
                    var arrEmpName = $("#EMP_NAME").val().split(',');
                    var arrEmpCode = $("#EMP_CODE").val().split(',');
                    for(var i = 0; i < arrEmpName.length; i ++){
                        $(".selected_user").append(selectedEmp(arrEmpId[i], arrEmpName[i], arrEmpCode[i]));
                    }
                }
            }
            
        });

        //单选
        <c:if test="${'1' == STATUS}">
            function clickEvent($obj){
                var word = $obj.text();
                word = $.trim(word);
                $(".selected_user li").remove();
                $(".selected_user").append(selectedEmp($obj.attr("empId"), word, $obj.attr("empCode"), $obj.attr("deptName")));
                $obj.parent().find("li").each(function(){
                    $(this).children("a").remove();
                })
                $obj.prepend(selectedTip());
                makeEmpList();
            }
        </c:if>

        //多选
        <c:if test="${'2' == STATUS}">
            function clickEvent($obj){
                var word = $obj.text();
                word = $.trim(word);
                var has = false;
                $(".selected_user li").each(function(){
                    if($(this).text() == word){
                        has=true;
                        $(this).remove();
                    }
                });
                if(!has){
                    $(".selected_user").append(selectedEmp($obj.attr("empId"), word, $obj.attr("empCode"), $obj.attr("deptName")));
                    $obj.prepend(selectedTip());
                }else{
                	$obj.children("a").remove();
                }
                makeEmpList();
            }
        </c:if>
        
        //返回选择的员工
        function selectedEmp(empId, empName, empCode, title){
            //返回拼接的字符
        	var str = "<li ";
            if(title){
            	str += " title='" + title + "' ";
            }
			str += " empId = '" + empId + "' empCode='" + empCode + "'>" + empName 
        		+ "<span class='shanchu'><i class='icon-close'></i></span></li>";
        	return str;
        }
        
        //返回已选择的图标
        function selectedTip(){
        	return "<a class='selected_tip' href='javascript:void(0)'><i class='icon-check-circle'></i></a>";
        }

        //保存选择的员工信息
        function makeEmpList(){
            var EMP_ID_ARR = new Array();
            var EMP_NAME_ARR = new Array();
            var EMP_CODE_ARR = new Array();
            $(".selected_user").find("li").each(function(){
                EMP_ID_ARR.push($(this).attr('empId'));
                EMP_NAME_ARR.push($.trim($(this).text()));
                EMP_CODE_ARR.push($(this).attr('empCode'));
            })
            $("#EMP_ID").val(EMP_ID_ARR.join(','));
            $("#EMP_NAME").val(EMP_NAME_ARR.join(','));
            $("#EMP_CODE").val(EMP_CODE_ARR.join(','));
        }
    </script>

<script type="text/javascript">
    //通过选择部门获取员工
    function getEmp(ID,NAME, CODE){
        //保存选择的部门信息
        $("#DEPT_ID").val(ID);
        $("#DEPT_NAME").val(NAME);
        $("#DEPT_CODE").val(CODE);
        //清空员工列表后再次加载
        $(".user_list_main ul li").remove();
        //$(".selected_user li").remove();
        $.ajax({
            type: "POST",
            url: '<%=basePath%>employee/findEmpByDept.do?isService=${isService}',
            data: {deptId:ID},
            dataType: 'json',
            cache: false,
            success: function(data){
                if(0 < data.list.length){
                    var li = "";
                    for(var i = 0; i < data.list.length; i++) {
                        li += "<li id='user_list' empId = '" + data.list[i].ID +"'"
                        	+ " empCode='" + data.list[i].EMP_CODE + "'"
                        	+ " deptName='" + data.list[i].EMP_DEPARTMENT_NAME + "'"
                        	+ " onclick='clickEvent($(this))'>" + data.list[i].EMP_NAME + "</li>"       
                    }
                    $(".user_list_main ul").append(li);
                    $(".selected_user").find("li").each(function(){
				       	var bottomEmpId = $(this).attr('empId');
				       	var bottomEmpCode = $(this).attr('empCode');
						$(".user_list_main ul li").each(function(){
							var topEmpId = $(this).attr('empId');
							var topEmpCode = $(this).attr('empCode');
							if(topEmpId == bottomEmpId || topEmpCode == bottomEmpCode)
							{
								$(this).prepend(selectedTip());
							}							
						})													
					})
                }
                else {
                    $(".user_list_main ul").tips({
                        side:3,
                        msg:'所选部门无员工！',
                        bg:'#AE81FF',
                        time:2
                    });
                }
            }
        });
    }
</script>
</body>
</html>
