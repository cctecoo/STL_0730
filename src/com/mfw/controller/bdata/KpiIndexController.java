package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mfw.controller.base.BaseController;
import com.mfw.service.bdata.KpiIndexService;

import net.sf.json.JSONObject;

/**
 * 基础数据-通用基础数据-emp_kpi_index表
 * @author  作者  蒋世平
 * @date 创建时间：2015年12月30日 下午17:42:21
 */
@Controller
@RequestMapping(value = "/kpiIndex")
public class KpiIndexController extends BaseController {
	
	@Resource(name="kpiIndexService")
	private KpiIndexService kpiIndexService;
	
	/**
	 * 员工修改页返回KPI明细
	 */
	@RequestMapping(value = "/kpiDetail",produces = "text/html;charset=UTF-8")
	public void kpiDetail(@RequestParam String empId, HttpServletResponse response) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			logBefore(logger, "kpiIndex查询");
			List<Object> kpiList = new ArrayList<Object>();
			
			kpiList = kpiIndexService.findByEmpid(empId);
			map.put("list", kpiList);
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
	
}
