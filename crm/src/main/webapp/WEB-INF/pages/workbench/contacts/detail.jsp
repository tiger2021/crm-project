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
		$("#createContactsRemark").focus(function(){
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

		//给“删除”联系人按钮添加单击事件
		$("#deleteContactBtn").click(function (){
			var id="${contact.id}";
			//发送Ajax请求
			$.ajax({
				url:"workbench/contacts/removeContactsForDetailByIds.do",
				type:"post",
				data:{id:id},
				success:function (data){
					if(data.code=="1"){
						//跳转到联系人主页面
						window.location.href="workbench/contacts/toContactsIndex.do";
					}else{
						//显示提示信息
						alert(data.message);
					}
				}
			})
		});


		//给“编辑”联系人按钮添加单击事件
		$("#editContactBtn").click(function (){

			//获取被选中的元素
			var checkedIds=$("#tBody input[type='checkbox']:checked");

				var id="${contact.id}";

				//发送Ajax请求
				$.ajax({
					url:"workbench/contacts/queryContactsForUpdateById.do",
					type:'post',
					data:{id:id},
					success:function (data){
						//将后台发送过来的数据填写到模态窗口中
						$("#edit-id").val(data.id);
						$("#edit-owner").val(data.owner);
						$("#edit-source").val(data.source);
						$("#edit-fullname").val(data.fullname);
						$("#edit-appellation").val(data.appellation);
						$("#edit-job").val(data.job);
						$("#edit-mphone").val(data.mphone);
						$("#edit-email").val(data.email);
						$("#edit-nextContactTime").val(data.nextContactTime);
						$("#edit-customerId").val(data.customerId);
						$("#edit-description").val(data.description);
						$("#edit-contactSummary").val(data.contactSummary);
						$("#edit-address").val(data.address);

						//显示修改市场活动的模态窗口
						$("#editContactsModal").modal("show");
					}

				});
		});

		//给“更新”联系人按钮添加单击事件
		$("#updateContactBtn").click(function (){
			//获取表单数据
			var id=$("#edit-id").val();
			var owner=$("#edit-owner").val();
			var source=$("#edit-source").val();
			var fullname=$("#edit-fullname").val();
			var appellation=$("#edit-appellation").val();
			var job=$("#edit-job").val();
			var mphone=$("#edit-mphone").val();
			var email=$("#edit-email").val();
			var nextContactTime=$("#edit-nextContactTime").val();
			var customerId=$("#edit-customerId").val();
			var description=$("#edit-description").val();
			var contactSummary=$("#edit-contactSummary").val();
			var address=$("#edit-address").val();


			//验证表单数据是否正确
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if(fullname==""){
				alert("活动名称不能为空");
				return;
			}

			//发送Ajax请求
			$.ajax({
				url:"workbench/contacts/updateContactsForDetailById.do",
				data:{
					id:id,
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
						$("#editContactsModal").modal("hide");
						//刷新页面
						window.location.reload();

					}else{
						alert(data.message);
						$("#editContactsModal").modal("show");
					}
				}
			})

		})

		//给“保存”按钮添加单击事件
		$("#saveCreateContactsRemarkBtn").click(function (){
			//收集参数
			var noteContent=$.trim($("#createContactsRemark").val());
			var contactsId='${contact.id}';
			//验证表单
			if(noteContent==""){
				alert("请输入评论");
				return;
			}else {
				//发送Ajax请求
				$.ajax({
					url: "workbench/contacts/saveCreateContactsRemark.do",
					type: "post",
					data: {
						noteContent: noteContent,
						contactsId: contactsId
					},
					dataType: "json",
					success: function (data) {
						if(data.code=="1"){
							//清空输入框
							$("#createContactsRemark").val("");
							//拼接数据
							var htmlStr="";
							htmlStr+="<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
							htmlStr+="<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
							htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
							htmlStr+="<h5>"+data.retData.noteContent+"</h5>";
							htmlStr+="<font color=\"gray\">客户</font> <font color=\"gray\">-</font> <b>${contact.fullname}</b> <small style=\"color: gray;\"> "+data.retData.createTime+"由${sessionScope.sessionUser.name}创建</small>";
							htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
							htmlStr+="<a remarkId="+data.retData.id+" name=\"editA\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
							htmlStr+="<a remarkId="+data.retData.id+" name=\"deleteA\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr+="</div>";
							htmlStr+="</div>";
							htmlStr+="</div>";
							$("#createContactsRemark").before(htmlStr);

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
				url:"workbench/contacts/removeContactsRemarkById.do",
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
					url:"workbench/contacts/updateContactsRemarkById.do",
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


	});
	
</script>

</head>
<body>

    <!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
         	<div class="modal-dialog" role="document" style="width: 85%;">
         		<div class="modal-content">
         			<div class="modal-header">
         				<button type="button" class="close" data-dismiss="modal">
         					<span aria-hidden="true">×</span>
         				</button>
         				<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
         			</div>
         			<div class="modal-body">
         				<form class="form-horizontal" role="form">
         					<%--这儿设置一个隐藏域用来保存联系人的id--%>
         					<input type="hidden" id="edit-id">

         					<div class="form-group">
         						<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
         						<div class="col-sm-10" style="width: 300px;">
         							<select class="form-control" id="edit-owner">
         								<c:forEach items="${ownerList}" var="owner">
         									<option value="${owner.id}">${owner.name}</option>
         								</c:forEach>
         							</select>
         						</div>
         						<label for="edit-source" class="col-sm-2 control-label">来源</label>
         						<div class="col-sm-10" style="width: 300px;">
         							<select class="form-control" id="edit-source">
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
         						<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
         						<div class="col-sm-10" style="width: 300px;">
         							<input type="text" class="form-control" id="edit-fullname" value="李四">
         						</div>
         						<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
         						<div class="col-sm-10" style="width: 300px;">
         							<select class="form-control" id="edit-appellation">
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
         						<label for="edit-job" class="col-sm-2 control-label">职位</label>
         						<div class="col-sm-10" style="width: 300px;">
         							<input type="text" class="form-control" id="edit-job">
         						</div>
         						<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
         						<div class="col-sm-10" style="width: 300px;">
         							<input type="text" class="form-control" id="edit-mphone" >
         						</div>
         					</div>

         					<div class="form-group">
         						<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
         						<div class="col-sm-10" style="width: 300px;">
         							<input type="text" class="form-control" id="edit-email">
         						</div>
         						<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
         						<div class="col-sm-10" style="width: 300px;">
         							<input type="text" class="form-control mydate" id="edit-nextContactTime" readonly>
         						</div>
         					</div>

         					<div class="form-group">
         						<label for="edit-customerId" class="col-sm-2 control-label">客户名称</label>
         						<div class="col-sm-10" style="width: 300px;">
         							<input type="text" class="form-control" id="edit-customerId" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
         						</div>
         					</div>

         					<div class="form-group">
         						<label for="edit-description" class="col-sm-2 control-label">描述</label>
         						<div class="col-sm-10" style="width: 81%;">
         							<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
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
         					</div>

         					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

         					<div style="position: relative;top: 20px;">
         						<div class="form-group">
         							<label for="edit-address" class="col-sm-2 control-label">详细地址</label>
         							<div class="col-sm-10" style="width: 81%;">
         								<textarea class="form-control" rows="1" id="edit-address"></textarea>
         							</div>
         						</div>
         					</div>
         				</form>

         			</div>
         			<div class="modal-footer">
         				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         				<button type="button" class="btn btn-primary" id="updateContactBtn">更新</button>
         			</div>
         		</div>
         	</div>
         </div>

	<!-- 修改联系人备注的模态窗口 -->
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



	<!-- 解除联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="unbundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
				</div>
				<div class="modal-body">
					<p>您确定要解除该关联关系吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" data-dismiss="modal">解除</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="bundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable2" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">关联</button>
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
			<h3>${contact.fullname}${contact.appellation} <small> ${contact.customerId}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editContactBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteContactBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contact.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contact.fullname}${contact.appellation}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contact.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${contact.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contact.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contact.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contact.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contact.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${contact.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${contact.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>

        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${contact.address}
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
        	<c:forEach items="${contactsRemarkList}" var="cr" >
        		<div id="div_${cr.id}" class="remarkDiv" style="height: 60px;">
        			<img title="${cr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        			<div style="position: relative; top: -40px; left: 40px;" >
        				<h5>${cr.noteContent}</h5>
        				<font color="gray">联系人</font> <font color="gray">-</font> <b>${contact.fullname}</b> <small style="color: gray;">${cr.editFlag=='1'?cr.editTime:cr.createTime}  由${cr.editFlag=='1'?cr.editBy:cr.createBy}  ${cr.editFlag=='1'?'修改':'创建'}</small>
        				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
        						<%--修改图标--%>
        					<a remarkId="${cr.id}" name="editA" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
        					&nbsp;&nbsp;&nbsp;&nbsp;<%--删除图标--%>
        					<a remarkId="${cr.id}" name="deleteA" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
        				</div>
        			</div>
        		</div>
        	</c:forEach>
        	<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        		<form role="form" style="position: relative;top: 10px; left: 10px;">
        			<textarea id="createContactsRemark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
        			<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
        				<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
        				<button type="button" id="saveCreateContactsRemarkBtn" class="btn btn-primary">保存</button>
        			</p>
        		</form>
        	</div>
        </div>
<%--	<!-- 备注 -->--%>
<%--	<div style="position: relative; top: 20px; left: 40px;">--%>
<%--		<div class="page-header">--%>
<%--			<h4>备注</h4>--%>
<%--		</div>--%>
<%--		--%>
<%--		<!-- 备注1 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
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
<%--			<img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>呵呵！</h5>--%>
<%--				<font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--		--%>
<%--		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">--%>
<%--			<form role="form" style="position: relative;top: 10px; left: 10px;">--%>
<%--				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>--%>
<%--				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">--%>
<%--					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>--%>
<%--					<button type="button" class="btn btn-primary">保存</button>--%>
<%--				</p>--%>
<%--			</form>--%>
<%--		</div>--%>
<%--	</div>--%>
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
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
					<tbody>
						<tr>
							<td><a href="../transaction/detail.jsp" style="text-decoration: none;">动力节点-交易01</a></td>
							<td>5,000</td>
							<td>谈判/复审</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>新业务</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="../transaction/save.jsp" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><a href="../activity/detail.jsp" style="text-decoration: none;">发传单</a></td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#bundActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>