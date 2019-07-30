package com.mfw.service.bdata;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.util.Const;
import com.mfw.util.Logger;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.PageData;

/**
 * 员工培训表Service
 * @author  作者  蒋世平
 * @date 创建时间：2016年5月10日 上午9:52:33
 */
@Service
public class EmployeeTrainService {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	@SuppressWarnings("unchecked")
	public List<PageData> findTrainList(Page page) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeTrainMapper.findTrainlistPage", page);
	}

	public void save(PageData pd)throws Exception{
		dao.save("EmployeeTrainMapper.save", pd);
	}
	
	/**
	 * 批量保存
	 */
	public void saveByBatch(List<PageData> list) throws Exception{
		dao.batchSave("EmployeeTrainMapper.saveByBatch", list);
	}

	public void edit(PageData pd)throws Exception{
		dao.update("EmployeeTrainMapper.edit", pd);
	}

	public void delete(PageData pd)throws Exception{
		dao.update("EmployeeTrainMapper.deleteRecord", pd);
	}
	
	/**
	 * 批量删除
	 */
	public void batchDelete(PageData pd)throws Exception{
		dao.update("EmployeeTrainMapper.batchDeleteRecord", pd);
	}

	public PageData findById(PageData pd)throws Exception{
		return (PageData) dao.findForObject("EmployeeTrainMapper.findById", pd);
	}

	public List<PageData> findByEmpCode(PageData searchPd)throws Exception{
		return (List<PageData>) dao.findForList("EmployeeTrainMapper.findByEmpCode", searchPd);
	}
	
	/**
	 * 更新培训计划
	 */
	public void updateEmpTrain(PageData pd) throws Exception{
		dao.update("EmployeeTrainMapper.updateEmpTrain", pd);
	}
	
	/**
	 * 根据员工编码删除记录
	 */
	private void deleteRecordByEmpcode(PageData pd) throws Exception{
		dao.update("EmployeeTrainMapper.deleteRecordByEmpcode", pd);
	}
	
	/**
	 * 导入从excel读取的员工培训记录
	 * @param filePath
	 * @param fileName
	 * @param user
	 * @param employeeService
	 * @return
	 * @throws Exception
	 */
	public String readEmpTrainExcel(String filePath, String fileName, User user, EmployeeService employeeService) throws Exception{
		String msg = "";
		//读取表格
		Workbook wb = ObjectExcelRead.getWorkbook(filePath, fileName);
		if(null==wb){
			return "未读取到表格文件";
		}
		//获取sheet数量
		int sheetNum = wb.getNumberOfSheets();
		//循环处理
		for(int i=0; i<sheetNum; i++){
			String sheetStr = "第" + (i+1) + "个sheet页" + wb.getSheetName(i) ;
			
			//执行读EXCEL操作,读出的数据导入List, 0:从第1行开始；0:从第A列开始；0:第1个sheet
			List<PageData> listPd = ObjectExcelRead.getExcelData(wb, 0, 0, i, new ArrayList<PageData>());
			if(listPd.size()==0){
				msg = sheetStr + "没有内容，退出导入";
				break;
			}
			//判断第一行表格名称
			String firstRow = listPd.get(0).getString("var0");
			if(!"人员培训统计台帐".equals(firstRow)){
				msg = sheetStr + "第一行标题不符，只能导入'人员培训统计台帐'，请检查后再导入";
				break;
			}
			//查询员工编码
			String empName = listPd.get(2).getString("var1");
			String empDeptName = listPd.get(3).getString("var3");
			
			PageData searchPd = new PageData();
			searchPd.put("name", empName);
			searchPd.put("deptName", empDeptName);
			PageData empPd = employeeService.findEmployeeByNameAndDept(searchPd);
			if(null == empPd){//没有查询到匹配的记录
				//部门名称可能包含中文括号，系统中保存的为英文，这里做一个替换
				searchPd.put("deptName", empDeptName.replace("（", "(").replace("）", ")"));
				empPd = employeeService.findEmployeeByNameAndDept(searchPd);
				if(null == empPd){
					msg = sheetStr + "员工["+empName+"]["+ empDeptName + "]部门与系统不一致，请检查后再导入";
					break;
				}
			}
			//判断第五行内容
			PageData fifthRow = listPd.get(4);
			//‘培训内容’占两个单元格，所以‘讲授人’是第四列
			if( !"培训日期".equals(fifthRow.getString("var0")) || !"培训内容".equals(fifthRow.getString("var1")) 
				|| !"讲授人".equals(fifthRow.getString("var3")) || !"地点".equals(fifthRow.getString("var4")) 
				|| !"培训形式".equals(fifthRow.getString("var5")) || !"课时".equals(fifthRow.getString("var6"))	
				|| !"成绩".equals(fifthRow.getString("var7")) || !"岗位变动".equals(fifthRow.getString("var8")) ){
				msg = sheetStr + "第五行标题不符，请检查后再导入";
				break;
			}
			//格式正确
			if(msg.isEmpty()){
				//执行导入操作
				msg = importExcel(listPd, empPd, user);
				if(!msg.isEmpty()){
					msg = sheetStr + msg;
					break;
				}
			}
		}
		return msg;
	}

	/**
	 * 从表格导入
	 */
	public String importExcel(List<PageData> listPd, PageData empPd, User user) throws Exception{
		//开始处理数据
		String empCode = empPd.get("EMP_CODE").toString();
		//var0:第一列      var1:第二列    varN:第N+1列
		List<PageData> addList = new ArrayList<PageData>();
		SimpleDateFormat fullDayFormat = new SimpleDateFormat("yyyyMMdd");
		for (int i = 5; i < listPd.size(); i++) {
			if(null == listPd.get(i).get("var0") || listPd.get(i).getString("var0").isEmpty()){//第一列没有数据则跳过
				continue;
			}
			String content = listPd.get(i).getString("var1");
			if(content=="" || content==null){
				content = listPd.get(i).getString("var2");
				if(content=="" || content==null){
					return "第" + (i+1) + "行的培训内容为空，请检查后再导入";
				}
			}
			
			
			//设置保存的数据
			PageData pd = new PageData();
			pd.put("EMP_CODE", empCode);
			pd.put("TRAIN_CONTENT", content);//培训内容
			pd.put("TRAIN_TEACHER", listPd.get(i).getString("var3"));//讲授人
			pd.put("TRAIN_ADDRESS", listPd.get(i).getString("var4"));//培训地点
			pd.put("TRAIN_MODE", listPd.get(i).getString("var5"));//培训形式
			pd.put("LESSON_PERIOD", listPd.get(i).getString("var6"));//课时
			pd.put("EVALUATION", null);
			pd.put("TRAIN_RESULT", listPd.get(i).getString("var7"));//成绩
			pd.put("GRADE_CHANGE", listPd.get(i).getString("var8"));//岗位变动
			pd.put("CREATE_USER", user.getUSERNAME());
			pd.put("CREATE_TIME", new Date());
			//处理培训日期
			String trainPeriod = listPd.get(i).getString("var0");
			try {
				Date[] arr = parseDate(fullDayFormat, trainPeriod);
				pd.put("START_DATE", arr[0]);
				pd.put("END_DATE", arr[1]);
			} catch (Exception e) {
				logger.error("importExcel empRrecord parseDate[" + trainPeriod + "].", e);
				return  "第" + (i+1) + "行转换日期格式出错:" + trainPeriod;
			}
			pd.put("TRAIN_DATE", null);
			pd.put("TRAIN_DATE_STR", trainPeriod);
			pd.put("STATUS", Const.SYS_STATUS_YW_YSX);
			addList.add(pd);		
		}
		//先删除之前所有的记录
		PageData updatePd = new PageData();
		updatePd.put("updateUser", user.getUSERNAME());
		updatePd.put("empCode", empCode);
		deleteRecordByEmpcode(updatePd);
		//批量保存
		saveByBatch(addList);
		return "";
	}
	/**
	 * 转换日期格式
	 */
	private Date[] parseDate(SimpleDateFormat fullDayFormat, String str) throws Exception{
		Date start = null;
		Date end = null;
		String startStr = null;
		if(str.matches("[0-9]{1,8}")){//纯数字，直接转换
			startStr = str;
			//格式化开始日期
			start = fullDayFormat.parse(startStr);
		}else{//需要处理的
			String splitStr = str.substring(4, 5);
			//第五位是汉字，则替换成.分隔符
			if(splitStr.matches("[\u4e00-\u9fa5]")){
				str =  str.replaceAll("[\u4e00-\u9fa5]", ".");
				splitStr = str.substring(4, 5);
			}
			if(splitStr.matches("[0-9]")){//第五位不是分隔符，20170117-18
				startStr =  str.substring(0, 8);
			}else{//第五位是分隔符的
				if(".".equals(splitStr)){
					splitStr = "\\.";
				}
				//先以分隔符分割
				String[] arr = str.split(splitStr);
				//1.拼接年
				startStr = arr[0];
				
				//只有年度，则拼接上1月1日
				if(arr.length==1){
					startStr += "0101";
				}else{
					//月份里包含汉字时
					if(arr[1].matches(".*[\u4e00-\u9fa5].*")){
						arr[1] = arr[1].replaceAll("[\u4e00-\u9fa5]", "");
					}
					//月份为一位时前面补零
					if(arr[1].length()==1){
						startStr += "0";
					}
					//2.拼接月份
					startStr += arr[1];
					//3.拼接天
					if(arr.length==2){//没有具体的天，默认为1号
						startStr += "01";
					}else{
						if(arr[2].length()==1){//日期为一位时前面补零
							startStr += "0";
						}else if(arr[2].length()>2){//日期大于两位时截取
							String dayStr = arr[2].substring(0, 2);
							if(dayStr.matches("[0-9]{1,}")){//前两位均为数字，则直接替换
								arr[2] = dayStr;
							}else{//只截取第一位，并在前面补零
								startStr += "0";
								arr[2] = arr[2].substring(0, 1);
							}
						}
						startStr += arr[2];
					}
				}
				
			}
			//格式化开始日期
			start = fullDayFormat.parse(startStr);
			//处理结束日期字符串,有空格，汉字，括号，长度小于10位，-分隔后的数组只有一个内容
			if(str.matches(".*\\s.*") || str.matches(".*[\u4e00-\u9fa5].*") 
					|| str.matches(".*\\(.*") || str.matches(".*\\（.*")
					|| str.length()<=9 || str.split("-").length==1 ){
				end = start;//无法处理的，直接取开始日期
			}else{
				String s = str.split("-")[1];//后半部分2016.7.22-15:00-16:40
				if(s.length()==0){//没有结束日期，则不处理
					end = start;
				}else if(s.indexOf(":")==1 || s.indexOf(":")==2){//后面只包含时间，没有日期
					end = start;
				}else{//存在结束日期的字符
					String[] arr = s.split("\\.");//以。分隔
					String endStr = null;
					if(arr.length==1){//不包含.分隔符
						if(s.length()<=2){//不包含月份，把开始日期的年月作为结束的
							endStr = startStr.substring(0, 6);
							if(s.length()==1){//天数为一位时前面补零
								endStr += "0";
							}
							endStr += s;
						}else if(s.length()==4){
							endStr = startStr.substring(0, 4) + s;
						}else{
							endStr = s;
						}
					}else if(arr.length==2){//不包含年份、
						endStr = str.substring(0, 4);
						if(arr[0].length()==1){//月份为一位时前面补零
							endStr += "0";
						}
						endStr += arr[0];
						if(arr[1].length()==1){//没有具体的天，默认为1号
							endStr += "0";
						}
						endStr += arr[1];
					}else{//包含年月日
						endStr = arr[0];
						if(arr[1].length()==1){//月份为一位时前面补零
							endStr += "0";
						}
						endStr += arr[1];
						if(arr[2].length()==1){//没有具体的天，默认为1号
							endStr += "0";
						}
						endStr += arr[2];
					}
					end = fullDayFormat.parse(endStr);
				}
			}
		}
		Date[] arr = {start, end};
		return arr;
	}
}
