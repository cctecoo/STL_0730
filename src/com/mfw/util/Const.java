package com.mfw.util;

import org.springframework.context.ApplicationContext;

/**
 * 常量
 */
public class Const {
	
	public static final String SUCCESS = "success";
	public static final String ERROR = "error";
	public static final String MSG = "msg";
	public static final String NO_FILE = "noFile";
	public static final String NOT_MATCH_FILE = "notMatchFile";
	public static final String NOT_FIND = "notFind";//未查询到数据
	public static final String NO_ENOUGH_AMOUNT = "noEnoughAmount";
	public static final String TOO_MUCH_DATA = "tooMuchData";//返回数据过多
	public static final String REPAET_DATA = "repeatData";//重复数据
	
	public static final String ACCESS_TOKEN= "accessToken";//微信验证信息
	public static final String ACCESS_TOKEN_EXPPIRES_IN= "accessTokenExpiresIn";
	
	public static final String PAY_STATUS_FINISH_CONTRACT = "finishContract";//采购单状态完成合同
	public static final String PAY_STATUS_NOT_FINISH_CONTRACT = "notFinishContract";//采购单状态,没有完成合同
	public static final String PAY_STATUS_FINISH_PAY = "finishPay";//采购单状态,合并付款
	public static final String PAY_STATUS_NOT_PAY = "notPay";//采购单状态,合并付款
	public static final String PAY_STATUS_MERGR = "merge";//采购单状态,合并付款
	
	public static final String IN = "IN";
	public static final String NOT_IN = "NOT IN";
	
	public static final String SESSION_SECURITY_CODE = "sessionSecCode";
	public static final String SESSION_USER = "sessionUser";
	public static final String SESSION_ROLE_RIGHTS = "sessionRoleRights";

	public static final String SESSION_menuList = "menuList"; //当前菜单
	public static final String SESSION_allmenuList = "allmenuList"; //全部菜单
	public static final String SESSION_appmenuList = "appmenuList"; //手机菜单
	public static final String SESSION_appIndexMenuList = "appIndexMenuList";//手机登陆后显示的菜单

	public static final String SESSION_QX = "QX";
	public static final String SESSION_userpds = "userpds";

	public static final String SESSION_USERROL = "USERROL"; //用户对象
	public static final String SESSION_USERNAME = "USERNAME"; //用户名
	
	public static final int SESSION_TIMEOUT = 30000; //session过期时间

	public static final String TRUE = "T";
	public static final String FALSE = "F";
	public static final String LOGIN = "/login_toLogin.do"; //登录地址

	public static final String SYSNAME = "admin/config/SYSNAME.txt"; //系统名称路径
	public static final String PAGE = "admin/config/PAGE.txt"; //分页条数配置路径
	public static final String EMAIL = "admin/config/EMAIL.txt"; //邮箱服务器配置路径
	public static final String SMS1 = "admin/config/SMS1.txt"; //短信账户配置路径1
	public static final String SMS2 = "admin/config/SMS2.txt"; //短信账户配置路径2

	public static final String FILEPATHIMG = "uploadFiles/uploadImgs/"; //图片上传路径
	public static final String FILEPATHFILE = "uploadFiles/file/"; //文件上传路径
	public static final String FILEPATHTASK = "uploadFiles/task"; //日清任务附件文件上传路径
	public static final String FILEPATHOA = "uploadFiles/oa"; //OA附件文件上传路径
	public static final String FILEPATHFEE = "uploadFiles/fee/"; //费控文件上传路径
	public static final String FILEPATHZSK = "uploadFiles/zsk/"; // 知识库文件上传路径
	public static final String FILEPAT_IMPORT = "uploadFiles/import/"; //导入文件上传路径
	
	public static final String NO_INTERCEPTOR_PATH = ".*/((login)|(logout)|(code)|(app)).*"; //不对匹配该值的访问路径拦截（正则）
	public static ApplicationContext WEB_APP_CONTEXT = null; //该值会在web容器启动时由WebAppContextListener初始化

