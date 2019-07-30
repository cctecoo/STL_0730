<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
 <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>工作清单</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <link href="static/summaryTask/css/bootstrap.min.css?v=3.3.5" rel="stylesheet">
    <link href="static/summaryTask/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
    <link href="static/summaryTask/css/plugins/iCheck/custom.css" rel="stylesheet">

    <link href="static/summaryTask/css/animate.min.css" rel="stylesheet">
    <link href="static/summaryTask/css/style.min.css?v=4.0.0" rel="stylesheet">
	<link href="static/summaryTask/css/datepicker.css" rel="stylesheet">
    <!-- 引入 -->
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
		.searchCondition{
               float: left;
               margin: 10px;
           }
        .searchCondition input , .searchCondition select{
               height:30px;
               border:1px solid #aaa;
        }
        .searchCondition_right{
               float: right;
               margin: 12px;
         }
         .searchCondition_right a{
         	  display:table-cell;
         	  padding:3px 7px;
         	  border:1px solid #aaa;
         	  text-decoration:none;
         	  color:#aaa;
         }
         .searchCondition_right a.active{
         	  background:#448fb9;
         	  color:#fff;
         	  border:1px solid #448fb9;
         }
           
	</style>
</head>
<body>
	<div class="container-fluid" id="main-container">
			<div class="row-fluid ">
				<form action="<%=basePath%>summaryTask/goTargetDetail.do" id="formTargetDetail" method="POST">
				<div >
					<input type="hidden" name="queryEmpCode" id="empCode" value="${pd.queryEmpCode }" />
                    <div class="searchCondition">
                        <span>指标： </span>
						<select id="INDEX_CODE" name="searchIndexCode">
	                            <option value="">全部</option>
	                            <c:forEach items="${indexList}" var="index" varStatus="vs">
	                                <option value="${index.INDEX_CODE}" <c:if test="${pd.searchIndexCode == index.INDEX_CODE}">selected</c:if>>${index.INDEX_NAME}</option>
	                            </c:forEach>
	                    </select>
                    </div>
                    <div class="searchCondition" >
                        <span>部门： </span>
                   		<select id="DEPT_CODE" name="searchDeptCode">
	                            <option value="">全部</option>
	                            <c:forEach items="${deptList}" var="index" varStatus="vs">
	                                <option value="${index.DEPT_CODE}" <c:if test="${pd.searchDeptCode == index.DEPT_CODE}">selected</c:if>>${index.DEPT_NAME}</option>
	                            </c:forEach>
	                    </select>  
                    </div>
                     <div class="searchCondition">
                        <span>年度： </span>
                        <input class="date-picker" id="searchTime" name="searchTime" 
                            type="text" data-date-format="yyyy" readonly="readonly"/>
                    </div>
                    <div class="searchCondition">
					<a class="btn btn-small btn-info" onclick="toSearch();" 
                          data-parent="#accordion" style="cursor: pointer;">查询</a> 
				</div>
                </div>
                </form>
			<div class="project-list">
				<table class="table table-hover">
					<tbody>
							<th class="project-status">指标</th>
							<th class="project-status">维度</th>
							<th class="project-status">单位</th>
							<th class="project-status">部门</th>
							<th class="project-status">责任人</th>
							<th class="project-status">年度目标</th>
							<th class="project-status">累计已完成</th>
							<th class="project-status">累计完成率</th>
							<th class="project-status">累计同比增幅</th>
						<c:forEach items="${list}" var="list">
							<tr>
								<td class="project-status">
								${list.indexName}
								</td>
								<td class="project-status">
								${list.productName}
								</td>
								<td class="project-status">
								${list.unitName}
								</td>
								<td class="project-status">
								${list.deptName}
								</td>
								<td class="project-status">
								${list.empName}
								</td>
								<td class="project-status">
								<a href="javascript:void(0)" onclick="showMonthWeek('${list.targetCode}')"
	        					data-rel="tooltip" data-placement="left">
	        					<fmt:formatNumber type="number" pattern="#,###.00">${list.targetCount}</fmt:formatNumber></a>
								</td>
								<td class="project-status">
								<fmt:formatNumber type="number" pattern="#,###.00">${list.finishCount}</fmt:formatNumber>
								</td>
								<td class="project-status">
								<fmt:formatNumber type="number" pattern="0.00">${list.finishRate}</fmt:formatNumber>
								%</td>
								<td class="project-status">
								<fmt:formatNumber type="number" pattern="0.00">${list.yearBeforeRate}</fmt:formatNumber>
								%</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		</div>
	</div>
	<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="static/js/bootbox.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
	<script type="text/javascript">
	//检索
    function toSearch(){
    	$("#formTargetDetail").submit();
    }
    function showMonthWeek(code){
    	var empCode = $("#empCode").val();
		siMenu('targetDetailMonthWeek', 'targetDetailMonthWeek', '目标明细页', "summaryTask/goTargetDetailMonthWeek.do?queryEmpCode="+empCode+"&targetCode="+code);
    }
  //打开新的tab页
	function siMenu(id,fid,MENU_NAME,MENU_URL){
		var fmid = "mfwindex";
		var mid = "mfwindex";
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
	}
  	//初始化日期控件
    $('#searchTime').datepicker({
        language:'zh-CN',
        minViewMode: 2,
        maxViewMode: 2,
        startViewMode: 2,
        format: 'yyyy',
        autoclose: true
    });   
	</script>

</body>
</html>
