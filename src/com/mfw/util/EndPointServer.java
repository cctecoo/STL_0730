package com.mfw.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.servlet.http.HttpSession;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.google.gson.Gson;
import com.mfw.entity.system.User;
import com.mfw.service.system.menu.MenuService;
import com.mfw.service.system.user.UserService;
import com.mfw.util.mail.SimpleMailSender;

@ServerEndpoint(value="/task/msg", configurator=EndPointServerConfig.class)
public class EndPointServer{
	private static Logger logger = Logger.getLogger(EndPointServer.class.toString());
	private static UserService userService;
	private static MenuService menuService;
	private static Set<Session> sessions = new HashSet<>();
	private static Map<String, User> userMap = new HashMap<String, User>();
	private static Map<String, String> userCodeMap = new HashMap<String, String>();
	private static Properties properties = new Properties();
	private static InputStream inputStream;
	
	static{
		try {
			//inputStream = UserService.class.getClassLoader().getResourceAsStream("message_zh_CN.properties");
			inputStream = UserService.class.getClassLoader().getResourceAsStream("message_tixing.properties");
			properties.load(new InputStreamReader(inputStream, "UTF-8"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@OnOpen
	public void onOpen(Session session, EndpointConfig config){
		//获取userSession
		User user = (User) config.getUserProperties().get(HttpSession.class.getName());
		userMap.put(user.getNUMBER(), user);
		userCodeMap.put(user.getUSERNAME(), user.getNUMBER());
		//添加在线的websocket.session
		sessions.add(session);
	}
	
	@OnMessage
	public void onMessage(String message){
//		System.out.println(message);
//		for(Session session : sessions){
//			try {
//				PageData result = new PageData();
//				result.put("taskMsg", "1231231231" );
//				session.getBasicRemote().sendText(new Gson().toJson(result));
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//		}
	}
	
	@OnClose
	public void onClose(Session session){
		//关闭连接时移除
		userMap.remove(userCodeMap.get(session.getUserPrincipal().getName().toString()));
		sessions.remove(session);
	}
	
	@OnError
	public void onError(Session session, Throwable error){
		System.out.println("连接出错");
		error.printStackTrace();
	}
	
	/**
     * 系统通知，给所有人发消息
     * @param sendMsgUserName 发送消息的员工名称
	 * @param msgId	        消息ID
	 * @param msgText	消息文本
	 * @param type	        任务类型
	 * @param userArea	发送区域
     */
	public static void sendAll(String sendMsgUserName, Integer msgId, String msgText, TaskType type, String userArea) {
    	try {
    		//如果是全部发送，则不检查用户的所在区域
    		PageData result = new PageData();
			//发送消息
			String url = properties.getProperty(Const.WEBSOCKET_URL_PREFFIX + type.toString());
			String work =  properties.getProperty(Const.WEBSOCKET_MSG_PREFFIX + type.toString());
			
			//传递参数，处理消息接受端
			result.put("msgType", "notice");
			result.put("msgUrl", url.replace("{id}", msgId.toString()));
			result.put("msgText", work.replace("{name}", msgText));
			
    		if("全部".equals(userArea)){
    			//先检查用户是否在线
    			for(Session session : sessions){
    				session.getBasicRemote().sendText(new Gson().toJson(result));
    			}
    		}else{
    			//循环当前的用户
    			for(String empCode : userMap.keySet()){
    				User user = userMap.get(empCode);
    				if(userArea.equals(user.getDeptArea())){
    					//先检查用户是否在线
    					for(Session session : sessions){
    						if(session.getUserPrincipal().getName().equals(user.getUSERNAME())){
    							session.getBasicRemote().sendText(new Gson().toJson(result));
    		    				break;
    						}
    					}
    				}
    			}
    		}
		} catch (Exception e) {
			logger.error(e);
		}
    }

	/**
	 * 发送消息
	 * @param sendMsgUserName 发送消息的员工名称
	 * @param targetEmpCode	目标员工编号
	 * @param type	任务类型
	 * @throws Exception
	 */
	public static void sendMessage(String sendMsgUserName, String targetEmpCode, TaskType type){
		try {
			String msgText = sendMsgUserName + " "+ properties.getProperty(Const.WEBSOCKET_MSG_PREFFIX + type.toString());
			//根据目标员工编号查找缓存的用户信息
			User user = userMap.get(targetEmpCode);
			if(null != user){//用户在线
				//先检查用户是否在线
				for(Session session : sessions){
					if(session.getUserPrincipal().getName().equals(user.getUSERNAME())){
						PageData result = new PageData();
						if(type.equals(TaskType.REFRESH_COMMAND)){//刷新操作
							result.put("command", type);
						}else{//发送消息
							String url = properties.getProperty(Const.WEBSOCKET_URL_PREFFIX + type.toString());
							String[] urls = url.split("\\?");
							
							result = menuService.findByUrl(urls[0]);
							result.put("MENU_URL", url);
							result.put("taskMsg",msgText );
						}
						session.getBasicRemote().sendText(new Gson().toJson(result));
						return;//发送给目标员工后，返回
					}
				}
			}
			if(SimpleMailSender.isEnable()){//用户不在线,邮件可用则发送邮件
				PageData searchPd = new PageData();
				searchPd.put("NUMBER", targetEmpCode);
				PageData pd = userService.findByUN(searchPd);
				if(pd != null && pd.get("EMAIL") != null){
					SimpleMailSender.simpleSendEmail(pd.get("EMAIL").toString(), "工作", msgText);
					return;
				}
			}
			logger.info("没有发送消息的途径");
		} catch (Exception e) {
			logger.error(e);
		}
	}
	
	
	public static void sendMessageNew(String sendMsgUserName, String targetEmpCode, TaskType type, PageData pd){
		try {
			//根据目标员工编号查找缓存的用户信息
			User user = userMap.get(targetEmpCode);
			//先检查用户是否在线
			if(null != user&&pd.get("pc")!=null&&pd.get("pc").toString().equals("pc"))
			{
				for(Session session : sessions){
					if(session.getUserPrincipal().getName().equals(user.getUSERNAME())){
						PageData result = new PageData();
						if(type.equals(TaskType.REFRESH_COMMAND)){//刷新操作
							result.put("command", type);
						}else{//发送消息
							String url = properties.getProperty(Const.WEBSOCKET_URL_PREFFIX + type.toString());
							String[] urls = url.split("\\?");
								
							result = menuService.findByUrl(urls[0]);
							result.put("MENU_URL", url);
							result.put("taskMsg",pd.get("WORK_NAME").toString());
						}
						session.getBasicRemote().sendText(new Gson().toJson(result));
						return;
					}
				}
			}

			if(SimpleMailSender.isEnable()&&pd.get("mail")!=null&&pd.get("mail").toString().equals("mail")){//用户不在线,邮件可用则发送邮件
				PageData searchPd = new PageData();
				searchPd.put("NUMBER", targetEmpCode);
				PageData pdm = userService.findByUN(searchPd);
				if(pdm != null && pdm.get("EMAIL") != null){
					SimpleMailSender.simpleSendEmail(pdm.get("EMAIL").toString(), "工作", pd.get("WORK_NAME").toString());
					return;
				}
			}
			logger.info("没有发送消息的途径");
		} catch (Exception e) {
			logger.error(e);
		}
	}

	public static UserService getUserService() {
		return userService;
	}

	public static void setUserService(UserService userService) {
		EndPointServer.userService = userService;
	}

	public static MenuService getMenuService() {
		return menuService;
	}

	public static void setMenuService(MenuService menuService) {
		EndPointServer.menuService = menuService;
	}
	
}
