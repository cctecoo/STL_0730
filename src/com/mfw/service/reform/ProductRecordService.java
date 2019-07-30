package com.mfw.service.reform;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.entity.system.UserLog;
import com.mfw.service.system.UserLogService;
import com.mfw.util.Const;
import com.mfw.util.Logger;
import com.mfw.util.PageData;

/**
 * 产品记录Service
 * @author  作者  蒋世平
 * @date 创建时间：2017年7月5日 下午16:32:12
 */
@Service("productRecordService")
public class ProductRecordService {

	private Logger logger = Logger.getLogger(this.getClass());
	
	@Resource(name="daoSupport")
	private DaoSupport dao;
	
	@Resource(name = "userLogService")
    private UserLogService userLogService;
	
	/**
	 * 保存产品记录
	 */
	public String saveProductRecord(PageData pd, User user){
		try {
			pd.put("createEmpName", user.getNAME());
			pd.put("createUsername", user.getUSERNAME());
			if(pd.getString("id").isEmpty()){//新增
				insertProductRecord(pd);
			}else{//编辑
				updateProductRecord(pd);
				//对于记录已经提交的，再次修改时，需要保存记录
				String isRecordCommited = pd.getString("isRecordCommited");
				if(Const.SYS_STATUS_YW_YSX.equals(isRecordCommited)){
					 userLogService.logInfo(new UserLog(user.getUSER_ID()
	                            , UserLog.LogType.update, "产品记录-产品入库", "修改产品合格状态-"+pd.getString("productStatusName")));//操作日志入库
				}
			}
			
			return "success";
		} catch (Exception e) {
			logger.error("保存产品记录出错", e);
			return "error";
		}
	}
	
	/**
	 * 保存产品记录到数据库
	 */
	private void insertProductRecord(PageData pd) throws Exception{
		dao.save("ProductRecordMapper.insertProductRecord", pd);
	}
	
	/**
	 * 编辑产品记录
	 */
	private void updateProductRecord(PageData pd) throws Exception{
		dao.update("ProductRecordMapper.updateProductRecord", pd);
	}
	
	/**
	 * 更新产品记录状态
	 */
	private void updateRecordStatus(Integer recordId, String status, String userName) throws Exception{
		PageData pd = new PageData();
		pd.put("id", recordId);
		pd.put("recordStatus", status);
		pd.put("username", userName);
		dao.update("ProductRecordMapper.updateRecordStatus", pd);
	}
	
	/**
	 * 删除记录,状态置为已作废
	 */
	public void deleteProductRecord(Integer recordId, User user) throws Exception{
		updateRecordStatus(recordId, Const.SYS_STATUS_YW_YZF, user.getUSERNAME());
	}
	
	/**
	 * 提交记录,状态置为已生效
	 */
	public void submitProductRecord(Integer recordId, User user) throws Exception{
		updateRecordStatus(recordId, Const.SYS_STATUS_YW_YSX, user.getUSERNAME());
	}
	
	/**
	 * 更新在产记录的计划状态 
	 */
	private void updateRecordPlanStatus(Integer recordId, String status, String userName) throws Exception{
		PageData pd = new PageData();
		pd.put("id", recordId);
		pd.put("planStatus", status);
		pd.put("username", userName);
		dao.update("ProductRecordMapper.updateRecordPlanStatus", pd);
	}
	
	/**
	 * 更新产品记录状态
	 */
	public void resetProductRecord(Integer recordId, String resetType, User user) throws Exception{
		if("reject".equals(resetType)){//退回提交的记录,状态置为草稿
			updateRecordStatus(recordId, Const.SYS_STATUS_YW_CG, user.getUSERNAME());
		}else if("finishProduce".equals(resetType)){//更新在产记录，为已完成状态
			updateRecordPlanStatus(recordId, "已完成", user.getUSERNAME());
		}
	}
	
	/**
	 * 根据ID查询产品记录
	 */
	public PageData findProductRecord(Integer id) throws Exception{
		return findProductRecordById(id);
	}
	
	/**
	 * 根据ID查询产品记录
	 */
	private PageData findProductRecordById(Integer id) throws Exception{
		return (PageData) dao.findForObject("ProductRecordMapper.findProductRecordById", id);
	}
	
