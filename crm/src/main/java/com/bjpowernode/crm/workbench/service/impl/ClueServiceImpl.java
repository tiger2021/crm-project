package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.mapper.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/19 23:22
 */
@Service("clueService")
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    private TranMapper tranMapper;

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public int saveClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionsForPage(Map<String,Object> map) {
        return clueMapper.selectCluesByConditionsForPage(map);
    }

    @Override
    public int queryCountOfClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public int deleteCluesByIds(String[] id) {
        return clueMapper.deleteCluesByIds(id);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int updateClueById(Clue clue) {
        return clueMapper.updateClueById(clue);
    }

    @Override
    public Clue selectClueByIdForDetail(String id) {
        return clueMapper.selectClueByIdForDetail(id);
    }

    @Override
    public void saveConvertClue(Map<String, Object> map) {
        String clueId=(String)map.get("clueId");
        //根据ClueId查询线索
        Clue clue = clueMapper.selectClueByIdForConvert(clueId);
        User user = (User) map.get(Contants.SESSION_USER);
        //将线索中与客户相关的内容保存到客户表中
          //封装参数
        Customer customer=new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setOwner(user.getId());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        //将封装好的Customer保存到客户表中
        int num = customerMapper.insertCustomer(customer);

        //将线索中与联系人相关的内容保存到联系人表中
        //封装参数
        Contacts contacts=new Contacts();

        contacts.setId(UUIDUtils.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formateDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        //将封装好的Contacts保存到联系人表中
        int numContacts = contactsMapper.insertContact(contacts);


        //根据clueId查询该线索下所有的备注
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkByClueId(clueId);
        //把该线索下所有的备注转换到客户备注表中一份
        for (ClueRemark clueRemark : clueRemarkList) {
            //封装参数
            CustomerRemark customerRemark=new CustomerRemark();
            customerRemark.setId(UUIDUtils.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCreateBy(user.getId());
            customerRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
            customerRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
            customerRemark.setCustomerId(customer.getId());
            int customerRemarkNum = customerRemarkMapper.insertCustomerRemark(customerRemark);
        }

        //把该线索下所有的备注转换到联系人备注表中一份
        for (ClueRemark clueRemark : clueRemarkList) {
            //封装参数
            ContactsRemark contactsRemark=new ContactsRemark();
            contactsRemark.setId(UUIDUtils.getUUID());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setCreateBy(user.getId());
            contactsRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
            contactsRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
            contactsRemark.setContactsId(contacts.getId());
            contactsRemarkMapper.insertContactsRemark(contactsRemark);
        }

        //根据clueId查询该线索和市场活动的关联关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);
        //把该线索和市场活动的关联关系转换到联系人和市场活动的关联关系表中
        List<ContactsActivityRelation> contactsActivityRelationList=new ArrayList<>();
        ContactsActivityRelation contactsActivityRelation=null;
        //封装参数
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
            contactsActivityRelation=new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtils.getUUID());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            contactsActivityRelation.setContactsId(contacts.getId());
            contactsActivityRelationList.add(contactsActivityRelation);
        }
        //调用service
        contactsActivityRelationMapper.insertContactsActivityRelationByList(contactsActivityRelationList);

        //判断是否需要创建交易
        String isCreateTran = (String) map.get("isCreateTran");
        if(isCreateTran.equals("true")){
            //如果需要创建交易，则往交易表中添加一条记录
            Tran tran=new Tran();
            //初始化tran
            tran.setId(UUIDUtils.getUUID());
            tran.setOwner(user.getId());
            String money=(String)map.get("money");
            tran.setMoney(money);
            String name=(String)map.get("name");
            tran.setMoney(name);
            String expectedDate=(String)map.get("expectedDate");
            tran.setExpectedDate(expectedDate);
            tran.setCustomerId(customer.getId());
            String stage=(String)map.get("stage");
            tran.setStage(stage);
            String activityId=(String)map.get("activityId");
            tran.setActivityId(activityId);
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtils.formateDateTime(new Date()));
            //调用mapper方法进行保存
            tranMapper.insertTran(tran);

            //把该线索下所有的备注转换到交易备注表中一份
            TranRemark tranRemark=null;
            List<TranRemark> tranRemarkList=new ArrayList<>();
            for (ClueRemark clueRemark : clueRemarkList) {
                tranRemark=new TranRemark();
                tranRemark.setId(UUIDUtils.getUUID());
                tranRemark.setNoteContent(clueRemark.getNoteContent());
                tranRemark.setCreateBy(user.getId());
                tranRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
                tranRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
                tranRemark.setTranId(tran.getId());

                tranRemarkList.add(tranRemark);
            }
            //调用service
            tranRemarkMapper.insertTranRemarkByList(tranRemarkList);


        }


    }
}
