package com.mfw.controller.configPlan;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.ScheduleJob;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.configPlan.RemindConfigService;
import com.mfw.service.scheduleJob.ScheduleJobService;
import com.mfw.util.PageData;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 报表配置计划
 * @author  作者 白惠文
 * @date 创建时间：2017年5月11日 下午17:11:30
 */
@Controller
@RequestMapping(value="/configPlan")
public class configPlanController extends BaseController{
    @Resource(name = "commonService")
    private CommonService commonService;
    @Resource(name = "scheduleJobService")
    private ScheduleJobService scheduleJobService;
	@Resource(name = "deptService")
	private DeptService deptService;	
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name = "remindConfigService")
	private RemindConfigService remindConfigService;
	
    /**
     * 进入配置计划页面
     * @param page
     * @return mv
     * @throws Exception
     * author 白惠文
     */
    @RequestMapping(value="/goConfigPlan")
    public ModelAndView goConfigPlan(Page page) throws Exception{
        logBefore(logger, "报表配置计划");

        ModelAndView mv = this.getModelAndView();
        PageData pd = this.getPageData();       
        PageData plan = new PageData();
		List<PageData> deptLists = new ArrayList<PageData>();
		
		//获取所有部门
		deptLists = deptService.listAlln();        
		List<PageData> employeeLists = new ArrayList<PageData>();
		for(PageData dept : deptLists){
			employeeLists.addAll(employeeService.findEmpByDeptPd(dept));
		}
		deptLists.addAll(employeeLists);					
		//根据viewName获取推送配置计划，若有则为修改，否则为新增	
        plan = scheduleJobService.findConfigDetail(pd);
        
        if(plan!=null)
        {
        	mv.addObject("flag", "edit");
        	List<PageData> empList = scheduleJobService.findEmpByPlanId(plan);
    		String empName = "";
    		String empId = "";
    		for(PageData dept : deptLists){
    			for(PageData emp : empList){
    				if(dept.get("ID").equals(emp.get("EMP_ID"))){
    					dept.put("checked", true);
    					empName+=dept.getString("DEPT_NAME")+",";
    					empId +=dept.get("ID").toString()+",";
    				}
    			}
    		}    		
    		PageData pdm = new PageData();
    		if(empName!=null && !"".equals(empName))
    		{
    			pdm.put("empName",empName.substring(0, empName.length()-1));
    			pdm.put("empId",empId.substring(0, empId.length()-1));
    		}
    		else
    		{
    			pdm.put("empName","");
    			pdm.put("empId","");
    		}
    		 mv.addObject("pdm", pdm);
        }else
        {
        	mv.addObject("flag", "new");
        }
        JSONArray arr = JSONArray.fromObject(deptLists);
        mv.addObject("deptTreeNodes", arr.toString());
        mv.addObject("plan", plan);
        mv.setViewName("configPlan/config");
  		mv.addObject("pd", pd);
        return mv;
    }
    
    
    
	/**
	 * 保存
	 */
    @ResponseBody
	@RequestMapping(value = "/saveConfig")
	public JSONObject save() throws Exception {
		logBefore(logger, "编辑报表推送计划");
		try {
			PageData pd = new PageData();
			PageData pdm = new PageData();
			List<PageData> savePdList = new ArrayList<PageData>();
			pd = this.getPageData();

			String emp_ids = pd.getString("EMP_ID");
			String[] empIdlist = null;
			if (emp_ids != null && !"".equals(emp_ids)){
				empIdlist = emp_ids.split(",");
			}
			//如果是修改
			if(pd.get("flag").equals("edit"))
			{
				scheduleJobService.editPlan(pd);
				scheduleJobService.deleteConfigPerson(pd);
			}else if(pd.get("flag").equals("new"))
			{
				//如果是新增
				scheduleJobService.addPlan(pd);				
			}
			//查询保存后的结果
			pdm = scheduleJobService.findConfigDetail(pd);
			// 批量保存数据			
			if (empIdlist != null) {
				for (int j = 0; j < empIdlist.length; j++) {
					PageData savePd = new PageData();
					savePd.put("PLAN_ID", pdm.get("ID").toString());
					savePd.put("EMP_ID", empIdlist[j]);
					savePdList.add(savePd);
				}
			}
			// 批量存入数据库
			if(savePdList.size() > 0)
			{
				scheduleJobService.batchSavePlan(savePdList);
			}			
			scheduleJobService.init();
			Map<String,String> str = new HashMap();
			str.put("biaozhi", "success");
			JSONObject json= JSONObject.fromObject(str);			
			return json;
		} catch (Exception e) {			
			Map<String,String> str = new HashMap();
			str.put("biaozhi", "fail");
			JSONObject json= JSONObject.fromObject(str);	
			logger.error(e.toString(), e);
			return json;			
		}		
	}
    
	/**
	 * 列表
	 * 
	 * @param page
	 * @return mv
	 * @throws Exception
	 * 
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		//推送计划列表
		mv.setViewName("configPlan/list");
		return mv;
	}
    /**
     * 推送计划表格
     * @param page
     * @return mv
     * @throws Exception
     * author 白惠文
     */
    @ResponseBody
    @RequestMapping(value="/planList")
	public GridPage planList(Page page, HttpServletRequest request) {
        logBefore(logger, "报表推送计划列表");
        //处理查询条件
		convertPage(page, request);
		PageData pd = page.getPd();
        List<PageData> list = new ArrayList<PageData>();
        try {
			list = scheduleJobService.findAllConfig(pd);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}       
        return new GridPage(list, page);
    }
    
    
    
	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete")
	public void delete(PrintWriter out) {
		logBefore(logger, "删除推送计划");
		PageData pd = new PageData();
		PageData pdm = new PageData();
		try {
			pd = this.getPageData();
			pdm = scheduleJobService.findConfigDetailById(pd);
			ScheduleJob scheduleJob = new ScheduleJob();
			scheduleJob.setJobName(pdm.get("VIEWNAME").toString());
			scheduleJobService.deleteJob(scheduleJob);
			//删除计划
			scheduleJobService.deletePlanConfig(pd);
			//删除推送人
			scheduleJobService.deleteConfigPerson(pd);
			out.write("success");
		} catch (Exception e) {
			out.write("error");
			logger.error(e.toString(), e);
		}
		out.close();
	}
	
	
	/**
	 * 提醒配置界面
	 * 
	 * @param page
	 * @return mv
	 * @throws Exception
	 * 
	 */
	@RequestMapping(value = "/remindConfig")
	public ModelAndView remindConfig(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData plan = new PageData();
		plan = remindConfigService.findConfig(plan);
		mv.addObject("plan",plan);
		mv.setViewName("configPlan/remindConfig");
		return mv;
	}
	
	
	/**
	 * 保存提醒配置
	 */
    @ResponseBody
	@RequestMapping(value = "/saveRemind")
	public JSONObject saveRemind() throws Exception {
		logBefore(logger, "保存提醒计划");
		Map<String,String> str = new HashMap();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			//设置时间字段为null
			if(pd.containsKey("AIMTIME") && pd.get("AIMTIME").toString().isEmpty()){
				pd.put("AIMTIME", null);
			}
			if(pd.containsKey("TEMPTIME") && pd.get("TEMPTIME").toString().isEmpty()){
				pd.put("TEMPTIME", null);
			}
			if(pd.containsKey("GROUPTIME") && pd.get("GROUPTIME").toString().isEmpty()){
				pd.put("GROUPTIME", null);
			}
			if(pd.containsKey("FLOWTIME") && pd.get("FLOWTIME").toString().isEmpty()){
				pd.put("FLOWTIME", null);
			}
			remindConfigService.save(pd);//remind_plan，消息推送计划
			
			//后边保存模板推送计划
			if(pd.get("DAILYTIME")!=null&&!pd.get("DAILYTIME").toString().equals(""))
			{
				remindConfigService.saveRemind(pd,"daily");
			}
			if(pd.get("GROUPTIME")!=null&&!pd.get("GROUPTIME").toString().equals("")&&pd.get("GROUPREMINDTIME")!=null)
			{
				remindConfigService.saveRemind(pd,"cProject");
			}
			if(pd.get("AIMTIME")!=null&&!pd.get("AIMTIME").toString().equals("")&&pd.get("AIMREMINDTIME")!=null)
			{
				remindConfigService.saveRemind(pd,"business");
			}
			if(pd.get("FLOWTIME")!=null&&!pd.get("FLOWTIME").toString().equals("")&&pd.get("FLOWREMINDTIME")!=null)
			{
				remindConfigService.saveRemind(pd,"flow");
			}
			if(pd.get("TEMPTIME")!=null&&!pd.get("TEMPTIME").toString().equals("")&&pd.get("TEMPREMINDTIME")!=null)
			{
				remindConfigService.saveRemind(pd,"temp");
			}
			
			str.put("biaozhi", "success");
			JSONObject json= JSONObject.fromObject(str);			
			return json;
		} catch (Exception e) {			
			str.put("biaozhi", "fail");
			JSONObject json= JSONObject.fromObject(str);	
			logger.error(e.toString(), e);
			return json;			
		}		
	}
	
    
    

}
