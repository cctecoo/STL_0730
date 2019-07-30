/**
 * 
 */
package com.mfw.service.bdata;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

/**
 * bd_kpi_category_files表Service
 * @author  作者  蒋世平
 * @date 创建时间：2015年12月16日 上午10:51:20
 */
@Service("kpiCategoryService")
public class KpiCategoryFilesService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;

	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("KpiCategoryMapper.save", pd);
	}
	
	/*
	 * 新增次级
	 */
	public void saveSec(PageData pd) throws Exception {
		dao.save("KpiCategoryMapper.saveSec", pd);
	}

	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		dao.delete("KpiCategoryMapper.delete", pd);
	}

	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		dao.update("KpiCategoryMapper.edit", pd);
	}

	/*
	 * 列表
	 */
	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>) dao.findForList("KpiCategoryMapper.datalistPage", page);
	}

	/*
	 * 列表(全部)
	 */
	public List<PageData> listAll(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("KpiCategoryMapper.listAll", pd);
	}
	
	/*
	 * 列表(无参全部)
	 */
	public List<PageData> listAlln() throws Exception {
		return (List<PageData>) dao.findForList("KpiCategoryMapper.listAlln", null);
	}

	/*
	 * 通过id获取数据
	 */
	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("KpiCategoryMapper.findById", pd);
	}
	
	/*
	 * 通过ParentId获取数据（上级名称）
	 */
	public PageData findByParentIdName(PageData pd) throws Exception {
		return (PageData) dao.findForObject("KpiCategoryMapper.findByParentIdName", pd);
	}
	
	/*
	 * 通过id获取数据（上级名称）
	 */
	public PageData findByIdName(PageData pd) throws Exception {
		return (PageData) dao.findForObject("KpiCategoryMapper.findByIdName", pd);
	}

	/*
	 * 通过code获取数据
	 */
	public PageData findByCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("KpiCategoryMapper.findByCode", pd);
	}
	
	/*
	 * 批量删除
	 */
	public void deleteAll(String[] ArrayDATA_IDS) throws Exception {
		dao.delete("KpiCategoryMapper.deleteAll", ArrayDATA_IDS);
	}

	/*
	 * 批量获取
	 */
	public List<PageData> getAllById(String[] ArrayDATA_IDS) throws Exception {
		return (List<PageData>) dao.findForList("KpiCategoryMapper.getAllById", ArrayDATA_IDS);
	}

	/*
	 * 删除科目
	 */
	public void delTp(PageData pd) throws Exception {
		dao.update("KpiCategoryMapper.delTp", pd);
	}

	public PageData findByName(PageData pd) throws Exception  {
		return (PageData) dao.findForObject("KpiCategoryMapper.findByName", pd);
	}
	
	/**
	 *  批量删除由考核模板导入的数据 
	 */
	public void deleteByImportModel(String importCode) throws Exception{
		dao.delete("KpiCategoryMapper.deleteByImportModel", importCode);
	}
}
