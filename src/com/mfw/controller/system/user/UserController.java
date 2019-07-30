package com.mfw.controller.system.user;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.crypto.hash.SimpleHash;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.druid.sql.visitor.functions.Trim;
import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.Role;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.system.menu.MenuService;
import com.mfw.service.system.role.RoleService;
import com.mfw.service.system.user.UserService;
import com.mfw.util.AppUtil;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.GetPinyin;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.ObjectExcelView;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;

import net.sf.json.JSONArray;

/**
 * 用户管理
 * @author  作者 于亚洲
 * @date 创建时间：2014年7月30日 下午15:16:29
 */
@Controller
@RequestMapping(value = "/user")
public class UserController extends BaseController {

	@Resource(name = "userService")
	private UserService userService;
	@Resource(name = "roleService")
	private RoleService roleService;
	@Resource(name = "menuService")
	private MenuService menuService;
	@Resource(name = "deptService")
	private DeptService deptService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;

	/**
	 * 保存用户
	 */
	@RequestMapping(value = "/saveU")
	public ModelAndView saveU(PrintWriter out) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		pd.put("USER_ID", this.get32UUID()); //ID
		pd.put("RIGHTS", ""); //权限
		pd.put("LAST_LOGIN", ""); //最后登录时间
		pd.put("IP", ""); //IP
		pd.put("STATUS", "0"); //状态
		pd.put("SKIN", "default"); //默认皮肤

		pd.put("PASSWORD", 
				new SimpleHash("SHA-1", pd.getString("USERNAME"), 
				pd.getString("PASSWORD")).toString());

