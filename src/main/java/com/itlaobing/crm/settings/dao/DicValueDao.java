package com.itlaobing.crm.settings.dao;

import com.itlaobing.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getDicValueList(String code);
}
