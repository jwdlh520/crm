package com.itlaobing.crm.settings.service;

import com.itlaobing.crm.exception.LoginException;
import com.itlaobing.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> queryUserAll();
}
