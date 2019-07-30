package com.mfw.service.bdata;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

/**
 * bd_bussiness_index表Service
 * @author  作者  蒋世平
 * @date 创建时间：2016年5月10日 上午10:02:29
 */
@Service("bussinessIndexService")
public class BussinessIndexService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("BussinessIndexMapper.save", pd);
	}
	

	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		dao.delete("BussinessIndexMapper.delete", pd);
	}

	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		dao.update("BussinessIndexMapper.edit", pd);
	}

	/*
	 * 列表
	 */
	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>) dao.findForList("BussinessIndexMapper.listPageIndex", page);
	}
	
	/*
	 * 通过id获取数据
	 */
	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("BussinessIndexMapper.findById", pd);
	}
	
	/*
	 * 通过code获取数据
	 */
	public PageData findByCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("BussinessIndexMapper.findByCode", pd);
	}


    /**
     * 无参全部，不分页
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<PageData> findAll() throws Exception{
        return (List<PageData>)dao.findForList("BussinessIndexMapper.findAll", null);
    }
    
    /**
	 * 检查经营指标是否被使用
	 */
	public int checkBusiIndexUsed(Integer id) throws Exception{
		PageData result = (PageData) dao.findForObject("BussinessIndexMapper.checkBusiIndexUsed", id);
		return ((Long) result.get("num")).intValue();
	}
}
