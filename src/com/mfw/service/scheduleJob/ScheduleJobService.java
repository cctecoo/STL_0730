package com.mfw.service.scheduleJob;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.quartz.CronScheduleBuilder;
import org.quartz.CronTrigger;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.JobExecutionContext;
import org.quartz.JobKey;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.quartz.TriggerKey;
import org.quartz.impl.StdScheduler;
import org.quartz.impl.matchers.GroupMatcher;
import org.springframework.stereotype.Service;

import com.mfw.controller.scheduleJob.BusinessQuartzFactory;
import com.mfw.controller.scheduleJob.CProjectQuartzFactory;
import com.mfw.controller.scheduleJob.ChartQuartzFactory;
import com.mfw.controller.scheduleJob.DailyReportQuartzFactory;
import com.mfw.controller.scheduleJob.DailyTaskQuartzFactory;
import com.mfw.controller.scheduleJob.FlowQuartzFactory;
import com.mfw.controller.scheduleJob.RankingQuartzFactory;
import com.mfw.controller.scheduleJob.ReportQuartzFactory;
import com.mfw.controller.scheduleJob.TempQuartzFactory;
import com.mfw.controller.scheduleJob.TimeoutQuartzFactory;
import com.mfw.controller.scheduleJob.WeeklysummaryQuartzFactory;
import com.mfw.dao.DaoSupport;
import com.mfw.entity.ScheduleJob;
import com.mfw.service.app.AppService;
import com.mfw.service.system.user.UserService;
import com.mfw.util.PageData;
import com.mfw.util.Tools;

/**
 * 定时任务
 * @author  作者 白惠文
 * @date 创建时间：2017年6月30日 下午17:42:14
 */
@Service
public class ScheduleJobService {
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	@Resource
	private ScheduleJobService scheduleJobService;
	@Resource
	private UserService userService;
	@Resource(name = "scheduler")
	private StdScheduler scheduler;
	private static final  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	@Resource(name="appService")
	private AppService appService;
	
	public void init() throws Exception{
		Properties prop = Tools.loadPropertiesFile("config.properties");
		String quartz = prop.getProperty("QUARTZ");
		if(quartz.equals("yes"))
		{
			PageData pd = new PageData();
			PageData dailyJob = new PageData();
			// 筛选出日期包括今日的
			pd.put("status", "0");
			pd.put("viewName", "daily");
			// 这里从数据库中获取任务信息数据
			List<PageData> jobList = new ArrayList<PageData>();
			jobList = scheduleJobService.findAllConfig(pd);		
			// 将结果遍历，并调用创建/修改定时任务的方法
			for (PageData job : jobList) {
				if(job.get("VIEWNAME").toString().equals("daily")||job.get("VIEWNAME").toString().equals("cProject")||job.get("VIEWNAME").toString().equals("business")||job.get("VIEWNAME").toString().equals("flow")||job.get("VIEWNAME").toString().equals("temp"))
				{
					Calendar yesterday = Calendar.getInstance();
					Calendar tomorrow = Calendar.getInstance();
					yesterday.setTime(new Date());
					yesterday.set(Calendar.DATE, yesterday.get(Calendar.DATE) - 1);			
					tomorrow.setTime(new Date());
					tomorrow.set(Calendar.DATE, tomorrow.get(Calendar.DATE) + 1);
					job.put("START_DATE", sdf.format(yesterday.getTime()));
					job.put("END_DATE", sdf.format(tomorrow.getTime()));
				}
				addTask(job);
			}
			getAllJob();
		}
		else
		{
			System.out.println("定时器开关："+quartz+",定时器未启动");
		}
	}
	
