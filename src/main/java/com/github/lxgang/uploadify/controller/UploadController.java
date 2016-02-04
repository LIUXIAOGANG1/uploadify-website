package com.github.lxgang.uploadify.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.github.lxgang.uploadify.beans.Uploader;

@Controller
public class UploadController {
	Logger logger = LoggerFactory.getLogger(UploadController.class);
	
	@Value("${upload.url}")
	private String ctxPath;
	
    @RequestMapping(value = "/")
    public ModelAndView index() {
    	ModelAndView mav = new ModelAndView("index");
    	Uploader uploader = new Uploader();
    	
    	mav.addObject("uploadify", uploader);
        return mav;
    }
    
    @RequestMapping("/upload.html")
    public void upload(HttpServletRequest request, HttpServletResponse response) {
        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
        
        Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();    
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");  
        String ymd = sdf.format(new Date());  
        ctxPath += ymd + "/";  
        //创建文件夹  
        File file = new File(ctxPath);    
        if (!file.exists()) {    
            file.mkdirs();    
        }    
        String fileName = null;
        String path=null;
        for (Map.Entry<String, MultipartFile> entity : fileMap.entrySet()) {    
            // 上传文件名    
            MultipartFile mf = entity.getValue();    
            fileName = mf.getOriginalFilename();  
            
            String uuid = UUID.randomUUID().toString().replaceAll("\\-", "");// 返回一个随机UUID。
            String suffix = fileName.indexOf(".") != -1 ? fileName.substring(fileName.lastIndexOf("."), fileName.length()) : null;

            String newFileName = uuid + (suffix != null ? suffix : "");// 构成新文件名。
            
            File uploadFile = new File(ctxPath + newFileName);    
            try {  
                FileCopyUtils.copy(mf.getBytes(), uploadFile); 
                path =ctxPath + newFileName;
	        } catch (IOException e) {  
	            e.printStackTrace();  
	        }    
        }   
        
        try {
    	    response.setCharacterEncoding("utf8");
    		PrintWriter pw = response.getWriter();
//			path ="{ \"statusCode\":\""+200+"\", \"message\":\""+"&#x4E0A;&#x4F20;&#x6210;&#x529F;!"+"\", \"navTabId\":\"\", \"callbackType\":\"closeCurrent\", \"forwardUrl\":\""+path+"\" } ";
			
			path ="{ \"forwardUrl\":\""+path+"\" } ";
			path = "('"+path+"')";
    		pw.println(path);
    		pw.close();
		} catch (Exception e) {
		}
           
		return;
    }
}
