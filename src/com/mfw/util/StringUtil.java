package com.mfw.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 字符串相关方法
 */
public class StringUtil {

	/**
	 * 将以逗号分隔的字符串转换成字符串数组
	 * 
	 * @param valStr
	 * @return String[]
	 */
	public static String[] StrList(String valStr) {
		int i = 0;
		String TempStr = valStr;
		String[] returnStr = new String[valStr.length() + 1 - TempStr.replace(",", "").length()];
		valStr = valStr + ",";
		while (valStr.indexOf(',') > 0) {
			returnStr[i] = valStr.substring(0, valStr.indexOf(','));
			valStr = valStr.substring(valStr.indexOf(',') + 1, valStr.length());

			i++;
		}
		return returnStr;
	}
	
	/**
	 * 替换特殊字符为""
	 * @param s
	 * @return
	 */
	public static String replaceSpecialStr(String s){
		//String s="wewe#@?$*' \"&123=123;,";
		//RegExp(/[(\ )(\~)(\!)(\@)(\#)(\$)(\%)(\^)(\&)(\*)(\()(\))(\-)(\_)(\+)(\=)(\[)(\])(\{)(\})(\|)(\\)(\;)(\:)(\')(\")(\,)(\.)(\/)(\<)(\>)(\?)(\)]+/);
		StringBuffer sb = new StringBuffer() ; 
		Pattern p = Pattern.compile("'|\"|&|=|;|,|#|@| |\\$|\\*|\\?|\\+|:|%|~|!|\\^") ;
        Matcher m = p.matcher(s) ;
        while( m.find() ){
            //String tmp = m.group() ;
            String v = "";
            //注意，在替换字符串中使用反斜线 (\) 和美元符号 ($) 可能导致与作为字面值替换字符串时所产生的结果不同。
            //美元符号可视为到如上所述已捕获子序列的引用，反斜线可用于转义替换字符串中的字面值字符。 
            v = v.replace("\\", "\\\\").replace("$", "\\$"); 
            //替换掉查找到的字符串            
            m.appendReplacement(sb, v) ; 
        }
        //别忘了加上最后一点
        m.appendTail(sb) ;
        
        return sb.toString();
	}
}
