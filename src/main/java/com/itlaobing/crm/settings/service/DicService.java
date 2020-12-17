package com.itlaobing.crm.settings.service;

import com.itlaobing.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicService {
    Map<String, List<DicValue>> getDicList();
}
