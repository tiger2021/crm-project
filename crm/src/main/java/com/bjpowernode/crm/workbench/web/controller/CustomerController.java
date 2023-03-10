package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/10 21:30
 */
@Controller
public class CustomerController {
    @RequestMapping("/workbench/customer/toCustomerIndex.do")
    public String toCustomerIndex(){
        return "workbench/customer/index";
    }
}
