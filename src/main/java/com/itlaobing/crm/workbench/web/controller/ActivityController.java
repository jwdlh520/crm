package com.itlaobing.crm.workbench.web.controller;

import com.itlaobing.crm.settings.domain.User;
import com.itlaobing.crm.settings.service.UserService;
import com.itlaobing.crm.settings.service.impl.UserServiceImpl;
import com.itlaobing.crm.utils.PrintJson;
import com.itlaobing.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ActivityController extends HttpServlet {
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入活动操作");
        String path = request.getServletPath();
        if ("/workbench/activity/QueryUserAll.do".equals(path)){
            List<User> uList = queryUserAll();
            System.out.println(uList.toString());
            PrintJson.printJsonObj(response,uList);
        }
    }
    private List<User> queryUserAll() {
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> users = userService.queryUserAll();
        return users;
    }
}
