package com.itlaobing.crm.workbench.web.controller;

import com.itlaobing.crm.settings.domain.User;
import com.itlaobing.crm.settings.service.UserService;
import com.itlaobing.crm.settings.service.impl.UserServiceImpl;
import com.itlaobing.crm.utils.*;
import com.itlaobing.crm.vo.PaginationVO;
import com.itlaobing.crm.workbench.dao.Activity_remarkDao;
import com.itlaobing.crm.workbench.domain.Activity;
import com.itlaobing.crm.workbench.domain.ActivityRemark;
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
        } else if ("/workbench/activity/delete.do".equals(path)) {
            delete(request, response);
        } else if ("/workbench/activity/get.do".equals(path)) {
            getUserAndActivity(request, response);
        } else if ("/workbench/activity/update.do".equals(path)) {
            update(request, response);
        }else if ("/workbench/activity/detail.do".equals(path)) {
            detail(request, response);
        }else if ("/workbench/activity/remarkList.do".equals(path)) {
           remarkList(request, response);
        }else if ("/workbench/activity/delRemark.do".equals(path)) {
            delRemark(request, response);
        }else if ("/workbench/activity/saveRemark.do".equals(path)) {
            saveRemark(request, response);
        }else if ("/workbench/activity/updateRemark.do".equals(path)) {
            updateRemark(request, response);
        }
    }

    /*
        修改备注
    * */
    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改备注操作");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";
        ActivityRemark remark = new ActivityRemark();
        remark.setId(id);
        remark.setNoteContent(noteContent);
        remark.setEditTime(editTime);
        remark.setEditBy(editBy);
        remark.setEditFlag(editFlag);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.updateRemark(remark);
        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("remark",remark);
        PrintJson.printJsonObj(response,map);
    }

    /*
        添加备注
    * */
    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到添加备注操作");
        String id = UUIDUtil.getUUID();
        String noteContent = request.getParameter("noteContent");
        String activityId = request.getParameter("activityId");
        String createTime = DateTimeUtil.getSysTime();
        //当前登录用户
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String editFlag = "0";
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setCreateTime(createTime);
        activityRemark.setCreateBy(createBy);
        activityRemark.setActivityId(activityId);
        activityRemark.setEditFlag(editFlag);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.saveRemark(activityRemark);
        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("activityRemark",activityRemark);
        PrintJson.printJsonObj(response,map);
    }

    /*
        删除备注
    * */
    private void delRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除备注操作");
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.delRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    /*
        获取备注信息列表
    * */
    private void remarkList(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<ActivityRemark> remarks = activityService.remarkList(id);
        PrintJson.printJsonObj(response,remarks);
    }

    /*
        活动详细信息页
    * */
    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity = activityService.detail(id);
        request.setAttribute("activity",activity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);

    }

    /*
        更新活动信息
    * */
    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到更新活动操作");
        //获取参数
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.update(activity);
        PrintJson.printJsonFlag(response,flag);
    }

    /*
        获取用户列表和指定的活动对象
    * */
    private void getUserAndActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改活动信息的操作");
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Map<String, Object> map = activityService.getUserAndActivity(id);
        PrintJson.printJsonObj(response, map);
    }

    /*
     * 删除活动信息
     * */
    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行市场活动删除操作");
        String ids[] = request.getParameterValues("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.delete(ids);
        PrintJson.printJsonFlag(response, flag);
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
        Integer skipNo = (pageNo - 1) * pageSize;
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
        PrintJson.printJsonObj(response, paginationVO);
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
