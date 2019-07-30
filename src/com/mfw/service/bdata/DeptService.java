package com.mfw.service.bdata;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.controller.base.BaseService;
import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.entity.system.UserLog;
import com.mfw.entity.system.UserLog.LogType;
import com.mfw.util.Const;
import com.mfw.util.PageData;

/**
 * 部门管理Service
 * @author  作者  蒋世平
 * @date 创建时间：2016年5月10日 上午11:52:09
 */
@Service("deptService")
@SuppressWarnings("unchecked")
public class DeptService extends BaseService{

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/*
	 * 获取最大编码
	 */
	public String maxCode(PageData pd) throws Exception {
		return (String)dao.findForObject("DeptMapper.maxCode", pd);
	}
	
	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("DeptMapper.save", pd);
	}

	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"部门", "删除，id："+ pd.get("ID").toString()));
		dao.delete("DeptMapper.delete", pd);
	}

	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"部门", "编辑，id："+ pd.toString()));
		pd.put("updateUser", getUser().getUSERNAME());
		dao.update("DeptMapper.edit", pd);
	}

	/*
	 * 列表
	 */
	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.datalistPage", page);
	}

	/*
	 * 列表(全部)
	 */
	public List<PageData> listAll(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.listAll", pd);
	}
	
	/*
	 * 列表(无参全部)
	 */
	public List<PageData> listAlln() throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.listAlln", null);
	}
	
	/**
	 * 根据当前登陆人的数据权限获取部门树节点
	 * @return
	 * @throws Exception
	 */
	public List<PageData> listWithAuth(User user) throws Exception{
		return (List<PageData>) dao.findForList("DeptMapper.listWithAuth", user);
	}
	
	
	/**
	 * 根据当前登陆人的数据权限获取部门及子部门下的员工
	 * @return
	 * @throws Exception
	 */
	public List<PageData> listEmpWithAuth(User user) throws Exception{
		return (List<PageData>) dao.findForList("DeptMapper.listEmpWithAuth", user);
	}

	/*
	 * 子部门列表(全部)
	 */
	public List<PageData> listChild(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.listChild", pd);
	}
	/*
	 * 获取部门人数
	 */
	public PageData getENum(PageData pd) throws Exception {
		return (PageData)dao.findForObject("DeptMapper.getENum", pd);
	}
	
	/**
	 * 获取部门岗位数
	 */
	public PageData getPositionLevelNum(PageData pd) throws Exception {
		return (PageData)dao.findForObject("DeptMapper.getPositionLevelNum", pd);
	}
	
	/*
	 * 通过id获取数据
	 */
	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("DeptMapper.findById", pd);
	}

	/*
	 * 通过标识获取ID
	 */
	public String findIdByS(PageData pd) throws Exception {
		return (String) dao.findForObject("DeptMapper.findIdByS", pd);
	}
	
	/*
	 * 批量删除
	 */
	public void deleteAll(String[] ArrayDATA_IDS) throws Exception {
		userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"部门", "批量删除，id："+ ArrayDATA_IDS.toString()));
		dao.delete("DeptMapper.deleteAll", ArrayDATA_IDS);
	}

	/*
	 * 批量获取
	 */
	public List<PageData> getAllById(String[] ArrayDATA_IDS) throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.getAllById", ArrayDATA_IDS);
	}

	/*
	 * 删除图片
	 */
	public void delTp(PageData pd) throws Exception {
		dao.update("DeptMapper.delTp", pd);
	}
	
	public List<PageData> findBudgetDeptList() throws Exception{
		
		return (List<PageData>) dao.findForList("DeptMapper.findBudgetDeptList", null);
	}
	
	public List<PageData> findForecastDeptList() throws Exception{
		
		return (List<PageData>) dao.findForList("DeptMapper.findForecastDeptList", null);
	}
	/*
	 * 验证编码和标识是否重复
	 */
	public int checkCode(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		Map result = (Map)dao.findForObject("DeptMapper.checkCodeAndSign", pd);
		if(result.size()>0){
			count = Integer.parseInt(result.get("SL").toString());
		}
		return count;
	}
	/*
	 * 验证部门下是否有员工
	 */
	public int checkEmp(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		Map result = (Map)dao.findForObject("DeptMapper.checkEmp", pd);
		if(result.size()>0){
			count = Integer.parseInt(result.get("E").toString());
		}
		return count;
	}
//--------------------------订单提交模块方法---------------------------
	/*
	 * 查询订单中未添加的部门
	 */
	public List<PageData> listnotInScall(PageData scaleData) throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.listnotInScall", scaleData);
	}
	/*
	 * 查询订单已添加的部门
	 */
	public List<PageData> findScaleDept(String orderId) throws Exception {
		return (List<PageData>)dao.findForList("DeptMapper.findScaleDept", orderId);
	}
