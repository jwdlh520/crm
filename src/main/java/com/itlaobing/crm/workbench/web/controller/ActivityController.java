package com.itlaobing.crm.workbench.web.controller;

import com.itlaobing.crm.settings.domain.User;
import com.itlaobing.crm.settings.service.UserService;
import com.itlaobing.crm.settings.service.impl.UserServiceImpl;
import com.itlaobing.crm.utils.*;
import com.itlaobing.crm.vo.PaginationVO;
import com.itlaobing.crm.workbench.domain.Activity;
import com.itlaobing.crm.workbench.service.ActivityService;
import com.itlaobing.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityController extends HttpServlet {
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入活动操作");
        String path = request.getServletPath();
        if ("/workbench/activity/QueryUserAll.do".equals(path)) {
            queryUserAll(request, response);
        } else if ("/workbench/activity/save.do".equals(path)) {
            //id自动生成
            save(request, response);
        } else if ("/workbench/activity/pageList.do".equals(path)) {
            pageList(request, response);
        }
    }

    /*
     * 查询所有市场活动
     * */
    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        /*
            分页查询：
                mysql中使用limit进行分页操作：limit a,b
                解释：跳过前面a条记录查询b条记录
                a = (pageNo-1)*pageSize
                b = pageSize
         * */
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        //将pageNo和pageSize转为Integer类型
        Integer pageNo = Integer.valueOf(pageNoStr);
        Integer pageSize = Integer.valueOf(pageSizeStr);
        Integer skipNo = (pageNo-1)*pageSize;
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        /*
            怎么将这些数据打包？
                map还是domain？-->map
            返回类型？
                我们需要total:查询的总条数 pageList:[{活动信息1},{活动信息2},...]
                Map:
                    map.put("total":total);
                    map.put("dataList":dataList);
                    PrintJSON.print(response,map);
                VO:
                    属性：map的key
                    PaginationVO<T>
                        private Integer total;
                        private List<T> dataList;
                    使用范型：使用时向T传值，T的值是什么，List<T>中的T就是什么
        * */
        Map<String, Object> map = new HashMap<>();
        map.put("skipNo", skipNo);
        map.put("pageSize", pageSize);
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);

        PaginationVO<Activity> paginationVO = activityService.pageList(map);
        PrintJson.printJsonObj(response,paginationVO);
    }

    /*
     * 查询所有用户
     * */
    private void queryUserAll(HttpServletRequest request, HttpServletResponse response) {
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> users = userService.queryUserAll();
        PrintJson.printJsonObj(response, users);
    }

    /*
     * 保存市场活动表
     * */
    private void save(HttpServletRequest request, HttpServletResponse response) {
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
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.save(activity);
        PrintJson.printJsonFlag(response, flag);
    }
}
