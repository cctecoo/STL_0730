package com.mfw.util;

import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

/**
 * 从EXCEL导入到数据库 创建人：mfw 创建时间：2014年12月23日
 * 
 * @version
 */
public class ObjectExcelRead {

	/**
	 * 获取导入的表格
	 * @param filepath	文件上传的路径
	 * @param filename	文件名称
	 * @return
	 */
	public static Workbook getWorkbook(String filepath, String filename){
		Workbook wb = null;
		try {
			File target = new File(filepath, filename);
			FileInputStream fi = new FileInputStream(target);
			//调用工厂类，不需要再判断03、07的文件类型了
			wb = WorkbookFactory.create(fi);
//			String fileType = filename.split("\\.")[1];
//			if(fileType.equals("xls")){
//				wb = new HSSFWorkbook(fi);
//			}else if(fileType.equals("xlsx")){
//				wb = new XSSFWorkbook(fi);
//			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return wb;
	}
	
	/**
	 * 获取每个sheet页的内容
	 * @param wb 	   //表格对象
	 * @param startrow //开始行号
	 * @param startcol //开始列号
	 * @param sheetnum //sheet
	 * @return list
	 */
	public static List<PageData> getExcelData(Workbook wb, int startrow, int startcol, int sheetnum,
			List<PageData> varList){
		Sheet sheet = wb.getSheetAt(sheetnum); //sheet 从0开始
		int rowNum = sheet.getLastRowNum() + 1; //取得最后一行的行号

		for (int i = startrow; i < rowNum; i++) { //行循环开始

			PageData varpd = new PageData();
			Row row = sheet.getRow(i); //行
			if(null == row){
				continue;//空白行跳过，继续读取下一行
			}
			int cellNum = row.getLastCellNum(); //每行的最后一个单元格位置

			for (int j = startcol; j < cellNum; j++) { //列循环开始

				Cell cell = row.getCell(Short.parseShort(j + ""));
				String cellValue = null;
				if (null != cell) {
					//cell.setCellType(Cell.CELL_TYPE_STRING);
					
					switch (cell.getCellType()) { // 判断excel单元格内容的格式，并对其进行转换，以便插入数据库
						case Cell.CELL_TYPE_NUMERIC:
							boolean isDate = false;
							SimpleDateFormat sdf = null;
							short format = cell.getCellStyle().getDataFormat();
							if (format == 14 || format == 31 || format == 57 || format == 58  
				                    //|| (176<=format && format<=178) //|| (182<=format && format<=196) 
				                    || (210<=format && format<=213) || (208==format ) ) { // 日期
				                sdf = new SimpleDateFormat("yyyy-MM-dd");
				                isDate = true;
				            } else if (format == 20 || format == 32 || format==183 || (200<=format && format<=209) ) { // 时间
				                sdf = new SimpleDateFormat("HH:mm");
				                isDate = true;
				            } else { // 不是日期格式
				            	cell.setCellType(Cell.CELL_TYPE_STRING);
								cellValue = cell.getStringCellValue().trim();
				            }
							if(isDate){
								double value = cell.getNumericCellValue();
								cell.setCellType(Cell.CELL_TYPE_STRING);
								String strVal = cell.getStringCellValue().trim();
								if(strVal.substring(strVal.length()-3).equals(".10")){
									cellValue = strVal;
								}else{
									Date date = org.apache.poi.ss.usermodel.DateUtil.getJavaDate(value);
						            if(date==null || "".equals(date)){
						            	cellValue = "";
						            }
						            try {
						            	cellValue = sdf.format(date);
						            } catch (Exception e) {
						                e.printStackTrace();
						                cellValue = "";
						            }
								}
							}
							
//							if(DateUtil.isCellDateFormatted(cell)){
//								cellValue = new SimpleDateFormat("yyyy-MM-dd").format(DateUtil.getJavaDate(cell.getNumericCellValue())); 
//							}else{
//								cell.setCellType(Cell.CELL_TYPE_STRING);
//								cellValue = cell.getStringCellValue().trim();
//							}
							//cellValue = cell.getStringCellValue().trim();
							break;
						case Cell.CELL_TYPE_STRING:
							cellValue = cell.getStringCellValue().trim();
							break;
						case Cell.CELL_TYPE_FORMULA:
							cellValue = cell.getCellFormula().trim();
							//cellValue = cell.getStringCellValue().trim();
							// cellValue = String.valueOf(cell.getDateCellValue());
							break;
						case Cell.CELL_TYPE_BLANK:
							cellValue = "";
							break;
						case Cell.CELL_TYPE_BOOLEAN:
							cellValue = String.valueOf(cell.getBooleanCellValue()).trim();
							break;
						case Cell.CELL_TYPE_ERROR:
							cellValue = String.valueOf(cell.getErrorCellValue()).trim();
							break;
					}
				} else {
					cellValue = "";
				}

				varpd.put("var" + j, cellValue);

			}
			varList.add(varpd);
		}
		return varList;
	}
	
	/**
	 * @param filepath //文件路径
	 * @param filename //文件名
	 * @param startrow //开始行号
	 * @param startcol //开始列号
	 * @param sheetnum //sheet
	 * @return list
	 */
	public static List<PageData> readExcel(String filepath, String filename, int startrow, int startcol, int sheetnum) {
		List<PageData> varList = new ArrayList<PageData>();

		try {
			//读取表格文件
			Workbook wb = getWorkbook(filepath, filename);
			//wb.getNumberOfSheets();
			//处理表格
			varList = getExcelData(wb, startrow, startcol, sheetnum, varList);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return varList;
	}

}
