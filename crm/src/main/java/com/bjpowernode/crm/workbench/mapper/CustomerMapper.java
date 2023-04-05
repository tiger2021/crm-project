package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    int insert(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    int insertSelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    Customer selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    int updateByPrimaryKeySelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    int updateByPrimaryKey(Customer record);

    int insertCustomer(Customer customer);

    List<String> selectCustomerNameByName(String name);

    //根据客户名称精确查询客户
    Customer selectCustomerByName(String name);

    List<Customer> selectCustomerForPageByCondition(Map<String,Object> map);

    int selectCountOfCustomerForPageByCondition(Map<String,Object> map);

    int insertCreateCustomer(Customer customer);
}