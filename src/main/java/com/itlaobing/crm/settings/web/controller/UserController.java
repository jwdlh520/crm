package com.itlaobing.crm.settings.web.controller;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class UserController extends HttpServlet {
    //使用模版模式
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入用户控制器");
        String path = request.getServletPath();
        //注意：一定要在最前面加上"/"
        if ("/settings/user/xxx.do".equals(path)){
            //xxx(request,response);
        }else if("/settings/user/xxx.do".equals(path)){

        }else {

        }
    }
}
