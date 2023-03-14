package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/10 23:48
 */
public interface ActivityService {
    public int saveCreateActivity(Activity activity);

    public List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    public int queryCountOfActivityByConditionForPage(Map<String,Object> map);

    public int deleteActivityByIds(String[] ids);

    public Activity queryActivityById(String id);

    public int saveEditActivityById(Activity activity);

    public List<Activity> queryAllActivities();

    public List<Activity> queryActivitiesByIds(String[] ids);
}
