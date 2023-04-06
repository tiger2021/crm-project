package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/10 21:35
 */
@Controller
public class ContactsController {

    @Autowired
    private UserService userService;

    @Autowired
    private ContactsService contactsService;

    @RequestMapping("/workbench/contacts/toContactsIndex.do")
    public String toContactsIndex(HttpServletRequest request){
        //调用userService，查询所有的user
        List<User> ownerList = userService.queryAllUsers();
        request.setAttribute("ownerList",ownerList);

        return "workbench/contacts/index";
    }

    @RequestMapping("/workbench/contacts/queryContactsForPageByCondition.do")
    @ResponseBody
    public Object queryContactsForPageByCondition(String owner,String name,String customerName,
                                                  String source,String nextContactTime,int pageNo,int pageSize) {
        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("customerName",customerName);
        map.put("source",source);
        map.put("nextContactTime",nextContactTime);
        map.put("pageNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调用service方法进行查询
        List<Contacts> contactsList = contactsService.queryContactsForPageByCondition(map);
        int totalRows = contactsService.queryCountOfContactsForPageByCondition(map);

        //将查询到的数据封装到map中，并返回给前端
        Map<String,Object> resMap=new HashMap<>();
        resMap.put("contactsList",contactsList);
        resMap.put("totalRows",totalRows);
        return resMap;
    }
}
