package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/10 21:23
 */
@Controller
public class ClueController {

    @Autowired
    private UserService userService;

    @Autowired
    private ClueService clueService;
    @RequestMapping("/workbench/clue/toClueIndex.do")
    public String toClueIndex(HttpServletRequest request){
        //调用userService，查询所有的user
        List<User> ownerList = userService.queryAllUsers();
        request.setAttribute("ownerList",ownerList);

        return "workbench/clue/index";
    }



    @RequestMapping("/workbench/clue/saveClue.do")
    @ResponseBody
    public Object saveClue(Clue clue, HttpSession session){
        //封装参数
        return null;

    }
}
