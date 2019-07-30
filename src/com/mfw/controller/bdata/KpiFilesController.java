package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.KpiCategoryFilesService;
import com.mfw.service.bdata.KpiFilesService;
import com.mfw.service.bdata.KpiIndexService;
import com.mfw.service.bdata.KpiModelLineService;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;
import com.mfw.util.UserUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 基础数据-通用基础数据-KPI指标库
 * @author  作者  蒋世平
 * @date 创建时间：2015年12月18日 下午18:02:31
 */
@Controller
@RequestMapping(value = "/kpiFiles")
public class KpiFilesController extends BaseController {
	
	@Resource(name = "kpiFilesService")
	private KpiFilesService kpiFilesService;
	@Resource(name = "kpiModelLineService")
	private KpiModelLineService kpiModelLineService;
	@Resource(name = "kpiIndexService")
	private KpiIndexService kpiIndexService;
	@Resource(name = "kpiCategoryService")
	private KpiCategoryFilesService kpiCategoryService;
	
	/**
	 * 列表
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) {
		logBefore(logger, "bd_kpi_files列表");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		
		try {
			pd = this.getPageData();
			page.setPd(pd);
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();

			PageData maxId = kpiFilesService.maxID(pd);
			if(maxId==null)
			{
				maxId = new PageData();
				maxId.put("max(ID)", 0);
			}
			List<PageData> varList = kpiFilesService.listAll(pd);
			int treeID = 0;
			if(session.getAttribute("ID") !=null&&(pd.get("ID") ==null||pd.get("ID") ==""))
			{
				pd.put("ID", session.getAttribute("ID"));
			}
			if(pd.get("ID")!=null)
			{	
				treeID = Integer.valueOf(pd.get("ID").toString());
				if(Integer.valueOf(pd.get("ID").toString()) > Integer.valueOf(maxId.get("max(ID)").toString())){
					
					pd.put("ID", Integer.valueOf(pd.get("ID").toString())-Integer.valueOf(maxId.get("max(ID)").toString()));
					pd = kpiCategoryService.findById(pd);
					pd.put("treeID", treeID);
				}
				else{
					pd = kpiFilesService.findById(pd); //根据ID读取
					pd.put("treeID", treeID);
					List<PageData> file = kpiFilesService.findFileById(pd);
					if(file!=null)
					{
						mv.addObject("fileList", file);
					}
				}
			}
			else{				
				pd.put("treeID", treeID);
				List<PageData> file = kpiFilesService.findFileById(pd);
				if(file!=null)
				{
					mv.addObject("fileList", file);
				}
			}
			
			List<PageData> categoryList = kpiCategoryService.listAll(pd);//列出科目类型列表
			List<PageData> dtreeList = new ArrayList<PageData>() ;
			
			
			for(int i=0;i<categoryList.size();i++){
				PageData tempdata = categoryList.get(i);
				PageData dtreedata = new PageData();
				dtreedata.put("NAME", tempdata.get("NAME"));
				dtreedata.put("CODE", tempdata.get("CODE"));
				if(tempdata.get("PARENT_ID") !=null||tempdata.get("PARENT_ID") == "0")
				{
					dtreedata.put("PARENT_ID", 0);
				}
				else
				{
					dtreedata.put("PARENT_ID", Integer.valueOf(tempdata.get("PARENT_ID").toString())+Integer.valueOf(maxId.get("max(ID)").toString()));
				}				
				dtreedata.put("ID", Integer.valueOf(tempdata.get("ID").toString())+Integer.valueOf(maxId.get("max(ID)").toString()));
				dtreeList.add(dtreedata);
			}
			for(int i=0;i<varList.size();i++){
				PageData tempdata = varList.get(i);
				if(Integer.valueOf(tempdata.get("PARENT_ID").toString())==0){
					int a = Integer.valueOf(tempdata.get("KPI_CATEGORY_ID").toString());
					int b = Integer.valueOf(maxId.get("max(ID)").toString());
					tempdata.put("PARENT_ID", a+b);
				}
				tempdata.put("NAME", tempdata.getString("KPI_NAME"));
				tempdata.put("CODE", tempdata.getString("KPI_CODE"));
				dtreeList.add(tempdata);
			}
			mv.addObject("dtreeList",dtreeList);			
			mv.addObject("varList", varList);
			mv.addObject("pd", pd);
			
			mv.setViewName("bdata/kpi/kpiFiles_list");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	/**
	 * 验证部门下是否有员工
	 */
	@RequestMapping(value = "/checkEmp")
	public void checkEmp(PrintWriter out) {
		logBefore(logger, "验证部门KPI下是否有员工");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			int count = kpiFilesService.checkEmp(pd);
			out.write(count+"");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

	}
	
