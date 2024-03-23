<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="edge" />
<!-- InstanceBeginEditable name="doctitle" -->
<title><%=pageTitle%></title>
<!-- InstanceEndEditable -->
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />  
	<meta name="format-detection" content="telephone=no" />  
	<meta name="apple-mobile-web-app-capable" content="yes" />  
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
<link href="css/style_main.css?ver=1.15"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/minimalTabs.css?v=1.1">
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/ddaccordion.css">
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">
        <link rel="stylesheet" href="css/jquery.tabs.css?v=1.18" type="text/css" media="print, projection, screen">
	<link href="css/bootstrap-3.3.4.css" rel="stylesheet">
<link href="css/jquery.alerts.css?v=1.2" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.21">
		<script src="js/jquery-1.7.2.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.23"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
        <script src="js/jquery.tabs.pack.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js?v=1.0"></script>
<script type="text/javascript" src="js/moment.min.js"></script>
<script type="text/javascript" src="js/zh-cn.js"></script>
<script src="js/jquery.alerts.js?v=1.3" type="text/javascript"></script>
	<script type="text/javascript" src="js/ajax.js"></script>
	<script type="text/javascript" src="js/tab-view.js"></script>
	<script type="text/javascript" src="js/bootstrap-treeview.min.js"></script>

