package com.itlaobing.crm.workbench.dao;

import com.itlaobing.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    Integer save(TranHistory tranHistory);

    List<TranHistory> showHistoryList(String id);
}