//--------------------------订单提交模块方法---------------------------

    /**
     *  通过ID查询子部门
     *  @param ID
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> findSonDeptsById(String ID) throws Exception{
        return (List<PageData>)dao.findForList("DeptMapper.findSonDeptsById",ID);
    }

    /**
     * 根据部门名称获取部门ID
     * @param deptName
     * @return
     * @throws Exception
     */
	public String findIdByName(String deptName) throws Exception {
		PageData pageData = (PageData) dao.findForObject("DeptMapper.findIdByName",deptName);
		return pageData == null ? null : pageData.get("ID").toString();
	}

	/**
	 * 根据上级部门ID获取子部门ID
	 * @param pid
	 * @return
	 * @throws Exception 
	 */
	public List<String> finIdsByPid(String pid) throws Exception {
		return (List<String>) dao.findForList("DeptMapper.finIdsByPid", pid);
	}

    /**
     * 获得节点下所有经营体
     * @param deptId
     * @throws Exception
     * author yangdw
     */
    public List<PageData> getAllSonDepts(String deptId) throws Exception {

        List<PageData> deptList = new ArrayList<PageData>();

        PageData deptSearchpd = new PageData();
        deptSearchpd.put("ID",deptId);
        //加入它本身
        PageData dept = findById(deptSearchpd);
        deptList.add(dept);

        List<PageData> sonDeptList = findSonDeptsById(dept.get("ID").toString());
        if(null != sonDeptList && 0 < sonDeptList.size()){
            for (int i = 0;i < sonDeptList.size(); i ++){
                //放入它下一节点支上的所有部门
                deptList.addAll(getAllSonDepts(sonDeptList.get(i).get("ID").toString()));
            }
            return deptList;
        }else {
            return deptList;
        }
    }

    /**
     * 根据部门编码获取部门标识
     * @param deptCode
     * @return
     * @throws Exception
     */
	public String getSignByCode(String deptCode) throws Exception {
		return (String) dao.findForObject("DeptMapper.getSignByCode", deptCode);
	}
	
	/**
	 * 根据ID获取部门名称
	 * @param ids
	 * @return
	 * @throws Exception
	 */
	public List<String> findNameByIds(String[] ids) throws Exception{
		return (List<String>) dao.findForList("DeptMapper.getNameByIds", ids);
	}
	/**
	 * 根据标识获取部门
	 */
	public PageData findIdBySign(PageData pdc) throws Exception{
		return (PageData) dao.findForObject("DeptMapper.findIdBySign", pdc);
	}
	
	/**
	 * 更新岗位中的部门名称
	 */
	public void updateDeptNameInPos(PageData pd) throws Exception{
		dao.update("DeptMapper.updateDeptNameInPos", pd);
	}
	
	/**
	 * 更新员工中的部门名称
	 */
	public void updateDeptNameInEmp(PageData pd) throws Exception{
		dao.update("DeptMapper.updateDeptNameInEmp", pd);
	}
	
	/**
	 * 更新用户中的部门名称
	 */
	public void updateDeptNameInUser(PageData pd) throws Exception{
		dao.update("DeptMapper.updateDeptNameInUser", pd);
	}
	
	/**
	 * 查询部门的负责人
	 */
	public PageData findDeptLeader(String deptId) throws Exception{
		return (PageData) dao.findForObject("DeptMapper.findDeptLeader", deptId);
	}
	
	/**
	 *  根据用户的userId 查询有权限查看的所有部门
	 */
	public List<PageData> findDeptInDataRoleByUserId(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("DeptMapper.findDeptInDataRoleByUserId", pd);
	}
	
	/**
	 * 根据部门编码，查询部门信息
	 */
	public PageData findDeptByCode(String deptCode) throws Exception{
		PageData pd = new PageData();
		pd.put("deptCode", deptCode);
		return (PageData) dao.findForObject("DeptMapper.findDeptByCode", pd);
	}
	
	/**
	 * 用于返回树结构
	 */
	public PageData findAvaiableDept(PageData reqPd){
		PageData result = new PageData();
		try {
			//查询可用的部门
			reqPd.put("ENABLED", 1);
			List<PageData> list = listAll(reqPd);
			//判断是否不选择父节点
			boolean isNocheckParent = null != reqPd.get("isNocheckParent") && reqPd.get("isNocheckParent").toString().equals("true");
			//处理用于返回给前台的数据
			List<PageData> datas = new ArrayList<PageData>();
			for(PageData item : list){
				String nameStr = item.get("DEPT_NAME").toString();
				PageData pd = new PageData();
				pd.put("id", item.get("ID"));//与父类以code为关联字段
				pd.put("pId", item.get("PARENT_ID"));
				pd.put("name", nameStr);
				pd.put("deptCode", item.get("DEPT_CODE"));
				pd.put("description", nameStr);
				if(isNocheckParent){
					pd.put("nocheck", item.get("IS_PARENT").toString().equals("parent"));
				}
				datas.add(pd);
			}
			result.put("datas", datas);
			result.put("msg", Const.SUCCESS);
		} catch (Exception e) {
			logger.error(e);
			result.put("msg", Const.ERROR);
		}
		return result;
	}

	/**
	 * 设置部门的分管领导
	 * @throws Exception 
	 */
	public void updateManageEmp(PageData pd) throws Exception {
		
		//先判断是否有选择部门，没有则置空之前配置的
		PageData result = (PageData) dao.findForObject("DeptMapper.findManageDeptId", pd);
		if(null != result && !result.get("relateDeptIds").toString().isEmpty()){
			//先删除之前的
			dao.update("DeptMapper.updateManageEmpNull", result);
		}
		//更新主管部门
		if(pd.containsKey("relateDeptIds") && !pd.get("relateDeptIds").toString().isEmpty()){
			String msg = "设置分管领导，empCode："+ pd.get("empCode").toString() 
					+ ", relateDeptIds"+ pd.get("relateDeptIds").toString();
			userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, "部门"
					, msg));
			dao.update("DeptMapper.updateManageEmp", pd);
		}
	}
	
}