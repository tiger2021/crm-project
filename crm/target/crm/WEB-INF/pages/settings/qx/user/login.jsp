<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--引入js标签库--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function (){
		//给整个网页添加价盘按下事件,event中封装的是键盘按下时间
		$(window).keydown(function(event){
			//判断按下的是否为enter建
			if(event.keyCode==13){
				//模拟点击登录按钮
				$("#loginBtn").click();
			}
		})

		$("#loginBtn").click(function (){
			//获取用户输入的数据
			 var loginAct = $.trim($("#loginAct").val());
			 var loginPwd=$.trim($("#loginPwd").val());
			 var isRemPwd=$("#isRemPwd").prop("checked");

			 //判断用户输入的数据是否合法
			if(loginAct==""){
				alert("用户名不能为空");
				return;
			}
			if(loginPwd==""){
				alert("密码不能为空");
			}

			//提示用户正在提交请求
			// $("#msg").text("正在努力验证...")


			//发送Ajax异步请求
			$.ajax({
				url:'settings/qx/user/login.do',   //在上面已经配了basePath，所以路径不用写全
				type:'post',
				data:{
					loginAct:loginAct,
					loginPwd:loginPwd,
					isRemPwd:isRemPwd
				},
				dataType:'json',
				success:function (data){ //data为服务器返回给前端的数据
					if(data.code=="1"){
						//需要跳转到工作的主页面
						window.location.href="workbench/index.do";
					}else{
						//提示错误信息
						$("#msg").text(data.message);

					}
				},
				beforeSend:function (){ // 	当Ajax向后台发送请求之前，会自动执行该函数
					        //如果该函数执行之后返回true，则Ajax会真正向后台发送请求，否则，Ajax不会向后台发送请求
					       //表单验证一般写在这儿，也可以不写在这儿
					$("#msg").text("正在努力验证...");
					return true;
				}



			})
		})
	})
</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
	</div>

	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct" type="text" value="${cookie.loginAct.value}" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPwd" type="password" value="${cookie.loginPwd.value}" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct.value and not empty cookie.loginPwd.value}">
								<input id="isRemPwd" type="checkbox" checked> 十天内免登录
							</c:if>
							<c:if test="${empty cookie.loginAct.value or empty cookie.loginPwd.value}">
								<input id="isRemPwd" type="checkbox"> 十天内免登录
							</c:if>

						</label>
						&nbsp;&nbsp;
						<span id="msg"></span>
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>