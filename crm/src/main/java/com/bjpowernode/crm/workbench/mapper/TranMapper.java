package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.FunnelVO;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Mon Apr 03 11:57:02 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Mon Apr 03 11:57:02 CST 2023
     */
    int insert(Tran record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Mon Apr 03 11:57:02 CST 2023
     */
    int insertSelective(Tran record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Mon Apr 03 11:57:02 CST 2023
     */
    Tran selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Mon Apr 03 11:57:02 CST 2023
     */
    int updateByPrimaryKeySelective(Tran record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Mon Apr 03 11:57:02 CST 2023
     */
    int updateByPrimaryKey(Tran record);

    int insertTran(Tran tran);


    /**
     * @description:根据条件查询交易
     **/
    List<Tran> selectTransactionByCondition(Map<String,Object> map);

    int selectCountOfTransactionByConditionForPage(Map<String,Object> map);

    Tran selectTransactionForDetailById(String id);

    List<FunnelVO> selectCountOfTranGroupByStage();

    List<Tran> selectTransactionByCustomerId(String customerId);

    int deleteTransactionById(String id);

    List<Tran> selectTransactionByContactsId(String contactsId);

    int deleteTransactionsByIds(String[] id);
}