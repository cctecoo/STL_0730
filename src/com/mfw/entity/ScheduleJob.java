package com.mfw.entity;

import java.util.Date;
import java.util.List;

import com.mfw.util.PageData;

/**
 * 定时任务实体类
 * @author  作者 白惠文
 * @date 创建时间：2017年6月8日 下午17:51:40
 */
public class ScheduleJob {
	private Long jobId;
    /** 
     * 任务开始时间
     */	
	private String startDate;
    /** 
     * 任务结束时间
     */
	private String endDate;
    /** 
     * 任务名称-唯一标识
     */ 
	private String jobName;
    /** 
     * cron表达式
     */ 
	private String cronExpression;
    /** 
     * 任务执行时调用哪个类的方法 包名+类名
     */  
    private String beanClass;
    /** 
     * 任务状态 是否启动任务 
     */  
    private String jobStatus;
	/** 
     * spring bean 
     */  
    private String springId;
    /** 
     * 任务调用的方法名 
     */  
    private String methodName;
    /** 
     *  任务内容
     */  
    private String model;
    /** 
     *  消息接收人
     */  
    private List<String> openId;
    
	public List<String> getOpenId() {
		return openId;
	}
	public void setOpenId(List<String> openId) {
		this.openId = openId;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public String getJobStatus() {
		return jobStatus;
	}
	public void setJobStatus(String jobStatus) {
		this.jobStatus = jobStatus;
	}
	public Long getJobId() {
		return jobId;
	}
	public void setJobId(Long jobId) {
		this.jobId = jobId;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getJobName() {
		return jobName;
	}
	public void setJobName(String jobName) {
		this.jobName = jobName;
	}
	public String getCronExpression() {
		return cronExpression;
	}
	public void setCronExpression(String cronExpression) {
		this.cronExpression = cronExpression;
	}
	public String getBeanClass() {
		return beanClass;
	}
	public void setBeanClass(String beanClass) {
		this.beanClass = beanClass;
	}
	public String getSpringId() {
		return springId;
	}
	public void setSpringId(String springId) {
		this.springId = springId;
	}
	public String getMethodName() {
		return methodName;
	}
	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}

}
