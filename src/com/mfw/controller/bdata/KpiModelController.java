package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.KpiCategoryFilesService;
import com.mfw.service.bdata.KpiFilesService;
import com.mfw.service.bdata.KpiModelLineService;
import com.mfw.service.bdata.KpiModelService;
import com.mfw.util.AppUtil;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;

import net.sf.json.JSONObject;

/**
 * 基础数据-通用基础数据-KPI模板
 * @author  作者  蒋世平
 * @date 创建时间：2015年12月23日 下午17:32:22
 */
@Controller
@RequestMapping(value="/kpiModel")
public class KpiModelController extends BaseController {
	
	@Resource(name="kpiModelService")
	private KpiModelService kpiModelService;
	@Resource(name="kpiModelLineService")
	private KpiModelLineService kpiModelLineService;
	@Resource(name = "kpiFilesService")
	private KpiFilesService kpiFilesService;
	@Resource(name = "kpiCategoryService")
	private KpiCategoryFilesService kpiCategoryService;
	@Resource(name="employeeService")
	private EmployeeService employeeService;
	
	/**
	 * 列表
	 */
	@RequestMapping(value="/list_old")
	public ModelAndView list_old(){
		logBefore(logger, "bd_kpi_model列表");
		ModelAndView mv = this.getModelAndView();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try{
			PageData pd = new PageData();
			pd = this.getPageData();
			//KID不为空，则是保存模板中kpi的标准等信息
			if(pd.getString("kID") !=null){
				String kpiID = pd.getString("kID");//kpi的id
				String kpiIDArr[] = kpiID.split(",");
				for(int i=0;i<kpiIDArr.length;i++){
					String kpiStandard = pd.getString("index"+i+"_kpiStandard");
					String kpiScore = pd.getString("index"+i+"_kpiScore");
					PageData Arr = new PageData();
					Arr.put("ID", kpiIDArr[i]);
					Arr.put("PREPARATION2", kpiStandard);//kpi标准
					Arr.put("PREPARATION3", kpiScore);//kpi分值
					Arr.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
					Arr.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));					//最后更改时间
								
				this.kpiModelLineService.updateScore(Arr);
				}
				mv.addObject("msg", "success");
			}
			List<PageData> varList = kpiModelService.listAll(pd);

