package com.itlaobing.crm.workbench.dao;

import com.itlaobing.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    Integer save(Tran tran);

    Integer getAllCount(Map<String, Object> map);

    List<Tran> getTranList(Map<String, Object> map);

    Tran getById(String id);

    Integer changeStage(Tran tran);

    Integer getTotal();

    List<Map<String, Object>> echartsShow();
}