	/**
	 * 返回产品记录
	 */
	public List<PageData> findProductList(Page page) throws Exception{
		PageData pd = page.getPd();
		//加载类型为上月入库时，替换查询参数
		String recordType = pd.getString("recordType");
		if(Const.CONFIG_PAGE_PRODUCT_RECORD_LASTMONTHINSTORE.equals(recordType)){
			pd.put("queryMonth", getLastMonth(pd.getString("queryMonth")));
			pd.put("recordType", Const.CONFIG_PAGE_PRODUCT_RECORD_INSTORE);
		}
		return findProductRecordlistPage(page);
	}
	
	
	/**
	 * 从数据库查询产品记录
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findProductRecordlistPage(Page page) throws Exception{
		return (List<PageData>) dao.findForList("ProductRecordMapper.findProductRecordlistPage", page);
	}
	
	/**
	 * 返回上一月的字符串
	 */
	private String getLastMonth(String month){
		String d = null;
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM");
			Calendar cal = Calendar.getInstance();
			cal.setTime(sdf.parse(month));
			cal.add(Calendar.MONTH, -1);
			d = sdf.format(cal.getTime());
		} catch (ParseException e) {
			logger.error("转换日期出错", e);
		}
		
		return d;
	}
	
	/**
	 * 按照销售产品的大类进行统计
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> summaryRecordAmount(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("ProductRecordMapper.summaryRecordAmount", pd);
	}
	
	/**
	 * 汇总大系产品记录，相同大类的汇总情况拼接在一起
	 */
	public JSONObject summaryRecordAmountByParentProduct(PageData pd){
		Map<String, Object> dataMap = new HashMap<String, Object>();
		Object queryMonth = pd.get("queryMonth");
		if(null == queryMonth || queryMonth.toString().isEmpty()){
			dataMap.put("errorMsg", "没有传入查询的月份");
		}else{
			try {
				//以记录类型分组进行查询当月记录
				List<PageData> list = summaryRecordAmount(pd);
				
				//查询当月及上月合格入库量（产品状态为合格、入库日期为本月的入库记录）
				pd.put("queryMonth", queryMonth.toString());
				pd.put("recordType", Const.CONFIG_PAGE_PRODUCT_RECORD_INSTORE);
				pd.put("isFindInStore", true);
				List<PageData> lastMonthInStoreList = summaryRecordAmount(pd);
				for(PageData record : lastMonthInStoreList){
					if(queryMonth.equals(record.getString("INSTORE_MONTH"))){
						record.put("RECORD_TYPE", Const.CONFIG_PAGE_PRODUCT_RECORD_CURRENT_MONTH_INSTORE);
						record.put("RECORD_TYPE_NAME", "本月合格入库");
					}else{
						record.put("RECORD_TYPE", Const.CONFIG_PAGE_PRODUCT_RECORD_LASTMONTHINSTORE);
						record.put("RECORD_TYPE_NAME", "上月合格入库");
					}
				}
				list.addAll(lastMonthInStoreList);
				
				//处理以记录类型和产品大类分组的返回结果
//				dataMap.put("summaryMap", converToMap(list, "PARENT_PRODUCT_CODE"));
				if(list.size()>0){
					dataMap.put("summaryMap", getSummaryRecords(list));
				}
				
				dataMap.put("queryMonth", queryMonth);
				dataMap.put("moneyBaseUnitName", pd.get("moneyBaseUnitName"));
				dataMap.put("weightBaseUnitName", pd.get("weightBaseUnitName"));
			} catch (Exception e) {
				logger.error("查询大系产品记录汇总-出错", e);
				dataMap.put("errorMsg", "查询大系产品记录汇总出错");
			}
		} 
		JSONObject json = JSONObject.fromObject(dataMap);
		return json;
	}
	
