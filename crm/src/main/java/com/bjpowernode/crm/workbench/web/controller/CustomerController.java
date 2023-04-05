package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;
import com.bjpowernode.crm.workbench.service.CustomerRemarkService;
import com.bjpowernode.crm.workbench.service.CustomerService;
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
 * @create 2023/3/10 21:30
 */
@Controller
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private UserService userService;

    @Autowired
    private CustomerRemarkService customerRemarkService;


    @RequestMapping("/workbench/customer/toCustomerIndex.do")
    public String toCustomerIndex(HttpServletRequest request){

        //调用userService，查询所有的user
        List<User> ownerList = userService.queryAllUsers();
        request.setAttribute("ownerList",ownerList);

        return "workbench/customer/index";
    }


    @RequestMapping("/workbench/customer/queryCustomerForPageByCondition.do")
    @ResponseBody
    public Object queryCustomerForPageByCondition(String name,String owner,String phone,
                                                  String website,int pageNo,int pageSize) {
        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("website",website);
        map.put("pageNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调用service方法进行查询
        List<Customer> customerList = customerService.queryCustomerForPageByCondition(map);
        int totalRows = customerService.queryCountOfCustomerForPageByCondition(map);

        //将查询到的数据封装到map中，并返回给前端
        Map<String,Object> resMap=new HashMap<>();
        resMap.put("customerList",customerList);
        resMap.put("totalRows",totalRows);
        return resMap;
    }

    @RequestMapping("/workbench/customer/saveCreateCustomer.do")
    @ResponseBody
    public Object saveCreateCustomer(HttpSession session,Customer customer){
        //封装参数
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        customer.setId(UUIDUtils.getUUID());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));


        ReturnObject returnObject=new ReturnObject();
        try {
            //调用Service保存customer
            int num = customerService.saveCreateCustomer(customer);
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

    @RequestMapping("/workbench/customer/removeCustomerByIds.do")
    @ResponseBody
    public Object removeCustomerByIds(String[] id){
        ReturnObject returnObject=new ReturnObject();

        try {
            //调用Service
            int num = customerService.removeCustomerByIds(id);

            //判断是否删除成功
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

    @RequestMapping("/workbench/customer/queryCustomerById.do")
    @ResponseBody
    public Object queryCustomerById(String customerId){
        ReturnObject returnObject=new ReturnObject();

        //调用service进行查询
        Customer customer = customerService.queryCustomerById(customerId);

        return customer;
    }

    @RequestMapping("/workbench/customer/renewCustomerById.do")
    @ResponseBody
    public Object renewCustomerById(Customer customer,HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        customer.setEditBy(user.getId());
        customer.setEditTime(DateUtils.formateDateTime(new Date()));

        ReturnObject returnObject=new ReturnObject();

        try {
            //调用service
            int num = customerService.renewCustomerById(customer);

            //判断是否修改成功
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

    @RequestMapping("/workbench/customer/toCustomerDetail.do")
    public String toCustomerDetail(String id,HttpServletRequest request){
        //调用service查询customer
        Customer customer = customerService.queryCustomerForDetailById(id);
        request.setAttribute("customer",customer);
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryCustomerRemarkForDetailByCustomerId(id);
        request.setAttribute("customerRemarkList",customerRemarkList);

        return "workbench/customer/detail";
    }



}