	/**
	 * 将数据库结果遍历，并调用创建/修改定时任务的方法
	 * 
	 * @param List
	 * @throws Exception
	 * @author 白惠文
	 */
	public void addTask(PageData pd) throws Exception {
		PageData job = pd;
		List<String> openId = new ArrayList<String>();
		PageData user = new PageData();
		ScheduleJob sJob = new ScheduleJob();
		List<PageData> empPlanList = scheduleJobService.findEmpByPlanId(job);
		if (empPlanList != null) {
			for (PageData empPlan : empPlanList) {
				user = userService.findOpenIdByEmpId(empPlan);
				if (user != null) {
					openId.add(user.getString("OPEN_ID"));
				}
			}
			String cronExpression = editCron(job);
			//String cronExpression = "0/20 * * * * ?";
			if (!cronExpression.equals("")) {
				sJob.setCronExpression(cronExpression);
			}
			sJob.setStartDate(job.get("START_DATE").toString());
			sJob.setEndDate(job.get("END_DATE").toString());
			sJob.setJobName(job.getString("VIEWNAME"));
			sJob.setModel(job.getString("MODEL"));
			sJob.setOpenId(openId);
			System.out.println(sJob);
			addJob(sJob);
		}
	}
	
	/**
	 * 拼接cron表达式
	 * 
	 * @param List
	 * @throws Exception
	 * @author 白惠文
	 */
	private String editCron(PageData pd) {
		PageData job = pd;
		String cronExpression = "";
		// 如果按日发送
		if (job.get("RULE").toString().equals("1")) {
			String[] dateStr = job.get("DAYTIME").toString().split(":");
			String hour = dateStr[0];
			String minute = dateStr[1];
			String second = dateStr[2];
			cronExpression = second + " " + minute + " " + hour + " ? * *";
		}
		// 如果按周发送
		else if (job.get("RULE").toString().equals("2")) {
			String week = job.get("DAY_FOR_WEEK").toString();
			String[] dateStr = job.get("WEEKTIME").toString().split(":");
			String hour = dateStr[0];
			String minute = dateStr[1];
			String second = dateStr[2];
			cronExpression = second + " " + minute + " " + hour + " ? * " + week;
		}
		// 如果按月发送
		else if (job.get("RULE").toString().equals("3")) {
			String month = job.get("DAY_FOR_MONTH").toString();
			String[] dateStr = job.get("MONTHTIME").toString().split(":");
			String hour = dateStr[0];
			String minute = dateStr[1];
			String second = dateStr[2];
			cronExpression = second + " " + minute + " " + hour + " " + month + " * ?";
		}
		return cronExpression;
	}
	
