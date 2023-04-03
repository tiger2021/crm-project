package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.mapper.TranMapper;
import com.bjpowernode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @Author 小镇做题家
 * @create 2023/4/3 21:58
 * @Description:
 */

@Service
public class TransactionServiceImpl implements TransactionService {
    @Autowired
    private TranMapper tranMapper;


    @Override
    public List<Tran> selectTransactionByCondition(Map<String, Object> map) {
        return tranMapper.selectTransactionByCondition(map);
    }

    @Override
    public int queryCountOfTransactionByConditionForPage(Map<String, Object> map) {
        return tranMapper.selectCountOfTransactionByConditionForPage(map);
    }
}
