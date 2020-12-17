package com.itlaobing.crm.workbench.dao;

import com.itlaobing.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getListByClueId(String clueId);

    void deleteByClueId(String clueId);
}
