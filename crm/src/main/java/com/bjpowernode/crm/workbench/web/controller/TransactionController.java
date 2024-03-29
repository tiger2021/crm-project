package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.domain.TranRemark;
import com.bjpowernode.crm.workbench.service.CustomerService;
import com.bjpowernode.crm.workbench.service.TranHistoryService;
import com.bjpowernode.crm.workbench.service.TranRemarkService;
import com.bjpowernode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/10 21:35
 */
@Controller
public class TransactionController {

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private TransactionService transactionService;



    @Autowired
    private CustomerService customerService;

    @Autowired
    private TranRemarkService tranRemarkService;

    @Autowired
    private TranHistoryService tranHistoryService;


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

    @RequestMapping("/workbench/transaction/toTransactionSave.do")
    public String toTransactionSave(HttpServletRequest request){
        //调用service层方法，查询动态数据
        List<User> userList=userService.queryAllUsers();
        List<DicValue> stageList=dicValueService.queryDicValueByTypeCode("stage");
        //把数据保存到request中
        request.setAttribute("userList",userList);
        request.setAttribute("stageList",stageList);

        return "workbench/transaction/save";
    }


    @RequestMapping("/workbench/transaction/getPossibilityByStage.do")
    @ResponseBody
    public Object getPossibilityByStage(String stageValue){
        //解析properties配置文件，根据阶段获取可能性
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageValue);
        //返回响应信息
        return  possibility;

    }

    @RequestMapping("/workbench/transaction/queryCustomerNameByName.do")
    @ResponseBody
    public Object queryCustomerNameByName(String customerName){
        List<String> customerNameList = customerService.queryCustomerNameByName(customerName);
        return customerNameList;
    }


    @RequestMapping("/workbench/transaction/saveCreateTransaction.do")
    @ResponseBody
    public Object saveCreateTransaction(@RequestParam Map<String,Object> map, HttpSession session){
        //封装参数
        map.put(Contants.SESSION_USER,session.getAttribute(Contants.SESSION_USER));

        ReturnObject returnObject=new ReturnObject();

        try {
            transactionService.saveCreateTran(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/transaction/toTransactionDetail.do")
    public String toTransactionDetail(String id,HttpServletRequest request){
        //调用service层方法，查询相关数据
        Tran tran = transactionService.queryTransactionForDetailById(id);
        List<TranRemark> tranRemarkList = tranRemarkService.queryTransactionRemarkForDetailByTranId(id);
        List<TranHistory> tranHistorieList = tranHistoryService.queryTranHistoryForDetailByTranId(id);

        //根据tran所处阶段名称查询可能性
        String stageValue=tran.getStage();
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageValue);
        tran.setPossibility(possibility);

        //将响应的数据添加到请求域中
        request.setAttribute("tran",tran);
        request.setAttribute("tranRemarkList",tranRemarkList);
        request.setAttribute("tranHistorieList",tranHistorieList);

        //调用service方法，查询交易所有的阶段,将来在前端显示“交易阶段”时使用
        List<DicValue> stageList=dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("stageList",stageList);

        return "/workbench/transaction/detail";
    }

    @RequestMapping("/workbench/transaction/deleteTransactionAndTransactionRemarkByTransactionId.do")
    @ResponseBody
    public Object deleteTransactionAndTransactionRemarkByTransactionId(String id){
        ReturnObject returnObject=new ReturnObject();

        try {
            //调对应的service进行操作
            transactionService.deleteTransactionAndTransactionRemarkByTransactionId(id);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }


    @RequestMapping("/workbench/transaction/removeTransactionsByIds.do")
    @ResponseBody
    public Object removeTransactionsByIds(String[] id){

        ReturnObject returnObject=new ReturnObject();

        try {
            //调用service删除transaction
            transactionService.removeTransactionsByIds(id);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }

        return returnObject;
    }


    @RequestMapping("/workbench/transaction/saveTransactionRemark.do")
    @ResponseBody
    public Object saveTransactionRemark(TranRemark tranRemark,HttpSession session){
        //封装参数，保存交易评论
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        tranRemark.setId(UUIDUtils.getUUID());
        tranRemark.setCreateBy(user.getId());
        tranRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        tranRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);

        ReturnObject returnObject=new ReturnObject();

        try {
            //调用Service保存
            int num = tranRemarkService.insertTranRemark(tranRemark);
            //判断是否保存成功
            if(num>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(tranRemark);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return returnObject;
    }


    @RequestMapping("/workbench/transaction/updateTransactionRemarkById.do")
    @ResponseBody
    public Object updateTransactionRemarkById(TranRemark tranRemark,HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        tranRemark.setEditBy(user.getId());
        tranRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        tranRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);

        ReturnObject returnObject=new ReturnObject();

        try {
            //调用service
            int num = tranRemarkService.updateTransactionRemarkById(tranRemark);

            //判断是否保存成功
            if(num>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(tranRemark);
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


    @RequestMapping("/workbench/transaction/removeTransactionRemarkById.do")
    @ResponseBody
    public Object removeTransactionRemarkById(String id){

        ReturnObject returnObject=new ReturnObject();

        try {
            //调用service
            int num = tranRemarkService.removeTransactionRemarkById(id);

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


}
