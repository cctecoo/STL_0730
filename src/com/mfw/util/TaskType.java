package com.mfw.util;

/**
 * WebSocket使用，表示提示的任务类型
 * @author 李伟涛
 *
 */
public enum TaskType {

	/**
	 * 年度经营目标
	 */
	yeartarget,
	/**
	 * 部门年度经营目标
	 */
	yeardepttask,
	/**
	 * 部门月度经营目标
	 */
	monthdepttask,
	/**
	 * 员工月度经营目标
	 */
	bmonthemptarget,
	/**
	 * 目标工作即将超期
	 */
	businessTaskRemind,
	/**
	 * 目标工作超期
	 */
	businessTaskOver,
	
	
	/**
	 * 协同工作即将超期
	 */
	projectTaskRemind,
	/**
	 * 协同工作超期
	 */
	projectTaskOver,
	/**
	 * 重点协同项目
	 */
	cproject,
	/**
	 * 创新项目审核
	 */
	cprojectAudit,

	/**
	 * 创新项目会签
	 */
	cprojectSign,
	/**
	 * 重点协同项目通过
	 */
	projectCheckComplete,
	/**
	 * 重点协同项目退回
	 */
	projectReject,
	/**
	 * 重点协同项目节点
	 */
	cprojectNode,
	/**
	 * 重点协同项目活动
	 */
	cprojectEvent, 
	/**
	 * 重点协同项目开始验收
	 */
	projectAcceptance,
	/**
	 * 重点协同项目验收通过
	 */
	projectAcceptanceCommit,
	/**
	 * 重点协同项目验收不通过
	 */
	projectAcceptanceUnfinish,
	
	
	/**
	 * 流程工作
	 */
	flow, 
	/**
	 * 流程工作转交
	 */
	passFlow, 
	/**
	 * 流程工作退回
	 */
	flowReject, 
	/**
	 * 流程工作完成
	 */
	flowComplete, 
	/**
	 * 流程工作超期
	 */
	flowOver, 
	/**
	 * 关注流程
	 */
	flowFocus, 
	
	
	/**
	 * 临时工作
	 */
	empDailyTask, 
	/**
	 * 临时工作申请审核
	 */
	empDailyTaskAudit,
	/**
	 * 临时工作申请被退回
	 */
	empDailyTaskReject,
	
	
	/**
	 * 目标工作日清提报
	 */
	commitBusinessTask,
	/**
	 *	重点协同工作日清提报
	 */
	commitCreativeTask,
	/**
	 * 日常工作日清提报
	 */
	commitDailyTask,
	/**
	 * 临时工作日清提报
	 */
	commitTempTask,
	
	
	/**
	 * 临时工作评价
	 */
	commitTempTaskAssess,
	/**
	 * 提交的临时工作日清被退回
	 */
	commitTempTaskReject,
	/**
	 * 临时工作超期
	 */
	tempTaskOver,
	/**
	 * 临时工作即将超期
	 */
	tempTaskRemind,
	
	/**
	 * 目标工作日清审核完毕
	 */
	businessTaskCheckComplete,
	/**
	 *目标工作日清被退回
	 */
	businessReject,	
	/**
	 * 重点协同工作日清审核完毕
	 */
	creativeTaskCheckComplete,
	/**
	 * 重点协同工作日清被退回
	 */
	creativeTaskReject,
	/**
	 * 日常工作审核完毕
	 */
	dailyTaskCheckComplete,
	
	/**
	 * 审核日常工作
	 */
	dailyTaskAssessComplete,
	/**
	 * 日常工作日清退回
	 */
	dailyTaskReject,
	/**
	 * 日常工作日清未提交提醒
	 */
	dailyTaskRemind,
	
	/**
	 * 任务数量统计刷新指令
	 */
	REFRESH_COMMAND,
	
	
	/**
	 * 下发文件
	 */
	sendFile,
	/**
	 * 共享文件
	 */
	shareFile, 
	/**
	 * 评价协同工作
	 */		
	evaluateCreativeTask,
	/**
	 * 评价了协同工作
	 */	
	evaluateCreativeTaskComplete,
	
	/**
	 * 转交工作单
	 */
	sendRepairOrder,
	/**
	 * 退回工作单
	 */
	rejectRepairOrder,
	/**
	 * 完成工作单
	 */
	finishRepairOrder,
	
	/**
	 * 昨日日报未提交提醒
	 */
	dailyReportRemind,
	
	/**
	 * 转交表单工作
	 */
	sendFormWork,
	/**
	 * 退回表单工作
	 */
	rejectFormWork,
	/**
	 * 完成表单
	 */
	finishFormWork,
	
	/**
	 * 转交采购表单
	 */
	sendFormPurchase,
	/**
	 * 退回采购表单
	 */
	rejectFormPurchase,
	/**
	 * 完成采购表单
	 */
	finishFormPurchase,
	
	/**
	 * 月度绩效评价
	 */
	empPerformanceAssess,
	
	/**
	 * 系统公告
	 */
	sysNotice
}
