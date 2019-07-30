package com.mfw.entity.bdata;

/**
 * 文件类
 * @author  作者 于亚洲
 * @date 创建时间：2015年12月18日 下午15:23:59
 */
public class DocFile {
	private Integer ID; //文件id
	private String FILENAME; //文件编码
	private String PATH; //文件名称
	private String DOCUMENT_ID; //文件标识


	public Integer getID() {
		return ID;
	}
	public void setID(Integer iD) {
		ID = iD;
	}
	public String getFILENAME() {
		return FILENAME;
	}
	public void setFILENAME(String fILENAME) {
		FILENAME = fILENAME;
	}
	public String getPATH() {
		return PATH;
	}
	public void setPATH(String pATH) {
		PATH = pATH;
	}
	public String getDOCUMENT_ID() {
		return DOCUMENT_ID;
	}
	public void setDOCUMENT_ID(String dOCUMENT_ID) {
		DOCUMENT_ID = dOCUMENT_ID;
	}
}
