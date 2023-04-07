package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;

/**
 * @Author 小镇做题家
 * @create 2023/4/4 16:51
 * @Description:
 */
public interface TranRemarkService {
    List<TranRemark> queryTransactionRemarkForDetailByTranId(String tranId);

    int insertTranRemark(TranRemark tranRemark);
}
