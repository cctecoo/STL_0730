package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.informix.lang.Decimal;
import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.KpiModelService;
import com.mfw.service.bdata.PositionLevelService;
import com.mfw.util.AppUtil;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.UserUtils;
import com.mfw.util.UuidUtil;

import net.sf.json.JSONArray;

/**
 * 岗位管理
 * @author  作者  蒋世平
 * @date 创建时间：2016年5月8日 下午17:51:37
 */
@Controller
@RequestMapping(value="/positionLevel")
public class PositionLevelController extends BaseController {
	
	@Resource(name="positionLevelService")
	private PositionLevelService positionLevelService;
	@Resource(name = "deptService")
	private DeptService deptService;
	@Resource(name="kpiModelService")
	private KpiModelService kpiModelService;
	@Resource(name="employeeService")
	private EmployeeService employeeService;
	/**
	 * 列表
	 */
	@RequestMapping(value="/list")
	public ModelAndView list(Page page){
		logBefore(logger, "列表岗位维护");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			List<PageData> varList = deptService.listAll(pd); //列出Dept列表
			for(int i=0;i<varList.size();i++){
				varList.get(i).put("eNum", getPositionLevelNum(varList.get(i)));
				if(Integer.valueOf(varList.get(i).get("ENABLED").toString())==0){
					varList.get(i).put("DEPT_NAME", varList.get(i).get("DEPT_NAME").toString()+"(未启用)");
				}
			}
			JSONArray arr = JSONArray.fromObject(varList); //Dept列表转为ztree可识别的类型
			
			mv.addObject("deptTreeNodes", arr.toString());
			mv.addObject("pd", pd);
			mv.addObject("varList", varList);
			mv.setViewName("bdata/positionLevel/list");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	/**
	 * 获取部门岗位数量
	 */
	public int getPositionLevelNum(PageData p){
		int eNum = 0;
		try {
			eNum = Integer.valueOf(deptService.getPositionLevelNum(p).get("num").toString());
			List<PageData> childList = deptService.listChild(p);
			for(int j=0;j<childList.size();j++){
				 eNum +=getPositionLevelNum(childList.get(j));				
			}
		}catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return eNum;
	}
	
	@ResponseBody
	@RequestMapping(value = "/empList")
	public GridPage employeeList(Page page, HttpServletRequest request){
		List<PageData> empList = new ArrayList<>();
		try {
			convertPage(page, request);
			//PageData pageData = page.getPd();
			
			empList = positionLevelService.listAll(page); 
			
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(empList, page);
	}
	
	
	/**
	 * 新增页面
	 */
	@RequestMapping(value = "/toAdd")
	public ModelAndView toAdd(Page page) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			List<PageData> deptList = deptService.listAlln();//列出部门列表
			List<PageData> kpiList = kpiModelService.listAllEnable(pd);
			JSONArray arr = JSONArray.fromObject(deptList);
			mv.setViewName("bdata/positionLevel/add");
			mv.addObject("deptList", deptList);
			mv.addObject("kpiList", kpiList);
			mv.addObject("pd", pd);
			mv.addObject("deptTreeNodes", arr.toString());
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	/**
	 * 保存新增信息
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public ModelAndView add() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			pd.put("ID", UuidUtil.get32UUID()); //ID
			pd.put("attachDeptId", pd.getString("DEPT_ID"));
			pd.put("createUser", getUser().getNAME());
			pd.put("createTime", new Date());
			positionLevelService.add(pd);
			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "failed");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 去修改页面
	 */
	@RequestMapping(value = "/goEdit")
	public ModelAndView goEdit() {
		logBefore(logger, "去修改PositionLevel页面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {
			pd = positionLevelService.findById(pd); //根据ID读取
			List<PageData> deptList = deptService.listAlln();//列出部门列表
			List<PageData> kpiList = kpiModelService.listAllEnable(pd);
			JSONArray arr = JSONArray.fromObject(deptList);
			mv.setViewName("bdata/positionLevel/edit");
			mv.addObject("deptList", deptList);
			mv.addObject("kpiList", kpiList);
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
			mv.addObject("deptTreeNodes", arr.toString());
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 编辑
	 */
	@RequestMapping(value = "/edit")
	public ModelAndView edit() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			pd.put("attachDeptId", pd.getString("DEPT_ID"));
			positionLevelService.edit(pd);
			//修改对应的员工中的岗位名称及考核模板
			employeeService.updatePositionNameInEmp(pd);
			
			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "failed");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete")
	public void delete(PrintWriter out) {
		logBefore(logger, "删除positionLevel");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			Integer id = Integer.valueOf((String)pd.get("id"));
			//检查岗位是否有被用到
			Integer count = employeeService.findEmpByGradeId(id);
			if(count>0){
				out.write("fail");
			}else{
				positionLevelService.delete(pd);
				out.write("success");
			}
		} catch (Exception e) {
			out.write("error");
			logger.error(e.toString(), e);
		}
		out.close();
	}
	
	/**
	 * 批量删除
	 */
	@RequestMapping(value = "/deleteAll")
	@ResponseBody
	public Object deleteAll() {
		logBefore(logger, "批量删除positionLevel");
		PageData pd = new PageData();		
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			pd = this.getPageData();
			List<PageData> pdList = new ArrayList<PageData>();
			String DATA_IDS = pd.getString("DATA_IDS");
			if(null != DATA_IDS && !"".equals(DATA_IDS)){
				String ArrayDATA_IDS[] = DATA_IDS.split(",");
				positionLevelService.deleteAll(ArrayDATA_IDS);
				pd.put("msg", "ok");
			}else{
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
	
	/**
	 * 验证编码是否重复,true:不重复； false:重复
	 */
	@ResponseBody
	@RequestMapping(value = "/checkCode")
	public boolean checkCode() {
		logBefore(logger, "验证编码是否重复");
		PageData pd = getPageData();
		try {
			int count = positionLevelService.checkCode(pd);
			return count == 0 ? true : false;
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return false;
	}
	
	/**
	 * 根据部门编码获取岗位
	 * @param deptIds
	 * @return
	 */
	@ResponseBody
	@RequestMapping("findPositionByDeptId")
	public List<PageData> findPositionByDeptId(String deptId){
		try {
			return positionLevelService.findPositionByDeptId(deptId);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	
	
	/* ===============================导入导出================================== */
	/**
	 * 打开上传EXCEL页面
	 */
	@RequestMapping(value = "/goUploadExcel")
	public ModelAndView goUploadExcel() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/positionLevel/loadexcel");
		return mv;
	}
	/**
	 * 下载模版
	 */
	@RequestMapping(value = "/downExcel")
	public void downExcel(HttpServletResponse response) throws Exception {
		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "PositionLevel.xls", "PositionLevel.xls");
	}
	
	/**
	 * 从EXCEL导入到数据库
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/readExcel")
	public ModelAndView readExcel(@RequestParam(value = "excel", required = false) MultipartFile file,HttpServletRequest request) throws Exception {
		ModelAndView mv = this.getModelAndView();
		
		PageData pdc = new PageData();

		
		if (null != file && !file.isEmpty()) {
			String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
			String fileName = FileUpload.fileUp(file, filePath, "modelexcel"); //执行上传

			List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 2, 0, 0); //执行读EXCEL操作,读出的数据导入List 2:从第3行开始；0:从第A列开始；0:第0个sheet
			
			
			/* 存入数据库操作====================================== */
			List<PageData> saveList = new ArrayList<PageData>();
			Map<String, Integer> gradeCodeMap = new HashMap<String, Integer>();
			/**
			 * var0:第一列      var1:第二列    varN:第N+1列
			 */
			for (int i = 0; i < listPd.size(); i++) {
				if(listPd.get(i).getString("var0")==""||listPd.get(i).getString("var0")==null||listPd.get(i).getString("var1")==""||listPd.get(i).getString("var1")==null
						||listPd.get(i).getString("var2")==""||listPd.get(i).getString("var2")==null||listPd.get(i).getString("var4")==""||listPd.get(i).getString("var4")==null
						//||listPd.get(i).getString("var5")==""||listPd.get(i).getString("var5")==null
				){
					mv.addObject("msg", "第"+(i+3)+"行岗位的数据不全，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}
				String gradeCode = listPd.get(i).getString("var0");
				PageData pd = new PageData();
				pd.put("createUser", getUser().getNAME());
				pd.put("createTime", new Date());	
				pd.put("gradeCode", gradeCode); 	//岗位编号
				String flag = positionLevelService.findIdByCode(gradeCode);
				
				if(flag!=null){//数据库编码存在
					mv.addObject("msg", "第"+(i+3)+"行的岗位编码已存在，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}else{//数据库没重复，则检查导入表格是否重复
					if(gradeCodeMap.containsKey(gradeCode)){
						mv.addObject("msg", "第" + gradeCodeMap.get(gradeCode)+ "行与第"+(i+3)+"行的岗位编码在表格中出现重复，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}else{//map中不存在则存入
						gradeCodeMap.put(gradeCode, i+3);
					}
				}
				pd.put("gradeName", listPd.get(i).getString("var1")); 	//岗位名称
				pdc.put("DEPT_SIGN", listPd.get(i).getString("var2"));
				PageData pdm = deptService.findIdBySign(pdc);			//跟据标识获取部门
				if(pdm == null)
				{
					mv.addObject("msg", "第"+(i+3)+"行岗位的部门不存在，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}
				pd.put("attachDeptId", pdm.get("ID"));				//部门ID
				pd.put("attachDeptName", pdm.get("DEPT_NAME"));		//部门名称
				/*Decimal labor = new Decimal(listPd.get(i).getString("var4"));*/
				try {
					String var4 = listPd.get(i).getString("var4");
					Integer jobRank = Integer.parseInt(var4);
					pd.put("jobRank", jobRank);//岗位等级
				} catch (Exception e) {
					logger.error("第"+(i+3)+"行的岗位等级不是数字", e);
					mv.addObject("msg", "第"+(i+3)+"行的岗位等级不是数字，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}
				pd.put("laborCost", "1");//员工成本
				pd.put("gradeDesc", listPd.get(i).getString("var5")); 	//级别描述
				if(listPd.get(i).getString("var6")!=""&&listPd.get(i).getString("var6")!=null)
				{
					pdc.put("CODE", listPd.get(i).getString("var6"));
					pdm = kpiModelService.findByCode(pdc);					//跟据编码获取关联KPI
					if(pdm == null)
					{
						pdm = new PageData();
						pdm.put("ID", "");
					}
					pd.put("attachKpiModel", pdm.get("ID"));
				}
				//positionLevelService.add(pd);
				saveList.add(pd);
			}
			for(int i=0; i<saveList.size(); i++){
				positionLevelService.add(saveList.get(i));
			}
			/* 存入数据库操作====================================== */
			mv.addObject("msg", "导入成功");
		}

		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 *返回部门及岗位树
	 */
	@ResponseBody
	@RequestMapping(value="findDeptAndPosTree")
	public GridPage findDeptAndPosTree(){
		//查询部门树
		try {
			List<PageData> deptList = deptService.listAll(null);
			List<PageData> list = new ArrayList<PageData>();
			//岗位
			for(PageData dept : deptList){
				list.addAll(positionLevelService.findPositionTreeByDeptId(dept));
			}
			deptList.addAll(list);
			return new GridPage(deptList, new Page());
		} catch (Exception e) {
			logger.error("11", e);
			return null;
		}
	}
}
