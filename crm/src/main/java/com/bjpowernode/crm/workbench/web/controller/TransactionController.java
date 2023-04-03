package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.service.TransactionService;
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
public class TransactionController {

    @Autowired
    private TransactionService transactionService;
    @RequestMapping("/workbench/transaction/toTransactionIndex.do")
    public String toTransactionIndex(HttpServletRequest request){
        return "workbench/transaction/index";
    }

    @RequestMapping("/workbench/transaction/queryTransactionByConditionForPage.do")
    @ResponseBody
    public Object queryTransactionByConditionForPage(String owner,String name, String customerName,
                                               String stage,String type,String source,String contantsName,
                                                     int pageNo,int pageSize){
        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("owner",owner);
        map.put("name",name);
        map.put("customerName",customerName);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contantsName",contantsName);
        map.put("pageNo",(pageNo-1)*pageSize);  //这儿一定要注意，要不然会找死你
        map.put("pageSize",pageSize);

        //调用Service进行查询
        List<Tran> transList = transactionService.selectTransactionByCondition(map);
        int totalRows = transactionService.queryCountOfTransactionByConditionForPage(map);

        //将查询到的数据封装到map中，并返回给前端
        Map<String,Object> resMap=new HashMap<>();
        resMap.put("transList",transList);
        resMap.put("totalRows",totalRows);

        return resMap;

    }
}
