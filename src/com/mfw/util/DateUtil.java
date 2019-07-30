package com.mfw.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtil {
	
	/**
	 * 2018
	 */
	private final static SimpleDateFormat sdfYear = new SimpleDateFormat("yyyy");

	/**
	 * 2018-01-01
	 */
	private final static SimpleDateFormat sdfDay = new SimpleDateFormat("yyyy-MM-dd");

	/**
	 * 20180101
	 */
	private final static SimpleDateFormat sdfDays = new SimpleDateFormat("yyyyMMdd");

	/**
	 * 2018-01-01 01:01:01
	 */
	private final static SimpleDateFormat sdfTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	/**
	 * 返回当前年份
	 * 2018
	 * @return
	 */
	public static String getYear() {
		return sdfYear.format(new Date());
	}

	/**
	 * 返回当前日期
	 * 2018-01-01
	 * @return
	 */
	public static String getDay() {
		return sdfDay.format(new Date());
	}

	/**
	 * 返回当前日期
	 * 20180101
	 * @return
	 */
	public static String getDays() {
		return sdfDays.format(new Date());
	}

	/**
	 * 返回当前时间
	 * 2018-01-01 01:01:01
	 * @return
	 */
	public static String getTime() {
		return sdfTime.format(new Date());
	}

	/**
	 * @Title: compareDate
	 * @Description: TODO(日期比较，如果s>=e 返回true 否则返回false)
	 * @param s
	 * @param e
	 * @return boolean
	 * @throws
	 * @author luguosui
	 */
	public static boolean compareDate(String s, String e) {
		if (parseDate(s) == null || parseDate(e) == null) {
			return false;
		}
		return parseDate(s).getTime() >= parseDate(e).getTime();
	}
	
	/**
	 * 返回当前日期 2018-01-01
	 */
	public static Date getCurrentDate(){
		try {
			Date now = sdfDay.parse(sdfDay.format(new Date()));
			return now;
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 格式化日期
	 * 2018-01-01
	 * @return
	 */
	public static Date parseDate(String date) {
		try {
			return sdfDay.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * 格式化日期
	 * 2018-01-01
	 * @return
	 */
	public static String format(Date date) {
		return sdfDay.format(date);
	}

	/**
	 * 校验日期是否合法
	 * 
	 * @return
	 */
	public static boolean isValidDate(String s) {
		try {
			sdfDay.parse(s);
			return true;
		} catch (Exception e) {
			// 如果throw java.text.ParseException或者NullPointerException，就说明格式不对
			return false;
		}
	}

	public static int getDiffYear(String startTime, String endTime) {
		try {
			long aa = 0;
			int years = (int) (((sdfDay.parse(endTime).getTime() - sdfDay.parse(startTime).getTime()) / (1000 * 60 * 60 * 24)) / 365);
			return years;
		} catch (Exception e) {
			// 如果throw java.text.ParseException或者NullPointerException，就说明格式不对
			return 0;
		}
	}

	/**
	 * <li>功能描述：时间相减得到天数
	 * 
	 * @param beginDateStr
	 * @param endDateStr
	 * @return long
	 * @author Administrator
	 */
	public static long getDaySub(String beginDateStr, String endDateStr) {
		long day = 0;
		java.util.Date beginDate = null;
		java.util.Date endDate = null;

		try {
			beginDate = sdfDay.parse(beginDateStr);
			endDate = sdfDay.parse(endDateStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		day = (endDate.getTime() - beginDate.getTime()) / (24 * 60 * 60 * 1000);
		//System.out.println("相隔的天数="+day);

		return day;
	}

	/**
	 * 得到n天之后的日期
	 * 
	 * @param days
	 * @return
	 */
	public static String getAfterDayDate(String days) {
		int daysInt = Integer.parseInt(days);

		Calendar canlendar = Calendar.getInstance(); // java.util包
		canlendar.add(Calendar.DATE, daysInt); // 日期减 如果不够减会将月变动
		Date date = canlendar.getTime();

		String dateStr = sdfTime.format(date);

		return dateStr;
	}

	/**
	 * 得到n天之后是周几
	 * 
	 * @param days
	 * @return
	 */
	public static String getAfterDayWeek(String days) {
		int daysInt = Integer.parseInt(days);

		Calendar canlendar = Calendar.getInstance(); // java.util包
		canlendar.add(Calendar.DATE, daysInt); // 日期减 如果不够减会将月变动
		Date date = canlendar.getTime();

		SimpleDateFormat sdf = new SimpleDateFormat("E");
		String dateStr = sdf.format(date);

		return dateStr;
	}

	public static void main(String[] args) {
		System.out.println(getDays());
		System.out.println(getAfterDayWeek("3"));
	}

}
