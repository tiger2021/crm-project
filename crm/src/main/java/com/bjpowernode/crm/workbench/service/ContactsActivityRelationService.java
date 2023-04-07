package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;
import java.util.Map;

/**
 * @Author 小镇做题家
 * @create 2023/4/7 14:10
 * @Description:
 */
public interface ContactsActivityRelationService {
    int saveContactsActivityRelationByList(List<ContactsActivityRelation> contactsActivityRelation);

    int removeContactsActivityRelationByContactsIdAndActivityId(ContactsActivityRelation contactsActivityRelation);
}
