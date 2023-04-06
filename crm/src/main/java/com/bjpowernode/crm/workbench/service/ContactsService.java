package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

/**
 * @Author 小镇做题家
 * @create 2023/4/5 22:02
 * @Description:
 */
public interface ContactsService {
    List<Contacts> queryContactsByCustomerId(String customerId);

    List<Contacts> queryContactsForPageByCondition(Map<String,Object> map);

    int queryCountOfContactsForPageByCondition(Map<String,Object> map);
}
