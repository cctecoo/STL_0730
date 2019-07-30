package com.mfw.controller.document;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.entity.system.Menu;
import com.mfw.entity.system.User;
import com.mfw.entity.system.UserLog;
import com.mfw.entity.system.UserLog.LogObj;
import com.mfw.entity.system.UserLog.LogType;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.PositionLevelService;
import com.mfw.service.system.UserLogService;
import com.mfw.service.system.user.UserService;

import com.mfw.util.*;
import net.sf.json.JSONArray;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * markDown文件查看类
 * @author  作者 蒋世平
 * @date 创建时间：2019年2月15日 下午13:00:54
 */
@Controller
@RequestMapping(value="/document")
public class DocumentController extends BaseController {

	@RequestMapping("toDocs")
	public ModelAndView toDocs(){
		//跳转到使用说明页面
		ModelAndView mv = new ModelAndView("docs/total");

		return mv;
	}

	@RequestMapping(value="loadMdFile", produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String loadMdFile(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logBefore(logger, "下载MD文件");
		PageData pd =this.getPageData();
		//下载文件
		String pageName = String.valueOf(pd.get("pageName"));
		String filePath = Tools.getRootFilePath() + "WEB-INF/jsp/docs/" + pageName;
		byte[] data = FileUtil.toByteArray2(filePath);
		String json = new String(data);

		return json;
	}

}
