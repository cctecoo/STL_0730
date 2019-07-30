package com.mfw.controller.reform;

import java.util.List;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mfw.controller.base.BaseController;
import com.mfw.service.reform.BaseDataReformService;
import com.mfw.util.PageData;

/**
 * 基础数据列表
 * @author  作者  蒋世平
 * @date 创建时间：2016年5月18日 下午15:12:53
 */
@Controller
@RequestMapping("baseDataReform")
public class BaseDataReformController extends BaseController{
	
	@Resource(name="baseDataReformService")
	private BaseDataReformService baseDataReformService;

	@ResponseBody
	@RequestMapping("findProductList")
	public List<PageData> findProductList(){
		logBefore(logger, "查询可用的产品列表");
		PageData pd = this.getPageData();
		try {
			List<PageData> productList = baseDataReformService.findAllProduct(pd);
			return productList;
		} catch (Exception e) {
			logger.error("查询可用的产品列表出错", e);
			return null;
		}
	}
	
	@ResponseBody
	@RequestMapping("findDeptAndEmp")
	public JSONObject findDeptAndEmp(){
		logBefore(logger, "查询部门员工列表");
		JSONObject json = baseDataReformService.findEmployeeWithDept();
		return json;
	}
	
	@ResponseBody
	@RequestMapping("findUnitList")
	public List<PageData> findUnitList(){
		logBefore(logger, "查询单位列表");
		try {
			List<PageData> list = baseDataReformService.findAllUnit();
			return list;
		} catch (Exception e) {
			logger.error("查询单位列表出错", e);
		}
		return null;
	}
}
