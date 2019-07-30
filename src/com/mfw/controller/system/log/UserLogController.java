package com.mfw.controller.system.log;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.service.system.UserLogService;
import com.mfw.util.PageData;

/**
 * 用户操作日志
 * @author  作者 李伟涛
 * @date 创建时间：2015年5月08日 下午15:28:18
 */
@Controller
@RequestMapping("/userlog")
public class UserLogController extends BaseController{

	@Resource(name="userLogService")
	private UserLogService userLogService;
	
	@ResponseBody
	@RequestMapping(value="/logList")
	public GridPage findList(Page page, HttpServletRequest request){
		convertPage(page, request);
		List<PageData> logList = new ArrayList<>();
//		int total = 0;
		try {
			logList = userLogService.listPage(page);
			
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			for(PageData log : logList){
				log.put("oper_date", dateFormat.format(log.get("oper_date")));
			}
			
//			total = userLogService.countLog(page);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new GridPage(logList, page);
	}
	
}
