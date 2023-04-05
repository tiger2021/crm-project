package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;

/**
 * @Author 小镇做题家
 * @create 2023/4/5 22:02
 * @Description:
 */
public interface ContactsService {
    List<Contacts> queryContactsByCustomerId(String customerId);
}
