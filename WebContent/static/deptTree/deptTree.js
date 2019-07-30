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
var deptTree;
var deptTreeInner;
//objId和treeId均为树元件ID，为兼容其他人用法，保留
var objId;
var treeId;

//用于在class中添加dept-tree的元素显示部门树
$.fn.initDeptTree = function(setting, depts, height, width){
	var appendHtml = '';
	var initDeptId = setting.initDeptId ? setting.initDeptId : '';
	appendHtml += '<input type="hidden" id="EMP_DEPARTMENT_ID" name="EMP_DEPARTMENT_ID" value="' + initDeptId + '"/>' + 
		'<div id="deptTreePanel" style="background-color:white;z-index: 1000;">' + 
		'<ul id="deptTree" class="tree"></ul>';
	$(".dept-tree").after(appendHtml);
	//加载数据
	if(!depts){
		$.post('dept/findDeptTreeNodes.do', function(data){
			var output = data;
			//初始化部门树
			init(setting, output.rows, height, width);
		});
	}else{
		//初始化部门树
		init(setting, depts, height, width);
	}
	objId = $(".dept-tree")[0].id;
	deptTreeInner = $("#" + objId);
	$(".dept-tree").bind('click', function(){
		
		var objOffset = deptTreeInner.offset();
		$("#"+treeId).parent().css({
			//left : objOffset.left + "px", 
			//top : objOffset.top + deptTreeInner.outerHeight() + "px",
			width : deptTreeInner.outerWidth()
		}).slideDown("fast");
	});
}

$.fn.deptTree = init;

//初始化树
function init(setting, depts, height, width){
	height = height == null ? 200 : height;
	width = width == null ? 236 : width;
	treeId = setting.treeId ? setting.treeId : "deptTree";
	parentPos = setting.parentPos ? setting.parentPos : "absolute";
	$("#"+treeId).parent().css({
		display: "none",
		position: parentPos,
		overflow: "auto",
		height: height,
		width: width,
		border: "1px solid #CCCCCC"
	});
	
	$("#"+treeId).css({
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
		$("#"+treeId).css("height","85%").after(
			'<div style="text-align: center;padding-top: 5px;border-top: 1px solid #CCCCCC;">'+
				'<input id="sure" class="btn btn-mini btn-purple" type="button" value="确定" onclick="deptTreeSelectEnd()">'+
				'<input id="reset" class="btn btn-mini btn-purple" type="button" value="重置" style="margin-left: 10px;" onclick="resetDeptTree()">'+
				'<input class="btn btn-mini btn-purple" type="button" value="取消" style="margin-left: 10px;" onclick="hideDeptTree()">'+
			'</div>'
		);
	}else{
		if(undefined == setting.callback || !setting.callback.hasOwnProperty("click")){
			setting.callback = {
				click: deptNodeClick
			};
		}
	}
	deptTree = $("#"+treeId).zTree(setting, depts);
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
	$("#"+treeId).parent().css({
		//left : objOffset.left + "px", 
		//top : objOffset.top + deptTreeInner.outerHeight() + "px",
		width : deptTreeInner.outerWidth()
	}).slideDown("fast");
};
function hideDeptTree() {
	$("#"+treeId).parent().fadeOut("fast");
};


/**
 * 显示树形面板，根据触发控件位置确定面板位置
 * @param objId 点击时显示树形控件的元件ID
 * 同一页面多个地方需要显示树的时候，需增加treeIdNew确定显示哪个树
 */
/*function showDeptTreeMulti(obj,treeIdNew) {
	treeId = treeIdNew;
	objId = obj.id;
	deptTreeInner = $("#" + objId);
	var objOffset = deptTreeInner.offset();
	$("#"+treeId).parent().css({
		left : objOffset.left + "px", 
		top : objOffset.top + deptTreeInner.outerHeight() + "px"
	}).slideDown("fast");
};*/

/**
 * 树节点多选时确认方法
 */
function deptTreeSelectEnd() {
	var nodes = deptTree.getCheckedNodes();
	var values = "";
	var texts = "";
	var codes = "";
	for(var i = 0; i < nodes.length; i++){
		values += nodes[i].ID + ",";
		texts += nodes[i].DEPT_NAME + ",";
		codes += nodes[i].DEPT_CODE + ",";
	}
	values = values.substring(0,values.length - 1);
	texts = texts.substring(0,texts.length - 1);
	codes = codes.substring(0,codes.length - 1);
	
	deptTreeInner.val(texts);
	if(deptTreeInner.next()){
		deptTreeInner.next().val(values);
	}
	if(deptTreeInner.next().next()){
		deptTreeInner.next().next().val(codes);
	}
	hideDeptTree();
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

/**
 * 重置树节点状态，全部设置为未选择
 */
function resetDeptTree(){
	deptTree.checkAllNodes(false);
}