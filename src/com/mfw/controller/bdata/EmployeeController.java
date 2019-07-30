package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.time.DateUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.entity.system.UserLog;
import com.mfw.entity.system.UserLog.LogType;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.KpiModelLineService;
import com.mfw.service.bdata.KpiModelService;
import com.mfw.service.bdata.PositionLevelService;
import com.mfw.service.system.UserLogService;
import com.mfw.service.system.datarole.DataRoleService;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.ObjectExcelView;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;
import com.mfw.util.UserUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 基础数据-通用基础数据-员工管理
 * @author  作者  蒋世平
 * @date 创建时间：2015年12月11日 下午17:02:31
 */
@Controller
@RequestMapping(value = "/employee")
public class EmployeeController extends BaseController {
	
	@Resource(name="userLogService")
	private UserLogService userlogService;
	
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name="kpiModelService")
	private KpiModelService kpiModelService;
	@Resource(name="kpiModelLineService")
	private KpiModelLineService kpiModelLineService;
	@Resource(name="deptService")
	private DeptService deptService;
	@Resource(name="positionLevelService")
	private PositionLevelService positionLevelService;//岗位
	@Resource(name="commonService")
	private CommonService commonService;
//	@Resource(name="userService")
//	private UserService userService;
	@Resource(name="dataroleService")
	private DataRoleService dataroleService;
	
	/**
	 * 员工列表
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) {
		logBefore(logger, "查询Employee列表");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			page.setPd(pd);
			//只查询有效的员工数量
			pd.put("ENABLED", 1);
			List<PageData> varList = deptService.listAll(pd); //列出Dept列表
			for(int i=0;i<varList.size();i++){
				varList.get(i).put("eNum", getENum(varList.get(i)));
				if(Integer.valueOf(varList.get(i).get("ENABLED").toString())==0){
					varList.get(i).put("DEPT_NAME", varList.get(i).get("DEPT_NAME").toString()+"(未启用)");
				}
			}
			JSONArray arr = JSONArray.fromObject(varList); //Dept列表转为ztree可识别的类型
			
			mv.addObject("deptTreeNodes", arr.toString());
			mv.addObject("varList", varList);
			mv.addObject("page", page);
			mv.setViewName("bdata/employee/employee_list");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	@ResponseBody
	@RequestMapping(value = "/empList")
	public GridPage employeeList(Page page, HttpServletRequest request){
		List<PageData> empList = new ArrayList<>();
		try {
			convertPage(page, request);
			PageData pageData = page.getPd();
			
			if(null == pageData.get("ID") || pageData.getString("ID").isEmpty()){
				empList = employeeService.listPageEmp(page);
			}else{
				List<String> ids = deptService.finIdsByPid(pageData.get("ID").toString());
				ids.add(pageData.get("ID").toString());
				
				pageData.put("ids", ids);
				page.setPd(pageData);
				empList = employeeService.listPageEmp(page);
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(empList, page);
	}
	
	/**
	 * 员工列表检索
	 */
	@RequestMapping(value = "/listSearch")
	public ModelAndView listSearch(Page page) {
		logBefore(logger, "查询Employee列表");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			page.setPd(pd);
			//查询employee列表
			List<PageData> empList = employeeService.listAll(pd);
			//List<PageData> empList = employeeService.listPageEmp(page);
			//根据ID获取
			pd = employeeService.findById(pd);
			
			mv.addObject("empList", empList);
			mv.addObject("page", page);
			mv.setViewName("bdata/employee/employee_list");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/**
	 * 订单成员组成信息员工检索
	 */
	@RequestMapping(value = "/labourSearch")
	public ModelAndView labourSearch(Page page, String orderId) {
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			page.setPd(pd);
			
			//查询已经添加的员工
			/*logBefore(logger, "查询已经添加的员工");
			List<String> labourList = projectOrderLabourService.listEmpId(orderId);
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("labourList", labourList);
			map.put("pd", pd);*/
			
			//查询未添加的employee列表
			logBefore(logger, "查询未添加的employee列表");
			List<PageData> empList = employeeService.listAllLabour(pd);
			
			//根据ID获取
			pd = employeeService.findById(pd);
			//查询分成方式列表
			List<PageData> shareTypeList = commonService.typeListByBm("FCFS");
			logBefore(logger, "查询已添加部门列表");
			List<PageData> deptList = deptService.findScaleDept(orderId);
			
			mv.addObject("empList", empList);
			mv.addObject("deptList", deptList);
			mv.addObject("shareTypeList", shareTypeList);
			mv.addObject("orderId", orderId);
			mv.addObject("page", page);
			mv.setViewName("order/projectOrderLabourAdd");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/**
	 * 新增员工页面跳转
	 */
	@RequestMapping(value = "/goAddEmp")
	public ModelAndView goAdd() throws Exception {
		logBefore(logger, "新增Employee页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			List<PageData> kpiModelList = kpiModelService.listAllEnable(pd);
			List<PageData> deptList = deptService.listAll(pd);
			JSONArray arr = JSONArray.fromObject(deptList);

			mv.addObject("msg", "save");
			mv.addObject("pd", pd);
			mv.addObject("kpiModelList", kpiModelList);
			mv.addObject("deptList", deptList);
			mv.addObject("deptTreeNodes", arr.toString());
			mv.setViewName("bdata/employee/employee_edit");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}
	
	/**
	 * 员工新增验证
	 */
	@RequestMapping(value = "/checkEmployee")
	public void checkEmployee(String empCode, String msg, String id, PrintWriter out){
		try{
			PageData pd = new PageData();
			pd.put("EMP_CODE", empCode);
			
			logBefore(logger, "bd_employee表新增验证");
			if(msg == "save"){	//新增
				PageData empData  = employeeService.findByCode(pd);
				//判断用户所填code是否重复
				if(null == empData){
					out.write("true");
				}else{
					out.write("false");
				}
			}else{	//修改
				pd.put("ID", id);
				//原有数据
				PageData emp = employeeService.findById(pd);
				//修改后的数据
				PageData empData  = employeeService.findByCode(pd);
				if(null != empData && empData.getString("EMP_CODE").equals(emp.getString("EMP_CODE"))){	//用户没有修改编号
					out.write("true");
				}else if(null != empData && !empData.getString("EMP_CODE").equals(emp.getString("EMP_CODE"))){//用户修改后的编号与原有编号重复
					out.write("false");
				}else if(null == empData){	//用户修改后的编号为唯一
					out.write("true");
				}
			}
			
		} catch(Exception e){
			logger.error(e.toString(), e);
		} finally{
			out.flush();
			out.close();
		}
	}
	
	/**
	 * 新增员工
	 */
	@RequestMapping(value = "/save")
	public ModelAndView save() throws Exception {
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			//获取岗位名称
			if(null != pd.get("EMP_GRADE_ID") && !"".equals(pd.getString("EMP_GRADE_ID").toString())){
				int gradeId = Integer.parseInt(pd.get("EMP_GRADE_ID") + "");
				PageData levelData = new PageData();
				levelData.put("id", gradeId);
				logBefore(logger, "查询岗位级别名称");
				levelData = positionLevelService.findById(levelData);
				pd.put("EMP_GRADE_NAME", levelData.get("GRADE_NAME"));
			}
			//获取上级领导名称
			if(null != pd.get("LEADER_EMPCODE") && !pd.getString("LEADER_EMPCODE").isEmpty()){
				PageData leaderEmp = new PageData();
				leaderEmp.put("EMP_CODE", pd.get("LEADER_EMPCODE"));
				leaderEmp = employeeService.findByCode(leaderEmp);
				pd.put("LEADER_EMPNAME", leaderEmp.get("EMP_NAME"));
			}
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//创建人
			pd.put("CREATE_TIME", Tools.date2Str(new Date()));						//创建时间
			pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));//最后修改人
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));					 //最后更改时间
			
			logBefore(logger, "新增Employee");
			employeeService.save(pd);
			
			List<PageData> deptList = deptService.listAll(pd);
			JSONArray arr = JSONArray.fromObject(deptList);
			mv.addObject("deptTreeNodes", arr.toString());
			
			mv.addObject("editFlag", "saveSucc");
			mv.setViewName("save_result");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
