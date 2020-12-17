package com.itlaobing.crm.workbench.dao;

import com.itlaobing.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    Customer getCustomerByName(String company);

    Integer save(Customer customer);

    List<String> getCustomerName(String name);
}
