package com.mfw.controller.system.login;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.session.InvalidSessionException;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.Menu;
import com.mfw.entity.system.Role;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.EmployeeTrainService;
import com.mfw.service.bdata.PositionDutyService;
import com.mfw.service.bdata.ShowDataService;
import com.mfw.service.configPlan.RemindRecordService;

import com.mfw.service.system.datarole.DataRoleService;
import com.mfw.service.system.menu.MenuService;
import com.mfw.service.system.role.RoleService;
import com.mfw.service.system.user.UserService;
import com.mfw.util.AppUtil;
import com.mfw.util.Const;
import com.mfw.util.PageData;
import com.mfw.util.RightsHelper;
import com.mfw.util.Tools;

import net.sf.json.JSONObject;

/**
 * 总入口、登录
 * @author  作者 蒋世平
 * @date 创建时间：2015年4月28日 下午16:27:19
 */
@Controller
public class LoginController extends BaseController {

	@Resource(name = "userService")
	private UserService userService;
	@Resource(name = "menuService")
	private MenuService menuService;
	@Resource(name = "roleService")
	private RoleService roleService;
	@Resource(name = "positionDutyService")
	private PositionDutyService positionDutyService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "showDataService")
	private ShowDataService showDataService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;

	@Resource(name="dataroleService")
	private DataRoleService dataroleService;
	@Resource(name = "employeeTrainService")
	private EmployeeTrainService employeeTrainService;
	@Resource(name = "remindRecordService")
	private RemindRecordService remindRecordService;
	
	/**
	 * 获取登录用户的IP
	 * 
	 * @throws Exception
	 */
	public void getRemortIP(String USERNAME) throws Exception {
		PageData pd = new PageData();
		HttpServletRequest request = this.getRequest();
		String ip = "";
		if (request.getHeader("x-forwarded-for") == null) {
			ip = request.getRemoteAddr();
		} else {
			ip = request.getHeader("x-forwarded-for");
		}
		pd.put("USERNAME", USERNAME);
		pd.put("IP", ip);
		userService.saveIP(pd);
	}

	/**
	 * 访问登录页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/login_toLogin")
	public ModelAndView toLogin() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		pd.put("SYSNAME", Tools.readTxtFile(Const.SYSNAME)); // 读取系统名称
		mv.setViewName("system/admin/login");
		mv.addObject("pd", pd);
		return mv;
	}

	/**
	 * 请求登录，验证用户
	 */
	@RequestMapping(value = "/login_login")
	@ResponseBody
	public Object login(String username, String password) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		PageData pd = this.getPageData();
		String errInfo = "";

		Subject currentUser = SecurityUtils.getSubject();
		if (currentUser.isAuthenticated()) {
			currentUser.logout();
		}
		Session session = currentUser.getSession();
		//用用户名+密码去验证
		pd.put("USERNAME", username);
		pd.put("PASSWORD",
				new SimpleHash("SHA-1", username, password).toString());
		pd = userService.getUserByNameAndPwd(pd);
		if(null == pd){//再次用员工编号+密码去验证
			pd = new PageData();
			pd.put("NUMBER", username);
			pd = userService.findByUN(pd);
			if(null != pd){
				username = pd.getString("USERNAME");
				String inputPwd = new SimpleHash("SHA-1", pd.getString("USERNAME"), password).toString();
				if(!pd.getString("PASSWORD").equals(inputPwd)){
					pd = null;
				}
			}
		}
		//用户验证通过则设置用户信息到shiro的session
		if (pd != null && pd.get("ENABLED").toString().equals("1")) {
			userService.updateLastLogin(pd);

			User user = new User();
			user.setUSER_ID(pd.getString("USER_ID"));
			user.setUSERNAME(pd.getString("USERNAME"));
			user.setPASSWORD(pd.getString("PASSWORD"));
			user.setNAME(pd.getString("NAME"));
			user.setRIGHTS(pd.getString("RIGHTS"));
			user.setROLE_ID(pd.getString("ROLE_ID"));
			user.setLAST_LOGIN(pd.getString("LAST_LOGIN"));
			user.setIP(pd.getString("IP"));
			user.setSTATUS(pd.getString("STATUS"));
			user.setNUMBER(pd.getString("NUMBER"));// 员工编号
			user.setDeptId((Integer) pd.get("DEPT_ID"));// 员工所属部门
			user.setDeptName(pd.getString("DEPT_NAME"));//员工部门名称
			user.setEmail(pd.getString("EMAIL"));//员工邮箱
			user.setDeptArea(pd.getString("DEPT_AREA"));
			user.setDeptAreaCode(pd.getString("AREA_BIANMA"));
			user.setPhone(pd.getString("PHONE"));
			if(null != pd.get("JOB_RANK")){
				user.setJobRank((Integer)pd.get("JOB_RANK"));
			}
			
			session.setAttribute(Const.SESSION_USER, user);

			// shiro加入身份验证
			Subject subject = SecurityUtils.getSubject();
			UsernamePasswordToken token = new UsernamePasswordToken(username,
					password);
			try {
				subject.login(token);
			} catch (AuthenticationException e) {
				errInfo = "身份验证失败！";
			}

		}else if(pd != null){
			errInfo = "empNotEnabled"; // 用户对应的员工未启用
		} else {
			errInfo = "usererror"; // 用户名或密码有误
		}

		if (Tools.isEmpty(errInfo)) {
			errInfo = "success"; // 验证成功
		}
		map.put("result", errInfo);
		return AppUtil.returnObject(new PageData(), map);
	}

	/**
	 * 访问系统首页
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/login_index")
	public ModelAndView login_index(Page page) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = getPageData();
		try {
			// shiro管理的session
			Session session = SecurityUtils.getSubject().getSession();
			User user = (User) session.getAttribute(Const.SESSION_USER);
			if (user != null) {
				User userr = (User) session.getAttribute(Const.SESSION_USERROL);
				if (null == userr) {
					user = userService.getUserAndRoleById(user.getUSER_ID());
					session.setAttribute(Const.SESSION_USERROL, user);
				} else {
					user = userr;
				}
				Role role = user.getRole();
				String roleRights = role != null ? role.getRIGHTS() : "";
				// 避免每次拦截用户操作时查询数据库，以下将用户所属角色权限、用户权限限都存入session
				session.setAttribute(Const.SESSION_ROLE_RIGHTS, roleRights); // 将角色权限存入session
				session.setAttribute(Const.SESSION_USERNAME, user.getUSERNAME()); // 放入用户名

				List<Menu> allmenuList = new ArrayList<Menu>();

				if (null == session.getAttribute(Const.SESSION_allmenuList)) {
					allmenuList = menuService.listAllWebMenu();
					if (Tools.notEmpty(roleRights)) {
						setHasMenu(allmenuList, roleRights);
					}
					session.setAttribute(Const.SESSION_allmenuList, allmenuList); // 菜单权限放入session中
				} else {
					allmenuList = (List<Menu>) session.getAttribute(Const.SESSION_allmenuList);
				}

				// 切换菜单=====
				List<Menu> menuList = new ArrayList<Menu>();
				if (null == session.getAttribute(Const.SESSION_menuList) || ("yes".equals(pd.getString("changeMenu")))) {
					List<Menu> menuList1 = new ArrayList<Menu>();
					List<Menu> menuList2 = new ArrayList<Menu>();

					// 拆分菜单
					for (int i = 0; i < allmenuList.size(); i++) {
						Menu menu = allmenuList.get(i);
						if ("1".equals(menu.getMENU_TYPE())) {
							menuList1.add(menu);
						} else {
							menuList2.add(menu);
						}
					}

					session.removeAttribute(Const.SESSION_menuList);
					if ("2".equals(session.getAttribute("changeMenu"))) {
						session.setAttribute(Const.SESSION_menuList, menuList1);
						session.removeAttribute("changeMenu");
						session.setAttribute("changeMenu", "1");
						menuList = menuList1;
					} else {
						session.setAttribute(Const.SESSION_menuList, menuList2);
						session.removeAttribute("changeMenu");
						session.setAttribute("changeMenu", "2");
						menuList = menuList2;
					}
				} else {
					menuList = (List<Menu>) session.getAttribute(Const.SESSION_menuList);
				}
				// 切换菜单=====

				if (null == session.getAttribute(Const.SESSION_QX)) {
					session.setAttribute(Const.SESSION_QX, this.getUQX(session)); // 按钮权限放到session中
				}

				// FusionCharts 报表
				String strXML = "<graph caption='前12个月订单销量柱状图' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'><set name='2013-05' value='4' color='AFD8F8'/><set name='2013-04' value='0' color='AFD8F8'/><set name='2013-03' value='0' color='AFD8F8'/><set name='2013-02' value='0' color='AFD8F8'/><set name='2013-01' value='0' color='AFD8F8'/><set name='2012-01' value='0' color='AFD8F8'/><set name='2012-11' value='0' color='AFD8F8'/><set name='2012-10' value='0' color='AFD8F8'/><set name='2012-09' value='0' color='AFD8F8'/><set name='2012-08' value='0' color='AFD8F8'/><set name='2012-07' value='0' color='AFD8F8'/><set name='2012-06' value='0' color='AFD8F8'/></graph>";
				mv.addObject("strXML", strXML);
				// FusionCharts 报表

				//统计当前任务数量
//				List<PageData> taskMsg = commonService.showMsgData(user.getNUMBER());
//				int count = 0;
//				for(PageData msg : taskMsg){
//					count += Integer.valueOf(msg.get("count").toString());
//				}
//				mv.addObject("taskMsg", taskMsg);
//				mv.addObject("taskMsgCount", count);
				
				mv.addObject("refreshInterval", Const.REFRESH_INTERVAL);
				mv.setViewName("system/admin/index");
				mv.addObject("user", user);
				mv.addObject("menuList", menuList);
			} else {
				mv.setViewName("system/admin/login");// session失效后跳转登录页面
			}

		} catch (Exception e) {
			mv.setViewName("system/admin/login");
			logger.error(e.getMessage(), e);
		}
		pd.put("SYSNAME", Tools.readTxtFile(Const.SYSNAME)); // 读取系统名称
		mv.addObject("pd", pd);
		return mv;
	}
	
	/**
	 * 显示菜单结构
	 */
	@RequestMapping("toSysPage")
	public ModelAndView toSysPage(){
		PageData pd = this.getPageData();
		String pageName = pd.get("pageName").toString();
		ModelAndView mv = new ModelAndView(pageName);
		return mv;
	}
	
	/**
	 * 获取菜单
	 */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping("findMenuList")
	public PageData findMenuList(){
		PageData result = new PageData();
		try {
			// shiro管理的session
			Session session = SecurityUtils.getSubject().getSession();
			List<Menu> menuList = (List<Menu>) session.getAttribute(Const.SESSION_menuList);
			result.put("menuList", menuList);
			result.put(Const.MSG, Const.SUCCESS);
		} catch (InvalidSessionException e) {
			logger.error(e);
			result.put(Const.MSG, Const.ERROR);
		}
		
		return result;
	}
	
	/**
	 * 跳转到待开发页面
	 */
	@RequestMapping("toErrorDevelop")
	public ModelAndView toErrorDevelop(){
		ModelAndView mv = new ModelAndView("error-develop");
		return mv;
	}

	/**
	 * 获取任务数量
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="countTask")
	public HashMap<String,Object> countTask(){
		try {
			//获取新的工作统计
			User user = getUser();
			HashMap<String,Object> result = new HashMap<>();
			List<PageData> taskMsg = new ArrayList<>();
			int count = 0;

			result.put("taskMsg", taskMsg);
			result.put("taskMsgCount", count);
			
			//获取未读消息
			PageData pd = new PageData();
			pd.put("empCode", user.getNUMBER());
			pd.put("STATUS", 1);
			List<PageData> recordList = remindRecordService.findRecord(pd);
			int recordCount = recordList.size();
			Properties prop = Tools.loadPropertiesFile("message_tixing.properties");
			for(PageData record:recordList){
				String url = prop.getProperty(Const.WEBSOCKET_URL_PREFFIX + record.getString("WORK")).replace("{id}", record.get("WORK_ID").toString()).replace("{empCode}", pd.get("empCode").toString());
				record.put("URL", url);
			}
			result.put("recordList", recordList);
			result.put("recordCount", recordCount);
			
			return result;
		} catch (Exception e) {
			logger.error(e);
			return null;
		}
	}
	
	private void setHasMenu(List<Menu> allmenuList, String roleRights){
		if(allmenuList != null){
			for (Menu menu : allmenuList) {
				menu.setHasMenu(RightsHelper.testRights(roleRights, menu.getMENU_ID()));
				if (menu.isHasMenu()) {
					setHasMenu(menu.getSubMenu(), roleRights);
				}
			}
		}
	}
	
	/**
	 * 进入tab标签
	 * 
	 * @return
	 */
	@RequestMapping(value = "/tab")
	public String tab() {
		return "system/admin/tab";
	}

	/**
	 * 进入首页后的默认页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/login_default")
	public ModelAndView defaultPage() {
		ModelAndView modelAndView = new ModelAndView();
		try {
			User user = getUser();
			// 获取全部岗位职责
			List<PageData> dutys = positionDutyService.findDutyByUser(user);
			modelAndView.addObject("dutys", dutys);

			// 获取已收藏的岗位职责
			List<PageData> commonDutys = positionDutyService
					.findCommonDuty(user);
			modelAndView.addObject("commonDutys", commonDutys);
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.setViewName("system/admin/default");
		return modelAndView;
	}

	/**
	 * 进入导航页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/goNavigation")
	public ModelAndView goNavigation(HttpServletRequest request) {
		//跳转到公司的组织架构图页面
		//return showCompanyOrganizationChart();
		//跳转到新版员工工作台
		return showSummaryTask();
	}
	
	/**
	 * 主页展示
	 */
	public ModelAndView showSummaryTask(){
		ModelAndView mv = new ModelAndView();
		//员工和领导区别跳转主页 by 苏立君 20170814
		PageData pd = new PageData();
		pd.put("USERNAME", getUser().getUSERNAME());//将员工名放入查询PD中
		int isLeader = 0;
		try {
			isLeader = commonService.checkLeader(pd);//查询是否是领导 0:不是;1:是
		} catch (Exception e) {
			e.printStackTrace();
		}
//		if(isLeader == 1){//是领导时页面跳转为领导工作台页面
//			mv.setViewName("summary/summaryTaskForLeader");
//		}else{//不是领导(员工)时页面跳转为员工工作台页面
//			mv.setViewName("summary/summaryTask");
//		}
		mv.setViewName("summary/summaryTask");
		mv.addObject("queryEmpCode", getUser().getNUMBER());
		
		return mv;
	}
	
	/**
	 * 公司的组织架构页面
	 */
	public ModelAndView showCompanyOrganization(){
		ModelAndView modelAndView = new ModelAndView();
		List<PageData> districtList = new ArrayList<>();
		List<PageData> functionList = new ArrayList<>();
		List<PageData> allDeptList = new ArrayList<>();
		try {
			districtList = this.commonService.typeListByBm("BMDY");
			functionList = this.commonService.typeListByBm("BMZN");
			PageData pd = new PageData();
			/*
			//====数据权限
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("USERNAME", session.getAttribute(Const.SESSION_USERNAME));
			int count = commonService.checkLeader(pd);
			User user = (User) session.getAttribute(Const.SESSION_USERROL);
			if(count != 0){
				List<PageData> dataRoles = dataroleService.findByUser(user.getUSER_ID());
				
				if(dataRoles!=null && dataRoles.size()!=0){
					List DEPT_IDS = new ArrayList<>();
					for(PageData dataRole : dataRoles){
						DEPT_IDS.add(dataRole.get("DEPT_ID"));
					}
					pd.put("deptIdList", DEPT_IDS);
					allDeptList = this.showDataService.findDept(pd);
				}
			}else{
				pd.put("dept_id", user.getDeptId());
				allDeptList = this.showDataService.findDept(pd);
			}
			*/
			allDeptList = this.showDataService.findDept(pd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.addObject("allDeptList", allDeptList);
		modelAndView.addObject("districtList", districtList);
		modelAndView.addObject("functionList", functionList);
		modelAndView.setViewName("system/admin/main");
		return modelAndView;
	}

	/**
	 * 查询主页细胞分裂图节点
	 * 
	 * @param TYPE
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "findItem", produces = "text/html;charset=UTF-8")
	public void findItem(@RequestParam String TYPE, HttpServletResponse response)
			throws Exception {
		List<PageData> list = new ArrayList<>();
		Map<String, Object> map = new HashMap<String, Object>();
		if (TYPE.equals("1")) {
			list = this.commonService.typeListByBm("BMDY");
		} else {
			list = this.commonService.typeListByBm("BMZN");
		}
		map.put("list", list);
		JSONObject jo = JSONObject.fromObject(map);
		String json = jo.toString();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.write(json);
		out.flush();
		out.close();
	}

	/**
	 * 打开iframe的主页面
	 * 
	 * @param pageName
	 * @return
	 */
	@RequestMapping(value = "showData")
	public String showData() {
		return "system/admin/showDeptData";
	}

	/**
	 * 查询员工基本信息
	 * 
	 * @param empId
	 * @throws Exception
	 */
	@RequestMapping(value = "queryBasicInfo", produces = "text/html;charset=UTF-8")
	public void queryBasicInfo(String empId, HttpServletResponse response)
			throws Exception {
		PageData pd = this.showDataService.queryBasicInfo(empId);
		Map<String, Object> map = new HashMap<>();
		if (pd.get("EMP_CODE") != null) {
			map.put("EMP_CODE", pd.getString("EMP_CODE"));
		}
		if (pd.get("EMP_NAME") != null) {
			map.put("EMP_NAME", pd.getString("EMP_NAME"));
		}
		if (pd.get("DEPT_NAME") != null) {
			map.put("DEPT_NAME", pd.getString("DEPT_NAME"));
		}
		JSONObject jo = JSONObject.fromObject(map);
		String json = jo.toString();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.write(json);
		out.flush();
		out.close();

	}

	/**
	 * 查询目标
	 * 
	 * @param page
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "queryTarget")
	public GridPage queryTarget(Page page, HttpServletRequest request) {
		logBefore(logger, "导航页查询目标列表");
		List<PageData> targetList = new ArrayList<>();
		try {
			convertPage(page, request);
			PageData searchPd = page.getPd();
			List<PageData> sysDeptList = commonService.getSysDeptList();
			if (null != sysDeptList && 0 != sysDeptList.size()
					&& null != sysDeptList.get(0)) {
				String[] sysDeptArr = new String[sysDeptList.size()];
				for (int i = 0; i < sysDeptList.size(); i++) {
					sysDeptArr[i] = sysDeptList.get(i).get("DEPT_CODE")
							.toString();
				}
				searchPd.put("sysDeptArr", sysDeptArr);
			}
			page.setPd(searchPd);
			targetList = showDataService.list(page);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(targetList, page);
	}

	/**
	 * 查询简历
	 * 
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/queryRecord")
	public void queryRecord(@RequestParam String empId,
			HttpServletResponse response) throws Exception {
		logBefore(logger, "查询简历列表");
		PageData pd = new PageData();
		pd.put("EMP_ID", empId);
		PageData recordPd = this.employeeService.findRecord(pd);
		Map<String, Object> map = new HashMap<>();
		if (recordPd != null) {
			if (recordPd.get("EMP_ID") != null) {
				map.put("EMP_ID", recordPd.getString("EMP_ID"));
			}
			if (recordPd.get("NAME") != null) {
				map.put("NAME", recordPd.getString("NAME"));
			}
			if (recordPd.get("GENDER") != null) {
				String gender = recordPd.getString("GENDER");
				if (gender.equals("1")) {
					map.put("GENDER", "男");
				} else {
					map.put("GENDER", "女");
				}
			}
			if (recordPd.get("ADDRESS") != null) {
				map.put("ADDRESS", recordPd.getString("ADDRESS"));
			}
			if (recordPd.get("AGE") != null) {
				map.put("AGE", recordPd.getString("AGE"));
			}
			if (recordPd.get("BIRTHDAY") != null) {
				map.put("BIRTHDAY", recordPd.get("BIRTHDAY").toString());
			}
			if (recordPd.get("PHONE") != null) {
				map.put("PHONE", recordPd.getString("PHONE"));
			}
			if (recordPd.get("EMAIL") != null) {
				map.put("EMAIL", recordPd.getString("EMAIL"));
			}
			if (recordPd.get("SCHOOL") != null) {
				map.put("SCHOOL", recordPd.getString("SCHOOL"));
			}
			if (recordPd.get("GRADUATE_TIME") != null) {
				map.put("GRADUATE_TIME", recordPd.get("GRADUATE_TIME")
						.toString());
			}
			if (recordPd.get("MAJOR") != null) {
				map.put("MAJOR", recordPd.getString("MAJOR"));
			}
			if (recordPd.get("DEGREE") != null) {
				map.put("DEGREE", recordPd.getString("DEGREE"));
			}
		}

		JSONObject jo = JSONObject.fromObject(map);
		String json = jo.toString();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.write(json);
		out.flush();
		out.close();
	}

	/**
	 * 查询工作经历
	 * 
	 * @param page
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "queryRecordExp")
	public GridPage queryRecordExp(Page page, HttpServletRequest request)
			throws Exception {
		logBefore(logger, "查询工作经历列表");
		List<PageData> list = new ArrayList<>();
		convertPage(page, request);
		list = this.showDataService.queryRecordExp(page);
		return new GridPage(list, page);

	}

	/**
	 * 打开iframe的员工页面
	 * 
	 * @param pageName
	 * @return
	 */
	@RequestMapping(value = "enterEmpData")
	public ModelAndView enterEmpData() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("system/admin/showEmpData");
		//查询当前登录人是否有权限查看该部门
		PageData pd = this.getPageData();
		pd.put("userId", getUser().getUSER_ID());
		try {
			if(null!=getUser().getDeptId() && getUser().getDeptId()==Integer.parseInt(pd.getString("deptId"))){
				mv.addObject("selfdept", true);
			}else{
				PageData dataRole = dataroleService.findDataRoleByDeptAndUser(pd);
				mv.addObject("hasDataRole", null != dataRole);
			}
		} catch (Exception e) {
			logger.error("查询部门的数据权限出错", e);
		}
		
		return mv;
	}

	/**
	 * 根据职能查询部门
	 * 
	 * @param BIANMA
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "findDeptByFun", produces = "text/html;charset=UTF-8")
	public void findDeptByFun(@RequestParam String BIANMA,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logBefore(logger, "通过职能查找部门");
		PageData pd = new PageData();
		pd.put("BIANMA", BIANMA);
		List<PageData> list = new ArrayList<>();
		/*
		//====数据权限
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		pd.put("USERNAME", session.getAttribute(Const.SESSION_USERNAME));
		int count = commonService.checkLeader(pd);
		User user = (User) session.getAttribute(Const.SESSION_USERROL);
		if(count != 0){
			List<PageData> dataRoles = dataroleService.findByUser(user.getUSER_ID());
			
			if(dataRoles!=null && dataRoles.size()!=0){
				List DEPT_IDS = new ArrayList<>();
				for(PageData dataRole : dataRoles){
					DEPT_IDS.add(dataRole.get("DEPT_ID"));
				}
				pd.put("deptIdList", DEPT_IDS);
				list = this.showDataService.findDeptByFun(pd);
			}
		}else{
			pd.put("dept_id", user.getDeptId());
			list = this.showDataService.findDeptByFun(pd);
		}
		*/
		list = this.showDataService.findDeptByFun(pd);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("funDeptList", list);
		JSONObject jo = JSONObject.fromObject(map);
		String json = jo.toString();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.write(json);
		out.flush();
		out.close();
	}

	/**
	 * 根据地域查询部门
	 * 
	 * @param BIANMA
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "findDeptByDis", produces = "text/html;charset=UTF-8")
	public void findDeptByDis(@RequestParam String BIANMA,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logBefore(logger, "通过地域查找部门");
		PageData pd = new PageData();
		pd.put("BIANMA", BIANMA);
		List<PageData> list = new ArrayList<>();
		/*
		//====数据权限
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		pd.put("USERNAME", session.getAttribute(Const.SESSION_USERNAME));
		int count = commonService.checkLeader(pd);
		User user = (User) session.getAttribute(Const.SESSION_USERROL);
		if(count != 0){
			List<PageData> dataRoles = dataroleService.findByUser(user.getUSER_ID());
			
			if(dataRoles!=null && dataRoles.size()!=0){
				List DEPT_IDS = new ArrayList<>();
				for(PageData dataRole : dataRoles){
					DEPT_IDS.add(dataRole.get("DEPT_ID"));
				}
				pd.put("deptIdList", DEPT_IDS);
				list = this.showDataService.findDeptByDis(pd);
			}
		}else{
			pd.put("dept_id", user.getDeptId());
			list = this.showDataService.findDeptByDis(pd);
		}
		*/
		list = this.showDataService.findDeptByDis(pd);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("funDeptList", list);
		JSONObject jo = JSONObject.fromObject(map);
		String json = jo.toString();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.write(json);
		out.flush();
		out.close();
	}

	/**
	 * 查询职能
	 * 
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "findFun", produces = "text/html;charset=UTF-8")
	public void findFun(HttpServletResponse response) throws Exception {
		logBefore(logger, "查询职能");
		List<PageData> functionList = this.commonService.typeListByBm("BMZN");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("functionList", functionList);
		JSONObject jo = JSONObject.fromObject(map);
		String json = jo.toString();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.write(json);
		out.flush();
		out.close();
	}

	/**
	 * 查询部门下人员列表
	 *    
	 * @param page
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "empTaskList")
	public GridPage empTaskList(Page page, HttpServletRequest request)
			throws Exception {
		logBefore(logger, "查询部门下员工列表");
		List<PageData> list = new ArrayList<>();
		convertPage(page, request);
		PageData pd = page.getPd();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		
		String lastYm = sdf.format(getLastMonth(new Date()));
		
		pd.put("lastYm", lastYm);
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		PageData newPd = new PageData();
		newPd.put("USERNAME", session.getAttribute(Const.SESSION_USERNAME));
		/*
		int count = commonService.checkLeader(newPd);
		if(count==0){
			pd.put("USERNAME", getUser().getNUMBER());
		}
		*/
		//查询是否有部门的数据权限
		pd.put("userId", getUser().getUSER_ID());
		PageData dataRole = dataroleService.findDataRoleByDeptAndUser(pd);
		//是否显示得分情况等，当前登录人有权限查看时，才进行下面的查询
		boolean showDetail = null != dataRole || (null != getUser().getDeptId() && 
				getUser().getDeptId()==Integer.parseInt(pd.getString("deptId")));
		pd.put("showDetail", showDetail);
		page.setPd(pd);
		list = this.showDataService.findEmpTaskList(page);
		
		if(showDetail){
			if(pd.get("current").toString().equals("1")){
				for (int i = 0; i < list.size(); i++) {
					if(i<2){
						PageData empPd = (PageData)list.get(i);
						empPd.put("ORDER", "good");
					}
				}
			}

			String curYM = sdf.format(new Date());
			for (PageData objPd : list) {
				objPd.put("curYm", curYM);
				PageData curPd = (PageData) this.showDataService
						.doQueryCurScore(objPd);
				if (curPd != null) {
					objPd.put("SCORE", curPd.get("SCORE").toString());
				}
			}
		}
		
		
		return new GridPage(list, page);
	}

	/**
	 * 查询绩效得分
	 * 
	 * @param empCode
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "queryPerInfo", produces = "text/html;charset=UTF-8")
	public void queryPerInfo(@RequestParam String empCode,
			HttpServletResponse response) throws Exception {
		PageData pageData = new PageData();
		String MONTH = "";
		String LAST_MONTH = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		if (MONTH == null || MONTH.equals("")) {
			Calendar c = Calendar.getInstance();
			MONTH = sdf.format(c.getTime());
			c.add(Calendar.MONTH, -1);
			LAST_MONTH = sdf.format(c.getTime());
		}
		pageData.put("MONTH", MONTH);
		pageData.put("LAST_MONTH", LAST_MONTH);
		pageData.put("EMP_CODE", empCode);
		PageData pd = this.showDataService.queryPerInfo(pageData);
		Map<String, Object> map = new HashMap<String, Object>();
		String PERF_ID = "";
		if (pd != null) {
			if (pd.get("PERF_ID") != null) {
				PERF_ID = pd.get("PERF_ID").toString();
				map.put("PERF_ID", PERF_ID);
			}
		}
		if(pd.get("SCORE") == null){
			map.put("SCORE", "0");
		}else{
			map.put("SCORE", pd.get("SCORE").toString());
		}
		
		JSONObject jo = JSONObject.fromObject(map);
		String json = jo.toString();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.write(json);
		out.flush();
		out.close();

	}


	/**
	 * 进入员工详情页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "goViewEmpDetail")
	public String goViewEmpDetail() {
		return "system/admin/showEmpDetail";

	}

	// 获取上月月份
	private Date getLastMonth(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(Calendar.MONTH, -1);
		return c.getTime();
	}

	/**
	 * 根据部门id查询部门名称
	 * 
	 * @param deptId
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "findDeptNameById")
	public void findDeptNameById(@RequestParam String deptId,
			HttpServletResponse response) throws Exception {
		logBefore(logger, "根据部门id查询部门名称");
		PageData pd = this.showDataService.findDeptNameById(deptId);
		String deptName = pd.getString("DEPT_NAME");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptName", deptName);
		JSONObject jo = JSONObject.fromObject(map);
		String json = jo.toString();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.write(json);
		out.flush();
		out.close();
	}

	/**
	 * 查询周工作任务
	 * 
	 * @param page
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "weekTask")
	public GridPage weekTask(Page page, HttpServletRequest request)
			throws Exception {
		logBefore(logger, "查询周工作任务列表");
		List<PageData> taskList = new ArrayList<>();// 周工作列表
		List<PageData> deptList = new ArrayList<PageData>();// 下属部门列表
		convertPage(page, request);
		PageData pd = page.getPd();
		// 查询部门列表
		deptList = getDeptList(request, commonService);
		String deptCodeStr = "";// 用于查询所有部门下的员工周工作
		if (deptList.size() > 0) {
			for (PageData dept : deptList) {
				deptCodeStr += "," + "'" + dept.getString("DEPT_CODE") + "'";
			}
			deptCodeStr = "(" + deptCodeStr.substring(1) + ")";

			pd.put("deptCodeStr", deptCodeStr);
		}
		// 不显示草稿状态的周工作任务和创新活动
		pd.put("useStatus", Const.SYS_STATUS_YW_CG);
		taskList = showDataService.empWeekTasklistPage(page);
		return new GridPage(taskList, page);

	}

	/**
	 * 用户注销
	 * 
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/logout")
	public ModelAndView logout() {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();

		// shiro管理的session
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();

		session.removeAttribute(Const.SESSION_USER);
		session.removeAttribute(Const.SESSION_ROLE_RIGHTS);
		session.removeAttribute(Const.SESSION_allmenuList);
		session.removeAttribute(Const.SESSION_menuList);
		session.removeAttribute(Const.SESSION_QX);
		session.removeAttribute(Const.SESSION_userpds);
		session.removeAttribute(Const.SESSION_USERNAME);
		session.removeAttribute(Const.SESSION_USERROL);
		session.removeAttribute("changeMenu");

		// shiro销毁登录
		Subject subject = SecurityUtils.getSubject();
		subject.logout();

		pd = this.getPageData();
		String msg = pd.getString("msg");
		pd.put("msg", msg);

		pd.put("SYSNAME", Tools.readTxtFile(Const.SYSNAME)); // 读取系统名称
		mv.setViewName("system/admin/login");
		mv.addObject("pd", pd);
		return mv;
	}

	/**
	 * 获取用户权限
	 */
	public Map<String, String> getUQX(Session session) {
		PageData pd = new PageData();
		Map<String, String> map = new HashMap<String, String>();
		try {
			String USERNAME = session.getAttribute(Const.SESSION_USERNAME)
					.toString();
			pd.put(Const.SESSION_USERNAME, USERNAME);
			String ROLE_ID = userService.findByUId(pd).get("ROLE_ID")
					.toString();

			pd.put("ROLE_ID", ROLE_ID);

			PageData pd2 = new PageData();
			pd2.put(Const.SESSION_USERNAME, USERNAME);
			pd2.put("ROLE_ID", ROLE_ID);

			pd = roleService.findObjectById(pd);

			pd2 = roleService.findGLbyrid(pd2);
			if (null != pd2) { 
				map.put("FX_QX", pd2.get("FX_QX").toString());
				map.put("FW_QX", pd2.get("FW_QX").toString());
				map.put("QX1", pd2.get("QX1").toString());
				map.put("QX2", pd2.get("QX2").toString());
				map.put("QX3", pd2.get("QX3").toString());
				map.put("QX4", pd2.get("QX4").toString());

				pd2.put("ROLE_ID", ROLE_ID);
				pd2 = roleService.findYHbyrid(pd2);
				map.put("C1", pd2.get("C1").toString());
				map.put("C2", pd2.get("C2").toString());
				map.put("C3", pd2.get("C3").toString());
				map.put("C4", pd2.get("C4").toString());
				map.put("Q1", pd2.get("Q1").toString());
				map.put("Q2", pd2.get("Q2").toString());
				map.put("Q3", pd2.get("Q3").toString());
				map.put("Q4", pd2.get("Q4").toString());
			}

			map.put("adds", pd.getString("ADD_QX"));
			map.put("dels", pd.getString("DEL_QX"));
			map.put("edits", pd.getString("EDIT_QX"));
			map.put("chas", pd.getString("CHA_QX"));

			// System.out.println(map);

			this.getRemortIP(USERNAME);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return map;
	}

    /**
     * 获取累计登陆时间
     * @throws Exception
     */
    @RequestMapping(value = "/getLoginTime")
    public void getLoginTime(PrintWriter out) throws Exception{
    	PageData pd = new PageData();
    	pd = this.getPageData();
    	Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user = (User)session.getAttribute(Const.SESSION_USER);
		pd.put("USER_ID", user.getUSER_ID());

    	String time = userService.findTimeById(pd);
    	if(time == null){
    		time="0";
    	}
    	if(null == pd.get("first")){
    		int newTime = Integer.valueOf(time) + Integer.valueOf(Const.REFRESH_INTERVAL);
        	pd.put("ONLINE_TIME", newTime);
        	userService.updateOnlineTime(pd);
        	time = String.valueOf(newTime);
    	}

    	
    	out.write(time);
		out.flush();
		out.close();
		
    }
    
    /**
	 * 查询员工培训记录
	 * 
	 * @param page
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "queryTrain")
	public GridPage queryTrain(Page page, HttpServletRequest request) {
		logBefore(logger, "导航页查询培训记录列表");
		List<PageData> trainList = new ArrayList<>();
		try {
			convertPage(page, request);
			PageData searchPd = page.getPd();
			page.setPd(searchPd);
			trainList = employeeTrainService.findByEmpCode(searchPd);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(trainList, page);
	}

}
