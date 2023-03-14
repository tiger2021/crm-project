<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%--添加js标签库--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core_1_1" %>

<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<%--引入日历的插件--%>
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<%--引入分页的插件--%>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<%--引入jQuery函数库--%>
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<%--引入bootstrap框架--%>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<%--引入日历的插件--%>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<%--引入分页的插件--%>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">


	<%--入口函数，整个页面加载完成之后，执行该函数中的语句--%>
	$(function(){

		//给“创建”添加单击事件
		$("#createActivityBtn").click(function(){
			//清空创建市场活动的模态窗口form表单中的内容
			//get(0)的作用是将jQuery对象转换为dom对象，然后用dom对象中的reset函数
			$("#createActivityForm").get(0).reset();

			//打开创建市场活动的模态窗口
			$("#createActivityModal").modal("show");

		})

		//给“保存”按钮添加单击事件
		$("#saveActivityBtn").click(function (){
			//获取表单数据
			var owner=$("#create-marketActivityOwner").val();
			var name=$.trim($("#create-marketActivityName").val());
			var startDate=$("#create-startTime").val();
			var endDate=$("#create-endTime").val();
			var cost=$("#create-cost").val();
			var description=$("#create-describe").val();

			//验证表单数据是否正确
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if(name==""){
				alert("活动名称不能为空");
				return;
			}
			if(startDate!="" && endDate!=""){
				if(startDate>endDate){
					alert("结束日期不能比开始日期小");
					return;
				}
			}
			//创建正则表达式用来验证成本
			var regExp=/^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能为非负整数");
				return;
			}

			//发送Ajax请求
			$.ajax({
				url:"workbench/activity/saveCreateActivity.do",
				data:{
					 owner:owner,
					 name:name,
					 startDate:startDate,
					 endDate:endDate,
					 cost:cost,
					 description:description
				},
				type:'post',
				dataType:'json',
				//处理响应
				success:function(data){
					if(data.code=="1"){
						//成功，关闭模态窗口
						$("#createActivityModal").modal("hide");
						queryActivityByConditionForPage(1,$("#demo_page1").bs_pagination('getOption','rowsPerPage'));
					}else{
						alert(data.message);
						$("#createActivityModal").modal("show");
					}
				}
					})

		})

		//当容器加载完成之后，对容器调用工具函数,在页面上显示日历(使用类加载器)
		$(".mydate").datetimepicker({
			language:'zh-CN',  //日历上显示的语言
			format:'yyyy-mm-dd',  //日期的格式
			minView:'month',   //可以选择的最小视图
			initialDate:new Date(),    //初始化显示的日期
			autoclose:true,    //设置选择完日期或者时间之后，是否自动关闭日历
			todayBtn:true,   //是否显示“今天”按钮
			clearBtn:true    //是否显示“清空按钮”
		});


		//当主页面加载完成之后，向后台发送Ajax请求，查询要显示的市场活动
		queryActivityByConditionForPage(1,10);

		//给“查询”按钮添加点击事件
		$("#queryActivityBtn").click(function (){
			queryActivityByConditionForPage(1,$("#demo_page1").bs_pagination('getOption','rowsPerPage'));
		})

		//给“全选”按钮添加单击事件
		$("#checkAll").click(function (){
			//选中tBody标签中的input中类型为checkbox的对象，prop是给属性赋值的
			$("#tBody input[type='checkbox']").prop("checked",this.checked);
		})
        //给列表中的所有checkBox添加点击事件,注意固有元素和动态生成元素的区别，选择器的书写格式会不同
		$("#tBody").on("click","input[type='checkbox']",function (){
			//判断列表中的所有checkbox是否全部是选中状态或取消状态
			//获取列表中所有被选中的checkbox的数量
			// $("#tBody input[type='checkbox']:checked").size()
			//获取列表中所有的checkbox的数量
			// $("#tBody input[type='checkbox']").size()
			if($("#tBody input[type='checkbox']").size()
					==$("#tBody input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked",true);
			}else{
				$("#checkAll").prop("checked",false);
			}
		});

		//给”删除“按钮添加单击事件
		$("#deleteActivityBtn").click(function (){
			var checkedIds=$("#tBody input[type='checkbox']:checked");
			if(checkedIds.size()==0) {
				alert("请选择需要删除的数据");
				return;
			}else{
				//提示用户是否确定要删除这些数据
				if(window.confirm("情定要删除吗？")==true){
					/*将需要删除的市场活动的id拼接成字符串，因为这里面的key都为id，所有的key都是相同的,
                    * 所以在发送Ajax请求的时候不能写为json的格式
                    * */
					var ids="";
					$.each(checkedIds,function (index,obj){
						ids+="id="+this.value+"&";
					});

					//删除拼接的字符最后多出来的&
					ids=ids.substr(0,ids.length-1);
					//发送Ajax请求
					$.ajax({
						url:"workbench/activity/deleteActivityByIds.do",
						type:"post",
						data:ids,
						success:function (data){
							if(data.code=="1"){
								//刷新市场活动页面
								queryActivityByConditionForPage(1,$("#demo_page1").bs_pagination('getOption','rowsPerPage'));
							}else{
								//显示提示信息
								alert(data.message);
							}
						}
					})
				}


			}
		});

		//给”修改"按钮添加点击事件
		$("#editActivityBtn").click(function (){
			//获取被选中的元素
			var checkedIds=$("#tBody input[type='checkbox']:checked");
			if(checkedIds.size()==0) {
				alert("请选择需要修改的数据");
				return;
			}else if(checkedIds.size()>1){
				alert("只能选择一条数据进行修改");
				return;
			}else {
				var id=checkedIds.val();

				//发送Ajax请求
				$.ajax({
					url:"workbench/activity/queryActivityById.do",
					type:'post',
					data:{id:id},
					success:function (data){
						//将后台发送过来的数据填写到模态窗口中
						$("#edit-activityId").val(data.id);
						//向下拉列表中填入信息
						$("#edit-marketActivityOwner").val(data.owner);
						$("#edit-marketActivityName").val(data.name);
						$("#edit-startTime").val(data.startDate);
						$("#edit-endTime").val(data.endDate);
						$("#edit-cost").val(data.cost);
						$("#edit-describe").val(data.description);
						//显示修改市场活动的模态窗口
						$("#editActivityModal").modal("show");
					}
				});
			}
		});

		//给“更新”按钮添加点击事件
		$("#activityUpdateBtn").click(function (){
			//获取表单数据
			var id=$("#edit-activityId").val();
			var owner=$("#edit-marketActivityOwner").val();
			var name=$.trim($("#edit-marketActivityName").val());
			var startDate=$("#edit-startTime").val();
			var endDate=$("#edit-endTime").val();
			var cost=$("#edit-cost").val();
			var description=$("#edit-describe").val();

			//验证表单数据是否正确
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if(name==""){
				alert("活动名称不能为空");
				return;
			}
			if(startDate!="" && endDate!=""){
				if(startDate>endDate){
					alert("结束日期不能比开始日期小");
					return;
				}
			}
			//创建正则表达式用来验证成本
			var regExp=/^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能为非负整数");
				return;
			}

			//发送Ajax请求
			$.ajax({
				url:"workbench/activity/saveEditActivityById.do",
				data:{
					id:id,
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:'post',
				dataType:'json',
				//处理响应
				success:function(data){
					if(data.code=="1"){
						//成功，关闭模态窗口
						$("#editActivityModal").modal("hide");
						queryActivityByConditionForPage(1,$("#demo_page1").bs_pagination('getOption','rowsPerPage'));
					}else{
						alert(data.message);
						$("#editActivityModal").modal("show");
					}
				}
			})

		})

	});


	//定义查询市场活动的函数
	function queryActivityByConditionForPage(pageNo,pageSize){
		//收集参数
		var name=$("#query-name").val();
		var owner=$("#query-owner").val();
		var startDate=$("#query-startDate").val();
		var endDate=$("#query-endDate").val();

		//向后台发送Ajax请求
		$.ajax({
			url:"workbench/activity/queryActivityByConditionForPage.do",
			type:"post",
			data: {
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				pageNo:pageNo,
				pageSize:pageSize
			},
			success:function (data){
				//显示查询出的市场活动的总记录数
				$("#totalRowsB").text(data.totalRows);
				//遍历List，拼接字符串
				var htmlStr="";
				$.each(data.activityList,function (index,activity){
					htmlStr+="<tr class=\"active\">"
					htmlStr+="<td><input type=\"checkbox\" value=\""+activity.id+"\"/></td>"
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\">"+activity.name+"</a></td>"
					htmlStr+="<td>"+activity.owner+"</td>"
					htmlStr+="<td>"+activity.startDate+"</td>"
					htmlStr+="<td>"+activity.endDate+"</td>"
					htmlStr+="</tr>"
				});
				$("#tBody").html(htmlStr);

				//取消全选按钮
				$("#checkAll").prop("checked",false);

				//计算总页数
				var totalPages=1;
				if(data.totalRows%pageSize==0){
					totalPages=data.totalRows/pageSize;
				}else{
					//parseInt()用来取整数部分的，  eval()模拟执行js代码
					totalPages=parseInt(data.totalRows/pageSize)+1;
				}

				//对容器调用bs_pagination工具函数，显示翻页信息
				$("#demo_page1").bs_pagination({
					currentPage:pageNo,//当前页号,相当于pageNo

					rowsPerPage:pageSize,//每页显示条数,相当于pageSize
					totalRows:data.totalRows,//总条数
					totalPages: totalPages,  //总页数,必填参数.

					visiblePageLinks:5,//最多可以显示的卡片数

					showGoToPage:true,//是否显示"跳转到"部分,默认true--显示
					showRowsPerPage:true,//是否显示"每页显示条数"部分。默认true--显示
					showRowsInfo:true,//是否显示记录的信息，默认true--显示

					//用户每次切换页号，都自动触发本函数;
					//每次返回切换页号之后的pageNo和pageSize
					onChangePage: function(event,pageObj) { // returns page_num and rows_per_page after a link has clicked
						//js代码
						queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		})
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
				
					<form class="form-horizontal" role="form" id="createActivityForm">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								 <c:forEach items="${userList}" var="user">
									 <option value="${user.id}">${user.name}</option>
								 </c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-endTime" readonly>
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
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveActivityBtn">保存</button>
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
                       <%--这儿设置一个隐藏域用来保存市场活动的id--%>
						<input type="hidden" id="edit-activityId">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-startTime"  readonly>
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-endTime" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="activityUpdateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
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
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >开始日期</div>
					  <input class="form-control mydate" type="text" id="query-startDate" readonly />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control mydate" type="text" id="query-endDate" readonly>
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>

				<%--显示分页--%>
				<div id="demo_page1"></div>
			</div>


<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB"></b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
<%--			</div>--%>
			
		</div>
		
	</div>
</body>
</html>