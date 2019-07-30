package com.mfw.controller.base;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;

import com.mfw.entity.system.User;
import com.mfw.service.system.UserLogService;
import com.mfw.util.Const;
import com.mfw.util.Logger;
import com.mfw.util.PageData;

/**
 * 基础service
 * @author  作者 蒋世平
 * @date 创建时间：2016年4月15日 下午16：53:12
 */
public class BaseService {
	
	protected Logger logger = Logger.getLogger(this.getClass());
	

	@Resource(name="userLogService")
	protected UserLogService userlogService;

	/**
	 * 获取用户信息
	 * @return
	 */
	public User getUser(){
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		User user = (User)session.getAttribute(Const.SESSION_USER);
		return user;
	}
	
	/**
	 * 获取用户角色信息
	 * @return
	 */
	public User getUserRole(){
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		User user = (User)session.getAttribute(Const.SESSION_USERROL);
		return user;
	}
	
	/**
	 * 新增数据时设置默认信息
	 * @param pd
	 * @return
	 */
	public PageData savePage(PageData pd){
		User user=getUser();
		pd.put("isdel","0");//0 有效，1或者null 无效
		pd.put("createUser", user.getUSERNAME());
		pd.put("createTime", new Date());
		return pd;
	}
	
	/**
	 * 更新数据时组装更新信息
	 * @param pd
	 * @return
	 */
	public PageData updatePage(PageData pd){
		User user=getUser();
		pd.put("updateUser", user.getUSERNAME());
		pd.put("updateTime", new Date());
		return pd;
	}
	
	/**
	 * 判断是否为财务预算表单
	 * @param empDeptArea:FIN PUR COT
	 * @return
	 */
	public boolean getIsFeeForm(Object empDeptArea){
		boolean isMatchForm = null != empDeptArea && "FIN".equals(empDeptArea.toString());
		return isMatchForm;
	}
	
	/**
	 * 判断是否为发票入账表单
	 */
	public boolean getIsBillForm(Object empDeptArea){
		boolean isMatchForm = null != empDeptArea && "BIL".equals(empDeptArea.toString());
		return isMatchForm;
	}
	
	/**
	 * 判断是否为采购表单
	 * @return
	 */
	public boolean getIsPurchasingForm(Object empDeptArea){
		boolean isMatchForm = null != empDeptArea && "PUR".equals(empDeptArea.toString());
		return isMatchForm;
	}
	
	/**
	 * 判断是否为采购合同表单
	 * @return
	 */
	public boolean getIsPurchasingContractForm(Object empDeptArea){
		boolean isMatchForm = null != empDeptArea && "COT".equals(empDeptArea.toString());
		return isMatchForm;
	}
	
	/**
	 * 判断是否为采购付款表单
	 */
	public boolean getIsPurchasePaymentForm(Object empDeptArea){
		boolean isMatchForm = null != empDeptArea && "PAY".equals(empDeptArea.toString());
		return isMatchForm;
	}
	
	/**
	 * 判断是否为合并付款表单
	 */
	public boolean getIsPurchasePaymentMergeForm(Object empDeptAreaObj){
		boolean isMatchForm = null != empDeptAreaObj && "MRG".equals(empDeptAreaObj.toString());
		return isMatchForm;
	}

	/**
	 * 判断是否为预算调整申请单
	 */
	public boolean getIsBudgetAdjustForm(Object empDeptArea){
		boolean isMatchForm = null != empDeptArea && "BUD".equals(empDeptArea.toString());
		return isMatchForm;
	}

	/**
	 * 判断是否为采购合同额外付款单
	 */
	public boolean getIsContractExtraPaymentForm(Object empDeptArea){
		boolean isMatchForm = null != empDeptArea && "EXT".equals(empDeptArea.toString());
		return isMatchForm;
	}

	/**
	 * 获取计划进度
	 * 
	 * @param startDate
	 *            任务开始时间
	 * @param endDate
	 *            任务结束时间
	 * @param taskTime
	 *            当前时间
	 */
	public double getPercent(String startDate, String endDate, String taskTime)
			throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date startday = sdf.parse(startDate);
		Date endday = sdf.parse(endDate);
		// 获取当前时间
		Date taskday = sdf.parse(taskTime);
		// 当前时间小于开始时间，计划进度为0；当前时间大于结束时间，计划进度返回1
		double planPercent = 0;
		if (taskday.before(startday)) {
			planPercent = 0;
		} else if (!taskday.before(endday)) {
			planPercent = 100;
		} else {// 计算计划进度
				// 计算任务天数
			double days = getDays(startday, endday);
			// 计算已经过去的天数
			double pastDays = getDays(startday, taskday);
			planPercent = new Double(pastDays / days).doubleValue() * 100;
		}

		return planPercent;
	}
	
	/**
	 * 计算间隔天数（开始和结束日期为同一天时返回1天）
	 */
	public double getDays(Date startday, Date endday) {
		Calendar cal = Calendar.getInstance();
		// 获取开始时间
		cal.setTime(startday);
		long starTtime = cal.getTimeInMillis();
		// 获取结束时间
		cal.setTime(endday);
		long endTime = cal.getTimeInMillis();
		double days = (endTime - starTtime) / (1000 * 3600 * 24) + 1;

		return days;
	}
}
