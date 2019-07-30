/**
 * 基于zTree v3.5进行封装
 * 使用前请确认页面引入jquery 1.4以上版本和zTree v3.5相关样式文件和脚本文件
 * 当前只适配下拉框内嵌树，仅支持简单JSON数据
 * 
 * setting为zTree全局设置，具体配置请参考zTree v2.6 API文档
 * depts为需要转换为树形结构的JSON数据
 * height/width 树面板的高度/宽度
 * @author wangjinjin
 */
var deptTree;
var deptTreeInner;
//objId和treeId均为树元件ID，为兼容其他人用法，保留
var objId;
var treeId;
var deptEmpFlag = null;
$.fn.deptTree = init;

//初始化树
function init(setting, depts, height, width){
	height = height == null ? 200 : height;
	width = width == null ? 180 : width;
	treeId = setting.treeId ? setting.treeId : "deptTree";
	
	$("#"+treeId).parent().css({
		display: "none",
		position: "absolute",
		overflow: "auto",
		height: height,
		width: width,
		border: "1px solid #CCCCCC",
		left:null,
		top:null
	});
	
	$("#"+treeId).css({
		height: "100%",
		overflow: "auto",
		padding: 0,
		margin: 0
	});
	
	setting.data = {
		key:{
			name:"DEPT_NAME"
		},
		simpleData: {
			enable: true,
			idKey:"ID",
			pIdKey:"PARENT_ID",
			rootPId: 0
		}
	}
	
	//如果设置为多选，则向面板添加确认、重置和取消按钮
	//单选则设置树节点单击事件
	if(setting.view.selectedMulti){
		$("#"+treeId).css("height","85%").after(
			'<div style="text-align: center;padding-top: 5px;border-top: 1px solid #CCCCCC;">'+
				'<input class="btn btn-mini btn-purple" type="button" value="确定" style="width:35px;height:23px;margin-bottom:8px"onclick="selectConfirm()">'+
				'<input class="btn btn-mini btn-purple" type="button" value="重置" style="margin-left: 10px;width:35px;height:23px;margin-bottom:8px" onclick="resetTree()">'+
				'<input class="btn btn-mini btn-purple" type="button" value="取消" style="margin-left: 10px;width:35px;height:23px;margin-bottom:8px" onclick="cancel()">'+
			'</div>'
		);
		if(undefined == setting.callback){
			setting.callback = {
				beforeCheck:beforeCheck
			}
		}else if(!setting.callback.hasOwnProperty("beforeCheck")){
			setting.callback.beforeCheck = beforeCheck;
		}
		if(undefined == setting.callback){
			setting.callback = {
				onCheck:onCheck
			}
		}else if(!setting.callback.hasOwnProperty("onCheck")){
			setting.callback.onCheck = onCheck;
		}
	}else{
		if(undefined == setting.callback || !setting.callback.hasOwnProperty("click")){
			setting.callback = {
				click: deptNodeClick
			};
		}
	}
	deptTree = $.fn.zTree.init($("#"+treeId), setting, depts);
	return deptTree;
}

//向页面body绑定事件，单击页面其他区域隐藏树
$(document).bind("mousedown",function(event){
		if (!(event.target.id == objId
			|| event.target.id.indexOf("deptTreePanel")>=0
				|| $(event.target).parents("#deptTreePanel").length>0
				|| $(event.target).parents("#ysdeptTreePanel").length>0
				|| $(event.target).parents("#bzdeptTreePanel").length>0)) {
			hideDeptTree();
		}
	}
);


/**
 * 显示树形面板，根据触发控件位置确定面板位置
 * @param objId 点击时显示树形控件的元件ID
 */
function showDeptTree(obj) {
	objId = obj.id;
	deptTreeInner = $("#" + objId);
	var objOffset = deptTreeInner.offset();
	$("#"+treeId).parent().slideDown("fast");
};
function hideDeptTree() {
	$("#"+treeId).parent().fadeOut("fast");
};

/**
 * 树节点多选时确认方法
 */
function selectConfirm(){
	var deptCode="";
	var deptName="";
	var nodes = deptTree.getCheckedNodes(true);
	for(var i=0; i<nodes.length;i++){
		deptCode += nodes[i].DEPT_CODE+",";
		deptName += nodes[i].DEPT_NAME+",";
	}
	deptName = deptName.substr(0,deptName.length-1);
	deptCode = deptCode.substr(0,deptCode.length-1);
	deptTreeInner.val(deptName);
	if(deptTreeInner.next()){
		deptTreeInner.next().val(deptCode);
	}
	hideDeptTree();
}

/**
 * 树节点多选时取消方法
 */
function cancel(){
	resetTree();
	if(deptTreeInner.next()){
		if(deptTreeInner.next().val()!=null && deptTreeInner.next().val()!=""){
			var result=deptTreeInner.next().val().split(","); 
			for(var i=0;i<result.length;i++){
				var node = deptTree.getNodeByParam("DEPT_CODE", result[i], null);
				node.checked = true;
				deptTree.updateNode(node);
				if(i == 0){
					if(node.DEPT_SIGN == null)
						deptEmpFlag = 0;//选择了人员
					else
						deptEmpFlag = 1;//选择了部门
				}
			}
		}
	}
	hideDeptTree();
}
/**
 * 树节点多选时重置方法，全部设置为未选
 */
function resetTree(){
	deptTree.checkAllNodes(false);
	deptEmpFlag = null;
	deptTreeInner.val("");
	if(deptTreeInner.next()){
		deptTreeInner.next().val("");
	}
}

/**
 * 树节点单选时点击方法
 */
function deptNodeClick(){
	var dept = deptTree.getSelectedNode();
	deptTreeInner.val(dept.DEPT_NAME);
	if(deptTreeInner.next()){
		deptTreeInner.next().val(dept.ID);
	}
	hideDeptTree();
}

function beforeCheck(treeId, treeNode){
	if(deptEmpFlag == null){
		if(treeNode.DEPT_SIGN == null)
			deptEmpFlag = 0;//如果先选了人员
		else
			deptEmpFlag = 1;//如果先选择了部门
	}else{
		if((treeNode.DEPT_SIGN == null && deptEmpFlag != 0) || (treeNode.DEPT_SIGN != null && deptEmpFlag != 1)){
			top.Dialog.alert("请选择同一级别的数据");
				return false;
		}
	}
	return true;
}

function onCheck(event,treeId, treeNode){
	if(deptTree.getCheckedNodes().length==0)
		deptEmpFlag = null;
}

