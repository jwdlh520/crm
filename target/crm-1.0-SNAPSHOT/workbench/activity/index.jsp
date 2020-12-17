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
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <%--
        js代码区
    --%>
    <script type="text/javascript">

        $(function () {
            //引入bootStrap的日期框架，使用class标签
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            /*
            * 	实现模态窗口的方式：
            * 		需要获取模态窗口的jQuery对象，调用modal方法，为该方法传递参数show：打开模态窗口 hid：隐藏模态窗口
            * */
            $("#addBtn").click(function () {
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

                            /*
                            * 注意：对于表单元素，使用js代码进行表单的提交和重置的操作：
                            *       提交可以使用jQuery代码调用submit()方法，但是重置只能使用原生js调用reset()方法，虽然jQuery中有reset()方法，但是不起作用
                            *
                            *       jQuery对象转换为dom对象：
                            *           $("#xxx")[i]    $("#xxx").get(i)
                            *       dom对象转换为jQuery对象：
                            *           $(dom)
                            * */
                            //刷新列表

                            //清空模态窗口的表单信息
                            $("#create-form")[0].reset();
                            //关闭模态窗口
                            $("#createActivityModal").modal("hide");
                            /*
                            *   这个方法是在用户修改分页组件的原有基础上发送ajax请求，保留用户之前的视角
                            *   $("#activityPage").bs_pagination('getOption', 'currentPage')：当前的页数
                            *   $("#activityPage").bs_pagination('getOption', 'rowsPerPage')：没页展示的条数
                            *   保存之后回到第一页，并且保持原有每页展示的条数
                            * */
                            pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            alert("活动信息添加失败");
                        }
                    }
                });
            });

            //查询按钮绑定事件
            $("#searchBtn").click(function () {
                /*
                    一个问题：当条件查询的时候，修改搜索框中的信息且未按钮搜索按钮，点击分页组件，会将新的信息当作查询条件来进行查询
                        解决：一个隐藏域中保存搜索过后的信息，当触发pageList方法的时候，将搜索框中的内容改为隐藏域中的内容
                * */
                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-startTime").val($.trim($("#search-startTime").val()));
                $("#hidden-endTime").val($.trim($("#search-endTime").val()));
                pageList(1, 2);
            });

            //在页面加载完成之后，向后台获取数据，刷新列表
            //在第一页展现两条记录
            pageList(1, 2);

            //全选按钮绑定事件
            $("#allChecked").click(function () {
                //将单选框全部选中，checked属性设置为全选框一样的
                $("input[name=singleChecked]").prop("checked", this.checked);
            });

            /*
                当单选框有一个没选中，全选框需要不选择
                注意：动态生成的元素不能直接以 dom对象.事件名();的形式绑定事件，需要使用on()方法来绑定事件
                    语法：$(需要绑定元素的最外层的有效的元素).on("事件名",需要绑定事件的jQuery对象,回调函数);
            * */
            $("#pageListBody").on("click", $("input[name=singleChecked]"), function () {
                //单选框的数量等于单选框被选中的数量，全选框就选中
                $("#allChecked").prop("checked", $("input[name=singleChecked]").length == $("input[name=singleChecked]:checked").length);
            })

            /*
                删除操作
            * */
            $("#delBtn").click(function () {
                //1.获取被选中的所有复选框，获取到value值.由于向后台传送数据的时候，一个id属性对应多个值，必须使用传统请求方式，而且是一个ajax请求
                //workbench/activity/delete.do?id=xxx&id=xxx......

                var $fx = $("input[name=singleChecked]:checked");
                var param = "";
                if ($fx.length == 0) {
                    alert("请选择需要删除的活动");
                } else {
                    for (var i = 0; i < $fx.length; i++) {
                        param += "id=" + $($fx[i]).val();
                        if (i < $fx.length - 1) {
                            param += "&";
                        }
                    }
                }
                if (confirm("您确定要删除吗？")){
                    $.ajax({
                        url: "workbench/activity/delete.do",
                        data : param,
                        dataType: "json",
                        type: "post",
                        success: function (data) {
                            //data:{"success":true/false}
                            if (data.success) {
                                //成功就进行一次ajax请求，刷新页面

                                /*
                                *   点击删除按钮之后，页面应该跳转到第一页，并且保持原本每页展示的条数
                                *
                                * */
                                pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                alert("删除活动信息失败");
                            }
                        }
                    });
                }
            })

            //给修改按钮绑定事件
            $("#editBtn").click(function () {
                //发送ajax请求，获取选中的活动信息的id
                var $ids = $(":checkbox:checked");
                if ($ids.length == 0){
                    alert("请选择需要修改的活动");
                }else if ($ids.length > 1){
                    alert("一次只能修改一条记录");
                }else {
                    var id = $ids.val();
                    $.ajax({
                        url : "workbench/activity/get.do",
                        dataType : "json",
                        type : "get",
                        data : {
                            "id" : id
                        },
                        success : function (data) {
                            //data:{"uList":[{用户1},{用户2},...],"activity":{属性,属性}}
                            var html = "<option></option>";
                            $.each(data.uList,function (i,n) {
                                html += "<option value='"+n.id+"'>"+n.name+"</option>";
                            })
                            $("#edit-owner").html(html);
                            //在隐藏域中设置表单的id，指定是哪一个活动对象
                            $("#edit-id").val(data.activity.id);
                            $("#edit-name").val(data.activity.name);
                            $("#edit-startDate").val(data.activity.startDate);
                            $("#edit-endDate").val(data.activity.endDate);
                            $("#edit-cost").val(data.activity.cost);
                            $("#edit-description").val(data.activity.description);

                            //打开模态窗口
                            $("#editActivityModal").modal("show");
                        }
                    });

                }
            })

            //为更新按钮绑定事件
            $("#updateBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/update.do",
                    dataType: "json",
                    //增删改查登录使用post 其他的使用get
                    type: "post",
                    data: {
                        id : $("#edit-id").val(),
                        owner: $.trim($("#edit-owner").val()),
                        name: $.trim($("#edit-name").val()),
                        startDate: $.trim($("#edit-startDate").val()),
                        endDate: $.trim($("#edit-endDate").val()),
                        cost: $.trim($("#edit-cost").val()),
                        description: $.trim($("#edit-description").val())
                    },
                    success: function (data) {
                        //data：{success:true/false}
                        if (data.success) {
                            alert("活动信息修改成功");
                            //关闭模态窗口
                            $("#editActivityModal").modal("hide");
                            //再调用一次pageList()方法
                            /*
                            *   点击修改的更新按钮之后，停留在当前的页数，并且每页展示的条数不变
                            * */
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            alert("活动信息修改失败");
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        }
                    }
                });
            })


        }); //页面加载函数结尾

        function pageList(pageNo, pageSize) {
            //在执行该方法的时候，将全选框的钩去掉
            $("#allChecked").prop("checked", false);
            //调用该方法的时候，将搜索框的内容替换为隐藏域中的内容
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-startTime").val($.trim($("#hidden-startTime").val()));
            $("#search-endTime").val($.trim($("#hidden-endTime").val()));

            /*
                对于所有的关系型数据库，前端分页操作的基础组件就是pageList(pageNo,pageSize)方法
                    pageNo：页数
                    pageSize：一页的条数

                pageList()方法就是向后台发送ajax请求，从后台获取到最新的活动信息，局部刷新活动列表

                我们在哪些情况下需要调用pageList(pageNo,pageSize)方法？
                    1.点击市场活动进入index.jsp时    true
                    2.点击创建，修改，删除按钮的时候
                    3.点击查询按钮的时候             true
                    4.点击分页的组件的时候            true
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
                        html += '<td><input type="checkbox" name="singleChecked" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;"';
                        //''里面包含""，""又包含''，这时候需要转义;
                        html += 'onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">' + n.name + '</a></td>';
                        //数据库中的活动表的owner是用户表中用户的id值。因为option的value值就是用户的id。所以在后台需要结合用户表将owner转换为姓名
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.startDate + '</td>';
                        html += '<td>' + n.endDate + '</td>';
                        html += '</tr>';
                    });
                    $("#pageListBody").html(html);
                    //计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
                    //处理完代码之后，实现分页操作
                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        //这个回调函数在点击分页组件时触发，不要动
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });
                }
            });
        }
    </script>
</head>
<body>
<%--隐藏域--%>
<input type="hidden" id="hidden-name"></input>
<input type="hidden" id="hidden-owner"></input>
<input type="hidden" id="hidden-startTime"></input>
<input type="hidden" id="hidden-endTime"></input>
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
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">

                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate" readonly>
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <%--
                                关于textarea注意两点：
                                    1.textarea一定要以标签对的形式出现，标签对一定要紧紧挨着，中间不要有空格，因为会把空格当作文本输出
                                    2.获取textarea的值或者给textarea中赋值时，还是使用val()方法，把它当作表单元素使用(不使用html()方法)
                            --%>
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="updateBtn">更新</button>
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
                        <input class="form-control time" type="text" id="search-startTime" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endTime" readonly>
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
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus"></span>
                    删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="allChecked"/></td>
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

        <%--
            分页组件部分
        --%>
        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage"></div>
        </div>

    </div>

</div>
</body>
</html>