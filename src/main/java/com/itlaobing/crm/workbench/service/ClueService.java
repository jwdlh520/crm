package com.itlaobing.crm.workbench.service;

import com.itlaobing.crm.workbench.dao.ClueDao;
import com.itlaobing.crm.workbench.domain.Activity;
import com.itlaobing.crm.workbench.domain.Clue;
import com.itlaobing.crm.workbench.domain.ClueActivityRelation;
import com.itlaobing.crm.workbench.domain.Tran;

import java.util.List;

public interface ClueService {
    boolean save(Clue clue);

    Clue detail(String id);

    boolean dissociate(String id);

    boolean bund(List<ClueActivityRelation> list);

    boolean convert(String clueId, Tran tran, String createBy);
}
