package com.itlaobing.crm.settings.service.impl;

import com.itlaobing.crm.settings.dao.UserDao;
import com.itlaobing.crm.settings.service.UserService;
import com.itlaobing.crm.utils.SqlSessionUtil;
import org.apache.ibatis.session.SqlSession;

public class UserServiceImpl implements UserService {
    //动态代理
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
}
