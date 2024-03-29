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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#createCustomerRemark").focus(function(){
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


		$("#remarkDivList").on("mouseover",".remarkDiv",function (){
			$(this).children("div").children("div").show();
		})

		$("#remarkDivList").on("mouseout",".remarkDiv",function (){
			$(this).children("div").children("div").hide();
		})

		$("#remarkDivList").on("mouseover",".myHref",function (){
			$(this).children("span").css("color","red");
		})

		$("#remarkDivList").on("mouseout",".myHref",function (){
			$(this).children("span").css("color","#E6E6E6");
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


		//调用queryTransactionAndContactsByCustomerId()
		queryTransactionAndContactsByCustomerId();

		//给“保存”按钮添加单击事件
		$("#saveCreateCustomerRemarkBtn").click(function (){
			//收集参数
			var noteContent=$.trim($("#createCustomerRemark").val());
			var customerId='${customer.id}';
			//验证表单
			if(noteContent==""){
				alert("请输入评论");
				return;
			}else {
				//发送Ajax请求
				$.ajax({
					url: "workbench/customer/insertCustomerRemark.do",
					type: "post",
					data: {
						noteContent: noteContent,
						customerId: customerId
					},
					dataType: "json",
					success: function (data) {
						if(data.code=="1"){
							//清空输入框
							$("#createCustomerRemark").val("");
							//拼接数据
							var htmlStr="";
							htmlStr+="<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
							htmlStr+="<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
							htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
							htmlStr+="<h5>"+data.retData.noteContent+"</h5>";
							htmlStr+="<font color=\"gray\">客户</font> <font color=\"gray\">-</font> <b>${customer.name}</b> <small style=\"color: gray;\"> "+data.retData.createTime+"由${sessionScope.sessionUser.name}创建</small>";
							htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
							htmlStr+="<a remarkId="+data.retData.id+" name=\"editA\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
							htmlStr+="<a remarkId="+data.retData.id+" name=\"deleteA\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr+="</div>";
							htmlStr+="</div>";
							htmlStr+="</div>";
							$("#createCustomerRemark").before(htmlStr);

							//该语句的作用为重新加载页面
							window.location.reload();

						}else {
							alert(data.message);
						}

					}


				});
			}
		});

		//给所有”删除评论的图标“添加单击事件
		$("#remarkDivList").on("click","a[name=deleteA]",function (){
			var id=$(this).attr("remarkId");  //this代表正在被点击的dom对象
			//向后台发送Ajax请求
			$.ajax({
				url:"workbench/customer/deleteCustomerRemarkById.do",
				type: "post",
				data:{
					id:id
				},
				dataType: "json",
				success:function (data){
					if(data.code=='1'){
						//刷新备注列表,删除div
						$("#div_"+id).remove();
					}else{
						alert(data.message);
					}
				}

			})
		})

		//给所有”修改评论的图标“按钮添加单击事件
		$("#remarkDivList").on("click","a[name=editA]",function (){
			// 获取活动评论的id
			var id=$(this).attr("remarkId");
			//获得notecontent,在h5前面要记得加空格
			var noteContent=$("#div_"+id+" h5").text();
			//把备注的id和noteContent写到修改备注的模态窗口中
			$("#edit_id").val(id);     //先将活动评论的id写在模态窗口中
			$("#edit_noteContent").text(noteContent);
			//弹出修改市场活动备注的模态窗口
			$("#editRemarkModal").modal("show");
		});

		//给更新评论的按钮添加单击事件
		$("#updateRemarkBtn").click(function (){
			//收集参数
			var id=$("#edit_id").val();
			var noteContent=$.trim($("#edit_noteContent").val());

			//验证表单
			if(noteContent==""){
				alert("请输入修改的评论");
				return;
			}else{
				//发送Ajax请求
				$.ajax({
					url:"workbench/customer/updateCustomerRemarkById.do",
					type:"post",
					data:{
						id:id,
						noteContent:noteContent
					},
					dataType:"json",
					success:function (data){
						if(data.code=="0"){
							alert(data.message);
						}else{
							//关闭模态窗口
							$("#editRemarkModal").modal("hide");
							//刷新备注列表
							$("#div_"+id+" h5").text(data.retData.noteContent);
							//更新时间和修改者
							$("#div_"+id+" small").text(" "+data.retData.editTime+" 由${sessionScope.sessionUser.name}修改")

						}
					}
				})
			}
		});

		//给所有”删除交易图标“添加单击事件
		$("#transactionTBody").on("click","a[name=transactionDeleteA]",function (){
			//提示用户是否确定要删除这些数据
			if(window.confirm("确定要删除吗？")==true) {
				var id = $(this).attr("deleteTransactionId");  //this代表正在被点击的dom对象
				//向后台发送Ajax请求
				$.ajax({
					url: "workbench/transaction/deleteTransactionAndTransactionRemarkByTransactionId.do",
					type: "post",
					data: {
						id: id
					},
					dataType: "json",
					success: function (data) {
						if (data.code == '1') {
							//调用queryTransactionAndContactsByCustomerId()
							queryTransactionAndContactsByCustomerId();

						} else {
							alert(data.message);
						}
					}

				})
			}
		})

		//给所有”删除联系人图标“添加单击事件
		$("#contactsTBody").on("click","a[name=contactsDeleteA]",function (){
			//提示用户是否确定要删除这些数据
			if(window.confirm("确定要删除吗？")==true) {
				var id = $(this).attr("deleteContactsId");  //this代表正在被点击的dom对象
				//向后台发送Ajax请求
				$.ajax({
					url: "workbench/contacts/removeContactsForDetailByIds.do",
					type: "post",
					data: {
						id: id
					},
					dataType: "json",
					success: function (data) {
						if (data.code == '1') {
							//调用queryTransactionAndContactsByCustomerId()
							queryTransactionAndContactsByCustomerId();

						} else {
							alert(data.message);
						}
					}

				})
			}
		})

		//给”新建联系人“按钮添加单击时间
		$("#createContactsBtn").click(function (){
			//清空创建交易的模态窗口form表单中的内容
			//get(0)的作用是将jQuery对象转换为dom对象，然后用dom对象中的reset函数
			$("#createContactForm").get(0).reset();

			//显示创建客户的模态窗口
			$("#createContactModal").modal("show");

		});

		//给“保存”按钮添加单击事件
		$("#saveCreateContactsBtn").click(function (){
			//收集参数
			var owner=$("#create-owner").val();
			var source=$("#create-source").val();
			var fullname=$("#create-fullname").val();
			var appellation=$("#create-appellation").val();
			var job=$("#create-job").val();
			var mphone=$("#create-mphone").val();
			var email=$("#create-email").val();
			var nextContactTime=$("#create-nextContactTime").val();
			var customerId=$("#create-customerId").val();
			var description=$("#create-description").val();
			var contactSummary=$("#create-contactSummary").val();
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
				url:"workbench/contacts/saveCreateContacts.do",
				data:{
					owner:owner,
					source:source,
					fullname:fullname,
					appellation:appellation,
					job:job,
					mphone:mphone,
					email:email,
					nextContactTime:nextContactTime,
					customerId:customerId,
					description:description,
					contactSummary:contactSummary,
					address:address
				},
				type:'post',
				dataType:'json',
				//处理响应
				success:function(data){
					if(data.code=="1"){
						//成功，关闭模态窗口
						$("#createContactModal").modal("hide");
						queryTransactionAndContactsByCustomerId();
					}else{
						alert(data.message);
						$("#createContactModal").modal("show");
					}
				}
			})

		});

	});

	//定义查询交易和联系人的函数
	function queryTransactionAndContactsByCustomerId(){
		//收集参数
		var customerId="${customer.id}";

		//向后台发送Ajax请求
		$.ajax({
			url:"workbench/customer/queryTransactionAndContactsByCustomerId.do",
			type:"post",
			data:{
				customerId:customerId
			},
			dataType:"json",
			success:function (data){
				//将查询到的交易信息展示到对应的地方
				var tranHtmlStr="";
				$.each(data.tranList,function (index,tran){
					tranHtmlStr+="<tr id=\"transaction-"+tran.id+"\">";
					tranHtmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\"  onclick=\"window.location.href='workbench/transaction/toTransactionDetail.do?id="+tran.id+"'\">"+tran.name+"</a></td>";
					tranHtmlStr+="<td>"+tran.money+"</td>";
					tranHtmlStr+="<td>"+tran.stage+"</td>";
					tranHtmlStr+="<td>"+tran.possibility+"</td>";
					tranHtmlStr+="<td>"+tran.expectedDate+"</td>";
					tranHtmlStr+="<td>"+tran.type+"</td>";
					tranHtmlStr+="<td><a deleteTransactionId=\""+tran.id+"\" name=\"transactionDeleteA\" href=\"javascript:void(0);\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>删除</a></td>";
					tranHtmlStr+="</tr>";
				});
				$("#transactionTBody").html( tranHtmlStr)

				//将查询到的联系人信息展示到对应的地方
				var contactsHtmlStr="";
				$.each(data.contactList,function (index,contacts){
					contactsHtmlStr+="<tr>";
					contactsHtmlStr+="<td><a href=\"workbench/contacts/toContactDetails.do?contactsId="+contacts.id+"\"  style=\"text-decoration: none;\">"+contacts.fullname+"</a></td>";
					contactsHtmlStr+="<td>"+contacts.email+"</td>";
					contactsHtmlStr+="<td>"+contacts.mphone+"</td>";
					contactsHtmlStr+="<td><a deleteContactsId=\""+contacts.id+"\" name=\"contactsDeleteA\" href=\"javascript:void(0);\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>删除</a></td>";
					contactsHtmlStr+="</tr>";
				});
				$("#contactsTBody").html(contactsHtmlStr)
			}
		});

	}
	
