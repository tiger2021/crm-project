package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

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



}
