package com.mfw.controller.system.notice;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.UserLog;
import com.mfw.entity.system.UserLog.LogType;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.system.UserLogService;
import com.mfw.service.system.notice.NoticeService;
import com.mfw.util.Const;
import com.mfw.util.EndPointServer;
import com.mfw.util.FileUpload;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.TaskType;

/**
 * 公告
 * @author  作者  蒋世平
 * @date 创建时间：2016年6月7日 下午17:04:13
 */
@Controller
@RequestMapping("/notice")
public class noticeController extends BaseController{

	@Resource(name="noticeService")
	NoticeService noticeService;
	@Resource(name="userLogService")
	private UserLogService userlogService;
	@Resource(name = "commonService")
    private CommonService commonService;
	
	
	@RequestMapping(value="/list")
	public ModelAndView list(){
		ModelAndView mv = new ModelAndView();
		try {
			mv.addObject("sysUser", getUser().getUSERNAME());
			mv.setViewName("system/notice/list");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	@RequestMapping(value="/addSave")
	public ModelAndView add(){
		ModelAndView mv = new ModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			pd.put("content", StringEscapeUtils.escapeHtml(pd.getString("content")));
			pd.put("status", Const.SYS_STATUS_YW_CG);
			pd.put("create_user", getUser().getUSERNAME());
			pd.put("create_time", new Date());
			noticeService.add(pd);
//			userlogService.logInfo(
//					new UserLog(
//						getUser().getUSER_ID(), 
//						LogType.add,
//						"公告",
//						"新增成功，ID：" + pd.getString("ID")
//					)
//				);
			mv.addObject("msg", "success");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	@RequestMapping(value="/uploadImage", method=RequestMethod.POST)
	@ResponseBody
    public void uploadImage(@RequestParam("file")CommonsMultipartFile pic,HttpServletResponse response,MultipartHttpServletRequest request){
       // Map result_map = new HashMap();
        try{
        	//PageData pd = this.getPageData();
        	String filename = pic.getOriginalFilename();
        	String filePath = PathUtil.getClasspath()
					+ Const.FILEPATHIMG; // 文件上传路径
        	FileUpload.fileUp(pic, filePath, filename.substring(0, filename.lastIndexOf(".")));
        	String url = Const.FILEPATHIMG+filename;
        	response.setCharacterEncoding("UTF-8");// 加上此处可解决页面js显示乱码问题            
        	response.getWriter().write(url);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
	
	/**
	 * 公告列表
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="noticeList",method=RequestMethod.POST)
	public GridPage noticeList(Page page, HttpServletRequest request){
		convertPage(page, request);
		PageData pageData = page.getPd();
		pageData.put("user", getUser().getNUMBER());
		
		pageData.put("CREATEUSER", getUser().getUSERNAME());
		int current = Integer.valueOf(request.getParameter("current"));
		int pageCount = Integer.valueOf(request.getParameter("rowCount"));
		page.setPd(pageData);
		page.setShowCount(pageCount);
		page.setCurrentPage(current);
		
		List<PageData> projectList = new ArrayList<PageData>();
		try {
			projectList = noticeService.notelistPage(page);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new GridPage(projectList, page);
	}
	
	/**
	 * 删除
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="delete",method=RequestMethod.POST)
	public String delete(@RequestParam("id") String id){
		try {
			noticeService.delete(id);
			userlogService.logInfo(
					new UserLog(
						getUser().getUSER_ID(), 
						LogType.delete,
						"公告",
						"删除成功，ID：" + id
					)
				);
			return "success";
		} catch (Exception e) {
			return e.getMessage();
		}
	}
	
	/**
	 * 发布
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="publish",method=RequestMethod.POST)
	public String publish(@RequestParam("id") String id){
		try {
			//发布消息
			PageData pd = new PageData();
			pd.put("ID", id);
			pd.put("STATUS", Const.SYS_STATUS_YW_YSX);
			pd.put("UPDATE_USER", getUser().getUSERNAME());
			pd.put("UPDATE_TIME", new Date());
			noticeService.publish(pd);
			userlogService.logInfo( new UserLog( getUser().getUSER_ID(),  LogType.update, "公告", "发布成功，ID：" + id ));
			
			//推送消息
			PageData msg = noticeService.findNoticeById(id);
			Integer msgId = Integer.valueOf(id);
			String msgText = msg.get("TITLE").toString();
			String userArea = msg.get("AREA").toString();
			//发送系统消息
			EndPointServer.sendAll(getUser().getNAME(), msgId, msgText, TaskType.sysNotice, userArea);
			//发送微信消息
			//TODO
			
			return Const.SUCCESS;
		} catch (Exception e) {
			logger.error(e);
			return Const.ERROR;
		}
	}
	
	@RequestMapping(value="/toAdd")
	public ModelAndView toAdd(){
		ModelAndView mv = new ModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			mv.addObject("pd", pd);
			mv.setViewName("system/notice/add");
			
			//查询地域列表
			List<PageData> areaList = commonService.typeListByBm(Const.DICTIONARIES_BM_BMDY);
			mv.addObject("areaList", areaList);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	@RequestMapping(value="/toNoticeInfo")
	public ModelAndView toNoticeInfo(){
		ModelAndView mv = new ModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			//查看系统公告
			if(pd.get("id")!=null){
				String noticeId = String.valueOf(pd.get("id"));
				pd = noticeService.findNoticeById(noticeId);
			}
			mv.addObject("pd", pd);
			mv.setViewName("system/notice/info");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	@RequestMapping(value="viewNoticeInfo")
	public ModelAndView viewNoticeInfo(){
		//接收人查看通知
		ModelAndView mv = new ModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			//查看系统通知
			if(pd.get("id")!=null){
				String noticeId = String.valueOf(pd.get("id"));
				boolean isSysAdmin = super.isSysAdmin();
				pd = noticeService.viewNoticeInfo(noticeId, isSysAdmin);
			}
			mv.addObject("pd", pd);
			mv.setViewName("system/notice/info");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
}
