package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @Author 小镇做题家
 * @create 2023/4/2 12:19
 * @Description:
 */
@Controller
public class ClueRemarkController {
    @Autowired
    private ClueRemarkService clueRemarkService;

    @RequestMapping("/workbench/clue/saveClueRemark.do")
    @ResponseBody
    public Object saveClueRemark(ClueRemark clueRemark, HttpSession session){
        //封装参数
        clueRemark.setId(UUIDUtils.getUUID());
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        clueRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);

        ReturnObject returnObject=new ReturnObject();
        try {
            //调用service方法
            int num = clueRemarkService.saveClueRemark(clueRemark);
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
        returnObject.setRetData(clueRemark);
        return returnObject;
    }

    @RequestMapping("/workbench/clue/removeClueRemarkById.do")
    @ResponseBody
    public Object removeClueRemarkById(String id){
        ReturnObject returnObject=new ReturnObject();

        try {
            int num = clueRemarkService.deleteClueRemarkById(id);
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

    @RequestMapping("/workbench/clue/renewClueRemark.do")
    @ResponseBody
    public Object renewClueRemark(ClueRemark clueRemark,HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        clueRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(DateUtils.formateDateTime(new Date()));

        ReturnObject returnObject=new ReturnObject();
        try {
            int num = clueRemarkService.updateClueRemarkById(clueRemark);
            if(num>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clueRemark);
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
