package com.itlaobing.crm.web.listener;

import com.itlaobing.crm.settings.domain.DicValue;
import com.itlaobing.crm.settings.service.DicService;
import com.itlaobing.crm.settings.service.impl.DicServiceImpl;
import com.itlaobing.crm.utils.ServiceFactory;
import com.itlaobing.crm.utils.SqlSessionUtil;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import java.util.*;

public class ServletContextListener implements javax.servlet.ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
//        System.out.println("数据字典添加到缓存开始");
        //获取全局作用域对象
        ServletContext application = sce.getServletContext();

        /*
            将数据字典存储到application中，分类存储
            Map<String,List<DicValue>>
            map.put("code",dvList1);
            map.put("code",dvList2);
            map.put("code",dvList3);
            ...
            ...
            拆解map，将map中的key和value传入到application的key和value
            application.setAttribute("code",dcList);
        * */
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImpl());
        Map<String,List<DicValue>> map = dicService.getDicList();
        Set<String> keys = map.keySet();
        for (String key : keys){
            //key就是code（字典的主键code）
            List<DicValue> list = map.get(key);
            application.setAttribute(key,list);
        }
//        System.out.println("数据字典添加到缓存结束");


        //--------------将交易阶段与对应的可能性查询出来-----------------
        /*
            对于数据量少且没有中文的清况下，我们可以把这种key-value的数据保存在properties文件中

            1.解析properties文件，获取keys
                两种方法：
                    Properties类
                    ResourceBundle : 一般使用这个(资源绑定器)它可以将Unicode编码转换为中文
            2.获取values
            3.将key和value保存在map集合中
            4.保存到application中
        * */
        //解析properties文件，获取keys,使用ResourceBundle时，需要将Properties文件的后缀名去掉
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        Map<String,String> pMap = new HashMap<>();
        //获取keys
        Enumeration<String> em = rb.getKeys();

        //获取values
        while(em.hasMoreElements()){
            //阶段
            String e = em.nextElement();
            //获取可能性
            String possibility = rb.getString(e);
            pMap.put(e,possibility);
        }
        //将pMap保存在服务器缓存中
        application.setAttribute("pMap",pMap);
    }
}
