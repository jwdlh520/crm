package com.itlaobing.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

public class EncodingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        //接受post请求设定字符编码
        servletRequest.setCharacterEncoding("UTF-8");

        //响应对象响应请求设置字符集编码
        servletResponse.setContentType("text/html;charset=utf-8");

        //释放请求
        filterChain.doFilter(servletRequest,servletResponse);
    }
}
