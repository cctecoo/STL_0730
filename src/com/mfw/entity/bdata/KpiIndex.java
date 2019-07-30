package com.mfw.entity.bdata;

/**
 * emp_kpi_index表
 * @author  作者 于亚洲
 * @date 创建时间：2015年12月28日 下午16:18:50
 */
public class KpiIndex {
	
	private int ID;
	private int YEAR;	//年度
	private int EMP_ID;	//员工ID
	private int KPI_MODEL_ID;	//KPI模板ID
	private String KPI_CODE;	//KPI编码
	private String KPI_NAME;	//KPI名称
	private String KPI_TYPE;	//KPI类型
	private String KPI_UNIT;	//单位
	private Long JAN;			//一月
	private Long FER;			//二月
	private Long MAR;			//三月
	private Long APR;			//四月
	private Long MAY;			//五月
	private Long JUN;			//六月
	private Long JUL;			//七月
	private Long AUG;			//八月
	private Long SEP;			//九月
	private Long OCT;			//十月
	private Long NOV;			//十一月
	private Long DECE;			//十二月
	private String SCORE;		//分值
	private String STATUS;		//状态
	private String ENABLE;		//可用标识
	private String CREATE_TIME;	//创建时间
	private String CREATE_USER;	//创建人
	private String LAST_UPDATE_TIME;	//最后更新时间
	private String LAST_UPDATE_USER;	//最后更新人
	private String PREPARATION1;
	private String PREPARATION2;	
	private String PREPARATION3;	
	private String PREPARATION4;	
	private String PREPARATION5;	
	private String PREPARATION6;
	
	public int getID() {
		return ID;
	}
	public void setID(int iD) {
		ID = iD;
	}
	public int getYEAR() {
		return YEAR;
	}
	public void setYEAR(int yEAR) {
		YEAR = yEAR;
	}
	public int getEMP_ID() {
		return EMP_ID;
	}
	public void setEMP_ID(int eMP_ID) {
		EMP_ID = eMP_ID;
	}
	public int getKPI_MODEL_ID() {
		return KPI_MODEL_ID;
	}
	public void setKPI_MODEL_ID(int kPI_MODEL_ID) {
		KPI_MODEL_ID = kPI_MODEL_ID;
	}
	public String getKPI_CODE() {
		return KPI_CODE;
	}
	public void setKPI_CODE(String kPI_CODE) {
		KPI_CODE = kPI_CODE;
	}
	public String getKPI_NAME() {
		return KPI_NAME;
	}
	public void setKPI_NAME(String kPI_NAME) {
		KPI_NAME = kPI_NAME;
	}
	public String getKPI_TYPE() {
		return KPI_TYPE;
	}
	public void setKPI_TYPE(String kPI_TYPE) {
		KPI_TYPE = kPI_TYPE;
	}
	public String getKPI_UNIT() {
		return KPI_UNIT;
	}
	public void setKPI_UNIT(String kPI_UNIT) {
		KPI_UNIT = kPI_UNIT;
	}
	public Long getJAN() {
		return JAN;
	}
	public void setJAN(Long jAN) {
		JAN = jAN;
	}
	public Long getFER() {
		return FER;
	}
	public void setFER(Long fER) {
		FER = fER;
	}
	public Long getMAR() {
		return MAR;
	}
	public void setMAR(Long mAR) {
		MAR = mAR;
	}
	public Long getAPR() {
		return APR;
	}
	public void setAPR(Long aPR) {
		APR = aPR;
	}
	public Long getMAY() {
		return MAY;
	}
	public void setMAY(Long mAY) {
		MAY = mAY;
	}
	public Long getJUN() {
		return JUN;
	}
	public void setJUN(Long jUN) {
		JUN = jUN;
	}
	public Long getJUL() {
		return JUL;
	}
	public void setJUL(Long jUL) {
		JUL = jUL;
	}
	public Long getAUG() {
		return AUG;
	}
	public void setAUG(Long aUG) {
		AUG = aUG;
	}
	public Long getSEP() {
		return SEP;
	}
	public void setSEP(Long sEP) {
		SEP = sEP;
	}
	public Long getOCT() {
		return OCT;
	}
	public void setOCT(Long oCT) {
		OCT = oCT;
	}
	public Long getNOV() {
		return NOV;
	}
	public void setNOV(Long nOV) {
		NOV = nOV;
	}
	public Long getDECE() {
		return DECE;
	}
	public void setDECE(Long dECE) {
		DECE = dECE;
	}
	public String getSCORE() {
		return SCORE;
	}
	public void setSCORE(String sCORE) {
		SCORE = sCORE;
	}
	public String getSTATUS() {
		return STATUS;
	}
	public void setSTATUS(String sTATUS) {
		STATUS = sTATUS;
	}
	public String getENABLE() {
		return ENABLE;
	}
	public void setENABLE(String eNABLE) {
		ENABLE = eNABLE;
	}
	public String getCREATE_TIME() {
		return CREATE_TIME;
	}
	public void setCREATE_TIME(String cREATE_TIME) {
		CREATE_TIME = cREATE_TIME;
	}
	public String getCREATE_USER() {
		return CREATE_USER;
	}
	public void setCREATE_USER(String cREATE_USER) {
		CREATE_USER = cREATE_USER;
	}
	public String getLAST_UPDATE_TIME() {
		return LAST_UPDATE_TIME;
	}
	public void setLAST_UPDATE_TIME(String lAST_UPDATE_TIME) {
		LAST_UPDATE_TIME = lAST_UPDATE_TIME;
	}
	public String getLAST_UPDATE_USER() {
		return LAST_UPDATE_USER;
	}
	public void setLAST_UPDATE_USER(String lAST_UPDATE_USER) {
		LAST_UPDATE_USER = lAST_UPDATE_USER;
	}
	public String getPREPARATION1() {
		return PREPARATION1;
	}
	public void setPREPARATION1(String pREPARATION1) {
		PREPARATION1 = pREPARATION1;
	}
	public String getPREPARATION2() {
		return PREPARATION2;
	}
	public void setPREPARATION2(String pREPARATION2) {
		PREPARATION2 = pREPARATION2;
	}
	public String getPREPARATION3() {
		return PREPARATION3;
	}
	public void setPREPARATION3(String pREPARATION3) {
		PREPARATION3 = pREPARATION3;
	}
	public String getPREPARATION4() {
		return PREPARATION4;
	}
	public void setPREPARATION4(String pREPARATION4) {
		PREPARATION4 = pREPARATION4;
	}
	public String getPREPARATION5() {
		return PREPARATION5;
	}
	public void setPREPARATION5(String pREPARATION5) {
		PREPARATION5 = pREPARATION5;
	}
	public String getPREPARATION6() {
		return PREPARATION6;
	}
	public void setPREPARATION6(String pREPARATION6) {
		PREPARATION6 = pREPARATION6;
	}
	
}