//	/**
//	 * 删除
//	 */
//	@RequestMapping(value = "/delete")
//	public void delete(PrintWriter out) {
//		logBefore(logger, "删除Employee");
//		PageData pd = new PageData();
//		try {
//			pd = this.getPageData();
//			employeeService.delete(pd);
//			out.write("success");
//			out.close();
//		} catch (Exception e) {
//			logger.error(e.toString(), e);
//		}
//	}
	
	/**
	 * 修改员工页面跳转
	 */
	@RequestMapping(value="/goEditEmp",produces = "text/html;charset=UTF-8")
	public ModelAndView goEdit(HttpServletResponse response){
		logBefore(logger, "修改Employee页面跳转");
		ModelAndView mv = this.getModelAndView();
		PageData emp = new PageData();
		emp = this.getPageData();
		try {
			emp = employeeService.findById(emp);
			//List<PageData> kpiModelList = kpiModelService.listAllEnable(emp);
			List<PageData> deptList = deptService.listAll(emp);
			JSONArray arr = JSONArray.fromObject(deptList);
			
			//查询该员工所属部门下的岗位列表
			String deptId = emp.get("EMP_DEPARTMENT_ID") + "";
			List<PageData> levelList = positionLevelService.findLevelByDeptId(deptId);
			
			mv.addObject("msg", "edit");
			mv.addObject("emp", emp);
			mv.addObject("deptList", deptList);
			mv.addObject("levelList", levelList);
			//mv.addObject("kpiModelList", kpiModelList);
			mv.addObject("deptTreeNodes", arr.toString());
			mv.setViewName("bdata/employee/employee_edit");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}						
		return mv;
	}
	
	/**
	 * 修改员工
	 */
	@RequestMapping(value = "/edit")
	public ModelAndView edit() throws Exception {
		logBefore(logger, "修改Employee");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			//获取岗位名称
			if(null != pd.get("EMP_GRADE_ID") && !"".equals(pd.getString("EMP_GRADE_ID").toString())){
				int gradeId = Integer.parseInt(pd.get("EMP_GRADE_ID") + "");
				PageData levelData = new PageData();
				levelData.put("id", gradeId);
				logBefore(logger, "查询岗位级别名称");
				levelData = positionLevelService.findById(levelData);
				if(null != levelData){
					pd.put("EMP_GRADE_NAME", levelData.get("GRADE_NAME"));
				}
			}
			//获取上级领导名称
			if(null != pd.get("LEADER_EMPCODE") && !pd.getString("LEADER_EMPCODE").isEmpty()){
				PageData leaderEmp = new PageData();
				leaderEmp.put("EMP_CODE", pd.get("LEADER_EMPCODE"));
				leaderEmp = employeeService.findByCode(leaderEmp);
				pd.put("LEADER_EMPNAME", leaderEmp.get("EMP_NAME"));
			}
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));						//最后更改时间
			//执行修改Employee
			employeeService.editEmpInfo(pd);

			List<PageData> deptList = deptService.listAll(pd);
			JSONArray arr = JSONArray.fromObject(deptList);
			mv.addObject("deptTreeNodes", arr.toString());
			mv.addObject("editFlag", "updateSucc");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}
	
	/**
	 * 点击模板列表查询
	 */
	@RequestMapping(value = "/modelDetail",produces = "text/html;charset=UTF-8")
	public void modelDetail(@RequestParam String ID, HttpServletResponse response) throws Exception {
		PageData pd = new PageData();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			pd = this.getPageData();
			pd.put("ID", ID);
			List<Object> list = new ArrayList<Object>();
			
			logBefore(logger, "点击模板列表查询");
			pd = kpiModelService.findById(pd);
			list = kpiModelLineService.listAllByModelId(ID);
			map.put("list", list);
			map.put("pd", pd);
			JSONObject jo = JSONObject.fromObject(map);
			String json = jo.toString();
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(json);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} 
		
	}
	
	/**
	 * 获取所选部门信息
	 */
	@RequestMapping(value = "/findDeptById",produces = "text/html;charset=UTF-8")
	public void findDeptById(@RequestParam String ID, HttpServletResponse response) throws Exception {
		logBefore(logger, "查询department");
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			pd.put("ID", ID);
			//根据ID获取
			pd = deptService.findById(pd);
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(pd.getString("DEPT_NAME"));
			out.flush();
			out.close();
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
	}
	
	/**
	 * 根据所选部门查询岗位
	 */
	@RequestMapping(value = "/findLevelByDeptId", produces = "text/html;charset=UTF-8")
	public void findLevelByDeptId(@RequestParam String deptId, HttpServletResponse response) throws Exception {
		logBefore(logger, "根据所选部门查询岗位");
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			//根据ID获取
			List<PageData> levelList = positionLevelService.findLevelByDeptId(deptId);
			
			map.put("list", levelList);
			JSONObject jo = JSONObject.fromObject(map);
			String json = jo.toString();
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(json);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
	}
	
	/**
	 * 根据所选岗位查询KPI模板
	 */
	@RequestMapping(value = "/findLevelKpi", produces = "text/html;charset=UTF-8")
	public void findLevelKpi(@RequestParam String kpiModelId, HttpServletResponse response) throws Exception {
		logBefore(logger, "根据所选岗位查询KPI模板ID");
		try {
			//根据ID获取
			PageData levelKpi = positionLevelService.findById2(kpiModelId);
			
			String levelKpiModelId = "";
			levelKpiModelId = levelKpi.get("ATTACH_KPI_MODEL") + "";
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(levelKpiModelId);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
	}
	
	/**
	 * 根据所选责任部门查询员工
	 */
	@RequestMapping(value = "/findEmpByDept", produces = "text/html;charset=UTF-8")
	public void findEmpByDept(HttpServletResponse response) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			PageData  reqpd = this.getPageData();
			logBefore(logger, "根据所选责任部门查询员工");
			//List<PageData> empList = employeeService.findEmpByDept(deptId);
			PageData searchPd = new PageData();
			searchPd.put("isService", reqpd.get("isService"));
			searchPd.put("deptId", reqpd.get("deptId"));
			List<PageData> empList = employeeService.findAllEmpByDept(searchPd);
			//查询是否为部门负责人
			PageData pd = new PageData();
			pd.put("ID", reqpd.get("deptId"));
			pd = deptService.findById(pd);
			for (PageData pageData : empList) {
				if(pageData.get("ID").equals(pd.get("DEPT_LEADER_ID"))){
					pageData.put("leader", true);
					break;
				}
			}
			
			map.put("list", empList);
			JSONObject jo = JSONObject.fromObject(map);
			String json = jo.toString();
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(json);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
	}
	
	/**
	 * 根据员工编号查询员工信息
	 * @param code
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findEmpByCode")
	public PageData findEmpByCode(String code){
		PageData result = new PageData();
		try {
			PageData pageData = new PageData();
			pageData.put("EMP_CODE", code);
			result = employeeService.findByCode(pageData);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 打开上传EXCEL页面（档案）
	 */
	@RequestMapping(value = "/goUploadExcelRecord")
	public ModelAndView goUploadExcelRecord() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/employee/recordLoadexcel");
		return mv;
	}
	
	/**
	 * 下载模版（档案）
	 */
	@RequestMapping(value = "/downExcelRecord")
	public void downExcelRecord(HttpServletResponse response) throws Exception {
		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "EmpRecord.xls", "EmpRecord.xls");
	}
	
	/**
	 * 导入员工额外信息
	 */
	@ResponseBody
	@RequestMapping(value = "uploadEmpOtherInfoExcel", produces = "application/json;charset=UTF-8")
	public String uploadEmpOtherInfoExcel(@RequestParam(value = "excel", required = false) MultipartFile file,
			HttpServletRequest request){
		//上传文件
		if (null == file || file.isEmpty()) {//没有文件
			return Const.NO_FILE;
		}
		//处理文件
		return employeeService.importEmpOtherInfoExcel(file, "EmpOtherInfoExcel", getUser());
	}
	
	/**
	 * 从EXCEL导入到数据库（档案）
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/readExcelRecord")
	public ModelAndView readExcelRecord(@RequestParam(value = "excel", required = false) MultipartFile file,HttpServletRequest request) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		PageData pdm = new PageData();
		PageData pdc = new PageData();
		if (null != file && !file.isEmpty()) {
			try {
				User user = getUser();
				String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
				String fileName = FileUpload.fileUp(file, filePath, "modelexcel"); //执行上传
				
				//执行读EXCEL操作,读出的数据导入List 1:从第2行开始；0:从第A列开始；0:第1个sheet
				List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 1, 0, 0);	//基础信息
				
				//执行读EXCEL操作,读出的数据导入List 1:从第2行开始；0:从第A列开始；0:第2个sheet
				List<PageData> exp = (List) ObjectExcelRead.readExcel(filePath, fileName, 1, 0, 1);		//工作经历
//				String msg = "";
				//var0:第一列      var1:第二列    varN:第N+1列
				for (int i = 1; i < listPd.size(); i++) {
					if(listPd.get(i).getString("var0")==""||listPd.get(i).getString("var0")==null
							//||listPd.get(i).getString("var2")==""||listPd.get(i).getString("var2")==null
							//||listPd.get(i).getString("var3")==""||listPd.get(i).getString("var3")==null
							//||listPd.get(i).getString("var4")==""||listPd.get(i).getString("var4")==null
							//||listPd.get(i).getString("var5")==""||listPd.get(i).getString("var5")==null
							//||listPd.get(i).getString("var6")==""||listPd.get(i).getString("var6")==null
					){
						mv.addObject("msg", "基础数据-第"+(i+2)+"行未填写员工编码，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
					
					/* 检验编码对应员工是否存在================================= */
					pdc.put("EMP_CODE", listPd.get(i).getString("var0"));
					PageData result = employeeService.findByCode(pdc);
					if(result == null){
						logger.error("第"+(i+2)+"行员工的编码"+ listPd.get(i).getString("var0") +"不存在，请检查后再导入");
						mv.addObject("msg", "第"+(i+2)+"行员工的编码不存在，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}

					Date birthDate = null;
					Date graduateDate  = null;
					try {
						String var2 = listPd.get(i).getString("var2");
						String var6 = listPd.get(i).getString("var6");
						Calendar c = new GregorianCalendar(1900,0,-1);
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy/M/d");
						SimpleDateFormat dateSdf = new SimpleDateFormat("yyyy-M-d");
						SimpleDateFormat pointDateSdf = new SimpleDateFormat("yyyy.MM.dd");
						if(var2.contains("/")){
							birthDate = sdf.parse(var2);
						}else if(var2.contains("-")){
							birthDate = dateSdf.parse(var2);
						}else if(var2.contains(".")){
							birthDate = pointDateSdf.parse(var2);
						}else{
							Date d = c.getTime();
							int days =  Integer.valueOf(var2);
							birthDate = DateUtils.addDays(d, days);
						}
						//毕业时间
						if(!var6.isEmpty()){
							if(var6.contains("/")){
								graduateDate = sdf.parse(var6);
							}else if(var6.contains("-")){
								graduateDate = dateSdf.parse(var6);
							}else if(var6.contains(".")){
								graduateDate = pointDateSdf.parse(var6);
							}else{
								Date d = c.getTime();
								int days =  Integer.valueOf(var6);
								graduateDate = DateUtils.addDays(d, days);
							}
						}
						
					} catch (Exception e) {
						logger.error("第"+(i+2)+"行记录的日期格式错误", e);
						//mv.addObject("msg", "第"+(i+2)+"行记录的日期格式错误，请检查后再导入");
						//mv.setViewName("save_result");
						//return mv;
					}
					pd.put("EMP_ID", result.get("ID"));	
					pd.put("NAME", result.get("EMP_NAME"));
					pd.put("GENDER", result.get("EMP_GENDER"));	
					pd.put("PHONE", result.get("EMP_PHONE"));
					pd.put("EMAIL", result.get("EMP_EMAIL"));
					pd.put("BIRTHDAY", birthDate);
//					pd.put("AGE", listPd.get(i).getString("var3"));
					pd.put("ADDRESS", listPd.get(i).getString("var3"));
					pd.put("SCHOOL", listPd.get(i).getString("var4"));
					pd.put("MAJOR", listPd.get(i).getString("var5"));
					pd.put("GRADUATE_TIME",graduateDate);
					pd.put("GRADUATE_TIME_TEXT", listPd.get(i).getString("var6"));
					pd.put("DEGREE", listPd.get(i).getString("var7"));
					pd.put("UPDATE_USER", user.getUSERNAME());
					PageData pdkData = employeeService.findRecord(pd);	//是否已有员工档案
					if(pdkData != null){
						employeeService.editRecord(pd);
					}else{
						employeeService.saveRecord(pd);
					}				
				}
				
				//var0:第一列      var1:第二列    varN:第N+1列
				for (int i = 1; i < exp.size(); i++) {
					if(exp.get(i).getString("var0")==""||exp.get(i).getString("var0")==null||exp.get(i).getString("var2")==""||exp.get(i).getString("var2")==null
							||exp.get(i).getString("var3")==""||exp.get(i).getString("var3")==null)
					{
						mv.addObject("msg", "第"+(i+2)+"行的工作经历数据不全，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
					
					/* 检验编码对应员工是否存在================================= */

					pdc.put("EMP_CODE", exp.get(i).getString("var0"));
					PageData result = employeeService.findByCode(pdc);
					if(result == null){
						mv.addObject("msg", "工作经历-"+(i+2)+"行条员工的编码不存在，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
					pdm.put("EMP_ID", result.get("ID"));	
					pdm.put("EXP", exp.get(i).getString("var2"));
					pdm.put("POSITION", exp.get(i).getString("var3"));

					employeeService.deleteAllExp(pdc);					//清空原有经历				
					employeeService.saveExp(pdm);						//导入Excel中的经历
				}
					
				mv.addObject("msg", "success");
			} catch (Exception e) {
				logger.error("导入档案出错", e);
				mv.addObject("msg", "failed");
			}
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 获取部门人数
	 */
	public int getENum(PageData p){
		//只查询有效的员工数量
		p.put("ENABLED", 1);
		int eNum = 0;
		try {
			eNum = Integer.valueOf(deptService.getENum(p).get("eNum").toString());
			List<PageData> childList = deptService.listChild(p);
			for(int j=0;j<childList.size();j++){
				 eNum +=getENum(childList.get(j));				
			}
		}catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return eNum;
	}
	
	//员工档案添加或修改
    @RequestMapping(value="/record")
    public ModelAndView record() throws Exception{
        logBefore(logger, "员工档案");
        ModelAndView mv = this.getModelAndView();
        PageData pd = this.getPageData();
        try {
        	//修改员工工作经历
        	if(null != pd.get("ID")){
        		String[] ids = pd.getString("ID").split(",",-1);
            	String[] update_ids = pd.getString("ID").split(",");
                String[] EXP = pd.getString("EXP").split(",",-1);
                String[] POSITION = pd.getString("POSITION").split(",",-1);
                if(EXP.length == POSITION.length){
                    List<PageData> addList = new ArrayList<PageData>();
                    
                    for(int i = 0;i < EXP.length;i ++){
                        PageData task = new PageData();
                        task.put("EMP_ID",pd.get("EMP_ID"));//员工ID
                        task.put("ID",ids[i]);//ID
                        task.put("EXP",EXP[i]);//工作经历
                        task.put("POSITION",POSITION[i]);//岗位
                        if("".equals(ids[i])){
                            //如果id不存在，那么就是增加
                            addList.add(task);
                        }else {
                            //如果id存在，就是更新
                        	employeeService.batchUpdate(task);
                        }
                    }
    	                
                    //批量删除
                    PageData deletePd = new PageData();
                    deletePd.put("EMP_ID",pd.get("EMP_ID"));
                    if(0 != update_ids.length && !("").equals(update_ids[0])){
                        deletePd.put("update_ids",update_ids);
                    }else {
                        String[] new_update_ids = {"0"};
                        deletePd.put("update_ids",new_update_ids);
                    }
                    employeeService.batchDelete(deletePd);

                    //批量新增
                    if(null != addList && 0 != addList.size()){
                    	employeeService.batchAdd(addList);
                    }
    	
            	}
        	}else{
        		//删除原有的工作经历
        		PageData deletePd = new PageData();
                deletePd.put("EMP_ID",pd.get("EMP_ID"));
        		employeeService.deleteAllExp(deletePd);
        	}
        	
            //没有填写日期数据时
            if(pd.getString("BIRTHDAY").isEmpty()){
            	pd.put("BIRTHDAY", null);
            }
            if(pd.getString("GRADUATE_TIME").isEmpty()){
            	pd.put("GRADUATE_TIME", null);
            }
            pd.put("UPDATE_USER", getUser().getUSERNAME());
        	//修改员工档案信息
            if(pd.getString("RECORD_ID").isEmpty()){
            	//如果没有基础信息，创建
            	employeeService.saveRecord(pd);
            }else{
            	//如果有基础信息，修改
            	employeeService.editRecord(pd);    
            }
            if("Y".equals(pd.getString("editRecord"))){
            	//根据员工ID，更新员工的电话、邮箱、性别信息
                employeeService.updateEmpInfoByRecordEmpId(pd);
                if(!pd.getString("EMP_PHONE").isEmpty() || !pd.getString("EMP_EMAIL").isEmpty()){
                	//根据员工ID，修改对应用户的电话、邮箱、性别信息
                    employeeService.updateSysuserPhoneAndEmailByEmpCode(pd);
                }
            }
            //跳转到编辑档案页面
            mv = goEditEmpRecord(pd.getString("EMP_ID"));
            mv.addObject("flag","success");
        }catch (Exception e){
            logger.error(e.toString(), e);
            //跳转到编辑档案页面
            mv = goEditEmpRecord(pd.getString("EMP_ID"));
            mv.addObject("flag","false");
        }
        
        return mv;
    }
    
    /**
     * 根据职位获取员工
     * @param positionId
     * @return
     */
    @ResponseBody
    @RequestMapping("findEmpByPosition")
    public List<PageData> findEmpByPosition(String positionId){
    	try {
			return employeeService.findEmpByPosition(positionId);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
    }
    
    /**
	 * 更新员工信息
	 */
	@RequestMapping(value = "/goUpdateEmpInfo")
	public ModelAndView goUpdateEmpInfo() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/employee/updateEmpInfo");
		return mv;
	}
    
	/**
	 * 打开上传EXCEL页面
	 */
	@RequestMapping(value = "/goUploadExcel")
	public ModelAndView goUploadExcel() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/employee/employeeLoadExcel");
		return mv;
	}
	/**
	 * 下载模版
	 */
	@RequestMapping(value = "/downExcel")
	public void downExcel(HttpServletResponse response) throws Exception {
		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "Employee.xls", "Employee.xls");
	}
	/**
	 * 从EXCEL导入到数据库
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/readExcel")
	public ModelAndView readExcel(@RequestParam(value = "excel", required = false) MultipartFile file,HttpServletRequest request) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd ;
		PageData pdm = new PageData();
		PageData pdc = new PageData();
		if (null != file && !file.isEmpty()) {
			try {
				String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
				String fileName = FileUpload.fileUp(file, filePath, "modelexcel"); //执行上传
				
				//执行读EXCEL操作,读出的数据导入List 1:从第2行开始；0:从第A列开始；0:第0个sheet
				List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 1, 0, 0);
				
				User user = UserUtils.getUser(request);
				//var0:第一列      var1:第二列    varN:第N+1列
				int countRow = 0;
				for (int i = 1; i < listPd.size(); i++) {
					if(listPd.get(i).getString("var0")==""||listPd.get(i).getString("var0")==null
							||listPd.get(i).getString("var1")==""||listPd.get(i).getString("var1")==null
							||listPd.get(i).getString("var2")==""||listPd.get(i).getString("var2")==null
							||listPd.get(i).getString("var3")==""||listPd.get(i).getString("var3")==null
							||listPd.get(i).getString("var4")==""||listPd.get(i).getString("var4")==null
//							||listPd.get(i).getString("var5")==""||listPd.get(i).getString("var5")==null
//							||listPd.get(i).getString("var6")==""||listPd.get(i).getString("var6")==null
							||listPd.get(i).getString("var7")==""||listPd.get(i).getString("var7")==null
							||listPd.get(i).getString("var8")==""||listPd.get(i).getString("var8")==null
//							||listPd.get(i).getString("var9")==""||listPd.get(i).getString("var9")==null
							||listPd.get(i).getString("var10")==""||listPd.get(i).getString("var10")==null){
						if(listPd.get(i).getString("var0")==""||listPd.get(i).getString("var0")==null){
							continue;
						}
						mv.addObject("msg", "第" + (i+2) + "行员工的数据不全，请检查后再导入。成功导入" + countRow + "条记录");
						mv.setViewName("save_result");
						return mv;
					}
					pd = new PageData();
					Date date = new Date();
					String username = user.getNAME();
					
					/* 检验编码和标识重复性================================= */

					pdc.put("EMP_CODE", listPd.get(i).getString("var0"));
					PageData result = employeeService.findByCode(pdc);
					if(result != null){
						mv.addObject("msg", "第" + (i+2) + "行员工的编码已存在，请检查后再导入。成功导入" + countRow + "条记录");
						mv.setViewName("save_result");
						return mv;
					}
					
					//验证用户编号
					String num = listPd.get(i).getString("var0");
					PageData checkCodeParam = new PageData();
					checkCodeParam.put("NUMBER",num);
					if (employeeService.findByCode(checkCodeParam) != null) {
						continue;
					}
					
					//根据部门标识获取部门ID

					PageData findDeptIdParam = new PageData();
					findDeptIdParam.put("DEPT_SIGN", listPd.get(i).getString("var3"));
					String deptId = deptService.findIdByS(findDeptIdParam);
					if(deptId ==null||deptId.equals(""))
					{
						mv.addObject("msg", "第"+i+"条的部门不存在，请检查后再导入。成功导入" + countRow + "条记录");
						mv.setViewName("save_result");
						return mv;
					}
					pdm.put("ID", deptId);
					PageData dept = deptService.findById(pdm);
					//根据岗位标识获取岗位ID
					String grade_code = listPd.get(i).getString("var7");
					String gradeId = positionLevelService.findIdByCode(grade_code);
					pdm.put("id", gradeId);
					PageData grade = positionLevelService.findById(pdm);
					
					if(gradeId ==null||gradeId.equals(""))
					{
						mv.addObject("msg", "第"+i+"条的岗位不存在，请检查后再导入。成功导入" + countRow + "条记录");
						mv.setViewName("save_result");
						return mv;
					}					
					pd.put("EMP_CODE", num);
					pd.put("EMP_NAME", listPd.get(i).getString("var1"));
					pd.put("EMP_GENDER", listPd.get(i).getString("var2").equals("男")?'1':'2');
					pd.put("EMP_DEPARTMENT_ID", deptId);
					pd.put("EMP_DEPARTMENT_NAME", dept.get("DEPT_NAME"));
					pd.put("EMP_EMAIL", listPd.get(i).getString("var5"));
					pd.put("EMP_PHONE", listPd.get(i).getString("var6"));
					pd.put("EMP_GRADE_ID", gradeId);
					pd.put("EMP_GRADE_NAME", grade.get("GRADE_NAME"));
					pd.put("EMP_REMARK", listPd.get(i).getString("var9"));
					pd.put("ENABLED", listPd.get(i).getString("var10").equals("是")?'1':'0');
					pd.put("ATTACH_KPI_MODEL", 0);
					pd.put("EMP_POSITION_CODE", 0);
					pd.put("CREATE_USER", username);
					pd.put("CREATE_TIME", date);
					
					employeeService.save(pd);//存入数据库
					countRow ++;
				}
				
				mv.addObject("msg", "成功导入" + countRow + "条记录");
			} catch (Exception e) {
				logger.error("导入员工出错", e);
				mv.addObject("msg", "导入异常，请联系管理员");
			}
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 更新员工岗位等信息（员工姓名和部门不会更新）
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/updateEmpPositionByExcel")
	public ModelAndView updateEmpPositionByExcel(@RequestParam(value = "excel", required = false) MultipartFile file,HttpServletRequest request) throws Exception {
		ModelAndView mv = this.getModelAndView();
		
		PageData pdm = new PageData();
		PageData pdc = new PageData();
		if (null != file && !file.isEmpty()) {
			try {
				String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
				String fileName = FileUpload.fileUp(file, filePath, "modelexcel_" + getUser().getNUMBER()); //执行上传
				
				//执行读EXCEL操作,读出的数据导入List 1:从第2行开始；0:从第A列开始；0:第0个sheet
				List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 1, 0, 0);
				List<PageData> empList = new ArrayList<PageData>();
				User user = UserUtils.getUser(request);
				//var0:第一列      var1:第二列    varN:第N+1列
				for (int i = 1; i < listPd.size(); i++) {
					if(listPd.get(i).getString("var0")==""||listPd.get(i).getString("var0")==null
							||listPd.get(i).getString("var1")==""||listPd.get(i).getString("var1")==null
							||listPd.get(i).getString("var2")==""||listPd.get(i).getString("var2")==null
							||listPd.get(i).getString("var3")==""||listPd.get(i).getString("var3")==null
							||listPd.get(i).getString("var4")==""||listPd.get(i).getString("var4")==null
//							||listPd.get(i).getString("var5")==""||listPd.get(i).getString("var5")==null
//							||listPd.get(i).getString("var6")==""||listPd.get(i).getString("var6")==null
							||listPd.get(i).getString("var7")==""||listPd.get(i).getString("var7")==null
							||listPd.get(i).getString("var8")==""||listPd.get(i).getString("var8")==null
//							||listPd.get(i).getString("var9")==""||listPd.get(i).getString("var9")==null
							||listPd.get(i).getString("var10")==""||listPd.get(i).getString("var10")==null)
					{
						mv.addObject("msg", "第" + (i+2) + "行员工的数据不全，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
					PageData pd = new PageData();
					Date date = new Date();
					String username = user.getNAME();
					
					//检查要更新的员工是否存在
					pdc.put("EMP_CODE", listPd.get(i).getString("var0"));
					PageData result = employeeService.findByCode(pdc);
					if(result == null){
						mv.addObject("msg", "第" + (i+2) + "行员工的编码不存在，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
					//根据部门标识获取部门ID
					PageData findDeptIdParam = new PageData();
					findDeptIdParam.put("DEPT_SIGN", listPd.get(i).getString("var3"));
					String deptId = deptService.findIdByS(findDeptIdParam);
					if(deptId ==null||deptId.equals("")){
						mv.addObject("msg", "第" + (i+2) + "行的部门标识不存在，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
					pdm.put("ID", deptId);
					PageData dept = deptService.findById(pdm);
					//根据岗位标识获取岗位ID
					String grade_code = listPd.get(i).getString("var7");
					String gradeId = positionLevelService.findIdByCode(grade_code);
					pdm.put("id", gradeId);
					PageData grade = positionLevelService.findById(pdm);
					if(gradeId ==null||gradeId.equals("")){
						mv.addObject("msg", "第" + (i+2) + "行的岗位编号不存在，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}	
									
					pd.put("EMP_CODE", listPd.get(i).getString("var0"));
//				pd.put("EMP_NAME", listPd.get(i).getString("var1"));
					pd.put("EMP_GENDER", listPd.get(i).getString("var2").equals("男")?'1':'2');
					pd.put("EMP_DEPARTMENT_ID", deptId);
					pd.put("EMP_DEPARTMENT_NAME", dept.get("DEPT_NAME"));
					pd.put("EMP_EMAIL", listPd.get(i).getString("var5"));
					pd.put("EMP_PHONE", listPd.get(i).getString("var6"));
					pd.put("EMP_GRADE_ID", gradeId);
					pd.put("EMP_GRADE_NAME", grade.get("GRADE_NAME"));
					pd.put("EMP_REMARK", listPd.get(i).getString("var9"));
					pd.put("ENABLED", listPd.get(i).getString("var10").equals("是")?'1':'0');
					pd.put("LAST_UPDATE_USER", username);
					pd.put("LAST_UPDATE_TIME", date);
					
					empList.add(pd);
				}
				for(PageData pd : empList){
					employeeService.updateEmpInfoByEmpcode(pd);
				}
				
				mv.addObject("msg", "success");
			} catch (Exception e) {
				logger.error("更新员工信息出错", e);
				mv.addObject("msg", "failed");
			}
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 导出员工信息
	 */
	@RequestMapping("exportEmployee")
	public ModelAndView exportEmployee(){
		logBefore(logger, "开始导出员工信息");
		PageData pd = this.getPageData();
		try {
			List<PageData> list = employeeService.findAllEmpInfo(pd);
			String fileTile = "员工管理";
			List<String> titles = new ArrayList<String>();

			titles.add("员工编码");
			titles.add("员工名称");
			titles.add("员工性别");
			titles.add("部门标识");
			titles.add("员工部门");
			titles.add("员工邮箱");
			titles.add("员工联系电话");
			titles.add("岗位编号");
			titles.add("岗位级别");
			titles.add("备注");
			titles.add("是否有效");
			List<PageData> varList = new ArrayList<PageData>();
			for (int i = 0; i < list.size(); i++) {
				PageData data = list.get(i);
				PageData vpd = new PageData();
				vpd.put("var1", data.getString("EMP_CODE"));
				vpd.put("var2", data.getString("EMP_NAME"));
				vpd.put("var3", "1".equals(data.getString("EMP_GENDER"))? "男":"女");
				vpd.put("var4", data.getString("DEPT_SIGN"));
				vpd.put("var5", data.getString("EMP_DEPARTMENT_NAME"));
				vpd.put("var6", data.getString("EMP_EMAIL"));
				vpd.put("var7", data.getString("EMP_PHONE"));
				vpd.put("var8", data.getString("GRADE_CODE"));
				vpd.put("var9", data.getString("EMP_GRADE_NAME"));
				vpd.put("var10", data.getString("EMP_REMARK"));
				vpd.put("var11", "1".equals(data.getString("ENABLED"))? "是":"否");
				varList.add(vpd);
			}
			
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("fileTile", fileTile);
			dataMap.put("titles", titles);
			dataMap.put("varList", varList);
			
			ObjectExcelView view = new ObjectExcelView(); //执行excel操作
			
			return new ModelAndView(view, dataMap);
		} catch (Exception e) {
			logger.error("导出员工信息-出错", e);
			return this.getModelAndView();
		}
	}
	
	@ResponseBody
	@RequestMapping("setSupportService")
	public String setSupportService(){
		logBefore(logger, "设置服务支持员工");
		try {
			PageData pd = this.getPageData();
			pd.put("empCodeArr", pd.getString("empCodeArr[]").split(","));
			employeeService.updateEmpSupportService(pd);
		} catch (Exception e) {
			logger.error("设置服务支持员工出错", e);
			return "error";
		}
		return "success";
	}
	
	/**
	 * 跳转到档案管理页面
	 */
	@RequestMapping(value = "/recordlist")
	public ModelAndView recordlist(Page page) {
		logBefore(logger, "查询EmployeeRecord列表");
		ModelAndView mv = this.getModelAndView();		
		PageData pd = new PageData();
		pd.put("EMP_CODE", getUser().getNUMBER());
		try {
			//判断角色，如果是管理员角色，则显示维护按钮
			if(isAdminGroup()){
				mv.addObject("showConfigBtn", "Y");
				if(isSysAdmin()){
					mv.addObject("isSysAdmin", "Y");
				}
			}
			String roleId = getUserRole().getRole().getPARENT_ID();
			if("0".equals(roleId) || "1".equals(roleId)){
				mv.addObject("showConfigBtn", "Y");
			}
			//查询员工是否可以维护
			PageData empInUser = employeeService.findIsChangeByEmpCode(getUser().getNUMBER(), Const.CONFIG_PAGE_RECORDING);
			if(null != empInUser && "Y".equals(empInUser.getString("IS_CHANGE"))){
				pd.put("findAll", "Y");//用于页面部门显示
				mv.addObject("changePerson", "Y");//维护人员
			}
			mv.addObject("showPage", Const.CONFIG_PAGE_RECORDING);
			//列出Dept列表
			pd.put("userId", getUser().getUSER_ID());
			List<PageData> deptList = deptService.findDeptInDataRoleByUserId(pd);
			if(deptList.size()>0)
			{
			//获取员工列表
				List<Integer> deptIdList = new ArrayList<Integer>();
				for (PageData dept : deptList) {
					deptIdList.add(Integer.valueOf(dept.get("ID").toString()));
				}
				List<PageData> empList = employeeService.findEmpByDeptIds(deptIdList);
				mv.addObject("empList", empList);
				mv.addObject("deptList", deptList);
			}
			mv.addObject("pd", pd);
		}catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("bdata/employee/employee_record_list");
		return mv;
	}
	
	/**
	 * 加载员工列表
	 */
	@ResponseBody
	@RequestMapping(value="/empRecordList")
	public GridPage empRecordList(Page page, HttpServletRequest request){
		List<PageData> empRecordList = new ArrayList<>();
		try {
			convertPage(page, request);
			PageData pageData = page.getPd();
			
			pageData.put("USERNAME", getUser().getUSERNAME());
			pageData.put("EMP_CODE", getUser().getNUMBER());
			
			PageData empInUser = employeeService.findIsChangeByEmpCode(getUser().getNUMBER(), pageData.getString("showPage"));
			String isChangeRecording = "N";
			if(null != empInUser){
				isChangeRecording = empInUser.getString("IS_CHANGE");
			}
			//管理员和指定的人资部门员工，可以查看所有部门的培训记录；其它人员按照部门的数据权限查看
			String roleId = getUserRole().getRole().getPARENT_ID();
			if("0".equals(roleId) || "1".equals(roleId) || "Y".equals(isChangeRecording)){
				pageData.put("allRecord", "Y");
			}else{
				List<Object> deptIdList = getRoleDept(pageData);
				if(deptIdList.size()>0){//有配置部门数据权限
					pageData.put("deptIdList", deptIdList);
					pageData.put("allEmpCode", getUser().getNUMBER());
				}else{//没有数据权限的只显示自己的
					pageData.put("selfEmpCode", getUser().getNUMBER());
				}
			}
			
			page.setPd(pageData);
			empRecordList = employeeService.findRecordList(page);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(empRecordList, page);
	}
	
	private List getRoleDept(PageData pd){
		List DEPT_IDS = new ArrayList<>();
		int count;
		try {
			count = commonService.checkLeader(pd);
		
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			User user = (User) session.getAttribute(Const.SESSION_USERROL);
			if(count != 0){//领导角色
				List<PageData> dataRoles = dataroleService.findByUser(user.getUSER_ID());
				if(dataRoles!=null && dataRoles.size()!=0){
					for(PageData dataRole : dataRoles){
						DEPT_IDS.add(dataRole.get("DEPT_ID"));
					}
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return DEPT_IDS;
	}
	
	/**
	 * 跳转到编辑档案页面
	 */
	@RequestMapping("goEditEmpRecord")
	public ModelAndView goEditEmpRecord(String empId){
		logBefore(logger, "跳转到编辑档案页面");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = this.getPageData();
			//根据员工编码查询员工的档案
			PageData empRecord = employeeService.findEmpAndRecord(pd);
			//查询员工的工作经历
			List<PageData> expList = employeeService.findExp(pd);
			mv.addObject("empRecord", empRecord);
			mv.addObject("expList", expList);
			mv.addObject("from", "menu");
			mv.setViewName("bdata/employee/employee_record");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}						
		return mv;
	}

	/**
	 * 去查看页面
	 */
	@RequestMapping(value="/goRecordShow")
	public ModelAndView goRecordShow(Page page){
		logBefore(logger, "修改Employee档案页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = this.getPageData();
			//根据员工编码查询员工的档案
			PageData empRecord = employeeService.findEmpAndRecord(pd);
			//查询员工的工作经历
			List<PageData> expList = employeeService.findExp(pd);
			mv.addObject("empRecord", empRecord);
			mv.addObject("expList", expList);
			
			mv.setViewName("bdata/employee/employee_record_show");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}						
		return mv;
	}
	
	/**
	 * 去配置维护人员页面
	 */
	@RequestMapping(value = "/goConfig")
	public ModelAndView goConfig(Page page) {
		logBefore(logger, "查询Employee列表");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			List<PageData> varList = deptService.listAll(pd); //列出Dept列表
			//是否传入展示页面参数
			if(null == pd.get("showPage") || pd.getString("showPage").isEmpty()){
				throw new Exception("未定义维护页面信息");
			}else{
				mv.addObject("showPage", pd.get("showPage"));
			}
			
			mv.addObject("varList", varList);
			mv.setViewName("empConfig/empConfig");
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
		
		return mv;
	}
	
	/**
	 * 在配置页面展示员工列表
	 */
	@ResponseBody
	@RequestMapping(value = "/loadEmpConfig")
	public GridPage loadEmpConfig(Page page, HttpServletRequest request){
		List<PageData> empList = new ArrayList<>();
		try {
			convertPage(page, request);
			//查询没有关联该页面的员工列表
			empList = employeeService.unConfigEmplistPage(page);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(empList, page);
	}
	
	/**
	 *保存维护人员
	 */
	@ResponseBody
	@RequestMapping("saveConfig")
	public String saveConfig(){
		logBefore(logger, "保存维护人员");
		try {
			PageData pd = this.getPageData();
			pd.put("empCodeArr", pd.getString("empCodeArr[]").split(","));
			pd.put("createUser", getUser().getUSERNAME());
			employeeService.saveEmpConfig(pd);
		} catch (Exception e) {
			logger.error("保存维护人员出错", e);
			return "error";
		}
		return "success";
	}
	
	/**
	 *移除维护人员
	 */
	@ResponseBody
	@RequestMapping("deleteEmpConfig")
	public String deleteEmpConfig(){
		logBefore(logger, "移除维护人员");
		try {
			PageData pd = this.getPageData();
			pd.put("userName", getUser().getUSERNAME());
			employeeService.deleteEmpConfigById(pd);
		} catch (Exception e) {
			logger.error("移除维护人员出错", e);
			return "error";
		}
		return "success";
	}
	
	/**
	 * 去展示维护人员页面
	 */
	@RequestMapping(value = "/showConfig")
	public ModelAndView showConfig(Page page) {
		logBefore(logger, "查询Employee列表");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			List<PageData> varList = deptService.listAll(pd); //列出Dept列表
			//是否传入展示页面参数
			if(null == pd.get("showPage") || pd.getString("showPage").isEmpty()){
				throw new Exception("未定义维护页面信息");
			}else{
				mv.addObject("showPage", pd.get("showPage"));
				mv.addObject("isAdminGroup", isAdminGroup());
				//请求参数中有显示删除，则传回页面
				if(null != pd.get("showDeleteBtn") && !pd.getString("showDeleteBtn").isEmpty()){
					mv.addObject("showDeleteBtn", pd.get("showDeleteBtn"));
				}
			}
			
			mv.addObject("varList", varList);
			mv.setViewName("empConfig/empConfigList");
		} 
		
		catch (Exception e) {
			e.printStackTrace();
		}
		
		return mv;
	}
	
	/**
	 * 展示维护人员
	 */
	@ResponseBody
	@RequestMapping(value = "/empConfigList")
	public GridPage empConfigList(Page page, HttpServletRequest request){
		List<PageData> list = new ArrayList<>();
		try {
			convertPage(page, request);
			list = employeeService.empConfiglistPage(page);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(list, page);
	}
	
	/**
	 * 提交档案
	 */
	@ResponseBody
	@RequestMapping("submit")
	public String submit(){
		try {
			logBefore(logger, "提交档案");
			PageData pd = this.getPageData();
			pd.put("status", Const.SYS_STATUS_YW_YSX);
			pd.put("updateUser", getUser().getUSERNAME());
			pd.put("updateTime", new Date());
			employeeService.updateRecording(pd);
		} catch (Exception e) {
			logger.error("提交培训记录出错", e);
			return "error";
		}		
		return "success";
	}
	
	/**
	 * 提交档案
	 */
	@ResponseBody
	@RequestMapping("submitExp")
	public String submitExp(){
		try {
			logBefore(logger, "提交档案");
			PageData pd = this.getPageData();
			pd.put("STATUS","YW_YSX");
			employeeService.saveExp(pd);
		} catch (Exception e) {
			logger.error("提交培训记录出错", e);
			return "error";
		}		
		return "success";
	}
	
	/**
	 * 展示档案配置人员
	 */
	@ResponseBody
	@RequestMapping(value = "/empRecordShowList")
	public GridPage empRecordShowList(Page page, HttpServletRequest request){
		List<PageData> empRecordShowList = new ArrayList<>();
		try {
			convertPage(page, request);
//			PageData pageData = page.getPd();
			empRecordShowList = employeeService.findByIsChangeRecordinglistPage(page);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(empRecordShowList, page);
	}
	
	@ResponseBody
	@RequestMapping("findLeaderEmp")
	public List<PageData> findLeaderEmp(){
		PageData pd = this.getPageData();
		//查询岗位等级更高的员工
		List<PageData> empList = new ArrayList<PageData>();
		try {
			String empCode = pd.getString("empCode");
			Integer deptId = Integer.valueOf(pd.getString("deptId"));
			Integer jobRank = Integer.valueOf(pd.getString("jobRank"));
			
			empList = findSuperiorLeader(empCode, deptId, jobRank, employeeService, true);
		} catch (Exception e) {
			logger.error("查询岗位等级更高的员工出错", e);
		}
		
		return empList;
	}
	
	@RequestMapping("toConfInchargeDept")
	public ModelAndView toConfInchargeDept(){
		//配置员工的分管部门
		ModelAndView mv = new ModelAndView("bdata/employee/employeeInchargeDeptConf");
		try {
			PageData pd = this.getPageData();
			String empCode = pd.getString("empCode");
			//查询部门树
			List<PageData> deptList = deptService.listAlln();
			List<PageData> list = new ArrayList<PageData>();
			for(PageData dept : deptList){
				Object manageEmpcode = dept.get("GENERAL_MANAGER_EMPCODE");
				if(null == manageEmpcode || empCode.equals(manageEmpcode.toString())){
					list.add(dept);
				}
			}
			deptList = list;
			String inChargeDpetNames = "";
			String inChargeDeptIds = "";
			String inChargeDeptCodes = "";
			for(PageData dept : deptList){
				Object manageEmpcode = dept.get("GENERAL_MANAGER_EMPCODE");
				if(null != manageEmpcode && empCode.equals(manageEmpcode.toString())){
					dept.put("checked", true);
					inChargeDpetNames += dept.getString("DEPT_NAME") +",";
					inChargeDeptIds += dept.get("ID").toString() +",";
					inChargeDeptCodes += dept.getString("DEPT_CODE") +",";
				}
			}
			if(!inChargeDpetNames.isEmpty()){
				inChargeDpetNames = inChargeDpetNames.substring(0, inChargeDpetNames.length()-1);
				inChargeDeptIds = inChargeDeptIds.substring(0, inChargeDeptIds.length()-1);
				inChargeDeptCodes = inChargeDeptCodes.substring(0, inChargeDeptCodes.length()-1);
			}
			JSONArray deptTreeNodes = JSONArray.fromObject(deptList);
			mv.addObject("deptTreeNodes", deptTreeNodes);
			mv.addObject("inChargeDpetNames", inChargeDpetNames);
			mv.addObject("inChargeDeptIds", inChargeDeptIds);
			mv.addObject("inChargeDeptCodes", inChargeDeptCodes);
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e);
		}
		return mv;
	}
	
	@ResponseBody
	@RequestMapping("saveInchargeDept")
	public String saveInchargeDept(){
		try {
			PageData pd = this.getPageData();
			deptService.updateManageEmp(pd);
			return "success";
		} catch (Exception e) {
			logger.error(e);
			return "error";
		}
	}
	
	/**
	 * 根据员工ID,查询员工的上级领导
	 */
	@ResponseBody
	@RequestMapping(value="findEmpLeader", produces = "text/html;charset=UTF-8")
	public String findEmpLeader(@RequestParam Integer empId){
		try {
			PageData leader = employeeService.findEmpLeaderByEmpId(empId);
			if(null == leader || null == leader.get("LEADER_EMPCODE")){
				return "nodata";
			}
			return leader.getString("LEADER_EMPCODE") + "," + leader.getString("LEADER_EMPNAME");
		} catch (Exception e) {
			logger.error("查询员工的上级领导出错", e);
			return "error";
		}
	}
	
	/**
	 * 导出员工的档案
	 */
	@RequestMapping("exporRecord")
	public ModelAndView exporRecord(){
		logBefore(logger, "exportRecord start");
		try {
			String userDeptArea = getUserDeptArea(deptService);
			Map<String, Object> dataMap = employeeService.exporRecord(userDeptArea);
			//执行excel操作
			return new ModelAndView(new ObjectExcelView(), dataMap);
		} catch (Exception e) {
			logger.error("exportRecord error", e);
			return this.getModelAndView();
		}
	}
	
	
	/**
	 *返回部门及员工树
	 */
	@ResponseBody
	@RequestMapping(value="findDeptAndEmpTree")
	public GridPage findDeptAndEmpTree(){
		//查询部门树
		try {
			List<PageData> deptList = deptService.listAll(null);
			//获取员工
			List<PageData> list = new ArrayList<PageData>();
			for(PageData dept : deptList){
				list.addAll(employeeService.findEmpByDeptPd(dept));
			}
			deptList.addAll(list);
			return new GridPage(deptList, new Page());
		} catch (Exception e) {
			logger.error("11", e);
			return null;
		}
	}
}