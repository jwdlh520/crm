<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">

        $(function () {
            //自动补全插件
            $("#create-customerName").typeahead({
                source: function (query, process) {
                    $.get(
                        "workbench/transaction/getCustomerName.do",
                        {"name": query},
                        function (data) {
                            //alert(data);
                            process(data);
                        },
                        "json"
                    );
                },
                //延迟时间
                delay: 1500
            });

            //给查询按钮绑定事件
            $("#searchBtn").click(function () {
                pageList(1,2);
            })

            //页面加载完成后发送ajax请求，局部刷新交易的列表
            pageList(1, 2);
        });

        function pageList(pageNo, pageSize) {
            $.ajax({
                url: "workbench/transaction/getTranList.do",
                dataType: "json",
                type: "get",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "owner": $.trim($("#owner").val()),
                    "customerName": $.trim($("#customerName").val()),
                    "name": $.trim($("#name").val()),
                    "stage": $.trim($("#stage").val()),
                    "type": $.trim($("#type").val()),
                    "source": $.trim($("#source").val()),
                    "contactName": $.trim($("#contactName").val())
                },
                success: function (data) {
                    /*
                    * 	data:
                    * 		["total":total,"dataList":{{交易1},{交易2},{交易3},{交易4}}]
                    * */
                    var html = "";
                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input name="dx" type="checkbox" value="' + n.id + '" /></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+n.id+'\';">' + n.name + "-" + n.description + '</a></td>';
                        html += '<td>' + n.name + '</td>';
                        html += '<td>' + n.stage + '</td>';
                        html += '<td>' + n.type + '</td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.source + '</td>';
                        html += '<td>' + n.contactSummary + '</td>';
                        html += '</tr>';
                    })
                    $("#tranBody").html(html);

                    //计算总页数
                    var totalPages = data.total%pageSize==0 ? data.total/pageSize :  parseInt(data.total/pageSize)+1;
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
                        onChangePage : function(event, data){
                            pageList(data.currentPage , data.rowsPerPage);
                        }
                    });
                }
            });

        }

    </script>
</head>
<body>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="customerName">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">阶段</div>
                        <select class="form-control" id="stage">
                            <option></option>
                            <c:forEach var="stage" items="${stage}">
                                <option value="${stage.value}">${stage.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select class="form-control" id="type">
                            <option></option>
                            <c:forEach items="${transactionType}" var="transactionType">
                                <option value="${transactionType.value}">${transactionType.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="source">
                            <option></option>
                            <c:forEach items="${source}" var="source">
                                <option value="${source.value}">${source.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">联系人名称</div>
                        <input class="form-control" type="text" id="contactName">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary"
                        onclick="window.location.href='workbench/transaction/add.do';"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default"
                        onclick="window.location.href='workbench/transaction/edit.jsp';"><span
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
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody id="tranBody">
                <%--<tr>
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点-交易01</a></td>
                    <td>动力节点</td>
                    <td>谈判/复审</td>
                    <td>新业务</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>李四</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点-交易01</a></td>
                    <td>动力节点</td>
                    <td>谈判/复审</td>
                    <td>新业务</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>李四</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage"></div>
        </div>

    </div>

</div>
</body>
</html>