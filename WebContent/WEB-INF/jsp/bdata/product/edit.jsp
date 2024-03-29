<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
	<head>
		<base href="<%=basePath%>">
		<%@ include file="../../system/admin/top.jsp"%> 
		<script type="text/javascript">
			$(function(){
				top.changeui();
				findParentProduct();
				
			})
			
			//保存
			function save(){
				var productSelectedType = $("#productType").val();
				if('SHCH'==productSelectedType){//生产类
					var parentCode = $("#relateSaleProductCode option:selected").attr("parentCode");
					$("#parentProductCode").val(parentCode);
				}else{
					var parentCode = $("#parentProduct").val();
					$("#parentProductCode").val(parentCode);
				}
				$("#form1").submit();
				$("#zhongxin").hide();
				$("#zhongxin2").show();
			}
			
			function changeNumber(objTxt){
				objTxt.value=objTxt.value.replace(/\D/g,'');
			}
			
			function checkCode(){
				if($("#productCode").val()==""||trimStr($("#productCode").val())==""){
					$("#productCode").tips({
						side:3,
			            msg:'请输入',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#productCode").focus();
					return false;
				}
				if($("#productName").val()==""){
					$("#productName").tips({
						side:3,
			            msg:'请输入',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#productName").focus();
					return false;
				}
				if($("#productType").val()==""){
					$("#productType").tips({
						side:3,
			            msg:'请选择',
			            bg:'#AE81FF',
			            time:2
			        });
					$("#productType").focus();
					return false;
				}
				
				var productCode = $("#productCode").val();
				var id = $("#id").val();
				top.jzts();
				var url = "<%=basePath%>/product/checkCode.do?productCode="+productCode+"&id="+id;
				$.get(
					"<%=basePath%>/product/checkCode.do?productCode="+productCode+"&id="+id,
					function(data){
						if(data=="0"){
							$("#codetip").attr("hidden", true);
							save();
						}else{
							$("#codetip").attr("hidden", false);
							$("#productCode").tips({
								side:3,
					            msg:'编码已存在',
					            bg:'#AE81FF',
					            time:2
					        });
							$("#productCode").focus();
							return false;
				        }
					}
				);
			}
			
			function trimStr(str){
				return str.replace(/(^\s*)|(\s*$)/g,"");
			}
			
			//选择产品类型后加载产品大类
			function findParentProduct(){
				$("#parentProduct").empty();
				$("#relateSaleProductCode").empty();
				//选择销售则不显示关联销售的行;如果选择生产则显示关联销售行,
				var productSelectedType = $("#productType").val();
				if('SHCH'==productSelectedType){//生产类
					$("#isParentTr").hide();
					$("#parentProductTr").hide();
					$("#relateSaleProductTr").show();
					findSaleProduct();
					return;
				}else{//非生产类
					$("#isParentTr").show();
					$("#parentProductTr").show();
					$("#relateSaleProductTr").hide();
				}
				
				//加载大系产品
				$.ajax({
					url:'<%=basePath%>product/findParentProduct.do?type=' + $("#productType").val(),
					type:'post',
					dataType:'json',
					success:function(data){
						var proList = data;
						var appendStr = '';
						appendStr +=  '<option value="">请选择</option>';
						$.each(proList, function(i, pro){
							appendStr +=  '<option value="' + pro.PRODUCT_CODE + '"';
							if(pro.PRODUCT_CODE=='${pd.PARENT_PRODUCT_CODE}'){
								appendStr += 'selected';
							}
							appendStr +='>' + pro.PRODUCT_NAME + '</option>';
						});
						$("#parentProduct").append(appendStr);
						$("#parentProduct option[value='${pd.PARENT_PRODUCT_CODE }']").attr("selected","selected");
					}
				});
			}
			
			//加载销售类产品
			function findSaleProduct(){
				$.ajax({
					url: '<%=basePath%>product/findByType.do',
					type: 'post',
					data: {type: 'XSH'},
					success: function(data){
						var proList = data;
						var appendStr = '';
						appendStr +=  '<option value="">请选择</option>';
						$.each(proList, function(i, pro){
							appendStr +=  '<option value="' + pro.PRODUCT_CODE + '"';
							if(pro.PRODUCT_CODE=='${pd.RELATE_SALE_PRODUCT_CODE}'){
								appendStr += 'selected';
							}
							if('undefined'==pro.PARENT_PRODUCT_CODE || null ==pro.PARENT_PRODUCT_CODE){
								pro.PARENT_PRODUCT_CODE = '';
							}
							appendStr +=' parentCode="' + pro.PARENT_PRODUCT_CODE + '">' + pro.PRODUCT_NAME + '</option>';
						});
						$("#relateSaleProductCode").append(appendStr);
						$("#relateSaleProductCode option[value='${pd.RELATE_SALE_PRODUCT_CODE }']").attr("selected","selected");
					}
				});
			}
		</script>
		<style>
			#zhongxin td{height:40px;}
	        #zhongxin td label{text-align:right; margin-right:10px;}
	        .need{color: red;}
	        input[type="checkbox"],input[type="radio"] {
				opacity:1 ;
				position: static;
				margin-bottom:8px;
			}
		</style>
	</head>
	<body>
		<form action="product/edit.do" name="form1" id="form1"  method="post">
			<input type="hidden" name="id" id="id" value="${pd.ID}" />
			<div id="zhongxin" align="center" style="margin-top:20px;">
			<table>
				<tr>
					<td><label><span class="need">*</span>产品编码：</label></td>
					<td><input type="text" name="productCode" maxlength="20" id="productCode" placeholder="这里输入产品编码" title="产品编码" value="${pd.PRODUCT_CODE }"/></td>
				</tr>
				<tr>
					<td><label><span class="need">*</span>产品名称：</label></td>
					<td><input type="text" name="productName" maxlength="50" id="productName" placeholder="这里输入产品名称" title="产品名称" value="${pd.PRODUCT_NAME }"/></td>
				</tr>
				<tr>
                    <td><label><span class="need">*</span>产品类型：</label></td>
                    <td>
                        <select id="productType" name="productType" onchange="findParentProduct();">
                        	<option value="">请选择</option>
                            <c:if test="${productType != null}">
                                <c:forEach items="${productType}" var="type">
                                    <option value="${type.BIANMA }" <c:if test="${pd.PRODUCT_TYPE == type.BIANMA }">selected</c:if> >${type.NAME}</option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </td>
                </tr>
                <tr id="parentProductTr">
                    <td><label>所在产品大系：</label></td>
                    <td>
                    	<input type="hidden" id="parentProductCode" name="parentProductCode" value="" />
                    	<select id="parentProduct" >
                        </select>
                    </td>
                </tr>
                <tr id="relateSaleProductTr">
                    <td><label>关联销售产品：</label></td>
                    <td>
                    	<select id="relateSaleProductCode" name="relateSaleProductCode">
                        </select>
                    </td>
                </tr>
                <tr id="isParentTr">
                    <td><label><span class="need">*</span>是否为产品大系：</label></td>
                    <td>
                    	<input type="radio" id="isParentProduct" name="isParentProduct" value="1" <c:if test="${pd.IS_PARENT_PRODUCT==1 }">checked</c:if> >是
                    	<input type="radio" id="isParentProduct" name="isParentProduct" value="0" <c:if test="${pd.IS_PARENT_PRODUCT==0 }">checked</c:if> >否
                    </td>
                </tr>
				<tr>
					<td><label>尺寸：</label></td>
					<td>	
						<input type="text" name="productSize" maxlength="50" id="productSize" placeholder="这里输入产品尺寸" title="产品尺寸" value="${pd.SIZE }"/>
					</td>
				</tr>
				
				<tr>
					<td><label>生产材料：</label></td>
					<td>
						<input type="text" name="material" id="material" maxlength="100" placeholder="这里输入生产材料" title="生产材料" value="${pd.MATERIAL }"/>
					</td>
				</tr>
				<tr>
					<td><label>产品描述：</label></td>
					<td><input type="text" name="descp" id="descp" maxlength="255" placeholder="这里输入产品描述" title="描述" value="${pd.DESCP }"></td>
				</tr>
			
				<tr>
				
					<td colspan="2" style="text-align: center;">
						<a class="btn btn-mini btn-primary" onclick="checkCode();">保存</a>
						<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
					</td>
				</tr>
			</table>
			</div>
		</form>
	
		<div id="zhongxin2" class="center" style="display:none">
			<img src="static/images/jzx.gif" style="width: 50px;" /><br/>
			<h4 class="lighter block green"></h4>
		</div>
		
	</body>
</html>