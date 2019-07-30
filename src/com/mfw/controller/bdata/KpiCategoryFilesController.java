package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.service.bdata.KpiCategoryFilesService;
import com.mfw.util.PageData;

/**
 * 基础数据-通用基础数据-KPI指标分类
 * @author  作者  蒋世平
 * @date 创建时间：2015年12月16日 下午17:02:31
 */
@Controller
@RequestMapping(value = "/kpiCategoryFiles")
public class KpiCategoryFilesController extends BaseController {
	
	@Resource(name = "kpiCategoryService")
	private KpiCategoryFilesService kpiCategoryService;
	
	/**
	 * 列表
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) {
		logBefore(logger, "bd_kpi_category_files列表");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = this.getPageData();
			PageData pdName = new PageData();

			page.setPd(pd);
			List<PageData> varList = kpiCategoryService.listAll(pd); //列出category列表
			pd = kpiCategoryService.findById(pd); //根据ID读取
			pdName = kpiCategoryService.findByParentIdName(pd);
			if(null != pdName){
				String parentName = pdName.getString("NAME");
				pd.put("parentName", parentName);
			}
			
			mv.setViewName("bdata/kpi/kpiCategoryFiles_list");
			mv.addObject("varList", varList);
			mv.addObject("msg", "edit");
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
	public ModelAndView goAdd() throws Exception {
		logBefore(logger, "bd_kpi_category_files表新增页面跳转");
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
	 * 新增次级页面跳转
	 */
	@RequestMapping(value = "/goAddSec")
	public ModelAndView goAddSec() throws Exception {
		logBefore(logger, "bd_kpi_category_files表新增次级页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			PageData pdName = new PageData();
			pd = this.getPageData();
			pdName = kpiCategoryService.findByIdName(pd);
			String parentName = pdName.getString("NAME");
			pd.put("parentName", parentName);

			mv.setViewName("bdata/kpi/kpiCategoryFiles_addSec");
			mv.addObject("msg", "saveSec");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}
	
	/**
	 * KPI类别新增验证
	 */
	@RequestMapping(value = "/checkKpiCategory")
	public void checkKpiCategory(String kpiCode, PrintWriter out){
		try{
			PageData pd = new PageData();
			pd.put("CODE", kpiCode);
			
			logBefore(logger, "KPI类别新增验证");
			PageData kpiCategoryData  = kpiCategoryService.findByCode(pd);
			//判断用户所填code是否重复
			if(null == kpiCategoryData){
				out.write("true");
			}else{
				out.write("false");
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
		logBefore(logger, "bd_kpi_category_files表新增");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			
			kpiCategoryService.save(pd);
			
			mv.addObject("msg","success");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/**
	 * 新增次级
	 */
	@RequestMapping(value = "/saveSec")
	public ModelAndView saveSec() throws Exception {
		logBefore(logger, "bd_kpi_category_files表新增次级");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			
			kpiCategoryService.saveSec(pd);
			
			mv.addObject("msg","success");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete")
	public void delete(PrintWriter out) {
		logBefore(logger, "bd_kpi_category_files表删除");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			kpiCategoryService.delete(pd);
			out.write("success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} finally{
			out.flush();
	        out.close();
		}

	}
	
	/**
	 * 修改页面跳转
	 */
	@RequestMapping(value = "/goEdit")
	public ModelAndView goEdit() {
		logBefore(logger, "bd_kpi_category_files表修改页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			pd = kpiCategoryService.findById(pd); //根据ID读取
			mv.setViewName("bdata/kpi/kpiCategoryFiles_edit");
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
		logBefore(logger, "修改表 bd_kpi_category_files");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();

			kpiCategoryService.edit(pd); //执行修改数据库
			mv.addObject("msg","success");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
}
