package com.itlaobing.crm.settings.service.impl;

import com.itlaobing.crm.exception.LoginException;
import com.itlaobing.crm.settings.dao.UserDao;
import com.itlaobing.crm.settings.domain.User;
import com.itlaobing.crm.settings.service.UserService;
import com.itlaobing.crm.utils.DateTimeUtil;
import com.itlaobing.crm.utils.SqlSessionUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.HashMap;
import java.util.Map;

public class UserServiceImpl implements UserService {
    //动态代理
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String,String> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userDao.login(map);
        //判断账号密码是否正确
        if (user == null){
            throw new LoginException("账号密码错误");
        }

        //验证失效时间
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (currentTime.compareTo(expireTime) >= 0){
            throw new LoginException("账号已失效");
        }

        //验证账号状态
        String lockState = user.getLockState();
        //需要以常量调用equals方法，这个不会出现空指针异常
        if ("0".equals(lockState)){
            throw new LoginException("账号已锁定，请联系管理员");
        }

        //验证ip地址
        String allowIps = user.getAllowIps();
        if (!allowIps.contains(ip)){
            throw new LoginException("ip地址禁止访问");
        }
        return user;
    }
}
