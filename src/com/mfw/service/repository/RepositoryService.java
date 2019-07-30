package com.mfw.service.repository;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

/**
 * 知识库管理Service
 * @author  作者  蒋世平
 * @date 创建时间：2016年8月27日 下午14:52:12
 */
@Service("repositoryService")
public class RepositoryService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;

	@SuppressWarnings("unchecked")
	public List<PageData> list(Page page) throws Exception{
		return (List<PageData>)dao.findForList("repositoryMapper.listPage", page);
	}

	public void save(PageData pd) throws Exception {
		dao.save("repositoryMapper.save", pd);
	}

	public PageData findById(PageData pd) throws Exception {
		return (PageData)dao.findForObject("repositoryMapper.findById", pd);
	}

	public void edit(PageData pd) throws Exception {
		dao.update("repositoryMapper.edit", pd);
		
	}

	public void delete(PageData pd) throws Exception {
		dao.update("repositoryMapper.delete", pd);
		
	}
	
	/**
	 * 批量保存
	 */
	public void batchSaveIssued(List<PageData> list) throws Exception {
		dao.save("repositoryMapper.batchSaveIssued", list);
	}
	
	/**
	 * 批量保存共享文件
	 */
	public void batchSaveShare(List<PageData> list) throws Exception {
		dao.save("repositoryMapper.batchSaveShare", list);
	}
	
	public void saveIssued(PageData pd) throws Exception {
		//判断是否已经存在，已经存在的不再增加
		if(!hasExist(pd)){
			dao.save("repositoryMapper.saveIssued", pd);
		}
	}
	
	public Boolean hasExist(PageData pd) throws Exception {
		Integer count = (Integer) dao.findForObject("repositoryMapper.hasExist", pd);
		if(count == 1)
			return true;
		return false;
	}
	
	public void deleteIssued(PageData pd) throws Exception {
		dao.update("repositoryMapper.deleteIssued", pd);
		
	}
	
	/**
	 * 删除共享的部门
	 */
	public void deleteShareDept(PageData pd) throws Exception {
		dao.update("repositoryMapper.deleteShareDept", pd);
		
	}
	
	public void deleteIssuedExceptOp(PageData pd) throws Exception {
		dao.update("repositoryMapper.deleteIssuedExceptOp", pd);
		
	}
	
	public PageData findIssuedById(PageData pd) throws Exception{
		return (PageData)dao.findForObject("repositoryMapper.findIssuedById", pd);
	}
	
	public List<PageData> findIssuedByDocId(PageData pd) throws Exception{
		return (List<PageData>)dao.findForList("repositoryMapper.findIssuedByDocId", pd);
	}
	
	/**
	 * 查找文件共享的部门列表
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findSharedDeptByDocId(PageData pd) throws Exception{
		return (List<PageData>)dao.findForList("repositoryMapper.findSharedDeptByDocId", pd);
	}
	
	public void updateIssued(PageData pd) throws Exception{
		dao.update("repositoryMapper.updateIssued", pd);
	}
	
	public List<PageData> findIssuedOpinions(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("repositoryMapper.findIssuedOpinions", pd);
	}
	
	public List<PageData> listByDeptId(Page page) throws Exception{
		return (List<PageData>) dao.findForList("repositoryMapper.findByDeptIdlistPage", page);
	}
}
