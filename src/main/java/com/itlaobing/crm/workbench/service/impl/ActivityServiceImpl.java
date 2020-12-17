package com.itlaobing.crm.workbench.service.impl;

import com.itlaobing.crm.settings.dao.UserDao;
import com.itlaobing.crm.settings.domain.User;
import com.itlaobing.crm.utils.SqlSessionUtil;
import com.itlaobing.crm.vo.PaginationVO;
import com.itlaobing.crm.workbench.dao.ActivityDao;
import com.itlaobing.crm.workbench.dao.Activity_remarkDao;
import com.itlaobing.crm.workbench.domain.Activity;
import com.itlaobing.crm.workbench.domain.ActivityRemark;
import com.itlaobing.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao dao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private Activity_remarkDao remarkDao = SqlSessionUtil.getSqlSession().getMapper(Activity_remarkDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

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
        //获取信息列表
        List<Activity> list = dao.getDataListByCondition(map);
        paginationVO.setTotal(total);
        paginationVO.setDataList(list);
        return paginationVO;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        //1.获取需要删除的记录条数(tbl_activity_remark表)
        int count1 = remarkDao.getCountByIds(ids);
        //2.获取实际删除的记录条数(tbl_activity_remark表)
        int count2 = remarkDao.deleteCount(ids);
        if (count1 != count2){
            flag = false;
        }
        //3.获取需要删除的记录条数(tbl_activity_表)
        int count3 = dao.deleteCount(ids);
        if (count3 != ids.length){
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserAndActivity(String id) {
        //获取用户列表
        List<User> uList = userDao.queryUserAll();
        //获取活动对象
        Activity activity = dao.findById(id);
        Map<String,Object> map = new HashMap<>();
        map.put("uList",uList);
        map.put("activity",activity);
        return map;
    }

    @Override
    public boolean update(Activity activity) {
        Integer count = dao.update(activity);
        if (count == 1){
            return true;
        }else {
            return false;
        }
    }

    @Override
    public Activity detail(String id) {
        Activity activity = dao.detail(id);
        return activity;
    }

    @Override
    public List<ActivityRemark> remarkList(String id) {
        List<ActivityRemark> remarks = remarkDao.getRemarksById(id);
        return remarks;
    }

    @Override
    public boolean delRemark(String id) {
        Integer count = remarkDao.delRemarkById(id);
        if (count == 1){
            return true;
        }else {
            return false;
        }
    }

    @Override
    public boolean saveRemark(ActivityRemark activityRemark) {
        Integer count = remarkDao.saveRemark(activityRemark);
        if (count == 1){
            return true;
        }else {
            return false;
        }
    }

    @Override
    public boolean updateRemark(ActivityRemark remark) {
        Integer count = remarkDao.updateRemark(remark);
        if (count == 1){
            return true;
        }else {
            return false;
        }
    }

    @Override
    public List<Activity> activityList(String id) {
        List<Activity> aList = dao.activityList(id);
        return aList;
    }

    @Override
    public List<Activity> pageListByConditionAndNotClueId(Map<String, Object> map) {
        List<Activity> list = dao.pageListByConditionAndNotClueId(map);
        return list;
    }

    @Override
    public List<Activity> pageListByName(String name) {
        List<Activity> list = dao.pageListByName(name);
        return list;
    }
}
