package com.mfw.service.reform;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.util.Logger;
import com.mfw.util.PageData;

/**
 * 基础数据列表Service
 * @author  作者  蒋世平
 * @date 创建时间：2017年7月5日 下午15:12:53
 */
@Service("baseDataReformService")
public class BaseDataReformService {
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Resource(name="daoSupport")
	private DaoSupport dao;

	/**
	 * 查询所有可用的产品
	 * 可传入参数 productType 用来过滤产品类型
	 */
	public List<PageData> findAllProduct(PageData pd) throws Exception{
		return findProductList(pd);
	}
	
	/**
	 * 从数据库查询所有可用的产品
	 * 可传入参数 productType 用来过滤产品类型
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findProductList(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("BaseDataReformMapper.findProductList", pd);
	}
	
	/**
	 * 查询部门员工列表
	 * @return
	 */
	public JSONObject findEmployeeWithDept(){
		Map<String, Object> dataMap = new HashMap<String, Object>();
		try {
			List<PageData> deptList = new ArrayList<PageData>();
			//先获取部门
			deptList = findDeptList();
			List<PageData> employeeList = new ArrayList<PageData>();
			//再去获取部门下的员工
			for(PageData dept : deptList){
				employeeList.addAll(findEmpListByDeptId(Integer.valueOf(dept.get("ID").toString())));
			}
			deptList.addAll(employeeList);
			
			dataMap.put("result", deptList);
		} catch (Exception e) {
			logger.error("查询部门员工列表出错", e);
			dataMap.put("errorMsg", "查询部门员工列表出错");
		}
		JSONObject json = JSONObject.fromObject(dataMap);
		return json;
	}
	
	/**
	 * 从数据库查询部门列表
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findDeptList() throws Exception{
		return (List<PageData>) dao.findForList("BaseDataReformMapper.findDeptList", null);
	}
	
	/**
	 * 从数据库查询部门下的员工
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findEmpListByDeptId(Integer id) throws Exception{
		return (List<PageData>) dao.findForList("BaseDataReformMapper.findEmpListByDeptId", id);
	}
	
	/**
	 * 查询单位列表
	 */
	public List<PageData> findAllUnit() throws Exception{
		return findUnitList();
	}
	
	/**
	 * 从数据库查询单位
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findUnitList() throws Exception{
		return (List<PageData>) dao.findForList("BaseDataReformMapper.findUnitList", null);
	}
} 
