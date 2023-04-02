package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Fri Mar 10 23:31:15 CST 2023
     */
    int deleteByPrimaryKey(String id);


    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Fri Mar 10 23:31:15 CST 2023
     */
    int insertSelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Fri Mar 10 23:31:15 CST 2023
     */
    Activity selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Fri Mar 10 23:31:15 CST 2023
     */
    int updateByPrimaryKeySelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Fri Mar 10 23:31:15 CST 2023
     */
    int updateByPrimaryKey(Activity record);

    int insertActivity(Activity activity);


    List<Activity> selectActivityByCondition(Map<String,Object> map);

    int selectCountOfActivityByCondition(Map<String,Object> map);

    int deleteActivityByIds(String[] ids);

    Activity selectActivityById(String id);

    int updateActivityById(Activity activity);

    /**
     * @description:查询所有的市场活动
     * @return: java.util.List<com.bjpowernode.crm.workbench.domain.Activity>
     **/
    List<Activity> selectAllActivities();

    List<Activity> selectActivityByIds(String[] ids);


    int insertActivityByList(List<Activity> activityList);


    Activity selectActivityForDetailById(String id);

    List<Activity> selectActivityForClueDetailByClueId(String clueId);

    List<Activity> selectActivityForClueDetailByNameClueId(Map<String,Object> map);
}