package com.itlaobing.crm.workbench.dao;

import com.itlaobing.crm.vo.PaginationVO;
import com.itlaobing.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    Integer save(Activity activity);

    PaginationVO<Activity> pageList(Map<String, Object> map);

    Integer getTotalByCondition(Map<String, Object> map);

    List<Activity> getDataListByCondition(Map<String, Object> map);
}
