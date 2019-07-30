package com.mfw.filter;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.OncePerRequestFilter;

/**
 * RequestFilter.java
 * @author 作者 蒋世平
 * @date 创建时间：2018-1-19下午3:00:22
 */
public class RequestFilter extends OncePerRequestFilter {

	@Override
	protected void doFilterInternal(HttpServletRequest request,
			HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		ParameterRequestWrapper requestWrapper = new ParameterRequestWrapper(request);  
        filterChain.doFilter(requestWrapper, response);
	}

}
