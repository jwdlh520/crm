package com.itlaobing.crm.workbench.service.impl;

import com.itlaobing.crm.utils.SqlSessionUtil;
import com.itlaobing.crm.workbench.dao.ActivityDao;
import com.itlaobing.crm.workbench.service.ActivityService;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao dao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
}
