<!--#include file="js/doc.js" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title><%=pageTitle%></title>
<link href="css/style_main.css"  rel="stylesheet" type="text/css" />
<link type="text/css" href="css/jquery-ui-1.7.2.custom.css" rel="stylesheet" />	
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="css/jquery.tabs.css" type="text/css" media="print, projection, screen">
        <!-- Additional IE/Win specific style sheet (Conditional Comments) -->
        <!--[if lte IE 7]>
        <link rel="stylesheet" href="css/jquery.tabs-ie.css" type="text/css" media="projection, screen">
        <![endif]-->
<link href="css/ddaccordion.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="css/emx_nav_left.css" type="text/css">
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="js/jquery.easing.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.7.2.custom.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
        <script src="js/jquery.history_remote.pack.js" type="text/javascript"></script>
        <script src="js/jquery.tabs.pack.js" type="text/javascript"></script>
<script src="js/jquery.floatDiv.js" type="text/javascript"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script src="js/jquery.barcode.min.js" type="text/javascript"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script src="js/ddaccordion.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<!--#include file="js/correctPng.js"-->
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var seeAll = 0;
	var userID = "";
	var realName = "";
	var addNew = 0;
		
ddaccordion.init({
	headerclass: "silverheader", //Shared CSS class name of headers group
	contentclass: "submenu", //Shared CSS class name of contents group
	revealtype: "click", //Reveal content when user clicks or onmouseover the header? Valid value: "click", "clickgo", or "mouseover"
	mouseoverdelay: 200, //if revealtype="mouseover", set delay in milliseconds before header expands onMouseover
	collapseprev: true, //Collapse previous content (so only one open at any time)? true/false
	defaultexpanded: [1], //index of content(s) open by default [index1, index2, etc] [] denotes no content
	onemustopen: true, //Specify whether at least one header should be open always (so never all headers closed)
	animatedefault: false, //Should contents open by default be animated into view?
	persiststate: true, //persist state of opened contents within browser session?
	toggleclass: ["", "selected"], //Two CSS classes to be applied to the header when it's collapsed and expanded, respectively ["class1", "class2"]
	togglehtml: ["", "", ""], //Additional HTML added to the header when it's collapsed and expanded, respectively  ["position", "html1", "html2"] (see docs)
	animatespeed: "fast", //speed of animation: integer in milliseconds (ie: 200), or keywords "fast", "normal", or "slow"
	oninit:function(headers, expandedindices){ //custom code to run when headers have initalized
		//do nothing
	},
	onopenclose:function(header, index, state, isuseractivated){ //custom code to run whenever a header is opened or closed
		//do nothing
	}
})
		
	<!--#include file="js/commFunction.js"-->

	$(document).ready(function () {
  	currPage = "userPage";
  	setCurrMenuItem();

    $("#userList").click(function(){
			$("#userList option:selected").each(function(){
				userID = $(this).val();
				realName = $(this).text();
	    	showUserDetail();
	    	getRoleListByUser();
	    	getPermissionListByUser();
	    	getAllPermissionListByUser();
			});
    });
    
    $("#changeRole").click(function(){
    	showUserRoleList();
    });
    
    $("#changePermission").click(function(){
    	showUserPermissionList();
    });
    
    $("#addUser").click(function(){
    	addNew = 1;
    	userID = "";
    	setButton();
			setUserEmpty();
    });
    
    $("#saveUser").click(function(){
    	var op = "update";
    	if(addNew == 1){op = "addUser";}
			$.get("userControl.asp?op=" + op + "&userID=" + $("#userID").val() + "&userName=" + $("#user_Name").val() + "&status=" + $("#status").val() + "&realName=" + escape($("#realName").val()) + "&passwd=" + $("#passwd").val() + "&passwd2=" + $("#passwd2").val() + "&moveUser=" + $("#moveUser").val() + "&description=" + escape($("#description").val()) + "&times=" + (new Date().getTime()),function(re){
	    	if(re==0){
		    	userID = $("#user_Name").val();
		    	getUserList();
		    	showUserDetail();
		    	jAlert("保存成功","提示信息");
	    	}
	    	if(re==1){
		    	jAlert("该用户名已经存在","提示信息");
	    	}
	    	if(re==2){
		    	jAlert("用户名、密码或姓名不能空缺","提示信息");
	    	}
	    	if(re==3){
		    	jAlert("两次输入的密码不一致","提示信息");
	    	}
			});
    });
    
    $("#delUser").click(function(){
			jConfirm('确实要删除该用户吗?', '确认对话框', function(r) {
				if(r){
					$.get("userControl.asp?op=delUser&userID=" + $("#userID").val() + "&times=" + (new Date().getTime()),function(re){
			    	userID = "";
			    	getUserList();
			    	setUserEmpty();
			    	jAlert("用户删除成功","提示信息");
					});
				}
			});
    });
    
    if(! checkPermission("admin")){
    	$("#changeRole").hide();
    	$("#changePermission").hide();
    	$("#addUser").hide();
    	$("#saveUser").hide();
    	$("#delUser").hide();
    }
    
    $("#user_Name").blur(function(){
    	if(addNew==1 && $("#user_Name").val()>""){
				$.get("userControl.asp?op=chkUserName&userID=" + $("#userID").val() + "&userName=" + $("#user_Name").val() + "&times=" + (new Date().getTime()),function(re){
					if(re==0){
						$("#imgAllow1").html("<img src='images/green_check.png' width='16'>");
						window.setTimeout(function(){
							$("#imgAllow1").html("<img src='images/blank.png' width='16'>");
						},3000);
					}else{
						$("#imgAllow1").html("<img src='images/cancel.png' width='16'>");
						jAlert("该名称已经存在","提示信息");
						window.setTimeout(function(){
							$("#imgAllow1").html("<img src='images/blank.png' width='16'>");
						},3000);
					}
				});
    	}
    });
    
    $("#passwd").blur(function(){
    	if($("#passwd2").val() != $("#passwd").val()){
    		$("#passwdConfirm").show();
    	}
    });
    
    $("#passwd2").blur(function(){
    	if($("#passwd2").val() != $("#passwd").val()){
    		jAlert("两次输入的密码不一致","提示信息");
    	}
    });

    getUserList();
    setButton();
	});
	
	function getUserList(){
		$.get("userControl.asp?op=getUserList&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			ar = unescape(re).split("%%");
			//alert(ar);
			$("#userList").empty();
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#userList");
				});
				$("#selCount").text(" (" + $("#userList").attr("length") + ")");
			}
		});
	}
	
	function showUserDetail(){
		$.get("userControl.asp?op=getUserInfoByName&userName=" + userID + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			addNew = 0;
			setButton();
			if(ar.length > 0){
				$("#status_old").val(ar[0]);
				$("#status").val(ar[0]);
				$("#user_Name").val(ar[1]);
				$("#realName").val(ar[2]);
				$("#passwd").val(ar[3]);
				$("#passwd2").val(ar[3]);
				$("#moveUser").val(ar[4]);
				$("#description").val(ar[5]);
				$("#userID").val(ar[6]);
			}
		});
	}

	function getRoleListByUser(){
		//根据用户名列出其拥有的角色
		$.get("userControl.asp?op=getRoleListByUser&userName=" + userID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//$("#roleList").empty();
			document.getElementById("roleList").options.length = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#roleList");
				});
			}
		});
	}

	function getPermissionListByUser(){
		//根据用户名列出其拥有的直接分配权限
		$.get("userControl.asp?op=getPermissionListByUser&userName=" + userID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//$("#permissionList").empty();
			document.getElementById("permissionList").options.length = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#permissionList");
				});
			}
		});
	}

	function getAllPermissionListByUser(){
		//根据用户名列出其拥有的所有权限
		$.get("userControl.asp?op=getAllPermissionListByUser&userName=" + userID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//$("#permissionList").empty();
			document.getElementById("allPermissionList").options.length = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[1] + "'>" + ar1[2] + "</option>").appendTo("#allPermissionList");
				});
			}
		});
	}
	
	function showUserRoleList(){
		if(userID > ""){
			$.get("commonControl.asp?op=setSession&sName=pagePara" + "&anyStr=" + escape(userID + "|" + realName + "|" + 1) + "&times=" + (new Date().getTime()),function(re){
				asyncbox.open({
					url:'userRoleList.asp?times=' + (new Date().getTime()),
					title: '角色分配',
		　　　width : 800,
		　　　height : 580,
		　　　callback : function(action){
	　　　　　if(action == 'close'){
				    	getRoleListByUser();
				    	getAllPermissionListByUser();
	　　　　　}
		　　　}
				});
			});
		}
	}
	
	function showUserPermissionList(){
		if(userID > ""){
			$.get("commonControl.asp?op=setSession&sName=pagePara" + "&anyStr=" + escape(userID + "|" + realName + "|" + 1) + "&times=" + (new Date().getTime()),function(re){
				asyncbox.open({
					url:'userPermissionList.asp?times=' + (new Date().getTime()),
					title: '权限分配',
		　　　width : 800,
		　　　height : 580,
		　　　callback : function(action){
	　　　　　if(action == 'close'){
				    	getPermissionListByUser();
				    	getAllPermissionListByUser();
	　　　　　}
		　　　}
				});
			});
		}
	}
	
	function setButton(){
		$("#passwdConfirm").hide();
  	$("#user_Name").attr("class","readOnly");
  	$("#user_Name").attr("readOnly","true");
		if(checkPermission("admin")){
			if(userID>""){
				$("#changeRole").attr("disabled","");
	    	$("#changePermission").attr("disabled","");
	    	$("#addUser").attr("disabled","");
	    	$("#saveUser").attr("disabled","");
	    	$("#delUser").attr("disabled","");
			}else{
				$("#changeRole").attr("disabled","true");
	    	$("#changePermission").attr("disabled","true");
	    	$("#saveUser").attr("disabled","true");
	    	$("#delUser").attr("disabled","true");
			}
			if(addNew==1){
	    	$("#delUser").attr("disabled","true");
	    	$("#addUser").attr("disabled","true");
	    	$("#saveUser").attr("disabled","");
	    	$("#passwdConfirm").show();
	    	$("#user_Name").attr("class","");
	    	$("#user_Name").attr("readOnly","");
			}
		}
	}

	function setUserEmpty(){
		$("#status_old").val(0);
		$("#status").val(0);
		$("#user_Name").val("");
		$("#realName").val("");
		$("#passwd").val("");
		$("#passwd2").val("");
		$("#moveUser").val("");
		$("#description").val("");
		$("#user_Name").focus();
	}
