package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import org.springframework.stereotype.Service;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/10 23:48
 */
public interface ActivityService {
    public int saveCreateActivity(Activity activity);
}
