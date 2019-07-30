package com.mfw.service.system;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.system.UserLog;
import com.mfw.util.PageData;

/**
 * 用户操作日志Service
 * @author  作者 于亚洲
 * @date 创建时间：2014年7月30日 下午15:16:29
 */
@Service("userLogService")
public class UserLogService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	@SuppressWarnings("unchecked")
	public List<PageData> listPage(Page page) throws Exception{
		return (List<PageData>) dao.findForList("UserLogMapper.listPage", page);
	}
	
	public void logInfo(UserLog userLog) throws Exception{
		dao.save("UserLogMapper.logOper", userLog);
	}

	public int countLog(Page page) throws Exception {
		return (int) dao.findForObject("UserLogMapper.countLog", page);
	}
	
}