	/**
	 * APP Constants
	 */
	//app注册接口_请求协议参数)
	public static final String[] APP_REGISTERED_PARAM_ARRAY = new String[] { "countries", "uname", "passwd", "title", "full_name", "company_name", "countries_code", "area_code", "telephone", "mobile" };
	public static final String[] APP_REGISTERED_VALUE_ARRAY = new String[] { "国籍", "邮箱帐号", "密码", "称谓", "名称", "公司名称", "国家编号", "区号", "电话", "手机号" };

	//app登录接口_请求协议中的参数
	public static final String[] APP_LOGIN_PARAM_ARRAY = new String[] { "uname", "passwd" };
	public static final String[] APP_LOGIN_VALUE_ARRAY = new String[] { "邮箱账号", "密码" };

	//app登录状态接口_请求协议中的参数
	public static final String[] APP_LOGINSTATUS_PARAM_ARRAY = new String[] { "app_id", "status" };
	public static final String[] APP_LOGINSTATUS_VALUE_ARRAY = new String[] { "app登录用户ID", "登录状态" };

	//忘记密码,查找用户账户是否存在接口_请求协议中的参数
	public static final String[] APP_FORGOTPASSWORD_PARAM_ARRAY = new String[] { "uname" };
	public static final String[] APP_FORGOTPASSWORD_VALUE_ARRAY = new String[] { "邮箱账号" };
	
	/**
	 * 业务状态--草稿
	 */
	public static final String SYS_STATUS_YW_CG = "YW_CG";
	/**
	 * 业务状态--待生效
	 */
	public static final String SYS_STATUS_YW_DSX = "YW_DSX";
	/**
	 * 业务状态--已生效
	 */
	public static final String SYS_STATUS_YW_YSX = "YW_YSX";
	/**
	 * 业务状态--已停用
	 */
	public static final String SYS_STATUS_YW_YTY = "YW_YTY";
	/**
	 * 业务状态--已完毕
	 */
	public static final String SYS_STATUS_YW_YWB = "YW_YWB";
	/**
	 * 业务状态--已作废
	 */
	public static final String SYS_STATUS_YW_YZF = "YW_YZF";
	/**
	 * 业务状态--已退回
	 */
	public static final String SYS_STATUS_YW_YTH = "YW_YTH";
	/**
	 * 业务状态--已终止
	 */
	public static final String SYS_STATUS_YW_YZZ = "YW_YZZ";
	/**
	 * 业务状态--通过
	 */
	public static final String SYS_STATUS_YW_TG = "YW_TG";
	/**
	 * 业务状态--不通过
	 */
	public static final String SYS_STATUS_YW_BTG = "YW_BTG";
	
	/**
	 *  业务状态--未完成
	 */
	public static final String SYS_STATUS_YW_WWC = "YW_WWC";
	
	/**
	 *  业务状态--撤回
	 */
	public static final String SYS_STATUS_YW_YCH = "YW_YCH";
	
	/**
	 *  业务状态--已评价
	 */
	public static final String SYS_STATUS_YW_YPJ = "YW_YPJ";
	
	/**
	 *  业务状态--已接收
	 */
	public static final String SYS_STATUS_YW_YJS = "YW_YJS";
	
	/**
	 *  业务状态--验收中
	 */
	public static final String SYS_STATUS_YW_YSZ = "YW_YSZ";
	
	/**
	 *  业务状态--已验收
	 */
	public static final String SYS_STATUS_YW_YYS = "YW_YYS";
	
	
	/**
	 * 目标工作类型
	 */
	public static final String TASK_TYPE_B = "B";
	
	/**
	 * 创新工作类型
	 */
	public static final String TASK_TYPE_C = "C";
	
	/**
	 * 日常工作类型
	 */
	public static final String TASK_TYPE_D = "D";
	
	/**
	 * 项目活动类型
	 */
	public static final String TASK_TYPE_E = "E";
	
	/**
	 * 流程工作类型
	 */
	public static final String TASK_TYPE_F = "F";
	
