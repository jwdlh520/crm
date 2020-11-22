package com.itlaobing.crm.web.filter;

import com.itlaobing.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        //需要获取到HttpServletRequest和HttpServletReponse，因为需要获取到Session对象，这个是在子类HttpServletRequest实现的
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        String path = request.getServletPath();
        if ("/settings/user/login.do".equals(path) || "/login.jsp".equals(path)) {
            filterChain.doFilter(servletRequest, servletResponse);
        } else {
            //判断session域的user对象是否为空来判断有没有登陆过
            User user = (User) request.getSession().getAttribute("user");
            if (user != null) {
                //登陆过，放行
                filterChain.doFilter(servletRequest, servletResponse);
            } else {
                /*
                 * 请求转发到登陆页面
                 *   请求转发和重定向
                 *       区别：
                 *            请求转发：路径为特殊的路径写法：内部路径 /login.jsp,不加项目名
                 *            重定向向浏览器发送一个地址，让浏览器再次发送请求，将页面修改。请求转发会让浏览器的地址变为指定的页面
                 *            路径为传统的绝对路径的写法：/crm/login.jsp-->/项目名/资源名
                 *              request.getContextPath():获取项目名
                 * */
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        }
    }
}
