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
 * 使用情况排名-定时任务
 * @author  作者 白惠文
 * @date 创建时间：2017年6月26日 下午17:01:02
 */
@Service
public class RankingQuartzFactory implements Job,ApplicationContextAware {   
	private static ApplicationContext applicationContext;

	@Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
    	AppService appService = (AppService) applicationContext.getBean("appService");
    	try {
			appService.sendRanking();
		} catch (Exception e1) {
			e1.printStackTrace();
		}

    }
	
	@Override
	public void setApplicationContext(ApplicationContext context) throws BeansException {
		applicationContext = context;
	}
 
} 
