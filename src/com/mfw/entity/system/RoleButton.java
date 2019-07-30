package com.mfw.entity.system;

/**
 * 角色按钮类
 * @author  作者 蒋世平
 * @date 创建时间：2017年5月24日 下午17:37:09
 */
public class RoleButton {
    private Integer gxId;

    private String roleId;

    private Integer menuId;

    private String buttonsId;

    private String anqxCode;

    public Integer getGxId() {
        return gxId;
    }

    public void setGxId(Integer gxId) {
        this.gxId = gxId;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId == null ? null : roleId.trim();
    }

    public Integer getMenuId() {
        return menuId;
    }

    public void setMenuId(Integer menuId) {
        this.menuId = menuId;
    }

    public String getButtonsId() {
        return buttonsId;
    }

    public void setButtonsId(String buttonsId) {
        this.buttonsId = buttonsId == null ? null : buttonsId.trim();
    }

    public String getAnqxCode() {
        return anqxCode;
    }

    public void setAnqxCode(String anqxCode) {
        this.anqxCode = anqxCode == null ? null : anqxCode.trim();
    }
}