	/**
	 * 新增根级页面跳转
	 */
	@RequestMapping(value = "/goAddr")
	public ModelAndView goAddr() throws Exception {
		logBefore(logger, "bd_kpi_category_files表新增根页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();

			mv.setViewName("bdata/kpi/kpiCategoryFiles_edit");
			mv.addObject("msg", "save");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}
	
	/**
	 * 新增页面跳转
	 */
	@RequestMapping(value = "/goAdd")
	public ModelAndView goAdd(String PARENT_ID) throws Exception {
		logBefore(logger, "KPI新增页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			PageData category = new PageData();
			pd = this.getPageData();
			PageData maxId = kpiFilesService.maxID(pd);
			
			if(Integer.valueOf(PARENT_ID) > Integer.valueOf(maxId.get("max(ID)").toString()))
			{
				pd.put("ID", Integer.valueOf(PARENT_ID) - Integer.valueOf(maxId.get("max(ID)").toString()));
				pd.put("PARENT_ID", Integer.valueOf(PARENT_ID) - Integer.valueOf(maxId.get("max(ID)").toString()));
				category = kpiCategoryService.findById(pd);
			}
			else{
				pd.put("PARENT_ID",Integer.valueOf(PARENT_ID));
				PageData parentID = new PageData();
				parentID.put("ID",pd.get("PARENT_ID"));
				PageData parent = kpiFilesService.findById(parentID);
				pd.put("ID",parent.get("KPI_CATEGORY_ID"));
				category = kpiCategoryService.findById(pd);
			}
			//列出所有科目类型
			List<PageData> categoryList = kpiCategoryService.listAlln();
			mv.addObject("category", category);
			mv.addObject("pd", pd);
			mv.addObject("msg", "save");
			mv.addObject("categoryList", categoryList);
			mv.setViewName("bdata/kpi/kpiFiles_edit");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}
	
	
	
	/**
	 * KPI新增验证
	 */
	@RequestMapping(value = "/checkKpiFiles",produces="text/html;charset=UTF-8")
	public void checkKpiFiles(String kpiCode, String msg, String id, PrintWriter out){
		try{
			PageData pd = new PageData();
			pd.put("KPI_CODE", kpiCode);
			
			logBefore(logger, "KPI新增验证");
			if(msg == "save"){		//新增
				PageData kpiData  = kpiFilesService.findByCode(pd);
				//判断用户所填code是否重复
				if(null == kpiData){
					out.write("true");
				}else{
					out.write("false");
				}
			}else{		//修改
				pd.put("ID", id);
				//原有数据
				PageData kpi = kpiFilesService.findById(pd);
				//修改后的数据
				PageData kpiData  = kpiFilesService.findByCode(pd);
				if(null != kpiData && kpiData.getString("KPI_CODE").equals(kpi.getString("KPI_CODE"))){	//用户没有修改编号
					out.write("true");
				}else if(null != kpiData && !kpiData.getString("KPI_CODE").equals(kpi.getString("KPI_CODE"))){//用户修改后的编号与原有编号重复
					out.write("false");
				}else if(null == kpiData){	//用户修改后的编号为唯一
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
	 * 新增
	 */
	@RequestMapping(value = "/save")
	public ModelAndView save() throws Exception {
		logBefore(logger, "bd_kpi_files表新增");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			PageData maxId = kpiFilesService.maxID(pd);
			
			if((Integer.valueOf(pd.get("PARENT_ID").toString()) > Integer.valueOf(maxId.get("max(ID)").toString()))||(pd.get("ID").equals(pd.get("PARENT_ID"))))
			{
				pd.put("PARENT_ID", 0);
			}
									
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			
			UUID uuid = UUID.randomUUID();  
	        String str = uuid.toString();
	        
			pd.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));		//创建人
			pd.put("CREATE_TIME", Tools.date2Str(new Date()));							//创建时间
			pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));						//最后更改时间
			pd.put("DOCUMENT_ID",str);
			
			String document = (String) pd.get("DOCUMENT");
			JSONArray json = JSONArray.fromObject(document);
			for(int i = 0; i < json.size(); i++){
				JSONObject jo = json.getJSONObject(i);
				pd.put("DOCUMENT", jo.get("filename"));
				pd.put("PATH", jo.get("filePath"));
				kpiFilesService.saveDocument(pd);//将文件名称及上传路径存保存
			}
			
			
			kpiFilesService.save(pd);
			mv.addObject("editFlag", "saveSucc");
			mv.setViewName("save_result");
			
		} catch (Exception e) {
			mv.addObject("editFlag", "savefail");
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete")
	public void delete(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			findAllChild(pd);			
			out.write("success");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} finally{
			out.flush();
			out.close();
		}

	}
	
	private void findAllChild(PageData pd) throws Exception{
        List<PageData> childList = kpiFilesService.findChildById(pd);
        
		logBefore(logger, "bd_kpi_files表删除");
		kpiFilesService.delete(pd);
		logBefore(logger, "bd_kpi_model_line表对应删除");
		kpiModelLineService.deleteByKpicode(pd);
		logBefore(logger, "emp_kpi_index表对应删除");
		kpiIndexService.deleteByKpicode(pd);
        if(childList != null) {
            for (int i = 0;i< childList.size();i++){
            	PageData eachchild = childList.get(i);
                findAllChild(eachchild);
            }
        }
    }
	
	/**
	 * 根修改页面跳转
	 */
	@RequestMapping(value = "/goEditTop")
	public ModelAndView goEditTop() throws Exception {
		logBefore(logger, "修改bd_kpi_category_files页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			
			
			pd = kpiCategoryService.findById(pd);  //根据ID读取
			
			mv.setViewName("bdata/kpi/kpiCategoryFiles_edit");
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}
	
	
	/**
	 * 修改页面跳转
	 */
	@RequestMapping(value = "/goEdit")
	public ModelAndView goEdit() throws Exception {
		logBefore(logger, "修改bd_kpi_files页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			PageData category = new PageData();
			PageData categoryID = new PageData();
			
			
			List<PageData> categoryList = kpiCategoryService.listAlln();//列出所有科目类型
			pd = kpiFilesService.findById(pd); //根据ID读取
			
			categoryID.put("ID",pd.get("KPI_CATEGORY_ID"));			
			category = kpiCategoryService.findById(categoryID);
			mv.setViewName("bdata/kpi/kpiFiles_edit");
			mv.addObject("category", category);
			mv.addObject("categoryList", categoryList);
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}
	
	/**
	 * 修改
	 */
	@RequestMapping(value = "/edit")
	public ModelAndView edit() throws Exception {
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			
			if(null != pd.get("KPI_CATEGORY_ID") && !"".equals(pd.getString("KPI_CATEGORY_ID").toString())){
				PageData kpiCategory = new PageData();
				kpiCategory.put("ID", pd.getString("KPI_CATEGORY_ID"));
				logBefore(logger, "查询KPI类别名称");
				kpiCategory = kpiCategoryService.findById(kpiCategory);
				pd.put("KPI_CATEGORY_NAME", kpiCategory.get("NAME"));
			}
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			session.setAttribute("ID", pd.get("ID"));

			pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));						//最后更改时间
			
			pd.put("KPI_TYPE", pd.get("KPI_CATEGORY_NAME"));
			
					
			if(pd.get("DOCUMENT_ID")==""||pd.get("DOCUMENT_ID")==null)
			{
				UUID uuid = UUID.randomUUID();  
		        String str = uuid.toString();
				pd.put("DOCUMENT_ID",str);								
			}
			else{
				pd.put("DOCUMENT_ID",pd.get("DOCUMENT_ID"));
			}
			
			String document = (String) pd.get("DOCUMENT");
			JSONArray json = JSONArray.fromObject(document);
			for(int i = 0; i < json.size(); i++){
				JSONObject jo = json.getJSONObject(i);
				pd.put("DOCUMENT", jo.get("filename"));
				pd.put("PATH", jo.get("filePath"));
				kpiFilesService.saveDocument(pd);//将文件名称及上传路径存保存
			}
			
			
			logBefore(logger, "修改表bd_kpi_files");
			kpiFilesService.edit(pd);
			logBefore(logger, "对应修改表BD_KPI_MODEL_LINE");
			kpiModelLineService.updateByKpicode(pd);

			mv.addObject("editFlag", "updateSucc");
			mv.setViewName("save_result");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}
	
	/**
	 * 上传文档
	 */		
	@RequestMapping(value = "/Upload",produces="application/json;charset=UTF-8")
	@ResponseBody
	public void KpiUpload(
			@RequestParam(value = "id-input-file-1", required = false) MultipartFile[] DOCUMENT,  HttpServletResponse response
	) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			for(int i=0;i<DOCUMENT.length;i++)
			{
				if (null != DOCUMENT[i] && !DOCUMENT[i].isEmpty()) {
					String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
					String filename = DOCUMENT[i].getOriginalFilename();
					FileUpload.fileUp(DOCUMENT[i], filePath, DOCUMENT[i].getOriginalFilename()
							.substring(0, DOCUMENT[i].getOriginalFilename().lastIndexOf("."))); //执行上传
					map = new HashMap<String, Object>();
					map.put("filename", filename);
					map.put("filePath", filePath);
					list.add(map);
				}
			}
			
			String json = JSONArray.fromObject(list).toString();
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(json);
			out.flush();
			out.close();
		}catch (Exception e){
			logger.error(e.toString(), e);
			
		}
		
	}
	
	
	/* ===============================导入导出================================== */
	/**
	 * 打开上传EXCEL页面
	 */
	@RequestMapping(value = "/goUploadExcel")
	public ModelAndView goUploadExcel() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/kpi/kpiloadexcel");
		return mv;
	}
	/**
	 * 下载模版
	 */
	@RequestMapping(value = "/downExcel")
	public void downExcel(HttpServletResponse response) throws Exception {

		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "Kpi.xls", "Kpi.xls");
	}
	/**
	 * 从EXCEL导入到数据库
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/readExcel")
	public ModelAndView readExcel(@RequestParam(value = "excel", required = false) MultipartFile file,HttpServletRequest request) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		PageData pdc = new PageData();
		
		if (null != file && !file.isEmpty()) {
			String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
			String fileName = FileUpload.fileUp(file, filePath, "modelexcel"); //执行上传

			List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 2, 0, 0); //执行读EXCEL操作,读出的数据导入List 1:从第3行开始；0:从第A列开始；0:第0个sheet
			
			
			/* 存入数据库操作====================================== */
			User user = UserUtils.getUser(request);
			pd.put("CREATE_USER", user.getNAME());
			pd.put("CREATE_TIME", new Date());
			pd.put("LAST_UPDATE_USER", user.getNAME());
			pd.put("LAST_UPDATE_TIME", new Date());

			
			/**
			 * var0:第一列      var1:第二列    varN:第N+1列
			 */
			for (int i = 0; i < listPd.size(); i++) {
				if(listPd.get(i).getString("var0")==""||listPd.get(i).getString("var0")==null||listPd.get(i).getString("var1")==""||listPd.get(i).getString("var1")==null
						||listPd.get(i).getString("var2")==""||listPd.get(i).getString("var2")==null||listPd.get(i).getString("var3")==""||listPd.get(i).getString("var3")==null
						||listPd.get(i).getString("var6")==""||listPd.get(i).getString("var6")==null)
				{
					mv.addObject("msg", "数据不全，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}
				String code = listPd.get(i).getString("var0");			
				pd.put("KPI_CODE", code);								//KPI编码
				pd.put("KPI_NAME", listPd.get(i).getString("var1")); 	//KPI名称
				String cate = listPd.get(i).getString("var2");
				pdc.put("NAME", cate);
				PageData ID = kpiCategoryService.findByName(pdc);
				if(ID==null)
				{
					mv.addObject("msg", "KPI类型不存在，请仔细检查");
					mv.setViewName("save_result");
					return mv;
				}
				pd.put("KPI_CATEGORY_ID", ID.get("ID"));				//kpi类型ID
				pd.put("KPI_CATEGORY_NAME", ID.get("NAME"));			//kpi类型名称
				String parent = listPd.get(i).getString("var3");
				pdc.put("KPI_CODE", parent);	
				PageData Parent = kpiFilesService.findByCode(pdc);
				if(Parent ==null)
				{
					Parent =new PageData();
					Parent.put("ID", 0);
				}
				pd.put("PARENT_ID",Parent.get("ID"));	//上级科目
				pd.put("KPI_UNIT", listPd.get(i).getString("var4"));	//KPI单位
				pd.put("KPI_DESCRIPTION", listPd.get(i).getString("var5"));	//指标描述
				pd.put("ENABLED", listPd.get(i).getString("var6").equals("是")?"1":"0");	//是否启用
				pd.put("KPI_SQL", listPd.get(i).getString("var7"));	//指标描述
								
				PageData sameList = kpiFilesService.findByCode(pd);
				if(sameList!=null)
				{					
					pd.put("ID", sameList.get("ID"));
					kpiFilesService.edit(pd);
				}
				else{
					kpiFilesService.save(pd);
				}
				
			}
			/* 存入数据库操作====================================== */
			mv.addObject("msg", "导入成功");
		}

		mv.setViewName("save_result");
		return mv;
	}
	
	


 
}
