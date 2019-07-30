package com.mfw.model;

import java.io.Serializable;

/**
 * 状态数据模型
 * @author  作者 苏立君
 * @date 创建时间：2015年12月2日 下午16:28:04
 */
public class StatusCountModel implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private Integer count;
	
	private String status;

	public Integer getCount() {
		return count;
	}

	public void setCount(Integer count) {
		this.count = count;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
}
