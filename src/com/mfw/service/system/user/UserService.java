package com.mfw.service.system.user;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.util.Const;
import com.mfw.util.DateUtil;
import com.mfw.util.PageData;

/**
 * 用户管理Service
 * @author  作者 于亚洲
 * @date 创建时间：2014年7月30日 下午15:16:29
 */
@Service("userService")
public class UserService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;

	//======================================================================================

	/*
	 * 通过id获取数据
	 */
	public PageData findByUiId(PageData pd) throws Exception {
		return (PageData) dao.findForObject("UserXMapper.findByUiId", pd);
	}

	/*
	 * 通过loginname获取数据
	 */
	public PageData findByUId(PageData pd) throws Exception {
		return (PageData) dao.findForObject("UserXMapper.findByUId", pd);
	}

	/*
	 * 通过邮箱获取数据
	 */
	public PageData findByUE(PageData pd) throws Exception {
		return (PageData) dao.findForObject("UserXMapper.findByUE", pd);
	}

	/*
	 * 通过编号获取数据
	 */
	public PageData findByUN(PageData pd) throws Exception {
		return (PageData) dao.findForObject("UserXMapper.findByUN", pd);
	}

	/*
	 * 保存用户
	 */
	public void saveU(PageData pd) throws Exception {
		dao.save("UserXMapper.saveU", pd);
	}

	/*
	 * 修改用户
	 */
	public void editU(PageData pd) throws Exception {
		dao.update("UserXMapper.editU", pd);
	}

	/*
	 * 换皮肤
	 */
	public void setSKIN(PageData pd) throws Exception {
		dao.update("UserXMapper.setSKIN", pd);
	}

	/*
	 * 删除用户
	 */
	public void deleteU(PageData pd) throws Exception {
		dao.delete("UserXMapper.deleteU", pd);
	}

	/*
	 * 批量删除用户
	 */
	public void deleteAllU(String[] USER_IDS) throws Exception {
		dao.delete("UserXMapper.deleteAllU", USER_IDS);
	}

	/*
	 * 用户列表(用户组)
	 */
	public List<PageData> listPdPageUser(Page page) throws Exception {
		return (List<PageData>) dao.findForList("UserXMapper.userlistPage", page);
	}

	/*
	 * 用户列表(全部)
	 */
	public List<PageData> listAllUser(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("UserXMapper.listAllUser", pd);
	}

	/*
	 * 用户列表(供应商用户)
	 */
	public List<PageData> listGPdPageUser(Page page) throws Exception {
		return (List<PageData>) dao.findForList("UserXMapper.userGlistPage", page);
	}

	/*
	 * 保存用户IP
	 */
	public void saveIP(PageData pd) throws Exception {
		dao.update("UserXMapper.saveIP", pd);
	}

	/*
	 * 登录判断
	 */
	public PageData getUserByNameAndPwd(PageData pd) throws Exception {
		return (PageData) dao.findForObject("UserXMapper.getUserInfo", pd);
	}

	/*
	 * 跟新登录时间
	 */
	public void updateLastLogin(PageData pd) throws Exception {
		pd.put("LAST_LOGIN", DateUtil.getTime().toString());
		dao.update("UserXMapper.updateLastLogin", pd);
	}

	/*
	 * 通过id获取数据
	 */
	public User getUserAndRoleById(String USER_ID) throws Exception {
		return (User) dao.findForObject("UserMapper.getUserAndRoleById", USER_ID);
	}

	@SuppressWarnings("unchecked")
	public String getUserNameByNumber(String number) throws Exception {
		String rtn ="";
		HashMap<String, Object> map = 
				(HashMap<String, Object>) dao.findForObject("UserMapper.getUserNameByNumber", number);
		if(map != null){
			rtn = map.get("USERNAME").toString();
		}
		return rtn;
	}
	
	/*
	 * 通过ID获取累计登录时间
	 */
	public String findTimeById(PageData pd) throws Exception {
		return (String) dao.findForObject("UserMapper.findTimeById", pd);
	}
	
	/*
	 * 通过ID获取累计登录时间(新)
	 */
	public String findTimeByIdNew(PageData pd) throws Exception {
		return (String) dao.findForObject("UserMapper.findTimeByIdNew", pd);
	}
	
	/*
	 * 更新登录时长
	 */
	public void updateOnlineTime(PageData pd) throws Exception {
		Date now = new Date(); 
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date =dateFormat.format(now);
		
		String onlineTime = (String) dao.findForObject("UserMapper.searchOnlineTimeChange", pd);
		if("".equals(onlineTime)||onlineTime == null){
			pd.put("ONLINE_TIME_CHANGE", date);
			dao.update("UserMapper.updateOnlineTime", pd);
		}else{
			Date onlineTimeChange =dateFormat.parse(onlineTime); 
			Long interval = (now.getTime() - onlineTimeChange.getTime());
			if (interval > Integer.valueOf(Const.REFRESH_INTERVAL)*60000){
				pd.put("ONLINE_TIME_CHANGE", date);
				dao.update("UserMapper.updateOnlineTime", pd);
			}
		}
	}
	


	public User findUserByOpenid(PageData pd) throws Exception {
		return (User) dao.findForObject("UserMapper.findUserByOpenid", pd);
	}

	public void bindOpenId(User user) throws Exception {
		dao.update("UserMapper.bindOpenId", user);
	}

	public void unBindOpenId(User user) throws Exception {
		dao.update("UserMapper.unBindOpenId", user);
	}
	/**
	 * 判断用户是否是高级用户（部长以上级别）
	 */
	public Boolean IsSeniorLeader(User user)throws Exception{
		Integer positionLevel = getUserLevel(user);
		Boolean result = false;
		if(positionLevel < 4){
			result = true;
		}
		return result;
	}
	public Integer getUserLevel(User user)throws Exception{
		return (Integer) dao.findForObject("UserMapper.getUserPositionLevel", user);
	}
	
	/*
	 * 根据员工ID获取员工对应账号的openID
	 */
	public PageData findOpenIdByEmpId(PageData empPlan) throws Exception {
		return (PageData) dao.findForObject("UserMapper.findOpenIdByEmpId", empPlan);
	}
	
	/**
	 * 判断用户是否该组织结构（部门下的）
	 */
	public boolean isExistUserInDept(String username, String deptId){
		PageData pd = new PageData();
		pd.put("username", username);
		pd.put("deptId", deptId);
		
		try {
			PageData result = (PageData) dao.findForObject("UserMapper.findUserByUsernameAndDeptId", pd);
			if(null != result){
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
			
		}
		return false;
	}
	
	/**
	 * 通过部门id查找用户信息，用于生成用户树
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findUserByDeptId(Integer deptId) throws Exception{
		PageData pd = new PageData();
		pd.put("deptId", deptId);
		return (List<PageData>) dao.findForList("UserMapper.findUserByDeptId", pd);
	}
}
