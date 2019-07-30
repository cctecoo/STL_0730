package com.mfw.entity.bdata;

/**
 * 职位级别类
 * @author  作者 于亚洲
 * @date 创建时间：2015年12月24日 下午14:12:42
 */
public class PositionLevel {
    private Integer id;

    private String gradeCode;

    private String gradeName;

    private Long laborCost;

    private String gradeDesc;

    private Integer attachDeptId;

    private String attachDeptName;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getGradeCode() {
        return gradeCode;
    }

    public void setGradeCode(String gradeCode) {
        this.gradeCode = gradeCode == null ? null : gradeCode.trim();
    }

    public String getGradeName() {
        return gradeName;
    }

    public void setGradeName(String gradeName) {
        this.gradeName = gradeName == null ? null : gradeName.trim();
    }

    public Long getLaborCost() {
        return laborCost;
    }

    public void setLaborCost(Long laborCost) {
        this.laborCost = laborCost;
    }

    public String getGradeDesc() {
        return gradeDesc;
    }

    public void setGradeDesc(String gradeDesc) {
        this.gradeDesc = gradeDesc == null ? null : gradeDesc.trim();
    }

    public Integer getAttachDeptId() {
        return attachDeptId;
    }

    public void setAttachDeptId(Integer attachDeptId) {
        this.attachDeptId = attachDeptId;
    }

    public String getAttachDeptName() {
        return attachDeptName;
    }

    public void setAttachDeptName(String attachDeptName) {
        this.attachDeptName = attachDeptName == null ? null : attachDeptName.trim();
    }
}