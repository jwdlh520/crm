package com.itlaobing.crm.settings.domain;

/*
* 关于字符串的日期和时间，市面上一般有两种形式：
*   1.日期
*       年月日：yyyy-MM-dd--->10位
*   2.日期 + 时间
*       yyyy-MM-dd HH:mm:ss--->19位
* */

/*
*   关于登陆
*       sql语句：select * from tbl_user where loginAct = ? and loginPwd = ?
*       返回值应该位User对象，因为之后不仅仅是验证用户名和密码匹配就能够使用，还要验证账号的状态，ip地址是否在范围之内
*           若用户为null，则账号密码不正确
*           若用户不为null，则账号密码正确
*       还需要验证：
*           expireTime 失效时间
*           lockState  账号状态
*           allowIps   运行范围的ip地址
* */
public class User {
    private String id;  //id，主键
    private String loginAct;    //登陆账号
    private String name;    //真实姓名
    private String loginPwd;    //登陆密码
    private String email;   //邮箱
    private String expireTime;  //失效时间
    private String lockState;   //锁定状态 0表示锁定 1表示启用
    private String deptno;  //部门编号
    private String allowIps;    //运行访问的ip地址
    private String createTime;  //创建时间
    private String createBy;    //创建人
    private String editTime;    //修改时间
    private String editBy;  //修改人

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLoginAct() {
        return loginAct;
    }

    public void setLoginAct(String loginAct) {
        this.loginAct = loginAct;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLoginPwd() {
        return loginPwd;
    }

    public void setLoginPwd(String loginPwd) {
        this.loginPwd = loginPwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(String expireTime) {
        this.expireTime = expireTime;
    }

    public String getLockState() {
        return lockState;
    }

    public void setLockState(String lockState) {
        this.lockState = lockState;
    }

    public String getDeptno() {
        return deptno;
    }

    public void setDeptno(String deptno) {
        this.deptno = deptno;
    }

    public String getAllowIps() {
        return allowIps;
    }

    public void setAllowIps(String allowIps) {
        this.allowIps = allowIps;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getEditTime() {
        return editTime;
    }

    public void setEditTime(String editTime) {
        this.editTime = editTime;
    }

    public String getEditBy() {
        return editBy;
    }

    public void setEditBy(String editBy) {
        this.editBy = editBy;
    }

    @Override
    public String toString() {
        return "User{" +
                "id='" + id + '\'' +
                ", loginAct='" + loginAct + '\'' +
                ", name='" + name + '\'' +
                ", loginPwd='" + loginPwd + '\'' +
                ", email='" + email + '\'' +
                ", expireTime='" + expireTime + '\'' +
                ", lockState='" + lockState + '\'' +
                ", deptno='" + deptno + '\'' +
                ", allowIps='" + allowIps + '\'' +
                ", createTime='" + createTime + '\'' +
                ", createBy='" + createBy + '\'' +
                ", editTime='" + editTime + '\'' +
                ", editBy='" + editBy + '\'' +
                '}';
    }
}
