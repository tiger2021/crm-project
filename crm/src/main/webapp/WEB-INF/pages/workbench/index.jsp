<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">

	//页面加载完毕
	$(function(){
		
		//导航中所有文本颜色为黑色
		$(".liClass > a").css("color" , "black");
		
		//默认选中导航菜单中的第一个菜单项
		$(".liClass:first").addClass("active");
		
		//第一个菜单项的文字变成白色
		$(".liClass:first > a").css("color" , "white");
		
		//给所有的菜单项注册鼠标单击事件
		$(".liClass").click(function(){
			//移除所有菜单项的激活状态
			$(".liClass").removeClass("active");
			//导航中所有文本颜色为黑色
			$(".liClass > a").css("color" , "black");
			//当前项目被选中
			$(this).addClass("active");
			//当前项目颜色变成白色
			$(this).children("a").css("color","white");
		});
		
		
		window.open("workbench/main/index.do","workareaFrame");

		//给确定按钮加点击事件(退出登录)
		$("#logoutBtn").click(function (){
			//发同步请求
			window.location.href="settings/qx/user/logout.do";
		});

		//给“我的资料”按钮添加单击事件
		$("#myProfileBtn").click(function(){
			//弹出“我的资料”模态窗口
			$("#myInformationModal").modal("show");
		});

		//给“更新”按钮添加单击事件
		$("#editLoginPwdBtn").click(function (){
			//收集参数
			var id="${sessionUser.id}";
			var confirmOldLoginPwd="${sessionUser.loginPwd}";
			var oldLoginPwd=$.trim($("#oldPwd").val());
			var loginPwd=$.trim($("#newPwd").val());
			var confirmLoginPwd1=$.trim($("#confirmPwd").val());
			//验证表单数据
			if(confirmOldLoginPwd!=oldLoginPwd){
				alert("原始密码不正确，请重新输入");
				return;
			}
			if(loginPwd==oldLoginPwd){
				alert("新密码与原来的密码相同，请重新输入新密码");
				return;
			}
			if(loginPwd!=confirmLoginPwd1){
				alert("两次输入的新密码不一样，请重新输入新密码");
				return;
			}
			if(loginPwd==""){
				alert("新密码不能为空");
				return;
			}
			//发送Ajax请求
			$.ajax({
				url:"workbench/editUserLoginPwdById.do",
				type:"post",
				data:{
					id:id,
					loginPwd:loginPwd
				},
				dataType:"json",
				success:function (data){
					if(data.code=="1"){
						//关闭修改密码的模态窗口
						$("#editPwdModal").modal("hide");
					}else{
						alert(data.message);
						return;
					}
				}
			});


		});
		
	});
	
</script>

</head>
<body>
	
	<!-- 我的资料 -->
	<div class="modal fade" id="myInformationModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">我的资料</h4>
				</div>
				<div class="modal-body">
					<div style="position: relative; left: 40px;">
						姓名：<b>${sessionUser.name}</b><br><br>
						登录帐号：<b>${sessionUser.loginAct}</b><br><br>
						组织机构：<b>${sessionUser.deptno}</b><br><br>
						邮箱：<b>${sessionUser.email}</b><br><br>
						失效时间：<b>${sessionUser.expireTime}</b><br><br>
						允许访问IP：<b>${sessionUser.allowIps}</b>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改密码的模态窗口 -->
	<div class="modal fade" id="editPwdModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 70%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改密码</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="oldPwd" class="col-sm-2 control-label">原密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="oldPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="newPwd" class="col-sm-2 control-label">新密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="newPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary"  id="editLoginPwdBtn" >更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 退出系统的模态窗口 -->
	<div class="modal fade" id="exitModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">离开</h4>
				</div>
				<div class="modal-body">
					<p>您确定要退出系统吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="logoutBtn">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 顶部 -->
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">客户关系管理系统 &nbsp;</div>
		<div style="position: absolute; top: 15px; right: 15px;">
			<ul>
				<li class="dropdown user-dropdown">
					<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
						<span class="glyphicon glyphicon-user"></span> ${sessionScope.sessionUser.name} <span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="javascript:void(0)" id="myProfileBtn"><span class="glyphicon glyphicon-file"></span> 我的资料</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
						<li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<!-- 中间 -->
	<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">
	
		<!-- 导航 -->
		<div id="navigation" style="left: 0px; width: 18%; position: relative; height: 100%; overflow:auto;">
		
			<ul id="no1" class="nav nav-pills nav-stacked">
				<li class="liClass"><a href="workbench/main/index.do" target="workareaFrame"><span class="glyphicon glyphicon-home"></span> 美好一天的开始</a></li>
				<li class="liClass"><a href="workbench/activity/toActivityIndex.do" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> 市场活动</a></li>
				<li class="liClass"><a href="workbench/clue/toClueIndex.do" target="workareaFrame"><span class="glyphicon glyphicon-search"></span> 线索（潜在客户）</a></li>
				<li class="liClass"><a href="workbench/customer/toCustomerIndex.do" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 客户</a></li>
				<li class="liClass"><a href="workbench/contacts/toContactsIndex.do" target="workareaFrame"><span class="glyphicon glyphicon-earphone"></span> 联系人</a></li>
				<li class="liClass"><a href="workbench/transaction/toTransactionIndex.do" target="workareaFrame"><span class="glyphicon glyphicon-usd"></span> 交易（商机）</a></li>
				<li class="liClass"><a href="workbench/chart/transaction/index.do" target="workareaFrame"><span class="glyphicon glyphicon-phone-alt"></span> 交易统计图表</a></li>

			</ul>
			
			<!-- 分割线 -->
			<div id="divider1" style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
		</div>
		
		<!-- 工作区 -->
		<div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
			<iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
		</div>
		
	</div>
	
	<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>
	
	<!-- 底部 -->
	<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>
	
</body>
</html>