package com.itlaobing.crm.workbench.dao;

//import com.itlaobing.crm.workbench.domain.ClueActivityRelation;

import com.itlaobing.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {


    Integer dissociate(String id);

    Integer bund(ClueActivityRelation car);

    List<ClueActivityRelation> getListByClueId(String clueId);

    void deleteByClueId(String clueId);
}
