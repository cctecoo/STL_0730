/**
 * 
 */
package com.mfw.service.bdata;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.system.User;
import com.mfw.util.PageData;

/**
 * bd_positions表Service
 * @author  作者  杨声涛
 * @date 创建时间：2016年5月13日 下午17:12:35
 */
@Service("positionDutyService")
public class PositionDutyService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;

	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("PositionDutyMapper.save", pd);
	}
	

	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		dao.delete("PositionDutyMapper.delete", pd);
	}
	

	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		dao.update("PositionDutyMapper.edit", pd);
	}

	/*
	 * 列表
	 */
	public List<PageData> listDuty(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("PositionDutyMapper.listDuty", pd);
	}
	
	/*
	 * 列表
	 */
	public PageData findCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("PositionDutyMapper.findCode", pd);
	}
	
	/*
	 * 根据岗位CODE查岗位
	 */
	public PageData findDutyByCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("PositionDutyMapper.findDutyByCode", pd);
	}
	
	
	/*
	 * 根据岗位ID查询岗位CODE
	 */
	public PageData findCodeById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("PositionDutyMapper.findCodeById", pd);
	}
	/*
	 * 新增明细
	 */
	public void saveDetail(PageData pd) throws Exception {
		dao.save("PositionDutyMapper.saveDetail", pd);
	}
	

	/*
	 * 批量删除明细
	 */
	public void batchDeleteDetail(PageData pd) throws Exception {
		dao.delete("PositionDutyMapper.batchDeleteDetail", pd);
	}
	
	/*
	 * 删除明细
	 */
	public void deleteDetail(PageData pd) throws Exception {
		dao.delete("PositionDutyMapper.deleteDetail", pd);
	}

	/*
	 * 修改 明细
	 */
	public void editDetail(PageData pd) throws Exception {
		dao.update("PositionDutyMapper.editDetail", pd);
	}

	/*
	 * 跟据ID查询岗位职责
	 */
	public PageData findById(PageData pd) throws Exception{
		return (PageData) dao.findForObject("PositionDutyMapper.findById", pd);
	}


	/*
	 * 跟据岗位ID查询明细
	 */
	public List<PageData> findDetailByPId(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("PositionDutyMapper.findDetailByPId", pd);
	}
	
	/*
	 * 跟据ID查询明细
	 */
	public PageData findDetailById(PageData pd) throws Exception{
		return (PageData) dao.findForObject("PositionDutyMapper.findDetailById", pd);
	}


	/*
	 * 查询岗位
	 */
	public List<PageData> findPosition(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("PositionDutyMapper.findPosition", pd);
	}

	/**
	 * 根据登录用户获取未收藏的岗位职业
	 * @param user
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findDutyByUser(User user) throws Exception {
		return (List<PageData>)dao.findForList("PositionDutyMapper.findDutyByUser", user.getNUMBER());
	}

	/**
	 * 根据登录用户获取常用的岗位职责
	 * @param user
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findCommonDuty(User user) throws Exception {
		return (List<PageData>)dao.findForList("PositionDutyMapper.findCommonDury", user.getNUMBER());
	}
	
	/**
	 * 检查当前日晴助手是否已收藏
	 */
	public Integer checkCollection(PageData pageData) throws Exception{
		return (Integer) dao.findForObject("PositionDutyMapper.checkCollection", pageData);
	}

	/**
	 * 收藏日清助手
	 */
	public Integer addCollection(PageData pageData) throws Exception{
		return (Integer) dao.save("PositionDutyMapper.addCollection", pageData);
	}

	/**
	 * 移除日清助手收藏
	 */
	public Integer removeCollection(PageData pageData) throws Exception{
		return (Integer) dao.delete("PositionDutyMapper.removeCollection", pageData);
	}


	/**
	 * 查询所有岗位职责
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAll() throws Exception{
		return (List<PageData>)dao.findForList("PositionDutyMapper.findAll", null);
	}


	/**
	 * 查询当前岗位下是否有某一职责
	 * @return
	 * @throws Exception
	 */
	public PageData findByRes(PageData pd) throws Exception{
		return (PageData) dao.findForObject("PositionDutyMapper.findByRes", pd);
	}


	public PageData findDetailByRes(PageData pd) throws Exception{
		return (PageData) dao.findForObject("PositionDutyMapper.findDetailByRes", pd);
	}

	/**
	 * 查询岗位所有的岗位职责明细
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAllDetailByEmpCode(String empCode) throws Exception{
		return (List<PageData>) dao.findForList("PositionDutyMapper.findAllDetailByEmpCode", empCode);
	}
	
	/**
	 * 复制岗位职责明细
	 */
	public void copyResponsibilityDetail(PageData pd) throws Exception{
		dao.save("PositionDutyMapper.copyResponsibilityDetail", pd);
	}
	
	/**
	 * 根据部门id查询岗位职责
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findPosiontionResponsibilityByDeptId(Integer deptId) throws Exception{
		return (List<PageData>) dao.findForList("PositionDutyMapper.findPosiontionResponsibilityByDeptId", deptId);
	}
	
	/**
	 * 根据部门id查询岗位职责明细
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findResponsibilityDetailByDeptId(Integer deptId) throws Exception{
		return (List<PageData>) dao.findForList("PositionDutyMapper.findResponsibilityDetailByDeptId", deptId);
	}
	
	/**
	 * 根据部门id,导出岗位职责
	 */
	public Map<String, Object> exportPositionDuty(Integer deptId) throws Exception{
		//根据部门id，查询岗位职责信息
		List<PageData> list = findPosiontionResponsibilityByDeptId(deptId);
		
		//表格的标题
		String fileTile = "岗位职责";
		//第二行标题
		List<String> titles = new ArrayList<String>();
		titles.add("部门标识");
		titles.add("部门名称");
		titles.add("岗位编码");
		titles.add("岗位名称");
		titles.add("职责");
		//数据行
		List<PageData> varList = new ArrayList<PageData>();
		for(int i=0; i<list.size(); i++){
			PageData item = list.get(i);
			PageData varPd = new PageData();
			int fieldIndex = 1;
			varPd.put("var" + fieldIndex++, item.get("DEPT_SIGN"));
			varPd.put("var" + fieldIndex++, item.get("DEPT_NAME"));
			varPd.put("var" + fieldIndex++, item.get("GRADE_CODE"));
			varPd.put("var" + fieldIndex++, item.get("GRADE_NAME"));
			varPd.put("var" + fieldIndex++, item.get("responsibility"));
			varList.add(varPd);
		}
		
		//根据部门id，查询岗位职责明细信息
		List<PageData> detailList = findResponsibilityDetailByDeptId(deptId);
		//表格的标题
		String fileTile2 = "职责详情";
		//第二行标题
		List<String> titles2 = new ArrayList<String>();
		titles2.add("岗位编码");
		titles2.add("岗位职责");
		titles2.add("职责明细");
		titles2.add("要求");
		titles2.add("频率");
		titles2.add("工作指南");
		titles2.add("参考时间");
		titles2.add("职责对象");
		//数据行
		List<PageData> varList2 = new ArrayList<PageData>();
		for(int i=0; i<detailList.size(); i++){
			PageData item = detailList.get(i);
			PageData varPd = new PageData();
			int fieldIndex = 1;
			varPd.put("var" + fieldIndex++, item.get("GRADE_CODE"));
			varPd.put("var" + fieldIndex++, item.get("responsibility"));
			varPd.put("var" + fieldIndex++, item.get("detail"));
			varPd.put("var" + fieldIndex++, item.get("requirement"));
			varPd.put("var" + fieldIndex++, item.get("frequency"));
			varPd.put("var" + fieldIndex++, item.get("guide"));
			varPd.put("var" + fieldIndex++, item.get("standard_time"));
			varPd.put("var" + fieldIndex++, item.get("target"));
			varList2.add(varPd);
		}
		
		String fileName = "岗位职责";
		if(list.size()>0){
			fileName +=  '-' + list.get(0).getString("DEPT_NAME");
		}
		
		List<String> sheetNames = new ArrayList<String>();
		sheetNames.add("岗位职责");
		sheetNames.add("职责详情");
		
		//设置创建表格的数据集合
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("sheetNames", sheetNames);
		
		dataMap.put("fileTile1", fileTile);
		dataMap.put("titles1", titles);
		dataMap.put("varList1", varList);
		
		dataMap.put("fileTile2", fileTile2);
		dataMap.put("titles2", titles2);
		dataMap.put("varList2", varList2);
		
		dataMap.put("filename", fileName);
		
		return dataMap;
	}
}