	/**
	 * 项目节点类型
	 */
	public static final String TASK_TYPE_N = "N";
	
	/**
	 * 临时工作类型
	 */
	public static final String TASK_TYPE_T = "T";

	/**
	 * 表单
	 */
	public static final String TASK_TYPE_FORM = "FORM";
	
	
	/**
	 * 创新项目
	 */
	public static final String PROJECT = "P";
	/**
	 * 创新项目验收
	 */
	public static final String PROJECT_Y = "Y";
	
	/**
	 * 主页查询任务-未完成工作，待办事项
	 */
	public static final String SUMMARY_TASK_UNHANDLE = "unFinish";
	/**
	 * 主页查询任务-五类工作
	 */
	public static final String SUMMARY_TASK_EMPTASK = "empTask";
	/**
	 * 主页查询任务-维修工单
	 */
	public static final String SUMMARY_TASK_REPAIR_ORDER = "repairOder";
	/**
	 * 主页查询任务-表单工作
	 */
	public static final String SUMMARY_TASK_FORMWORK = "formWork";
	/**
	 * 主页查询任务-系统消息列表
	 */
	public static final String SUMMARY_TASK_SYS_MSG = "sysMsg";

	
	/**
	 * 日清看板查询模块名
	 */
	public static final String MODULE_LIST_DEPT_EMP_TASK = "listDeptEmpTask";
	
	/**
	 * 项目类型编码
	 */
	public static final String PROJECT_TYPE_CODE = "XMLX";
	
	/**
	 * 流程节点的操作类型-接收
	 */
	public static final String FLOW_OPERA_TYPE_JS = "接收";
	
	/**
	 * 流程节点的操作类型-退回
	 */
	public static final String FLOW_OPERA_TYPE_TH = "退回";
	
	/**
	 * 流程节点的操作类型-下一步
	 */
	public static final String FLOW_OPERA_TYPE_XYB = "转交";
	
	/**
	 * 流程节点的操作类型-发起
	 */
	public static final String FLOW_OPERA_TYPE_FQ = "发起";
	
	/**
	 * 流程节点的操作类型-结束
	 */
	public static final String FLOW_OPERA_TYPE_END = "结束";
	
	/**
	 * 流程节点的操作类型-撤回
	 */
	public static final String FLOW_OPERA_TYPE_RECALL = "撤回";
	
	public static final String DAILY_TASK_OPERA_DOING = "doing";
	public static final String DAILY_TASK_OPERA_PAUSE = "pause";
	public static final String DAILY_TASK_OPERA_END = "end";
	
	/**
	 * WebSocket URL前缀，对应message_zh_CN.properties中配置的key
	 */
	public static final String WEBSOCKET_URL_PREFFIX = "websocket.url.";
	/**
	 * WebSocket 消息前缀，对应message_zh_CN.properties中配置的key
	 */
	public static final String WEBSOCKET_MSG_PREFFIX = "websocket.msg.";	
	/**
	 * WebSocket APPURL前缀，对应message_tixing.properties中配置的key
	 */
	public static final String APPSOCKET_URL_PREFFIX = "appsocket.url.";
	
	/**
	 * 字典数据 - 编码 - 产品类型
	 */
	public static final String DICTIONARIES_BM_CPLX = "CPLX";
	
	/**
	 * 字典编码-月度工作计划
	 */
	public static final String  DICTIONARIES_BM_XMLX_YDJH = "YDJH";
	
	/**
	 * 字典编码-年度工作计划
	 */
	public static final String  DICTIONARIES_BM_XMLX_NDJH = "NDJH";

	
	/**
	 * 字典数据 - 编码 - 目标详细类型
	 */
	public static final String DICTIONARIES_BM_MBXXLX = "MBXXLX";
	
	/**
	 * 字典数据 - 编码 - 部门地域
	 */
	public static final String DICTIONARIES_BM_BMDY = "BMDY";

