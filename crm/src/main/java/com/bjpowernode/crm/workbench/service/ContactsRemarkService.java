package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ContactsRemark;

import java.util.List;

/**
 * @Author 小镇做题家
 * @create 2023/4/6 18:58
 * @Description:
 */
public interface ContactsRemarkService {
    List<ContactsRemark> queryContactsRemarkByContactsId(String contactsId);

    int insertContactsRemark(ContactsRemark contactsRemark);

    int removeContactsRemarkById(String id);

    int updateContactsRemarkById(ContactsRemark contactsRemark);
}
