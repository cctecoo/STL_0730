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
 * 销售分析-定时任务
 * @author  作者 白惠文
 * @date 创建时间：2017年6月28日 下午16:02:19
 */
@Service
public class ChartQuartzFactory implements Job, ApplicationContextAware {

	private static ApplicationContext applicationContext;

	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		AppService appService = (AppService) applicationContext.getBean("appService");
		try {
			appService.sendChart();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	@Override
	public void setApplicationContext(ApplicationContext context) throws BeansException {
		applicationContext = context;
	}

}
