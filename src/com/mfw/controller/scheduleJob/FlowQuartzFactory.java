package com.mfw.controller.scheduleJob;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Service;

import com.mfw.service.configPlan.RemindConfigService;
import com.mfw.util.TaskType;

/**
 * 流程工作-定时任务
 * @author  作者 白惠文
 * @date 创建时间：2017年6月25日 下午15:21:22
 */
@Service
public class FlowQuartzFactory implements Job, ApplicationContextAware {
	private static ApplicationContext applicationContext;

	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		RemindConfigService remindConfigService = (RemindConfigService) applicationContext.getBean("remindConfigService");
		try {
			remindConfigService.saveMessage("", "", "", "", TaskType.flowOver);
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