	/**
	 * 配置维护人员的页面-绩效
	 */
	public static final String CONFIG_PAGE_PERFORMANCE = "performancePage";
	
	/**
	 * 配置直接考核人员-绩效评价页面
	 */
	public static final String CONFIG_PAGE_LEADER_DIRECT_ASSESS = "leaderDirectAssessPage";
	
	/**
	 * 配置维护人员的页面-员工培训
	 */
	public static final String CONFIG_PAGE_TRAINING = "empTrainingPage";
	
	/**
	 * 配置维护人员的页面-生产销售情况汇总-销售计划
	 */
	public static final String CONFIG_PAGE_PRODUCT_RECORD_SALEPLAN = "product_record_salePlan";
	
	/**
	 * 配置维护人员的页面-生产销售情况汇总-实际销售
	 */
	public static final String CONFIG_PAGE_PRODUCT_RECORD_ACTUALSALE = "product_record_actualSale";
	
	/**
	 * 配置维护人员的页面-生产销售情况汇总-生产计划
	 */
	public static final String CONFIG_PAGE_PRODUCT_RECORD_PRODUCEPLAN = "product_record_producePlan";
	
	/**
	 * 配置维护人员的页面-生产销售情况汇总-实际产量
	 */
	public static final String CONFIG_PAGE_PRODUCT_RECORD_ACTUALPRODUCE = "product_record_actualProduce";
	
	/**
	 * 配置维护人员的页面-生产销售情况汇总-产品入库
	 */
	public static final String CONFIG_PAGE_PRODUCT_RECORD_INSTORE = "product_record_inStore";
	
	/**
	 * 配置维护人员的页面-生产销售情况汇总-安全库存
	 */
	public static final String CONFIG_PAGE_PRODUCT_RECORD_SAFESTOREAMOUNT = "product_record_safeStoreAmount";
	
	/**
	 * 生产销售情况汇总-实际库存
	 */
	public static final String CONFIG_PAGE_PRODUCT_RECORD_ACTUALSTORE = "product_record_actualStore";
	
	/**
	 * 生产销售情况汇总-上月入库
	 */
	public static final String CONFIG_PAGE_PRODUCT_RECORD_LASTMONTHINSTORE = "product_record_lastMonthInStore";
	
	/**
	 * 生产销售情况汇总-本月合格的入库
	 */
	public static final String CONFIG_PAGE_PRODUCT_RECORD_CURRENT_MONTH_INSTORE = "product_record_currentMonthInStore";
	
	/**
	 * 生产销售情况汇总-上月留存
	 */
	public static final String CONFIG_PAGE_PRODUCT_RECORD_LASTMONTH_REMAIN = "product_record_lastMonthRemain";
	
	/**
	 * 生产销售情况汇总-非销售出库
	 */
	public static final String CONFIG_PAGE_PRODUCT_RECORD_NOTSALE_OUTPUT = "product_record_notSaleOutStore";
	
	
	/**
	 * 配置维护人员的页面-员工档案
	 */
	public static final String CONFIG_PAGE_RECORDING = "empRecordingPage";
	
	/**
	 * 配置维护人员的页面-薪酬
	 */
	public static final String CONFIG_PAGE_SALARY = "salaryPage";
	
	/**
	 * 车间考核-产线利润
	 */
	public static final String CONFIG_PAGE_PROFIT_INDEX = "profitIndexPage";
	
	/**
	 * 车间考核-产线设置
	 */
	public static final String CONFIG_PAGE_PRODCUT_LINE = "productLinePage";
	
	/**
	 * 车间考核-班组设置
	 */
	public static final String CONFIG_PAGE_WORKGROUP = "workGroupPage";
	
	/**
	 * 车间考核-车间考勤
	 */
	public static final String CONFIG_PAGE_EMP_WORK_HOUR = "empWorkHourPage";
	
	/**
	 * 车间考核-部门奖金
	 */
	public static final String CONFIG_PAGE_WORKSHOP_BONUS = "workshopBonusPage";
	
