package com.itlaobing.crm.workbench.service;

import com.itlaobing.crm.vo.PaginationVO;
import com.itlaobing.crm.workbench.domain.Activity;
import com.itlaobing.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    boolean save(Activity activity);

    PaginationVO<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Map<String, Object> getUserAndActivity(String id);

    boolean update(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> remarkList(String id);

    boolean delRemark(String id);

    boolean saveRemark(ActivityRemark activityRemark);

    boolean updateRemark(ActivityRemark remark);

    List<Activity> activityList(String id);

    List<Activity> pageListByConditionAndNotClueId(Map<String, Object> map);

    List<Activity> pageListByName(String name);
}
