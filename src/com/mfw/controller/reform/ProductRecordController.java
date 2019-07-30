package com.mfw.controller.reform;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.reform.ProductRecordService;
import com.mfw.util.Const;
import com.mfw.util.PageData;

/**
 * 产品记录
 * @author  作者  蒋世平
 * @date 创建时间：2017年7月5日 下午16:32:12
 */
@Controller
@RequestMapping("productRecord")
public class ProductRecordController extends BaseController{
	
	@Resource(name="employeeService")
	private EmployeeService employeeService;
	
	@Resource(name="productRecordService")
	private ProductRecordService productRecordService;
	
	@RequestMapping("toProductRecordSummary")
	public ModelAndView toProductRecordSummary(){
		ModelAndView mv =new ModelAndView();
		logBefore(logger, "进入产品记录页");
		mv.addObject("EMP_CODE", getUser().getNUMBER());
		mv.setViewName("productRecord/productRecordSummary");
		
		return mv;
	}
	
	@RequestMapping("toProductRecordResult")
	public ModelAndView toProductRecordResult(){
		ModelAndView mv =new ModelAndView();
		logBefore(logger, "展示产品记录结果");
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM");
			mv.addObject("queryMonth", sdf.format(new Date()));
			mv.addObject("isAdminGroup", isAdminGroup());
		} catch (Exception e) {
			logger.error("toProductRecordResult error", e);
		}
		
		mv.addObject("EMP_CODE", getUser().getNUMBER());
		mv.setViewName("productRecord/productRecordResult");
		
