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

    public int saveCreateActivityByList(List<Activity> activityList);

    public Activity queryActivityForDetailById(String id);

    public List<Activity> queryActivityForClueDetailByClueId(String clueId);

    public List<Activity> queryActivityForClueDetailByNameClueId(Map<String,Object> map);

    List<Activity> queryActivityForClueDetailByIdArray(String[] idArray);

    List<Activity> selectActivityForConvertByNameClueId(Map<String,Object> map);

    List<Activity> queryActivityForContactsDetailByNameContactsId(Map<String,Object> map);

    List<Activity> queryActivityForContactsDetailByContactsId(String contactsId);
}
