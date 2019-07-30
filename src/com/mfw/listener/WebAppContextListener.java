package com.mfw.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.springframework.stereotype.Component;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.mfw.util.Const;

/**
 * 网页环境监听器
 * @author  作者 于亚洲
 * @date 创建时间：2015年1月1日 下午16:31:15
 */
@Component
public class WebAppContextListener implements ServletContextListener {
	public void contextDestroyed(ServletContextEvent event) {		
		// TODO Auto-generated method stub
	}

	public void contextInitialized(ServletContextEvent event) {
		// TODO Auto-generated method stub
		Const.WEB_APP_CONTEXT = WebApplicationContextUtils.getWebApplicationContext(event.getServletContext());
		//System.out.println("========获取Spring WebApplicationContext");
	}
	
}
