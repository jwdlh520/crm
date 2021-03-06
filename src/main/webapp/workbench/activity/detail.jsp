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

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		//调用展示备注列表的方法
		reMarkList();
        //展示小图标
        $("#remarkBody").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        })
        $("#remarkBody").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        })

        //给添加按钮绑定事件，添加备注操作
        $("#saveRemarkBtn").click(function () {
            $.ajax({
                url : "workbench/activity/saveRemark.do",
                dataType : "json",
                type : "post",
                data : {
                    "noteContent" : $.trim($("#remark").val()),
                    "activityId" : "${activity.id}"
                },
                success : function (data) {
                    //data:{"success":true/false,"activityRemark":activityRemark}
                    if (data.success){
                        //将添加的备注展示在备注列表上
                        var html = "";
                        html += '<div id = "'+data.activityRemark.id+'" class="remarkDiv" style="height: 60px;">'
                        html += '<img title="'+data.activityRemark.noteContent+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                        html += '<div style="position: relative; top: -40px; left: 40px;" >'
                        html += '<h5 id="note'+data.activityRemark.id+'">'+data.activityRemark.noteContent+'</h5>'
                        html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="small'+data.activityRemark.id+'"> '+(data.activityRemark.createTime)+' 由'+ (data.activityRemark.createBy) +'</small>'
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                        html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" onclick="editRemark(\''+data.activityRemark.id+'\')" style="font-size: 20px; color: #FF0000;"></span></a>'
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;'
                        html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" onclick="delRemark(\''+data.activityRemark.id+'\')" style="font-size: 20px; color: #FF0000;"></span></a>'
                        html += '</div>'
                        html += '</div>'
                        html += '</div>'
                        $("#remarkDiv").before(html);
                        //清空文本域中的内容
                        $("#remark").val("");
                    }else {
                        alert("添加备注失败");
                    }
                }
            });
        })

        /*
        *   给修改备注的更新按钮绑定事件
        * */
        $("#updateRemarkBtn").click(function () {
            //获取id和noteContent
            var id = $("#remarkId").val();
            var noteContent = $.trim($("#noteContent").val());
            $.ajax({
                url : "workbench/activity/updateRemark.do",
                dataType : "json",
                type : "post",
                data : {
                    "id" : id,
                    "noteContent" : noteContent
                },
                success : function (data) {
                    //data : {"success":true/false,"remark":remark}
                    if (data.success){
                        //将该条备注上的信息替换：noteContent,editTime,editBy
                        $("#note" + id).html(data.remark.noteContent);
                        $("#small" + id).html(data.remark.editTime + " 由" + data.remark.editBy);
                        //关闭模态窗口
                        $("#editRemarkModal").modal("hide");
                    }else {
                        alert("修改备注失败");
                    }
                }
            });
        })
	});
	function reMarkList(){
		$.ajax({
			url : "workbench/activity/remarkList.do",
			dataType : "json",
			type : "get",
			data : {
				id : "${activity.id}"
			},
			success : function (data) {
				//data:[{备注1},{备注2},{备注3},...,]
				var html = "";
				$.each(data,function (i,n) {
                html += '<div id = "'+n.id+'" class="remarkDiv" style="height: 60px;">'
                html += '<img title="'+n.noteContent+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                html += '<div style="position: relative; top: -40px; left: 40px;" >'
                html += '<h5 id="note'+n.id+'">'+n.noteContent+'</h5>'
                html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="small'+n.id+'"> '+(n.editFlag==1?n.editTime:n.createTime)+' 由'+ (n.editFlag==1?n.editBy:n.createBy) +'</small>'
                html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" onclick="editRemark(\''+n.id+'\')" style="font-size: 20px; color: #FF0000;"></span></a>'
                html += '&nbsp;&nbsp;&nbsp;&nbsp;'
                    /*
                    *   注意：动态生成的元素中绑定事件，并且为回调函数中传递参数，这个参数需要在字符串里面
                    * */
                html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" onclick="delRemark(\''+n.id+'\')" style="font-size: 20px; color: #FF0000;"></span></a>'
                html += '</div>'
                html += '</div>'
                html += '</div>'

				})
				/*
					在指定的jQuery元素中添加元素有三种方法：
						1.html()；
						2.上一个元素-->append();
						3.下一个元素-->before();
						这里我们使用第三个方法
				* */
				$("#remarkDiv").before(html);

			}
		});
	}

	/*
	*   删除备注方法
	* */
	function delRemark(id) {
        $.ajax({
            url : "workbench/activity/delRemark.do",
            dataType : "json",
            type : "post",
            data : {
                "id" : id
            },
            success : function (data) {
                //data:{success:true/false}
                if (data.success){
                    //移除所选择删除的备注
                    //以下的操作不能满足需求
                    //reMarkList();

                    //选中需要删除的备至的jQuery对象
                    $("#" + id).remove();
                }else {
                    alert("删除备注失败");
                }
            }
        });
    }

    /*
    * 修改按钮事件
    * */
        function editRemark(id) {
            //获取noteContent
            var noteContent = $("#note" + id).html();
            //将noteContent写入到文本域中
            $("#noteContent").val(noteContent);
            //将该备注的id放入到隐藏域中
            $("#remarkId").val(id);
            //打开模态窗口
            $("#editRemarkModal").modal("show");
        }
	
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
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
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-marketActivityOwner">
                                    <option>zhangsan</option>
                                    <option>lisi</option>
                                    <option>wangwu</option>
                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name}<small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<!-- 备注2 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>