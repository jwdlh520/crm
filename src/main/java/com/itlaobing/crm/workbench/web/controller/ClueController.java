package com.itlaobing.crm.workbench.web.controller;

import com.itlaobing.crm.settings.domain.User;
import com.itlaobing.crm.settings.service.UserService;
import com.itlaobing.crm.settings.service.impl.UserServiceImpl;
import com.itlaobing.crm.utils.*;
import com.itlaobing.crm.vo.PaginationVO;
import com.itlaobing.crm.workbench.domain.*;
import com.itlaobing.crm.workbench.service.ActivityService;
import com.itlaobing.crm.workbench.service.ClueService;
import com.itlaobing.crm.workbench.service.impl.ActivityServiceImpl;
import com.itlaobing.crm.workbench.service.impl.ClueServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class ClueController extends HttpServlet {
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入线索模块");
        String path = request.getServletPath();
        if ("/workbench/clue/QueryUserAll.do".equals(path)) {
            QueryUserAll(request, response);
        }else if("/workbench/clue/save.do".equals(path)){
            save(request,response);
        }else if("/workbench/clue/detail.do".equals(path)){
            detail(request,response);
        }else if("/workbench/clue/activityList.do".equals(path)){
            activityList(request,response);
        }else if("/workbench/clue/dissociate.do".equals(path)){
            dissociate(request,response);
        }else if("/workbench/clue/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/workbench/clue/bund.do".equals(path)){
            bund(request,response);
        }else if("/workbench/clue/pageListByName.do".equals(path)){
            pageListByName(request,response);
        }else if("/workbench/clue/convert.do".equals(path)){
            convert(request,response);
        }
    }

    /*
    *   转换操作
    * */
    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入线索转换的操作");
        //判断是否需要创建交易
        String flag = request.getParameter("flag");
        String clueId = request.getParameter("clueId");
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        Tran tran = null;
        if ("true".equals(flag)){
            //需要创建交易
            tran = new Tran();
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String activityId = request.getParameter("activityId");
            String createTime = DateTimeUtil.getSysTime();
            tran.setId(UUIDUtil.getUUID());
            tran.setMoney(money);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setStage(stage);
            tran.setActivityId(activityId);
            tran.setCreateTime(createTime);
            tran.setCreateBy(createBy);
        }

        //如果不需要创建交易，tran为null，在业务层中判断
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());

        /*
            关于参数：
                1.clueId(必须)
                2.tran(必须)
                3.createBy:创建人  创建人只能在session域中获取user再获取name，这就必须要有request对象。
                                  但是如果我们向方法中传递request对象，不太合理，主要两点：
                                    (1).request对象太大，只需要取createBy，不需要传request对象
                                    (2).我们使用MVC开发模型，所以业务层就只处理业务，不参与参数的获取。
        * */
        boolean flag1 = clueService.convert(clueId,tran,createBy);
        response.sendRedirect(request.getContextPath() + "/workbench/clue/index.jsp");
    }

    /*
    *   获取活动列表
    * */
    private void pageListByName(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("name");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> list = activityService.pageListByName(name);
        PrintJson.printJsonObj(response,list);
    }


    /*
    *   关联操作
    * */
    private void bund(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到关联操作");
        String clueId = request.getParameter("clueId");
        String[] ids = request.getParameterValues("id");
        List<ClueActivityRelation> list = new ArrayList<>();
        for (String id : ids){
            ClueActivityRelation car = new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setClueId(clueId);
            car.setActivityId(id);
            list.add(car);
        }
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = clueService.bund(list);
        PrintJson.printJsonFlag(response,flag);
    }


    /*
    *   获取活动列表
    * */
    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        String searchText = request.getParameter("searchText");
        String clueId = request.getParameter("clueId");
        Map<String,Object> map = new HashMap<>();
        map.put("searchText",searchText);
        map.put("clueId",clueId);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> list = activityService.pageListByConditionAndNotClueId(map);
        PrintJson.printJsonObj(response,list);
    }

    /*
    *   解除关联
    * */
    private void dissociate(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = clueService.dissociate(id);
        PrintJson.printJsonFlag(response,flag);
    }


    /*
    *   获取线索关联的市场活动
    * */
    private void activityList(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id"); //线索的id
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList = activityService.activityList(id);
        PrintJson.printJsonObj(response,aList);
    }

    /*
    *   获取线索信息
    * */
    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = clueService.detail(id);
        //保存到reques域中
        request.setAttribute("clue",clue);
        //请求转发到detail.jsp页面
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }

    /*
    *   保存备注
    * */
    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入线索保存操作");
        String address = request.getParameter("address");
        String appellation = request.getParameter("appellation");
        String company = request.getParameter("company");
        String contactSummary = request.getParameter("contactSummary");
        String createBy = ((User)(request.getSession().getAttribute("user"))).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String id = UUIDUtil.getUUID();
        String job = request.getParameter("job");
        String mphone = request.getParameter("mphone");
        String nextContactTime = request.getParameter("nextContactTime");
        String owner = request.getParameter("owner");
        String phone = request.getParameter("phone");
        String source = request.getParameter("source");
        String state = request.getParameter("state");
        String website = request.getParameter("website");

        Clue clue = new Clue();
        clue.setId(id);
        clue.setAddress(address);
        clue.setAppellation(appellation);
        clue.setCompany(company);
        clue.setContactSummary(contactSummary);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);
        clue.setDescription(description);
        clue.setEmail(email);
        clue.setFullname(fullname);
        clue.setJob(job);
        clue.setMphone(mphone);
        clue.setNextContactTime(nextContactTime);
        clue.setOwner(owner);
        clue.setPhone(phone);
        clue.setSource(source);
        clue.setState(state);
        clue.setWebsite(website);

        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag = clueService.save(clue);
        PrintJson.printJsonFlag(response,flag);
    }

    /*
    *   获取用户信息列表
    * */
    private void QueryUserAll(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索模块操作");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.queryUserAll();
        PrintJson.printJsonObj(response,userList);
    }
}
