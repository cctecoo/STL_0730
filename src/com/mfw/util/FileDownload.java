package com.mfw.util;

import java.io.*;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 下载文件 创建人：mfw 创建时间：2014年12月23日
 * 
 * @version
 */
public class FileDownload {

	/**
	 * @param response
	 * @param filePath //文件完整路径(包括文件名和扩展名)
	 * @param fileName //下载后看到的文件名
	 * @return 文件名
	 */
	public static void fileDownload(final HttpServletResponse response, String filePath, String fileName) throws Exception {

		byte[] data = FileUtil.toByteArray2(filePath);
		fileName = URLEncoder.encode(fileName, "UTF-8");
		response.reset();
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
		response.addHeader("Content-Length", "" + data.length);
		response.setContentType("application/octet-stream;charset=UTF-8");
		OutputStream outputStream = new BufferedOutputStream(response.getOutputStream());;
		try {
			outputStream.write(data);
			outputStream.flush();
		} catch (Exception e) {
			outputStream.close();
			throw e;
		}
		outputStream.close();
		response.flushBuffer();
	}

	/**
	 * 打包下载多个附件
     * @param fileName 以逗号分隔下载的附件名称
	 */
	public static void zipFileDownload(String fileName, HttpServletRequest request,
							HttpServletResponse response) throws Exception {
        String zipName = String.valueOf(new Date().getTime()) + "打包下载.rar";
        zipName = new String(zipName.getBytes(), "ISO-8859-1");
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.setHeader("Content-Disposition","attachment; filename="+zipName);
        ZipOutputStream out = new ZipOutputStream(response.getOutputStream());
        try {
            //以逗号分隔下载的附件名称
            String[] arr = fileName.split(",");
            String rootFilePath = Tools.getRootFilePath();
            for(int i=0; i<arr.length; i++){
                String path = rootFilePath + Const.FILEPATHTASK + "\\" + arr[i];
                FileZip.doCompress(path, out);
                response.flushBuffer();
            }
        } catch (Exception e) {
            throw e;
        }finally{
            out.close();
        }
	}

}
