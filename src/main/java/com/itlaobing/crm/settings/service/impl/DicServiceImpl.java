package com.itlaobing.crm.settings.service.impl;

import com.itlaobing.crm.settings.dao.DicTypeDao;
import com.itlaobing.crm.settings.dao.DicValueDao;
import com.itlaobing.crm.settings.domain.DicType;
import com.itlaobing.crm.settings.domain.DicValue;
import com.itlaobing.crm.settings.service.DicService;
import com.itlaobing.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DicServiceImpl implements DicService {
    private DicValueDao dicValueDao = SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);
    private DicTypeDao dicTypeDao = SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);

    @Override
    public Map<String, List<DicValue>> getDicList() {
        Map<String,List<DicValue>> map = new HashMap<>();
        //获取所有的dic的code
        List<DicType> dtList = dicTypeDao.getDicTypeList();
        //根据code,获取每一个code对应的DicValue集合
        for (DicType dt : dtList){
            List<DicValue> list = dicValueDao.getDicValueList(dt.getCode());
            map.put(dt.getCode(),list);
        }
        //遍历集合，将code和集合封装到map集合中
        return map;
    }
}
