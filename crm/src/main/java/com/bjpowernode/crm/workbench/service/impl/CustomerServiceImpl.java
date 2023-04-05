package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.mapper.CustomerMapper;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @Author 小镇做题家
 * @create 2023/4/4 11:43
 * @Description:
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Override
    public List<String> queryCustomerNameByName(String name) {
        return customerMapper.selectCustomerNameByName(name);
    }

    @Override
    public List<Customer> queryCustomerForPageByCondition(Map<String, Object> map) {
        return customerMapper.selectCustomerForPageByCondition(map);
    }

    @Override
    public int queryCountOfCustomerForPageByCondition(Map<String, Object> map) {
        return customerMapper.selectCountOfCustomerForPageByCondition(map);
    }

    @Override
    public int saveCreateCustomer(Customer customer) {
        return customerMapper.insertCreateCustomer(customer);
    }

    @Override
    public int removeCustomerByIds(String[] id) {
        return customerMapper.deleteCustomerByIds(id);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public int renewCustomerById(Customer customer) {
        return customerMapper.updateCustomerById(customer);
    }
}
