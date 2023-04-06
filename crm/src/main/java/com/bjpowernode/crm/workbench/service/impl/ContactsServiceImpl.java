package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.mapper.ContactsMapper;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @Author 小镇做题家
 * @create 2023/4/5 22:02
 * @Description:
 */
@Service("contactsService")
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;
    @Override
    public List<Contacts> queryContactsByCustomerId(String customerId) {
        return contactsMapper.selectContactsByCustomerId(customerId);
    }

    @Override
    public List<Contacts> queryContactsForPageByCondition(Map<String, Object> map) {
        return contactsMapper.selectContactsForPageByCondition(map);
    }

    @Override
    public int queryCountOfContactsForPageByCondition(Map<String, Object> map) {
        return contactsMapper.selectCountOfContactsForPageByCondition(map);
    }

    @Override
    public int saveCreateContacts(Contacts contacts) {
        return contactsMapper.insertCreateContacts(contacts);
    }

    @Override
    public int updateContactsById(Contacts contacts) {
        return contactsMapper.updateContactsById(contacts);
    }

    @Override
    public Contacts queryContactsForUpdateById(String id) {
        return contactsMapper.selectContactsForUpdateById(id);
    }

    @Override
    public int deleteContactsByIds(String[] id) {
        return contactsMapper.deleteContactsByIds(id);
    }

    @Override
    public Contacts queryContactsForDetailById(String id) {
        return contactsMapper.selectContactsForDetailById(id);
    }

    @Override
    public int removeContactsForDetailByIds(String id) {
        return contactsMapper.deleteContactsForDetailByIds(id);
    }
}
