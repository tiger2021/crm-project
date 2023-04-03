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



//        Tran tran=new Tran();
//        //初始化tran
//        tran.setId(UUIDUtils.getUUID());
//        tran.setCreateBy(user.getId());
//        tran.setCreateTime(DateUtils.formateDateTime(new Date()));
//        String activityId=(String) map.get("activityId");
//        tran.setActivityId(activityId);
//        String money=(String)map.get("money");
//        tran.setMoney(money);
//        String name=(String)map.get("name");
//        tran.setMoney(name);


    }
}