</script>
</head>
<body style="margin:0;">
<div id='layout' align='left'>
 <!--#include file='js/mainMenu.js' -->
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->
	<div align='right' style='background:#f0f0ff;'>&nbsp;</div>
	<div id='map' align='left' style='background:#f9f9f9; padding-left:220px; height:18px;'>&nbsp;</div>
  	<table border='0' cellpadding='0' cellspacing='0' valign='top' width = '100%'>
  	    <tr height='490'>
  	    <td width='190' style='background:#f6f6ff;' valign='top'>
  	    	<div class='comm'><h2><span>用户列表</span><span id="selCount"></span></h2></div>
					<div>
						<select name="userList" size="25" id="userList" multiple style="background-color:#FFFFEE; border: '#EEEEFF'; width:100% ">
						</select>
					</div>
  	    </td>
  	    <td valign="top">
					<div style="width:97%;margin:0;">
						<div style="float:left;border:solid 1px #e0e0e0;width:28%;margin:1px;background:#ffffff;line-height:18px;">
		  	    	<div class="comm">
		  	    		<div><h2>用户信息</h2></div>
								<form>
								<table width="100%">
									<tr>
										<td>用户名</td>
										<td align="left"><input id="userID" type="hidden" />
						        	<input id="user_Name" name="user_Name" type="text" size="21" /><span id="imgAllow1"><img src='images/blank.png' width='16'></span>
							      </td>
						    	</tr>
									<tr>
										<td>真实姓名</td>
										<td align="left">
						        	<input id="realName" name="realName" type="text" size="21" />
							      </td>
						    	</tr>
									<tr>
										<td>登录密码</td>
										<td align="left">
						        	<input id="passwd" name="passwd" type="password" size="21" />
							      </td>
						    	</tr>
									<tr id="passwdConfirm">
										<td>确认密码</td>
										<td align="left">
						        	<input id="passwd2" name="passwd2" type="password" size="21" />
							      </td>
						    	</tr>
									<tr>
										<td>转档代码</td>
										<td align="left">
						        	<input id="moveUser" name="moveUser" type="text" size="21" />
							      </td>
						    	</tr>
									<tr>
										<td>备注</td>
										<td align="left">
						        	<textarea id="description" name="description" rows="3" cols="16" /></textarea>
							      </td>
						    	</tr>
									<tr>
										<td>状态</td>
										<td align="left"><input id="status_old" type="hidden" />
						        	<select id="status" name="status" style="width:132px;" />
						        		<option value="0">正常</option>
						        		<option value="1">禁用</option>
						        	</select>
							      </td>
						    	</tr>
						    </table>
	              <hr size="1" color="#c0c0c0" noshadow>
		            <div align="center">
		            	<input class="button" type="button" id="addUser" name="addUser" value="添加" />
		            	<input class="button" type="button" id="saveUser" name="saveUser" value="保存" />
		            	<input class="button" type="button" id="delUser" name="delUser" value="删除" />
		            </div>
					      </form>
		  	    	</div>
						</div>
						<div style="float:left;border:solid 1px #e0e0e0;width:23%;margin:1px;background:#ffffff;line-height:18px;">
		  	    	<div align="center">
		  	    		<div class="comm"><h2>拥有角色</h2></div>
								<select name="roleList" size="20" id="roleList" multiple style="background-color:#FFFFFE; border: '#EEEEFF'; width:100% ">
								</select>
		  	    	</div>
              <hr size="1" color="#c0c0c0" noshadow>
	            <div class="comm" align="center">
	            	<input class="button" type="button" id="changeRole" name="changeRole" value="变更角色" />
	            </div>
						</div>
						<div style="float:left;border:solid 1px #e0e0e0;width:23%;margin:1px;background:#ffffff;line-height:18px;">
		  	    	<div align="center">
		  	    		<div class="comm"><h2>直接权限</h2></div>
								<select name="permissionList" size="20" id="permissionList" multiple style="background-color:#FFFFFE; border: '#EEEEFF'; width:100% ">
								</select>
		  	    	</div>
              <hr size="1" color="#c0c0c0" noshadow>
	            <div class="comm" align="center">
	            	<input class="button" type="button" id="changePermission" name="changePermission" value="变更权限" />
	            </div>
						</div>
						<div style="float:left;border:solid 1px #e0e0e0;width:23%;margin:1px;background:#ffffff;line-height:18px;">
		  	    	<div align="center">
		  	    		<div class="comm"><h2>实际权限</h2></div>
								<select name="allPermissionList" size="25" id="allPermissionList" multiple style="background-color:#FCFCFC; border: '#EEEEFF'; width:100% ">
								</select>
		  	    	</div>
		  	    	<div style="color:gray;">* 包括直接分配的权限、从角色获得的权限以及他人的授权。</div>
						</div>
					</div>
  	    </td>
  	    </tr>
	</table>
	<div height="5" align="right" style="background:#f9f9f9;">&nbsp;</div>
</div>
</body>
</html>
