package com.itlaobing.crm.settings.web.controller;

import com.itlaobing.crm.settings.domain.User;
import com.itlaobing.crm.settings.service.UserService;
import com.itlaobing.crm.settings.service.impl.UserServiceImpl;
import com.itlaobing.crm.utils.MD5Util;
import com.itlaobing.crm.utils.PrintJson;
import com.itlaobing.crm.utils.ServiceFactory;
import com.itlaobing.crm.utils.SqlSessionUtil;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    //使用模版模式
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        //注意：一定要在最前面加上"/"
        if ("/settings/user/login.do".equals(path)){
            login(request,response);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response){
        System.out.println("进入登陆操作");
        //获取参数
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        loginPwd = MD5Util.getMD5(loginPwd);
        System.out.println(loginPwd);
        //获取ip地址
        String ip = request.getRemoteAddr();
        //获取动态代理对象,以后统一用代理类对象
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        System.out.println("------------");
        //如果出现异常，由于使用了动态代理，service层抛出的异常会在invocationHandler的实现类中就处理了，此时异常就不能抛出到这里，所
        //在invocationHandler的catch中需要将异常继续向上抛出，使用 "throw e.getCause()";
        try{
            User user = userService.login(loginAct,loginPwd,ip);
            //查询到了，传输给前端的信息为：success:true
            request.getSession().setAttribute("user",user);
            PrintJson.printJsonFlag(response,true);
        }catch (Exception e){
            //如果到了这里，说明没有查询到，这时候需要向前端传输错误信息
            String msg = e.getMessage();
            //将错误信息封装在map集合中，转换为json对象
            Map<String,Object> map = new HashMap<>();
            map.put("success",false);
            map.put("msg",msg);

            PrintJson.printJsonObj(response,map);
        }
    }
}
