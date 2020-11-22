<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href=" <%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-3.4.1.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">

        $(function () {
            //1.打开登陆页面时自动聚焦到账号文本框上
            $("#loginAct").focus();

            //2.刷新页面时将文本框中的内容清空
            $("#loginAct").val("");
            $("#loginPwd").val("");

            //3.给登陆按钮绑定鼠标单击事件
            $("#loginBtn").click(function () {
                //判断账号和密码是否为空,需要去除左右的空格，使用trim() jQuery中有一个$.trim(文本值);
               login();
            });

            //4.使用回车键也可以出发登录事件
            $(window).keydown(function (event) {
               if (event.keyCode == 13){
                       login();
               }
            });
        })

        /*
        * 注意：当我们要在<script>标签中定义函数，需要在$(function(){})的外面定义
        *       原因：在后面的动态生成标签的时候，如果写在里面，可能会加载不出来
        * */
        function login() {
            var loginAct = $.trim($("#loginAct").val());
            var loginPwd = $.trim($("#loginPwd").val());
            if (loginAct == "" || loginPwd == ""){
                //输出错误信息
                $("#msg").html("账号和密码不能为空！！！");
                return false;
            }
                $.ajax({
                    url : "settings/user/login.do",
                    data : {
                        "loginAct" : loginAct,
                        "loginPwd" : loginPwd
                    },
                    dataType : "json",
                    type : "post",
                    success : function (data) {
                        //json对象中信息{success:true/false,msg:错误的信息}
                        if (data.success){
                            document.location.href="workbench/index.html";
                        }else {
                            $("#msg").html(data.msg);
                        }
                    }
                })
        }
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;&nbsp;今晚打老虎</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.html" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPwd">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <%--
                    注意：当按钮放在表单标签之间，系统会默认为submit标签，这样就直接提交表单了。这不是我们想要的，所以要改为button标签
                --%>
                <button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>