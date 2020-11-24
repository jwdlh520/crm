package com.itlaobing.crm.workbench.service;

import com.itlaobing.crm.vo.PaginationVO;
import com.itlaobing.crm.workbench.domain.Activity;

import java.util.Map;

public interface ActivityService {
    boolean save(Activity activity);

    PaginationVO<Activity> pageList(Map<String, Object> map);
}