	/**
	 * 添加任务
	 * 
	 * @param scheduleJob
	 * @throws SchedulerException
	 * @throws ParseException
	 */
	public void addJob(ScheduleJob job) throws SchedulerException, ParseException {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		TriggerKey triggerKey = TriggerKey.triggerKey(job.getJobName());

		CronTrigger trigger = (CronTrigger) scheduler.getTrigger(triggerKey);

		// 不存在，创建一个
		if (null == trigger) {
			Class clazz = ChartQuartzFactory.class;
			if(job.getJobName().equals("chart"))
			{
				clazz = ChartQuartzFactory.class;
			}else if(job.getJobName().equals("ranking"))
			{
				clazz = RankingQuartzFactory.class;
			}else if(job.getJobName().equals("daily"))
			{
				clazz = DailyTaskQuartzFactory.class;
			}
			else if(job.getJobName().equals("cProject"))
			{
				clazz = CProjectQuartzFactory.class;
			}
			/*日常工作提交情况*/
			else if(job.getJobName().equals("report"))
			{
				clazz = ReportQuartzFactory.class;
			}
			/*临时协同任务超期情况*/
			else if(job.getJobName().equals("timeout"))
			{
				clazz = TimeoutQuartzFactory.class;
			}
			/*周积分排名情况*/
			else if(job.getJobName().equals("weeklysummary"))
				{
					clazz = WeeklysummaryQuartzFactory.class;
			}
			else if(job.getJobName().equals("business"))
			{
				clazz = BusinessQuartzFactory.class;
			}
			else if(job.getJobName().equals("flow"))
			{
				clazz = FlowQuartzFactory.class;
			}
			else if(job.getJobName().equals("temp"))
			{
				clazz = TempQuartzFactory.class;
			}
			//提醒昨天日报是否已提交
			else if(job.getJobName().equals("dailyReport"))
			{
				clazz = DailyReportQuartzFactory.class;
			}
			JobDetail jobDetail = JobBuilder.newJob(clazz).withIdentity(job.getJobName()).build();

			jobDetail.getJobDataMap().put("scheduleJob", job);
			
			CronScheduleBuilder scheduleBuilder = CronScheduleBuilder.cronSchedule(job.getCronExpression()).withMisfireHandlingInstructionDoNothing();

			trigger = TriggerBuilder.newTrigger().withIdentity(job.getJobName()).withSchedule(scheduleBuilder).startAt(formatter.parse(job.getStartDate())).endAt(formatter.parse(job.getEndDate())).build();

			scheduler.scheduleJob(jobDetail, trigger);
		} else {
			// Trigger已存在，那么更新相应的定时设置
			CronScheduleBuilder scheduleBuilder = CronScheduleBuilder.cronSchedule(job.getCronExpression()).withMisfireHandlingInstructionDoNothing();

			// 按新的cronExpression表达式重新构建trigger
			trigger = trigger.getTriggerBuilder().withIdentity(triggerKey).withSchedule(scheduleBuilder).startAt(formatter.parse(job.getStartDate())).endAt(formatter.parse(job.getEndDate())).build();

			// 按新的trigger重新设置job执行
			scheduler.rescheduleJob(triggerKey, trigger);
		}
	}
	
	
    /**
     * 根据报表名称获取报表推送配置信息
     * @param pageData
     * @return
     * @throws Exception 
     */
	@SuppressWarnings("unchecked")
	public PageData findConfigDetail(PageData pd) throws Exception {
		return (PageData) dao.findForObject("configMapper.findConfigDetail", pd);
	}
	
