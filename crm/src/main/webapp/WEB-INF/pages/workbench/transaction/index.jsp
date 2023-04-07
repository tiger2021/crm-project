<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">


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

	$(function(){
		//当主页面加载完成之后，向后台发送Ajax请求，查询要显示的交易
		queryTransactionByConditionForPage(1,10);

		//给“查询”按钮添加单击事件
		$("#search-transactionBtn").click(function (){
			queryTransactionByConditionForPage(1,$("#demo_page1").bs_pagination('getOption','rowsPerPage'));
		});

       //给“创建”按钮添加单击事件
       $("#createTransactionBtn").click(function (){
           window.location.href="workbench/transaction/toTransactionSave.do";
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


		//给”删除“按钮添加单击事件
		$("#deleteTransactionsBtn").click(function (){
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
						url:"workbench/transaction/removeTransactionsByIds.do",
						type:"post",
						data:ids,
						success:function (data){
							if(data.code=="1"){
								//刷新市场活动页面
								queryTransactionByConditionForPage(1,$("#demo_page1").bs_pagination('getOption','rowsPerPage'));
							}else{
								//显示提示信息
								alert(data.message);
							}
						}
					})
				}


			}
		});




		
		
	});

	//定义查询交易的函数
	function queryTransactionByConditionForPage(pageNo,pageSize){
		//收集参数
		//所有者
		var owner=$("#query-owner").val();
		var name=$("#query-name").val();
		var customerName=$("#query-customerName").val();
		var stage=$("#query-stage").val();
		var type=$("#query-type").val();
		var source=$("#query-source").val();
		var contantsName=$("#query-contantsName").val();
		//向后台发送Ajax请求
		$.ajax({
			url:"workbench/transaction/queryTransactionByConditionForPage.do",
			type:"post",
			data: {
				owner:owner,
				name:name,
				customerName:customerName,
				stage:stage,
				type:type,
				source:source,
				contantsName:contantsName,
				pageNo:pageNo,
				pageSize:pageSize
			},
			success:function (data){
				//显示查询出的市场活动的总记录数
				$("#totalRowsB").text(data.totalRows);
				//遍历List，拼接字符串
				var htmlStr="";
				$.each(data.transList,function (index,tran){

					htmlStr+="<tr>";
					htmlStr+="<td><input type=\"checkbox\" value=\""+tran.id+"\" /></td>";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/transaction/toTransactionDetail.do?id="+tran.id+"'\">"+tran.name+"</a></td>";
					htmlStr+="<td>"+tran.customerId+"</td>";
					htmlStr+="<td>"+tran.stage+"</td>";
					htmlStr+="<td>"+tran.type+"</td>";
					htmlStr+="<td>"+tran.owner+"</td>";
					htmlStr+="<td>"+tran.source+"</td>";
					htmlStr+="<td>"+tran.contactsId+"</td>";
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
						queryTransactionByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		})
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
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="query-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="query-stage">
					  	<option></option>
					  	<option>资质审查</option>
					  	<option>需求分析</option>
					  	<option>价值建议</option>
					  	<option>确定决策者</option>
					  	<option>提案/报价</option>
					  	<option>谈判/复审</option>
					  	<option>成交</option>
					  	<option>丢失的线索</option>
					  	<option>因竞争丢失关闭</option>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >类型</div>
					  <select class="form-control" id="query-type">
					  	<option></option>
					  	<option>已有业务</option>
					  	<option>新业务</option>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="query-source">
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
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="query-contantsName">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="search-transactionBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createTransactionBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteTransactionsBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tBody">

					</tbody>
				</table>
				<%--显示分页--%>
				<div id="demo_page1"></div>
			</div>
		</div>
		
	</div>
</body>
</html>