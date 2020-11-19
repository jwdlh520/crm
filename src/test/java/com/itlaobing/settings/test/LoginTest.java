package com.itlaobing.settings.test;

import com.itlaobing.crm.utils.DateTimeUtil;
import com.itlaobing.crm.utils.MD5Util;

public class LoginTest {
    public static void main(String[] args) {
        //1.验证用户名和密码：select * from tbl_user where loginAct = ? and loginPwd = ?

        //2.验证失效时间
        //设置失效时间
        String expireTime = "2019-11-10 13:32:20";
        //设置当前系统时间(使用日期工具类)
        String currentTime = DateTimeUtil.getSysTime();
        int res = currentTime.compareTo(expireTime);
       if (res > 0){
           System.out.println("登陆失败");
       }else {
           System.out.println("登陆成功");
       }
        System.out.println("------------------------");
       //3.验证账号的状态
        String lockState = "1"; //表示锁定状态
        if ("0".equals(lockState)){
            System.out.println("账号已锁定，请联系管理员");
        }else {
            System.out.println("登陆成功");
        }
        System.out.println("------------------------");
        //4.验证ip地址
        String ip = "192.168.1.3";
        String allowIp = "192.168.1.1,192.168.1.2";
        if (allowIp.contains(ip)){
            System.out.println("登陆成功");
        }else{
            System.out.println("登陆失败");
        }
        System.out.println("------------------------");
        //5.MD5加密技术
        //我们先将从前端获取到的密码加密，然后将密文与数据库的密码相比较
        String pwd = "lpcjwdlh520621...";
        pwd = MD5Util.getMD5(pwd);
        System.out.println(pwd);
    }
}
