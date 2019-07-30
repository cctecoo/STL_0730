package com.mfw.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.ConnectException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mfw.entity.ScheduleJob;
import com.mfw.entity.system.AccessToken;
import com.mfw.entity.system.OAuthInfo;
import com.mfw.entity.system.TemplateData;
import com.mfw.entity.system.WxTemplate;

import net.sf.json.JSONException;
import net.sf.json.JSONObject;


/**
 * author Yang DongWei
 * date 2015/10/26
 * email yangdw@haiersoft.com
 */
public class WeixinUtil {
    private static Logger log = LoggerFactory.getLogger(WeixinUtil.class);
    
    public final static String access_token_url1 = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=APPID&secret=APPSECRET";
    public final static String access_token_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code";
    public final static String ticket_url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=ACCESS_TOKEN&type=jsapi";
    	
    public static Object[] getOpenId(String code) {
    	Properties prop = Tools.loadPropertiesFile("config.properties");
    	OAuthInfo openId = null;
    	AccessToken accessToken = null;
        String requestUrl = access_token_url.replace("APPID", prop.getProperty("APPID").trim())
        		.replace("SECRET",  prop.getProperty("APPSECRET").trim()).replace("CODE", code.trim());
        //System.out.println("requestUrl:"+requestUrl);
        JSONObject jsonObject = httpRequest(requestUrl, "GET", null);
        // 如果请求成功
        if (null != jsonObject) {
            try {
                openId = new OAuthInfo();
                openId.setOpenId(jsonObject.getString("openid"));
                
                accessToken= new AccessToken();
                accessToken.setToken(jsonObject.getString("access_token"));
                accessToken.setExpiresIn(jsonObject.getInt("expires_in"));
            } catch (JSONException e) {
            	// 获取token失败   
            	openId = null;
            	log.error(e.toString());
            }
        }
        Object[] arr = {openId, accessToken};
        return arr;
    }

