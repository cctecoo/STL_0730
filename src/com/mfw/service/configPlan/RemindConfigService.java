package com.mfw.service.configPlan;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.system.AccessToken;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.scheduleJob.ScheduleJobService;
import com.mfw.service.system.user.UserService;
import com.mfw.util.Const;
import com.mfw.util.EndPointServer;
import com.mfw.util.Logger;
import com.mfw.util.PageData;
import com.mfw.util.TaskType;
import com.mfw.util.Tools;
import com.mfw.util.WeixinUtil;

/**
 * 报表配置计划Service
 * 
 * @author 作者 白惠文
 * @date 创建时间：2017年5月11日 下午17:11:30
 */
@Service("remindConfigService")
public class RemindConfigService {
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	@Resource(name = "scheduleJobService")
	private ScheduleJobService scheduleJobService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name = "userService")
	private UserService userService;
	
	@Resource
	private CommonService commonService;
	
	private Logger log = Logger.getLogger(this.getClass());
	private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	/**
	 * 修改推送配置信息
	 * 
	 * @param pageData
	 * @return
	 * @throws Exception
	 */
	private void editPlan(PageData pd) throws Exception {
		dao.update("remindConfigMapper.editPlan", pd);
	}

	/**
	 * 新增推送配置信息
	 * 
	 * @param pageData
	 * @return
	 * @throws Exception
	 */
	private void addPlan(PageData pd) throws Exception {
		dao.save("remindConfigMapper.addPlan", pd);
	}

	/**
	 * 保存配置信息
	 * 
	 * @param pageData
	 * @return
	 * @throws Exception
	 */
	public void save(PageData pd) throws Exception {
		PageData pdm = findConfig(pd);
		if (pdm != null) {
			editPlan(pd);
		} else {
			addPlan(pd);
		}
	}

	/**
	 * 查找推送配置信息
	 * 
	 * @param pageData
	 * @return
	 * @throws Exception
	 */
	public PageData findConfig(PageData pd) throws Exception {
		return (PageData) dao.findForObject("remindConfigMapper.findConfig", pd);
	}

	/**
	 * 配置提醒功能
	 * 
	 * @param pageData
	 * @return
	 * @throws Exception
	 */
	public void saveRemind(PageData pd, String viewName) throws Exception {
		PageData pdm = new PageData();
		// 固定参数
		pdm.put("viewName", viewName);
		pdm.put("rule", "1");
		pdm.put("DAYTIME", pd.get("DAILYTIME"));
		if (viewName.equals("cProject")) {
			pdm.put("DAYTIME", pd.get("GROUPREMINDTIME"));
		} else if (viewName.equals("business")) {
			pdm.put("DAYTIME", pd.get("AIMREMINDTIME"));
		} else if (viewName.equals("flow")) {
			pdm.put("DAYTIME", pd.get("FLOWREMINDTIME"));
		} else if (viewName.equals("temp")) {
			pdm.put("DAYTIME", pd.get("TEMPREMINDTIME"));
		}
		
		pdm.put("START_DATE", sdf.format(new Date()));
		pdm.put("END_DATE", sdf.format(new Date()));
		PageData plan = scheduleJobService.findConfigDetail(pdm);
		// 已存在，修改
		if (plan != null) {
			pdm.put("ID", plan.get("ID"));
			scheduleJobService.editPlan(pdm);//config_plan
		}
		// 新增
		else {
			scheduleJobService.addPlan(pdm);
		}
		scheduleJobService.init();
	}

	/**
	 * 根据员工编号查找员工当天日常日清
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findUnTodayDaily(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("remindConfigMapper.findUnTodayDaily", pd);
	}
	
	/**
	 * 根据员工编号查找员工昨天日常日清
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findUnYesterdayDaily(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("remindConfigMapper.findUnYesterdayDaily", pd);
	}

	/**
	 * 查询所有超期的协同工作(活动)
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findUnProjctEvent(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("remindConfigMapper.findUnProjctEvent", pd);
	}

	/**
	 * 查询所有即将超期的目标工作
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findUnBusiness(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("remindConfigMapper.findUnBusiness", pd);
	}

	/**
	 * 查询所有即将超期的临时工作
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findUnTemp(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("remindConfigMapper.findUnTemp", pd);
	}

	/**
	 * 查询所有即将超期的流程工作
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findUnFlow(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("remindConfigMapper.findUnFlow", pd);
	}

	/**
	 * 新增提醒消息记录
	 * 
	 * @param pageData
	 * @return
	 * @throws Exception
	 */
	private void addMsgRecord(PageData pd) throws Exception {
		dao.save("remindConfigMapper.addMsgRecord", pd);
	}

	/**
	 * 检查后台中配置，使用哪种形式发送提醒
	 * 
	 * @param pageData
	 * @return
	 * @return
	 * @throws Exception
	 */
	private PageData checkSendMsgType(PageData plan) throws Exception {
		PageData pd = new PageData();
		String pc = "";
		String weixin = "";
		String mail = "";
		if (plan.get("MESSAGETYPE") != null) {
			String messageType = plan.get("MESSAGETYPE").toString();
			String[] ss = messageType.split(",");
			if (ss.length > 0) {
				for (int i = 0; i < ss.length; i++) {
					if (ss[i].equals("pc")) {
						pc = "pc";
					} else if (ss[i].equals("weixin")) {
						weixin = "weixin";
					} else if (ss[i].equals("mail")) {
						mail = "mail";
					}
				}
			}
		}
		pd.put("pc", pc);
		pd.put("weixin", weixin);
		pd.put("mail", mail);
		return pd;
	}

	/**
	 * 检查是否在规定时间之内
	 * 
	 * @param plan
	 *            配置数据
	 * @param date
	 *            时间
	 * @return yes(在规定时间内)
	 */
	public String checkTime(PageData plan, Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		int weekTime = calendar.get(Calendar.DAY_OF_WEEK);
		String result = "";
		SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
		String nowTime = format.format(date);
		//设定工作日提醒
		if (plan.get("WEEK") != null) {
			String week = plan.get("WEEK").toString();//
			String start = plan.get("STARTTIME").toString();
			String end = plan.get("ENDTIME").toString();
			String[] weekList = week.split(",");
			//判断提醒的时间段
			if (weekList.length > 0) {
				for (int i = 0; i < weekList.length; i++) {
					if (weekTime == Integer.parseInt(weekList[i])) {
						//全天提醒
						if (plan.getString("TIME").equals("all")) {
							result = "yes";
						}
						// 时间类型为时间段的
						if (plan.getString("TIME").equals("other") && (nowTime.compareTo(start) != -1)
								&& (nowTime.compareTo(end) != 1)) {
							result = "yes";
						}
					}
				}
			}
		}
		return result;
	}

	/**
	 * 检查是否选择了该项进行提醒
	 * 
	 * @param plan
	 * @param type
	 * @return
	 */
	public int checkType(PageData plan, TaskType type) {
		int check = 0;
		if (plan.get("TYPE") != null) {
			String ruleType = plan.get("TYPE").toString();
			String[] rule = ruleType.split(",");
			String strType = type.toString();
			if (rule.length > 0) {
				for (int i = 0; i < rule.length; i++) {
					String theRule = rule[i];
					if (theRule.equals(strType)) {
						check = 1;
					}
				}
			}
		}
		return check;
	}

	/**
	 * 保存发送消息记录(多种消息)
	 * 
	 * @param sendMsgEmpName
	 *            发送消息的员工名
	 * @param targetEmpCode
	 *            目标员工编号
	 * @param name
	 *            任务名称，在模板消息中可替换
	 * @param id
	 *            任务ID
	 * @param type
	 *            任务类型
	 * @throws Exception
	 */
	public void saveMessage(String sendMsgEmpName, String targetEmpCode, String work, String id, TaskType type){
		
		try {
			PageData pd = new PageData();
			Properties prop = Tools.loadPropertiesFile("message_tixing.properties");//消息配置
			Properties prop2 = Tools.loadPropertiesFile("config.properties");//系统配置
			String commontTemplateId = prop2.getProperty("TEMPLATE_ID");//默认模板
			// 检查通用的消息发送形式（PC,微信和邮件）
			pd.put("viewName", "daily");
			pd.put("result", "");
			PageData plan = findConfig(pd);
			if (plan != null) {
				pd = checkSendMsgType(plan);//检查后台消息发送方式
				pd.put("TIME", Tools.date2Str(new Date())); // 创建时间
				Date date = new Date();
				String inPlanTime = checkTime(plan, date);//检查是否处于消息提醒时间段内
				int inPlanMsgType = checkType(plan, type);//检查是否在计划消息的类型中
				// 默认使用待办任务模板
				pd.put("template_id", commontTemplateId);
				
				// 根据传入类型更改TYPE，TYPE_NAME和template_id内容
				if (type.equals(TaskType.sendRepairOrder) 
						|| type.equals(TaskType.sendFormWork) || type.equals(TaskType.rejectFormWork)
						|| type.equals(TaskType.sendFormPurchase) || type.equals(TaskType.rejectFormPurchase)
						|| type.equals(TaskType.finishFormPurchase) || type.equals(TaskType.finishFormWork)) {
					//表单类消息
					String typeStr = "";
					if(type.equals(TaskType.sendRepairOrder)){
						typeStr = "维修工单";
					}else if(type.equals(TaskType.sendFormWork) || type.equals(TaskType.rejectFormWork)){
						typeStr = "财务表单";
					}else if(type.equals(TaskType.sendFormPurchase) || type.equals(TaskType.rejectFormPurchase)){
						typeStr = "采购表单";
					}
					pd.put("TYPE", "flow");
					pd.put("keyword1", typeStr);
					inPlanTime = "yes";
					inPlanMsgType = 1;
				} else if (type.equals(TaskType.empPerformanceAssess) ) {
					pd.put("TYPE", "empPerformanceAssess");
					pd.put("keyword1", "月度绩效");
					pd.put("tips", "请在电脑端查看详情");
					inPlanTime = "yes";
					inPlanMsgType = 1;
				}else if(type.equals(TaskType.commitDailyTask)){
					//日常任务-提交
					pd.put("TYPE", "daily");
					pd.put("keyword1", "日常任务");
				}else if (type.equals(TaskType.dailyTaskCheckComplete)) {
					// 日常任务-审核通过
					pd.put("TYPE", "daily");
					pd.put("keyword1", "日常任务");
					pd.put("template_id", prop2.getProperty("checkId"));
					pd.put("result", "审核通过");
				}else if (type.equals(TaskType.dailyTaskReject)) {
					// 日常任务-审核退回
					pd.put("TYPE", "daily");
					pd.put("keyword1", "日常任务");
					pd.put("template_id", prop2.getProperty("checkId"));
					pd.put("result", "审核退回");
				}else if (type.equals(TaskType.dailyTaskRemind)|| type.equals(TaskType.dailyReportRemind)) {
					// 日常任务-超期提醒
					pd.put("TYPE", "daily");
					pd.put("keyword1", "日常任务");
					pd.put("template_id", prop2.getProperty("remindId"));
				}else  if (type.equals(TaskType.cprojectAudit) || type.equals(TaskType.cprojectSign)
						|| type.equals(TaskType.cproject) || type.equals(TaskType.projectAcceptance)
						|| type.equals(TaskType.commitCreativeTask) || type.equals(TaskType.evaluateCreativeTask)) {
					pd.put("TYPE", "cproject");
					pd.put("keyword1", "协同任务");
				}else if (type.equals(TaskType.projectCheckComplete) || type.equals(TaskType.creativeTaskCheckComplete)
						|| type.equals(TaskType.projectAcceptanceCommit)
						|| type.equals(TaskType.evaluateCreativeTaskComplete)) {
					// 协同任务-审核通过
					pd.put("TYPE", "cproject");
					pd.put("keyword1", "协同任务");
					pd.put("template_id", prop2.getProperty("checkId"));
					pd.put("result", "审核通过");
				}else if (type.equals(TaskType.projectReject) || type.equals(TaskType.creativeTaskReject)
						|| type.equals(TaskType.projectAcceptanceUnfinish)) {
					// 协同任务-审核通过
					pd.put("TYPE", "cproject");
					pd.put("keyword1", "协同任务");
					pd.put("template_id", prop2.getProperty("checkId"));
					pd.put("result", "审核退回");
				}else if (type.equals(TaskType.projectTaskRemind) || type.equals(TaskType.projectTaskOver)) {
					// 协同任务-超期提醒
					pd.put("TYPE", "cproject");
					pd.put("keyword1", "协同任务");
					pd.put("template_id", prop2.getProperty("remindId"));
				}else if (type.equals(TaskType.yeartarget) || type.equals(TaskType.yeardepttask)
						|| type.equals(TaskType.monthdepttask) || type.equals(TaskType.bmonthemptarget)
						|| type.equals(TaskType.commitBusinessTask) || type.equals(TaskType.businessTaskCheckComplete)
						|| type.equals(TaskType.businessReject) || type.equals(TaskType.businessTaskOver)
						|| type.equals(TaskType.businessTaskRemind)) {
					pd.put("TYPE", "business");
					pd.put("keyword1", "目标任务");
					// 超期提醒
					if (type.equals(TaskType.businessTaskOver) || type.equals(TaskType.businessTaskRemind)) {
						pd.put("template_id", prop2.getProperty("remindId"));
					}
					// 审核通过
					if (type.equals(TaskType.businessTaskCheckComplete)) {
						pd.put("template_id", prop2.getProperty("checkId"));
						pd.put("result", "审核通过");
					}
					// 审核退回
					else if (type.equals(TaskType.businessReject)) {
						pd.put("template_id", prop2.getProperty("checkId"));
						pd.put("result", "审核退回");
					}
				} else if (type.equals(TaskType.flow) || type.equals(TaskType.passFlow)
						|| type.equals(TaskType.flowReject) || type.equals(TaskType.flowComplete)
						|| type.equals(TaskType.flowOver)) {
					pd.put("TYPE", "flow");
					pd.put("keyword1", "流程任务");
					// 超期提醒
					if (type.equals(TaskType.flowOver)) {
						pd.put("template_id", prop2.getProperty("remindId"));
					}
				}else if (type.equals(TaskType.empDailyTask) || type.equals(TaskType.empDailyTaskAudit)
						|| type.equals(TaskType.empDailyTaskReject) || type.equals(TaskType.commitTempTask)
						|| type.equals(TaskType.commitTempTaskAssess) || type.equals(TaskType.commitTempTaskReject)
						|| type.equals(TaskType.tempTaskOver) || type.equals(TaskType.tempTaskRemind)) {
					pd.put("TYPE", "temp");
					pd.put("keyword1", "临时任务");
					// 超期提醒
					if (type.equals(TaskType.tempTaskOver) || type.equals(TaskType.tempTaskRemind)) {
						pd.put("template_id", prop2.getProperty("remindId"));
					}
					// 审核通过
					if (type.equals(TaskType.empDailyTask) || type.equals(TaskType.commitTempTaskAssess)) {
						pd.put("template_id", prop2.getProperty("checkId"));
						pd.put("result", "审核通过");
					}
					// 审核退回
					else if (type.equals(TaskType.empDailyTaskReject) || type.equals(TaskType.commitTempTaskReject)) {
						pd.put("template_id", prop2.getProperty("checkId"));
						pd.put("result", "审核退回");
					}
				}
				
				//TODO //需要申请审核通过的模板id
				// 默认使用待办任务模板，发送模板报告信息，不同于上面的任务消息
				pd.put("template_id", prop2.getProperty("TEMPLATE_ID"));
				
				// 如果是日常日清工作提交提醒
				if (type.equals(TaskType.dailyTaskRemind)) {
					List<PageData> list = new ArrayList<PageData>();
					list = findUnTodayDaily(pd);
					String strDate = sdf.format(date);
					if (list != null && list.size() > 0) {
						pd.put("STATUS", 1);
						long now = new Date().getTime();
						pd.put("URL", "positionDailyTask/checkAdd.do?timeStamp=" + now);
						pd.put("WORK_NAME", "请于下班前提交" + strDate + "日清报告");
						pd.put("viewName", type.toString());
						pd.put("WORK_ID", id);
						pd.put("WORK", type.toString());
						pd.put("SUBMITTER_NAME", sendMsgEmpName);
						log.info(now + pd.get("WORK_NAME").toString());
						pd.put("keyword2", sendMsgEmpName);
						for (PageData emp : list) {
							pd.put("RECEIVER_CODE", emp.get("EMP_CODE"));
							addMsgRecord(pd);//保存消息记录
							if (inPlanTime.equals("yes") && inPlanMsgType == 1) {
								sendMessageToWeixin(pd, Integer.valueOf(emp.get("ID").toString()));
								EndPointServer.sendMessageNew(sendMsgEmpName, emp.get("EMP_CODE").toString(), type,
										pd);
							}
						}
					}
				}
				// 如果是昨日日报工作提醒
				else if (type.equals(TaskType.dailyReportRemind)) {
					List<PageData> dailyReportList = new ArrayList<PageData>();
					
					List<PageData> empList = new ArrayList<PageData>();
					PageData plan2 = new PageData();
					pd.put("viewName", "dailyReport");
					// 根据报表名称找到配置计划
					plan2 = scheduleJobService.findConfigDetail(pd);
					// 根据计划ID获得相关推送人ID
					empList = scheduleJobService.findEmpByPlanId(plan2);
					if(empList == null || empList.size()<=0){
						PageData empNull = new PageData();
						empNull.put("EMP_ID", "");
						empList.add(empNull);
					}
						
					pd.put("empList", empList);
					
					dailyReportList = findUnYesterdayDaily(pd);
					
					Calendar c = Calendar.getInstance();
					c.add(Calendar.DATE, -1);
					Date yesterdayDate = c.getTime();
					String strDate = sdf.format(yesterdayDate);
					if (dailyReportList != null && dailyReportList.size() > 0) {
						pd.put("STATUS", 1);
						
						pd.put("URL", "positionDailyTask/checkOneDayAdd.do?datetime=" + yesterdayDate);
						pd.put("WORK_NAME", "昨日" + strDate + "日清报告未提交，请及时填写");
						pd.put("viewName", type.toString());
						pd.put("WORK_ID", id);
						pd.put("WORK", type.toString());
						pd.put("SUBMITTER_NAME", sendMsgEmpName);
						log.info(yesterdayDate.getTime() + pd.get("WORK_NAME").toString());
						pd.put("keyword2", sendMsgEmpName);
						for (PageData emp : dailyReportList) {
							pd.put("RECEIVER_CODE", emp.get("EMP_CODE"));
							addMsgRecord(pd);
								sendMessageToWeixin(pd, Integer.valueOf(emp.get("ID").toString()));
								EndPointServer.sendMessageNew(sendMsgEmpName, emp.get("EMP_CODE").toString(), type,
										pd);
						}
					}
				}
				// 协同工作超期/即将超期提醒
				else if (type.equals(TaskType.projectTaskRemind)) {
					List<PageData> list = new ArrayList<PageData>();
					Date dateRes = new Date();
					Calendar cal = new GregorianCalendar();
					cal.setTime(dateRes);
					// 取超期时间（结束时间为昨天）
					cal.add(cal.DATE, -1);
					dateRes = cal.getTime();
					String yesterday = sdf.format(dateRes);
					pd.put("time", yesterday);
					// 取超期的协同工作
					list = findUnProjctEvent(pd);
					if (list.size() > 0) {
						pd.put("STATUS", 1);
						pd.put("URL", "empDailyTask/listTask.do?loadType=C");
						pd.put("viewName", "projectTaskOver");
						pd.put("SUBMITTER_NAME", sendMsgEmpName);
						pd.put("keyword2", sendMsgEmpName);
						inPlanMsgType = checkType(plan, TaskType.projectTaskOver);
						for (PageData emp : list) {
							work = prop.getProperty(Const.WEBSOCKET_MSG_PREFFIX + "projectTaskOver").replace("{name}",
									emp.get("taskName").toString());
							pd.put("WORK_NAME", work);
							pd.put("WORK_ID", emp.get("taskId").toString());
							pd.put("WORK", "projectTaskOver");
							pd.put("RECEIVER_CODE", emp.get("taskEmpCode").toString());
							addMsgRecord(pd);
							if (inPlanTime.equals("yes") && inPlanMsgType == 1) {
								sendMessageToWeixin(pd, Integer.valueOf(emp.get("EMP_ID").toString()));
								EndPointServer.sendMessageNew(sendMsgEmpName, emp.get("taskEmpCode").toString(), type,
										pd);
							}
						}
					}
					
					// 取即将超期的协同
					if (plan.get("GROUPTIME") != null) {
						int time = Integer.valueOf(plan.get("GROUPTIME").toString());
						// 取即将超期的时间
						cal.add(cal.DATE, +time);
						dateRes = cal.getTime();

						String proDate = sdf.format(dateRes);
						pd.put("time", proDate);
						// 取即将超期的协同工作
						list = findUnProjctEvent(pd);
						if (list.size() > 0) {
							pd.put("STATUS", 1);
							pd.put("URL", "empDailyTask/listTask.do?loadType=C");
							pd.put("viewName", type.toString());
							pd.put("SUBMITTER_NAME", sendMsgEmpName);
							pd.put("keyword2", sendMsgEmpName);
							for (PageData emp : list) {
								work = prop.getProperty(Const.WEBSOCKET_MSG_PREFFIX + type.toString()).replace("{name}",
										emp.get("taskName").toString());
								pd.put("WORK_NAME", work);
								pd.put("WORK_ID", emp.get("taskId").toString());
								pd.put("WORK", type.toString());
								pd.put("RECEIVER_CODE", emp.get("taskEmpCode").toString());
								addMsgRecord(pd);
								if (inPlanTime.equals("yes") && inPlanMsgType == 1) {
									sendMessageToWeixin(pd, Integer.valueOf(emp.get("EMP_ID").toString()));
									EndPointServer.sendMessageNew(sendMsgEmpName, emp.get("taskEmpCode").toString(),
											type, pd);
								}
							}
						}
					}
				}
				// 目标工作超期/即将超期提醒
				else if (type.equals(TaskType.businessTaskRemind)) {
					List<PageData> list = new ArrayList<PageData>();
					Date dateRes = new Date();
					Calendar cal = new GregorianCalendar();
					cal.setTime(dateRes);
					// 取超期时间（结束时间为昨天）
					cal.add(cal.DATE, -1);
					dateRes = cal.getTime();
					String yesterday = sdf.format(dateRes);
					pd.put("time", yesterday);
					// 取超期的目标工作
					list = findUnBusiness(pd);
					if (list.size() > 0) {
						pd.put("STATUS", 1);
						pd.put("URL", "empDailyTask/listTask.do?loadType=B");
						pd.put("viewName", "businessTaskOver");
						pd.put("SUBMITTER_NAME", sendMsgEmpName);
						inPlanMsgType = checkType(plan, TaskType.businessTaskOver);
						pd.put("keyword2", sendMsgEmpName);
						for (PageData emp : list) {
							work = prop.getProperty(Const.WEBSOCKET_MSG_PREFFIX + "businessTaskOver").replace("{name}",
									emp.get("taskName").toString());
							pd.put("WORK_NAME", work);
							pd.put("WORK_ID", emp.get("taskId").toString());
							pd.put("WORK", "businessTaskOver");
							pd.put("RECEIVER_CODE", emp.get("taskEmpCode").toString());
							addMsgRecord(pd);
							if (inPlanTime.equals("yes") && inPlanMsgType == 1) {
								sendMessageToWeixin(pd, Integer.valueOf(emp.get("EMP_ID").toString()));
								EndPointServer.sendMessageNew(sendMsgEmpName, emp.get("taskEmpCode").toString(), type,
										pd);
							}
						}
					}
					// 取即将超期的目标
					if (plan.get("AIMTIME") != null) {
						int time = Integer.valueOf(plan.get("AIMTIME").toString());
						// 取即将超期的时间
						cal.add(cal.DATE, +time);
						dateRes = cal.getTime();

						String proDate = sdf.format(dateRes);
						pd.put("time", proDate);
						// 取即将超期的目标工作
						list = findUnBusiness(pd);
						if (list.size() > 0) {
							pd.put("STATUS", 1);
							pd.put("URL", "empDailyTask/listTask.do?loadType=B");
							pd.put("viewName", type.toString());
							pd.put("SUBMITTER_NAME", sendMsgEmpName);
							pd.put("keyword2", sendMsgEmpName);
							for (PageData emp : list) {
								work = prop.getProperty(Const.WEBSOCKET_MSG_PREFFIX + type.toString()).replace("{name}",
										emp.get("taskName").toString());
								pd.put("WORK_NAME", work);
								pd.put("WORK_ID", emp.get("taskId").toString());
								pd.put("WORK", type.toString());
								pd.put("RECEIVER_CODE", emp.get("taskEmpCode").toString());
								addMsgRecord(pd);
								if (inPlanTime.equals("yes") && inPlanMsgType == 1) {
									sendMessageToWeixin(pd, Integer.valueOf(emp.get("EMP_ID").toString()));
									EndPointServer.sendMessageNew(sendMsgEmpName, emp.get("taskEmpCode").toString(),
											type, pd);
								}
							}
						}
					}
				}
				// 流程工作超期提醒
				else if (type.equals(TaskType.flowOver)) {
					List<PageData> list = new ArrayList<PageData>();
					Date dateRes = new Date();
					Calendar cal = new GregorianCalendar();
					if (plan.get("FLOWTIME") != null) {
						int time = Integer.valueOf(plan.get("FLOWTIME").toString());
						// 取即将超期的时间
						cal.add(cal.DATE, -time);
						dateRes = cal.getTime();

						String proDate = sdf.format(dateRes);
						pd.put("time", proDate);
						// 取即将超期的流程工作
						list = findUnFlow(pd);
						if (list.size() > 0) {
							pd.put("STATUS", 1);
							pd.put("URL", "empDailyTask/listTask.do?loadType=F");
							pd.put("viewName", type.toString());
							pd.put("SUBMITTER_NAME", sendMsgEmpName);
							pd.put("keyword2", sendMsgEmpName);
							for (PageData emp : list) {
								work = prop.getProperty(Const.WEBSOCKET_MSG_PREFFIX + type.toString()).replace("{name}",
										emp.get("taskName").toString());
								pd.put("WORK_NAME", work);
								pd.put("WORK_ID", emp.get("taskId").toString());
								pd.put("WORK", type.toString());
								pd.put("RECEIVER_CODE", emp.get("taskEmpCode").toString());
								addMsgRecord(pd);
								if (inPlanTime.equals("yes") && inPlanMsgType == 1) {
									sendMessageToWeixin(pd, Integer.valueOf(emp.get("EMP_ID").toString()));
									EndPointServer.sendMessageNew(sendMsgEmpName, emp.get("taskEmpCode").toString(),
											type, pd);
								}
							}
						}
					}

				}
				// 临时工作超期/即将超期提醒
				else if (type.equals(TaskType.tempTaskRemind)) {
					List<PageData> list = new ArrayList<PageData>();
					Date dateRes = new Date();
					Calendar cal = new GregorianCalendar();
					cal.setTime(dateRes);
					// 取超期时间（结束时间为昨天）
					cal.add(cal.DATE, -1);
					dateRes = cal.getTime();
					String yesterday = sdf.format(dateRes);
					pd.put("time", yesterday);
					// 取超期的临时工作
					list = findUnTemp(pd);
					if (list.size() > 0) {
						pd.put("STATUS", 1);
						pd.put("URL", "empDailyTask/listTask.do?loadType=C");
						pd.put("viewName", "projectTaskOver");
						pd.put("SUBMITTER_NAME", sendMsgEmpName);
						inPlanMsgType = checkType(plan, TaskType.tempTaskOver);
						pd.put("keyword2", sendMsgEmpName);
						for (PageData emp : list) {
							work = prop.getProperty(Const.WEBSOCKET_MSG_PREFFIX + "tempTaskOver").replace("{name}",
									emp.get("taskName").toString());
							pd.put("WORK_NAME", work);
							pd.put("WORK_ID", emp.get("taskId").toString());
							pd.put("WORK", "tempTaskOver");
							pd.put("RECEIVER_CODE", emp.get("taskEmpCode").toString());
							addMsgRecord(pd);
							if (inPlanTime.equals("yes") && inPlanMsgType == 1) {
								sendMessageToWeixin(pd, Integer.valueOf(emp.get("EMP_ID").toString()));
								EndPointServer.sendMessageNew(sendMsgEmpName, emp.get("taskEmpCode").toString(), type,
										pd);
							}
						}
					}
					// 取即将超期的临时工作
					if (plan.get("TEMPTIME") != null) {
						int time = Integer.valueOf(plan.get("TEMPTIME").toString());
						// 取即将超期的时间
						cal.add(cal.DATE, +time);
						dateRes = cal.getTime();

						String proDate = sdf.format(dateRes);
						pd.put("time", proDate);
						// 取即将超期的临时工作
						list = findUnTemp(pd);
						if (list.size() > 0) {
							pd.put("STATUS", 1);
							pd.put("URL", "empDailyTask/listTask.do?loadType=C");
							pd.put("viewName", type.toString());
							pd.put("SUBMITTER_NAME", sendMsgEmpName);
							pd.put("keyword2", sendMsgEmpName);
							for (PageData emp : list) {
								work = prop.getProperty(Const.WEBSOCKET_MSG_PREFFIX + type.toString()).replace("{name}",
										emp.get("taskName").toString());
								pd.put("WORK_NAME", work);
								pd.put("WORK_ID", emp.get("taskId").toString());
								pd.put("WORK", type.toString());
								pd.put("RECEIVER_CODE", emp.get("taskEmpCode").toString());
								addMsgRecord(pd);
								if (inPlanTime.equals("yes") && inPlanMsgType == 1) {
									sendMessageToWeixin(pd, Integer.valueOf(emp.get("EMP_ID").toString()));
									EndPointServer.sendMessageNew(sendMsgEmpName, emp.get("taskEmpCode").toString(),
											type, pd);
								}
							}
						}
					}
				}
				// 其它类型的消息，例如 提交或审核了工作/日清
				else {
					Logger logger = Logger.getLogger(this.getClass());
					String workName = sendMsgEmpName + " "
							+ prop.getProperty(Const.WEBSOCKET_MSG_PREFFIX + type.toString()).replace("{date}", work)
									.replace("{name}", work);
					pd.put("WORK_NAME", workName);
					pd.put("STATUS", 1);
					pd.put("URL", prop.getProperty(Const.WEBSOCKET_URL_PREFFIX + type.toString()));
					pd.put("SUBMITTER_NAME", sendMsgEmpName);
					pd.put("RECEIVER_CODE", targetEmpCode);
					pd.put("EMP_CODE", targetEmpCode);
					PageData emp = employeeService.findByCode(pd);
					emp.put("EMP_ID", emp.get("ID"));
					pd.put("viewName", type.toString());
					pd.put("WORK_ID", id);
					pd.put("WORK", type.toString());
					pd.put("keyword2", sendMsgEmpName);
//					if (pd.get("result") != null) {
//						pd.put("keyword2", pd.get("result"));
//					} else {
//						String strDate = sdf.format(date);
//						pd.put("keyword2", strDate);
//					}
					addMsgRecord(pd);
					logger.info("实际操作：" + workName + "操作人" + targetEmpCode);
					if (inPlanTime.equals("yes") && inPlanMsgType == 1) {
						sendMessageToWeixin(pd, Integer.valueOf(emp.get("EMP_ID").toString()));
						EndPointServer.sendMessageNew(sendMsgEmpName, targetEmpCode, type, pd);
					}
				}
			}
		} catch (Exception e) {
			log.error("发送消息异常", e);
		}
	}

	/**
	 * 发送消息记录(日常工作提报的提醒)
	 * 如果是支持微信消息，则发送微信消息
	 * @param pd
	 * @param emp
	 *            员工信息
	 * @throws Exception
	 */
	private void sendMessageToWeixin(PageData pd, Integer empId) throws Exception {
		
		PageData searchPd = new PageData();
		searchPd.put("EMP_ID", empId);
		PageData pdm = userService.findOpenIdByEmpId(searchPd);
//		InetAddress addr = InetAddress.getLocalHost();
//		String ip = addr.getHostAddress().toString(); // 获取本机ip
//		String hostName = addr.getHostName().toString(); // 获取本机计算机名称
//		log.info("ip=" + ip + "hostName=" + hostName);
		// 获取公众号验证信息
		Properties prop = Tools.loadPropertiesFile("config.properties");
		String appId = prop.getProperty("APPID");
		String appSecret = prop.getProperty("APPSECRET");
		AccessToken token = commonService.getAccessToken(appId, appSecret);
		if (token != null) {
			if (pdm != null && !pdm.get("EMP_NAME").equals("checkFlag") && pdm.get("OPEN_ID") != null
					&& pd.get("template_id") != null) {
				if (pd.get("weixin").equals("weixin")) {
					// 将推送文本框中设定的内容用实际数据代替
					String head = pd.get("WORK_NAME").toString();
					String url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appId + "&redirect_uri="
							+ prop.getProperty("REDIRECT_URI") + "app_login%2flogin_index.do?viewName="
							+ pd.getString("viewName") + "%26record_id=" + pd.get("ID")
							+ "&response_type=code&scope=snsapi_base&state=123#wechat_redirect";
					String tips = "请点击详情进行处理";
					if(pd.containsKey("tips") && !pd.get("tips").toString().isEmpty()){
						tips = pd.getString("tips");
						url = null;//在微信上没有点击链接
					}
					// 推送模板消息
					WeixinUtil.send_template_message(appId, appSecret, pdm.get("OPEN_ID").toString(),
							url, token, 
							pd.get("keyword1").toString(), pd.get("keyword2").toString(), head, tips,
							pd.get("template_id").toString());
					log.info("日清消息" + head);
				}
			}
		}
		/*模板消息
		{head}
		任务名称：{{keyword1}}
		相关人员：{{keyword2}}
		{{desc}}
		 */
	}
}
