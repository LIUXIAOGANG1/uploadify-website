<%@page import="java.text.MessageFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ include file="/resources/plugins/taglibs.jsp" %>
<%
	String pattern = (80 == request.getServerPort())? "{0}://{1}{2}" : "{0}://{1}:{3,number,#####}{2}";
	String basePath = MessageFormat.format(pattern, request.getScheme(), request.getServerName(), request.getContextPath(), request.getServerPort());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>uploadify</title>
		<!-- 新 Bootstrap 核心 CSS 文件 -->
	    <link rel="stylesheet" href="${ctx }/plugins/bootstrap/bootstrap.min.css">
	    <link rel="stylesheet" href="${ctx }/plugins/uploadify/uploadify-3.1.css">
	
	    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
	   	<script type="text/javascript" src="${ctx }/plugins/jquery/jquery-2.1.0.min.js"></script>
	    <script type="text/javascript" src="${ctx }/plugins/bootstrap/bootstrap.min.js"></script>
	    
		<script type="text/javascript" src="${ctx }/plugins/uploadify/jquery.uploadify-3.1.js"></script>
		<script type="text/javascript" src="${ctx }/plugins/uploadify/swfobject-3.1.js"></script>
		<script type="text/javascript" src="${ctx }/plugins/dwz/dwz.min.js"></script>
	</head>
	<body>
		<form:form action="" method="post" commandName="uploadify" role="form" cssClass="form-horizontal">
   				<div class="form-group">
		             <label for="picture" class="col-sm-2 control-label">产品图片：</label>
		             <div class="col-sm-10">
						<img alt="" src="" id="showimg" width="150" height="100" style="width: 150px; height: 100px" /> 
		                 <form:input path="picture" class="form-control" type="hidden"/>
		             </div>
				</div>
				
				<div class="form-group">
		             <label for="fileQueue" class="col-sm-2 control-label"> </label>
					<div class="col-sm-10">
						<div id="fileQueue" style="display: none;"></div>
						<input id="uploadfile" type="file" name="uploadfile" />
					</div>
				</div>
		</form:form>
	</body>
	
<script type="text/javascript">
	$(document).ready(function() {
		$("#uploadfile").uploadify({
			'swf' : '${ctx}/plugins/uploadify/uploadify-3.1.swf',
			'uploader' : '${ctx}/upload.html',
			'auto' : true,
			'queueID' : 'fileQueue',
			'multi' : false,
			'fileTypeExts' : '*.jpg;*.jpeg;*.png;*.gif:*.bmp', //可上传文件                
			'fileTypeDesc' : '*.jpg;*.jpeg;*.png;*.gif:*.bmp', //显示的文件类型
			'buttonText' : 'upload',
			'fileSizeLimit' : '200KB',
			'onUploadSuccess': function (fileObj, response, data) {  
				var json = DWZ.jsonEval(response);
				DWZ.ajaxDone(json);
				if (json.statusCode == undefined) {
					json = eval("(" + json + ")");
				}
				var imgpath = json.forwardUrl;
				$("#picture").val(imgpath);
				$("#showimg").attr("src", '${ctx}'+imgpath);
			}
		});
	});
</script>
</html>