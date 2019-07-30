package com.mfw.entity.system;

/**
 * 微信通用接口凭证
 * @author  作者 白惠文
 * @date 创建时间：2017年5月24日 下午17:15:03
 */
public class AccessToken {
    // 获取到的凭证
    private String token;
    // 凭证有效时间，单位：秒
    private int expiresIn;

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public int getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(int expiresIn) {
        this.expiresIn = expiresIn;
    }
}
