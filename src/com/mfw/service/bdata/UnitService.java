package com.mfw.service.bdata;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

/**
 * bd_unit表Service
 * @author  作者 杨声涛
 * @date 创建时间：2016年5月12日 下午2:44:41
 */
@Service("unitService")
public class UnitService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("UnitMapper.save", pd);
	}
	

	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		dao.delete("UnitMapper.delete", pd);
	}

	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		dao.update("UnitMapper.edit", pd);
	}

	/*
	 * 列表
	 */
	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>) dao.findForList("UnitMapper.listPageUnit", page);
	}
	
	/*
	 * 通过id获取数据
	 */
	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("UnitMapper.findById", pd);
	}
	
	/*
	 * 通过code获取数据
	 */
	public PageData findByCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("UnitMapper.findByCode", pd);
	}

    /**
     * 无参全部，不分页
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<PageData> findAll() throws Exception{
        return (List<PageData>)dao.findForList("UnitMapper.findAll", null);
    }
    
    /**
	 * 检查单位是否被使用
	 */
	public int checkUnitUsed(Integer id) throws Exception{
		PageData result = (PageData) dao.findForObject("UnitMapper.checkUnitUsed", id);
		return ((Long) result.get("num")).intValue();
	}
}
