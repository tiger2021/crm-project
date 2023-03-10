package com.bjpowernode.crm.settings.web.controller;


import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DataUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.sun.deploy.net.HttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
    public @ResponseBody Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpSession session, HttpServletResponse response){
        Map<String,Object> map=new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userService.queryUserByLoginActAndLoginPwd(map);

        //接下来判断查询是否成功
        ReturnObject returnObject=new ReturnObject();
        if(user==null){
            //用户名或密码错误
            returnObject.setCode("0");
            returnObject.setMessage("用户名或密码错误");
        }else{
            //调用时间的工具类
            String now = DataUtils.formateDateTime(new Date());
            if(now.compareTo(user.getExpireTime())>0){
                //账户已失效
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账户已失效");

            } else if (user.getLockState().equals(Contants.RETURN_OBJECT_CODE_FAIL)) {
                //账户处于锁定状态
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账户处于锁定状态");

            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {
                //用户的ip地址不在被允许访问的范围内
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("用户的ip地址不在被允许访问的范围内");

            }else{
                //成功登录
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("成功登录");

                //将当前用户对象User注入到session作用域，让前端调用
                session.setAttribute(Contants.SESSION_USER,user);

                //判断用户是否点击了十天免登录
                if(isRemPwd.equals("true")){
                    //向浏览器写cookie
                    Cookie c1 = new Cookie("loginAct", user.getLoginAct());
                    //设置cookie的保存时间
                    c1.setMaxAge(10*24*60*60);
                    //向浏览器写入cookie
                    response.addCookie(c1);

                    Cookie c2 = new Cookie("loginPwd", user.getLoginPwd());
                    c2.setMaxAge(10*24*60*60);
                    response.addCookie(c2);
                }else{  //删除上次在浏览器中保存的cookie
                    Cookie c1 = new Cookie("loginAct", "1");
                    c1.setMaxAge(0);  //设置cookie的有效时间为0
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd", "1");
                    c2.setMaxAge(0);
                    response.addCookie(c2);
                }
            }

        }
        return returnObject;

    }


}
