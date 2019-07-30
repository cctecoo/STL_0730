package com.mfw.service.system.notice;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.controller.base.BaseService;
import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

/**
 * 公告 Service
 * @author  作者  蒋世平
 * @date 创建时间：2016年6月7日 下午17:04:13
 */
@Service("noticeService")
public class NoticeService extends BaseService{

	@Resource(name = "daoSupport")
	private DaoSupport dao;

	@SuppressWarnings("unchecked")
	public List<PageData> notelistPage(Page page)throws Exception{
		return (List<PageData>) dao.findForList("NoticeMapper.notelistPage", page);
	}

	public void delete(String id)throws Exception{
		dao.update("NoticeMapper.deleteById", id);
	}

	private PageData findById(PageData pd)throws Exception{
		return (PageData) dao.findForObject("NoticeMapper.findById", pd);
	}

	public void add(PageData pd)throws Exception{
		dao.save("NoticeMapper.add", pd);
	}

	public void publish(PageData pd)throws Exception{
		dao.update("NoticeMapper.publish", pd);
	}
	
	/**
	 * 查询系统通知
	 */
	public PageData findNoticeById(String id)throws Exception{
		PageData pd = new PageData();
		pd.put("id", id);
		pd.put("empCode", getUser().getNUMBER());
		return findById(pd);
	}
	
	/**
	 * 接收人，查看系统通知
	 */
	public PageData viewNoticeInfo(String noticeId, boolean isSysAdmin) throws Exception{
		//先查询消息
		PageData pd = findNoticeById(noticeId);
		
		//系统管理员，不需要记录
		if(isSysAdmin){
			return pd;
		}
		
		//如果没有查看，则增加查看记录
		if(null != pd && null != pd.get("EMP_READ_COUNT")){
			int readCount = Integer.valueOf(pd.get("EMP_READ_COUNT").toString());
			if(readCount==0){
				PageData readPd = new PageData();
				readPd.put("noticeId", pd.get("ID"));
				readPd.put("empCode", getUser().getNUMBER());
				readPd.put("empName", getUser().getNAME());
				readPd.put("deptId", getUser().getDeptId());
				readPd.put("deptName", getUser().getDeptName());
				addNoticeEmpRead(readPd);
			}
		}
		
		return pd;
	}

	/**
	 * 添加员工查看通知的记录
	 * @param pd
	 * @throws Exception
	 */
	private void addNoticeEmpRead(PageData pd) throws Exception{
		dao.save("NoticeMapper.addNoticeEmpRead", pd);
	}

}