//	/**
//	 * 把返回的记录汇总，按照产品系列进行合并
//	 */
//	private Map<String, List<PageData>> converToMap(List<PageData> list, String group){
//		//处理返回结果
//		Map<String, List<PageData>> summaryMap = new HashMap<String, List<PageData>>();
//		for(PageData summary : list){
//			String code = summary.getString(group);
//			if(null == code || code.isEmpty()){//没有关联大类产品的，显示未分类
//				code = "noParentCode";
//				summary.put("PARENT_PRODUCT_NAME", "未分类");
//			}
//			if(summaryMap.containsKey(code)){//产品分类存在的则添加新的记录进去
//				summaryMap.get(code).add(summary);
//			}else{//第一次出现的产品分类，创建集合保存记录
//				List<PageData> sameParentList = new ArrayList<PageData>();
//				sameParentList.add(summary);
//				summaryMap.put(code, sameParentList);
//			}
//		}
//		return summaryMap;
//	}
	
	/**
	 * 处理查询到的记录，按照产品大类统计汇总
	 */
	private Map<String, Map<String, PageData>> getSummaryRecords(List<PageData> list){
		//处理返回结果
		Map<String, Map<String, PageData>> summaryMap = new HashMap<String, Map<String, PageData>>();
		for(PageData summary : list){
			String code = summary.getString("PARENT_PRODUCT_CODE");
			if(null == code || code.isEmpty()){//没有关联大类产品的，显示未分类
				code = "noParentCode";
				summary.put("PARENT_PRODUCT_NAME", "未分类");
			}
			if(summaryMap.containsKey(code)){//产品分类存在的则添加新的记录进去
				summaryMap.get(code).put(summary.getString("RECORD_TYPE"), summary);
			}else{//第一次出现的产品分类，创建集合保存记录
				Map<String, PageData> parentRecord = new HashMap<String, PageData>();
				PageData parentPd =new PageData();
				parentPd.put("PARENT_PRODUCT_NAME", summary.getString("PARENT_PRODUCT_NAME"));
				parentPd.put("PARENT_PRODUCT_CODE", code);
				parentRecord.put(summary.getString("RECORD_TYPE"), summary);
				parentRecord.put("parentPd", parentPd);
				summaryMap.put(code, parentRecord);
			}
		}
		return summaryMap;
	}
	
	/**
	 * 从数据库汇总同一大类下的产品记录
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> summaryRecordByParentProduct(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("ProductRecordMapper.summaryRecordByParentProduct", pd);
	}

	/**
	 * 返回同一大类下的子产品的汇总记录
	 */
	public JSONObject findProductRecordSummary(PageData pd){
		Map<String, Object> dataMap = new HashMap<String, Object>();
		Object queryMonth = pd.get("queryMonth");
		if(null == queryMonth || queryMonth.toString().isEmpty()){
			dataMap.put("errorMsg", "没有传入查询的月份");
		}else{
			try {
				//查询各项产品记录
				pd.put("recordTypes", findProductRecordTypes());
				List<PageData> list = summaryRecordByParentProduct(pd);

				//查询当月及上月合格入库量（产品状态为合格、入库日期为本月的入库记录）
				List<String> typeList = new ArrayList<String>();
				typeList.add(Const.CONFIG_PAGE_PRODUCT_RECORD_INSTORE);
				pd.put("recordTypes", typeList);
				pd.put("queryMonth", queryMonth.toString());
				pd.put("isFindInStore", true);
				List<PageData> lastMonthInStoreList = summaryRecordByParentProduct(pd);
				for(PageData record : lastMonthInStoreList){
					if(queryMonth.equals(record.getString("INSTORE_MONTH"))){
						record.put("RECORD_TYPE", Const.CONFIG_PAGE_PRODUCT_RECORD_CURRENT_MONTH_INSTORE);
						record.put("RECORD_TYPE_NAME", "本月合格入库");
					}else{
						record.put("RECORD_TYPE", Const.CONFIG_PAGE_PRODUCT_RECORD_LASTMONTHINSTORE);
						record.put("RECORD_TYPE_NAME", "上月合格入库");
					}
				}
				list.addAll(lastMonthInStoreList);
				//处理未分类的
				if(list.size()>0){
					String group = "RECORD_PRODUCT_CODE";
					//页面传递的‘产品大类’不为空时，以产品大类分组
					if(null != pd.get("parentProductCode") && !pd.getString("parentProductCode").isEmpty()){
						group = "RELATE_PRODUCT_CODE";
					}
					//dataMap.put("summaryMap", converChildToMap(list, group, "RECORD_PRODUCT_CODE"));
					Map<String, Map<String, PageData>> summaryMap = getProductRecords(list, group, "RECORD_PRODUCT_CODE");
					dataMap.put("summaryMap", summaryMap);
				}
				
				//dataMap.put("result", list);
			} catch (Exception e) {
				logger.error("查询同一大类下的汇总记录-出错", e);
				dataMap.put("errorMsg", "查询同一大类下的汇总记录出错");
			}
		} 
		JSONObject json = JSONObject.fromObject(dataMap);
		return json;
	}
	
	/**
	 * 处理查询到的结果，以产品进行统计合并
	 */
	private Map<String, Map<String, PageData>> getProductRecords(List<PageData> list, String group, String childGroup){
		//处理返回结果,用于存放以关联产品分组的记录
		Map<String, Map<String, PageData>> summaryMap = new HashMap<String, Map<String, PageData>>();
		
		for(PageData summary : list){
			String code = summary.getString(group);//获取关联产品编码
			String childCode = summary.getString(childGroup);//获取产品记录关联的产品编码
			if(null == code || code.isEmpty()){//记录没有关联大类产品的，显示未分类
				code = "noParentCode";
				summary.put("PARENT_PRODUCT_NAME", "未分类");
			}
			if(summaryMap.containsKey(childCode)){//产品存在的则添加新的记录进去
				summaryMap.get(childCode).put(summary.getString("RECORD_TYPE"), summary);
			}else{//第一次出现的产品，保存记录
				Map<String, PageData> childMap = new HashMap<String, PageData>();
				//存入关联的产品名称和编码
				PageData parentPd = new PageData();
				parentPd.put("RECORD_PRODUCT_NAME", summary.getString("RECORD_PRODUCT_NAME"));
				parentPd.put("RECORD_PRODUCT_CODE", childCode);
				parentPd.put("parentProductCode", code);
				childMap.put("parentPd", parentPd);
				//存入当前循环的记录
				childMap.put(summary.getString("RECORD_TYPE"), summary);
				summaryMap.put(childCode, childMap);//以产品编码存放
			}
		}
		return summaryMap;
	}