    /**
     * 发起https请求并获取结果
     *
     * @param requestUrl 请求地址
     * @param requestMethod 请求方式（GET、POST）
     * @param outputStr 提交的数据
     * @return JSONObject(通过JSONObject.get(key)的方式获取json对象的属性值)
     */
    public static JSONObject httpRequest(String requestUrl, String requestMethod, String outputStr) {
        JSONObject jsonObject = null;
        StringBuffer buffer = new StringBuffer();
        try {
            // 创建SSLContext对象，并使用我们指定的信任管理器初始化
            TrustManager[] tm = { new MyX509TrustManager() };
            SSLContext sslContext = SSLContext.getInstance("SSL", "SunJSSE");
            sslContext.init(null, tm, new java.security.SecureRandom());
            // 从上述SSLContext对象中得到SSLSocketFactory对象
            SSLSocketFactory ssf = sslContext.getSocketFactory();

            URL url = new URL(requestUrl);
            HttpsURLConnection httpUrlConn = (HttpsURLConnection) url.openConnection();
            httpUrlConn.setSSLSocketFactory(ssf);

            httpUrlConn.setDoOutput(true);
            httpUrlConn.setDoInput(true);
            httpUrlConn.setUseCaches(false);
            // 设置请求方式（GET/POST）
            httpUrlConn.setRequestMethod(requestMethod);

            if ("GET".equals(requestMethod))
                httpUrlConn.connect();

            // 当有数据需要提交时
            if (null != outputStr) {
                OutputStream outputStream = httpUrlConn.getOutputStream();
                // 注意编码格式，防止中文乱码
                outputStream.write(outputStr.getBytes("UTF-8"));
                outputStream.close();
            }

            // 将返回的输入流转换成字符串
            InputStream inputStream = httpUrlConn.getInputStream();
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream, "utf-8");
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

            String str = null;
            while ((str = bufferedReader.readLine()) != null) {
                buffer.append(str);
            }
            bufferedReader.close();
            inputStreamReader.close();
            // 释放资源
            inputStream.close();
            inputStream = null;
            httpUrlConn.disconnect();
            jsonObject = JSONObject.fromObject(buffer.toString());
        } catch (ConnectException ce) {
            log.error("Weixin server connection timed out.");
        } catch (Exception e) {
            log.error("https request error:{}", e);
        }
        return jsonObject;
    }

    /**
     * 获取access_token
     *
     * @param appid 凭证
     * @param appsecret 密钥
     * @return
     */
    public static AccessToken getAccessToken(String appid, String appsecret) {
    	AccessToken accessToken = null;
    	String requestUrl = access_token_url1.replace("APPID", appid.trim()).replace("APPSECRET", appsecret.trim());
        JSONObject jsonObject = httpRequest(requestUrl, "GET", null);
        // 如果请求成功
        if (null != jsonObject) {
            try {
                accessToken = new AccessToken();
                accessToken.setToken(jsonObject.getString("access_token"));
                accessToken.setExpiresIn(jsonObject.getInt("expires_in"));
            } catch (JSONException e) {
                accessToken = null;
                // 获取token失败
                log.error("获取token失败 errcode:{} errmsg:{}", jsonObject.getInt("errcode"), jsonObject.getString("errmsg"));
            }
        }
        return accessToken;
    }
    
	/**
	 * 
	 * 发送模板消息(任务到期/审核) 
	 * @param appId			公众账号的唯一标识
	 * @param appSecret		公众账号的密钥
	 * @param openId		用户标识
	 * @param myurl			跳转地址
	 * @param token
	 * @param work1
	 * @param work2			
	 * @param head			通知头
	 * @param tips			问题提示
	 * @param TEMPLATE_ID	模板id
	 */
	public static void send_template_message(String appId, String appSecret, String openId, String myurl, 
			AccessToken token, String work1, String work2, String head, String tips, String TEMPLATE_ID) {		
		if (token != null) {
			Properties prop = Tools.loadPropertiesFile("config.properties");
			String access_token = token.getToken();		
			String url = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=" + access_token;
			
			WxTemplate temp = new WxTemplate();
			temp.setUrl(myurl);
			temp.setTouser(openId);
			temp.setTopcolor("#000000");
			if (TEMPLATE_ID.equals("")) {
				temp.setTemplate_id(prop.getProperty("TEMPLATE_ID"));
			} else {
				temp.setTemplate_id(TEMPLATE_ID);
			}
			Map<String, TemplateData> m = new HashMap<String, TemplateData>();
			TemplateData first = new TemplateData();
			first.setColor("#3366FF");
			first.setValue(head);
			m.put("first", first);
			TemplateData keyword1 = new TemplateData();
			keyword1.setColor("#000000");
			keyword1.setValue(work1);
			m.put("keyword1", keyword1);
			TemplateData keyword2 = new TemplateData();
			keyword2.setColor("#000000");
			keyword2.setValue(work2);
			m.put("keyword2", keyword2);
			TemplateData remark = new TemplateData();
			remark.setColor("#000000");
			remark.setValue(tips);
			m.put("remark", remark);
			temp.setData(m);
			String jsonString = JSONObject.fromObject(temp).toString();
			JSONObject jsonObject = WeixinUtil.httpRequest(url, "POST", jsonString);
//			System.out.println(jsonObject);
			int result = 0;
			if (null != jsonObject) {
				if (0 != jsonObject.getInt("errcode")) {
					result = jsonObject.getInt("errcode");
				}
			}
			log.info("result="+result);
		}
	}
    
    
    /**
     * 发送报表模板消息(带时间)
     * appId 公众账号的唯一标识
     * appSecret 公众账号的密钥
     * openId 用户标识
     * myurl 跳转地址
     * head 通知头
     * my_work 代办工作
     * TEMPLATE_ID 模板ID
     */
	public static void send_template_message_new(String appId, String appSecret, String openId, String myurl,
			String my_work, String head, String TEMPLATE_ID,AccessToken token) {		
		if (token != null) {
			Properties prop = Tools.loadPropertiesFile("config.properties");
			String access_token = token.getToken();
			String url = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=" + access_token;
			WxTemplate temp = new WxTemplate();
			temp.setUrl(myurl);
			temp.setTouser(openId);
			temp.setTopcolor("#000000");
			if (TEMPLATE_ID.equals("")) {
				temp.setTemplate_id(prop.getProperty("TEMPLATE_ID"));
			} else {
				temp.setTemplate_id(TEMPLATE_ID);
			}
			Map<String, TemplateData> m = new HashMap<String, TemplateData>();
			TemplateData first = new TemplateData();
			first.setColor("#3366FF");
			first.setValue(head);
			m.put("first", first);
			TemplateData work = new TemplateData();
			work.setColor("#000000");
			work.setValue(my_work);
			m.put("keyword1", work);
			TemplateData time = new TemplateData();
			time.setColor("#000000");
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			time.setValue(df.format(new Date()));
			m.put("keyword2", time);
			TemplateData remark = new TemplateData();
			remark.setColor("#000000");
			remark.setValue("请点击详情进行处理");
			m.put("remark", remark);
			temp.setData(m);
			String jsonString = JSONObject.fromObject(temp).toString();
			JSONObject jsonObject = WeixinUtil.httpRequest(url, "POST", jsonString);
			log.info(jsonString);
//			System.out.println(jsonObject);
			int result = 0;
			if (null != jsonObject) {
				if (0 != jsonObject.getInt("errcode")) {
					result = jsonObject.getInt("errcode");
				}
			}
			log.info("result="+result);
		}
	}
    
    
    
    /**
     * 获取jsapi_ticket
     * @param accessToken 凭证
     * @return
     */
    public static String getTicket(AccessToken accessToken) {
    	String ticket = "";
    	
        String requestUrl = ticket_url.replace("ACCESS_TOKEN", accessToken.getToken());
        JSONObject jsonObject = httpRequest(requestUrl, "GET", null);
        // 如果请求成功
        if (null != jsonObject) {
            try {
            	ticket = jsonObject.getString("ticket");
            } catch (JSONException e) {
            	ticket = null;
                // 获取token失败
                log.error("获取ticket失败 errcode:{} errmsg:{}", jsonObject.getInt("errcode"), jsonObject.getString("errmsg"));
            }
        }
        return ticket;
    }
    
    /**
     * 生成随机字符串
     * @return
     */    
    public static String getRandomString(int length) { //length表示生成字符串的长度  
        String base = "abcdefghijklmnopqrstuvwxyz0123456789";     
        Random random = new Random();     
        StringBuffer sb = new StringBuffer();     
        for (int i = 0; i < length; i++) {     
            int number = random.nextInt(base.length());     
            sb.append(base.charAt(number));     
        }     
        return sb.toString();     
    } 
    
    
    /** 
     * 通过反射调用scheduleJob中定义的方法 
     *  
     * @param scheduleJob 
     */  
    public static void invokMethod(ScheduleJob scheduleJob) {  
        Object object = null;  
        Class clazz = null;
        
        if (StringUtils.isNotBlank(scheduleJob.getClass().getName())) {
            try {  
                clazz = Class.forName(scheduleJob.getClass().getName());  
                object = clazz.newInstance();  
            } catch (Exception e) {  
                e.printStackTrace();  
            }  
  
        }  
        if (object == null) {  
            log.error("任务名称 = [" + scheduleJob.getJobName() + "]---------------未启动成功，请检查是否配置正确！！！");  
            return;  
        }
        clazz = object.getClass();  
        Method method = null;  
        try {        	
            method = clazz.getDeclaredMethod("execute");
        } catch (NoSuchMethodException e) {  
            log.error("任务名称 = [" + scheduleJob.getJobName() + "]---------------未启动成功，方法名设置错误！！！");  
        } catch (SecurityException e) {   
            e.printStackTrace();
        }
        if (method != null) {  
            try {
            	System.out.println("\n启动成功222\n");
                method.invoke(object);
            } catch (IllegalAccessException e) {
                e.printStackTrace();  
            } catch (IllegalArgumentException e) {  
                e.printStackTrace();  
            } catch (InvocationTargetException e) {  
                e.printStackTrace();  
            }
        }  
          
    }  
    
}