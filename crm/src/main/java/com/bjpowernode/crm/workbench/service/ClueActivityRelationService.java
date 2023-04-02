package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

/**
 * @Author 小镇做题家
 * @create 2023/4/2 19:47
 * @Description:
 */
public interface ClueActivityRelationService {
    int saveClueActivityRelationByList(List<ClueActivityRelation> list);

    int deleteClueActivityRelationByClueIdAndActivityId(ClueActivityRelation clueActivityRelation);
}