    /**
     * 根据报表ID获取报表推送配置信息
     * @param pageData
     * @return
     * @throws Exception 
     */
	@SuppressWarnings("unchecked")
	public PageData findConfigDetailById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("configMapper.findConfigDetailById", pd);
	}
	
    /**
     * 修改报表推送配置信息
     * @param pageData
     * @return
     * @throws Exception 
     */
	public void editPlan(PageData pd) throws Exception {
		dao.update("configMapper.editPlan", pd);
		
	}
	
    /**
     * 新增报表推送配置信息
     * @param pageData
     * @return
     * @throws Exception 
     */
	public void addPlan(PageData pd) throws Exception {
		dao.save("configMapper.addPlan", pd);	
		
	}
	
    /**
     * 批量新增报表推送配置信息中的推送人与配送数据的关系
     * @param pageData
     * @return
     * @throws Exception 
     */
	public void batchSavePlan(List<PageData> list) throws Exception {
		dao.save("configMapper.batchSavePlan", list);		
	}

	
    /**
     * 根据推送计划ID获取推送人
     * @param pageData
     * @return
     * @throws Exception 
     */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpByPlanId(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("configMapper.findEmpByPlanId", pd);
	}

	
    /**
     * 根据推送计划ID删除推送人
     * @param pageData
     * @return
     * @throws Exception 
     */
	public void deleteConfigPerson(PageData pd) throws Exception {
		dao.delete("configMapper.deleteConfigPerson", pd);			
	}
	
	
    /**
     * 获取所有报表的推送配置信息
     * @param pageData
     * @return
     * @throws Exception 
     */
	@SuppressWarnings("unchecked")
	public List<PageData> findAllConfig(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("configMapper.findAllConfig", pd);
	}

    /**
     * 根据ID删除推送计划
     * @param pageData
     * @return
     * @throws Exception 
     */
	public void deletePlanConfig(PageData pd) throws Exception {
		dao.delete("configMapper.deletePlanConfig", pd);		
	}

	
	/**
	 * 暂停一个job
	 * 
	 * @param scheduleJob
	 * @throws SchedulerException
	 */
	public void pauseJob(ScheduleJob scheduleJob) throws SchedulerException {
		JobKey jobKey = JobKey.jobKey(scheduleJob.getJobName());
		scheduler.pauseJob(jobKey);
	}

	/**
	 * 恢复一个job
	 * 
	 * @param scheduleJob
	 * @throws SchedulerException
	 */
	public void resumeJob(ScheduleJob scheduleJob) throws SchedulerException {
		JobKey jobKey = JobKey.jobKey(scheduleJob.getJobName());
		scheduler.resumeJob(jobKey);
	}

	/**
	 * 删除一个job
	 * 
	 * @param scheduleJob
	 * @throws SchedulerException
	 */
	public void deleteJob(ScheduleJob scheduleJob) throws SchedulerException {
		JobKey jobKey = JobKey.jobKey(scheduleJob.getJobName());
		scheduler.deleteJob(jobKey);

	}

	/**
	 * 立即执行job
	 * 
	 * @param scheduleJob
	 * @throws SchedulerException
	 */
	public void runAJobNow(ScheduleJob scheduleJob) throws SchedulerException {
		JobKey jobKey = JobKey.jobKey(scheduleJob.getJobName());
		scheduler.triggerJob(jobKey);
	}
	
	
	
	
	/**  
    * 获取所有计划中的任务列表  
    *   
    * @return  
    * @throws SchedulerException  
    */  
   public List<ScheduleJob> getAllJob() throws SchedulerException {    
       GroupMatcher<JobKey> matcher = GroupMatcher.anyJobGroup();  
       Set<JobKey> jobKeys = scheduler.getJobKeys(matcher);  
       List<ScheduleJob> jobList = new ArrayList<ScheduleJob>();  
       for (JobKey jobKey : jobKeys) {  
           List<? extends Trigger> triggers = scheduler.getTriggersOfJob(jobKey);  
           for (Trigger trigger : triggers) {  
               ScheduleJob job = new ScheduleJob();  
               job.setJobName(jobKey.getName());  
               Trigger.TriggerState triggerState = scheduler.getTriggerState(trigger.getKey());  
               job.setJobStatus(triggerState.name());  
               if (trigger instanceof CronTrigger) {  
                   CronTrigger cronTrigger = (CronTrigger) trigger;  
                   String cronExpression = cronTrigger.getCronExpression();  
                   job.setCronExpression(cronExpression);  
               }  
               jobList.add(job);  
           }  
       }  
       return jobList;  
   }  
 
   /** 
    * 所有正在运行的job 
    *  
    * @return 
    * @throws SchedulerException 
    */  
   public List<ScheduleJob> getRunningJob() throws SchedulerException {    
       List<JobExecutionContext> executingJobs = scheduler.getCurrentlyExecutingJobs();  
       List<ScheduleJob> jobList = new ArrayList<ScheduleJob>(executingJobs.size());  
       for (JobExecutionContext executingJob : executingJobs) {  
           ScheduleJob job = new ScheduleJob();  
           JobDetail jobDetail = executingJob.getJobDetail();  
           JobKey jobKey = jobDetail.getKey();  
           Trigger trigger = executingJob.getTrigger();  
           job.setJobName(jobKey.getName());  
           Trigger.TriggerState triggerState = scheduler.getTriggerState(trigger.getKey());  
           job.setJobStatus(triggerState.name());  
           if (trigger instanceof CronTrigger) {  
               CronTrigger cronTrigger = (CronTrigger) trigger;  
               String cronExpression = cronTrigger.getCronExpression();  
               job.setCronExpression(cronExpression);  
           }  
           jobList.add(job);  
       }  
       return jobList;  
   } 
}
