package com.mfw.controller.base;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.entity.Page;
import com.mfw.entity.system.Menu;
import com.mfw.entity.system.User;
import com.mfw.entity.system.UserLog;
import com.mfw.entity.system.UserLog.LogObj;
import com.mfw.entity.system.UserLog.LogType;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.PositionLevelService;
import com.mfw.service.system.UserLogService;
import com.mfw.service.system.user.UserService;

import com.mfw.util.Const;
import com.mfw.util.FileUpload;
import com.mfw.util.Logger;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;
import com.mfw.util.UserUtils;
import com.mfw.util.UuidUtil;

import net.sf.json.JSONArray;

/**
 * 基类
 * @author  作者 蒋世平
 * @date 创建时间：2016年4月14日 下午17:33:54
 */
public class BaseController {

	protected Logger logger = Logger.getLogger(this.getClass());

	/**
	 * 得到PageData
	 */
	public PageData getPageData() {
		return new PageData(this.getRequest());
	}
	
	/**
	 * 得到ModelAndView
	 */
	public ModelAndView getModelAndView() {
		return new ModelAndView();
	}

	/**
	 * 得到request对象
	 */
	public HttpServletRequest getRequest() {
		HttpServletRequest request = 
				((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		return request;
	}

	/**
	 * 得到32位的uuid
	 * 
	 * @return
	 */
	public String get32UUID() {
		return UuidUtil.get32UUID();
	}

	public static void logBefore(Logger logger, String interfaceName) {
		logger.info("");
		logger.info("start");
		logger.info(interfaceName);
	}

	public static void logAfter(Logger logger) {
		logger.info("end");
		logger.info("");
	}
	
	/**
	 * 转换列表分页实体类
	 * @param pageData
	 * @param request
	 */
	public void convertPage(Page page, HttpServletRequest request){
		PageData pageData = getPageData();
		
		getSortMethod(pageData, request);
		getSearchPhrase(pageData, request);
		
		page.setPd(pageData);
		if( null != request.getParameter("rowCount") ){
			page.setShowCount(Integer.valueOf(request.getParameter("rowCount")));
		}
		
		
		if(request.getParameter("currentPage") == null 
				|| request.getParameter("currentPage").toString().equals("0") ){
			if( null != request.getParameter("current") ){
				page.setCurrentPage(Integer.valueOf(request.getParameter("current")));
			}
			
		}else{
			page.setCurrentPage(Integer.valueOf(request.getParameter("currentPage")));
		}
	}
	
	/**
	 * 获取用户信息
	 * @return
	 */
	public User getUser(){
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		User user = (User)session.getAttribute(Const.SESSION_USER);
		return user;
	}
	
	/**
	 * 获取用户角色信息
	 * @return
	 */
	public User getUserRole(){
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		User user = (User)session.getAttribute(Const.SESSION_USERROL);
		return user;
	}
	
	/**
	 * 新增数据时设置默认信息
	 * @param pd
	 * @return
	 */
	public PageData savePage(PageData pd){
		User user=getUser();
		pd.put("isdel","0");//0 有效，1或者null 无效
		pd.put("createUser", user.getUSERNAME());
		pd.put("createTime", new Date());
		return pd;
	}
	
	/**
	 * 更新数据时组装更新信息
	 * @param pd
	 * @return
	 */
	public PageData updatePage(PageData pd){
		User user=getUser();
		pd.put("updateUser", user.getUSERNAME());
		pd.put("updateTime", new Date());
		return pd;
	}
	
    /**
     * 为MV内放入部门树
     * @param mv
     * @throws Exception
     * author yangdw
     */
    public void deptTreeNodes(ModelAndView mv, List<PageData> deptList) throws Exception {
        //获取部门树
        List<PageData> tdeptList = new ArrayList<PageData>();
        for(int i =0; i< deptList.size();i++){
            PageData dept = deptList.get(i);
            dept.put("open",true);
            tdeptList.add(dept);
        }
        JSONArray arr = JSONArray.fromObject(tdeptList);
        mv.addObject("deptTreeNodes", arr.toString());
    }
    
    /**
     * 调用权限
     */
    @SuppressWarnings("unchecked")
	public void getHC(){
		ModelAndView mv = this.getModelAndView();
		HttpSession session = this.getRequest().getSession();
		Map<String, String> map = (Map<String, String>) session.getAttribute(Const.SESSION_QX);
		mv.addObject(Const.SESSION_QX,map);	//按钮权限
		List<Menu> menuList = (List<Menu>) session.getAttribute(Const.SESSION_menuList);
		mv.addObject(Const.SESSION_menuList, menuList);//菜单权限
	}
    
    /**
     * 绑定Bean中的日期对象
     * @param binder
     */
    @InitBinder
	public void initBinder(WebDataBinder binder){
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(format,true));
	}
    
    /**
	 * 获取搜索参数
	 * @param request
	 * @return
	 */
	public void getSearchPhrase(PageData pageData, HttpServletRequest request){
		if(null == request.getParameter("searchPhrase")){
			Set<String> paramKeys = request.getParameterMap().keySet();
			String searchKey = "";
			String searchPhrase = "";
			for(String str : paramKeys){
				if(str.startsWith("searchPhrase")){
					searchKey = str.substring(13, str.length()-1);
					searchPhrase = request.getParameter(str);
					pageData.put(searchKey, searchPhrase);
				}
			}
		}
	}
	
	/**
	 * 获取排序方法
	 * @param pageData
	 * @param request
	 */
	public void getSortMethod(PageData pageData,HttpServletRequest request){
		for(String str : request.getParameterMap().keySet()){
			if(str.startsWith("sort")){
				pageData.put("sortKey", str.substring(5, str.length()-1));
				pageData.put("sortMethod", request.getParameter(str));
				break;
			}
		}
		
	}
    /**
	 * 获取当前用户的下属部门列表
	 */
	public List<PageData> getDeptList(HttpServletRequest request, CommonService commonService){
		User user = UserUtils.getUser(request);
		PageData pd = new PageData();
		
		List<PageData> myList = new ArrayList<PageData>();
		try {
			String roleId = user.getRole().getROLE_ID();
			if(roleId != null){
				int count = commonService.checkSysRole(roleId);
				if(count==0){//不是管理员
					PageData dep = commonService.findDeptByEmpCode(user.getNUMBER());//当前部门信息
					myList = findAllChild(dep, commonService);//当前部门及其下属部门
				}else{//管理员
					myList = commonService.findDeptNoCom(pd);
				}
			}
		} catch (Exception e) {
			logger.error("获取当前用户的下属部门列表出错", e);
		}
		
		return myList;
	}
	/**
	 * 查询当前部门的下一级部门
	 */
	public List<PageData> findAllChild(PageData dep, CommonService commonService) throws Exception{
        List<PageData> childList = commonService.findChildDeptByDeptId(dep);
        List<PageData> myList = new ArrayList<PageData>();
        if(childList == null){//没有子部门则只添加当前部门
            myList.add(dep);
        }else {//有子部门，则循环查询是否存在下一级部门
        	myList.add(dep);
            for (int i = 0;i< childList.size();i++){
            	PageData eachChild = childList.get(i);
                myList.addAll(findAllChild(eachChild, commonService));
            }
        }
        return myList;
    }
	
	/**
	 * 查询员工所在部门的负责人，部门负责人则查询上一级领导
	 */
	public List<String> findLeaderByEmp(CommonService commonService) throws Exception{
		List<String> leaderEmpCodeList = new ArrayList<String>();
		PageData leader = commonService.findDeptLeader(getUser().getDeptId().toString());
		if(null!=leader){//部门负责人不为空时，判断是否是查询部门负责人的领导
			String leaderEmpCode = leader.getString("EMP_CODE");
			String empCode = getUser().getNUMBER();
			//当前员工为部门负责人则需要查询上级领导
			if(empCode!=null && empCode.equals(leaderEmpCode)){
				List<PageData> leaderList= commonService.findEmpCodeInDataRoleByDeptId(getUser().getDeptId());
				for(PageData leaderPd : leaderList){
					leaderEmpCodeList.add(leaderPd.getString("NUMBER"));
				}
			}else{//当前员工为普通员工
				leaderEmpCodeList.add(leaderEmpCode);
			}
		}
		
		return leaderEmpCodeList;
	}
	
	
	/**
	 * 返回上级领导；
	 * 部长等级为4，部长以上级别的可以显示同级别员工；
	 * 部长及以下员工，需要选择岗位等级高的员工，其中部长以下员工只能选择自己部门的
	 * @param empCode 员工编码
	 * @param deptId 员工部门ID
	 * @param jobRank 员工岗位等级
	 * @param findAllSuperiorEmp 为true时，查询所有部门中级别更高的员工，为空或false：只查询本部门下的级别更高员工
	 */
	public List<PageData> findSuperiorLeader(String empCode, Integer deptId, Integer jobRank,
			EmployeeService employeeService, boolean findAllSuperiorEmp) throws Exception{
		//查询所有岗位等级更高的员工
		PageData empPd = new PageData();
		empPd.put("empCode", empCode);
		empPd.put("operator", "<");//系统中小于代表更高级别的岗位
		empPd.put("empPositionLevel", jobRank);
		if(jobRank<=4){//部长等级为4，岗位等级越小级别越高
			empPd.put("operator", "<=");//系统中小于代表更高级别的岗位
		}else if(jobRank.intValue()>4){//部长下面的员工，只能选择自己部门的员工
			empPd.put("deptId", deptId);
		}
		
		List<PageData> list = employeeService.findSuperiorEmp(empPd);
		//没有查询到评价人时，去掉本部门的限制
		if(findAllSuperiorEmp || list.size()==0){
			empPd.put("deptId", null);
			list = employeeService.findSuperiorEmp(empPd);
		}
		return list;
	}
	


	/**
	 * 判断用户角色是否为管理员组的
	 * @return
	 */
	public boolean isAdminGroup(){
		//判断角色，如果是管理员角色，则显示维护按钮
		String parentRoleId = getUserRole().getRole().getPARENT_ID();
		return "0".equals(parentRoleId) || "1".equals(parentRoleId);
	}
	
	/**
	 * 判断用户角色是否为admin
	 * @return
	 */
	public boolean isSysAdmin(){
		//判断角色，如果是管理员角色，则显示维护按钮
		String parentRoleId = getUserRole().getRole().getPARENT_ID();
		return "0".equals(parentRoleId);
	}

	
	/**
	 * 记录日志
	 */
	public void logInfo(UserLogService userLogService, LogType logType, LogObj logObj, String content)throws Exception{
		userLogService.logInfo(new UserLog(getUser().getUSER_ID(), logType, logObj, content));
	}
	
	/**
	 * 查询用户的部门地域
	 */
	public String getUserDeptArea(DeptService deptService){
		Integer deptId = getUser().getDeptId();
		if(null==deptId){
			return null;
		}
		try {
			PageData pd = new PageData();
			pd.put("ID", deptId);
			PageData dept = deptService.findById(pd);
			return dept.getString("AREA");
		} catch (Exception e) {
			logger.error("getUserDeptArea", e);
			return null;
		}
	}

	/**
	 * 获取当前用户是否是管理员或维护人员
	 */
	public Map<String, Object> getAdminAndConfigEmp(EmployeeService employeeService, String configPage){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("isAdminGroup", isAdminGroup());//获取是否为管理员
		map.put("isSysAdmin", isSysAdmin());//系统管理员
		if(isAdminGroup()){
			map.put("showConfigBtn", "Y");
		}
		User user = getUser();
		map.put("currentUserArea", user.getDeptArea());
		map.put("currentUser", user.getUSERNAME());
		map.put("currentUserDeptId", user.getDeptId());
		map.put("showPage", configPage);
		try {
			if(null != configPage && !configPage.isEmpty()){
				PageData empInUser = employeeService.findIsChangeByEmpCode(user.getNUMBER(), configPage);
				if(null != empInUser && "Y".equals(empInUser.getString("IS_CHANGE"))){
					map.put(Const.CHANGE_PERSON, "Y");//维护人员
				}
			}
			
			return map;
		} catch (Exception e) {
			logger.error("getAdminAndConfigEmp error", e);
			return map;
		}
	}

	/**
	 * 查询页面上的维护权限
	 */
	public PageData getConfigRightsByPage(String configPage, String typeName, EmployeeService employeeService){
		PageData pd = new PageData();
		pd.put("typeCode", configPage);
		pd.put("typeName", typeName);
		pd.put(Const.CHANGE_PERSON, "N");
		try {
			User user = getUser();
			PageData empInUser = employeeService.findIsChangeByEmpCode(user.getNUMBER(), configPage);
			if(null != empInUser && "Y".equals(empInUser.getString("IS_CHANGE"))){
				pd.put(Const.CHANGE_PERSON, "Y");//维护人员
			}
		} catch (Exception e) {
			logger.error(e);
			pd.put(Const.MSG, "error");
		}
		return pd;
	}

	/**
	 * 查询用户的所有页面维护权限,可用于模糊查询
	 */
	public PageData getAllConfigRights(EmployeeService employeeService, String empCode, String showPageLike){
		PageData result = new PageData();
		try {
			result.put("isAdminGroup", isAdminGroup());//获取是否为管理员
			result.put("isSysAdmin", isSysAdmin());//系统管理员
			List<PageData> list = employeeService.findAllConfigPageByEmpCode(empCode, showPageLike);
			result.put("list", list);
			result.put(Const.MSG, Const.SUCCESS);
		} catch (Exception e) {
			logger.error("getAdminAndConfigEmp error", e);
			result.put(Const.MSG, Const.ERROR);
		}
		return result;
	}
	
	/**
	 * 获取当前用户的部门，分公司等信息
	 */
	public Map<String, Object> getUsernameAndDeptname(){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("username", getUser().getNAME());
		map.put("deptName", getUser().getDeptName());
		map.put("deptId", getUser().getDeptId());
		map.put("childCompany", getUser().getDeptArea());
		return map;
	}
	
	/**
	 *返回部门及员工树,用于流程设计页面
	 */
	public PageData findDeptAndEmpTreeForFlow(DeptService deptService, UserService userService ){
		
		PageData reslut = new PageData();
		//查询部门树
		try {
			List<PageData> datas = new ArrayList<PageData>();
			List<PageData> deptList = deptService.listAll(null);
			for(int i=0; i<deptList.size(); i++){
				PageData dept = new PageData();
				dept.put("nocheck", true);
				dept.put("name", deptList.get(i).get("DEPT_NAME"));
				dept.put("id", deptList.get(i).get("ID"));
				dept.put("pId", deptList.get(i).get("PARENT_ID"));
				datas.add(dept);
			}
			
			//获取用户
			for(PageData dept : deptList){
//				List<PageData> empList = employeeService.findEmpByDeptPd(dept);
				
				List<PageData> userList = userService.findUserByDeptId(Integer.valueOf(dept.get("ID").toString()));
				
				for(int i=0; i<userList.size(); i++){
					PageData emp = new PageData();
					emp.put("name", userList.get(i).get("NAME"));
					emp.put("id", "user_" + userList.get(i).get("USERNAME"));
					emp.put("pId", userList.get(i).get("DEPT_ID"));
					datas.add(emp);
				}
			}
			
			reslut.put("datas", datas);
			reslut.put("result", "1");
			reslut.put("msg", "获取数据完成");
			
		} catch (Exception e) {
			logger.error("11", e);
			reslut.put("result", "0");
			reslut.put("msg", "获取数据出错");
		}
		return reslut;
	}
	
	/**
	 * 查询部门树,用于流程设计页面
	 */
	public PageData findDeptTreeForFlow(DeptService deptService){
		PageData reslut = new PageData();
		//查询部门树
		try {
			List<PageData> datas = new ArrayList<PageData>();
			List<PageData> deptList = deptService.listAll(null);
			
			for(int i=0; i<deptList.size(); i++){
				PageData dept = new PageData();
				
				dept.put("name", deptList.get(i).get("DEPT_NAME"));
				dept.put("id", deptList.get(i).get("ID"));
				dept.put("pId", deptList.get(i).get("PARENT_ID"));
				if("0".equals(deptList.get(i).get("PARENT_ID").toString())){
					dept.put("nocheck", true);
				}
				datas.add(dept);
			}
			
			reslut.put("datas", datas);
			reslut.put("result", "1");
			reslut.put("msg", "获取数据完成");
		} catch (Exception e) {
			logger.error("11", e);
			reslut.put("result", "0");
			reslut.put("msg", "获取数据出错");
		}
		return reslut;
	}
	
	/**
	 *返回部门及岗位树
	 */
	public PageData findDeptAndPosTreeForFlow(DeptService deptService, PositionLevelService positionLevelService){
		PageData reslut = new PageData();
		//查询部门树
		try {
			List<PageData> datas = new ArrayList<PageData>();
			List<PageData> deptList = deptService.listAll(null);
			for(int i=0; i<deptList.size(); i++){
				PageData dept = new PageData();
				dept.put("nocheck", true);
				dept.put("name", deptList.get(i).get("DEPT_NAME"));
				dept.put("id", deptList.get(i).get("ID"));
				dept.put("pId", deptList.get(i).get("PARENT_ID"));
				datas.add(dept);
			}
			
			//岗位
			for(PageData dept : deptList){
				List<PageData> posList = positionLevelService.findPositionTreeByDeptId(dept);
				for(int i=0; i<posList.size(); i++){
					PageData pos = new PageData();
					pos.put("name", posList.get(i).get("DEPT_NAME"));
					pos.put("id", "pos_" + posList.get(i).get("ID"));
					pos.put("pId", posList.get(i).get("PARENT_ID"));
					datas.add(pos);
				}
			}
			
			reslut.put("datas", datas);
			reslut.put("result", "1");
			reslut.put("msg", "获取数据完成");
		} catch (Exception e) {
			logger.error("11", e);
			reslut.put("result", "0");
			reslut.put("msg", "获取数据出错");
		}
		return reslut;
	}
	
	/**
	 * 检查文件是否存在
	 */
	public boolean isFileExists(String uploadFilePath, String fileFullName){
		String filePath = uploadFilePath + "/" + fileFullName;
		File f = new File(filePath);
		return f.exists();
	}
	
	/**
	 * 获取模块维护类型的列表
	 */
	public PageData getconfigPageType(String typeCode, String typeName){
		PageData pd = new PageData();
		pd.put("typeCode", typeCode);
		pd.put("typeName", typeName);
		return pd;
	}
}
