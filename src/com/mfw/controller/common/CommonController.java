package com.mfw.controller.common;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mfw.util.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;


/**
 * 通用类
 * @author 作者 蒋世平
 * @date 创建时间：2018-4-26上午9:20:27
 */
@Controller
@RequestMapping(value="common")
public class CommonController extends BaseController{
	

	@RequestMapping("loadFile")
	public void loadFile(String fileName, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logBefore(logger, "下载附件");
		try {
			String name = fileName;
			String filePath = Tools.getRootFilePath() + Const.FILEPAT_IMPORT + "/" + name;
			FileDownload.fileDownload(response, filePath, "中高管月度考核汇总.xlsx");
		} catch (Exception e) {
			logger.error("下载附件出错", e);
		}
	}

	/**
	 * 组装上传页面参数
	 * @param viewName		上传页面名称
	 * @param downloadPath	模板下载的请求路径
	 * @param savePath		处理上传的请求路径
	 * @param isAjaxUpload	是否异步上传
	 * @return
	 */
	private ModelAndView getUploadView(String viewName, String downloadPath, String savePath, boolean isAjaxUpload){
		ModelAndView mv = new ModelAndView("commonUploadExcel");
		if(null != viewName){
			mv.setViewName(viewName);
		}
		//模板下载的请求url
		mv.addObject("downloadPath", downloadPath);
		//上传处理模板的url
		mv.addObject("savePath", savePath);
		//异步上传
		if(isAjaxUpload){
			mv.addObject("isAjaxUpload", isAjaxUpload);
		}
		
		return mv;
	}
	
	@RequestMapping("goUploadKpiModelExcel")
	public ModelAndView goUploadExcel(){
		//KPI模板导入
		PageData pd = this.getPageData();
		ModelAndView mv = getUploadView(null, "kpiModel/downloadExcel.do", "kpiModel/uploadExcel.do", false);
		mv.addObject("selectModelId", pd.get("MODEL_ID"));
	
		return mv;
	}
	
	@RequestMapping("goUploadPerformanceSummaryExcel")
	public ModelAndView goUploadPerformanceSummaryExcel(){
		//中高管绩效月度汇总
		ModelAndView mv = getUploadView(null, null, "performance/uploadPerformanceSummaryExcel.do", false);
		return mv;
	}

	@RequestMapping("goUploadEmpOtherInfoExcel")
	public ModelAndView goUploadEmpOtherInfoExcel(){
		//员工附加信息
		ModelAndView mv = getUploadView(null, null, "employee/uploadEmpOtherInfoExcel.do", true);
		return mv;
	}
	

	
	@RequestMapping("toShowListDetail")
	public ModelAndView toShowListDetail(){
		ModelAndView mv = new ModelAndView("commonListDetail");
		mv.addObject("pd", this.getPageData());
		return mv;
	}
	
}
