<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
	<head>
	    <meta charset="utf-8">
	    <title>分店客流量对比表</title>
	    <jsp:include page="../include.jsp"></jsp:include>
	    <link href="${pageContext.request.contextPath}/js/Metro-UI-CSS-master/docs/css/metro-bootstrap.css" rel="stylesheet">
	    <link href="${pageContext.request.contextPath}/js/Metro-UI-CSS-master/docs/css/iconFont.css" rel="stylesheet">
	    <script type="text/javascript" src="../js/dist/echarts.js"></script>
	    
	    <script type="text/javascript">
			require.config({
				paths : {
					echarts : '/CRS/js/dist'
				}
			});
		</script>
	</head>
	<body>
		<center><h1 style="height: 70px;line-height: 70px;">分店客流量对比统计</h1></center>
		<a href="${pageContext.request.contextPath}/index.jsp" style=" position: absolute;right: 30px;top: 20px; border:1px solid #666;padding:5px;">
         	<span class="first-name">返回首页&nbsp;<span class="icon-arrow-right"></span></span>
        </a>
		<div style="width:900px;margin:0 auto;">
			<label>开始时间:</label>
			<input id="startTime" type="text" width="130px" class="easyui-datebox" style="width:130px">
			<label>结束时间:</label>
			<input id="endTime" type="text" width="130px" class="easyui-datebox" style="width:130px">
			<label>选择店名:</label>
			<select id="shopName" class="easyui-combobox" name="dept" style="width:200px;" multiple="multiple">   
			    <option value="和毅总店">和毅总店</option>   
			    <option value="和毅体育新城店">和毅体育新城店</option>    
			</select>
			<a href="javascript:void(0)" class="easyui-linkbutton"  style="margin-left: 15px;" onclick="query()">
				<font size="3" color="blue">统计结果</font>
			</a>
		</div>
		
		<div id="main" style="height:500px"></div>
		
		<script type="text/javascript">
			$(function() {
				//给datebox一个默认值
				$('#startTime').datebox("setValue",'2014-08-10');
				$('#endTime').datebox("setValue",'2014-08-30');
				$('#shopName').combobox("setValues",['和毅总店','和毅体育新城店']);
				query();
		  	});
			function query() {
				//获取所有查询参数
		  		var startTime = $('#startTime').datebox("getValue");
		  		var endTime = $('#endTime').datebox("getValue");
		  		var dname_ary = $('#shopName').combobox("getValues");	//商店名数组
				var kll_ary  = [];	//客流量数组
				var day_ary   = [];	//日期数组
				var series_data = [];
				var colors = [ '#ff7f50', '#87cefa', '#da70d6', '#32cd32', '#6495ed','#ff69b4', '#ba55d3', '#cd5c5c', '#ffa500', '#40e0d0','#1e90ff', '#ff6347', '#7b68ee', '#00fa9a', '#ffd700','#6b8e23', '#ff00ff', '#3cb371', '#b8860b', '#30e0e0' ];
				var titles = [ ];
				for(var k=0;k<dname_ary.length;k++) {
					titles.push( dname_ary[k] );
				}
				$.ajax({
							type:"POST",
							url:"/CRS/report/daykll",
							async: false,
							data: {startTime:startTime,endTime:endTime,names:dname_ary.toString()},
							success: function(data) {
								day_ary = data.date_array;
								kll_ary = data.kll_array;
								for(var i=0;i<dname_ary.length;i++) {
									var obj =  { name :dname_ary[i],  type : 'bar', data :  kll_ary[i],
														markPoint : { data : [ { type : 'max', name : '最大值' }, { type : 'min', name : '最小值'} ] },  
														markLine : { data : [ {type : 'average', name : '平均值'} ] }
													};
								 	series_data.push(obj);
								}
								
							}
						});
		
				//return;
		
				require(	[
						 'echarts', 
						 'echarts/chart/bar', // 使用柱状图就加载bar模块，按需加载
						 'echarts/chart/funnel'
					], 
					function(ec)  {
						//  初始化echarts图表
						var myChart = ec.init(document.getElementById('main'));
		
					option = {
						title : {
							text : '分店每天客流量对比图',
							subtext : ''
						},
						color: colors,   //颜色
						tooltip : {
							trigger : 'axis'
						},
						legend : {
							data :  titles  //标题
						},
						toolbox : {
							show : true,
							feature : {
								mark : {
									show : true
								},
								dataView : {
									show : true,
									readOnly : false
								},
								magicType : {
									show : false,
									type : [ 'line', 'bar' ]
								},
								restore : {
									show : true
								},
								saveAsImage : {
									show : true
								}
							}
						},
						calculable : true,
						xAxis : [ {
							type : 'category',
							data : day_ary
						} ],
						yAxis : [ {
							type : 'value'
						} ],
						series : series_data 
						
					};
		
					// 为echarts对象加载数据 
					myChart.setOption(option);
				});

			}
		</script>
	
	</body>
</html>
