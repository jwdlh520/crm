package com.itlaobing.crm.workbench.service.impl;

import com.itlaobing.crm.utils.SqlSessionUtil;
import com.itlaobing.crm.workbench.dao.CustomerDao;
import com.itlaobing.crm.workbench.service.CustomerService;

import java.util.List;

public class CustomerServiceImpl implements CustomerService {
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

    @Override
    public List<String> getCustomerName(String name) {
        List<String> nlist = customerDao.getCustomerName(name);
        return nlist;
    }
}
