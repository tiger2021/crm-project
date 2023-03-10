package com.bjpowernode.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @Author 小镇做题家
 * @create 2023/3/10 13:51
 */
public class DataUtils {

    /**
     * @description: 返回带有时分秒的时间的字符串
     * @param: [date]
     * @return: java.lang.String
     **/
    public static String formateDateTime(Date date){
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(date);
    }


    /**
     * @description: 返回只有年月日的时间的字符串
     * @param: [date]
     * @return: java.lang.String
     **/
    public static String formateDate(Date date){
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }
}
