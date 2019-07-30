package com.mfw.service.bdata;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.util.PageData;

/**
 * bd_kpi_model表Service
 * @author  作者  蒋世平
 * @date 创建时间：2015年12月22日 上午11:41:18
 */
@Service("kpiModelService")
public class KpiModelService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	@Resource(name="kpiModelLineService")
	private KpiModelLineService kpiModelLineService;
	@Resource(name = "kpiFilesService")
	private KpiFilesService kpiFilesService;
	@Resource(name = "kpiCategoryService")
	private KpiCategoryFilesService kpiCategoryService;
	
	/*
	* 新增
	*/
	public Object save(PageData pd)throws Exception{
		return dao.save("KpiModelMapper.save", pd);
	}
	
//	/*
//	* 删除
//	*/
//	public void delete(PageData pd)throws Exception{
//		dao.delete("KpiModelMapper.delete", pd);
//	}
	
	/**
	 * 删除kpi模板
	 */
	public String deleteKpiModelById(String modelId) throws Exception{
		//先查询是否有岗位关联该模板
		String count = findPositionCountByKpiModelId(modelId);
		if("0".equals(count)){//没有关联的，可以删除
			delete(modelId);
			return "success";
		}else{//有关联的，不可删除
			return "used";
		}
	}
	
	/**
	 * 根据kpi模板id查询是否有岗位关联
	 */
	private String findPositionCountByKpiModelId(String modelId) throws Exception{
		PageData pd = (PageData) dao.findForObject("KpiModelMapper.findPositionCountByKpiModelId", modelId);
		return pd.get("COUNT").toString();
	}
	
	/*
	 * 逻辑删除
	 */
	private void delete(String modelId)throws Exception{
		dao.update("KpiModelMapper.delete", modelId);
	}
	
	/*
	* 修改
	*/
	public void edit(PageData pd)throws Exception{
		dao.update("KpiModelMapper.edit", pd);
	}
	
	/*
	*列表
	*/
	public List<PageData> list(Page page)throws Exception{
		return (List<PageData>)dao.findForList("KpiModelMapper.datalistPage", page);
	}
	
	/*
	*列表(全部)
	*/
	public List<PageData> listAll(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("KpiModelMapper.listAll", pd);
	}
	
	/*
	*列表(全部)
	*/
	public PageData listAllForCount(PageData pd)throws Exception{
		return (PageData)dao.findForObject("KpiModelMapper.listAllForCount", pd);
	}
	
	/*
	 * 查询已启用列表
	 */
	public List<PageData> listAllEnable(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("KpiModelMapper.listAllEnable", pd);
	}
	
	/*
	 *再用模板列表(全部)
	 */
	public List<PageData> listAllUsedModel(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("KpiModelMapper.listAllUsedModel", pd);
	}
	
	/*
	* 通过id获取数据
	*/
	public PageData findById(PageData pd)throws Exception{
		return (PageData)dao.findForObject("KpiModelMapper.findById", pd);
	}
	
	/*
	 * 通过id获取数据
	 */
	public PageData findById(String MODEL_ID)throws Exception{
		return (PageData)dao.findForObject("KpiModelMapper.findById", MODEL_ID);
	}
	
	/*
	* 批量删除
	*/
	public void deleteAll(String[] ArrayDATA_IDS)throws Exception{
		dao.delete("KpiModelMapper.deleteAll", ArrayDATA_IDS);
	}

	public PageData findByCode(PageData pdc)throws Exception{
		return (PageData)dao.findForObject("KpiModelMapper.findByCode", pdc);
	}
	
	/**
	 * 导入kpi模板excel
	 */
	public void importKpiModel(String kpiModelId, User user, List<PageData> listPd) throws Exception{
		
		int categoryCount = 0;
		int kpiFileCount = 0;
		PageData kpiCategoryFilePd = new PageData();
		//先删除之前关联的数据
		String importCode = "IMPORT-" + kpiModelId + "-";
		kpiCategoryService.deleteByImportModel(importCode);
		kpiFilesService.deleteKpiByImportModel(importCode);
		kpiModelLineService.deleteModelLineByImportModel(importCode, kpiModelId);
		//循环处理
		for(int i=2; i<listPd.size(); i++){
			PageData rowPd = listPd.get(i);
			String kpiCategoryName = rowPd.getString("var0");
			String kpiStandard = rowPd.getString("var1").replaceAll(",", "，");
			String kpiScore = rowPd.getString("var2");
			if(!kpiCategoryName.isEmpty()){
				kpiCategoryName = kpiCategoryName.replaceAll(",", "，");
				//先保存KPI指标库中的分类bd_kpi_category_files
				categoryCount ++;
				kpiFileCount = 0;
				kpiCategoryFilePd.put("CODE", "IMPORT-" + kpiModelId + "-" + categoryCount);
				kpiCategoryFilePd.put("NAME", kpiCategoryName);
				kpiCategoryFilePd.put("REMARKS", "考核模板导入");
				kpiCategoryService.save(kpiCategoryFilePd);
			}else{
				kpiCategoryName = kpiCategoryFilePd.getString("NAME").replaceAll(",", "，");
			}
			//保存kpi指标bd_kpi_files
			PageData kpiPd = new PageData();
			kpiFileCount ++;
			kpiPd.put("KPI_CODE", kpiCategoryFilePd.get("CODE") + "-" + kpiFileCount);
			kpiPd.put("KPI_NAME", kpiCategoryFilePd.get("NAME").toString().replaceAll(",", "，") + "-" + kpiFileCount);
			kpiPd.put("KPI_CATEGORY_ID",  kpiCategoryFilePd.get("ID"));
			kpiPd.put("KPI_CATEGORY_NAME", kpiCategoryName);
			kpiPd.put("KPI_DESCRIPTION", kpiStandard);
			kpiPd.put("PARENT_ID", 0);
			kpiPd.put("ENABLED", 1);
			kpiPd.put("CREATE_TIME", new Date());
			kpiPd.put("CREATE_USER", user.getUSERNAME());
			kpiFilesService.save(kpiPd);
			//保持kpi模板明细bd_kpi_model_line
			PageData kpiLinePd = new PageData();
			kpiLinePd.put("MODEL_ID", kpiModelId);
			kpiLinePd.put("KPI_CODE", kpiPd.get("KPI_CODE"));
			kpiLinePd.put("KPI_NAME", kpiPd.get("KPI_NAME").toString().replaceAll(",", "，"));
			kpiLinePd.put("KPI_TYPE", kpiCategoryName);
			kpiLinePd.put("CREATE_USER", user.getUSERNAME());	//创建人
			kpiLinePd.put("CREATE_TIME", new Date());
			kpiLinePd.put("KPI_DESCRIPTION", kpiStandard);//描述
			kpiLinePd.put("PREPARATION3", kpiScore);//分值
			kpiModelLineService.save(kpiLinePd);
		}
	}
}