	/**
	 * 车间考核-所有产线考核查看
	 */
	public static final String CONFIG_PAGE_WORKSHOP_KPI_SHOW = "workshopKpiShowPage";
	
	/**
	 * 车间考核-分公司产线考核查看
	 */
	public static final String CONFIG_PAGE_WORKSHOP_KPI_SHOW_PART = "workshopKpiShowPart";
	
	/**
	 * 车间考核-车间考核退回
	 */
	public static final String CONFIG_PAGE_WORKSHOP_PERFORMANCE_REJECT = "workshopPerformanceReject";
	
	/**
	 * 维修工单-中止权限
	 */
	public static final String CONFIG_PAGE_REPAIR_ORDER_STOP = "repairOrderStop";

	/**
	 * 维修工单-导出权限-工单完成情况汇总
	 */
	public static final String CONFIG_PAGE_REPAIR_ORDER_FINISH_SUMMARY = "repairOrderFinishSummary";
	
	/**
	 * 表单流程-中止权限
	 */
	public static final String CONFIG_PAGE_FORM_FLOW_STOP = "formFLowStop";
	
	/**
	 * 表单流程-导出付款权限
	 */
	public static final String CONFIG_PAGE_FORM_PAY_LIST = "formPayList";
	
	/**
	 * 表单流程-采购表单中止权限
	 */
	public static final String CONFIG_PAGE_FORM_PURCHASE_STOP = "formPurchaseStop";
	
	/**
	 * 表单流程-生成采购合同的付款权限
	 */
	public static final String CONFIG_PAGE_FORM_PURCHASE_PAYMENT = "formPurchasePayment";
	
	/**
	 * 财务-预算维护权限
	 */
	public static final String CONFIG_PAGE_COST_BUDGET = "costBudgetPage";
	
	/**
	 * 财务-成本中心预算查看权限
	 */
	public static final String CONFIG_PAGE_VIEW_BUDGET_COST_DEPT = "viewBudgetCostDeptCode-";
	
	/**
	 * 财务-科目维护权限
	 */
	public static final String CONFIG_PAGE_COST_ITEM = "costItemPage";
	
	/**
	 * 财务-成本中心维护权限
	 */
	public static final String CONFIG_PAGE_COST_DEPT = "costDeptPage";
	
	/**
	 * bom数据-维护权限
	 */
	public static final String CONFIG_PAGE_BOM_ITEM = "bomItemPage";

	/**
	 * bom关联品牌-维护权限
	 */
	public static final String CONFIG_PAGE_BOM_BRAND = "bomBrandPage";
	
	/**
	 * 供应商数据-维护权限
	 */
	public static final String CONFIG_PAGE_SUPPLIER = "supplierPage";
	
	/**
	 * 可维护人员
	 */
	public static final String CHANGE_PERSON = "changePerson";
	
	/**
	 * 系统管理员
	 */
	public static final String IS_SYS_ADMIN = "isSysAdmin";
	
	/**
	 * 配置维护人员的页面-表单列表
	 */
	public static final String CONFIG_PAGE_FORM_DESIGN = "formDesignPage";
	
	/**
	 * 配置维护人员的页面-表单列表
	 */
	public static final String CONFIG_PAGE_FLOW_DESIGN = "flowDesignPage";
	
	/**
	 * 刷新页面登陆时间间隔（分钟）
	 */
	public static final String REFRESH_INTERVAL = "10";
	
	/**
	 * 表单实例的状态-正常进行
	 */
	public static final String FORM_STATUS_NORMAL = "NORMAL";
	
	/**
	 * 表单实例的状态-结束
	 */
	public static final String FORM_STATUS_END = "END";
	
	/**
	 * 表单实例的状态-删除
	 */
	public static final String FORM_STATUS_DELETE = "DELETE";
	
	/**
	 * 表单实例的状态-中止
	 */
	public static final String FORM_STATUS_STOP = "STOP";

	/**
	 * 维修工单中的维修区域
	 */
	public static final String FORM_SELECTION_REPAIR_AREA = "repairAreaList";
}
