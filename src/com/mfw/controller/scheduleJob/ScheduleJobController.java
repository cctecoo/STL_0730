package com.mfw.controller.scheduleJob;

import javax.annotation.Resource;

import org.quartz.impl.StdScheduler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mfw.controller.base.BaseController;

import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.scheduleJob.ScheduleJobService;
import com.mfw.service.system.user.UserService;

/**
 * 初始化定时任务
 * @author  作者 白惠文
 * @date 创建时间：2017年6月23日 下午16:51:02
 */
@Controller
@RequestMapping(value = "/scheduleJob")
public class ScheduleJobController extends BaseController {

	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name = "userService")
	private UserService userService;
	@Resource(name = "scheduler")
	private StdScheduler scheduler;
	@Resource
	private ScheduleJobService scheduleJobService;
	
	/**
	 * 初始化定时任务内容
	 */
	@RequestMapping(value = "/init")
	public void init() {
		try {
			scheduleJobService.init();
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
	}



}
