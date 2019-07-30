package com.mfw.service.bdata;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.controller.base.BaseService;
import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.system.UserLog;
import com.mfw.entity.system.UserLog.LogType;
import com.mfw.util.PageData;

/**
 * 岗位管理Service
 * @author  作者  蒋世平
 * @date 创建时间：2016年5月8日 下午17:51:37
 */
@Service("positionLevelService")
public class PositionLevelService extends BaseService{
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	public List<PageData> listAll(Page page) throws Exception {
		return (List<PageData>)dao.findForList("PositionLevelMapper.listPage", page);
	}

	/**
	 * 查询所有职位，不分页
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAll() throws Exception{
		return (List<PageData>)dao.findForList("PositionLevelMapper.findAll", null);
	}
	
	public void add(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		dao.findForList("PositionLevelMapper.insertSelective", pd);
	}

	public PageData findById(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return (PageData) dao.findForObject("PositionLevelMapper.findObjectById", pd);
	}

	public PageData edit(PageData pd) throws Exception {
		userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"岗位", "编辑，id："+ pd.toString()));
		return (PageData) dao.findForObject("PositionLevelMapper.updateByPrimaryKeySelective", pd);
	}

	public void delete(PageData pd) throws Exception {
		userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.delete, 
				"岗位", "删除，id："+ pd.get("id").toString()));
		dao.delete("PositionLevelMapper.deleteByPrimaryKey", pd);
	}

	public void deleteAll(String[] ArrayDATA_IDS) throws Exception {
		userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"岗位", "批量删除，id："+ArrayDATA_IDS.toString()));
		dao.delete("PositionLevelMapper.deleteAll", ArrayDATA_IDS);
	}

	public int checkCode(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		Map result = (Map)dao.findForObject("PositionLevelMapper.checkCodeByGradeCode", pd);
		if(result.size()>0){
			count = Integer.parseInt(result.get("SL").toString());
		}
		return count;
	}
	
	public List<PageData> findLevelByDeptId(String deptId) throws Exception {
		return (List<PageData>)dao.findForList("PositionLevelMapper.findLevelByDeptId", deptId);
	}
	
	public PageData findById2(String pd) throws Exception {
		return (PageData) dao.findForObject("PositionLevelMapper.findById", pd);
	}
	
	/**
	 * 根据岗位标识获取ID
	 * @param GRADE_CODE
	 * @return
	 * @throws Exception
	 * 修改时间		修改人		修改内容
	 * 2016-03-28	李伟涛		新增
	 */
	@SuppressWarnings("unchecked")
	public String findIdByCode(String GRADE_CODE) throws Exception{
		List<String> queryList = (List<String>) dao.findForList("PositionLevelMapper.findIdByCode", GRADE_CODE);
		String result = null;
		if(queryList.size() > 0){
			result = queryList.get(0);
		}
		return result;
	}
	
	/**
	 * 根据岗位名称获取岗位ID
	 * @param positionNsame
	 * @return
	 * @throws Exception
	 */
	public Integer findIdByName(String positionNsame) throws Exception{
		return (Integer) dao.findForObject("PositionLevelMapper.findIdByName", positionNsame);
	}

	/**
	 * 根据部门ID获取岗位
	 * @param deptIds
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findPositionByDeptId(String deptIds) throws Exception {
		String[] ids = deptIds.split(",");
		return (List<PageData>) dao.findForList("PositionLevelMapper.findPositionByDeptId", ids);
	}
	
	/**
	 * 根据岗位名称获取某个部门的岗位ID
	 */
	public Integer findIdByPosNameAndDept(PageData pd) throws Exception{
		return (Integer) dao.findForObject("PositionLevelMapper.findIdByPosNameAndDept", pd);
	}
	
	/**
	 * 通过部门id查找岗位，形成组织岗位树
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findPositionTreeByDeptId(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("PositionLevelMapper.findPositionTreeByDeptId", pd);
	}
	
	/**
	 * 判断职位是否该组织结构（部门下的）
	 */
	public boolean isExistPositionInDept(String posId, String deptId){
		PageData pd = new PageData();
		pd.put("posId", posId);
		pd.put("deptId", deptId);
		try {
			PageData result = (PageData) dao.findForObject("PositionLevelMapper.findPositionLevelByDeptIdAndPosId", pd);
			if(null != result){
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
}
