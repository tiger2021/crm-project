package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
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
import javax.servlet.http.HttpSession;
import java.util.Date;
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


    @RequestMapping("/workbench/contacts/saveCreateContacts.do")
    @ResponseBody
    public Object saveCreateContacts(Contacts contacts, HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        contacts.setId(UUIDUtils.getUUID());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formateDateTime(new Date()));


        ReturnObject returnObject=new ReturnObject();
        try {
            //调用Service保存customer
            int num = contactsService.saveCreateContacts(contacts);
            //判断是否保存成功
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

    @RequestMapping("/workbench/contacts/queryContactsForUpdateById.do")
    @ResponseBody
    public Object queryContactsForUpdateById(String id){

        //调用service进行查找
        Contacts contact = contactsService.queryContactsForUpdateById(id);

        return contact;

    }

    @RequestMapping("/workbench/contacts/updateContactsById.do")
    @ResponseBody
    public Object updateContactsById(Contacts contacts,HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        contacts.setEditBy(user.getId());
        contacts.setEditTime(DateUtils.formateDateTime(new Date()));

        ReturnObject returnObject=new ReturnObject();

        try {
            //调用service保存修改
            int num = contactsService.updateContactsById(contacts);
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

    @RequestMapping("/workbench/contacts/deleteContactsByIds.do")
    @ResponseBody
    public Object deleteContactsByIds(String[] id){
        ReturnObject returnObject=new ReturnObject();

        try {
            //调用service进行删除操作
            int num = contactsService.deleteContactsByIds(id);
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


    @RequestMapping("/workbench/contacts/toContactDetails.do")
    public String toContactDetail(String contactsId,HttpServletRequest request){

        Contacts contact = contactsService.queryContactsForDetailById(contactsId);
        //将查询到的结果放到请求域中
        request.setAttribute("contact",contact);


        return "workbench/contacts/detail";
    }


}


