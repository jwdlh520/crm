package com.itlaobing.crm.settings.dao;

import com.itlaobing.crm.settings.domain.User;

import java.util.Map;

public interface UserDao {
    User login(Map<String, String> map);
}
