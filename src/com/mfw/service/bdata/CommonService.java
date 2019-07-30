package com.mfw.service.bdata;

import java.util.ArrayList;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.mfw.entity.system.AccessToken;
import com.mfw.entity.system.OAuthInfo;
import com.mfw.entity.system.User;
import com.mfw.util.Const;
import com.mfw.util.Logger;

import com.mfw.util.WeixinUtil;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.util.PageData;

/**
 * 通用Service
 * @author  作者  蒋世平
 * @date 创建时间：2016年5月10日 上午11:42:29
 */
@Service("commonService")
public class CommonService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	protected Logger logger = Logger.getLogger(this.getClass());
	
	public OAuthInfo getOpenId(String code) {
		Object[] arr = WeixinUtil.getOpenId(code);
    	OAuthInfo openId = (OAuthInfo) arr[0];
    	AccessToken accessToken = (AccessToken) arr[1];
    	if(null!=openId){
    		updateParamByName(Const.ACCESS_TOKEN, accessToken.getToken());
            updateParamByName(Const.ACCESS_TOKEN_EXPPIRES_IN, String.valueOf(accessToken.getExpiresIn()));
    	}
      
        return openId;
    }
	
	 /**
     * 获取access_token
     *
     * @param appid 凭证
     * @param appsecret 密钥
     * @return
     */
    public AccessToken getAccessToken(String appid, String appsecret) {
        AccessToken accessToken = null;
        String[] params = {Const.ACCESS_TOKEN, Const.ACCESS_TOKEN_EXPPIRES_IN};
        PageData pd = new PageData();
        pd.put("params", params);
        PageData result = findParamByNames(pd);
    	
        if(result.get(Const.ACCESS_TOKEN) != null && !result.get(Const.ACCESS_TOKEN).toString().isEmpty()){
        	//存在，判断是否过期
        	String tokenParam = result.get(Const.ACCESS_TOKEN).toString();
        	String expiresIn = result.get(Const.ACCESS_TOKEN_EXPPIRES_IN).toString();
        	Long now  = Long.parseLong(String.valueOf(System.currentTimeMillis()).substring(0, 10))-Long.parseLong(expiresIn);
        	if(now > 7200 ){//过期，需要更新
        		accessToken = WeixinUtil.getAccessToken(appid, appsecret);
        		if(null!=accessToken){
                	updateParamByName(Const.ACCESS_TOKEN, accessToken.getToken());
                	updateParamByName(Const.ACCESS_TOKEN_EXPPIRES_IN, String.valueOf(accessToken.getExpiresIn()));
        		}
            }else{
            	accessToken = new AccessToken();
                accessToken.setToken(tokenParam);
                accessToken.setExpiresIn(Integer.valueOf(expiresIn));
            }
        }else{//不存在，需要更新
        	accessToken = WeixinUtil.getAccessToken(appid, appsecret);
        	if(null!=accessToken){
	        	saveParamByName(Const.ACCESS_TOKEN, accessToken.getToken());
	        	saveParamByName(Const.ACCESS_TOKEN_EXPPIRES_IN, String.valueOf(accessToken.getExpiresIn()));
        	}
        }
        
        return accessToken;
    }
    public void saveConfigParam(PageData pd) throws Exception{
		dao.save("ConfigParamMapper.saveConfigParam", pd);
	}
	
	public void saveParamByName(String name, String val){
		try {
			PageData pd = new PageData();
			pd.put("itemName", name);
			pd.put("itemValue", val);
			dao.save("ConfigParamMapper.saveConfigParam", pd);
		} catch (Exception e) {
			logger.error(e);
		}
	}
	
	/**
	 * 更新
	 */
	public void updateParam(PageData pd) throws Exception {
		dao.update("ConfigParamMapper.updateParam", pd);
	}
	
	/**
	 * 更新
	 */
	public void updateParamByName(String name, String val){
		try {
			PageData pd = new PageData();
			pd.put("itemName", name);
			pd.put("itemValue", val);
			dao.update("ConfigParamMapper.updateParam", pd);
		} catch (Exception e) {
			logger.error(e);
		}
	}
	
    /**
	 * 查询多个
	 */
	public PageData findParamByNames(PageData pd){
		PageData result = new PageData();
		try {
			result = (PageData) dao.findForObject("ConfigParamMapper.findParamByNames", pd);
			result.put(Const.MSG, Const.SUCCESS);
		} catch (Exception e) {
			logger.error(e);
			result.put(Const.MSG, Const.ERROR);
		}
		return result;
	}
    
	/**
	 * 根据父级编码，获取数据字典中子类类型
	 * @param bianma 父节点的编码名
	 * @return list
	 * @throws Exception
	 */
	public List<PageData> typeListByBm(String bianma) throws Exception {
		return (List<PageData>) dao.findForList("DictionariesMapper.typeListByBm", bianma);
	}

	/**
	 * 获取数据字典中ZD_ID
	 * @param bianma 编码名
	 * @return list
	 * @throws Exception
	 */
	public String findIdByBm(String bianma) throws Exception {
		// TODO Auto-generated method stub
		return (String) dao.findForObject("DictionariesMapper.findIdByBm", bianma);
	}

	public String getKpiRatio(String bianma) throws Exception {
		// TODO Auto-generated method stub
		return (String) dao.findForObject("RatioModelMapper.getKpiRatio", bianma);
	}
	/*
	* 获取部门数据(除了公司以外)
	*/
	public List<PageData> findDeptNoCom(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("DeptMapper.findDeptNoCom", pd);
	}
	
	/*
	* 获取用户部门数据(根据当前用户)
	*/
	public String findDeptByUser(PageData pd)throws Exception{
		return (String)dao.findForObject("ProjectMapper.findDeptByUser", pd);
	}
	
	/*
	* 获取用户部门数据(根据ID)
	*/
	public PageData findDeptById(String dept_id)throws Exception{
		return (PageData)dao.findForObject("ProjectMapper.findDeptById",dept_id);
	}
	
	/*
	* 获取订单数据(根据部门)
	*/
	public List<PageData> findProByDept(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("ProjectMapper.findProByDept", pd);
	}
	
	
	/*
	* 获取下级部门数据(根据ID)
	*/		
	public List<PageData> findChildDeptById(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("ProjectMapper.findChildDeptById", pd);
	}

    /**
     * 获取员工数据权限部门
     * @throws Exception
     * author yangdw
     */
    public List<PageData> getSysDeptList() throws Exception {
        Subject currentUser = SecurityUtils.getSubject();
        Session session = currentUser.getSession();
        //获得登录用户
        User user = (User) session.getAttribute(Const.SESSION_USER);
        String USER_ID = "";
        PageData pd = new PageData();
        if(!"admin".equals(user.getUSERNAME())){
            USER_ID = user.getUSER_ID().toString();
            pd.put("USER_ID",USER_ID);
            return (List<PageData>) dao.findForList("DeptMapper.getSysDeptList", pd);
        }else {
            pd.put("USER_ID",USER_ID);
            return (List<PageData>) dao.findForList("DeptMapper.getSysDeptList", pd);
        }
    }
    
	public int checkSysRole(String roleId) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		Map result = (Map)dao.findForObject("RoleMapper.checkSysRole", roleId);
		if(result.size()>0){
			count = Integer.parseInt(result.get("SL").toString());
		}
		return count;
	}
	
	
	/**
     * 获取所有状态
     * @throws Exception
     * author yyz
     */
    public List<PageData> getStatusList(PageData pd) throws Exception {
           return (List<PageData>) dao.findForList("StatusMapper.listAll", pd);
    }
    
    /**
	* 根据部门ID获取下级部门列表
	*/		
	@SuppressWarnings("unchecked")
	public List<PageData> findChildDeptByDeptId(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("DeptMapper.findChildDeptById", pd);
	}
	
	/**
	 * 根据员工编码（empCode）查询员工所在部门
	 */
	public PageData findDeptByEmpCode(String empCode) throws Exception{
		return (PageData) dao.findForObject("EmployeeMapper.findDeptByEmpCode", empCode);
	}
	
	
    /**
	* 查看是否是领导
	*/
	public int checkLeader(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		PageData result = (PageData) dao.findForObject("RoleMapper.checkLeader", pd);
		if(result!=null){
			count = 1;
		}
		return count;
	}
	
	/**
	 * 获取消息提醒收据
	 * @param EMP_CODE
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> showMsgData(String EMP_CODE) throws Exception{
		return (List<PageData>) dao.findForList("showDataMapper.showMsgData", EMP_CODE);
	}
	
	/**
	 * 任务统计，用于主页上方显示数量，进行分步查询
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> showMsgData(String EMP_CODE, boolean splitSearch) throws Exception{
		List<PageData> list = new ArrayList<PageData>();
		//目标
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataTargetYear", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataTargetYearDept", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataTargetMonthEmp", EMP_CODE));
		//项目审核
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataProjectAudit", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataProjectComment", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataProjectReject", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataProjectAssess", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataProjectAssessReject", EMP_CODE));
		//项目分解
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataPorjectUnsplit", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataProjectUnsplitNode", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataProjectUnsplitEvent", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataProjectChange", EMP_CODE));
		
		//临时工作申请
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataTempTaskApply", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataTempTaskApplyReject", EMP_CODE));
		
		//日清-待处理
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataTempTask", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataFlowTask", EMP_CODE));
		
		//日清看板评价
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataEmpTargetTaskAssess", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataEmpEventTaskAssess", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataEmpPositionTaskAssess", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataEmpPositionTaskReject", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataTempTaskAssess", EMP_CODE));
		
		//表单
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataRepairOrder", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataFormWork", EMP_CODE));
		list.addAll((List<PageData>)dao.findForList("showDataMapper.showMsgDataFormPurchase", EMP_CODE));
		
		return list;
	}
	
	/**
	 * 查询部门负责人
	 */
	public PageData findDeptLeader(String deptId) throws Exception{
		return (PageData) dao.findForObject("DeptMapper.findDeptLeader", deptId);
	}
	
	/**
	 * 查询员工负责的部门
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findDeptInCharge(String empCode) throws Exception{
		return (List<PageData>) dao.findForList("DeptMapper.findDeptInCharge", empCode);
	}
	
	/**
	 * 查询拥有其它部门数据权限的部长级别以上的领导
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpCodeInDataRoleByDeptId(Integer detptId) throws Exception{
		return (List<PageData>) dao.findForList("dataroleMapper.findEmpCodeInDataRoleByDeptId", detptId);
	}
	
	/**
	 * 获取是否为副总权限
	 * @param roleId
	 * @return
	 * @throws Exception 
	 */
	public int checkFzRole(String roleId) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;

		Map result = (Map)dao.findForObject("RoleMapper.checkFzRole", roleId);		
		
		if(result.size()>0){
			count = Integer.parseInt(result.get("SL").toString());
		}
		return count;
	}
	
	
	/*
	 * 通过部门id获取部门分数
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> getScore(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("AppMapper.getScore", pd);
	}
	
	
	/*
	 * 通过部门id获取部门分数
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> getUserForOpenId(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("AppMapper.getUserForOpenId", pd);
	}
}
