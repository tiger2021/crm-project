package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/10 21:14
 */
@Controller
public class ActivityCOntroller {
    @RequestMapping("/workbench/activity/toActivity.do")
    public String toActivity(){
        return "workbench/activity/index";
    }
}
