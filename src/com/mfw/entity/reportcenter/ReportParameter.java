package com.mfw.entity.reportcenter;

import java.io.Serializable;

/**
 * 报表类
 * @author  作者 杨东伟
 * @date 创建时间：2016年5月14日 下午16:25:02
 */
public class ReportParameter implements Serializable {

    private static final long serialVersionUID = 2455006321879623644L;

    private String ID; //自增主键
    private String REPORT_CODE; //报表标识 主键
    private String REPORT_NAME; //报表名
    private String PARAMETER_CODE; //参数编号
    private String PARAMETER_NAME; //参数名
    private String DEFINE1;//自定义参数1 报表时间类型
    private String DEFINE2;//自定义参数2
    private String DEFINE3;//自定义参数3

    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public String getREPORT_CODE() {
        return REPORT_CODE;
    }

    public void setREPORT_CODE(String REPORT_CODE) {
        this.REPORT_CODE = REPORT_CODE;
    }

    public String getREPORT_NAME() {
        return REPORT_NAME;
    }

    public void setREPORT_NAME(String REPORT_NAME) {
        this.REPORT_NAME = REPORT_NAME;
    }

    public String getPARAMETER_CODE() {
        return PARAMETER_CODE;
    }

    public void setPARAMETER_CODE(String PARAMETER_CODE) {
        this.PARAMETER_CODE = PARAMETER_CODE;
    }

    public String getPARAMETER_NAME() {
        return PARAMETER_NAME;
    }

    public void setPARAMETER_NAME(String PARAMETER_NAME) {
        this.PARAMETER_NAME = PARAMETER_NAME;
    }

    public String getDEFINE1() {
        return DEFINE1;
    }

    public void setDEFINE1(String DEFINE1) {
        this.DEFINE1 = DEFINE1;
    }

    public String getDEFINE2() {
        return DEFINE2;
    }

    public void setDEFINE2(String DEFINE2) {
        this.DEFINE2 = DEFINE2;
    }

    public String getDEFINE3() {
        return DEFINE3;
    }

    public void setDEFINE3(String DEFINE3) {
        this.DEFINE3 = DEFINE3;
    }
}
