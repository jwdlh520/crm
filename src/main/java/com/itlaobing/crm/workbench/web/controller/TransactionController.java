package com.itlaobing.crm.workbench.web.controller;

import com.itlaobing.crm.settings.domain.User;
import com.itlaobing.crm.settings.service.UserService;
import com.itlaobing.crm.settings.service.impl.UserServiceImpl;
import com.itlaobing.crm.utils.DateTimeUtil;
import com.itlaobing.crm.utils.PrintJson;
import com.itlaobing.crm.utils.ServiceFactory;
import com.itlaobing.crm.utils.UUIDUtil;
import com.itlaobing.crm.vo.PaginationVO;
import com.itlaobing.crm.workbench.domain.*;
import com.itlaobing.crm.workbench.service.ActivityService;
import com.itlaobing.crm.workbench.service.ClueService;
import com.itlaobing.crm.workbench.service.CustomerService;
import com.itlaobing.crm.workbench.service.TransactionService;
import com.itlaobing.crm.workbench.service.impl.ActivityServiceImpl;
import com.itlaobing.crm.workbench.service.impl.ClueServiceImpl;
import com.itlaobing.crm.workbench.service.impl.CustomerServiceImpl;
import com.itlaobing.crm.workbench.service.impl.TransactionServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TransactionController extends HttpServlet {
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入交易模块");
        String path = request.getServletPath();
        if ("/workbench/transaction/add.do".equals(path)) {
            add(request, response);
        } else if ("/workbench/transaction/getCustomerName.do".equals(path)) {
            getCustomerName(request, response);
        } else if ("/workbench/transaction/save.do".equals(path)) {
            save(request, response);
        }else if ("/workbench/transaction/getTranList.do".equals(path)) {
            getTranList(request, response);
        }else if ("/workbench/transaction/detail.do".equals(path)) {
            detail(request, response);
        }else if ("/workbench/transaction/showHistoryList.do".equals(path)) {
            showHistoryList(request, response);
        }else if ("/workbench/transaction/changeStage.do".equals(path)) {
            changeStage(request, response);
        }else if ("/workbench/transaction/echarts.do".equals(path)) {
            echartsShow(request, response);
        }
    }


    /*
    *   漏斗图
    * */
    private void echartsShow(HttpServletRequest request, HttpServletResponse response) {
        TransactionService transactionService = (TransactionService) ServiceFactory.getService(new TransactionServiceImpl());
        Map<String,Object> map = transactionService.echartsShow();
        PrintJson.printJsonObj(response,map);
    }


    /*
    *   修改交易阶段
    * */
    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String stage = request.getParameter("stage");
        String money = request.getParameter("money");
        String expectedDate = request.getParameter("expectedDate");
        //修改时间  修改人
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        Tran tran = new Tran();
        tran.setId(id);
        tran.setStage(stage);
        tran.setMoney(money);
        tran.setExpectedDate(expectedDate);
        tran.setEditTime(editTime);
        tran.setEditBy(editBy);
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        tran.setPossibility(pMap.get(stage));
        TransactionService transactionService = (TransactionService) ServiceFactory.getService(new TransactionServiceImpl());
        boolean flag = transactionService.changeStage(tran);
        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("tran",tran);
        PrintJson.printJsonObj(response,map);
    }


    /*
    *   获取交易历史列表
    * */
    private void showHistoryList(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        TransactionService transactionService = (TransactionService) ServiceFactory.getService(new TransactionServiceImpl());
        List<TranHistory> historyList = transactionService.showHistoryList(id);
        for (TranHistory tranHistory : historyList){
            String stage = tranHistory.getStage();
            Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
            tranHistory.setPossibility(pMap.get(stage));
        }
        PrintJson.printJsonObj(response,historyList);
    }


    /*
    *   转到详细信息页
    * */
    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        TransactionService transactionService = (TransactionService) ServiceFactory.getService(new TransactionServiceImpl());
        Tran tran = transactionService.getById(id);

        //处理可能性
        /*
            在服务器缓存中获取pMap(阶段对应的可能性)
            获取阶段值
                1.单独将possibility存入到request域中，使用EL表达式获取
                2.使用VO,类变量为Tran和possibility
                    适用于增加了多个属性，开销较大
                3.扩展Tran的属性。当新增的属性不多的时候，我们可以在原来的类中添加属性。如果新增属性太多的话，不能使用这个方法，会破坏原阿来类的结构
        * */
        String stage = tran.getStage();
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(stage);
        tran.setPossibility(possibility);
        request.setAttribute("tran",tran);
        //使用请求转发
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    /*
    *   获取交易列表
    * */
    private void getTranList(HttpServletRequest request, HttpServletResponse response) {
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        String owner = request.getParameter("owner");
        String customerName = request.getParameter("customerName");
        String name = request.getParameter("name");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String contactName = request.getParameter("contactName");
        Integer pageNo = Integer.valueOf(pageNoStr);
        Integer pageSize = Integer.valueOf(pageSizeStr);
        Integer skipNo = (pageNo - 1) * pageSize;
        Map<String,Object> map = new HashMap<>();
        map.put("onwer",owner);
        map.put("customerName",customerName);
        map.put("name",name);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contactName",contactName);
        map.put("skipNo",skipNo);
        map.put("pageSize",pageSize);
        TransactionService transactionService = (TransactionService) ServiceFactory.getService(new TransactionServiceImpl());
        PaginationVO<Tran> paginationVO = transactionService.getTranList(map);
        PrintJson.printJsonObj(response,paginationVO);
    }


    /*
     *   添加交易操作
     * */
    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerName = request.getParameter("customerName"); //这个客户名称传入到service层中
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        //当前系统时间
        String createTime = DateTimeUtil.getSysTime();
        //当前登录用户
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

        Tran tran = new Tran();
        tran.setId(id);
        tran.setOwner(owner);
        tran.setMoney(money);
        tran.setName(name);
        tran.setExpectedDate(expectedDate);
        tran.setStage(stage);
        tran.setType(type);
        tran.setSource(source);
        tran.setActivityId(activityId);
        tran.setContactsId(contactsId);
        tran.setCreateTime(createTime);
        tran.setCreateBy(createBy);
        tran.setDescription(description);
        tran.setContactSummary(contactSummary);
        tran.setNextContactTime(nextContactTime);

        TransactionService transactionService = (TransactionService) ServiceFactory.getService(new TransactionServiceImpl());
        boolean flag = transactionService.save(tran,customerName);
        if (flag){
            //index.jsp页面
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        }
    }

    /*
     *   模糊查询姓名，自动补全
     * */
    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        String name = request.getParameter("name");
        List<String> nlist = customerService.getCustomerName(name);
        PrintJson.printJsonObj(response, nlist);
    }

    /*
     *   创建按钮点击，获取用户列表
     * */
    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> ulist = userService.queryUserAll();
        request.setAttribute("ulist", ulist);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request, response);
    }


}