</script>

</head>
<body>

<!-- 修改客户备注的模态窗口 -->
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
					<input type="hidden" id="edit_id">
					<div class="form-group">
						<label for="edit_noteContent" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="edit_noteContent"></textarea>
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


        <!-- 创建联系人的模态窗口 -->
        <div class="modal fade" id="createContactModal" role="dialog">
	        <div class="modal-dialog" role="document" style="width: 85%;">
		        <div class="modal-content">
			        <div class="modal-header">
				        <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
					        <span aria-hidden="true">×</span>
				        </button>
				        <h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
			        </div>
			        <div class="modal-body">
				        <form class="form-horizontal" role="form" id="createContactForm">
					        <div class="form-group">
						        <label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						        <div class="col-sm-10" style="width: 300px;">
							        <select class="form-control" id="create-owner">
								        <c:forEach items="${ownerList}" var="owner">
									        <option value="${owner.id}">${owner.name}</option>
								        </c:forEach>
							        </select>
						        </div>
						        <label for="create-source" class="col-sm-2 control-label">来源</label>
						        <div class="col-sm-10" style="width: 300px;">
							        <select class="form-control" id="create-source">
								        <option></option>
								        <option>广告</option>
								        <option>推销电话</option>
								        <option>员工介绍</option>
								        <option>外部介绍</option>
								        <option>在线商场</option>
								        <option>合作伙伴</option>
								        <option>公开媒介</option>
								        <option>销售邮件</option>
								        <option>合作伙伴研讨会</option>
								        <option>内部研讨会</option>
								        <option>交易会</option>
								        <option>web下载</option>
								        <option>web调研</option>
								        <option>聊天</option>
							        </select>
						        </div>
					        </div>
					        <div class="form-group">
						        <label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
						        <div class="col-sm-10" style="width: 300px;">
							        <input type="text" class="form-control" id="create-fullname">
						        </div>
						        <label for="create-appellation" class="col-sm-2 control-label">称呼</label>
						        <div class="col-sm-10" style="width: 300px;">
							        <select class="form-control" id="create-appellation">
								        <option></option>
								        <option>先生</option>
								        <option>夫人</option>
								        <option>女士</option>
								        <option>博士</option>
								        <option>教授</option>
							        </select>
						        </div>
					        </div>
					        <div class="form-group">
						        <label for="create-job" class="col-sm-2 control-label">职位</label>
						        <div class="col-sm-10" style="width: 300px;">
							        <input type="text" class="form-control" id="create-job">
						        </div>
						        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
						        <div class="col-sm-10" style="width: 300px;">
							        <input type="text" class="form-control" id="create-mphone">
						        </div>
					        </div>
					        <div class="form-group" style="position: relative;">
						        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
						        <div class="col-sm-10" style="width: 300px;">
							        <input type="text" class="form-control" id="create-email">
						        </div>
						        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
						        <div class="col-sm-10" style="width: 300px;">
							        <input type="text" class="form-control mydate" id="create-nextContactTime" readonly>
						        </div>
					        </div>
					        <div class="form-group" style="position: relative;">
						        <label for="create-customerId" class="col-sm-2 control-label">客户名称</label>
						        <div class="col-sm-10" style="width: 300px;">
							        <input type="text" class="form-control" id="create-customerId" placeholder="支持自动补全，输入客户不存在则新建">
						        </div>
					        </div>
					        <div class="form-group" style="position: relative;">
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
				        <button type="button" class="btn btn-primary" id="saveCreateContactsBtn">保存</button>
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
			<h3>${customer.name} </h3>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${customer.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${customer.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${customer.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 10px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<%--遍历remarkList--%>
		<c:forEach items="${customerRemarkList}" var="cr" >
			<div id="div_${cr.id}" class="remarkDiv" style="height: 60px;">
				<img title="${cr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${cr.noteContent}</h5>
					<font color="gray">客户</font> <font color="gray">-</font> <b>${customer.name}</b> <small style="color: gray;">${cr.editFlag=='1'?cr.editTime:cr.createTime}  由${cr.editFlag=='1'?cr.editBy:cr.createBy}  ${cr.editFlag=='1'?'修改':'创建'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
							<%--修改图标--%>
						<a remarkId="${cr.id}" name="editA" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;<%--删除图标--%>
						<a remarkId="${cr.id}" name="deleteA" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
<%--		<!-- 备注1 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">客户</font> <font color="gray">-</font> <b>北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--		--%>
<%--		<!-- 备注2 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>呵呵！</h5>--%>
<%--				<font color="gray">客户</font> <font color="gray">-</font> <b>北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="createCustomerRemark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" id="saveCreateCustomerRemarkBtn" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="transactionTBody">

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/transaction/toTransactionSave.do" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactsTBody">
<%--						<tr>--%>
<%--							<td><a href="contacts/detail.jsp" style="text-decoration: none;">李四</a></td>--%>
<%--							<td>lisi@bjpowernode.com</td>--%>
<%--							<td>13543645364</td>--%>
<%--							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="createContactsBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>