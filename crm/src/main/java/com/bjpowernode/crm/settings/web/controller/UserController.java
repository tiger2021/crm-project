package com.bjpowernode.crm.settings.web.controller;


import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;



@Controller
public class UserController {

    @Autowired
    private UserService userService;

    /*
    *跳转到登录页面
    * */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        //请求转发到登录页面
        return "settings/qx/user/login";
    }



    //当需要返回json的时候需要加注解@ResponseBody



    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userService.queryUserByLoginActAndLoginPwd(map);

        if(user!=null){
            System.out.println("user不为空");
        }

        //接下来判断查询是否成功
        ReturnObject returnObject=new ReturnObject();
        if(user==null){
            //用户名或密码错误
            returnObject.setCode("0");
            returnObject.setMessage("用户名或密码错误");


        }else{
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String now = sdf.format(new Date());
            if(now.compareTo(user.getExpireTime())>0){
                //账户已失效
                returnObject.setCode("0");
                returnObject.setMessage("账户已失效");

            } else if (user.getLockState().equals("0")) {
                //账户处于锁定状态
                returnObject.setCode("0");
                returnObject.setMessage("账户处于锁定状态");

            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {
                //用户的ip地址不在被允许访问的范围内
                returnObject.setCode("0");
                returnObject.setMessage("用户的ip地址不在被允许访问的范围内");

            }else{
                //成功登录
                returnObject.setCode("1");
                returnObject.setMessage("成功登录");
            }

        }
        return returnObject;

    }


}
