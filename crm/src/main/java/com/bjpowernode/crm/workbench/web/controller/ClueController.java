package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

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
    private ActivityService activityService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

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
        clue.setId(UUIDUtils.getUUID());
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtils.formateDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用clueService
            int num = clueService.saveClue(clue);
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


    @RequestMapping("/workbench/clue/queryClueByConditionsForPage.do")
    @ResponseBody
    public Object queryClueByConditionsForPage(String fullname,String company,String phone,String mphone,
                                               String source,String owner,String state,int pageNo,int pageSize){
        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("state",state);
        map.put("pageNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调用service
        List<Clue> clueList = clueService.queryClueByConditionsForPage(map);
        int totalRows=clueService.queryCountOfClueByCondition(map);
        Map<String,Object> retMap=new HashMap<>();
        retMap.put("clueList",clueList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }

    @RequestMapping("/workbench/clue/removeCluesByIds.do")
    @ResponseBody
    public Object removeCluesByIds(String[] id){
        ReturnObject returnObject=new ReturnObject();

        try {
            int num = clueService.deleteCluesByIds(id);
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

    @RequestMapping("/workbench/clue/queryClueById.do")
    @ResponseBody
    public Object queryClueById(String id){
        ReturnObject returnObject=new ReturnObject();
        Clue clue = clueService.queryClueById(id);
        if(clue==null){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }else{
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(clue);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/renewClue.do")
    @ResponseBody
    public Object renewClue(Clue clue,HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formateDateTime(new Date()));

        ReturnObject returnObject=new ReturnObject();

        //调用service
        try {
            int num = clueService.updateClueById(clue);

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

    @RequestMapping("/workbench/clue/toClueDetail.do")
    public String toClueDetail(String id,HttpServletRequest request){
        Clue clue = clueService.selectClueByIdForDetail(id);
        request.setAttribute("clue",clue);

        List<ClueRemark> remarkList = clueRemarkService.selectClueRemarkByClueIdForClueDetail(id);
        request.setAttribute("remarkList",remarkList);

        List<Activity> activityList = activityService.queryActivityForClueDetailByClueId(id);
        request.setAttribute("activityList",activityList);

        return "/workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/queryActivityForClueDetailByNameClueId.do")
    @ResponseBody
    public Object queryActivityForClueDetailByNameClueId(String activityName,String clueId){
        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);

        List<Activity> activityList = activityService.queryActivityForClueDetailByNameClueId(map);

        //返回响应信息
        return activityList;
    }


    @RequestMapping("/workbench/clue/queryActivityForConvertByNameClueId.do")
    @ResponseBody
    public Object queryActivityForConvertByNameClueId(String activityName,String clueId){
        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);
        List<Activity> activityList = activityService.selectActivityForConvertByNameClueId(map);
        //返回响应信息
        return activityList;

    }


}
