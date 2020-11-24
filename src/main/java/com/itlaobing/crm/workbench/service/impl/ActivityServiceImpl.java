package com.itlaobing.crm.workbench.service.impl;

import com.itlaobing.crm.utils.SqlSessionUtil;
import com.itlaobing.crm.vo.PaginationVO;
import com.itlaobing.crm.workbench.dao.ActivityDao;
import com.itlaobing.crm.workbench.domain.Activity;
import com.itlaobing.crm.workbench.service.ActivityService;

import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao dao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);

    @Override
    public boolean save(Activity activity) {
        Integer count = dao.save(activity);
        boolean flag = true;
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVO<Activity> pageList(Map<String, Object> map) {

        PaginationVO<Activity> paginationVO = new PaginationVO<>();
        //获取总数
        Integer total = dao.getTotalByCondition(map);
        System.out.println(total);
        //获取信息列表
        List<Activity> list = dao.getDataListByCondition(map);
        System.out.println(list.size());
        paginationVO.setTotal(total);
        paginationVO.setDataList(list);
        return paginationVO;
    }
}
