package com.mfw.service.app;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.system.AccessToken;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.configPlan.RemindRecordService;
import com.mfw.service.scheduleJob.ScheduleJobService;
import com.mfw.service.system.datarole.DataRoleService;
import com.mfw.service.system.user.UserService;
import com.mfw.util.Const;
import com.mfw.util.DateUtil;
import com.mfw.util.PageData;
import com.mfw.util.Tools;
import com.mfw.util.WeixinUtil;


/**
 * app报表用Service
 * @author  作者  白惠文
 * @date 创建时间：2017年5月4日 上午10:02:29
 */
@Service("appService")
public class AppService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	@Resource
	private CommonService commonService;
	@Resource
	private ScheduleJobService scheduleJobService;
	@Resource
	private UserService userService;
	@Resource
	private EmployeeService employeeService;

	@Resource
	private DataRoleService dataRoleService;
	@Resource
	private DeptService deptService;
	@Resource
	private RemindRecordService remindRecordService;
	private static final  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
	private static final  SimpleDateFormat sdt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 

	/*
	 * 获取每个产品的统计数据
	 */
	public List<PageData> getEveryProduct(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("AppMapper.getEveryProduct", pd);
	}

	/*
	 * 获取所有产品的统计数据之和
	 */
	public PageData getAllProduct(PageData pd) throws Exception {
		return (PageData) dao.findForObject("AppMapper.getAllProduct", pd);
	}
	/*
	 * 获取日常任务提交情况
	 */
	
	//@SuppressWarnings("unchecked")
	public List<PageData> getEmployee(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("AppMapper.getAllEmployee", pd);
	}
	/*
	 * 获取超期计划
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> getTimeout(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("AppMapper.getTimeout", pd);
		}
    public void Timeout_history(List<PageData> addList) throws Exception {
        dao.save("AppMapper.Timeout_history", addList);
    }
	@SuppressWarnings("unchecked")
	public List<PageData> getTimeout_history(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("AppMapper.getTimeout_history", pd);
		}

	/*
	 * 获取周积分排名
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> getWeeklysummary(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("AppMapper.getWeeklysummary", pd);
		}
	
	/**
	 * 发送销售分析
	 * 
	 * @throws Exception
	 */
	public void sendChart() throws Exception {
		PageData pd = new PageData();
		PageData pdm = new PageData();
		List<PageData> empList = new ArrayList<PageData>();
		PageData plan = new PageData();
		String actual_count = "";
		String actual_money = "";
		Properties prop = Tools.loadPropertiesFile("config.properties");
		pd.put("viewName", "chart");
		pd.put("EMP_NAME", "checkFlag");
		// 根据报表名称找到配置计划
		plan = scheduleJobService.findConfigDetail(pd);
		// 根据计划ID获得相关推送人ID
		empList = scheduleJobService.findEmpByPlanId(plan);
		// 根据发送数据类型获得具体日期
		Date dateRes = dealDate(plan);
		pd.put("date", dateRes);
		// 获取统计数据
		pdm = getAllProduct(pd);
		if (pdm != null) {
			actual_count = pdm.get("actual_count").toString();
			actual_money = pdm.get("actual_money").toString();
		}
		// 获取公众号验证信息
		String appId = prop.getProperty("APPID");
		String appSecret = prop.getProperty("APPSECRET");
		AccessToken token = commonService.getAccessToken(appId, appSecret);
		if (token != null) {
			// 遍历接收消息人并发送消息
			for (PageData emp : empList) {
				pd = userService.findOpenIdByEmpId(emp);
				if (pd != null && !pd.get("EMP_NAME").equals("checkFlag") && pd.get("OPEN_ID") != null) {
					// 将推送文本框中设定的内容用实际数据代替
					String remark = plan.get("MODEL").toString().replace("{user}", pd.getString("EMP_NAME"))
							.replace("{duty}", pd.getString("EMP_GRADE_NAME")).replace("{sales}", actual_count)
							.replace("{salesAmount}", actual_money);

					// 推送模板消息
					WeixinUtil.send_template_message_new(appId, appSecret,
							pd.get("OPEN_ID").toString(),
							"https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appId
									+ "&redirect_uri=" + prop.getProperty("REDIRECT_URI")
									+ "app_login%2flogin_index.do?viewName=chart%26selectDate=" + dateRes
									+ "&response_type=code&scope=snsapi_base&state=123#wechat_redirect",
							"销售分析消息", remark, prop.getProperty("reportId"), token);

					System.out.println("\n报告！" + pd.get("EMP_NAME").toString() + ",您有一条销售分析信息待查看\n销售总量:" + actual_count
							+ "吨\n销售金额:" + actual_money + "万元\n");

					// System.out.println("\n" + remark + "\n");
				}
			}
		}
	}

	/**
	 * 发送排名
	 * 
	 * @throws Exception
	 */
	public void sendRanking() throws Exception {
		PageData pd = new PageData();
		List<PageData> list = new ArrayList<PageData>();
		List<PageData> rankList = new ArrayList<PageData>();
		PageData plan = new PageData();
		String first = "";
		String second = "";
		String third = "";
		Properties prop = Tools.loadPropertiesFile("config.properties");
		pd.put("viewName", "ranking");
		pd.put("EMP_NAME", "checkFlag");
		// 根据报表名称找到配置计划
		plan = scheduleJobService.findConfigDetail(pd);
		// 根据计划ID获得相关推送人ID
		list = scheduleJobService.findEmpByPlanId(plan);
		// 根据发送数据类型获得具体日期
		Date nowDate = new Date();
		Date dateRes = dealDate(plan);
		pd.put("date", dateRes);
		// 获取排名数据
		rankList = commonService.getScore(pd);
		if (rankList != null) {
			if (rankList.size() > 0) {
				first = rankList.get(0).get("EMP_DEPARTMENT_NAME").toString();
			}
			if (rankList.size() > 1) {
				second = rankList.get(1).get("EMP_DEPARTMENT_NAME").toString();
			}
			if (rankList.size() > 2) {
				third = rankList.get(2).get("EMP_DEPARTMENT_NAME").toString();
			}
		}
		// 获取公众号验证信息
		String appId = prop.getProperty("APPID");
		String appSecret = prop.getProperty("APPSECRET");
		AccessToken token = commonService.getAccessToken(appId, appSecret);
		if (token != null) {
			// 遍历接收消息人并发送消息
			for (PageData emp : list) {
				pd = userService.findOpenIdByEmpId(emp);
				if (pd != null && !pd.get("EMP_NAME").equals("checkFlag") && pd.get("OPEN_ID") != null) {
					// 将推送文本框中设定的内容用实际数据代替
					String remark = plan.get("MODEL").toString().replace("{user}", pd.getString("EMP_NAME"))
							.replace("{duty}", pd.getString("EMP_GRADE_NAME")).replace("{first}", first)
							.replace("{second}", second).replace("{third}", third);

					// 推送模板消息
					WeixinUtil.send_template_message_new(appId, appSecret,
							pd.get("OPEN_ID").toString(),
							"https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appId
									+ "&redirect_uri=" + prop.getProperty("REDIRECT_URI")
									+ "app_login%2flogin_index.do?viewName=ranking%26selectDate=" + dateRes
									+ "&response_type=code&scope=snsapi_base&state=123#wechat_redirect",
							"排名消息", remark, prop.getProperty("reportId"), token);
					System.out.println("\n报告！" + pd.get("EMP_NAME").toString() + ",您有一条排名信息待查看\n状元:" + first + ",榜眼:"
							+ second + ",探花:" + third + "\n");
					// System.out.println("\n" + remark + "\n");
				}
			}
		}
	}

	/**
	 * 处理时间
	 * 
	 * @throws Exception
	 */
	public Date dealDate(PageData pd) throws Exception {
		Date dateRes = new Date();
		if(pd.get("nowDate")!=null)
		{
			dateRes = (Date) pd.get("nowDate");
		}
		Calendar cal = new GregorianCalendar();
		cal.setTime(dateRes);
		// 如果取昨天时间
		if(pd.get("DATA_TYPE")!=null)
		{
			if (pd.get("DATA_TYPE").toString().equals("2")) {
				cal.add(cal.DATE, -1);
				dateRes = cal.getTime();
			}
			// 如果取本周（周日）时间
	        else if (pd.get("DATA_TYPE").toString().equals("3")) {
				cal.add(Calendar.DAY_OF_WEEK, 7);
				dateRes = cal.getTime();
			}
			// 如果取上周（周日）时间
			else if (pd.get("DATA_TYPE").toString().equals("4")) {
				cal.add(Calendar.DAY_OF_WEEK, 7);
				cal.add(cal.DATE, -7);
				dateRes = cal.getTime();
			}
			// 如果取本月(最后一天)时间
			else if (pd.get("DATA_TYPE").toString().equals("5")) {
				cal.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONDAY), cal.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
				cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
				dateRes = cal.getTime();
			}
			// 如果取上月(最后一天)时间
			else if (pd.get("DATA_TYPE").toString().equals("6")) {
				cal.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONDAY), cal.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
				cal.add(cal.MONTH, -1);
				cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));			
				dateRes = cal.getTime();
			}
		}
		return dateRes;
	}

	/**
	 * 生成签名之前必须先了解一下jsapi_ticket，jsapi_ticket是公众号用于调用微信JS接口的临时票据。
	 * 由于获取jsapi_ticket的api调用次数非常有限，频繁刷新jsapi_ticket会导致api调用受限，影响自身业务。
	 * jsapi_ticket的有效期为7200秒，通过access_token来获取。 开发者必须在自己的服务全局缓存jsapi_ticket
	 * 
	 * @throws FileNotFoundException
	 *  
	 */
	public String getTicket(AccessToken access_token) {
		String jsapi_ticket = "";
		try {
			Properties prop = Tools.loadPropertiesFile("config.properties");
			String timestamp = prop.getProperty("ticketTime");
			// 判断是否有效
			Long now = Long.parseLong(String.valueOf(System.currentTimeMillis()).substring(0, 10))
					- Long.parseLong(timestamp);
			if (now > 7200) {
				// 无效重新获取并写入
				jsapi_ticket = WeixinUtil.getTicket(access_token);
				String filePath = Tools.getClassPath();
				filePath = filePath.trim() + "config.properties";
				InputStream fis = new FileInputStream(filePath);
				prop.load(fis);
				prop.setProperty("ticket", jsapi_ticket);
				prop.setProperty("ticketTime", String.valueOf(System.currentTimeMillis()).substring(0, 10));
				FileOutputStream oFile = new FileOutputStream(filePath);
				prop.store(oFile, "Copyright (c) Seven");
				oFile.close();

				// FileOutputStream fos = new FileOutputStream(String.valueOf(Thread.currentThread().getContextClassLoader().getResource("")));
				// 将Properties集合保存到流中
				// prop.store(fos, "Copyright (c) Seven");
				// fos.close();// 关闭流
			} else {
				jsapi_ticket = prop.getProperty("ticket");
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return jsapi_ticket;
	}
	
	
	
	/**
	 * 根据viewName找到相关页面
	 * 
	 * @throws Exception
	 */	
	public ModelAndView findPage(PageData pd){
		ModelAndView mv = new ModelAndView();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		PageData plan = new PageData();
		PageData pdm = new PageData();
		Date dateRes = new Date();
		plan.put("viewName", session.getAttribute("viewName"));
		String viewName = session.getAttribute("viewName").toString();
		try {
			if(pd.get("selectDate") != null){
				dateRes = (Date) pd.get("selectDate");
			}else{
				plan = scheduleJobService.findConfigDetail(plan);
				if(plan !=null){
					dateRes = dealDate(plan);					
				}
			}
		    pd.put("date", dateRes);
			//如果是五类工作提醒，点击后更新相关历史消息为已读
			if(pd.get("record_id")!=null){				
				pdm.put("ID", Integer.valueOf(pd.get("record_id").toString()));
				pdm.put("status", 2);
				remindRecordService.editRecord(pdm);
				pdm = remindRecordService.findRecordById(pdm);
			}
			//如果是排名情况
			if(viewName.equals("ranking")){
				List<PageData> list = new ArrayList<PageData>();
				list= commonService.getScore(pd);
				if(list != null && list.size() != 0){
					if(list.size()>0){							
						mv.addObject("first",(list.get(0)!=null)?list.get(0):"");
					}
					if(list.size()>1){
						mv.addObject("second",(list.get(1)!=null)?list.get(1):"");
					}
					if(list.size()>2){
						mv.addObject("third",(list.get(2)!=null)?list.get(2):"");
					}							
					mv.addObject("list", list);
				}
				mv.setViewName("app/chart/ranking");
				return mv;
			}
			//如果是销售分析
			if(viewName.equals("chart")){
				List<PageData> list = new ArrayList<PageData>();
				list= getEveryProduct(pd);
				pd = getAllProduct(pd);
				if(pd !=null){
					mv.addObject("allProduct",pd);
				}
				if(list !=null){
					mv.addObject("everyProduct",list);
				}									
				mv.setViewName("app/chart/chart");
				return mv;
			}
			//如果是日常任务提交情况
			if(viewName.equals("report")){
				User user = (User) session.getAttribute(Const.SESSION_USER);
				List<PageData> deptList = deptService.listWithAuth(user);
				List<String> deptIds = new ArrayList<String>();
				PageData pdd = new PageData();
				for (int i=0;i<deptList.size();i++){
					deptIds.add(deptList.get(i).get("ID").toString()+" ");
				}
			    pdd.put("deptList", deptIds);
				pdd.put("DATE", pd.get("selectStrDate"));
				List<PageData> result = getEmployee(pdd);
				PageData sumNum = getEmployeeCount(pdd);
				mv.addObject("result",result);
				mv.addObject("sumNum",sumNum);
				mv.setViewName("app/chart/report");
				return mv;
		    }
			//如果是各类任务超期情况
			if(viewName.equals("timeout")){   
				User user = (User) session.getAttribute(Const.SESSION_USER);
				List<PageData> foundlist = new ArrayList<PageData>();
				PageData pdm1 = new PageData();
				List<PageData> deptList = deptService.listWithAuth(user);
				List<String> deptIds = new ArrayList<String>();
				for (int i=0;i<deptList.size();i++){
					deptIds.add(deptList.get(i).get("ID").toString()+" ");
				}
				//发送人的部门ID
				pdm1.put("SEND_DEPT_ID", deptIds);
				if(null!=pd.get("selectStrDate")){
				  pdm1.put("DATE",  pd.get("selectStrDate"));
				}
				else{ 
				 SimpleDateFormat dataformat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		    	 String datestr = dataformat.format(new Date());
		    	 pdm1.put("DATE",datestr);
				}
				//从历史表中取出超期数据
				foundlist = getTimeout_history(pdm1);
				mv.addObject("list", foundlist);
				mv.setViewName("app/chart/timeout");
				return mv;
			}	
			//如果是周积分排名情况
			if(viewName.equals("weeklysummary")){       
				PageData searchParam = new PageData();
				PageData userPd = new PageData();
				userPd.put("USERNAME", getUser().getUSERNAME());
				String name =userPd.get("USERNAME")+"";
				if(!"admin".equals(name)){
					userPd.put("DeptId", getUser().getDeptId());
					String deptID =  userPd.get("DeptId")+"";
					List<PageData> deptList1 = deptService.getAllSonDepts(deptID);
					if(deptList1!=null&&deptList1.size()>0){
						List<String> deptIds = new ArrayList<String>();
						for (int i=0;i<deptList1.size();i++){
							deptIds.add(deptList1.get(i).get("ID").toString());
						}
						searchParam.put("deptList1", deptIds);
					}   
					/*Date date1= new Date();
					pd.put("selectStrDat",date1);
					String selectStrDate = sdt.format(date1);
					pd.put("selectStrDate", selectStrDate);*/   
					//灰色字段验证时间减七天方法是否可行
					if(null!=pd.get("selectStrDate")){
					    searchParam.put("DATE",pd.get("selectStrDate"));
					    Date date = sdt.parse((String) searchParam.get("DATE"));
					    pd.put("date", date);
					    Calendar cal = new GregorianCalendar();
						cal.setTime(date);
						cal.add(cal.DATE, -7);
						dateRes = cal.getTime();
					    String a = sdt.format(dateRes);
					    String b = a.substring(0, 19);
					    searchParam.put("DATES",b);
					}else {
				    	 SimpleDateFormat dataformat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
				    	 String datestr = dataformat.format(new Date());
				    	 searchParam.put("DATE",datestr);
				    	 String a  = DateUtil.getAfterDayDate("-7");
				    	 searchParam.put("DATES",a);
				    }
					List<PageData> scoreList = getWeeklysummary(searchParam);
					mv.addObject("scoreList", scoreList); 
					mv.setViewName("app/chart/weeklysummary");
					return mv;
				}
			}
			//如果是未提交或审核日常日清
			if(viewName.equals("projectTaskRemind")
					||viewName.equals("projectTaskOver")
					||viewName.equals("creativeTaskReject")
					||viewName.equals("creativeTaskCheckComplete")
					||viewName.equals("evaluateCreativeTaskComplete")
					||viewName.equals("flow")
					||viewName.equals("passFlow")
					||viewName.equals("flowReject")
					||viewName.equals("flowComplete")
					||viewName.equals("flowOver")
					||viewName.equals("businessTaskCheckComplete")
					||viewName.equals("businessReject")
					||viewName.equals("businessTaskOver")
					||viewName.equals("businessTaskRemind")
					||viewName.equals("tempTaskOver")
					||viewName.equals("tempTaskRemind")
					||viewName.equals("commitTempTaskAssess")
					||viewName.equals("commitTempTaskReject")){
				User user = (User) session.getAttribute(Const.SESSION_USER);
				String empCode = user.getNUMBER();
				List<PageData> productList = new ArrayList<PageData>();//产品列表
				List<PageData> projectList = new ArrayList<PageData>();//项目列表


				//默认加载目标工作
				if(null == pd.get("loadType")){
					pd.put("loadType", Const.TASK_TYPE_B);
				}
				//如果是协同工作
				if(viewName.equals("projectTaskRemind")
						||viewName.equals("projectTaskOver")
						||viewName.equals("creativeTaskReject")
						||viewName.equals("creativeTaskCheckComplete")
						||viewName.equals("evaluateCreativeTaskComplete")){
					pd.put("loadType", Const.TASK_TYPE_C);
				}
				//如果是流程工作
				else if(viewName.equals("flow")
						||viewName.equals("passFlow")
						||viewName.equals("flowReject")
						||viewName.equals("flowComplete")
						||viewName.equals("flowOver")){
					pd.put("loadType", Const.TASK_TYPE_F);
				}
				//如果是日常工作
				else if(viewName.equals("dailyTaskRemind")
						||viewName.equals("dailyTaskCheckComplete")
						||viewName.equals("dailyTaskReject"))
				{
					pd.put("loadType", Const.TASK_TYPE_D);
				}else if(viewName.equals("tempTaskOver")
						||viewName.equals("tempTaskRemind")
						||viewName.equals("commitTempTaskAssess")
						||viewName.equals("commitTempTaskReject"))
				{
					pd.put("loadType", Const.TASK_TYPE_T);
				}
				//如果审核通过了
				if(viewName.equals("dailyTaskCheckComplete")
						||viewName.equals("creativeTaskCheckComplete")						
						||viewName.equals("evaluateCreativeTaskComplete")
						||viewName.equals("businessTaskCheckComplete")
						||viewName.equals("flowComplete")
						||viewName.equals("commitTempTaskAssess")
						||viewName.equals("commitTempTaskReject"))
				{
					pd.put("wxStatus", "ended");
				}
				
				pd.put("empCode", empCode);
				//返回当前登陆员工编码
				pd.put("currentUser", user.getNUMBER());
				mv.addObject("pd", pd);
				// 查询员工是否可以添加日常工作
				pd.put("EMP_CODE", user.getNUMBER());

				mv.setViewName("app/task/taskList");				
				return mv;
			}
			//如果是提交了日清
			if(viewName.equals("commitCreativeTask")
					||viewName.equals("evaluateCreativeTask")
					||viewName.equals("commitBusinessTask")
					||viewName.equals("commitTempTask")){
				User user = (User) session.getAttribute(Const.SESSION_USER);
				String empCode = user.getNUMBER();
				List<PageData> productList = new ArrayList<PageData>();//产品列表
				List<PageData> projectList = new ArrayList<PageData>();//项目列表

				//默认加载目标工作
				if(null == pd.get("loadType")){
					pd.put("loadType", Const.TASK_TYPE_B);
				}
				if(viewName.equals("commitCreativeTask")
						||viewName.equals("evaluateCreativeTask")){
					pd.put("loadType", Const.TASK_TYPE_C);
				}else if(viewName.equals("commitDailyTask")){
					pd.put("loadType", Const.TASK_TYPE_D);
				}else if(viewName.equals("commitTempTask")){
					pd.put("loadType", Const.TASK_TYPE_T);
				}
				//表示领导查看的日清看板
				pd.put("showDept", 1);

				//查询是否领导，1为领导，0为普通员工
				PageData userPd = new PageData();
				userPd.put("USERNAME", user.getUSERNAME());
				int count = commonService.checkLeader(userPd);

				//查询当前员工可以查看的部门列表
				List<PageData> deptList = dataRoleService.findByUser(user.getUSER_ID());
				//查询当前员工的岗位等级
				PageData empPositionLevel = employeeService.findPositionByEmpCode(user.getNUMBER());
				pd.put("positionLevel", empPositionLevel.get("JOB_RANK"));
					
				String deptIdStr = "";//用于页面上选择部门时查询员工
				String deptCodeStr = "";//用于查询所有部门下的员工周工作
				if(count==0){//普通员工
					//普通员工只能查看本部门员工的工作
					pd.put("readTask", 1);
					//普通员工，配置了不显示部门工作为N,则不展示部门其它员工工作
					if( null != empPositionLevel && "N".equals(empPositionLevel.getString("IS_SHOW_DEPT_WORK")) ){
						pd.put("IS_SHOW_DEPT_WORK", empPositionLevel.getString("IS_SHOW_DEPT_WORK"));
					}else{
						//把当前员工的部门添加到部门列表中
						PageData deptPd = new PageData();
						deptPd.put("ID", user.getDeptId());
						PageData empDeptpd = deptService.findById(deptPd);
						if(null == empDeptpd){
							pd.put("selfDept", "none");
							mv.addObject("pd", pd);
							return mv;
						}
						empDeptpd.put("DEPT_ID", deptPd.get("ID"));
						deptList = new ArrayList<PageData>();
						deptList.add(empDeptpd);
						pd.put("selfDeptCode", empDeptpd.get("DEPT_CODE"));
						mv.addObject("deptList", deptList);
					}
				}else{//领导
					mv.addObject("selfEmpCode", user.getNUMBER());
						
					//配有部门数据权限的
					if(deptList.size()>0){
						for(PageData dept : deptList){
							deptIdStr += "," + dept.get("DEPT_ID");
							deptCodeStr += "," + "'" + dept.getString("DEPT_CODE") + "'";
						}
						deptIdStr = deptIdStr.substring(1);
						deptCodeStr = "(" + deptCodeStr.substring(1) + ")";
					
						pd.put("deptCodeStr", deptCodeStr);
						pd.put("deptIdStr", deptIdStr);
						mv.addObject("deptList", deptList);
					}else{
						//把当前员工的部门添加到部门列表中
						PageData deptPd = new PageData();
						deptPd.put("ID", user.getDeptId());
						PageData empDeptpd = deptService.findById(deptPd);
						if(null == empDeptpd){
							pd.put("selfDept", "none");
							mv.addObject("pd", pd);
							return mv;
						}
						empDeptpd.put("DEPT_ID", deptPd.get("ID"));
						deptList = new ArrayList<PageData>();
						deptList.add(empDeptpd);
						pd.put("deptCode", empDeptpd.get("DEPT_CODE"));
						mv.addObject("deptList", deptList);
					}
				}
				//查询页面显示的部门员工列表
				List<Integer> deptIdList = new ArrayList<Integer>();
				if(null == pd.get("deptCode") || pd.get("deptCode").toString().isEmpty()){//没有选择部门
					if(deptList.size()>0){
						for(PageData dept : deptList){
							deptIdList.add(Integer.valueOf(dept.get("DEPT_ID").toString()));
						}
					}
				}else{//已选部门
					for(PageData dept : deptList){
						if(dept.getString("DEPT_CODE").equals(pd.getString("deptCode"))){
							deptIdList.add(Integer.valueOf(dept.get("DEPT_ID").toString()));
							break;
						}
					}
				}
				if(deptIdList.size()>0){
					List<PageData> empList = employeeService.findEmpByDeptIds(deptIdList);
					mv.addObject("empList", empList);
				}
				pd.put("checkEmpCode", user.getNUMBER());
				pd.put("currentUser", user.getNUMBER());
				mv.addObject("pd", pd);
				return mv;
			} 
			//临时任务审核结果查看
			if(viewName.equals("empDailyTask")
					||viewName.equals("empDailyTaskReject")){
		    	User user = (User) session.getAttribute(Const.SESSION_USER);
				pd.put("USERNAME", user.getUSERNAME());
				if(viewName.equals("empDailyTask")){
					pd.put("ended", "ended");
				}			
				int count = 0;
				try {
					count = commonService.checkLeader(pd);
					PageData empAndGradeInfo = employeeService.findEmpAndGradeInfoByEmpcode(user.getNUMBER());
					if(null != empAndGradeInfo){
						//判断岗位等级是否高于部长
						String jobRank = empAndGradeInfo.get("JOB_RANK").toString();
						if(Integer.parseInt(jobRank)<4){//部长等级为4，岗位等级越小级别越高
							mv.addObject("superior", "Y");
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				mv.addObject("count", count);
				mv.addObject("pd", pd);
		    	mv.setViewName("app/temp/appTempWorkIssued");
		    	return mv;
			}
			//临时任务审核
			if(viewName.equals("empDailyTaskAudit")){
		    	mv.setViewName("app/temp/appTempWorkCheck");
		    	return mv;
			}else if(viewName.equals("dailyTaskReject")
					||viewName.equals("cprojectAudit")
					||viewName.equals("cprojectSign")
					||viewName.equals("projectCheckComplete")
					||viewName.equals("projectReject")
					||viewName.equals("cproject")
					||viewName.equals("projectAcceptance")
					||viewName.equals("projectAcceptanceCommit")
					||viewName.equals("projectAcceptanceUnfinish")
					||viewName.equals("yeartarget")
					||viewName.equals("yeardepttask")
					||viewName.equals("monthdepttask")
					||viewName.equals("bmonthemptarget")
					||viewName.equals("develop")
			){
				mv.setViewName("app/login/working");
				return mv;
			}else if(viewName.equals("commitDailyTask")
					||viewName.equals("dailyTaskCheckComplete")){
				String url = "redirect:/app_task/goDailyInfo.do?manageId="+pdm.getString("WORK_ID")+"&show=3";
				mv = new ModelAndView(url);
				return mv;
			}else if(viewName.equals("dailyTaskRemind")||viewName.equals("dailyReportRemind")){
				String url = "redirect:/app_task/add.do?fromPage=dailyTaskReport&show=2&parentPage=gridTask&loadType=D";
				mv = new ModelAndView(url);
				return mv;
			}else if(viewName.equals("remindRecord")){
				String url = "redirect:/app_remindRecord/list.do";
				mv = new ModelAndView(url);
				return mv;
			}else if(viewName.equals("myRanking")){
				String url = "redirect:/app_remindRecord/myRanking.do";
				mv = new ModelAndView(url);
				return mv;
			}else if(viewName.equals("sendFormWork") || viewName.equals("rejectFormWork") || viewName.equals("finishFormWork")){
				//财务表单
				String url = "redirect:/app_task/toFormFlowList.do";
				mv = new ModelAndView(url);
				return mv;
			}else if(viewName.equals("sendFormPurchase") || viewName.equals("rejectFormPurchase") || viewName.equals("finishFormPurchase")){
				//采购表单
				String url = "redirect:/app_task/toPurchaseFormList.do";
				mv = new ModelAndView(url);
				return mv;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("app/index");
		return mv;
	}
	/*提取用户信息*/
	private User getUser() {
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		User user = (User)session.getAttribute(Const.SESSION_USER);
		return user;
	}

	public ModelAndView go(PageData pd)
	{
		ModelAndView mv = new ModelAndView();
		return mv;
	}

	
	/**
	 * 发送日常任务提交情况
	 * 
	 * @throws Exception
	 */
	public void sendReport() throws Exception {
		PageData pd = new PageData();
		PageData pdd = new PageData();
		Date date = new Date();
		//时间由当前时间变为取前一天 20171201 sulj
		Calendar dateNew = Calendar.getInstance();
		dateNew.setTime(date);
		dateNew.set(Calendar.DATE, dateNew.get(Calendar.DATE) - 1);
		
		List<PageData> empList = new ArrayList<PageData>();
		String strDate = sdf.format(dateNew.getTime());
		PageData plan = new PageData();
		// java配置文件，表达配置信息
		Properties prop = Tools.loadPropertiesFile("config.properties");
		pd.put("viewName", "report");
		pd.put("EMP_NAME", "checkFlag");
		// 根据报表名称找到配置计划
		plan = scheduleJobService.findConfigDetail(pd);
		// 根据计划ID获得相关推送人ID
		empList = scheduleJobService.findEmpByPlanId(plan);
		// 根据发送数据类型获得具体日期
		Date dateRes = dealDate(plan);
		pd.put("date", dateRes);
		// 获取统计数据
		pdd.put("date", strDate);
		// 获取公众号验证信息
		String appId = prop.getProperty("APPID");
		String appSecret = prop.getProperty("APPSECRET");
		AccessToken token = commonService.getAccessToken(appId, appSecret);
		if (token != null) {
			// 遍历接收消息人并发送消息
			for (PageData emp : empList) {
				pd = userService.findOpenIdByEmpId(emp);
				if (pd != null && !pd.get("EMP_NAME").equals("checkFlag") && pd.get("OPEN_ID") != null) {
					// 将推送文本框中设定的内容用实际数据代替
					String remark = plan.get("MODEL").toString().replace("{duty}", pd.getString("EMP_DEPARTMENT_NAME"))
							.replace("{date}", pdd.getString("date"));
					// 推送模板消息
					WeixinUtil.send_template_message_new(appId, appSecret,
							pd.get("OPEN_ID").toString(),
							"https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appId
									+ "&redirect_uri=" + prop.getProperty("REDIRECT_URI")
									+ "app_login%2flogin_index.do?viewName=report%26selectStrDate=" + strDate
									+ "&response_type=code&scope=snsapi_base&state=123#wechat_redirect",
							"日清日报提交情况", remark, prop.getProperty("reportId"), token);

					System.out.println("\n您好！请查看" + pd.get("EMP_DEPARTMENT_NAME").toString() + strDate + ",日常任务提交情况\n");

					// System.out.println("\n" + remark + "\n");
				}
			}
		}
	}

	/**
	 * 发送超期任务情况
	 * 
	 * @throws Exception
	 */
	public void sendTimeout() throws Exception {
		User user = new User();
		List<PageData> list = new ArrayList<PageData>();
		List<String> deptIds = new ArrayList<String>();
		PageData pdf = new PageData();
		PageData pd = new PageData();
		Date date = new Date();
		String strDate = sdt.format(date);
		String strDater = sdf.format(date);
		List<PageData> empList = new ArrayList<PageData>();
		PageData plan = new PageData();
		Properties prop = Tools.loadPropertiesFile("config.properties");
		pd.put("viewName", "timeout");
		pd.put("EMP_NAME", "checkFlag");
		// 根据报表名称找到配置计划
		plan = scheduleJobService.findConfigDetail(pd);
		// 根据计划ID获得相关推送人ID
		empList = scheduleJobService.findEmpByPlanId(plan);
		// 根据发送数据类型获得具体日期
		Date dateRes = dealDate(plan);
		pd.put("date", dateRes);
		pdf.put("date", strDater);
		// 获取公众号验证信息
		String appId = prop.getProperty("APPID");
		String appSecret = prop.getProperty("APPSECRET");
		AccessToken token = commonService.getAccessToken(appId, appSecret);
		if (token != null) {
			// 遍历接收消息人并发送消息
			for (PageData emp : empList) {
				pd = userService.findOpenIdByEmpId(emp);
				if (pd != null && !pd.get("EMP_NAME").equals("checkFlag") && pd.get("OPEN_ID") != null) {
					// 将推送文本框中设定的内容用实际数据代替
					user.setDeptId(Integer.parseInt(pd.get("deptId") + ""));
					user.setUSER_ID(pd.get("USER_ID") + "");
					List<PageData> deptList = deptService.listWithAuth(user);
					for (int i = 0; i < deptList.size(); i++) {
						deptIds.add(deptList.get(i).get("ID").toString() + " ");
					}
					SimpleDateFormat dataformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					String datestq = dataformat.format(new Date());
					pd.put("DATE", datestq);
					pd.put("deptList", deptIds);
					list = getTimeout(pd);
					String remark = plan.get("MODEL").toString().replace("{duty}", pd.getString("EMP_DEPARTMENT_NAME"))
							.replace("{date}", pdf.getString("date"));
					// 推送模板消息
					WeixinUtil.send_template_message_new(appId, appSecret,
							pd.get("OPEN_ID").toString(),
							"https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appId
									+ "&redirect_uri=" + prop.getProperty("REDIRECT_URI")
									+ "app_login%2flogin_index.do?viewName=timeout%26selectStrDate=" + datestq
									+ "&response_type=code&scope=snsapi_base&state=123#wechat_redirect",
							"各类工作超期情况", remark, prop.getProperty("reportId"), token);
					System.out.println("\n您好！请查看" + pd.get("EMP_DEPARTMENT_NAME").toString() + strDate + ",各类工作超期情况\n");
					// System.out.println("\n" + remark + "\n");
				}
			}
			Timeout_history(list);
		}
	}

	/**
	 * 发送周积分排名情况
	 * 
	 * @throws Exception
	 */
	public void sendWeeklysummary() throws Exception {
		PageData pd = new PageData();
		PageData pde = new PageData();
		PageData pds = new PageData();
		Date date = new Date();
		String strDate = sdt.format(date);
		String strDater = sdf.format(date);
		String a = DateUtil.getAfterDayDate("-7");
		String strDates = a.substring(0, 10);
		List<PageData> empList = new ArrayList<PageData>();
		PageData plan = new PageData();
		Properties prop = Tools.loadPropertiesFile("config.properties");
		pd.put("viewName", "weeklysummary");
		pd.put("EMP_NAME", "checkFlag");
		// 根据报表名称找到配置计划
		plan = scheduleJobService.findConfigDetail(pd);
		// 根据计划ID获得相关推送人ID
		empList = scheduleJobService.findEmpByPlanId(plan);
		// 根据发送数据类型获得具体日期
		Date dateRes = dealDate(plan);
		pd.put("date", dateRes);
		pde.put("date", strDater);
		pds.put("dates", strDates);
		// 获取公众号验证信息
		String appId = prop.getProperty("APPID");
		String appSecret = prop.getProperty("APPSECRET");
		AccessToken token = commonService.getAccessToken(appId, appSecret);
		if (token != null) {
			// 遍历接收消息人并发送消息
			for (PageData emp : empList) {
				pd = userService.findOpenIdByEmpId(emp);
				if (pd != null && !pd.get("EMP_NAME").equals("checkFlag") && pd.get("OPEN_ID") != null) {
					// 将推送文本框中设定的内容用实际数据代替
					String remark = plan.get("MODEL").toString().replace("{duty}", pd.getString("EMP_DEPARTMENT_NAME"))
							.replace("{date}", pde.getString("date")).replace("{dates}", pds.getString("dates"));
					// 推送模板消息
					WeixinUtil.send_template_message_new(appId, appSecret,
							pd.get("OPEN_ID").toString(),
							"https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appId
									+ "&redirect_uri=" + prop.getProperty("REDIRECT_URI")
									+ "app_login%2flogin_index.do?viewName=weeklysummary%26selectStrDate=" + strDate
									+ "&response_type=code&scope=snsapi_base&state=123#wechat_redirect",
							"周积分消息", remark, prop.getProperty("reportId"), token);
					System.out.println("\n您好！请查看" + pd.get("EMP_DEPARTMENT_NAME").toString() + strDates + "——"
							+ strDater + ",周积分报表\n");
					// System.out.println("\n" + remark + "\n");
				}
			}
		}
	}

	public PageData getEmployeeCount(PageData pd) throws Exception {
		return (PageData) dao.findForObject("AppMapper.getAllEmployeeCount", pd);
	}
}
