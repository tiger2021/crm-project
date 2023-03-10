package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/10 21:23
 */
@Controller
public class ClueController {
    @RequestMapping("/workbench/clue/toClueIndex.do")
    public String toClueIndex(){
        return "workbench/clue/index";
    }
}