<script language="javascript">
	var seeAll = 0;
	var dMark = 0;
	var dUser = "";
	var sWhere = "";
	var sTitle = "";
	var dKind = "";
	var iEditMemo = 0;	//检测是否有备忘录更新
	var iSelProject = [0,0,0,0,0,0,0,0,0];	//指定项目展开属性(共计8个属性)
	let checkPartner = 0;

	var lastTime = new Date().getTime();
	var currentTime = new Date().getTime();
	var timeOut = 3 * 60 * 60 * 1000; //设置超时时间： 3*60分

	<!--#include file="js/commFunction.js"-->
	<!--#include file="enterListIncReady.js"-->
	memoListLong = 0;
	checkListLong = 0;
	grantListLong = 0;
	_feedback_open = 0;
	_k0 = 0;
	_k2 = 0;
	_k3 = 0;
	_k4 = 0;
	_k5 = 0;
	_k6 = 0;
  
	$(document).ready(function (){
		$.ajaxSetup({ 
			async: false 
		}); 
		currPage = "homePage";
		$("#currUser").html(currUserName);

		$('#container-1').tabs({ 
			fxAutoHeight: true
		});

		if(currPartner>""){
			$("#enterHostCheckItem").hide();
			$("#enterPartnerItem").hide();
			$("#searchEnterHostCheck").checkbox({"checked": true});
			checkPartner = 1;
		}
		setHostMenu();
		setEnterListMenu();

		//$('form').jqTransform({imgPath:'images/jqtransform/'});
		$("#resetPassword").click(function(){
			showUserPasswdInfo();
		});
		
		$("#changePasswd").click(function(){
			showUserPasswdInfo();
		});
		
		$("#signOut").click(function(){
			window.parent.open('default.asp?times=' + (new Date().getTime()),'_self');
		});
		
		window.setInterval(function () {
			chkUserActive();
			//refreshMsg();
    	}, 120000);
		$('#container-1').triggerTab(2); // disables third tab

		$(document).mouseover(function(){	//鼠标移动事件
			lastTime = new Date().getTime(); //更新操作时间
		});
        /* 定时器  间隔2*60秒检测是否长时间未操作页面  */
        window.setInterval(testTime, 2*60*1000);	
	});

	function testTime(){
		currentTime = new Date().getTime(); //更新当前时间
		if(currentTime - lastTime > timeOut){ //判断是否超时
			window.open("default.asp?msg=超时退出，请重新登录。", "_self");
		}
		if(_feedback_open == 1){
			getFeedbackItem();
		}
		checkNewFeedback();
	}

	function checkNewFeedback(){
		$.getJSON(uploadURL + "/public/checkNewFeedback" ,function(data){
			if(data>0){
				$("#frame6_title_trail").css("color","red");
			}else{
				$("#frame6_title_trail").css("color","gray");
			}
		});
	}

	function clickMenu(k){
		if(k==0 && _k0==0){
			_k0 = 1;
			$.getScript("memoListIncReady.js", function() {
			});
			$.getScript("templateListIncReady.js", function() {
			});
		}
		if(k==2 && _k2==0){
			_k2 = 1;
			$.getScript("generateApplyListIncReady.js", function() {
			});
		}
		if(k==3 && _k3==0){
			_k3 = 1;
			$.getScript("studentNeedDiplomaListIncReady.js", function() {
			});
			$.getScript("generateDiplomaListIncReady.js", function() {
			});
			$.getScript("diplomaListIncReady.js", function() {
			});
		}
		if(k==4 && _k4==0){
			_k4 = 1;
			$.getScript("rptTrainningIncReady.js", function() {
			});
			$.getScript("rptSalesIncReady.js", function() {
			});
			$.getScript("rptChannelIncReady.js", function() {
			});
			$.getScript("rptPartnerSalesIncReady.js", function() {
			});
		}
		if(k==5 && _k5==0){
			_k5 = 1;
			$.getScript("certListIncReady.js", function() {
			});
			$.getScript("courseListIncReady.js", function() {
			});
			$.getScript("lessonListIncReady.js", function() {
			});
			$.getScript("videoListIncReady.js", function() {
			});
			$.getScript("coursewareListIncReady.js", function() {
			});
			$.getScript("agencyListIncReady.js", function() {
			});
			$.getScript("questionListIncReady.js", function() {
			});
		}
		if(k==6 && _k6==0){
			_k6 = 1;
			$.getScript("userListIncReady.js", function() {
			});
			$.getScript("teacherListIncReady.js", function() {
			});
			$.getScript("partnerListIncReady.js", function() {
			});
			$.getScript("feedbackListIncReady.js", function() {
			});
		}
	}

	function setHostMenu(){
		$("#menu2").hide();	//申报
		$("#menu3").show();	//证书	
		$("#menu4").show();	//统计
		$("#menu5").show();	//课程
		$("#menu6").show();	//综合
		if(checkPartner==1){
			//	合作单位
			$("#menu3").hide();		
			$("#menu5").hide();	
			$("#menu6").hide();	
			$("#menu4").hide();	//统计
		}else{
			//	主单位
			if(checkPermission("applyEdit")){
				$("#menu2").show();	//申报
			}
			if(checkPermission("courseBrowse")){
				$("#menu5").show();	//课程
			}

			if(!checkPermission("courseAdd")){
				deleteTab("视频管理");
				deleteTab("课件管理");
				deleteTab("知识点");
			}
			if(!checkPermission("deptAdd") && !checkPermission("deptShow")){
				deleteTab("部门管理");
			}
			if(!checkPermission("examAdd") || !checkPermission("courseAdd")){
				deleteTab("题库管理");
			}
		}
	}

	function mSubstr(str,slen){ 
		var tmp = 0;
		var len = 0;
		var okLen = 0;
		for(var i=0;i<slen;i++)
		{
			if(str.charCodeAt(i)>255){
				tmp += 2;
			}else{
				len += 1;
			}
			okLen += 1;
			if(tmp + len == slen) 
			{
				return (str.substring(0,okLen));
				break;
			}
			if(tmp + len > slen)
			{
				return (str.substring(0,okLen - 1)); 
				break;
			}
		}
	}

</script>

</head>

