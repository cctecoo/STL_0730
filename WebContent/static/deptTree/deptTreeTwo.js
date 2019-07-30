/**
 * 基于zTree v2.6进行封装
 * 使用前请确认页面引入jquery 1.4以上版本和zTree v2.6相关样式文件和脚本文件
 * 当前只适配下拉框内嵌树，仅支持简单JSON数据
 * 
 * setting为zTree全局设置，具体配置请参考zTree v2.6 API文档
 * depts为需要转换为树形结构的JSON数据
 * height/width 树面板的高度/宽度
 * @author liweitao
 */
var deptTreeTwo;
var deptTreeInnerTwo;
//objId和treeId均为树元件ID，为兼容其他人用法，保留
var objIdTwo;
var treeIdTwo;

$.fn.deptTreeTwo = function(setting, depts, height, width){
	height = height == null ? 200 : height;
	width = width == null ? 236 : width;
	treeIdTwo = setting.treeId ? setting.treeId : "deptTree";
	
	$("#"+treeIdTwo).parent().css({
		display: "none",
		position: "absolute",
		overflow: "auto",
		height: height,
		width: width,
		border: "1px solid #CCCCCC"
	});
	
	$("#"+treeIdTwo).css({
		height: "100%",
		overflow: "auto",
		padding: 0,
		margin: 0
	});
	
	setting.isSimpleData = true;
	setting.treeNodeKey = "ID";
	setting.treeNodeParentKey = "PARENT_ID";
	setting.nameCol = "DEPT_NAME";
	
	//如果设置为多选，则向面板添加确认、重置和取消按钮
	//单选则设置树节点单击事件
	if(setting.checkable){
		$("#"+treeIdTwo).css("height","85%").after(
			'<div style="text-align: center;padding-top: 5px;border-top: 1px solid #CCCCCC;">'+
				'<input class="btn btn-mini btn-purple" type="button" value="确定" onclick="deptTreeSelectEndTwo()">'+
				'<input class="btn btn-mini btn-purple" type="button" value="重置" style="margin-left: 10px;" onclick="resetDeptTreeTwo()">'+
				'<input class="btn btn-mini btn-purple" type="button" value="取消" style="margin-left: 10px;" onclick="hideDeptTreeTwo()">'+
			'</div>'
		);
	}else{
		if(undefined == setting.callback || !setting.callback.hasOwnProperty("click")){
			setting.callback = {
				click: deptNodeClickTwo
			};
		}
	}
	deptTreeTwo = $("#"+treeIdTwo).zTree(setting, depts);
	return deptTreeTwo;
}

//向页面body绑定事件，单击页面其他区域隐藏树
$(document).bind("mousedown",function(event){
		if (!(event.target.id == objIdTwo
			|| event.target.id.indexOf("deptTreePanel")>=0
				|| $(event.target).parents("#deptTreePanel").length>0
				|| $(event.target).parents("#ysdeptTreePanel").length>0
				|| $(event.target).parents("#bzdeptTreePanel").length>0)) {
			hideDeptTreeTwo();
		}
	}
);


/**
 * 显示树形面板，根据触发控件位置确定面板位置
 * @param objIdTwo 点击时显示树形控件的元件ID
 */
function showDeptTreeTwo(obj) {
	objIdTwo = obj.id;
	deptTreeInnerTwo = $("#" + objIdTwo);
	var objOffset = deptTreeInnerTwo.offset();
	$("#"+treeIdTwo).parent().css({
		left : objOffset.left + "px", 
		top : objOffset.top + deptTreeInnerTwo.outerHeight() + "px"
	}).slideDown("fast");
};
function hideDeptTreeTwo() {
	$("#"+treeIdTwo).parent().fadeOut("fast");
};


/**
 * 树节点多选时确认方法
 */
function deptTreeSelectEndTwo() {
	var nodes = deptTreeTwo.getCheckedNodes();
	var values = "";
	var texts = "";
	for(var i = 0; i < nodes.length; i++){
		values += nodes[i].ID + ",";
		texts += nodes[i].DEPT_NAME + ",";
	}
	values = values.substring(0,values.length - 1);
	texts = texts.substring(0,texts.length - 1);
	
	deptTreeInnerTwo.val(texts);
	if(deptTreeInnerTwo.next()){
		deptTreeInnerTwo.next().val(values);
	}
	hideDeptTree();
}

/**
 * 树节点单选时点击方法
 */
function deptNodeClickTwo(){
	var dept = deptTreeTwo.getSelectedNode();
	deptTreeInnerTwo.val(dept.DEPT_NAME);
	if(deptTreeInnerTwo.next()){
		deptTreeInnerTwo.next().val(dept.ID);
	}
	hideDeptTreeTwo();
}

/**
 * 重置树节点状态，全部设置为未选择
 */
function resetDeptTreeTwo(){
	deptTreeTwo.checkAllNodes(false);
}