package com.itlaobing.crm.workbench.dao;

//import com.itlaobing.crm.workbench.domain.Clue;

import com.itlaobing.crm.workbench.domain.Clue;

public interface ClueDao {


    Integer save(Clue clue);

    Clue detail(String id);

    Clue getById(String clueId);

    Integer delete(String clueId);
}
