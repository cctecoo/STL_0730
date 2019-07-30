package com.mfw.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.mfw.entity.system.User;

/**
 * 用户工具类
 * @author Tang
 * @date 2015-11-26
 *
 */
public class UserUtils {
	
	/**
	 * 获取用户信息
	 * @param request
	 * @return
	 */
	public  static User getUser(HttpServletRequest request){
		HttpSession session = request.getSession();
		 User user=(User) session.getAttribute("USERROL");
		return user;
	}
}
