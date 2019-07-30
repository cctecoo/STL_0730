package com.mfw.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Tools {

	/**
	 * 随机生成六位数验证码
	 * 
	 * @return
	 */
	public static int getRandomNum() {
		Random r = new Random();
		return r.nextInt(900000) + 100000;//(Math.random()*(999999-100000)+100000)
	}

	/**
	 * 检测字符串是否不为空(null,"","null")
	 * 
	 * @param s
	 * @return 不为空则返回true，否则返回false
	 */
	public static boolean notEmpty(String s) {
		return s != null && !"".equals(s) && !"null".equals(s);
	}

	/**
	 * 检测字符串是否为空(null,"","null")
	 * 
	 * @param s
	 * @return 为空则返回true，不否则返回false
	 */
	public static boolean isEmpty(String s) {
		return s == null || "".equals(s) || "null".equals(s);
	}

	/**
	 * 字符串转换为字符串数组
	 * 
	 * @param str 字符串
	 * @param splitRegex 分隔符
	 * @return
	 */
	public static String[] str2StrArray(String str, String splitRegex) {
		if (isEmpty(str)) {
			return null;
		}
		return str.split(splitRegex);
	}

	/**
	 * 用默认的分隔符(,)将字符串转换为字符串数组
	 * 
	 * @param str 字符串
	 * @return
	 */
	public static String[] str2StrArray(String str) {
		return str2StrArray(str, ",\\s*");
	}

	/**
	 * 按照yyyy-MM-dd HH:mm:ss的格式，日期转字符串
	 * 
	 * @param date
	 * @return yyyy-MM-dd HH:mm:ss
	 */
	public static String date2Str(Date date) {
		return date2Str(date, "yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 按照yyyy-MM-dd HH:mm:ss的格式，字符串转日期
	 * 
	 * @param date
	 * @return
	 */
	public static Date str2Date(String date) {
		if (notEmpty(date)) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			try {
				return sdf.parse(date);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			return new Date();
		} else {
			return null;
		}
	}

	/**
	 * 按照参数format的格式，日期转字符串
	 * 
	 * @param date
	 * @param format
	 * @return
	 */
	public static String date2Str(Date date, String format) {
		if (date != null) {
			SimpleDateFormat sdf = new SimpleDateFormat(format);
			return sdf.format(date);
		} else {
			return "";
		}
	}

	/**
	 * 把时间根据时、分、秒转换为时间段
	 * 
	 * @param StrDate
	 */
	public static String getTimes(String StrDate) {
		String resultTimes = "";

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		java.util.Date now;

		try {
			now = new Date();
			java.util.Date date = df.parse(StrDate);
			long times = now.getTime() - date.getTime();
			long day = times / (24 * 60 * 60 * 1000);
			long hour = (times / (60 * 60 * 1000) - day * 24);
			long min = ((times / (60 * 1000)) - day * 24 * 60 - hour * 60);
			long sec = (times / 1000 - day * 24 * 60 * 60 - hour * 60 * 60 - min * 60);

			StringBuffer sb = new StringBuffer();
			//sb.append("发表于：");
			if (hour > 0) {
				sb.append(hour + "小时前");
			} else if (min > 0) {
				sb.append(min + "分钟前");
			} else {
				sb.append(sec + "秒前");
			}

			resultTimes = sb.toString();
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return resultTimes;
	}

	/**
	 * 写txt里的单行内容
	 * 
	 * @param filePath 文件路径
	 * @param content 写入的内容
	 */
	public static void writeFile(String fileP, String content) {
		//String filePath = String.valueOf(Thread.currentThread().getContextClassLoader().getResource("")) + "../../"; //项目路径
		String filePath = Tools.getRootPath();
		filePath = (filePath.trim() + fileP.trim()).substring(6).trim();
		PrintWriter pw;
		try {
			
			FileOutputStream fos = new FileOutputStream(filePath);
			//通过桥连接，把字节流转变为字符流，并指定编码格式
			OutputStreamWriter osw = new OutputStreamWriter(fos,"UTF-8");//写入文件时指定编码格			
			pw = new PrintWriter(osw);
			
//			pw = new PrintWriter(new FileWriter(filePath));
			pw.print(content);
			pw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 验证邮箱
	 * 
	 * @param email
	 * @return
	 */
	public static boolean checkEmail(String email) {
		boolean flag = false;
		try {
			String check = "^([a-z0-9A-Z]+[-|_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
			Pattern regex = Pattern.compile(check);
			Matcher matcher = regex.matcher(email);
			flag = matcher.matches();
		} catch (Exception e) {
			flag = false;
		}
		return flag;
	}

	/**
	 * 验证手机号码
	 * 
	 * @param mobiles
	 * @return
	 */
	public static boolean checkMobileNumber(String mobileNumber) {
		boolean flag = false;
		try {
			Pattern regex = Pattern.compile("^(((13[0-9])|(15([0-3]|[5-9]))|(18[0,5-9]))\\d{8})|(0\\d{2}-\\d{8})|(0\\d{3}-\\d{7})$");
			Matcher matcher = regex.matcher(mobileNumber);
			flag = matcher.matches();
		} catch (Exception e) {
			flag = false;
		}
		return flag;
	}
	
	/**
	 * 获取项目在tomcat下的磁盘路径以项目名称结尾
	 * 类似D:/tomcat7/webapps/STL-OEC/，
	 * 区分windows和linux
	 */
	public static String getRootPath() {
		  String classPath = Tools.class.getClassLoader().getResource("").getPath();
		  //windows-File.separator=\,classPath=/D:/MyWork/tomcat/tomcat7/webapps/STL-OEC/WEB-INF/classes/
		  //rootPath=D:/MyWork/tomcat/tomcat7/webapps/STL-OEC
		  //linux-rootPath=/,/root/Desktop/java/apache-tomcat-7.0.78/webapps/STL-OEC/WEB-INF/classes/
		  String rootPath  = "";
		  //windows下
		  if("\\".equals(File.separator)){   
		   rootPath  = classPath.substring(1,classPath.indexOf("WEB-INF/classes"));
		   //rootPath = rootPath.replace("/", "\\");
		  }
		  //linux下
		  if("/".equals(File.separator)){   
		   rootPath  = classPath.substring(0,classPath.indexOf("WEB-INF/classes"));
		   //rootPath = rootPath.replace("\\", "/");
		  }
		  return rootPath;
	}
	
	
	/**
	 * 获取文件所在根目录地址
	 * 在tomcat下的磁盘路径以项目名称结尾
	 * 类似D:/tomcat7/webapps/STL-OEC/，
	 * 区分windows和linux
	 */
	public static String getRootFilePath() {
		  String classPath = Tools.class.getClassLoader().getResource("").getPath();
		  //windows-File.separator=\,classPath=/D:/MyWork/tomcat/tomcat7/webapps/STL-OEC/WEB-INF/classes/
		  //rootPath=D:/MyWork/tomcat/tomcat7/webapps/STL-OEC
		  //linux-rootPath=/,/root/Desktop/java/apache-tomcat-7.0.78/webapps/STL-OEC/WEB-INF/classes/
		  String rootPath  = "";
		  
		  Properties prop = Tools.loadPropertiesFile("fileconfig.properties");
		  
		  if("0".equals(prop.getProperty("IS_FIXED_ADDRESS"))){
			//windows下
			  if("\\".equals(File.separator)){   
			   rootPath  = classPath.substring(1,classPath.indexOf("WEB-INF/classes"));
			   //rootPath = rootPath.replace("/", "\\");
			  }
			  //linux下
			  if("/".equals(File.separator)){   
			   rootPath  = classPath.substring(0,classPath.indexOf("WEB-INF/classes"));
			   //rootPath = rootPath.replace("\\", "/");
			  }
		  }else{
			//windows下
			  if("\\".equals(File.separator)){   
			   rootPath  = prop.getProperty("WINDOWS_FIXED_FILE_PATH");
			  }
			  //linux下
			  if("/".equals(File.separator)){   
			   rootPath  = prop.getProperty("LINUX_FIXED_FILE_PATH");
			  }
		  }
		  
		  return rootPath;
	}
	
	/**
	 * 返回class文件的目录
	 * 类似STL-OEC/WEB-INF/classes/
	 */
	public static String getClassPath(){
		return getRootPath() + "WEB-INF/classes/";
	}

	/**
	 * 读取txt里的单行内容
	 * 
	 * @param filePath 文件路径
	 */
	public static String readTxtFile(String fileP) {
		try {

			String filePath = Tools.getRootPath();
			/*
			String filePath = String.valueOf(Thread.currentThread().getContextClassLoader().getResource("")) + "../../"; //项目路径
			//区分操作系统
			String opSystemName = System.getProperty("os.name");
			if(opSystemName.startsWith("Windows")){
				filePath = filePath.replaceAll("file:/", "");
			}else if(opSystemName.startsWith("Linux")){
				filePath = filePath.replaceAll("file:", "");
			}
//			filePath = filePath.replaceAll("file:/", "");
			filePath = filePath.replaceAll("%20", " ");
			*/
			filePath = filePath.trim() + fileP.trim();

			String encoding = "utf-8";
			File file = new File(filePath);
			if (file.isFile() && file.exists()) { // 判断文件是否存在
				InputStreamReader read = new InputStreamReader(new FileInputStream(file), encoding); // 考虑到编码格式
				BufferedReader bufferedReader = new BufferedReader(read);
				String lineTxt = null;
				while ((lineTxt = bufferedReader.readLine()) != null) {
					return lineTxt;
				}
				read.close();
			} else {
				System.out.println("找不到指定的文件,查看此路径是否正确:" + filePath);
			}
		} catch (Exception e) {
			System.out.println("读取文件内容出错");
		}
		return "";
	}
	
	/**
	 * 读取配置文件
	 * @param configPath 文件存放的相对路径
	 * @return
	 */
	public static Properties loadPropertiesFile(String configPath){
		try {
			Properties pro = new Properties();
			String filePath = Tools.getClassPath();
			filePath = filePath.trim() + configPath.trim();
			FileInputStream in = new FileInputStream(filePath);
			pro.load(new InputStreamReader(in, "UTF-8"));
			return pro;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	/**
	 * 向配置文件存储
	 * @param configPath 文件存放的相对路径
	 * @return
	 */
	public static Properties storePropertiesFile(String configPath,Properties p){
		try {
			String filePath = Tools.getClassPath();
			filePath = filePath.trim() + configPath.trim();
			FileOutputStream out = new FileOutputStream(filePath);
			p.store(out,null);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 *检验String是否为数字
	 *@param checknum 
	 *@return isNum 
	 */
	public static boolean checkStringIsNum(String checknum){
		try {
			//可检验带正负号、小数点的数字
			Pattern pattern = Pattern.compile("^[+-]?\\d+(\\.\\d+)?$");
			boolean result = pattern.matcher(checknum).matches();
			return result;
		} catch (Exception e) {
			return false;
		}
	}

}
