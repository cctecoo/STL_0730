package com.mfw.resolver;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

/**
 * 异常解析器
 * @author  作者 苏立君
 * @date 创建时间：2015年12月2日 下午17:08:04
 */
public class MyExceptionResolver implements HandlerExceptionResolver {

	public ModelAndView resolveException(HttpServletRequest request, 
			HttpServletResponse response, Object handler, Exception ex) {
		
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ex.printStackTrace(new PrintStream(baos));
		String log_info = baos.toString();
		
		Logger.getLogger(getClass()).error(log_info);
		
		ModelAndView mv = new ModelAndView("error");
		
		if(ex.getMessage().startsWith("Maximum upload size")){
			mv.addObject("msg", "上传文件超过最大限制100M");
			mv.setViewName("save_result");
		}else{
			mv.addObject("exception", ex.toString().replaceAll("\n", "<br/>"));
		}
		
		return mv;
	}

}
