<%@ page import="com.itlaobing.crm.settings.domain.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">

        $(function () {
            /*
            * 	实现模态窗口的方式：
            * 		需要获取模态窗口的jQuery对象，调用modal方法，为该方法传递参数show：打开模态窗口 hid：隐藏模态窗口
            * */
            $("#addBtn").click(function () {
                //引入bootStrap的日期框架，使用class标签
                $(".time").datetimepicker({
                    minView: "month",
                    language: 'zh-CN',
                    format: 'yyyy-mm-dd',
                    autoclose: true,
                    todayBtn: true,
                    pickerPosition: "bottom-left"
                });
                //这样就可以在打开模态窗口之前添加其他的操作了。
                //注意：id选择器一定不要忘记"#"

                //在模态窗口打开之前，获取tbl_user中所有的user的名字
                $.ajax({
                    url: "workbench/activity/QueryUserAll.do",
                    dataType: "json",
                    type: "get",
                    success: function (data) {
                        //拼接下拉列表,必须先默认给一个空的<option>标签
                        var html = "<option></option>";
                        //遍历所有用户，data：[{id:"?",name:"?",......},{}]-->json数组
                        $.each(data, function (i, n) {
                            //n就是json数组中的每一个json对象
                            html += "<option value = '" + n.id + "'>" + n.name + "</option>";
                        })
                        //一定要加"#"
                        $("#create-owner").html(html);

                        //默认当前登陆用户为默认选中
                        /*
                        * 	在js中使用el表达式，需要将el表达式写在字符串里面，否则无法识别
                        * */
                        var id = "${user.id}";
                        $("#create-owner").val(id);
                    }
                })

                $("#createActivityModal").modal("show");
            });

            //给保存按钮绑定事件
            $("#saveBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/save.do",
                    dataType: "json",
                    //增删改查登录使用post 其他的使用get
                    type: "post",
                    data: {
                        owner: $.trim($("#create-owner").val()),
                        name: $.trim($("#create-name").val()),
                        startDate: $.trim($("#create-startTime").val()),
                        endDate: $.trim($("#create-endTime").val()),
                        cost: $.trim($("#create-cost").val()),
                        description: $.trim($("#create-description").val())
                    },
                    success: function (data) {
                        //data：{success:true/false}
                        if (data.success) {
                            //添加成功
                            //刷新活动列表(局部刷新)

                            //清空模态窗口的表单信息
                            /*
                            * 注意：对于表单元素，使用js代码进行表单的提交和重置的操作：
                            *       提交可以使用jQuery代码调用submit()方法，但是重置只能使用原生js调用reset()方法，虽然jQuery中有reset()方法，但是不起作用
                            *
                            *       jQuery对象转换为dom对象：
                            *           $("#xxx")[i]    $("#xxx").get(i)
                            *       dom对象转换为jQuery对象：
                            *           $(dom)
                            * */
                            $("#create-form")[0].reset();
                            //关闭模态窗口
                            $("#createActivityModal").modal("hide");
                        } else {
                            alert("活动信息添加失败");
                        }
                    }
                });
            });

            //查询按钮绑定事件
            $("#searchBtn").click(function () {
                pageList(1, 2);
            });

            //在页面加载完成之后，向后台获取数据，刷新列表
            //在第一页展现两条记录
            pageList(1, 2);
        });

        function pageList(pageNo, pageSize) {
            /*
                对于所有的关系型数据库，前端分页操作的基础组件就是pageList(pageNo,pageSize)方法
                    pageNo：页数
                    pageSize：一页的条数

                pageList()方法就是向后台发送ajax请求，从后台获取到最新的活动信息，局部刷新活动列表

                我们在哪些情况下需要调用pageList(pageNo,pageSize)方法？
                    1.点击市场活动进入index.jsp时
                    2.点击创建，修改，删除按钮的时候
                    3.点击查询按钮的时候
                    4.点击分页的组件的时候
                一共有6个入口需要使用到pageList()方法，我们需要调用该方法发送ajax请求进行局部刷新
            * */
            $.ajax({
                url: "workbench/activity/pageList.do",
                dataType: "json",
                type: "get",
                //查询语句使用动态sql
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startTime").val()),
                    "endDate": $.trim($("#search-endTime").val()),
                },
                success: function (data) {
                    //我们需要的是活动信息列表，分页插件需要的是总条数
                    //data:{"total" : xxx,"pageList" : [{活动信息1},{活动信息2}，...]}
                    var html = "";
                    $.each(data.dataList, function (i, n) {
                        //n代表每一个活动对象
                        html += '<tr class="active">';
                        //复选框的value值应该为活动的id
                        html += '<td><input type="checkbox" value="'+n.id+'"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;"';
                        //''里面包含""，""又包含''，这时候需要转义;
                        html += 'onclick="window.location.href=\'workbench/activity/detail.jsp\';">'+n.name+'</a></td>';
                        //数据库中的活动表的owner是用户表中用户的id值。因为option的value值就是用户的id。所以在后台需要结合用户表将owner转换为姓名
                        html += '<td>'+n.owner+'</td>';
                        html += '<td>'+n.startDate+'</td>';
                        html += '<td>'+n.endDate+'</td>';
                        html += '</tr>';
                    });
                    $("#pageListBody").html(html);
                }
            });
        }
    </script>
</head>
<body>
<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="create-form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">

                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <%--
                                使用readonly属性使输入框为只能读，不能手写，但是可以选择日期
                            --%>
                            <input type="text" class="form-control time" id="create-startTime" readonly>
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endTime" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <%--
                    对于保存按钮，我们在保存活动信息的时候，需要发送给服务器一个ajax请求，效果为：
                        1.活动信息存储在活动表中
                        2.在市场活动列表中显示出新添加的活动信息（局部刷新）

                        data-dismiss="modal" ：关闭模态窗口
                --%>
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control" type="text" id="search-startTime"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control" type="text" id="search-endTime">
                    </div>
                </div>

                <button type="button" id="searchBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <%--
                    模态窗口：
                        data-toggle="modal"：表示点击这个按钮，弹出一个模态窗口
                        data-target="#createActivityModal"：表示要打开具体的模态窗口

                        这样有一个问题：
                            在打开模态窗口之前我们不能添加其他的功能，所以我们需要将这个按钮绑定事件，使用js代码来实现打开模态窗口的功能
                --%>
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span>
                    创建
                </button>
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="pageListBody">
                <%--<tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                        10
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="#">20</a></li>
                        <li><a href="#">30</a></li>
                    </ul>
                </div>
                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <li class="disabled"><a href="#">首页</a></li>
                        <li class="disabled"><a href="#">上一页</a></li>
                        <li class="active"><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">下一页</a></li>
                        <li class="disabled"><a href="#">末页</a></li>
                    </ul>
                </nav>
            </div>
        </div>

    </div>

</div>
</body>
</html>