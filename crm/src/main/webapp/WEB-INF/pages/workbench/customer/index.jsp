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
<%--入口函数--%>
	$(function(){
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

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
		queryCustomerByConditionForPage(1,10);

		//给“查询”按钮添加单击事件
		$("#queryCustomerBtn").click(function (){
			queryCustomerByConditionForPage(1,$("#demo_page1").bs_pagination('getOption','rowsPerPage'));
		});

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

		//给“创建”按钮添加单击事件
		$("#createCustomerBtn").click(function (){
			//清空创建交易的模态窗口form表单中的内容
			//get(0)的作用是将jQuery对象转换为dom对象，然后用dom对象中的reset函数
			$("#createCustomerForm").get(0).reset();

			//显示创建客户的模态窗口
			$("#createCustomerModal").modal("show");
		});

		//给“保存”按钮添加单击事件
		$("#saveCreateCustomerBtn").click(function (){
			//收集参数
			var owner=$("#create-owner").val();
			var name=$("#create-name").val();
			var website=$("#create-website").val();
			var phone=$("#create-phone").val();
			var description=$("#create-description").val();
			var contactSummary=$("#create-contactSummary").val();
			var nextContactTime=$("#create-nextContactTime").val();
			var address=$("#create-address").val();


			//验证表单数据是否正确
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if(name==""){
				alert("活动名称不能为空");
				return;
			}

			//发送Ajax请求
			$.ajax({
				url:"workbench/customer/saveCreateCustomer.do",
				data:{
					owner:owner,
					name:name,
					website:website,
					phone:phone,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				type:'post',
				dataType:'json',
				//处理响应
				success:function(data){
					if(data.code=="1"){
						//成功，关闭模态窗口
						$("#createCustomerModal").modal("hide");
						queryCustomerByConditionForPage(1,$("#demo_page1").bs_pagination('getOption','rowsPerPage'));
					}else{
						alert(data.message);
						$("#createCustomerModal").modal("show");
					}
				}
			})

		});

		//给”删除“按钮添加单击事件
		$("#deleteCustomerBtn").click(function (){
			var checkedIds=$("#tBody input[type='checkbox']:checked");
			if(checkedIds.size()==0) {
				alert("请选择需要删除的数据");
				return;
			}else{
				//提示用户是否确定要删除这些数据
				if(window.confirm("确定要删除吗？")==true){
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
						url:"workbench/customer/removeCustomerByIds.do",
						type:"post",
						data:ids,
						success:function (data){
							if(data.code=="1"){
								//刷新市场活动页面
								queryCustomerByConditionForPage(1,$("#demo_page1").bs_pagination('getOption','rowsPerPage'));
							}else{
								//显示提示信息
								alert(data.message);
							}
						}
					})
				}


			}
		});

		//给“修改”按钮添加单击事件
		$("#editCustomerBtn").click(function (){

				//获取被选中的元素
				var checkedIds=$("#tBody input[type='checkbox']:checked");
				if(checkedIds.size()==0) {
					alert("请选择需要修改的数据");
					return;
				}else if(checkedIds.size()>1){
					alert("只能选择一条数据进行修改");
					return;
				}else {
					var customerId=checkedIds.val();

					//发送Ajax请求
					$.ajax({
						url:"workbench/customer/queryCustomerById.do",
						type:'post',
						data:{customerId:customerId},
						success:function (data){
							//将后台发送过来的数据填写到模态窗口中
							$("#edit-customerId").val(data.id);
							//向下拉列表中填入信息
							$("#edit-customerOwner").val(data.owner);
							$("#edit-customerName").val(data.name);
							$("#edit-website").val(data.website);
							$("#edit-phone").val(data.phone);
							$("#edit-description").val(data.description);
							$("#edit-contactSummary").val(data.contactSummary);
							$("#edit-nextContactTime").val(data.nextContactTime);
							$("#edit-address").val(data.address);
							//显示修改市场活动的模态窗口
							$("#editCustomerModal").modal("show");
						}
					});
				}
		});

		//给“更新”按钮添加点击事件
		$("#updateCustomerBtn").click(function (){
			//获取表单数据
			var id=$("#edit-customerId").val();
			var owner=$("#edit-customerOwner").val();
			var name=$("#edit-customerName").val();
			var website=$("#edit-website").val();
			var phone=$("#edit-phone").val();
			var description=$("#edit-description").val();
			var contactSummary=$("#edit-contactSummary").val();
			var nextContactTime=$("#edit-nextContactTime").val();
			var address=$("#edit-address").val();

			//验证表单数据是否正确
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if(name==""){
				alert("活动名称不能为空");
				return;
			}

			//发送Ajax请求
			$.ajax({
				url:"workbench/customer/renewCustomerById.do",
				data:{
					id:id,
					owner:owner,
					name:name,
					website:website,
					phone:phone,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					description:description
				},
				type:'post',
				dataType:'json',
				//处理响应
				success:function(data){
					if(data.code=="1"){
						//成功，关闭模态窗口
						$("#editCustomerModal").modal("hide");
						//刷新市场活动页面
						queryCustomerByConditionForPage(1,$("#demo_page1").bs_pagination('getOption','rowsPerPage'));
					}else{
						alert(data.message);
						$("#editCustomerModal").modal("show");
					}
				}
			})

		})


		
	});

	//定义查询市场活动的函数
	function queryCustomerByConditionForPage(pageNo,pageSize){
		//收集参数
		var name=$("#query-name").val();
		var owner=$("#query-owner").val();
		var phone=$("#query-phone").val();
		var website=$("#query-website").val();

		//向后台发送Ajax请求
		$.ajax({
			url:"workbench/customer/queryCustomerForPageByCondition.do",
			type:"post",
			data: {
				name:name,
				owner:owner,
				phone:phone,
				website:website,
				pageNo:pageNo,
				pageSize:pageSize
			},
			success:function (data){
				//显示查询出的市场活动的总记录数
				$("#totalRowsB").text(data.totalRows);
				//遍历List，拼接字符串
				var htmlStr="";
				$.each(data.customerList,function (index,customer){
					htmlStr+="<tr>";
					htmlStr+="<td><input type=\"checkbox\" value=\""+customer.id+"\"/></td>";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/customer/toCustomerDetail.do?id="+customer.id+"'\">"+customer.name+"</a></td>";
					htmlStr+="<td>"+customer.owner+"</td>";
					htmlStr+="<td>"+customer.phone+"</td>";
					htmlStr+="<td>"+customer.website+"</td>";
					htmlStr+="</tr>";
				});
				$("#tBody").html(htmlStr);


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
						queryCustomerByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		})
	}
	
</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createCustomerForm">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
									<c:forEach items="${ownerList}" var="owner">
										<option value="${owner.id}">${owner.name}</option>
									</c:forEach>
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control mydate" id="create-nextContactTime" readonly>
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateCustomerBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<%--这儿设置一个隐藏域用来保存市场活动的id--%>
						<input type="hidden" id="edit-customerId">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
									<c:forEach items="${ownerList}" var="owner">
										<option value="${owner.id}">${owner.name}</option>
									</c:forEach>
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" >
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" >
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control mydate" id="edit-nextContactTime" readonly>
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateCustomerBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
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
				      <input class="form-control" id="query-name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="query-owner" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" id="query-phone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" id="query-website" type="text">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryCustomerBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createCustomerBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editCustomerBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteCustomerBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="tBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>http://www.bjpowernode.com</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>010-84846003</td>--%>
<%--                            <td>http://www.bjpowernode.com</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>

				<%--显示分页--%>
				<div id="demo_page1"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
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