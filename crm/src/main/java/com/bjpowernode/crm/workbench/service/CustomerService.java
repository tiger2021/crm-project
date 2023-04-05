package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

/**
 * @Author 小镇做题家
 * @create 2023/4/4 11:42
 * @Description:
 */
public interface CustomerService {
    List<String> queryCustomerNameByName(String name);

    List<Customer> queryCustomerForPageByCondition(Map<String,Object> map);

    int queryCountOfCustomerForPageByCondition(Map<String,Object> map);

    int saveCreateCustomer(Customer customer);
}
