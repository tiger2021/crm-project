package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;

/**
 * @Author 小镇做题家
 * @create 2023/4/4 16:55
 * @Description:
 */
public interface TranHistoryService {

    List<TranHistory> queryTranHistoryForDetailByTranId(String tranId);

}
