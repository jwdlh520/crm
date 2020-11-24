package com.itlaobing.crm.workbench.service.impl;

import com.itlaobing.crm.utils.SqlSessionUtil;
import com.itlaobing.crm.workbench.dao.ActivityDao;
import com.itlaobing.crm.workbench.domain.Activity;
import com.itlaobing.crm.workbench.service.ActivityService;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao dao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);

    @Override
    public boolean save(Activity activity) {
        Integer count = dao.save(activity);
        boolean flag = true;
        if (count != 1){
            flag = false;
        }
        return flag;
    }
}
