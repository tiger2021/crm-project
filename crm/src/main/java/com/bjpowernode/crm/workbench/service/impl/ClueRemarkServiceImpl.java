package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.mapper.ClueRemarkMapper;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author 小镇做题家
 * @create 2023/4/2 11:16
 * @Description:
 */
@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Override
    public List<ClueRemark> selectClueRemarkByClueIdForClueDetail(String clueId) {
        return clueRemarkMapper.selectClueRemarkByClueIdForClueDetail(clueId);
    }

    @Override
    public int saveClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insert(clueRemark);
    }
}
