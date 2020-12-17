package com.itlaobing.crm.workbench.dao;

import com.itlaobing.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface Activity_remarkDao {
    int getCountByIds(String[] ids);

    int deleteCount(String[] ids);

    List<ActivityRemark> getRemarksById(String id);

    Integer delRemarkById(String id);

    Integer saveRemark(ActivityRemark activityRemark);

    Integer updateRemark(ActivityRemark remark);
}
