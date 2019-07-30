package com.mfw.service.file;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.mfw.dao.DaoSupport;
import com.mfw.util.Const;
import com.mfw.util.FileUpload;
import com.mfw.util.Logger;
import com.mfw.util.PageData;

/**
 * 附件Service
 * @author  作者 蒋世平
 * @date 创建时间：2016年7月04日 下午16:08:40
 */
@Service("fileService")
public class FileService {
	
	private Logger logger = Logger.getLogger(this.getClass());

	@Resource(name="daoSupport")
	private DaoSupport dao;
	
	/**
	 * 上传附件
	 */
	public String saveFile(MultipartFile[] files, PageData pd){
		//处理请求参数
		Object taskId = pd.get("taskId");
		Object taskType = pd.get("taskType");
		Object userName = pd.get("userName");
		if(null == taskId || taskId.toString().isEmpty()
				|| null == taskType || taskType.toString().isEmpty()
				|| null == userName || userName.toString().isEmpty()){
			logger.error("请求参数不完整");
			return "请求参数不完整";
		}
		try {
			for(int i = 0;i<files.length;i++){
				saveFileToServer(files[i], taskId.toString(), taskType.toString(), userName.toString());
			}
			return "";
		} catch (Exception e) {
			logger.error("上传文件出错", e);
			return "上传文件出错";
		}
    }
	
    /**
     * 上传文件到服务器
     */
    private Integer saveFileToServer(MultipartFile file, String taskId, 
    		String taskType, String userName) throws Exception{
    	//上传附件
		if(null != file && !file.isEmpty()){
			logger.info("开始上传文件");
			String str = FileUpload.uploadFile(file, Const.FILEPATHTASK);
			//拼接保存附件的信息
			String fileName = str.split(",")[0];
			String fileName_server = str.split(",")[1];
			PageData filePd = new PageData();
			filePd.put("fileName", fileName);
			filePd.put("fileName_server", fileName_server);
			filePd.put("taskId", taskId);
			filePd.put("taskType", taskType);
			filePd.put("createUser", userName);
			filePd.put("createDate", new Date());
			saveFile(filePd);
			return Integer.parseInt(filePd.get("id").toString());
		}
		return null;
    }
	
	/**
	 * 保存附件记录到数据库
	 */
	private void saveFile(PageData pd) throws Exception{
		dao.save("TaskFileMapper.saveFile", pd);
	}

	/**
	 * 查询工作上传的附件
	 */
	public List<PageData> findTaskFiles(PageData pd) throws Exception{
		//处理请求参数
		Object taskId = pd.get("taskId");
		Object taskType = pd.get("taskType");
		if(null == taskId || taskId.toString().isEmpty()
				|| null == taskType || taskType.toString().isEmpty()){
			logger.error("请求参数不完整");
			throw new Exception("请求参数不完整");
		}
		List<PageData> fileList = findFile(pd);
		return fileList;
	}
	
	/**
	 * 查询工作上传的附件
	 */
	@SuppressWarnings("unchecked")
	private List<PageData> findFile(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("TaskFileMapper.findFile", pd);
	}
	
	/**
	 * 根据文件ID删除附件
	 */
	public void deleteFile(Integer id) throws Exception{
		deleteFileByFileId(id);
	}
	
	/**
	 * 根据文件ID删除附件
	 */
	private void deleteFileByFileId(Integer id) throws Exception{
		dao.delete("TaskFileMapper.deleteFileByFileId", id);
	}
}

