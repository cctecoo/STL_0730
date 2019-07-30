package com.mfw.util;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;

import org.springframework.web.servlet.view.document.AbstractExcelView;

/**
 * 处理部门业务预算模板导出
 */
@SuppressWarnings("deprecation")
public class YwExcelView extends AbstractExcelView {
	
	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * 处理导出时的数据
	 */
	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(Map<String, Object> model, HSSFWorkbook workbook, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		Date date = new Date();
		String filename = Tools.date2Str(date, "yyyyMMddHHmmss");
		HSSFSheet sheet;
		HSSFCell cell;
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename=" + filename + "_YwBudgetDeptYear.xls");
		sheet = workbook.createSheet("sheet1");
		//标题样式
		HSSFCellStyle headerStyle = workbook.createCellStyle();
		headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		HSSFFont headerFont = workbook.createFont(); //标题字体
		headerFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		headerFont.setFontHeightInPoints((short) 11);
		headerStyle.setFont(headerFont);
		//内容样式
		HSSFCellStyle contentStyle = workbook.createCellStyle();
		contentStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		
		short width = 20, height = 25 * 20;
		sheet.setDefaultColumnWidth(width);
		
		int maxLevel = (Integer) model.get("maxLevel");
		String depModelId = (String) model.get("depModelId");
		setCell(sheet, headerStyle, "模板标识", 0, 0, maxLevel-1, 0);
		setCell(sheet, headerStyle, "科目名称", 0, 1, maxLevel-1, 1);
		//设置一级纬度列头
		List<PageData> titles = (List<PageData>) model.get("titles");
		Map<String, List<PageData>> colMap = (Map<String, List<PageData>>) model.get("colMap");
		
		int lastEndIndex = 2;//维度从第2列开始
		//设置子维度表头
		setChildTitle(titles, sheet, headerStyle, lastEndIndex, maxLevel, colMap);
		//设置自定义维度
		List<PageData> defList = (List<PageData>) model.get("defList");
		for(int i=0; i<titles.size(); i++){
			lastEndIndex += ((Long) titles.get(i).get("endSize")).intValue();
		}
		for(int i=0; i<defList.size(); i++){
			setCell(sheet, headerStyle, defList.get(i).getString("DEF_NAME"), 0, lastEndIndex+i, maxLevel-1, lastEndIndex+i);
		}
		
		//设置行头
		List<PageData> rowList = (List<PageData>) model.get("rowList");
		for(int i=0; i<rowList.size(); i++){
			cell = getCell(sheet, maxLevel + i, 0);
			cell.setCellStyle(headerStyle);
			setText(cell, depModelId);
			PageData rowPd = rowList.get(i);
			cell = getCell(sheet, maxLevel + i, 1);//科目名称从第2列开始
			cell.setCellStyle(headerStyle);
			setText(cell, rowPd.getString("SUBJECT_NAME"));
		}
		sheet.getRow(0).setHeight(height);
	}
	
	/**
	 * 创建合并的单元格
	 * @param sheet			sheet表格
	 * @param style			样式
	 * @param text			值
	 * @param firstRow		起始行
	 * @param firstCol		起始列
	 * @param lastRow		结束行
	 * @param lastCol		结束列
	 */
	private void setCell(HSSFSheet sheet,HSSFCellStyle style, String text, int firstRow, 
			int firstCol, int lastRow, int lastCol){
		sheet.addMergedRegion(new Region(firstRow, (short)firstCol, lastRow, (short)lastCol));
		HSSFCell cell = getCell(sheet, firstRow, firstCol);
		cell.setCellStyle(style);
		setText(cell, text);
	}
	
	/**
	 * 设置子维度标题
	 * @param titles		父维度列表
	 * @param sheet			sheet表
	 * @param headerStyle	标题样式
	 * @param lastEndIndex	上一个维度的下标
	 * @param maxLevel		最大维度
	 * @param colMap		子纬度集合
	 */
	private void setChildTitle(List<PageData> titles, HSSFSheet sheet, HSSFCellStyle headerStyle, 
			int lastEndIndex, int maxLevel, Map<String, List<PageData>> colMap){
		
		for(int i=0; i<titles.size(); i++){
			PageData titlePd = titles.get(i);
			int level = ((Integer)titlePd.get("DIM_LEVEL")).intValue();
			int endSize = ((Long) titlePd.get("endSize")).intValue();
			String text = titlePd.getString("DIMENSION_NAME");
			//当前维度等级小于最大维度等级时，获取子维度
			if(level<maxLevel){
				if(endSize>0){//包含多个子纬度
					//设置当前维度所在的单元格
					setCell(sheet, headerStyle, text, level-1, lastEndIndex, level-1, lastEndIndex+endSize-1);
					//拼接用于获取子维度列表的键值
					String key = (level+1) + "_" + i + "_" + String.valueOf(titlePd.get("DIM_ID"));
					logger.debug("key=" + key);
					List<PageData> childTitles = colMap.get(key);
					if(null != childTitles){//子维度列表不为空时，创建对应单元格
						setChildTitle(childTitles, sheet, headerStyle, lastEndIndex, maxLevel, colMap);
					}else{
						logger.debug("no child");
					}
				}else{
					endSize = 1;//不包含子维度时加一，表示处理下一个单元格
					setCell(sheet, headerStyle, text, level-1, lastEndIndex, maxLevel-1, lastEndIndex);
				}
			}else{
				endSize = 1;//不包含子维度时加一，表示处理下一个单元格
				HSSFCell cell = getCell(sheet, level-1, lastEndIndex);
				cell.setCellStyle(headerStyle);
				setText(cell, text);
			}
			
			lastEndIndex = lastEndIndex + endSize;//单元格设置后，改变其结束的下标
		}
	}

}
