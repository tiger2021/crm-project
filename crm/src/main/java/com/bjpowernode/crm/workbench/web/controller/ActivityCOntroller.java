package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.HSSFUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;

/**
 * @Description:
 * @Author 小镇做题家
 * @create 2023/3/10 21:14
 */
@Controller
public class ActivityCOntroller {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityRemarkService activityRemarkService;


    @RequestMapping("/workbench/activity/toActivityIndex.do")
    public String toActivityIndex(HttpServletRequest request){
        //查询用户的信息
        List<User> userList = userService.queryAllUsers();
        //将查询出的信息返回给前端页面
        request.setAttribute("userList",userList);
        //进行页面的跳转
        return "workbench/activity/index";
    }


    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveCreateActivity(Activity activity, HttpSession session){
        //封装参数信息
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setCreateBy(user.getId());

        ReturnObject returnObject = new ReturnObject();

        try{
            //调用service插入数据
            int num = activityService.saveCreateActivity(activity);

            if(num>0){      //成功插入数据
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("创建成功");
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍侯.....");
            }

    } catch (Exception e) {
        e.printStackTrace();
        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
        returnObject.setMessage("系统繁忙，请稍侯.....");
    }

        //向前端返回信息
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(String name,String owner,String startDate,
                                                  String endDate,int pageNo,int pageSize){
        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("pageNo",(pageNo-1)*pageSize);  //这儿一定要注意，要不然会找死你
        map.put("pageSize",pageSize);

        //调用service，查询数据
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryCountOfActivityByConditionForPage(map);

        //将查询到的数据封装到map中，并返回给前端
        Map<String,Object> resMap=new HashMap<>();
        resMap.put("activityList",activityList);
        resMap.put("totalRows",totalRows);
        return resMap;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = activityService.deleteActivityByIds(id);
            if(ret==0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("当前系统繁忙，请稍后删除");
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("当前系统繁忙，请稍后删除");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id){
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    @RequestMapping("/workbench/activity/saveEditActivityById.do")
    @ResponseBody
    public Object saveEditActivityById(Activity activity,HttpSession session){
        //封装参数
        User editor = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setEditBy(editor.getId());
        activity.setEditTime(DateUtils.formateDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service修改数据库中的数据
            int num = activityService.saveEditActivityById(activity);
            if(num==0){
                //未修改成功
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙.....");
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙.....");
        }
        return returnObject;
    }

    //查询所有的市场活动，然后以Excel文件的形式让前端下载
    @RequestMapping("/workbench/activity/exportAllActivities.do")
    public void exportAllActivities(HttpServletResponse response)throws Exception{
        //调用service曾查询市场活动
        List<Activity> activityList = activityService.queryAllActivities();

        //创建excel文件对象，把activity List写入到excel文件中
        HSSFWorkbook wb = new HSSFWorkbook();
        //创建表单对象
        HSSFSheet sheet = wb.createSheet("市场活动表单");
        //创建表单中的行对象
        HSSFRow row = sheet.createRow(0);
        //创建每一行中的列对象
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("活动名称");
        cell = row.createCell(3);
        cell.setCellValue("活动开始时间");
        cell = row.createCell(4);
        cell.setCellValue("活动结束时间");
        cell = row.createCell(5);
        cell.setCellValue("活动成本");
        cell = row.createCell(6);
        cell.setCellValue("活动描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        //将activityList中的数据插入到excel表中
        if(activityList!=null || activityList.size()!=0){
            //遍历
            Activity activity;
            for (int i = 0; i < activityList.size(); i++) {
                activity=activityList.get(i);
                //创建表单中的行对象
                row = sheet.createRow(i+1);
                //创建每一行中的列对象
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }

//        //根据web对象生成excel文件，然后存放在硬盘上
//        FileOutputStream os = new FileOutputStream("F:\\Study\\Project\\crm-project\\activityList.xml");
//        wb.write(os);
        //关闭资源
//        os.close();
//        wb.close();

        //把生成的文件下载到客户端
        //防止浏览器将生成的文件直接打开,设置响应头信息
        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");
        //设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //获取输出流对象
        ServletOutputStream outputStream = response.getOutputStream();
        wb.write(outputStream);
        wb.close();
//        //用文件输入流将刚才存在自己硬盘上的excel文件读到内存区中
//        FileInputStream is = new FileInputStream("F:\\Study\\Project\\crm-project\\activityList.xml");
//        //将文件写到客户端浏览器上
//        //定义一个缓存区
//        byte[] buff = new byte[1024];
//        int len=0;  //记录buff中的字节的数量
//        while((len=is.read(buff))!=-1){
//            outputStream.write(buff,0,len);
//        }
//        is.close();
        outputStream.flush();  //将输出流中的内容响应到浏览器
    }


    //查询客户选择的市场活动，然后以Excel文件的形式让前端下载
    @RequestMapping("/workbench/activity/exportActivitiesByIds.do")
    public void exportActivitiesByIds(String[] id,HttpServletResponse response)throws Exception{
        System.out.println(id);
        //调用service曾查询市场活动
        List<Activity> activityList = activityService.queryActivitiesByIds(id);

        //创建excel文件对象，把activity List写入到excel文件中
        HSSFWorkbook wb = new HSSFWorkbook();
        //创建表单对象
        HSSFSheet sheet = wb.createSheet("市场活动表单");
        //创建表单中的行对象
        HSSFRow row = sheet.createRow(0);
        //创建每一行中的列对象
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("活动名称");
        cell = row.createCell(3);
        cell.setCellValue("活动开始时间");
        cell = row.createCell(4);
        cell.setCellValue("活动结束时间");
        cell = row.createCell(5);
        cell.setCellValue("活动成本");
        cell = row.createCell(6);
        cell.setCellValue("活动描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        //将activityList中的数据插入到excel表中
        if(activityList!=null || activityList.size()!=0){
            //遍历
            Activity activity;
            for (int i = 0; i < activityList.size(); i++) {
                activity=activityList.get(i);
                //创建表单中的行对象
                row = sheet.createRow(i+1);
                //创建每一行中的列对象
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }
        //把生成的文件下载到客户端
        //防止浏览器将生成的文件直接打开,设置响应头信息
        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");
        //设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //获取输出流对象
        ServletOutputStream outputStream = response.getOutputStream();
        wb.write(outputStream);
        wb.close();
        outputStream.flush();  //将输出流中的内容响应到浏览器
    }


    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile activityFile,HttpSession session){
        User user=(User) session.getAttribute(Contants.SESSION_USER);  //获得当前登录的用户
        ReturnObject returnObject=new ReturnObject();
        try {
            InputStream is = activityFile.getInputStream();
            HSSFWorkbook wb = new HSSFWorkbook(is);
            HSSFSheet sheet = wb.getSheetAt(0);
            HSSFRow row=null;
            HSSFCell cell=null;
            Activity activity=null;
            List<Activity> activityList=new ArrayList<>();
            for(int i=1;i<=sheet.getLastRowNum();i++) {//sheet.getLastRowNum()：最后一行的下标
                row=sheet.getRow(i);//行的下标，下标从0开始，依次增加
                activity=new Activity();
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateTime(DateUtils.formateDateTime(new Date()));
                activity.setCreateBy(user.getId());

                for(int j=0;j<row.getLastCellNum();j++) {//row.getLastCellNum():最后一列的下标+1
                    //根据row获取HSSFCell对象，封装了一列的所有信息
                    cell=row.getCell(j);//列的下标，下标从0开始，依次增加
                    //获取列中的数据
                    String cellValue= HSSFUtils.getCellValueForStr(cell);
                    if(j==0){
                        activity.setName(cellValue);
                    }else if(j==1){
                        activity.setStartDate(cellValue);
                    }else if(j==2){
                        activity.setEndDate(cellValue);
                    }else if(j==3){
                        activity.setCost(cellValue);
                    }else if(j==4){
                        activity.setDescription(cellValue);
                    }
                }
                //每一行中所有列都封装完成之后，把activity保存到list中
                activityList.add(activity);
            }
            int num = activityService.saveCreateActivityByList(activityList);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(num);
        } catch (IOException e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }
       return returnObject;
    }

    @RequestMapping("/workbench/activity/avtivityDetail.do")
    public String queryActivityDetail(String id,HttpServletRequest request){
        Activity activity = activityService.queryActivityForDetailById(id);
        List<ActivityRemark> remarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
        request.setAttribute("activity",activity);
        request.setAttribute("remarkList",remarkList);
        return "workbench/activity/detail";
    }

}
