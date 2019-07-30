package com.mfw.service.bdata;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.mfw.controller.base.BaseService;
import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.entity.system.UserLog;
import com.mfw.entity.system.UserLog.LogType;
import com.mfw.util.Const;
import com.mfw.util.FileUpload;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.PageData;

/**
 * 员工表Service
 * @author  作者  蒋世平
 * @date 创建时间：2015年12月11日 上午11:32:29
 */
@Service("employeeService")
public class EmployeeService extends BaseService{
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("EmployeeMapper.save", pd);
	}

	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"员工", "删除，id："+ pd.get("ID").toString()));
		dao.delete("EmployeeMapper.delete", pd);
	}

	/**
	 * 更新员工信息
	 */
	public void editEmpInfo(PageData pd) throws Exception {
		//执行修改Employee
		edit(pd);
		//更新相应的用户信息
		updateEmpInfoInUser(pd);
	}
	
	/**
	 * 修改对应的员工中的岗位名称及考核模板
	 */
	public void updatePositionNameInEmp(PageData pd) throws Exception{
		dao.update("EmployeeMapper.updatePositionNameInEmp", pd);
	}
	
	/**
	 * 修改
	 */
	private void edit(PageData pd) throws Exception {
		userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"员工", "编辑，id："+ pd.toString()));
		dao.update("EmployeeMapper.edit", pd);
	}

	/*
	 * 列表(全部)
	 */
	public List<PageData> listAll(String[] IDS) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.listAllByIds", IDS);
	}

	/*
	 * 列表(全部)
	 */
	public List<PageData> listAll(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.listAll", pd);
	}
	
	/*
	 * 列表(全部)
	 */
	public List<PageData> listAllLabour(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.listAllLabour", pd);
	}
	
	/*
	 *列表(全部)
	 */
	public List<PageData> listPageEmp(Page page)throws Exception{
		return (List<PageData>)dao.findForList("EmployeeMapper.listPage", page);
	}
	
	public int countEmp(Page page) throws Exception{
		return (int) dao.findForObject("EmployeeMapper.countEmp", page);
	}
	
	/**
	 * 查找没有系统登录用户的员工
	 * @return
	 * 修改时间		修改人		修改内容
	 * 2016-03-24	李伟涛		新增
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpNotInUser(PageData pd) throws Exception{
		return (List<PageData>)dao.findForList("EmployeeMapper.findEmpNotInUser", pd);
	}
	
	/*
	 * 通过部门id查找员工
	 */
	public List<PageData> findEmpByDept(String deptId) throws Exception {
		return (List<PageData>)dao.findForList("EmployeeMapper.findEmpByDept", deptId);
	}
	
	/*
	 * 通过部门id查找员工
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAllEmpByDept(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("EmployeeMapper.findAllEmpByDept", pd);
	}
	
	/*
	 * 通过id获取数据
	 */
	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("EmployeeMapper.findById", pd);
	}
	/*
	 * 通过code获取数据
	 */
	public PageData findRecordByCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("EmployeeMapper.findRecordByCode", pd);
	}
	/*
	 * 通过员工编码获取数据
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findRecordList(Page page) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeMapper.findRecordlistPage", page);
	}
	/*
	 * 通过员工编码获取是否是配置人员
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findByIsChangeTraining(Page page) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeMapper.findByIsChangeTraining", page);
	}
	
	/*
	 * 通过员工编码获取是否是档案配置人员
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findByIsChangeRecordinglistPage(Page page) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeMapper.findByIsChangeRecordinglistPage", page);
	}
	
	 /* 通过bd_employee的id获取sys_user的数据
	 */
	public PageData findSystemUserById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("EmployeeMapper.findSystemUserById", pd);
	}

	/*
	 * 通过code获取数据
	 */
	public PageData findByCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("EmployeeMapper.findByCode", pd);
	}
	
	
	/**
	 * 根据员工id查询员工信息和档案
	 */
	public PageData findEmpAndRecord(PageData pd) throws Exception {
		return (PageData) dao.findForObject("EmployeeMapper.findEmpAndRecord", pd);
	}
	
	/*
	 * 批量删除
	 */
	public void deleteAll(String[] ArrayDATA_IDS) throws Exception {
		userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"员工", "批量删除，id："+ ArrayDATA_IDS.toString()));
		dao.delete("EmployeeMapper.deleteAll", ArrayDATA_IDS);
	}

	/*
	 * 批量获取
	 */
	public List<PageData> getAllById(String[] ArrayDATA_IDS) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.getAllById", ArrayDATA_IDS);
	}
	
	/**
	 * 根据岗位ID查询该岗位的员工数
	 */
	public Integer findEmpByGradeId(Integer gradeId) throws Exception {
		return (Integer) dao.findForObject("EmployeeMapper.findEmpByGradeId", gradeId);
	}

	public List<PageData> findByDeptIds(List<String> ids) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.findByDeptIds", ids);
	}

	/**
	 * 根据员工编码查询员工所在部门
	 */
	public PageData findDeptByEmpCode(String empCode) throws Exception{
		return (PageData) dao.findForObject("EmployeeMapper.findDeptByEmpCode", empCode);
	}

	/**
	 * 根据部门编码获取员工列表
	 * @param string
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpByDeptCode(String code) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.findEmpByDeptCode", code);
	}
	
	/**
	 * 根据多个部门Id查询员工
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpByDeptIds(List<Integer> deptIds) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeMapper.findEmpByDeptIds", deptIds);
	}
	
	/**
	 * 根据用户编码批量查找
	 */
	public List<PageData> getAllByCodes(String[] ArrayDATA_CODES) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeMapper.getAllByCodes", ArrayDATA_CODES);
	}
	
	/**
	 * 通过员工ID获取员工档案基础信息
	 */
	public PageData findRecord(PageData pd) throws Exception{
		return (PageData) dao.findForObject("EmployeeMapper.findRecord", pd);
	}
	
	/**
	 * 通过员工ID获取员工档案基础信息
	 */
	public PageData findRecordId(PageData pd) throws Exception{
		return (PageData) dao.findForObject("EmployeeMapper.findRecordId", pd);
	}
	
	/**
	 * 通过员工ID获取员工工作经历
	 */
	public List<PageData> findExp(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.findExp", pd);
	}
	
	
	/**
	 * 新增员工档案基础信息
	 */
	public void saveRecord(PageData pd) throws Exception {
		dao.save("EmployeeMapper.saveRecord", pd);
	}
	
	/**
	 * 新增员工工作经历
	 */
	public void saveExp(PageData pd) throws Exception {
		dao.save("EmployeeMapper.saveExp", pd);
	}


	/**
	 * 修改员工档案基础信息
	 */
	public void editRecord(PageData pd) throws Exception {
		dao.update("EmployeeMapper.editRecord", pd);
	}
	
	
	
    /**
     *  批量新增工作经历
     */
    public void batchAdd(List<PageData> addList) throws Exception {
        dao.save("EmployeeMapper.batchAdd", addList);
    }

    /**
     *  批量更新工作经历
     */
    public void batchUpdate(PageData pd) throws Exception {
        dao.update("EmployeeMapper.batchUpdate", pd);
    }

    /**
     *  批量删除工作经历
     */
    public void batchDelete(PageData deletePd) throws Exception {
        dao.delete("EmployeeMapper.batchDelete", deletePd);
    }
    
    /**
     *  删除工作经历
     */
    public void deleteAllExp(PageData deletePd) throws Exception {
        dao.delete("EmployeeMapper.deleteAllExp", deletePd);
    }

    /**
     * 根据编码获取员工姓名
     * @param code
     * @return
     * @throws Exception
     */
    public String findCodeByName(String name) throws Exception{
    	return (String) dao.findForObject("EmployeeMapper.findCodeByName", name);
    }

    /**
     * 根据职位获取员工
     * @param positionId
     * @return
     * @throws Exception 
     */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpByPosition(String positionId) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.findEmpByPosition", positionId);
	}
	
	/*
	 * 通过部门id查找员工，形成组织人员树查到的人员信息
	 */
	public List<PageData> findEmpByDeptPd(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("EmployeeMapper.findEmpByDeptPd", pd);
	}
	
	/**
	 *  根据员工编码查询岗位信息
	 */
	public PageData findPositionByEmpCode(String empCode) throws Exception {
		return (PageData) dao.findForObject("EmployeeMapper.findPositionByEmpCode", empCode);
	}
	
	/*
	 * 列表(全部)
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAllEmpInfo(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.findAllEmpInfo", pd);
	}
	
	/**
	 * 查询上级岗位的所有员工(岗位最大为1级，最小为15级，小于运算符‘<’代表更高级别岗位的员工)
	 * @param pd, 可以设置empCode， deptId，operator（运算符直接用在sql中:<,>,=,<=,>=）
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findSuperiorEmp(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeMapper.findSuperiorEmp", pd);
	}
	
	/**
	 * 更新员工表中‘服务支持’字段 
	 */
	public void updateEmpSupportService(PageData pd) throws Exception{
		dao.update("EmployeeMapper.updateEmpSupportService", pd);
	}
	
	/**
	 * 查询员工信息
	 */
	public PageData findEmployeeByNameAndDept(PageData pd) throws Exception{
		return (PageData) dao.findForObject("EmployeeMapper.findEmployeeByNameAndDept", pd);
	}
	
	/**
	 * 根据员工编码修改员工信息
	 */
	public void updateEmpInfoByEmpcode(PageData pd) throws Exception{
		dao.update("EmployeeMapper.updateEmpInfoByEmpcode", pd);
	}
	
	/**
	 * 更新用户中的员工姓名
	 */
	private void updateEmpInfoInUser(PageData pd) throws Exception{
		dao.update("EmployeeMapper.updateEmpInfoInUser", pd);
	}
	
	/**
	 * 根据员工编码查询员工和岗位信息
	 */
	public PageData findEmpAndGradeInfoByEmpcode(String empCode) throws Exception{
		return (PageData) dao.findForObject("EmployeeMapper.findEmpAndGradeInfoByEmpcode", empCode);
	}
	
	/**
	 * 根据员工ID查找所属部门信息
	 */
	public PageData findDeptInfoByEmpId(PageData pd) throws Exception{
		return (PageData) dao.findForObject("EmployeeMapper.findDeptInfoByEmpId", pd);
	}
	
	/**
	 * 根据员工编码 查询员工的上级领导
	 */
	public PageData findEmpLeaderByEmpId(Integer empId) throws Exception{
		return (PageData) dao.findForObject("EmployeeMapper.findEmpLeaderByEmpId", empId);
	}
	
	/**
	 * 更新培训计划
	 */
	public void updateRecording(PageData pd) throws Exception{
		dao.update("EmployeeMapper.updateRecording", pd);
	}
	
	/**
	 *  根据员工ID，从档案管理页面，更新员工的电话、邮箱、性别信息
	 */
	public void updateEmpInfoByRecordEmpId(PageData pd) throws Exception{
		dao.update("EmployeeMapper.updateEmpInfoByRecordEmpId", pd);
	}
	
	/**
	 *  根据员工ID，更新员工的电话、邮箱、性别信息
	 */
	public void updateSysuserPhoneAndEmailByEmpCode(PageData pd) throws Exception{
		dao.update("EmployeeMapper.updateSysuserPhoneAndEmailByEmpCode", pd);
	}
	
	/**
	 * findAllConfigPageByEmpCode
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAllConfigPageByEmpCode(String empCode, String showPageLike) throws Exception {
		PageData pd = new PageData();
		pd.put("empCode", empCode);
		pd.put("showPageLike", showPageLike);
		return (List<PageData>) dao.findForList("EmployeeMapper.findAllConfigPageByEmpCode", pd);
	}
	
	/**
	 * 查询员工是否可以维护单个页面
	 */
	public PageData findIsChangeByEmpCode(String empCode, String showPage) throws Exception{
		PageData pageData = new PageData();
		pageData.put("empCode", empCode);
		pageData.put("showPage", showPage);
		return findConfigEmpByEmpCode(pageData);
	}
	
	/**
	 * 查询员工是否可以维护单个页面
	 */
	private PageData findConfigEmpByEmpCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("EmployeeMapper.findIsChangeByEmpCode", pd);
	}
	
	/**
	 * 查询员工是否可以维护多个页面
	 */
	public List<PageData> findIsChangeByShowpages(String empCode, List<String> showPages) throws Exception {
		PageData userPd = new PageData();
		userPd.put("empCode", empCode);
		userPd.put("showPages", showPages);
		return findConfigEmpByShowpages(userPd);
	}
	
	/**
	 * 查询员工是否可以维护多个页面
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findConfigEmpByShowpages(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.findIsChangeByShowpages", pd);
	}
	
	/**
	 * 在配置页面展示员工列表
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> unConfigEmplistPage(Page page)throws Exception{
		return (List<PageData>)dao.findForList("EmployeeMapper.unConfigEmplistPage", page);
	}
	
	/**
	 * 保存员工维护列表
	 */
	public void saveEmpConfig(PageData pd) throws Exception{
		//选择的人员-‘维护’字段置为‘Y’
		dao.update("EmployeeMapper.saveEmpConfig", pd);
	}
	
	/**
	 * 删除关联页面的维护人员信息
	 */
	public void deleteEmpConfig(PageData pd) throws Exception{
		//把关联该页面的所有员工‘维护’字段置为‘N’
		dao.update("EmployeeMapper.deleteEmpConfig", pd);
	}
	
	/**
	 * 根据ID删除关联页面的维护人员信息
	 */
	public void deleteEmpConfigById(PageData pd) throws Exception{
		dao.update("EmployeeMapper.deleteEmpConfigById", pd);
	}
	
	/**
	 * 展示保存的员工维护列表
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> empConfiglistPage(Page page) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeMapper.empConfiglistPage", page);
	}
	
	/**
	 * 根据部门地域查询员工档案信息
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findRecordByDeptArea(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeMapper.findRecordByDeptArea", pd);
	}
	
	/**
	 * 根据部门地域查询员工的工作经历
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findRecordExpByDeptArea(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeMapper.findRecordExpByDeptArea", pd);
	}
	
	/**
	 * 导出员工的档案及工作经历
	 */
	public Map<String, Object> exporRecord(String userDeptArea) throws Exception{
		PageData pd = new PageData();
		pd.put("area", userDeptArea);
		//查询当前用户所在区域的员工档案
		List<PageData> recordList = findRecordByDeptArea(pd);
		
		//表格的标题
		String fileTile = "员工档案管理";
		//第二行标题
		List<String> titles = new ArrayList<String>();
		titles.add("员工编码");
		titles.add("员工姓名");
		titles.add("出生日期");
		titles.add("籍贯");
		titles.add("毕业学校");
		titles.add("专业");
		titles.add("毕业时间");
		titles.add("学位");
		//档案数据行
		List<PageData> varList = new ArrayList<PageData>();
		for(int i=0; i<recordList.size(); i++){
			PageData rec = recordList.get(i);
			PageData varPd = new PageData();
			int fieldIndex = 1;
			varPd.put("var" + fieldIndex++, rec.get("EMP_CODE"));
			varPd.put("var" + fieldIndex++, rec.get("EMP_NAME"));
			varPd.put("var" + fieldIndex++, rec.get("BIRTHDAY"));
			varPd.put("var" + fieldIndex++, rec.get("ADDRESS"));
			varPd.put("var" + fieldIndex++, rec.get("SCHOOL"));
			varPd.put("var" + fieldIndex++, rec.get("MAJOR"));
			varPd.put("var" + fieldIndex++, rec.get("GRADUATE_TIME"));
			varPd.put("var" + fieldIndex++, rec.get("DEGREE"));
			varList.add(varPd);
		}
		
		//处理工作经历
		//查询当前用户所在区域的员工的工作经历
		List<PageData> recordExpList = findRecordExpByDeptArea(pd);
		//表格的标题
		String fileTile2 = "工作经历";
		//第二行标题
		List<String> titles2 = new ArrayList<String>();
		titles2.add("员工编码");
		titles2.add("员工姓名");
		titles2.add("工作经历");
		titles2.add("岗位");
		//档案数据行
		List<PageData> varList2 = new ArrayList<PageData>();
		for(int i=0; i<recordExpList.size(); i++){
			PageData rec = recordExpList.get(i);
			PageData varPd = new PageData();
			int fieldIndex = 1;
			varPd.put("var" + fieldIndex++, rec.get("EMP_CODE"));
			varPd.put("var" + fieldIndex++, rec.get("EMP_NAME"));
			varPd.put("var" + fieldIndex++, rec.get("EXP"));
			varPd.put("var" + fieldIndex++, rec.get("POSITION"));
			varList2.add(varPd);
		}
		List<String> sheetNames = new ArrayList<String>();
		sheetNames.add("基本信息");
		sheetNames.add("工作经历");
		//设置创建表格的数据集合
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("sheetNames", sheetNames);
		
		dataMap.put("fileTile1", fileTile);
		dataMap.put("titles1", titles);
		dataMap.put("varList1", varList);
		
		dataMap.put("fileTile2", fileTile2);
		dataMap.put("titles2", titles2);
		dataMap.put("varList2", varList2);
		
		return dataMap;
	}

	/**
	 * 导入员工联系电话等信息
	 * @return
	 */
	public String importEmpOtherInfoExcel(MultipartFile file, String targetFileName, User user){
		try {
			//执行上传
			String fileName = FileUpload.fileUp(file, FileUpload.getImportExcelPath(), targetFileName);
			
			//执行读EXCEL操作,读出的数据导入List 1:从第2行开始；0:从第A列开始；0:第0个sheet
			List<PageData> pdList = (List<PageData>) ObjectExcelRead.readExcel(FileUpload.getImportExcelPath(), fileName, 0, 0, 0); 
			
			for (int i = 1; i < pdList.size(); i++) {
				PageData pd = pdList.get(i);
				Object var0 = pd.get("var0");
				Object var1 = pd.get("var1");
				Object var2 = pd.get("var2");
				boolean isFirstMatch = null!=var1 && var1.toString().length()<11;
				boolean isSencondMatch = null!=var2 && var2.toString().length()==11;
				if(isFirstMatch){
					pd.put("cellPhone", var1);
					pd.put("telPhone", var2);
				}else if(isSencondMatch){
					pd.put("cellPhone", var2);
					pd.put("telPhone", var1);
				}else if(null!=var1){
					pd.put("cellPhone", var2);
					pd.put("telPhone", var1);
				}else{
					pd.put("cellPhone", var1);
					pd.put("telPhone", var2);
				}
			}
			//批量导入数据库
			PageData savePd = new PageData();
			savePd.put("list", pdList);
			dao.save("EmployeeMapper.batchSaveEmpOtherInfo", savePd);
			
			return Const.SUCCESS;
		} catch (Exception e) {
			e.printStackTrace();
			return Const.ERROR;
		}
	}
	
	/**
	 * 根据年度考核模板ID，查询出之前关联的员工列表
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpListByYearKpiModelId(String yearKpiModelId) throws Exception{
		PageData pd = new PageData();
		pd.put("yearKpiModelId", yearKpiModelId);
		List<PageData> list = (List<PageData>) dao.findForList("EmployeeMapper.findEmpListByYearKpiModelId", pd);
		return list;
	}
	
	/**
	 * 年度考核模板，关联的人员修改时
	 */
	public void updateYearKpiModelInEmp(String yearKpiModelId, String relateEmpCodes) throws Exception{
		PageData pd = new PageData();
		
		//根据年度考核模板ID，查询出之前关联的员工列表
		List<PageData> oldEmpList = findEmpListByYearKpiModelId(yearKpiModelId);
		
		//之前关联的员工，设置年度考核模板id=0
		if(oldEmpList.size()>0){
			List<String> empCodeList = new ArrayList<String>();
			for(int i=0; i<oldEmpList.size(); i++){
				empCodeList.add(oldEmpList.get(i).get("EMP_CODE").toString());
			}
			pd.put("empCodeList", empCodeList);
			pd.put("yearKpiModelId", "0");//之前关联的员工，设置年度考核模板id=0
			dao.update("EmployeeMapper.updateYearKpiModelInEmp", pd);
		}
		//模板当前选择的员工，更新模板id
		String[] empCodeArr = relateEmpCodes.split(",");
		if(empCodeArr.length>0){
			List<String> empCodeList = Arrays.asList(empCodeArr);
			pd.put("empCodeList", empCodeList);
			pd.put("yearKpiModelId", yearKpiModelId);
			dao.update("EmployeeMapper.updateYearKpiModelInEmp", pd);
		}
	}

}
