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

    int deleteCount(String[] ids);

    Activity findById(String id);

    Integer update(Activity activity);

    Activity detail(String id);

    List<Activity> activityList(String id);

    List<Activity> pageListByConditionAndNotClueId(Map<String, Object> map);

    List<Activity> pageListByName(String name);

}
