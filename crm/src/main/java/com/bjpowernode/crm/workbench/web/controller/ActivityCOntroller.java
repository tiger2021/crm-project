package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/10 21:14
 */
@Controller
public class ActivityCOntroller {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;


    @RequestMapping("/workbench/activity/toActivityIndex.do")
    public String toActivityIndex(HttpServletRequest request){
        //查询用户的信息
        List<User> userList = userService.queryAllUsers();
        //将查询出的信息返回给前端页面
        request.setAttribute("userList",userList);
        //进行页面的跳转
        return "workbench/activity/index";
    }


    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveCreateActivity(Activity activity, HttpSession session){
        //封装参数信息
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setCreateBy(user.getId());

        ReturnObject returnObject = new ReturnObject();

        try{
            //调用service插入数据
            int num = activityService.saveCreateActivity(activity);

            if(num>0){      //成功插入数据
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("创建成功");
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍侯.....");
            }

    } catch (Exception e) {
        e.printStackTrace();
        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
        returnObject.setMessage("系统繁忙，请稍侯.....");
    }

        //向前端返回信息
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(String name,String owner,String startDate,
                                                  String endDate,int beginNo,int pageSize){
        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNo",beginNo);
        map.put("pageSize",pageSize);

        //调用service，查询数据
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryCountOfActivityByConditionForPage(map);

        //将查询到的数据封装到map中，并返回给前端
        Map<String,Object> resMap=new HashMap<>();
        resMap.put("activityList",activityList);
        resMap.put("totalRows",totalRows);
        return resMap;
    }

}
