package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
public class WorkBenchIndexController {

    @Autowired
    private UserService userService;

    @RequestMapping("/workbench/index.do")
    public String index(){
        return "workbench/index";
    }


    @RequestMapping("/workbench/editUserLoginPwdById.do")
    @ResponseBody
    public Object editUserLoginPwdById(String id,String loginPwd) {
        //封装参数
        Map<String,String> map=new HashMap<>();
        map.put("id",id);
        map.put("loginPwd",loginPwd);

        ReturnObject returnObject=new ReturnObject();
        try {
            //调用service方法，修改用户密码
            int num = userService.editUserLoginPwdById(map);
            if(num>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
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
