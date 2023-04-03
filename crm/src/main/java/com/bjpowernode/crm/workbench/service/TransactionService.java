package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

/**
 * @Author 小镇做题家
 * @create 2023/4/3 21:58
 * @Description:
 */
public interface TransactionService {


    List<Tran> selectTransactionByCondition(Map<String,Object> map);

    int queryCountOfTransactionByConditionForPage(Map<String,Object> map);

}
