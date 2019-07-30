package com.mfw.controller.scheduleJob;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Service;

import com.mfw.service.app.AppService;

/**
 * 超时任务-定时任务
 * @author  作者 白惠文
 * @date 创建时间：2017年6月22日 下午17:21:02
 */
@Service
public class TimeoutQuartzFactory implements Job,ApplicationContextAware {   
	private static ApplicationContext applicationContext;

	@Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
    	AppService appService = (AppService) applicationContext.getBean("appService");
    	try {
			appService.sendTimeout();
		} catch (Exception e1) {
			e1.printStackTrace();
		}

    }
	
	@Override
	public void setApplicationContext(ApplicationContext context) throws BeansException {
		applicationContext = context;
	}
 
} 
