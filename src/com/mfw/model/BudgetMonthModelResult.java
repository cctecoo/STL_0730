package com.mfw.model;

import java.io.Serializable;

/**
 * 月度预测条件
 * @author  作者 苏立君
 * @date 创建时间：2015年11月26日 下午13:41:24
 */
public class BudgetMonthModelResult implements Serializable{

	private static final long serialVersionUID = -8344265545401780854L;
	
	private Integer id;
	
	private Integer deptId;//部门ID
	
	private String deptName;//部门名称
	
	private String yearTime;//年度
	
	private Integer month;//月份
	
	private Integer forduceDeptId;//编制部门ID
	
	private Integer budgetDeptModelId;//预算部门权限

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getDeptId() {
		return deptId;
	}

	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getYearTime() {
		return yearTime;
	}

	public void setYearTime(String yearTime) {
		this.yearTime = yearTime;
	}

	public Integer getMonth() {
		return month;
	}

	public void setMonth(Integer month) {
		this.month = month;
	}

	public Integer getForduceDeptId() {
		return forduceDeptId;
	}

	public void setForduceDeptId(Integer forduceDeptId) {
		this.forduceDeptId = forduceDeptId;
	}

	public Integer getBudgetDeptModelId() {
		return budgetDeptModelId;
	}

	public void setBudgetDeptModelId(Integer budgetDeptModelId) {
		this.budgetDeptModelId = budgetDeptModelId;
	}

	
}
