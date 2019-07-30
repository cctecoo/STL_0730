package com.mfw.util;

import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;

/**
 * @Title  websocket 配置类，可以传入HttpSession中保存的信息
 * @author jiangsp
 * @date   2017-5-5
 */
public class EndPointServerConfig extends ServerEndpointConfig.Configurator{

	@Override
	public void modifyHandshake(ServerEndpointConfig config,
			HandshakeRequest request, HandshakeResponse response) {
		HttpSession httpSession = (HttpSession) request.getHttpSession();
		config.getUserProperties().put(HttpSession.class.getName(), httpSession.getAttribute(Const.SESSION_USER));
	}
}
