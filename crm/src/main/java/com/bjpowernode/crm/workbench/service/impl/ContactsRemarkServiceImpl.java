package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.ContactsRemark;
import com.bjpowernode.crm.workbench.mapper.ContactsRemarkMapper;
import com.bjpowernode.crm.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author 小镇做题家
 * @create 2023/4/6 18:58
 * @Description:
 */

@Service("contactsRemarkService")
public class ContactsRemarkServiceImpl implements ContactsRemarkService {
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Override
    public List<ContactsRemark> queryContactsRemarkByContactsId(String contactsId) {
        return contactsRemarkMapper.selectContactsRemarkByContactsId(contactsId);
    }

    @Override
    public int insertContactsRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.insertContactsRemark(contactsRemark);
    }
}
