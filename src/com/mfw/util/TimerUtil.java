package com.mfw.util;

import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import com.mfw.controller.base.BaseController;
import com.mfw.service.scheduleJob.ScheduleJobService;

/**
 * 登录验证过滤器 创建人：mfw 创建时间：2014年2月17日
 * 
 * @version
 */
public class TimerUtil extends BaseController implements ServletContextListener {
	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.HOUR_OF_DAY, 2); // 控制时
		calendar.set(Calendar.MINUTE,0); // 控制分
		calendar.set(Calendar.SECOND, 0); // 控制秒
		Date time = calendar.getTime(); // 得出执行任务的时间
		
		WebApplicationContext wac = ContextLoader.getCurrentWebApplicationContext(); 
		final ScheduleJobService scheduleJobService  = (ScheduleJobService)  wac.getBean("scheduleJobService");
		
		Timer timer = new Timer();
	
		timer.scheduleAtFixedRate(new TimerTask() {
			public void run() {
				try {
					scheduleJobService.init();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}, time, 1000 * 60 * 60 * 24);// 这里设定将延时每天固定执行
		
	}
	
	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		
	}
	
	
	

}
