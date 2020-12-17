package com.itlaobing.crm.workbench.service.impl;

import com.itlaobing.crm.utils.DateTimeUtil;
import com.itlaobing.crm.utils.SqlSessionUtil;
import com.itlaobing.crm.utils.UUIDUtil;
import com.itlaobing.crm.workbench.dao.*;
import com.itlaobing.crm.workbench.domain.*;
import com.itlaobing.crm.workbench.service.ClueService;

import java.util.List;

public class ClueServiceImpl implements ClueService {
    //线索
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
    private ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);


    //活动
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private Activity_remarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(Activity_remarkDao.class);

    //联系人
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);

    //客户
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);

    //交易
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);


    @Override
    public boolean save(Clue clue) {
        Integer count = clueDao.save(clue);
        if (count == 1) {
            return true;
        } else {
            return false;
        }
    }

    @Override
    public Clue detail(String id) {
        Clue clue = clueDao.detail(id);
        return clue;
    }

    @Override
    public boolean dissociate(String id) {
        Integer count = clueActivityRelationDao.dissociate(id);
        if (count == 1) {
            return true;
        } else {
            return false;
        }
    }

    @Override
    public boolean bund(List<ClueActivityRelation> list) {
        boolean flag = true;
        for (ClueActivityRelation car : list) {
            int count = clueActivityRelationDao.bund(car);
            if (count != 1) {
                flag = false;
            }
        }
        return flag;
    }

    @Override
    public boolean convert(String clueId, Tran tran, String createBy) {
        boolean flag = true;
        String createTime = DateTimeUtil.getSysTime();
        //(1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
        Clue clue = clueDao.getById(clueId);
        //(2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
        String company = clue.getCompany();
        Customer customer = customerDao.getCustomerByName(company);
        if (customer == null) {

            customer = new Customer();
            customer.setAddress(clue.getAddress());
            customer.setContactSummary(clue.getContactSummary());
            customer.setCreateBy(createBy);
            customer.setCreateTime(createTime);
            customer.setDescription(clue.getDescription());
            customer.setId(UUIDUtil.getUUID());
            customer.setName(company);
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setOwner(clue.getOwner());
            customer.setPhone(clue.getPhone());
            customer.setWebsite(clue.getWebsite());
        }
        Integer count1 = customerDao.save(customer);
        if (count1 != 1) {
            flag = false;
        }
        //(3) 通过线索对象提取联系人信息，保存联系人
        Contacts contact = new Contacts();
        contact.setAddress(clue.getAddress());
        contact.setAppellation(clue.getAppellation());
        contact.setContactSummary(clue.getContactSummary());
        contact.setCreateBy(createBy);
        contact.setCreateTime(createTime);
        contact.setCustomerId(customer.getId());
        contact.setDescription(clue.getDescription());
        contact.setEmail(clue.getEmail());
        contact.setFullname(clue.getFullname());
        contact.setId(UUIDUtil.getUUID());
        contact.setJob(clue.getJob());
        contact.setMphone(clue.getMphone());
        contact.setNextContactTime(clue.getNextContactTime());
        contact.setOwner(clue.getOwner());
        contact.setSource(clue.getSource());
        Integer count2 = contactsDao.save(contact);
        if (count2 != 1) {
            flag = false;
        }

        //(4) 线索备注转换到客户备注以及联系人备注
        //获取线索备注
        List<ClueRemark> clueRemarkList = clueRemarkDao.getListByClueId(clueId);
        for (ClueRemark clueRemark : clueRemarkList) {
            //联系人备注
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setEditFlag("0");
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setContactsId(contact.getId());
            int count3 = contactsRemarkDao.save(contactsRemark);
            if (count3 != 1) {
                flag = false;
            }

            //客户备注
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setEditFlag("0");
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setCreateTime(createTime);
            customerRemark.setCreateBy(createBy);

            Integer count7 = customerRemarkDao.save(customerRemark);
            if (count7 != 1) {
                flag = false;
            }
        }

        //(5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getListByClueId(clueId);
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setContactsId(contact.getId());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            Integer count4 = contactsActivityRelationDao.save(contactsActivityRelation);
            if (count4 != 1) {
                flag = false;
            }
        }

        //(6) 如果有创建交易需求，创建一条交易
        if (tran != null) {
            /*
                controller中tran以及有了一些数据：
                    id,money,name,expectedDate,stage,activityId,createTime,createBy
                    根据客户的需求再决定是否继续完善信息
            * */
            tran.setSource(clue.getSource());
            tran.setOwner(clue.getOwner());
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setDescription(clue.getDescription());
            tran.setCustomerId(customer.getId());
            tran.setContactSummary(clue.getContactSummary());
            tran.setContactsId(contact.getId());
            Integer count5 = tranDao.save(tran);
            if (count5 != 1) {
                flag = false;
            }

            //(7) 如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setTranId(tran.getId());
            tranHistory.setStage(tran.getStage());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setCreateTime(createTime);
            tranHistory.setCreateBy(createBy);
            Integer count6 = tranHistoryDao.save(tranHistory);
            if (count6 != 1) {
                flag = false;
            }
        }

        //(8) 删除线索备注
        clueRemarkDao.deleteByClueId(clueId);

        //(9) 删除线索和市场活动的关系
        clueActivityRelationDao.deleteByClueId(clueId);

        //(10) 删除线索
        Integer count7 = clueDao.delete(clueId);
        if (count7 != 1) {
            flag = false;
        }
        return flag;
    }
}
