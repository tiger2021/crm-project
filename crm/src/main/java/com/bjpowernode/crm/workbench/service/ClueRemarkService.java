package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

/**
 * @Author 小镇做题家
 * @create 2023/4/2 11:16
 * @Description:
 */
public interface ClueRemarkService {
    List<ClueRemark> selectClueRemarkByClueIdForClueDetail(String clueId);

}
