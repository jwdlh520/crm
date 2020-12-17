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

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			initialDate: new Date(),//初始化当前日期
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		//为"搜索图标"绑定实际，打开模态窗口
		$("#openSearchModalBtn").click(function () {
			$("#searchActivityModal").modal("show");
		})

		//为搜索按钮绑定按键事件
		$("#searchBtn").keydown(function (event) {
			if (event.keyCode == 13){
				$.ajax({
					url : "workbench/clue/pageListByName.do",
					dataType : "json",
					type : "get",
					data : {
						//这里只需要获取名字
						"name" : $.trim($("#searchBtn").val())
					},
					success : function (data) {
						/*
							data:
								[{1},{2},{3}]
						* */
						var html = "";
						$.each(data,function (i,n) {
						html += '<tr>';
						html += '<td><input type="radio" value="'+n.id+'" name="dx"/></td>';
						html += '<td id="'+n.id+'">'+n.name+'</td>';
						html += '<td>'+n.startDate+'</td>';
						html += '<td>'+n.endDate+'</td>';
						html += '<td>'+n.owner+'</td>';
						html += '</tr>';
						})
						$("#activityList").html(html);
					}
				});
				return false;
			}
		})

		//为提交按钮绑定事件
		$("#submitBtn").click(function () {
			//获取选中的活动的id
			var id = $("input[name=dx]:checked").val();
			//获取活动的名称
			var name = $("#"+id).html();
			//将活动名称填充到市场活动源下面的文本框中
			$("#activity").val(name);
			//将活动的id保存在隐藏域当中
			$("#activityId").val(id);
			//关闭模态窗口
			$("#searchActivityModal").modal("hide");
		})

		//为转换按钮绑定事件
		$("#tranBtn").click(function () {
			//判断"为客户创建交易"复选框是否被选中
			if($("#isCreateTransaction").prop("checked")){
				//alert("需要为客户创建交易");
				/*
					如果使用传统发送请求的方式向后台发送请求方式：
						超链接
						window.location.href
						表单：优点：
							1.可以发送post请求，而其他的只能发送get请求
							2.可以批量地传递参数，不需要手动的添加。(需要在每一个表单元素中添加name属性，后台通过name获取到参数)
						当参数是敏感的信息，例如：金钱，密码等需要使用post请求
				* */
				//如果需要为客户创建交易，使用提交form的方式
				$("#convertForm").submit();
			}else {
				//alert("不需要为客户创建交易");
				//只需要向后台传递clueId
				window.location.href="workbench/clue/convert.do?clueId=${param.id}";
			}
		})
	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchBtn" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityList">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitBtn">提交</button>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${param.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${param.fullname}${param.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form method="post" id="convertForm" action="workbench/clue/convert.do">
			<%--
				隐藏域获取clueId
			--%>
		  <input type="hidden" value="true" name="flag">
		  <input type="hidden" value="${param.id}" name="clueId">
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="${param.company}" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control time" id="expectedClosingDate" name="expectedDate" readonly>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage" class="form-control" name="stage">
		    	<option></option>
				<c:forEach items="${applicationScope.stage}" var="item">
					<option value="${item.value}">${item.text}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchModalBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
			<input type="hidden" id="activityId" name="activityId">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${param.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" value="转换" id="tranBtn">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" onclick="window.history.back()" value="取消">
	</div>
</body>
</html>