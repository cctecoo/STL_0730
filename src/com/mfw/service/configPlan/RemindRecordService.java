package com.mfw.service.configPlan;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.system.User;
import com.mfw.util.PageData;

/**
 * 推送配置计划Service
 * @author  作者 白惠文
 * @date 创建时间：2017年7月31日 下午17:01:02
 */
@Service("remindRecordService")
public class RemindRecordService {
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
    /**
     * 根据员工编号查找历史消息
     * @param pageData
     * @return
     * @throws Exception 
     */
	public List<PageData> findRecord(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("remindConfigMapper.findRecord", pd);
	}
	
    /**
     * 标记历史记录状态
     * @param pageData
     * @return
     * @throws Exception 
     */
	public void editRecord(PageData pd) throws Exception {
		dao.update("remindConfigMapper.editRecord", pd);		
	}
	
	
    /**
     * 根据ID查找历史消息
     * @param pageData
     * @return
     * @throws Exception 
     */
	public PageData findRecordById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("remindConfigMapper.findRecordById", pd);
	}

    /**
     * 一键标记为已读
     * @param pageData
     * @return
     * @throws Exception 
     */
	public void updateAll(PageData pd) throws Exception {
		dao.update("remindConfigMapper.updateAll", pd);		
	}
}
