package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.entity.system.Menu;
import com.mfw.service.bdata.KpiModelLineService;
import com.mfw.util.AppUtil;
import com.mfw.util.Const;
import com.mfw.util.ObjectExcelView;
import com.mfw.util.PageData;
import com.mfw.util.Tools;

/**
 * 基础数据-通用基础数据-KPI模板详情
 * @author  作者  蒋世平
 * @date 创建时间：2015年12月23日 下午15:12:34
 */
@Controller
@RequestMapping(value="/kpiModelLine")
public class KpiModelLineController extends BaseController {
	
	@Resource(name="kpiModelLineService")
	private KpiModelLineService kpiModelLineService;
	
	/**
	 * 新增
	 */
	@RequestMapping(value="/save")
	public ModelAndView save() throws Exception{
		logBefore(logger, "bd_kpi_model_line新增");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd.put("BDBUDGETMODELLINE_ID", this.get32UUID());	//主键
		pd.put("MODEL_ID", "");	//模板ID
		pd.put("CATEGORY_CODE", "");	//科目类型编码
		pd.put("CATEGORY_NAME", "");	//科目类型名称
		pd.put("SUBJECT_CODE", "");	//科目编码
		pd.put("SUBJECT_NAME", "");	//科目名称
		pd.put("CREATE_USER", "");	//创建人
		pd.put("CREATE_TIME", Tools.date2Str(new Date()));	//创建时间
		pd.put("LAST_UPDATE_USER", "");	//最后修改人
		pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));	//最后修改时间
		kpiModelLineService.save(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 删除
	 */
	@RequestMapping(value="/delete")
	public void delete(PrintWriter out){
		logBefore(logger, "删除BdBudgetModelLine");
		PageData pd = new PageData();
		try{
			pd = this.getPageData();
			kpiModelLineService.delete(pd);
			out.write("success");
			out.close();
		} catch(Exception e){
			logger.error(e.toString(), e);
		}
		
	}
	
	/**
	 * 修改
	 */
	@RequestMapping(value="/edit")
	public ModelAndView edit() throws Exception{
		logBefore(logger, "修改BdBudgetModelLine");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		kpiModelLineService.edit(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 列表
	 */
	@RequestMapping(value="/list")
	public ModelAndView list(Page page){
		logBefore(logger, "列表BdBudgetModelLine");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try{
			pd = this.getPageData();
			page.setPd(pd);
			List<PageData>	varList = kpiModelLineService.list(page);	//列出BdBudgetModelLine列表
			this.getHC(); //调用权限
			mv.setViewName("budget/bdbudgetmodelline/bdbudgetmodelline_list");
			mv.addObject("varList", varList);
			mv.addObject("pd", pd);
		} catch(Exception e){
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	/**
	 * 去新增页面
	 */
	@RequestMapping(value="/goAdd")
	public ModelAndView goAdd(){
		logBefore(logger, "去新增BdBudgetModelLine页面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {
			mv.setViewName("budget/bdbudgetmodelline/bdbudgetmodelline_edit");
			mv.addObject("msg", "save");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}						
		return mv;
	}	
	
	/**
	 * 去修改页面
	 */
	@RequestMapping(value="/goEdit")
	public ModelAndView goEdit(){
		logBefore(logger, "去修改BdBudgetModelLine页面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {
			pd = kpiModelLineService.findById(pd);	//根据ID读取
			mv.setViewName("budget/bdbudgetmodelline/bdbudgetmodelline_edit");
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}						
		return mv;
	}	
	
	/**
	 * 批量删除
	 */
	@RequestMapping(value="/deleteAll")
	@ResponseBody
	public Object deleteAll() {
		logBefore(logger, "批量删除BdBudgetModelLine");
		PageData pd = new PageData();		
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			pd = this.getPageData();
			List<PageData> pdList = new ArrayList<PageData>();
			String DATA_IDS = pd.getString("DATA_IDS");
			if(null != DATA_IDS && !"".equals(DATA_IDS)){
				String ArrayDATA_IDS[] = DATA_IDS.split(",");
				kpiModelLineService.deleteAll(ArrayDATA_IDS);
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
	
	/*
	 * 导出到excel
	 * @return
	 */
	@RequestMapping(value="/excel")
	public ModelAndView exportExcel(){
		logBefore(logger, "导出BdBudgetModelLine到excel");
		ModelAndView mv = new ModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try{
			Map<String,Object> dataMap = new HashMap<String,Object>();
			List<String> titles = new ArrayList<String>();
			titles.add("模板ID");	//1
			titles.add("科目类型编码");	//2
			titles.add("科目类型名称");	//3
			titles.add("科目编码");	//4
			titles.add("科目名称");	//5
			titles.add("创建人");	//6
			titles.add("创建时间");	//7
			titles.add("最后修改人");	//8
			titles.add("最后修改时间");	//9
			dataMap.put("titles", titles);
			List<PageData> varOList = kpiModelLineService.listAll(pd);
			List<PageData> varList = new ArrayList<PageData>();
			for(int i=0;i<varOList.size();i++){
				PageData vpd = new PageData();
				vpd.put("var1", varOList.get(i).getString("MODEL_ID"));	//1
				vpd.put("var2", varOList.get(i).getString("CATEGORY_CODE"));	//2
				vpd.put("var3", varOList.get(i).getString("CATEGORY_NAME"));	//3
				vpd.put("var4", varOList.get(i).getString("SUBJECT_CODE"));	//4
				vpd.put("var5", varOList.get(i).getString("SUBJECT_NAME"));	//5
				vpd.put("var6", varOList.get(i).getString("CREATE_USER"));	//6
				vpd.put("var7", varOList.get(i).getString("CREATE_TIME"));	//7
				vpd.put("var8", varOList.get(i).getString("LAST_UPDATE_USER"));	//8
				vpd.put("var9", varOList.get(i).getString("LAST_UPDATE_TIME"));	//9
				varList.add(vpd);
			}
			dataMap.put("varList", varList);
			ObjectExcelView erv = new ObjectExcelView();
			mv = new ModelAndView(erv,dataMap);
		} catch(Exception e){
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	/* ===============================权限================================== */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void getHC(){
		ModelAndView mv = this.getModelAndView();
		HttpSession session = this.getRequest().getSession();
		Map<String, String> map = (Map<String, String>)session.getAttribute(Const.SESSION_QX);
		mv.addObject(Const.SESSION_QX,map);	//按钮权限
		List<Menu> menuList = (List)session.getAttribute(Const.SESSION_menuList);
		mv.addObject(Const.SESSION_menuList, menuList);//菜单权限
	}
	/* ===============================权限================================== */
	
	@InitBinder
	public void initBinder(WebDataBinder binder){
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(format,true));
	}
}
