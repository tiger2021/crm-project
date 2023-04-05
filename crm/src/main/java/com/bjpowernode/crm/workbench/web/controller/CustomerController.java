package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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


    @RequestMapping("/workbench/customer/toCustomerIndex.do")
    public String toCustomerIndex(){
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
}