		return mv;
	}
	
	@RequestMapping("toProductRecordList")
	public ModelAndView toProductRecordList(){
		ModelAndView mv =new ModelAndView("productRecord/productRecordList");
		logBefore(logger, "进入产品记录列表页面");
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM");
			List<PageData> recordTypeList = productRecordService.findRecordTypeList();
			//配置页面增加退回权限
			PageData rejectPd = new PageData();
			rejectPd.put("recordTypeCode", "rejectProductRecord");
			rejectPd.put("recordTypeName", "退回权限");
			recordTypeList.add(rejectPd);
			
			//获取登陆用户的管理员权限等信息
			mv.addAllObjects(getAdminAndConfigEmp(employeeService, null));
			//查询员工可以维护的记录类型
			mv.addObject("configPageList", findConfigPages(true));
			
			mv.addObject("recordTypeList", recordTypeList);
//			mv.addObject("actualStoreType", Const.CONFIG_PAGE_PRODUCT_RECORD_ACTUALSTORE);
//			mv.addObject("queryMonth", sdf.format(new Date()));
		} catch (Exception e) {
			logger.error("查询员工维护权限出错", e);
		}
		
		return mv;
	}
	
	/**
	 * 查询员工是否可以维护多个页面
	 */
	private List<PageData> findConfigPages(boolean isFindRejectRights) throws Exception{
		//获取记录类型列表
		List<String> showPages = productRecordService.findProductRecordTypes();
		if(isFindRejectRights){
			showPages.add("rejectProductRecord");//配置页面增加退回权限
		}
		
		List<PageData> configPageList = employeeService.findIsChangeByShowpages(getUser().getNUMBER(), showPages);
		return configPageList;
	}
	
	@RequestMapping("toEditProductRecord")
	public ModelAndView toEditProductRecord(){
		ModelAndView mv = new ModelAndView();
		logBefore(logger, "进入添加记录页面");
		PageData pd = this.getPageData();
		try {
			if(null != pd.get("id")){//id不为空表示编辑记录
				PageData productRecord = productRecordService.findProductRecord(Integer.valueOf(pd.getString("id")));
				mv.addObject("productRecord", productRecord);
			}
			//所有的产品记录类型
			mv.addObject("recordTypeList", productRecordService.findRecordTypeList());
			//查询员工可以维护的哪些类型
			mv.addObject("configPageList", findConfigPages(false));
			mv.addAllObjects(getAdminAndConfigEmp(employeeService, null));
		} catch (Exception e) {
			logger.error("查询产品记录出错", e);
		}
		mv.setViewName("productRecord/editProductRecord");
		
		return mv;
	}
	
	@ResponseBody
	@RequestMapping("saveProductRecord")
	public String saveProductRecord(){
		logBefore(logger, "保存产品记录");
		PageData pd = this.getPageData();
		User user = getUser();
		
		return productRecordService.saveProductRecord(pd, user);
	}
	
	@ResponseBody
	@RequestMapping("deleteProductRecord")
	public String deleteProductRecord(){
		logBefore(logger, "删除记录,状态置为已作废");
		PageData pd = this.getPageData();
		try {
			Integer recordId = Integer.valueOf(pd.get("id").toString());
			productRecordService.deleteProductRecord(recordId, getUser());
			return "success";
		} catch (Exception e) {
			logger.error("删除记录,状态置为已作废，出错", e);
			return "error";
		}
	}
	
	@ResponseBody
	@RequestMapping("submitProductRecord")
	public String submitProductRecord(){
		logBefore(logger, "提交记录,状态置为已生效");
		PageData pd = this.getPageData();
		try {
			Integer recordId = Integer.valueOf(pd.get("id").toString());;
			productRecordService.submitProductRecord(recordId, getUser());
			return "success";
		} catch (Exception e) {
			logger.error("提交记录,状态置为已生效，出错", e);
			return "error";
		}
	}
	
	@ResponseBody
	@RequestMapping("resetProductRecord")
	public String resetProductRecord(){
		logBefore(logger, "resetProductRecord start");
		PageData pd = this.getPageData();
		try {
			//记录id
			Integer recordId = Integer.valueOf(pd.get("id").toString());
			//更新的类型
			String resetType = pd.getString("resetType");
			productRecordService.resetProductRecord(recordId, resetType, getUser());
			return "success";
		} catch (Exception e) {
			logger.error("resetProductRecord error", e);
			return "error";
		}
	}
	
	@ResponseBody
	@RequestMapping("findProductList")
	public GridPage findProductList(Page page, HttpServletRequest request){
		logBefore(logger, "查询产品记录");
		convertPage(page, request);
		PageData pd = page.getPd();
		List<PageData> list = new ArrayList<PageData>();
		try {
			if(null == pd.get("findDetail") && null==pd.get("currentUsername")){
				pd.put("currentUsername", getUser().getUSERNAME());
			}
			
			page.setPd(pd);
			list = productRecordService.findProductList(page);
		} catch (Exception e) {
			logger.error("查询产品记录出错", e);
		}
		return new GridPage(list, page);
	}
	
	@ResponseBody
	@RequestMapping(value="findSameParentProductRecordSummary", produces="text/html;charset=UTF-8")
	public String findSameParentProductRecordSummary(){
		logBefore(logger, "查询大类产品记录的汇总情况,同一大类返回一行记录");
		PageData pd = this.getPageData();
		JSONObject json = productRecordService.summaryRecordAmountByParentProduct(pd);
		
		/*
		JSONObject json = productRecordService.findSameParentProductRecordSummary(pd);
		*/
		
		return json.toString();
	}
	
	@ResponseBody
	@RequestMapping(value="findProductRecordSummary", produces="text/html;charset=UTF-8")
	public String findProductRecordSummary(){
		logBefore(logger, "查询子类产品记录的汇总情况,返回同一大类下的汇总记录");
		PageData pd = this.getPageData();
		JSONObject json = productRecordService.findProductRecordSummary(pd);
		return json.toString();
	}
	
	/*
	@ResponseBody
	@RequestMapping(value="findParentProductRecordSummary", produces="text/html;charset=UTF-8")
	public String findParentProductRecordSummary(){
		logBefore(logger, "查询大类产品记录的汇总情况");
		PageData pd = this.getPageData();
		JSONObject json = productRecordService.findParentProductRecordSummary(pd);
		return json.toString();
	}
	
	
	@ResponseBody
	@RequestMapping(value="findChildProductRecordSummary", produces="text/html;charset=UTF-8")
	public String findChildProductRecordSummary(){
		logBefore(logger, "查询子类产品记录的汇总情况");
		PageData pd = this.getPageData();
		JSONObject json = productRecordService.findChildProductRecordSummary(pd);
		return json.toString();
	}
	*/
	
	@RequestMapping("showProductRecordList")
	public ModelAndView showProductRecordList(){
		logBefore(logger, "查询产品记录详情");
		ModelAndView mv = new ModelAndView("productRecord/ProductRecordDetail");
		PageData pd = this.getPageData();
		String recordType = pd.getString("recordType");
		mv.addObject("recordType", recordType);
//		if(Const.CONFIG_PAGE_PRODUCT_RECORD_SALEPLAN.equals(recordType)
//			|| Const.CONFIG_PAGE_PRODUCT_RECORD_ACTUALSALE.equals(recordType)){
//			mv.addObject("isSaleRecord", true);
//		}else if(Const.CONFIG_PAGE_PRODUCT_RECORD_INSTORE.equals(recordType)){
//			mv.addObject("isInStore", true);
//		}
		mv.addObject("pd", pd);
		return mv;
	}
	
}
