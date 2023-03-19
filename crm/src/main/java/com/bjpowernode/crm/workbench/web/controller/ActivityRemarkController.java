package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/18 16:06
 */
@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;


    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    @ResponseBody
    public Object saveCreateActivityRemark(ActivityRemark activityRemark , HttpSession session){
        //封装参数
        activityRemark.setId(UUIDUtils.getUUID());
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        activityRemark.setCreateBy(user.getId());
        activityRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        activityRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
        ReturnObject returnObject = new ReturnObject();
        try {
            int num = activityRemarkService.saveCreateActivityRemark(activityRemark);
            if(num==1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后....");
        }
        return returnObject;
    }


    @RequestMapping("/workbench/activity/deleteActivityRemark.do")
    @ResponseBody
    public Object deleteActivityRemark(String id){

        ReturnObject returnObject = new ReturnObject();

        try {
            int num = activityRemarkService.deleteActivityRemarkById(id);
            if(num>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍重试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍重试....");
        }
        return returnObject;

    }

    @RequestMapping("/workbench/activity/updateActivityRemark.do")
    @ResponseBody
    public Object updateActivityRemark(ActivityRemark activityRemark,HttpSession session){
        //封装参数
        activityRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditTime(DateUtils.formateDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service方法
            int num = activityRemarkService.saveEditActivityRemark(activityRemark);
            if(num>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }





}

