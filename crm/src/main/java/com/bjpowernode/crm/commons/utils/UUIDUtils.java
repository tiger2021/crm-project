package com.bjpowernode.crm.commons.utils;

import java.util.UUID;

/**
 * @Description:用来生成不重复的id
 * @Author 小镇做题家
 * @create 2023/3/11 14:13
 */
public class UUIDUtils {
    public static String getUUID(){
         return UUID.randomUUID().toString().replaceAll("-", "");
    }
}
