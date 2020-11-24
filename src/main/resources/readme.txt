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

活动信息的添加：
    String id = UUIDUtil.getUUID();
    String owner = request.getParameter("owner");
    String name = request.getParameter("name");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    String cost = request.getParameter("cost");
    String description = request.getParameter("description");
    //当前系统时间
    String createTime = DateTimeUtil.getSysTime();
    //当前登录用户
    String createBy = ((User) request.getSession().getAttribute("user")).getName();
    String editTime = request.getParameter("");
    String editBy = request.getParameter("");