			mv.addObject("varList", varList);
			mv.addObject("pd", pd);
			mv.setViewName("bdata/kpi/kpiModel_list");
			
		} catch(Exception e){
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/**
	 * 列表
	 */
	@RequestMapping(value="/list")
	public ModelAndView list(){
		logBefore(logger, "bd_kpi_model列表");
		ModelAndView mv = this.getModelAndView();
		try{
			PageData pd = new PageData();
			pd = this.getPageData();
			
			mv.addObject("pd", pd);
			mv.setViewName("bdata/kpi/kpiModelList");
		} catch(Exception e){
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	@ResponseBody
	@RequestMapping("loadKpiModelList")
	public GridPage loadKpiModelList(Page page, HttpServletRequest request){
		logBefore(logger, "加载kpi模板列表");
		List<PageData> list = new ArrayList<>();
		try {
			convertPage(page, request);
			PageData pd = page.getPd();
			
			list = kpiModelService.listAll(pd);
			
			if(list.size()>0){
				page.setShowCount(list.size());
				page.setTotalResult(list.size());
			}
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return new GridPage(list, page);
	}
	
	/**
	 * 新增页面跳转
	 */
	@RequestMapping(value="/goAdd")
	public ModelAndView goAdd(){
		logBefore(logger, "bd_kpi_model新增页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			//查询KPI列表
			List<PageData> kpiTypeList = kpiCategoryService.listAll(pd);
			List<PageData> kpiList = kpiFilesService.listAllEnab(pd);
			mv.addObject("msg", "save");
			mv.addObject("pd", pd);
			mv.addObject("kpiList", kpiList);
			mv.addObject("kpiTypeList", kpiTypeList);
			mv.setViewName("bdata/kpi/kpiModel_edit");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}						
		return mv;
	}
	
	/**
	 * 新增
	 */
	@RequestMapping(value="/save")
	public ModelAndView save() throws Exception{
		logBefore(logger, "bd_kpi_model,bd_kpi_model_line新增");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			PageData count = kpiModelService.listAllForCount(pd);
			int counter = Integer.valueOf(count==null?"0":count.get("CODE").toString())+1;
			DecimalFormat df = new DecimalFormat("0000");
		    String str = df.format(counter);
			pd.put("CODE", str);
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//创建人
			pd.put("CREATE_TIME", Tools.date2Str(new Date()));						//创建时间
			pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));//最后修改人
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));					//最后更改时间
			pd.put("PREPARATION3", 0);
			kpiModelService.save(pd);
			String ids = pd.getString("txtGroupsSelect");
			if (ids==null || ids.equals("")) {	//具体科目未做修改
				mv.addObject("msg","success");
				mv.setViewName("save_result");
				return mv;
			}
			String[] sublist = pd.getString("txtGroupsSelect").split(",");
			for (String subId : sublist) {
				//KPI对象
				PageData pds = new PageData();
				pds.put("ID", subId);
				pds = kpiFilesService.findById(pds);
				//KPI模板明细
				PageData pdml = new PageData();
				pdml.put("MODEL_ID", pd.get("ID"));
				pdml.put("KPI_CODE", pds.get("KPI_CODE"));
				pdml.put("KPI_NAME", pds.get("KPI_NAME"));
				pdml.put("KPI_DESCRIPTION", pds.get("KPI_DESCRIPTION"));
				pdml.put("KPI_TYPE", pds.get("KPI_CATEGORY_NAME"));
				pdml.put("KPI_UNIT", pds.get("KPI_UNIT"));
				pdml.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//创建人
				pdml.put("CREATE_TIME", Tools.date2Str(new Date()));					//创建时间
				pdml.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
				pdml.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));					//最后更改时间
				
				kpiModelLineService.save(pdml);
			}
			
			mv.addObject("msg", "success");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/**
	 * 修改页面跳转
	 */
	@RequestMapping(value="/goEdit")
	public ModelAndView goEdit(String MODEL_ID){
		logBefore(logger, "bd_kpi_model修改页面跳转");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {
			List<PageData> subCodeList = kpiModelLineService.listAllSubByModelId(pd.getString("MODEL_ID"));
			String subIds = "" ;
			List<PageData> kpiTypeList = kpiCategoryService.listAll(pd);
			for (PageData pdsub : subCodeList) {
				subIds += pdsub.get("ID")+",";
			}
			if (subIds.endsWith(",")) {
				subIds = subIds.substring(0, subIds.length() - 1);
			}
			pd.put("where", subIds);
			
			String ArrayUSER_IDS[] = subIds.split(",");
			
			List<PageData> kpiList = kpiFilesService.listAll(ArrayUSER_IDS);
			pd = kpiModelService.findById(MODEL_ID);	//根据ID读取
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
			mv.addObject("kpiList", kpiList);
			mv.addObject("subCodeList", subCodeList);
			mv.addObject("kpiTypeList", kpiTypeList);
			mv.setViewName("bdata/kpi/kpiModel_edit");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/**
	 * 修改
	 */
	@RequestMapping(value="/edit")
	public ModelAndView edit() throws Exception{
		logBefore(logger, "修改bd_kpi_model");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));						//最后更改时间
			
			kpiModelService.edit(pd);
			String ids = pd.getString("txtGroupsSelect").toString();
			if (ids == null || ids.equals("")) {	//具体科目未做修改
				mv.addObject("msg","success");
				mv.setViewName("save_result");
				return mv;
			}
			
			pd.put("IDS", pd.getString("txtGroupsSelect"));
			kpiModelLineService.deleteAllByModelId(pd);
			if(!ids.equals("")){	//选择了具体科目
				if(!ids.equals("blank")){
					String[] sublist = pd.getString("txtGroupsSelect").split(",");
					for (String subId : sublist) {
						PageData pds = new PageData();//科目对象
						pds.put("ID", subId);
						pds = kpiFilesService.findById(pds);
						
						PageData pdml = new PageData();//模板明细
						pdml.put("MODEL_ID", pd.get("MODEL_ID"));
						pdml.put("KPI_CODE", pds.get("KPI_CODE"));
						pdml.put("KPI_NAME", pds.get("KPI_NAME"));
						pdml.put("KPI_TYPE", pds.get("KPI_CATEGORY_NAME"));
						pdml.put("KPI_UNIT", pds.get("KPI_UNIT"));
						pdml.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//创建人
						pdml.put("CREATE_TIME", Tools.date2Str(new Date()));					//创建时间
						pdml.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
						pdml.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));					//最后更改时间
						
						kpiModelLineService.save(pdml);
					}
				}
			}
			
			mv.addObject("msg","修改成功");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/**
	 * 删除
	 */
	@ResponseBody
	@RequestMapping(value="/delete")
	public String delete(String MODEL_ID){
		logBefore(logger, "bd_kpi_model删除");
		try{
			String result = kpiModelService.deleteKpiModelById(MODEL_ID);
			return result;
		} catch(Exception e){
			logger.error(e.toString(), e);
			return "error";
		}
	}
	
	/**
	 * 批量删除
	 */
	@RequestMapping(value="/deleteAll")
	@ResponseBody
	public Object deleteAll() {
		logBefore(logger, "批量删除BdBudgetModel");
		PageData pd = new PageData();		
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			pd = this.getPageData();
			List<PageData> pdList = new ArrayList<PageData>();
			String DATA_IDS = pd.getString("DATA_IDS");
			if(null != DATA_IDS && !"".equals(DATA_IDS)){
				String ArrayDATA_IDS[] = DATA_IDS.split(",");
				kpiModelService.deleteAll(ArrayDATA_IDS);
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
			//查询模板信息
			pd = kpiModelService.findById(pd);
			//查询考核项
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
	 * 点击KPI模板，查询关联的kpi详情
	 */
	@RequestMapping(value = "toModelDetail")
	public ModelAndView toModelDetail(){
		ModelAndView mv = new ModelAndView("bdata/kpi/kpiModelDetail");
		PageData pd = this.getPageData();
		try {
			String modelId = pd.get("modelId").toString();
			//List<Object> list = kpiModelLineService.listAllByModelId(ID);
			//mv.addObject("list", list);
			
			//查询员工列表
			List<PageData> empList = employeeService.listAll(new PageData());
			//查询年度模板,是否关联到员工
			List<PageData> relateEmpList = employeeService.findEmpListByYearKpiModelId(modelId);
			if(relateEmpList.size()>0){
				for(int i=0; i<relateEmpList.size(); i++){
					String relateEmpCode =relateEmpList.get(i).get("EMP_CODE").toString();
					//查找到关联的员工，设置已经关联属性
					for(int j=0; j<empList.size(); j++){
						if(empList.get(j).get("EMP_CODE").toString().equals(relateEmpCode)){
							empList.get(j).put("isSelected", true);
							break;
						}
					}
				}
			}
			
			mv.addObject("empList", empList);
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} 
		return mv;
	}
	
	@RequestMapping("saveKpiSocre")
	public ModelAndView saveKpiSocre(){
		ModelAndView mv = new ModelAndView("save_result");
		PageData pd = this.getPageData();
		try {
			//KID不为空，则是保存模板中kpi的标准等信息
			if(pd.getString("kID") !=null){
				String kpiID = pd.getString("kID");//kpi的id
				String kpiIDArr[] = kpiID.split(",");
				for(int i=0;i<kpiIDArr.length;i++){
					String kpiStandard = pd.getString("index"+i+"_kpiStandard");
					String kpiScore = pd.getString("index"+i+"_kpiScore");
					PageData Arr = new PageData();
					Arr.put("ID", kpiIDArr[i]);
					Arr.put("PREPARATION2", kpiStandard);//kpi标准
					Arr.put("PREPARATION3", kpiScore);//kpi分值
					Arr.put("LAST_UPDATE_USER", getUser().getUSERNAME());	//最后修改人
					Arr.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));					//最后更改时间
								
				this.kpiModelLineService.updateScore(Arr);
				}
				mv.addObject("msg", "success");
			}
		} catch (Exception e) {
			logger.error("saveKpiSocre error", e);
			mv.addObject("msg", "error");
		}
		return mv;
	}
	
	/**
	 * 保存考核模板的关联人
	 */
	@ResponseBody
	@RequestMapping("saveRelateEmp")
	public PageData saveRelateEmp(){
		PageData result = new PageData();
		try {
			PageData pd = this.getPageData();
			String yearKpiModelId = pd.get("yearKpiModelId").toString();
			String relateEmpCodes = "";
			if(pd.containsKey("relateEmpCodes[]")){
				relateEmpCodes = pd.get("relateEmpCodes[]").toString();
			}
			
			employeeService.updateYearKpiModelInEmp(yearKpiModelId, relateEmpCodes);
			result.put(Const.MSG, Const.SUCCESS);
		} catch (Exception e) {
			logger.error(e);
			result.put(Const.MSG, Const.ERROR);
		}
		return result;
	}
	
	/**
	 * 保存考核周期、考核标准、分数、考核目的
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/saveScore")
	@ResponseBody
	public String saveScore(HttpServletRequest request) throws Exception{
		
		Integer ID = request.getParameter("ID")==null?0:Integer.valueOf(request.getParameter("ID"));
		String PREPARATION1 = request.getParameter("PREPARATION1");
		String PREPARATION2 = request.getParameter("PREPARATION2");
		String PREPARATION3 = request.getParameter("PREPARATION3");
		String PREPARATION4 = request.getParameter("PREPARATION4");
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		
		PageData pd = new PageData();
		pd.put("ID", ID);
		pd.put("PREPARATION1", PREPARATION1);
		pd.put("PREPARATION2", PREPARATION2);
		pd.put("PREPARATION3", PREPARATION3);
		pd.put("PREPARATION4", PREPARATION4);
		pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
		pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));					//最后更改时间
		
		
		this.kpiModelLineService.updateScore(pd);
		
		return null;
	}
	
	
	@RequestMapping(value = "/changeText",produces = "text/html;charset=UTF-8")
	public void changeText(@RequestParam String KPI_ID, @RequestParam String MODEL_ID,  HttpServletResponse response) throws Exception {
		PageData pd = new PageData();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			pd = this.getPageData();
			List<PageData> subCodeList = kpiModelLineService.listAllSubByModelId(pd.getString("MODEL_ID"));
			String subIds = "" ;
			for (PageData pdsub : subCodeList) {
				subIds += pdsub.get("ID")+",";
			}
			if (subIds.endsWith(",")) {
				subIds = subIds.substring(0, subIds.length() - 1);
			}			
			
			pd.put("subIds", subIds);
			List<PageData> kpiList = kpiFilesService.listAllByModelId(pd);
			pd = kpiModelService.findById(pd);
			

			map.put("kpiList", kpiList);
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
	 * 下载模版
	 */
	@RequestMapping(value = "downloadExcel")
	public void downloadExcel(HttpServletResponse response) throws Exception {
		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "KpiModel.xls", "Kpi模板.xls");
	}
	
	/**
	 * 从EXCEL导入到数据库
	 */
	@RequestMapping(value = "uploadExcel")
	public ModelAndView uploadExcel(@RequestParam(value = "excel", required = false) MultipartFile file,HttpServletRequest request) throws Exception {
		ModelAndView mv =new ModelAndView("save_result");
		if (null != file && !file.isEmpty()) {
			String filePath = PathUtil.getClasspath() + Const.FILEPAT_IMPORT; //文件上传路径
			String fileName = FileUpload.fileUp(file, filePath, "kpiModelExcel"); //执行上传

			@SuppressWarnings({ "unchecked", "rawtypes" })
			List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 0, 0, 0); //执行读EXCEL操作,读出的数据导入List 2:从第3行开始；0:从第A列开始；0:第0个sheet
			//校验文件是否为KPI模板
			if(listPd.size()<2 || !"KPI考核模版".equals(listPd.get(0).get("var0"))){
				mv.addObject("msg", "导入模板错误，请确认导入的是KPI考核模版");
				return mv;
			}
			
			//循环处理表格内容
			User user = getUser();
			
			String msg = "";
			String firstColumn = listPd.get(1).getString("var0");
			String secondColumn = listPd.get(1).getString("var1");
			String thirdColumn = listPd.get(1).getString("var2");
			//var0:第一列      var1:第二列    varN:第N+1列
			for (int i = 2; i < listPd.size(); i++) {//从表格第三行开始循环检查
				PageData rowPd = listPd.get(i);
				//检查非空
				if(i==2 && Tools.isEmpty(rowPd.getString("var0"))){
					msg = "第" + (i+1) + "行未填写" + firstColumn;
				}else if(Tools.isEmpty(rowPd.getString("var1"))){
					msg = "第" + (i+1) + "行未填写" + secondColumn;
				}else if(Tools.isEmpty(rowPd.getString("var2"))){
					msg = "第" + (i+1) + "行未填写" + thirdColumn;
				}else{//检查长度和数字格式
					if(rowPd.getString("var0").length()>32){
						msg = "第" + (i+1) + "行" + firstColumn + "超过最大长度限制32";
					}else if(rowPd.getString("var1").length()>400){
						msg = "第" + (i+1) + "行" + secondColumn + "超过最大长度限制400";
					}else if(!Tools.checkStringIsNum(rowPd.getString("var2"))){
						msg = "第" + (i+1) + "行" + thirdColumn + "需填写数字";
					}
				}
				if(!msg.isEmpty()){
					mv.addObject("msg", msg);
					return mv;
				}
			}
			
			//获取请求参数
			PageData pd = new PageData(request);
			String kpiModelId = pd.getString("selectModelId");
			/* 存入数据库操作====================================== */
			kpiModelService.importKpiModel(kpiModelId, user, listPd);
			
			mv.addObject("msg", "导入成功");
		}

		return mv;
	}
	

}
