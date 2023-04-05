package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

/**
 * @Author 小镇做题家
 * @create 2023/4/5 21:01
 * @Description:
 */
public interface CustomerRemarkService {
    List<CustomerRemark> queryCustomerRemarkForDetailByCustomerId(String customerId);
}
