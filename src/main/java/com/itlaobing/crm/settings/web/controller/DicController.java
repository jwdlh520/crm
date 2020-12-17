package com.itlaobing.crm.settings.web.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DicController extends HttpServlet {
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        //注意：一定要在最前面加上"/"
        if ("/settings/dic/xxx.do".equals(path)) {
            //xxx(request, response);
        }
    }
}
