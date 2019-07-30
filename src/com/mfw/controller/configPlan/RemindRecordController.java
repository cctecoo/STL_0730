package com.mfw.controller.configPlan;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.service.configPlan.RemindRecordService;
import com.mfw.util.Const;
import com.mfw.util.Logger;
import com.mfw.util.PageData;
import com.mfw.util.Tools;

import net.sf.json.JSONObject;

/**
 * 推送配置计划
 * @author  作者 白惠文
 * @date 创建时间：2017年7月31日 下午17:01:02
 */
@Controller
@RequestMapping(value="/remindRecord")
public class RemindRecordController extends BaseController{
	@Resource
	private RemindRecordService remindRecordService;
	private Logger log = Logger.getLogger(this.getClass());
	/**
	 * 列表
	 * @param page
	 * @return mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		Properties prop = Tools.loadPropertiesFile("message_tixing.properties");
		String empCode = getUser().getNUMBER();
		pd.put("empCode", empCode);
		List<PageData> list = remindRecordService.findRecord(pd);
		String url = "";
		String viewName = "";
		if(list.size()>0)
		{
			for (PageData record:list)
			{
				if(record.get("WORK")!=null)
				{
					viewName = record.getString("WORK");
				}
				if(record.get("TYPE")!=null)
				{										
					if(record.getString("TYPE").equals("daily"))
					{
						record.put("type", "日常任务");
					}
					else if(record.getString("TYPE").equals("cproject"))
					{
						record.put("type", "协同任务");
					}
					else if(record.getString("TYPE").equals("business"))
					{
						record.put("type", "目标任务");
					}
					else if(record.getString("TYPE").equals("flow"))
					{
						record.put("type", "流程任务");
					}
					else if(record.getString("TYPE").equals("temp"))
					{
						record.put("type", "临时任务");
					}
				}				

				url = prop.getProperty(Const.WEBSOCKET_URL_PREFFIX + viewName).replace("{id}", record.get("WORK_ID").toString()).replace("{empCode}", empCode);

				record.put("URL", url);		
			}
		}
		mv.addObject("list", list);
		//推送计划列表
		mv.setViewName("configPlan/remindList");
		return mv;
	}
	
	
	/**
	 * 标记已读
	 */
    @ResponseBody	
	@RequestMapping(value = "/updateRead")
	public String updateRead() throws Exception {
		logBefore(logger, "标记已读");
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			remindRecordService.editRecord(pd);
			return "success";
		} catch (Exception e) {
			log.error("更新历史消息记录状态出错",e);
			return "failed";			
		}
	}
    
	/**
	 * 一键标记已读
	 */
    @ResponseBody	
	@RequestMapping(value = "/updateAll")
	public String updateAll() throws Exception {
		logBefore(logger, "一键标记已读");
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			String emp_code = getUser().getNUMBER();
			pd.put("RECEIVER_CODE", emp_code);
			remindRecordService.updateAll(pd);
			return "success";
		} catch (Exception e) {
			log.error("一键标记已读出错",e);
			return "failed";			
		}
	}
    
    
	/**
	 * 根据条件查询消息历史
	 */
    @ResponseBody	
	@RequestMapping(value = "/record")
	public List<PageData> record() throws Exception {
		logBefore(logger, "根据条件查询消息历史");
		Properties prop = Tools.loadPropertiesFile("message_tixing.properties");
		PageData pd = new PageData();
		pd = this.getPageData();
		String empCode = getUser().getNUMBER();
		List<PageData> list = new ArrayList<PageData>();
		try {
			pd.put("empCode", empCode);
			list = remindRecordService.findRecord(pd);
			String url = "";
			String viewName ="";
			if(list.size()>0)
			{
				for (PageData record:list)
				{
					if(record.get("WORK")!=null)
					{
						viewName = record.getString("WORK");
					}
					url = prop.getProperty(Const.WEBSOCKET_URL_PREFFIX + viewName).replace("{id}", record.get("WORK_ID").toString()).replace("{empCode}", empCode);

					record.put("URL", url);		
				}
			}
		} catch (Exception e) {
			log.error("更新历史消息记录状态出错",e);		
		}		
		return list;
	}
}
