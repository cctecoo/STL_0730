package com.mfw.entity.system;

/**
 * 凭证实体类
 * @author  作者 蒋世平
 * @date 创建时间：2017年5月24日 下午17:37:09
 */
public class Ticket {
    // 获取到的凭证
    private String ticket;
    // 凭证有效时间，单位：秒
    private int expiresIn;
    
    private String errcode;
    
    private String errmsg;
       
    public int getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(int expiresIn) {
        this.expiresIn = expiresIn;
    }

	public String getTicket() {
		return ticket;
	}

	public void setTicket(String ticket) {
		this.ticket = ticket;
	}

	public String getErrcode() {
		return errcode;
	}

	public void setErrcode(String errcode) {
		this.errcode = errcode;
	}

	public String getErrmsg() {
		return errmsg;
	}

	public void setErrmsg(String errmsg) {
		this.errmsg = errmsg;
	}
}
