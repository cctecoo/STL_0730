package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.mfw.service.bdata.EmployeeTrainService;
import com.mfw.service.system.UserLogService;
import com.mfw.service.system.datarole.DataRoleService;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;

/**
 * 基础数据-通用基础数据-员工培训管理
 * @author  作者  蒋世平
 * @date 创建时间：2016年5月07日 下午16:42:21
 */
@Controller
@RequestMapping(value = "/empTrain")
public class EmployeeTrainController extends BaseController {

	@Resource(name = "employeeTrainService")
	private EmployeeTrainService employeeTrainService;
	@Resource(name = "userLogService")
	private UserLogService userLogService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "dataroleService")
	private DataRoleService dataroleService;
	@Resource(name="deptService")
	private DeptService deptService;
	
	/**
	 * 培训记录列表
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) {
		logBefore(logger, "查询EmployeeTrain列表");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = this.getPageData();
			mv.addObject("EMP_CODE", getUser().getNUMBER());
			//判断角色，如果是管理员角色，则显示维护按钮
			String roleId = getUserRole().getRole().getPARENT_ID();
			mv.addObject("roleId", roleId);
			if("0".equals(roleId) || "1".equals(roleId)){
				mv.addObject("showConfigBtn", "Y");
			}
			//查询员工是否可以维护
			PageData empInUser = employeeService.findIsChangeByEmpCode(getUser().getNUMBER(), Const.CONFIG_PAGE_TRAINING);
			if(null != empInUser && "Y".equals(empInUser.getString("IS_CHANGE"))){
				pd.put("findAll", "Y");//用于页面部门显示
				mv.addObject("changePerson", "Y");//维护人员
			}
			
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
			mv.addObject("showPage", Const.CONFIG_PAGE_TRAINING);
			mv.addObject("pd", pd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("bdata/employee/employee_train_list");
		return mv;
	}
	
	@ResponseBody
	@RequestMapping(value = "/empTrainList")
	public GridPage empTrainList(Page page, HttpServletRequest request){
		List<PageData> empList = new ArrayList<>();
		try {
			convertPage(page, request);
			PageData pd = page.getPd();
			pd.put("USERNAME", getUser().getUSERNAME());
			pd.put("EMP_CODE", getUser().getNUMBER());
			
			PageData empInUser = employeeService.findIsChangeByEmpCode(getUser().getNUMBER(), pd.getString("showPage"));
			String isChageTrain = "N";
			if(null != empInUser){
				isChageTrain = empInUser.getString("IS_CHANGE");
			}
			//管理员和指定的人资部门员工，可以查看所有部门的培训记录；其它人员按照部门的数据权限查看
			String roleId = getUserRole().getRole().getPARENT_ID();
			if("0".equals(roleId) || "1".equals(roleId) || "Y".equals(isChageTrain)){
				pd.put("findAll", "Y");
			}else{
				List<Object> deptIdList = getRoleDept(pd);
				if(deptIdList.size()>0){//有配置部门数据权限
					pd.put("deptIdList", deptIdList);
				}else{//没有数据权限的只显示自己的
					pd.put("selfEmpCode", getUser().getNUMBER());
				}
			}
			page.setPd(pd);
			empList = employeeTrainService.findTrainList(page);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(empList, page);
	}
	
	/**
	 * 去新增页面
	 */
	@RequestMapping(value = "/goAdd")
	public ModelAndView goAdd() {
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		try {
			pd.put("EMP_CODE", getUser().getNUMBER());
			pd.put("EMP_NAME", getUser().getNAME());
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.addObject("empTrain",pd);
		mv.setViewName("bdata/employee/employee_train_add");
		return mv;
	}
	
	/**
	 * 到编辑界面
	 */
	@RequestMapping(value = "/goEdit")
	public ModelAndView goEdit(){
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		try {
			pd = employeeTrainService.findById(pd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.addObject("empTrain",pd);
		mv.setViewName("bdata/employee/employee_train_add");
		return mv;
	}
	
	/**
	 * 保存页面
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/save")
	public ModelAndView save() {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			if(pd.get("ID")==null || "".equals(pd.getString("ID"))){
				pd.put("CREATE_USER", getUser().getUSERNAME());
				pd.put("CREATE_TIME", new Date());
				employeeTrainService.save(pd);
//				userLogService.logInfo(new UserLog(getUser().getUSER_ID(),
//						LogType.add, "员工培训记录", pd.get("ID").toString()));
			}else{
				pd = updateInfo(pd);
				employeeTrainService.edit(pd);
				userLogService.logInfo(new UserLog(getUser().getUSER_ID(),
						LogType.update, "员工培训记录", pd.get("ID").toString()));
			}
			
			mv.addObject("msg", "操作成功");

		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "操作失败");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	private PageData updateInfo(PageData pd){
		pd.put("UPDATE_USER", getUser().getUSERNAME());
		pd.put("UPDATE_TIME", new Date());
		return pd;
	}
	
	/**
	 * 删除培训记录
	 */
	@RequestMapping(value = "/delete")
	public void delete(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			pd = updateInfo(pd);
			employeeTrainService.delete(pd);
			userLogService.logInfo(new UserLog(getUser().getUSER_ID(),
					LogType.delete, "员工培训记录", pd.get("ID").toString()));
			out.write("success");
		} catch (Exception e) {
			out.write("error");
			logger.error(e.toString(), e);
		}
		out.close();
	}
	
	@ResponseBody
	@RequestMapping("batchDelete")
	public String batchDelete(){
		logBefore(logger, "批量删除培训记录");
		PageData pd = this.getPageData();
		try {
			pd.put("UPDATE_USER", getUser().getUSERNAME());
			employeeTrainService.batchDelete(pd);
			return "success";
		} catch (Exception e) {
			logger.error("批量删除培训记录-出错", e);
			return "error";
		}
		
	}
	
	/**
	 * 打开上传EXCEL页面（培训记录）
	 */
	@RequestMapping(value = "/goUploadExcelTrain")
	public ModelAndView goUploadExcelRecord() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/employee/trainLoadexcel");
		return mv;
	}
	/**
	 * 下载模版（培训记录）
	 */
	@RequestMapping(value = "/downExcelTrain")
	public void downExcelRecord(HttpServletResponse response) throws Exception {
		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "EmpTrain.xls", "EmpTrain.xls");
	}
	/**
	 * 从EXCEL导入到数据库（培训记录）
	 */
	@RequestMapping(value = "/readExcelTrain")
	public ModelAndView readExcelRecord(@RequestParam(value = "excel", required = false) MultipartFile file,
			HttpServletRequest request) {
		ModelAndView mv =new ModelAndView("save_result");
		if (null != file && !file.isEmpty()) {
			String filePath = PathUtil.getClasspath() + Const.FILEPAT_IMPORT; //文件上传路径
			String fileName = FileUpload.fileUp(file, filePath, "empTrainExcel"); //执行上传
			
			try {
//				
//				//执行读EXCEL操作,读出的数据导入List, 0:从第1行开始；0:从第A列开始；0:第1个sheet
//				List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 0, 0, 0);	//培训记录
//				//判断第一行表格名称
//				String firstRow = listPd.get(0).getString("var0");
//				if(!"员工上岗前培训统计表".equals(firstRow)){
//					mv.addObject("msg", "只能导入员工上岗前培训统计表，请检查后再导入");
//					return mv;
//				}
//				//查询员工编码
//				String empName = listPd.get(2).getString("var1");
//				String empDeptName = listPd.get(3).getString("var3");
//				PageData searchPd = new PageData();
//				searchPd.put("name", empName);
//				searchPd.put("deptName", empDeptName);
//				PageData empPd = employeeService.findEmployeeByNameAndDept(searchPd);
//				if(null == empPd){
//					mv.addObject("msg", "没有对应员工的信息，请检查表格中基本信息的姓名和部门是否与本系统一致");
//					return mv;
//				}
//				//判断第五行内容
//				PageData fifthRow = listPd.get(4);
//				//‘培训内容’占两个单元格，所以‘讲授人’是第四列
//				if( !"培训日期".equals(fifthRow.getString("var0")) || !"培训内容".equals(fifthRow.getString("var1")) 
//					|| !"讲授人".equals(fifthRow.getString("var3")) || !"地点".equals(fifthRow.getString("var4")) 
//					|| !"培训形式".equals(fifthRow.getString("var5")) || !"课时".equals(fifthRow.getString("var6"))	
//					|| !"成绩".equals(fifthRow.getString("var7")) || !"岗位变动".equals(fifthRow.getString("var8")) ){
//					mv.addObject("msg", "第五行格式不符，请检查后再导入");
//					return mv;
//				}
//				//执行导入操作
//				String msg = employeeTrainService.importExcel(listPd, empPd, getUser());
				String msg = employeeTrainService.readEmpTrainExcel(filePath, fileName, getUser(), employeeService);
				if(!msg.isEmpty()){
					mv.addObject("msg", msg.replaceAll("\n", ""));
					return mv;
				}
//				userLogService.logInfo(new UserLog(getUser().getUSER_ID(),
//						LogType.add, "员工培训记录", "批量保存"));	
				mv.addObject("msg", "导入完成");
			} catch (Exception e) {
				logger.error("导入员工的培训记录出错", e);
				mv.addObject("msg", "后台处理出错，请联系系统管理员");
				return mv;
			}
		}
		return mv;
	}
	
	
	/**
	 * 获取配置的部门数据权限
	 */
	private List<Object> getRoleDept(PageData pd){
		List<Object> DEPT_IDS = new ArrayList<>();
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
			e.printStackTrace();
		}
		return DEPT_IDS;
	}
	
	/**
	 * 提交培训记录
	 */
	@ResponseBody
	@RequestMapping("submit")
	public String submit(){
		try {
			logBefore(logger, "提交培训记录");
			PageData pd = this.getPageData();
			pd.put("status", Const.SYS_STATUS_YW_YSX);
			pd.put("updateUser", getUser().getUSERNAME());
			pd.put("updateTime", new Date());
			employeeTrainService.updateEmpTrain(pd);
		} catch (Exception e) {
			logger.error("提交培训记录出错", e);
			return "error";
		}
		
		return "success";
	}
	
}
