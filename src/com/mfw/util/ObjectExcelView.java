package com.mfw.util;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.Region;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import com.mfw.util.PageData;
import com.mfw.util.Tools;

/**
 * 导入到EXCEL 类名称：ObjectExcelView.java 类描述：
 * 
 * @author mfw 作者单位： 联系方式：
 * @version 1.0
 */
public class ObjectExcelView extends AbstractExcelView {

	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(Map<String, Object> model, HSSFWorkbook workbook, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		Date date = new Date();
		//文件名称
		String filename = Tools.date2Str(date, "yyyyMMddHHmmss");
		if(null != model.get("filename") && !model.get("filename").toString().isEmpty()){
			String name = model.get("filename").toString();
			name = name.replaceAll("\\/", "");
			filename = new String(name.getBytes(), "ISO-8859-1"); 
		}
		//单元格的文本对齐方式
		short textAlign = HSSFCellStyle.ALIGN_CENTER;//居中
		if(null != model.get("textAlign") && model.get("textAlign").toString().equals("left")){
			textAlign = HSSFCellStyle.ALIGN_LEFT ;//左对齐
		}
		
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename=" + filename + ".xls");
		
		//设置默认样式
		HSSFCellStyle headerStyle = workbook.createCellStyle(); //标题样式
		headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
//		headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
//		headerStyle.setFillForegroundColor(HSSFColor.ROYAL_BLUE.index);
		HSSFFont headerFont = workbook.createFont(); //标题字体
		headerFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		headerFont.setFontHeightInPoints((short) 16);
		headerFont.setFontName("宋体");
//		headerFont.setColor(HSSFColor.WHITE.index);
		headerStyle.setFont(headerFont);
		
		HSSFCellStyle titleStyle = workbook.createCellStyle(); //行标题样式
		titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		titleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		HSSFFont titleFont = workbook.createFont(); //内容字体
		titleFont.setFontHeightInPoints((short) 11);
		titleFont.setFontName("宋体");
		titleStyle.setFont(titleFont);
		
		HSSFCellStyle contentStyle = workbook.createCellStyle(); //内容样式
		contentStyle.setAlignment(textAlign);//文本对齐方式
		HSSFFont contentFont = workbook.createFont(); //内容字体
		contentFont.setFontName("宋体");
		contentStyle.setFont(contentFont);
		
		short width = 20, height = 25 * 20;
		
		//获取sheet页的名称列表
		List<String> sheetNames = new ArrayList<String>();
		sheetNames.add("sheet1");
		if(null != model.get("sheetNames")){
			sheetNames = (List<String>) model.get("sheetNames");
		}
		//循环创建sheet页
		for(int k=0; k<sheetNames.size(); k++){
			//获取每个sheet中内容使用的下标
			String index = String.valueOf(k+1);
			if(sheetNames.size()==1){
				index = "";
			}
			//sheet名称
			String sheetName = sheetNames.get(k);
			sheetName = sheetName.replaceAll("\\/", "");
			//第一行的大标题
			String fileTitle = null;
			if(null != model.get("fileTile"+index)){
				fileTitle = model.get("fileTile"+index).toString();
			}
			//获取第二标题行
			List<String> titles = (List<String>) model.get("titles"+index);
			//获取第三标题行
			List<String> thridtitles = (List<String>) model.get("thridtitles"+index);
			//读取数据行
			List<PageData> varList = (List<PageData>) model.get("varList"+index);
			//获取最后的统计行
			List<PageData> totalList = (List<PageData>) model.get("totalList"+index);
			//特殊模块的表格样式
			String titleType = null;
			if(null != model.get("titleType"+index)){
				titleType = model.get("titleType"+index).toString();
			}
			
			//创建sheet
			createSheet(workbook, sheetName, fileTitle, titles, varList, thridtitles, totalList,
					titleType, headerStyle, titleStyle, contentStyle, width, height);
		}
	}
	
