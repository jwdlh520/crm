package com.itlaobing.workbench;

import com.itlaobing.crm.utils.ServiceFactory;
import com.itlaobing.crm.utils.SqlSessionUtil;
import com.itlaobing.crm.utils.UUIDUtil;
import com.itlaobing.crm.workbench.dao.ActivityDao;
import com.itlaobing.crm.workbench.domain.Activity;
import com.itlaobing.crm.workbench.service.ActivityService;
import com.itlaobing.crm.workbench.service.impl.ActivityServiceImpl;
import org.apache.ibatis.session.SqlSession;
import org.junit.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class ActivityTest {
    /*
    *   junit测试：单元测试
    * */
    @Test
    public void testSave(){
        Activity activity = new Activity();
        activity.setId(UUIDUtil.getUUID());
        activity.setName("Junit测试");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = activityService.save(activity);
        /*
        *   断言的方式(使用较少)
        * */
        Assert.assertEquals(true,flag);

        /*
        *   正常处理方式，使用较多
        * */
        System.out.println(flag);
    }
    
}
