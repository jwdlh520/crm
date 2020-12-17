package com.itlaobing.crm.workbench.service.impl;

import com.itlaobing.crm.utils.DateTimeUtil;
import com.itlaobing.crm.utils.SqlSessionUtil;
import com.itlaobing.crm.utils.UUIDUtil;
import com.itlaobing.crm.vo.PaginationVO;
import com.itlaobing.crm.workbench.dao.CustomerDao;
import com.itlaobing.crm.workbench.dao.TranDao;
import com.itlaobing.crm.workbench.dao.TranHistoryDao;
import com.itlaobing.crm.workbench.domain.Customer;
import com.itlaobing.crm.workbench.domain.Tran;
import com.itlaobing.crm.workbench.domain.TranHistory;
import com.itlaobing.crm.workbench.service.TransactionService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TransactionServiceImpl implements TransactionService {
   private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
   private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
   private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

   @Override
   public boolean save(Tran tran, String customerName) {
      boolean flag = true;
      /*
         1.通过客户名称进行精确查询，是否存在该客户。如果存在则使用该客户的id，如果不存在则创建一个新客户
         2.添加交易
         3.添加交易历史记录
      * */
      Customer customer = customerDao.getCustomerByName(customerName);
      if (customer == null){
         //该客户不存在，创建新的客户
         customer = new Customer();
         customer.setId(UUIDUtil.getUUID());
         customer.setOwner(tran.getOwner());
         customer.setNextContactTime(tran.getNextContactTime());
         customer.setName(customerName);
         customer.setDescription(tran.getDescription());
         customer.setCreateTime(DateTimeUtil.getSysTime());
         customer.setCreateBy(tran.getCreateBy());
         customer.setContactSummary(tran.getContactSummary());
         //添加客户
         Integer count1 = customerDao.save(customer);
         if (count1 != 1){
            flag = false;
         }
      }

      //创建交易
      tran.setCustomerId(customer.getId());
      Integer count2 = tranDao.save(tran);
      if (count2 != 1){
         flag = false;
      }

      //创建交易历史记录
      TranHistory tranHistory = new TranHistory();
      tranHistory.setId(UUIDUtil.getUUID());
      tranHistory.setTranId(tran.getId());
      tranHistory.setStage(tran.getStage());
      tranHistory.setMoney(tran.getMoney());
      tranHistory.setExpectedDate(tran.getExpectedDate());
      tranHistory.setCreateTime(DateTimeUtil.getSysTime());
      tranHistory.setCreateBy(tran.getCreateBy());
      Integer count3 = tranHistoryDao.save(tranHistory);
      if (count3 != 1){
         flag = false;
      }
      return flag;
   }

   @Override
   public PaginationVO<Tran> getTranList(Map<String, Object> map) {
      PaginationVO<Tran> paginationVO = new PaginationVO<>();
      //获取总条数
      Integer total = tranDao.getAllCount(map);

      //获取交易列表
      List<Tran> list = tranDao.getTranList(map);

      paginationVO.setTotal(total);
      paginationVO.setDataList(list);
      return paginationVO;
   }

   @Override
   public Tran getById(String id) {
      Tran tran = tranDao.getById(id);
      return tran;
   }

   @Override
   public List<TranHistory> showHistoryList(String id) {
      List<TranHistory> historyList = tranHistoryDao.showHistoryList(id);
      return historyList;
   }

   @Override
   public boolean changeStage(Tran tran) {
      boolean flag = true;
      //修改该交易的stage，添加editBy和editTime
      Integer count1 = tranDao.changeStage(tran);
      if (count1 != 1){
         flag = false;
      }

      //创建交易历史记录
      TranHistory tranHistory = new TranHistory();
      tranHistory.setId(UUIDUtil.getUUID());
      tranHistory.setTranId(tran.getId());
      tranHistory.setStage(tran.getStage());
      tranHistory.setMoney(tran.getMoney());
      tranHistory.setExpectedDate(tran.getExpectedDate());
      tranHistory.setCreateTime(tran.getEditTime());
      tranHistory.setCreateBy(tran.getEditBy());
      tranHistory.setPossibility(tran.getPossibility());
      Integer count2 = tranHistoryDao.save(tranHistory);
      if (count2 != 1){
         flag = false;
      }
      return flag;
   }

   @Override
   public Map<String, Object> echartsShow() {
      //获取总条数
      Integer total = tranDao.getTotal();
      //获取每个阶段的条数
      List<Map<String,Object>> dataList = tranDao.echartsShow();

      Map<String,Object> map = new HashMap<>();
     /* map.put("total",total);*/
      map.put("dataList",dataList);
      return map;
   }
}