<body>
<div id="layout">
	</div>

 <!-- InstanceBeginEditable name="EditRegion" -->

	<table border="0" cellpadding="0" cellspacing="0" valign="top" width="100%">
		<tr>
			<td valign="top" style="height:400px; text-align: left;">
				<div id="container-1" align="left">
					<ul class="tabs-nav">
						<li id="menu0"><a href="#fragment-0" onClick="javascript:clickMenu(0);"><span style="font-size:1em;">我的事务</span></a></li>
						<li id="menu1"><a href="#fragment-1" onClick="javascript:clickMenu(1);"><span style="font-size:1em;">报名管理</span></a></li>
						<li id="menu2"><a href="#fragment-2" onClick="javascript:clickMenu(2);"><span style="font-size:1em;">申报管理</span></a></li>
						<li id="menu3"><a href="#fragment-3" onClick="javascript:clickMenu(3);"><span style="font-size:1em;">证书管理</span></a></li>
						<li id="menu4"><a href="#fragment-4" onClick="javascript:clickMenu(4);"><span style="font-size:1em;">统计报表</span></a></li>
						<li id="menu5"><a href="#fragment-5" onClick="javascript:clickMenu(5);"><span style="font-size:1em;">课程管理</span></a></li>
						<li id="menu6"><a href="#fragment-6" onClick="javascript:clickMenu(6);"><span id="frame6_title_trail" style="font-size:1em;">综合管理</span></a></li>
					</ul>
					<div id="fragment-0">
						<div align="center" style="width:480px; text-align: center;"><h4></h4></div>
						<div class="urbangreymenu" style="width:12%;float:left;">
							<h3 class="headerbar">信息提示</h3>
							<ul class="submenu">
								<li id="c_notice"></li>
								<li id="c_message"></li>
								<li id="c_memo"></li>
								<li id="c_task"></li>
								<li id="c_grant"></li>
							</ul>
							<div class="comm" align='left' style="background:#fdfdfd;padding-top:10px;">
								<div>当前用户：<span style="color:gray;" id="currUser"></span></div>
								<div style="align:center; padding:10px;"><input class="easyui-linkbutton inputButton" type="button" id="changePasswd" value=" 修改密码 "></div>
								<div style="align:center; padding:10px;"><input class="easyui-linkbutton inputButton" type="button" id="signOut" value=" 退出 "></div>
							</div>
						</div>
						<div id="minialDiv" style="width:87%;float:right;">
							<ul id="tabs">
							    <li id="mTab1"><a href="#" name="#tab0">备忘录</a></li>
							    <li><a href="#" name="#tab1">系统文档</a></li>
							</ul>
							
							<div id="content"> 
							    <div id="tab0"><!--#include file="memoListIncDetail.js"--></div>
							    <div id="tab1"><!--#include file="templateListIncDetail.js"--></div>
							</div>
						</div>
						<script type="text/javascript">
					
					    function resetTabs(){
					        $("#content > div").hide(); //Hide all content
					        $("#tabs a").attr("id",""); //Reset id's      
					    }
					
					    var myUrl = window.location.href; //get URL
					    var myUrlTab = myUrl.substring(myUrl.indexOf("#")); // For localhost/tabs.html#tab2, myUrlTab = #tab2     
					    var myUrlTabName = myUrlTab.substring(0,4); // For the above example, myUrlTabName = #tab
					
					    (function(){
					        $("#content > div").hide(); // Initially hide all content
					        $("#tabs li:first a").attr("id","current"); // Activate first tab
					        $("#content > div:first").fadeIn(); // Show first tab content
					        
					        $("#tabs a").on("click",function(e) {
					            e.preventDefault();
					            if ($(this).attr("id") == "current"){ //detection for current tab
					             return       
					            }
					            else{             
					            resetTabs();
					            $(this).attr("id","current"); // Activate this
					            $($(this).attr('name')).fadeIn(); // Show content for current tab
					            }
					        });
					
					        for (i = 1; i <= $("#tabs li").length; i++) {
					          if (myUrlTab == myUrlTabName + i) {
					              resetTabs();
					              $("a[name='"+myUrlTab+"']").attr("id","current"); // Activate url tab
					              $(myUrlTab).fadeIn(); // Show url tab content        
					          }
					        }
					    })()
					  </script>
					</div>
					
					<div id="fragment-1">
						<!--#include file="enterListIncDetail.js"-->
					</div>
					
					<div id="fragment-2">
						<!--#include file="generateApplyListIncDetail.js"-->
					</div>
					
					<div id="fragment-3">
						<div id="dhtmlgoodies_tabView3">
							<div id="dtab31" class="dhtmlgoodies_aTab">
								<!--#include file="studentNeedDiplomaListIncDetail.js"-->
							</div>
							<div id="dtab32" class="dhtmlgoodies_aTab">
								<!--#include file="generateDiplomaListIncDetail.js"-->
							</div>
							<div id="dtab33" class="dhtmlgoodies_aTab">
								<!--#include file="diplomaListIncDetail.js"-->
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView3',Array("证书制作","证书打印","证书查询"),0);
						</script>
					</div>
					
					<div id="fragment-4">
						<div id="dhtmlgoodies_tabView4">
							<div id="dtab41" class="dhtmlgoodies_aTab">
								<!--#include file="rptTrainningIncDetail.js"-->
							</div>
							<div id="dtab42" class="dhtmlgoodies_aTab">
								<!--#include file="rptSalesIncDetail.js"-->
							</div>
							<div id="dtab43" class="dhtmlgoodies_aTab">
								<!--#include file="rptChannelIncDetail.js"-->
							</div>
							<div id="dtab44" class="dhtmlgoodies_aTab">
								<!--#include file="rptPartnerSalesIncDetail.js"-->
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView4',Array("收费日报", "销售日报", "渠道日报", "小报表"),0);
						</script>
					</div>
					
					<div id="fragment-5">
						<div id="dhtmlgoodies_tabView5">
							<div id="dtab51" class="dhtmlgoodies_aTab">
								<!--#include file="agencyListIncDetail.js"-->
							</div>
							<div id="dtab52" class="dhtmlgoodies_aTab">
								<!--#include file="certListIncDetail.js"-->
							</div>
							<div id="dtab53" class="dhtmlgoodies_aTab">
								<!--#include file="courseListIncDetail.js"-->
							</div>
							<div id="dtab54" class="dhtmlgoodies_aTab">
								<!--#include file="lessonListIncDetail.js"-->
							</div>
							<div id="dtab55" class="dhtmlgoodies_aTab">
								<!--#include file="videoListIncDetail.js"-->
							</div>
							<div id="dtab56" class="dhtmlgoodies_aTab">
								<!--#include file="coursewareListIncDetail.js"-->
							</div>
							<div id="dtab57" class="dhtmlgoodies_aTab">
								<!--#include file="questionListIncDetail.js"-->
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView5',Array("认证机构","认证项目","培训课程","课节管理","视频管理","课件管理","题库管理"),0);
						</script>
					</div>
					
					<div id="fragment-6">
						<div id="dhtmlgoodies_tabView6">
							<div id="dtab60" class="dhtmlgoodies_aTab">
								<!--#include file="feedbackListIncDetail.js"-->
							</div>
							<div id="dtab61" class="dhtmlgoodies_aTab">
								<!--#include file="userListIncDetail.js"-->
							</div>
							<div id="dtab62" class="dhtmlgoodies_aTab">
								<!--#include file="teacherListIncDetail.js"-->
							</div>
							<div id="dtab63" class="dhtmlgoodies_aTab">
								<!--#include file="partnerListIncDetail.js"-->
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView6',Array("课程答疑","用户管理","教师管理","部门管理"),0);
						</script>
					</div>
				</div>
			</td>
		</tr>
	</table>
<input type="hidden" id="hTitle" value="" />
<input type="hidden" id="hWhere" value="" />
<div class="clear"></div>
<!-- InstanceEndEditable -->


</div>
  
</body>
<!-- InstanceEnd --></html>