//	
//	/**
//	 * 查询到的结果，以产品进行分类汇总
//	 */
//	private Map<String, Map<String, List<PageData>>> converChildToMap(List<PageData> list, String group, String childGroup){
//		//处理返回结果,用于存放以关联产品分组的记录
//		Map<String, Map<String, List<PageData>>> summaryMap = new HashMap<String, Map<String, List<PageData>>>();
//		
//		for(PageData summary : list){
//			String code = summary.getString(group);//获取关联产品编码
//			String childCode = summary.getString(childGroup);//获取产品记录关联的产品编码
//			if(null == code || code.isEmpty()){//记录没有关联大类产品的，显示未分类
//				code = "noParentCode";
//				summary.put("PARENT_PRODUCT_NAME", "未分类");
//			}
//			if(summaryMap.containsKey(code)){//产品分类存在的则添加新的记录进去
//				Map<String, List<PageData>> childMap = summaryMap.get(code);
//				if(childMap.containsKey(childCode)){
//					childMap.get(childCode).add(summary);
//				}else{
//					List<PageData> childList = new ArrayList<PageData>();
//					childList.add(summary);
//					childMap.put(childCode, childList);
//				};
//			}else{//第一次出现的产品分类，创建集合保存记录
//				//childMap,用于存放某一产品的的不同类型记录，比如A产品的出货记录，入库记录等
//				Map<String, List<PageData>> childMap = new HashMap<String, List<PageData>>();
//				List<PageData> childList = new ArrayList<PageData>();
//				childList.add(summary);
//				
//				childMap.put(childCode, childList);
//				summaryMap.put(code, childMap);//以产品编码存放
//			}
//		}
//		return summaryMap;
//	}

	
//	/**
//	 * 汇总大系产品记录
//	 */
//	public JSONObject findParentProductRecordSummary(PageData pd){
//		Map<String, Object> dataMap = new HashMap<String, Object>();
//		Object queryMonth = pd.get("queryMonth");
//		if(null == queryMonth || queryMonth.toString().isEmpty()){
//			dataMap.put("errorMsg", "没有传入查询的月份");
//		}else{
//			try {
//				List<PageData> list = summaryParentProductRecord(pd);
//				dataMap.put("result", list);
//				dataMap.put("queryMonth", queryMonth);
//				dataMap.put("moneyBaseUnitName", pd.get("moneyBaseUnitName"));
//				dataMap.put("weightBaseUnitName", pd.get("weightBaseUnitName"));
//			} catch (Exception e) {
//				logger.error("查询大系产品记录汇总-出错", e);
//				dataMap.put("errorMsg", "查询大系产品记录汇总出错");
//			}
//		} 
//		JSONObject json = JSONObject.fromObject(dataMap);
//		return json;
//	}
//	
//	/**
//	 * 汇总子产品记录
//	 */
//	public JSONObject findChildProductRecordSummary(PageData pd){
//		Map<String, Object> dataMap = new HashMap<String, Object>();
//		Object queryMonth = pd.get("queryMonth");
//		if(null == queryMonth || queryMonth.toString().isEmpty()){
//			dataMap.put("errorMsg", "没有传入查询的月份");
//		}else{
//			try {
//				List<PageData> list = summaryChildProductRecord(pd);
//				dataMap.put("result", list);
//			} catch (Exception e) {
//				logger.error("查询子产品记录汇总-出错", e);
//				dataMap.put("errorMsg", "查询子产品记录汇总出错");
//			}
//		} 
//		JSONObject json = JSONObject.fromObject(dataMap);
//		return json;
//	}
//	
//	/**
//	 * 从数据库汇总子产品记录
//	 */
//	@SuppressWarnings("unchecked")
//	private List<PageData> summaryChildProductRecord(PageData pd) throws Exception{
//		return (List<PageData>) dao.findForList("ProductRecordMapper.summaryChildProductRecord", pd);
//	}
//	
//	/**
//	 * 汇总产品大系记录
//	 */
//	@SuppressWarnings("unchecked")
//	private List<PageData> summaryParentProductRecord(PageData pd) throws Exception{
//		return (List<PageData>) dao.findForList("ProductRecordMapper.summaryParentProductRecord", pd);
//	}
	
	/**
	 * 返回产品记录的类型
	 */
	public List<PageData> findRecordTypeList(){
		List<PageData> list = new ArrayList<PageData>();
		list.add(getRecordType("XSH", Const.CONFIG_PAGE_PRODUCT_RECORD_SALEPLAN, "月销售计划"));
		list.add(getRecordType("XSH", Const.CONFIG_PAGE_PRODUCT_RECORD_ACTUALSALE, "实际发货"));
		list.add(getRecordType("SHCH", Const.CONFIG_PAGE_PRODUCT_RECORD_PRODUCEPLAN, "月生产计划"));
		list.add(getRecordType("SHCH", Const.CONFIG_PAGE_PRODUCT_RECORD_ACTUALPRODUCE, "在产产量"));
		list.add(getRecordType("", Const.CONFIG_PAGE_PRODUCT_RECORD_INSTORE, "产品入库"));
		list.add(getRecordType("", Const.CONFIG_PAGE_PRODUCT_RECORD_SAFESTOREAMOUNT, "安全库存"));
		list.add(getRecordType("", Const.CONFIG_PAGE_PRODUCT_RECORD_LASTMONTH_REMAIN, "上月留存"));
		list.add(getRecordType("", Const.CONFIG_PAGE_PRODUCT_RECORD_NOTSALE_OUTPUT, "非销售出库"));
		return list;
	}
	
	private PageData getRecordType(String relateProductType, String recordTypeCode, String recordTypeName){
		PageData pd = new PageData();
		pd.put("relateProductType", relateProductType);
		pd.put("recordTypeCode", recordTypeCode);
		pd.put("recordTypeName", recordTypeName);
		return pd;
	}
	
	/**
	 * 获取记录类型列表
	 */
	public List<String> findProductRecordTypes(){
		//获取记录类型列表
		List<String> showPages = new ArrayList<String>();
		List<PageData> recordTypeList = findRecordTypeList();
		for(int i=0; i<recordTypeList.size(); i++){
			showPages.add(recordTypeList.get(i).getString("recordTypeCode"));
		}
		
		return showPages;
	}
}
