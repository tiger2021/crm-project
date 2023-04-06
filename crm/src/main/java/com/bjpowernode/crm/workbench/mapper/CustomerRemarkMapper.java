package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    int insert(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    int insertSelective(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    CustomerRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    int updateByPrimaryKeySelective(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Apr 03 12:21:31 CST 2023
     */
    int updateByPrimaryKey(CustomerRemark record);

    int insertCustomerRemark(CustomerRemark customerRemark);

    List<CustomerRemark> selectCustomerRemarkForDetailByCustomerId(String customerId);

    int deleteCustomerRemarkById(String id);

}