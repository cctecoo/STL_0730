package com.mfw.controller.app.login;

import java.util.ArrayList;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.entity.system.AccessToken;
import com.mfw.entity.system.Menu;
import com.mfw.entity.system.OAuthInfo;
import com.mfw.entity.system.Role;
import com.mfw.entity.system.User;
import com.mfw.service.app.AppService;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.scheduleJob.ScheduleJobService;
import com.mfw.service.system.menu.MenuService;
import com.mfw.service.system.role.RoleService;
import com.mfw.service.system.user.UserService;
import com.mfw.util.Const;
import com.mfw.util.PageData;
import com.mfw.util.RightsHelper;
import com.mfw.util.TaskType;
import com.mfw.util.Tools;
import com.mfw.util.WeixinUtil;

import net.sf.json.JSONArray;

/**
 * 手机端登陆
 * @author  作者  李伟涛
 * @date 创建时间：2017年4月01日 下午16:42:22
 */
@Controller
@RequestMapping(value="/app_login")
public class AppLoginController extends BaseController{

	@Resource(name="userService")
	private UserService userService;
	@Resource(name = "roleService")
	private RoleService roleService;
	@Resource(name = "menuService")
	private MenuService menuService;
	@Resource(name = "deptService")
	private DeptService deptService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name="appService")
	private AppService appService;
	@Resource
	private ScheduleJobService scheduleJobService;
	
	@RequestMapping(value="/toLogin")
	public String toLogin(){
		return "/app/login/login";
	}
	public static Properties prop = Tools.loadPropertiesFile("config.properties");
	
	/**
	 * 登录验证
	 * @param usernam
	 * @param password
	 * @return
	 * 修改时间		修改人		修改内容
	 * 2017-04-28	白惠文		增加微信号验证
	 */
	@ResponseBody
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public String login(){
/*		SavedRequest savedRequest = (SavedRequest) SecurityUtils.getSubject().getSession().getAttribute("shiroSavedRequest");
		String url = savedRequest.getRequestUrl();*/
		
		PageData pd = this.getPageData();
		PageData pdm = this.getPageData();
		String errInfo = "";
		try {
			String KEYDATA[] = pd.get("KEYDATA").toString().split(",");

			if (null != KEYDATA && KEYDATA.length == 2) {
				//shiro管理的session
				Subject currentUser = SecurityUtils.getSubject();
				Session session = currentUser.getSession();
				String USERNAME = KEYDATA[0];
				String PASSWORD = KEYDATA[1];
				//用用户名+密码去验证
				pd.put("USERNAME", USERNAME);
				pdm.put("USERNAME", USERNAME);
				String passwd = new SimpleHash("SHA-1", USERNAME, PASSWORD).toString(); //密码加密
				pd.put("PASSWORD", passwd);
				pd.put("OPEN_ID", "");
				//获取数据库保存的用户
				pd = userService.getUserByNameAndPwd(pd);
				if(null == pd){//再次用员工编号+密码去验证
					pd = new PageData();
					pd.put("NUMBER", USERNAME);
					pd = userService.findByUN(pd);
					if(null != pd){
						USERNAME = pd.getString("USERNAME");
						String inputPwd = new SimpleHash("SHA-1", pd.getString("USERNAME"), PASSWORD).toString();
						if(!pd.getString("PASSWORD").equals(inputPwd)){
							pd = null;
						}
					}
				}
				//数据库存在有效用户，则继续验证
				if (pd != null && pd.get("ENABLED").toString().equals("1")) {
					//如果是微信端登录，验证oepnId
					if(pdm.get("viewName").toString().equals("weixin")){
						Object openId = session.getAttribute("openId");
						if(openId!= null){
							//查询当前OpenId下是否绑定用户
							User userr = userService.findUserByOpenid(pdm);
							//如果该微信已绑定其他账号(如果为绑定账号则跳过)，提醒
							if(userr != null && !userr.getUSERNAME().equals(pdm.getString("USERNAME"))){
								errInfo = "existUser";
							}else{
								errInfo = setUserToSession(session, pd, USERNAME, PASSWORD);
							}
						}else if(pd.get("OPEN_ID") !=null && !"".equals(pd.get("OPEN_ID").toString())){
							//如果该账号中已绑定其他微信号，提醒
							errInfo = "existOpenId"; 
						}
					}else{//手机网页登录
						errInfo = setUserToSession(session, pd, USERNAME, PASSWORD);
					}
				}else if(pd != null){
					errInfo = "empNotEnabled"; // 用户对应的员工未启用
				} else {
					errInfo = "usererror"; //用户名或密码有误
				}
				if (Tools.isEmpty(errInfo)) {
					errInfo = "success"; //验证成功
				}
			} else {
				errInfo = "error"; //缺少参数
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return errInfo;
	}
	
	/**
	 * 把用户信息保存到session中
	 */
	private String setUserToSession(Session session, PageData pd, 
			String USERNAME, String PASSWORD) throws Exception{
		//更新用户的登陆时间
		userService.updateLastLogin(pd);
		//把用户信息保存到session中
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
		if(null != pd.get("JOB_RANK")){
			user.setJobRank((Integer)pd.get("JOB_RANK"));
		}
		
		session.setAttribute(Const.SESSION_USER, user);
		
		session.removeAttribute(Const.SESSION_SECURITY_CODE);

		//shiro加入身份验证
		Subject subject = SecurityUtils.getSubject();
		UsernamePasswordToken token = new UsernamePasswordToken(USERNAME, PASSWORD);
		try {
			subject.login(token);
			return "";
		} catch (AuthenticationException e) {
			return "身份验证失败！";
		}
	}
	
	/**
	 * 绑定验证
	 * @param usernam
	 * @param password
	 * @return
	 * 修改时间		修改人		修改内容
	 * 2017-04-28	白惠文		新增
	 */
	@ResponseBody
	@RequestMapping(value="/login_bind", method=RequestMethod.POST)
	public String login_bind(){
		PageData pd = this.getPageData();
		String errInfo = "";
		try {
			String KEYDATA[] = pd.get("KEYDATA").toString().split(",");

			if (null != KEYDATA && KEYDATA.length == 2) {
				//shiro管理的session
				Subject currentUser = SecurityUtils.getSubject();
				Session session = currentUser.getSession();
				String USERNAME = KEYDATA[0];
				String PASSWORD = KEYDATA[1];
				//用用户名+密码去验证
				pd.put("USERNAME", USERNAME);
				String passwd = new SimpleHash("SHA-1", USERNAME, PASSWORD).toString(); //密码加密
				pd.put("PASSWORD", passwd);
				pd.put("OPEN_ID", "");
				pd = userService.getUserByNameAndPwd(pd);
				if(null == pd){//再次用员工编号+密码去验证
					pd = new PageData();
					pd.put("NUMBER", USERNAME);
					pd = userService.findByUN(pd);
					if(null != pd){
						USERNAME = pd.getString("USERNAME");
						String inputPwd = new SimpleHash("SHA-1", pd.getString("USERNAME"), PASSWORD).toString();
						if(!pd.getString("PASSWORD").equals(inputPwd)){
							pd = null;
						}
					}
				}
				if (pd != null && pd.get("ENABLED").toString().equals("1")) {
					//如果该账号中已绑定其他微信号，提醒
					if(pd.get("OPEN_ID") !=null){
						if(!pd.get("OPEN_ID").equals("")){
							errInfo = "existOpenId"; 
						}						
					}else{
						errInfo = setUserToSession(session, pd, USERNAME, PASSWORD);
					}
				}else if(pd != null){
					errInfo = "empNotEnabled"; // 用户对应的员工未启用
				} else {
					errInfo = "usererror"; //用户名或密码有误
				}
				if (Tools.isEmpty(errInfo)) {
					errInfo = "success"; //验证成功
				}
			} else {
				errInfo = "error"; //缺少参数
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return errInfo;
	}
	
	private String openId;

	/**
	 * 访问系统首页
	 */
	@RequestMapping(value = "/login_index")
	public ModelAndView login_index(Page page) {
		ModelAndView mv = this.getModelAndView();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		PageData pd = new PageData();
		pd = this.getPageData();	
		String code = "";
		User user =new User();
		if(pd.get("viewName")!=null && !pd.get("viewName").equals("")){
			session.setAttribute("viewName", pd.get("viewName"));
		}
		try {
			//从微信登录的
			if(pd.get("code")!=null && !pd.get("code").toString().equals("failcode")){
				code = pd.get("code").toString();
				//获取微信的openId
				OAuthInfo oa = commonService.getOpenId(code);
				if(oa != null){
					openId = oa.getOpenId();
					pd.put("openId", openId);
					session.setAttribute("openId", openId);				
				}
				//根据openId获取绑定的用户
				user = userService.findUserByOpenid(pd);
/*				if (user == null||user.equals("")){
					user = (User) session.getAttribute(Const.SESSION_USER);
					if(user != null){
						pd.put("openId", openId);
						user.setOPEN_ID(pd.getString("openId"));
						logger.info("访问系统首页,用户名:"+user.getNAME()+"openId:"+session.getAttribute("openId").toString());
						userService.bindOpenId(user);
					}
				}*/
				if(user != null&&!user.equals("")){
					//把获取到的用户存入session
					session.setAttribute(Const.SESSION_USER, user);
				}else{
					mv.addObject("pd",pd);
					mv.setViewName("/app/login/bind");//session失效后跳转登录页面
					return mv;
				}
			}else{
				user = (User) session.getAttribute(Const.SESSION_USER);
			}
			//
			if (user != null) {
				//获取用户角色
				User userr = (User) session.getAttribute(Const.SESSION_USERROL);
				if (null == userr) {
					user = userService.getUserAndRoleById(user.getUSER_ID());
					session.setAttribute(Const.SESSION_USERROL, user);
				} else {
					user = userr;
				}
				
//				//获取当前组织机构名称
//				getDeptName(user);
				//获取所属岗位
				getPositionName(user);
				
				Role role = user.getRole();
				String roleRights = role != null ? role.getRIGHTS() : "";
				//避免每次拦截用户操作时查询数据库，以下将用户所属角色权限、用户权限限都存入session
				session.setAttribute(Const.SESSION_ROLE_RIGHTS, roleRights); //将角色权限存入session
				session.setAttribute(Const.SESSION_USERNAME, user.getUSERNAME()); //放入用户名

				//获取菜单
				List<Menu> appMenus = getAppMenus(session, roleRights);
				session.setAttribute(Const.SESSION_appmenuList, appMenus);
				//传给默认页时删除’我‘页面
				List<Menu> appIndexMenuList = new ArrayList<Menu>();
				for(Menu menu : appMenus){
					if(menu.getMENU_URL().contains("login_index.do")){
						continue;
					}
					appIndexMenuList.add(menu);
				}
				session.setAttribute(Const.SESSION_appIndexMenuList, appIndexMenuList);
				//查找跳转的页面
				if(session.getAttribute("viewName") != null){
					mv = appService.findPage(pd);
					mv.addObject("pd",pd);
					mv.addObject("user", user);
					mv.addObject("menuList", appMenus);	
					return mv;
				}
				mv.addObject("pd",pd);
				mv.setViewName("app/index");
				mv.addObject("user", user);
				mv.addObject("menuList", appMenus);					

			} else {
				mv.addObject("pd",pd);
				mv.setViewName("/app/login/login");//session失效后跳转登录页面
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			mv.setViewName("/app/login/login");			
		}
		pd.put("SYSNAME", Tools.readTxtFile(Const.SYSNAME)); //读取系统名称
		mv.addObject("pd", pd);
		return mv;
	}
	
	/**
	 * 绑定解绑功能-确认绑定状态
	 */	
	@RequestMapping(value = "/checkBind")
	public ModelAndView checkBind(Page page) {
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();		
		String code = "";
		
		try {
			if(pd.get("code")!=null)
			{
				code = pd.get("code").toString();
			}else if(session.getAttribute("openId") != null|| !("").equals(session.getAttribute("openId")))
			{
				openId = (String) session.getAttribute("openId");
				pd.put("openId", openId);

			}
			OAuthInfo oa = commonService.getOpenId(code);
			if(oa != null)
			{
				openId = oa.getOpenId();
				pd.put("openId", openId);
				session.setAttribute("openId", openId);
			}
			User user = userService.findUserByOpenid(pd);
			if(user != null)
			{
				mv.setViewName("/app/login/unBind");//如果已绑定跳转至解绑界面
			}
			else{
				mv.setViewName("/app/login/bind");
				//mv.setViewName("/app/login/stl_bind");//如果未绑定跳转至绑定界面
			}

		} catch (Exception e) {
			mv.setViewName("/app/login/unBindFail");
			logger.error(e.getMessage(), e);
		}
		mv.addObject("pd", pd);
		return mv;
	}
	
	
	
	/**
	 * 解除绑定
	 */	
	@RequestMapping(value = "/unBind")
	public ModelAndView unBind() {
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();				
		try {
			pd.put("openId", session.getAttribute("openId").toString());
			User user = userService.findUserByOpenid(pd);
			if (user != null&& user.getOPEN_ID() != null) {
				userService.unBindOpenId(user);
				session.removeAttribute(Const.SESSION_USER);
				session.removeAttribute("openId");
				mv.setViewName("/app/login/unBindSuccess");
			} else {
				mv.setViewName("/app/login/unBindFail");//session失效后跳转登录页面
			}
		} catch (Exception e) {
			mv.setViewName("/app/login/unBindFail");
			logger.error(e.getMessage(), e);
		}
		mv.addObject("pd", pd);
		return mv;
	}
	
	
	/**
	 * 绑定
	 */	
	@RequestMapping(value = "/bind")
	public ModelAndView bind() {
		ModelAndView mv = this.getModelAndView();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		PageData pd = new PageData();
		pd = this.getPageData();		
		try {
			User user = (User) session.getAttribute(Const.SESSION_USER);
			if (user != null) {
				pd.put("USERNAME", user.getUSERNAME().toString());				
				user.setOPEN_ID(session.getAttribute("openId").toString());
				logger.info("绑定时,用户名:"+user.getNAME()+"openId:"+session.getAttribute("openId").toString());
				userService.bindOpenId(user);				
				mv.setViewName("/app/login/bindSuccess");
			}else{
				mv.setViewName("/app/login/bind");
			}
		} catch (Exception e) {
			mv.setViewName("/app/login/bind");
			logger.error(e.getMessage(), e);
		}
		pd.put("SYSNAME", Tools.readTxtFile(Const.SYSNAME)); //读取系统名称
		mv.addObject("pd", pd);
		return mv;
	}
	
	/**
	 * 注销
	 * @return
	 */
	@RequestMapping(value = "/logout")
	public String logout(){
		Subject subject1 = SecurityUtils.getSubject();
		Session session1 = subject1.getSession();
		if(session1.getAttribute("openId") != null)
		{
			String openId = session1.getAttribute("openId").toString();
			subject1.logout();
			Subject subject = SecurityUtils.getSubject();
			Session session = subject.getSession();
			session.setAttribute("openId", openId);
		}else
		{
			subject1.logout();
		}
		return "/app/login/login";
	}
	/**
	 * 获取用户权限
	 */
	private Map<String, String> getUQX(Session session) {
		PageData pd = new PageData();
		Map<String, String> map = new HashMap<String, String>();
		try {
			String USERNAME = session.getAttribute(Const.SESSION_USERNAME).toString();
			pd.put(Const.SESSION_USERNAME, USERNAME);
			String ROLE_ID = userService.findByUId(pd).get("ROLE_ID").toString();

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

			//System.out.println(map);

			this.getRemortIP(USERNAME);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return map;
	}
	
	/**
	 * 获取登录用户的IP
	 * 
	 * @throws Exception
	 */
	private void getRemortIP(String USERNAME) throws Exception {
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
	 * 获取部门名称
	 * @param user
	 * @throws Exception
	 */
	private void getDeptName(User user) throws Exception{
		PageData search = new PageData();
		search.put("ID", user.getDeptId());
		search = deptService.findById(search);
		if(search == null){
			user.setDeptName("无");
		}else{
			user.setDeptName(search.getString("DEPT_NAME"));
		}
	}
	
	/**
	 * 获取岗位名称
	 * @param user
	 * @throws Exception
	 */
	private void getPositionName(User user) throws Exception{
		PageData search = new PageData();
		search.put("EMP_CODE", user.getNUMBER());
		search = employeeService.findByCode(search);
		if(search == null){
			user.setPASSWORD("无");
		}else{
			user.setPASSWORD(search.getString("EMP_GRADE_NAME"));
		}
	}
	
	/**
	 * 获取菜单
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private List<Menu> getAppMenus(Session session, String roleRights) throws Exception{
		List<Menu> appMenuList = new ArrayList<Menu>();
		List<Menu> result = new ArrayList<Menu>();
		if (null == session.getAttribute(Const.SESSION_allmenuList)) {
			result = menuService.listAppMenu();
			if (Tools.notEmpty(roleRights)) {
				for (Menu menu : result) {
					boolean isHasRight = RightsHelper.testRights(roleRights, menu.getMENU_ID());
					menu.setHasMenu(true);
					if(isHasRight){
						appMenuList.add(menu);
					}
				}
				result = appMenuList;
			}
		} else {
			result = (List<Menu>) session.getAttribute(Const.SESSION_allmenuList);
		}

		if (null == session.getAttribute(Const.SESSION_QX)) {
			session.setAttribute(Const.SESSION_QX, this.getUQX(session)); //按钮权限放到session中
		}
		return result;
	}
	
	/**
	 * 获取配置信息
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/getConfig")
	public JSONArray getConfig(){
		PageData pd = this.getPageData();
		Properties prop = Tools.loadPropertiesFile("config.properties");
        //获取appId
        String appid = prop.getProperty("APPID");
        //获取appsecret
        String appsecret = prop.getProperty("APPSECRET");
        //获取页面路径(前端获取时采用location.href.split('#')[0]获取url)
//        String url = pd.get("url").toString();
        String url = "www.baidu.com";
        //获取access_token
        AccessToken access_token = new AccessToken();
    	access_token = commonService.getAccessToken(appid,appsecret);
    	 
		//获取ticket
        String jsapi_ticket = appService.getTicket(access_token);
        //获取Unix时间戳(java时间戳为13位,所以要截取最后3位,保留前10位)
        String timeStamp = String.valueOf(System.currentTimeMillis()).substring(0, 10);
        //创建有序的Map用于创建签名串
        SortedMap<String, String> params = new TreeMap<String, String>();
        params.put("jsapi_ticket", jsapi_ticket);
        params.put("timestamp", timeStamp);
        params.put("noncestr", WeixinUtil.getRandomString(32));
        params.put("url", url);   
        //签名
        String signature = "";
        //得到签名再组装到Map里
        params.put("signature", signature);
        //传入对应的appId
        params.put("appId", appid);
        //组装完毕，回传
        try {
            JSONArray jsonArray = JSONArray.fromObject(params);
            return jsonArray;        
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
		
	}
	
	
	/**
	 * 发送消息界面
	 */	
	@RequestMapping(value = "/goSendMessage")
	public ModelAndView goSendMessage() {
		ModelAndView mv = this.getModelAndView();		
		mv.setViewName("/app/chart/sendMsg");
		return mv;
	}
    
}