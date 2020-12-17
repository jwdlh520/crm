package com.itlaobing.crm.workbench.service;

import com.itlaobing.crm.vo.PaginationVO;
import com.itlaobing.crm.workbench.domain.Tran;
import com.itlaobing.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    boolean save(Tran tran, String customerName);

    PaginationVO<Tran> getTranList(Map<String, Object> map);

    Tran getById(String id);

    List<TranHistory> showHistoryList(String id);

    boolean changeStage(Tran tran);

    Map<String, Object> echartsShow();
}