		if (null == userService.findByUId(pd)) {
			userService.saveU(pd);
			mv.addObject("msg", "success");
		} else {
			mv.addObject("msg", "failed");
		}
		mv.setViewName("save_result");
		return mv;
	}

	/**
	 * 判断用户名是否存在
	 */
	@RequestMapping(value = "/hasU")
	public void hasU(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			if (userService.findByUId(pd) != null) {
				out.write("error");
			} else {
				out.write("success");
			}
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

	}

	/**
	 * 判断邮箱是否存在
	 */
	@RequestMapping(value = "/hasE")
	public void hasE(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();

			if (userService.findByUE(pd) != null) {
				out.write("error");
			} else {
				out.write("success");
			}
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

	}

	/**
	 * 判断编码是否存在
	 */
	@RequestMapping(value = "/hasN")
	public void hasN(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();

			if (userService.findByUN(pd) != null) {
				out.write("error");
			} else {
				out.write("success");
			}
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

	}

	/**
	 * 修改用户
	 */
	@RequestMapping(value = "/editU")
	public ModelAndView editU(PrintWriter out) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		if (pd.getString("PASSWORD") != null && !"".equals(pd.getString("PASSWORD"))) {
			pd.put("PASSWORD", new SimpleHash("SHA-1", pd.getString("USERNAME"), pd.getString("PASSWORD")).toString());
		}
		userService.editU(pd);
		mv.addObject("msg", "success");
		mv.setViewName("save_result");
		return mv;
	}

	/**
	 * 去修改用户页面
	 */
	@RequestMapping(value = "/goEditU")
	public ModelAndView goEditU() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		//顶部修改个人资料
		String fx = pd.getString("fx");

		//System.out.println(fx);

		if ("head".equals(fx)) {
			mv.addObject("fx", "head");
		} else {
			mv.addObject("fx", "user");
		}
		pd = userService.findByUiId(pd); //根据ID读取
		pd.put("ENABLED", 1);
		List<PageData> numbers = employeeService.findEmpNotInUser(pd);
		PageData pageData = new PageData();
		pageData.put("EMP_CODE", pd.get("NUMBER"));
		numbers.add(pageData);
		
		List<Role> roleList = roleService.listAllERRoles(); //列出所有二级角色
		List<PageData> deptList = deptService.listAlln(); //列出所有部门
		mv.setViewName("system/user/user_edit");
		mv.addObject("msg", "editU");
		mv.addObject("numbers", numbers);
		mv.addObject("pd", pd);
		mv.addObject("roleList", roleList);
		mv.addObject("deptList", deptList);

		return mv;
	}

	/**
	 * 去新增用户页面
	 */
	@RequestMapping(value = "/goAddU")
	public ModelAndView goAddU() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd.put("ENABLED", 1);
		List<PageData> numbers = employeeService.findEmpNotInUser(pd);
		List<Role> roleList  = roleService.listAllERRoles(); //列出所有二级角色
		
		mv.setViewName("system/user/user_edit");
		mv.addObject("msg", "saveU");
		mv.addObject("roleList", roleList);
		mv.addObject("numbers", numbers);
		mv.addObject("pd", pd);

		return mv;
	}

	/**
	 * 显示用户列表(用户组)
	 */
	@RequestMapping(value = "/listUsers")
	public ModelAndView listUsers(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		page.setPd(pd);
		//List<PageData> userList = userService.listPdPageUser(page); //列出用户列表
		List<Role> roleList = roleService.listAllERRoles(); //列出所有二级角色
		List<PageData> deptList = deptService.listAlln();//列出所有部门

		/* 调用权限 */
		this.getHC(); //================================================================================
		/* 调用权限 */
		
		Object deptid = pd.get("DEPT_ID");
		JSONArray arr = JSONArray.fromObject(deptList);
		if(deptid != null && !deptid.equals("")){
			PageData data = new PageData();
			data.put("ID", deptid);
			pd.put("deptIds", deptid);
			pd.put("deptNames", deptService.findById(data).get("DEPT_NAME"));
		}
		mv.setViewName("system/user/user_list");
		//mv.addObject("userList", userList);
		mv.addObject("roleList", roleList);
		mv.addObject("deptList", deptList);
		mv.addObject("deptTreeNodes", arr.toString());
		mv.addObject("pd", pd);
		mv.addObject("userRole", getUserRole());

		return mv;
	}
	
	@ResponseBody
	@RequestMapping(value="/userList")
	public GridPage findList(Page page, HttpServletRequest request){
		convertPage(page, request);
		List<PageData> userList = new ArrayList<>();
		try {
			userList = userService.listPdPageUser(page); //列出用户列表
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new GridPage(userList, page);
	}
	

	/**
	 * 显示用户列表(tab方式)
	 */
	@RequestMapping(value = "/listtabUsers")
	public ModelAndView listtabUsers(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		List<PageData> userList = userService.listAllUser(pd); //列出用户列表

		/* 调用权限 */
		this.getHC(); //================================================================================
		/* 调用权限 */

		mv.setViewName("system/user/user_tb_list");
		mv.addObject("userList", userList);
		mv.addObject("pd", pd);

		return mv;
	}

	/**
	 * 删除用户
	 */
	@RequestMapping(value = "/deleteU")
	public void deleteU(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			userService.deleteU(pd);
			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

	}

	/**
	 * 批量删除
	 */
	@RequestMapping(value = "/deleteAllU")
	@ResponseBody
	public Object deleteAllU() {
		PageData pd = new PageData();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			pd = this.getPageData();
			List<PageData> pdList = new ArrayList<PageData>();
			Object obj = pd.get("USER_IDS[]");
			String USER_IDS = obj.toString();

			if (null != USER_IDS && !"".equals(USER_IDS)) {
				String ArrayUSER_IDS[] = USER_IDS.split(",");
				userService.deleteAllU(ArrayUSER_IDS);
				pd.put("msg", "ok");
			} else {
				pd.put("msg", "no");
			}

			pdList.add(pd);
			map.put("list", pdList);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} finally {
			logAfter(logger);
		}
		return AppUtil.returnObject(pd, map);
	}

	//===================================================================================================

	/*
	 * 导出用户信息到EXCEL
	 * @return
	 */
	@RequestMapping(value = "/excel")
	public ModelAndView exportExcel() {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {

			//检索条件===
			String USERNAME = pd.getString("USERNAME");
			if (null != USERNAME && !"".equals(USERNAME)) {
				USERNAME = USERNAME.trim();
				pd.put("USERNAME", USERNAME);
			}
			//检索条件===

			Map<String, Object> dataMap = new HashMap<String, Object>();
			String fileTile = "用户资料";
			dataMap.put("fileTile", fileTile);
			List<String> titles = new ArrayList<String>();

			titles.add("用户名"); //1
			titles.add("员工编号"); //2
			titles.add("姓名"); //3
			titles.add("部门");
			titles.add("系统角色"); //4
			//titles.add("手机"); //5
			//titles.add("邮箱"); //6
			titles.add("备注");
			titles.add("最近登录"); //7
			titles.add("上次登录IP"); //8

			dataMap.put("titles", titles);

			List<PageData> userList = userService.listAllUser(pd);
			List<PageData> varList = new ArrayList<PageData>();
			for (int i = 0; i < userList.size(); i++) {
				PageData vpd = new PageData();
				int index = 0;
				String fieldName = "var";
				vpd.put(fieldName + ++index, userList.get(i).getString("USERNAME"));
				vpd.put(fieldName + ++index, userList.get(i).getString("NUMBER"));
				vpd.put(fieldName + ++index, userList.get(i).getString("NAME"));
				vpd.put(fieldName + ++index, userList.get(i).getString("DEPT_NAME"));
				vpd.put(fieldName + ++index, userList.get(i).getString("ROLE_NAME"));
//				vpd.put(fieldName + ++index, userList.get(i).getString("PHONE"));
//				vpd.put(fieldName + ++index, userList.get(i).getString("EMAIL"));
				vpd.put(fieldName + ++index, userList.get(i).getString("BZ"));
				vpd.put(fieldName + ++index, userList.get(i).getString("LAST_LOGIN"));
				vpd.put(fieldName + ++index, userList.get(i).getString("IP")); 
				varList.add(vpd);
			}

			dataMap.put("varList", varList);

			ObjectExcelView erv = new ObjectExcelView(); //执行excel操作

			mv = new ModelAndView(erv, dataMap);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 打开上传EXCEL页面
	 */
	@RequestMapping(value = "/goUploadExcel")
	public ModelAndView goUploadExcel() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("system/user/uploadexcel");
		return mv;
	}

	/**
	 * 下载模版
	 */
	@RequestMapping(value = "/downExcel")
	public void downExcel(HttpServletResponse response) throws Exception {

		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "Users.xls", "Users.xls");

	}

	/**
	 * 从EXCEL导入到数据库
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/readExcel")
	public ModelAndView readExcel(@RequestParam(value = "excel", required = false) MultipartFile file) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			if (null != file && !file.isEmpty()) {
				String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
				String fileName = FileUpload.fileUp(file, filePath, "userexcel"); //执行上传
				List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 2, 0, 0); //执行读EXCEL操作,读出的数据导入List 2:从第3行开始；0:从第A列开始；0:第0个sheet
				String result = "";
				//var0 :用户名， var1 :员工编号， var2 :姓名， var3: 部门，var4 :系统角色  var5:备注  //var5 :手机， var6:邮箱
				int count = 0;
				for (int i = 0; i < listPd.size(); i++) {
					String rowCheck = "第" + (i+3) + "行：";
					//验证员工编号
					String num = listPd.get(i).getString("var1");
					PageData empPd = new PageData();
					empPd.put("EMP_CODE", num);
					//查询数据库中的员工信息
					PageData emp = employeeService.findByCode(empPd);
					if(null == emp){
						result += rowCheck + num + " 员工编号不存在，";
						continue;
					}
					//验证员工编号是否已绑定用户
					PageData checkCodeParam = new PageData();
					checkCodeParam.put("NUMBER",num);
					if (userService.findByUN(checkCodeParam) != null) {
						result += rowCheck + num + " 员工编号已绑定用户，";
						continue;
					}
					
					//获取用户名
					/*
					String USERNAME = GetPinyin.getPingYin(listPd.get(i).getString("var0")); //根据姓名汉字生成全拼
					PageData checkUserNameParam = new PageData();
					checkUserNameParam.put("USERNAME",USERNAME);
				
					if (userService.findByUId(checkUserNameParam) != null) { //判断用户名是否重复
						USERNAME = GetPinyin.getPingYin(USERNAME) + Tools.getRandomNum();
					}
					*/
					String USERNAME = listPd.get(i).getString("var0");
					PageData checkUserNameParam = new PageData();
					checkUserNameParam.put("USERNAME",USERNAME);
					if (userService.findByUId(checkUserNameParam) != null) { //判断用户名是否重复
						result += rowCheck + USERNAME + " 用户名已存在，";
						continue;
					}
					
					//获取角色ID
					String roleId = roleService.findRoleIdByName(listPd.get(i).getString("var4"));
					if(roleId.isEmpty()){
						result += rowCheck + listPd.get(i).getString("var4") + " 系统角色不存在，";
						continue;
					}
					//获取部门ID
					String deptName = listPd.get(i).getString("var3");
					String deptId = deptService.findIdByName(deptName);
					if(null == deptId){
						result += rowCheck + deptName + " 部门不存在，";
						continue;
					}
					
					pd.put("USER_ID", this.get32UUID()); //ID
					pd.put("USERNAME", USERNAME);
					pd.put("PASSWORD", new SimpleHash("SHA-1", USERNAME, "123").toString());//默认密码123
					pd.put("NAME", listPd.get(i).getString("var2")); //姓名
					pd.put("RIGHTS", ""); //权限
					pd.put("ROLE_ID", roleId);
					pd.put("DEPT_ID", deptId);
					pd.put("DEPT_NAME", deptName);
					pd.put("STATUS", "0"); //状态
					pd.put("BZ", listPd.get(i).getString("var5")); //备注
					pd.put("SKIN", "default"); //默认皮肤
					pd.put("NUMBER", num); //编号已存在就跳过
					pd.put("EMAIL", emp.get("EMP_EMAIL")); //邮箱
					pd.put("PHONE", emp.get("EMP_PHONE")); //手机号
					//pd.put("EMAIL", listPd.get(i).getString("var6"));
					//pd.put("PHONE", listPd.get(i).getString("var5")); //手机号
					userService.saveU(pd);
					count++;
				}
				result += " 成功导入" + count + "条记录";
				mv.addObject("msg", "importSysUserSuccess");
				mv.addObject("result", result);
			}
		} catch (Exception e) {
			mv.addObject("msg", "failed");
			e.printStackTrace();
		}
		mv.setViewName("save_result");
		return mv;
	}

}
