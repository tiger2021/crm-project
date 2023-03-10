package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/10 21:35
 */
@Controller
public class TransactionController {
    @RequestMapping("/workbench/transaction/toTransactionIndex.do")
    public String toTransactionIndex(){
        return "workbench/transaction/index";
    }
}
