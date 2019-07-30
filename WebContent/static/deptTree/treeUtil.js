/**
 * 基于zTree v2.6进行封装
 * 使用前请确认页面引入jquery 1.4以上版本和zTree v2.6相关样式文件和脚本文件
 * 当前只适配下拉框内嵌树，仅支持简单JSON数据
 * 
 * setting为zTree全局设置，具体配置请参考zTree v2.6 API文档
 * list为需要转换为树形结构的JSON数据
 * height/width 树面板的高度/宽度
 * @author yuyazhou
 */
var haierTree;
var haierTreeInner;
//objId和treeId均为树元件ID，为兼容其他人用法，保留
var objId;
var treeId;

//objValue节点上的主键ID,CODE等，objName节点显示的名字
var objKey,objValue,objName;

$.fn.haierTree = function(setting, list, height, width){
	height = height == null ? 200 : height;
	width = width == null ? 236 : width;
	treeId = setting.treeId ? setting.treeId : "haierTree";
	
	$("#"+treeId).parent().css({
		display: "none",
		position: "absolute",
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
	
	objKey = setting.treeNodeKey ? setting.treeNodeKey : "ID";
	objValue = setting.treeNodeValue ? setting.treeNodeValue : "CODE";
	objName = setting.nameCol ? setting.nameCol : "NAME";
	
	//如果设置为多选，则向面板添加确认、重置和取消按钮
	//单选则设置树节点单击事件
	if(setting.checkable){
		$("#"+treeId).css("height","85%").after(
			'<div style="text-align: center;padding-top: 5px;border-top: 1px solid #CCCCCC;">'+
				'<input class="btn btn-mini btn-purple" type="button" value="确定" onclick="haierTreeSelectEnd()">'+
				'<input class="btn btn-mini btn-purple" type="button" value="重置" style="margin-left: 10px;" onclick="resetHaierTree()">'+
				'<input class="btn btn-mini btn-purple" type="button" value="取消" style="margin-left: 10px;" onclick="hideHaierTree()">'+
			'</div>'
		);
	}else{
		if(undefined == setting.callback || !setting.callback.hasOwnProperty("click")){
			setting.callback = {
				click: treeNodeClick
			};
		}
	}
	haierTree = $("#"+treeId).zTree(setting, list);
	return haierTree;
}

//向页面body绑定事件，单击页面其他区域隐藏树
$(document).bind("mousedown",function(event){
		if (!(event.target.id == objId
			|| event.target.id.indexOf("haierTreePanel")>=0
				|| $(event.target).parents("#haierTreePanel").length>0
				|| $(event.target).parents("#haierTreePanelTwo").length>0)) {
			hideHaierTree();
		}
	}
);


/**
 * 显示树形面板，根据触发控件位置确定面板位置
 * @param objId 点击时显示树形控件的元件ID
 */
function showHaierTree(obj) {
	objId = obj.id;
	haierTreeInner = $("#" + objId);
	var objOffset = haierTreeInner.offset();
	$("#"+treeId).parent().css({
		left : objOffset.left + "px", 
		top : objOffset.top + haierTreeInner.outerHeight() + "px"
	}).slideDown("fast");
};
function hideHaierTree() {
	$("#"+treeId).parent().fadeOut("fast");
};


/**
 * 树节点多选时确认方法
 */
function haierTreeSelectEnd() {
	var nodes = haierTree.getCheckedNodes();
	var values = "";
	var texts = "";
	for(var i = 0; i < nodes.length; i++){
		var obj = nodes[i];
		values += eval("obj."+objValue) + ",";
		texts += eval("obj."+objName) + ",";
	}
	values = values.substring(0,values.length - 1);
	texts = texts.substring(0,texts.length - 1);
	
	haierTreeInner.val(texts);
	if(haierTreeInner.next()){
		haierTreeInner.next().val(values);
	}
	hideHaierTree();
}

/**
 * 树节点单选时点击方法
 */
function treeNodeClick(){
	var obj = haierTree.getSelectedNode();
	haierTreeInner.val(eval("obj."+objName));
	if(haierTreeInner.next()){
		haierTreeInner.next().val(eval("obj."+objValue));
	}
	hideHaierTree();
}

/**
 * 重置树节点状态，全部设置为未选择
 */
function resetHaierTree(){
	haierTree.checkAllNodes(false);
}