	/**
	 * 创建sheet页
	 * @param workbook		表格对象
	 * @param sheetName		sheet页名称
	 * @param fileTitle		大标题
	 * @param titles		列标题
	 * @param varList		数据行
	 * @param thirdtitles	第三行标题
	 * @param totalList		汇总行
	 * @param titleType		标题样式
	 * @param headerStyle	大标题样式
	 * @param titleStyle	列标题样式
	 * @param contentStyle	单元格样式
	 * @param width			默认的单元格宽度
	 * @param height		默认行高度
	 */
	@SuppressWarnings("deprecation")
	private void createSheet(HSSFWorkbook workbook, String sheetName, String fileTitle, List<String> titles,
			List<PageData> varList, List<String> thirdtitles, List<PageData> totalList, String titleType,
			HSSFCellStyle headerStyle, HSSFCellStyle titleStyle, HSSFCellStyle contentStyle,
			short width, short height){
		HSSFSheet sheet = workbook.createSheet(sheetName);
		HSSFCell cell;
		
		int len = titles.size();
		
		sheet.setDefaultColumnWidth(width);
		int currentRow = 0;
		
		if(null == thirdtitles){
			//设置文件第一行标题
			if(null != fileTitle){
				sheet.addMergedRegion(new Region(0, (short)0, 0, (short)(len-1)));
				cell = getCell(sheet, 0, 0);
				cell.setCellStyle(headerStyle);
				setText(cell, fileTitle);
				sheet.getRow(currentRow).setHeight(height);
				currentRow ++;
			}
			if(len>0){
				for (int i = 0; i < len; i++) { //设置标题
					String title = titles.get(i);
					cell = getCell(sheet, currentRow, i);
					cell.setCellStyle(titleStyle);
					setText(cell, title);
				}
				sheet.getRow(currentRow).setHeight(height);
				currentRow ++;
			}
		}else{
			//设置文件第一行标题
			if(null != fileTitle){
				sheet.addMergedRegion(new Region(0, (short)0, 0, (short)(thirdtitles.size())));
				cell = getCell(sheet, 0, 0);
				cell.setCellStyle(headerStyle);
				setText(cell, fileTitle);
				sheet.getRow(currentRow).setHeight(height);
				currentRow ++;
			}
			if(len>0){//第二行标题
				for (int i = 0; i < len; i++) { //设置标题
					String title = titles.get(i);
					if(null != titleType && titleType.equals("repairOrder")){
						sheet.setDefaultColumnWidth(10);
						int start = i==0? 0 : 1+4*(i-1);
						int end = i==0? 0: 4*i;
						int endRow = currentRow==1 && i==0? 2: currentRow;
						
						sheet.addMergedRegion(new Region(currentRow, (short)start, endRow, (short)end));
						cell = getCell(sheet, currentRow, start);
					}else{
						cell = getCell(sheet, currentRow, i);
					}
					cell.setCellStyle(titleStyle);
					setText(cell, title);
				}
				sheet.getRow(currentRow).setHeight(height);
				currentRow ++;
			}
			if(thirdtitles.size()>0){//第三行标题
				for (int i = 0; i < thirdtitles.size(); i++) { //设置标题
					String title = thirdtitles.get(i);
					cell = getCell(sheet, currentRow, i+1);
					cell.setCellStyle(titleStyle);
					setText(cell, title);
				}
				sheet.getRow(currentRow).setHeight(height);
				currentRow ++;
			}
		}
		
		
		//设置数据行
		int varCount = varList.size();
		for (int i = 0; i < varCount; i++) {
			PageData vpd = varList.get(i);
			if(null != thirdtitles && thirdtitles.size()>0){//第三行标题
				len = thirdtitles.size()+1;
			}
			setCellData(len, vpd, sheet, i, currentRow, contentStyle);
			/*for (int j = 0; j < len; j++) {
				Object varstr = vpd.get("var" + (j + 1)) != null ? vpd.get("var" + (j + 1)) : "";
				cell = getCell(sheet, i + currentRow, j);
				cell.setCellStyle(contentStyle);
				if(varstr instanceof Integer || varstr instanceof Double || varstr instanceof Long){
					cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
					cell.setCellValue(Double.valueOf(String.valueOf(varstr)));
				}else if(varstr instanceof BigDecimal){
					cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
					cell.setCellValue(((BigDecimal) varstr).doubleValue());
				}else{
					setText(cell, (String)varstr);
				}
			}*/
		}

		//设置汇总行
		if(totalList != null){
			for(int i=0; i<totalList.size(); i++){
				PageData vpd = totalList.get(i);
				setCellData(len, vpd, sheet, i, currentRow+varCount, contentStyle);
			}
		}
	}

	/**
	 * 创建单元格内容
	 */
	private void setCellData(int len, PageData vpd, HSSFSheet sheet,
			int row, int currentRow, HSSFCellStyle contentStyle){
		for (int j = 0; j < len; j++) {
			Object varstr = vpd.get("var" + (j + 1)) != null ? vpd.get("var" + (j + 1)) : "";
			HSSFCell cell = getCell(sheet, row + currentRow, j);
			cell.setCellStyle(contentStyle);
			if(varstr instanceof Integer || varstr instanceof Double || varstr instanceof Long){
				cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
				cell.setCellValue(Double.valueOf(String.valueOf(varstr)));
			}else if(varstr instanceof BigDecimal){
				cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
				cell.setCellValue(((BigDecimal) varstr).doubleValue());
			}else{
				setText(cell, (String)varstr);
			}
		}
	}

}
