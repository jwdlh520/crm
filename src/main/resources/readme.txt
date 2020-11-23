 ajax请求：
    $.ajax({
				url : "",
				dataType : "json",
				type : "get",
				data : {

				}
				success : function (data) {

				}
			});

jsp绝对路径配置：
    <%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
    <%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <!DOCTYPE html>
    <html>
    <head>
    	<base href=" <%=basePath%>">