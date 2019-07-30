package com.mfw.entity.system;

import java.io.Serializable;

import com.mfw.entity.Page;

/**
 * 用户实体类
 * @author  作者 于亚洲
 * @date 创建时间：2014年6月28日 下午17:33:19
 */
public class User implements Serializable{
	private static final long serialVersionUID = 2724888087391664167L;
	private String USER_ID; //用户id
	private String USERNAME; //用户名
	private String PASSWORD; //密码
	private String NAME; //姓名
	private Integer deptId;//部门
	private String deptName;//部门名称
	private String RIGHTS; //权限
	private String ROLE_ID; //角色id
	private String LAST_LOGIN; //最后登录时间
	private String IP; //用户登录ip地址
	private String STATUS; //状态
	private Role role; //角色对象
	private Page page; //分页对象
	private String SKIN; //皮肤
	private String NUMBER;//员工编号,EMP_CODE（新增）
	private String OPEN_ID;//用于微信绑定服务号通知
	private Integer jobRank;//保存员工的岗位等级
	private String email;//保存员工的邮箱
	private String deptArea;//用户部门的所在地
	private String deptAreaCode;
	private String phone;//用户手机
	
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getDeptAreaCode() {
		return deptAreaCode;
	}

	public void setDeptAreaCode(String deptAreaCode) {
		this.deptAreaCode = deptAreaCode;
	}

	/**
	 * 对应员工表的EMP_CODE
	 */
	public String getNUMBER() {
		return NUMBER;
	}

	public void setNUMBER(String nUMBER) {
		NUMBER = nUMBER;
	}

	public String getSKIN() {
		return SKIN;
	}

	public void setSKIN(String sKIN) {
		SKIN = sKIN;
	}

	public String getUSER_ID() {
		return USER_ID;
	}

	public void setUSER_ID(String uSER_ID) {
		USER_ID = uSER_ID;
	}

	public String getUSERNAME() {
		return USERNAME;
	}

	public void setUSERNAME(String uSERNAME) {
		USERNAME = uSERNAME;
	}

	public String getPASSWORD() {
		return PASSWORD;
	}

	public void setPASSWORD(String pASSWORD) {
		PASSWORD = pASSWORD;
	}

	public String getNAME() {
		return NAME;
	}

	public void setNAME(String nAME) {
		NAME = nAME;
	}

	public String getRIGHTS() {
		return RIGHTS;
	}

	public void setRIGHTS(String rIGHTS) {
		RIGHTS = rIGHTS;
	}

	public String getROLE_ID() {
		return ROLE_ID;
	}

	public void setROLE_ID(String rOLE_ID) {
		ROLE_ID = rOLE_ID;
	}

	public String getLAST_LOGIN() {
		return LAST_LOGIN;
	}

	public void setLAST_LOGIN(String lAST_LOGIN) {
		LAST_LOGIN = lAST_LOGIN;
	}

	public String getIP() {
		return IP;
	}

	public void setIP(String iP) {
		IP = iP;
	}

	public String getSTATUS() {
		return STATUS;
	}

	public void setSTATUS(String sTATUS) {
		STATUS = sTATUS;
	}

	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}

	public Page getPage() {
		if (page == null)
			page = new Page();
		return page;
	}

	public void setPage(Page page) {
		this.page = page;
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

	public String getOPEN_ID() {
		return OPEN_ID;
	}

	public void setOPEN_ID(String oPEN_ID) {
		OPEN_ID = oPEN_ID;
	}

	public Integer getJobRank() {
		return jobRank;
	}

	public void setJobRank(Integer jobRank) {
		this.jobRank = jobRank;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getDeptArea() {
		return deptArea;
	}

	public void setDeptArea(String deptArea) {
		this.deptArea = deptArea;
	}
	
	
}
