<!--#include file="js/doc.js" -->
<%
var nodeID = 0;
var free = 0;
var fix = 0;
var con = "";
var sWhere = "";
var sTitle = "";
var tLen = 0;

if (String(Request.QueryString("nodeID")) != "undefined" && 
    String(Request.QueryString("nodeID")) != "") { 
  nodeID = parseInt(String(Request.QueryString("nodeID")));
}
if (String(Request.QueryString("free")) != "undefined" && 
    String(Request.QueryString("free")) != "") { 
  free = String(Request.QueryString("free"));
}
if (String(Request.QueryString("fix")) != "undefined" && 
    String(Request.QueryString("fix")) != "") { 
  fix = String(Request.QueryString("fix"));
}
if (String(Request.QueryString("con")) != "undefined" && 
    String(Request.QueryString("con")) != "") { 
  con = String(Request.QueryString("con"));
}
if (String(Request.QueryString("sWhere")) != "undefined" && 
    String(Request.QueryString("sWhere")) != "") { 
  sWhere = String(unescape(Request.QueryString("sWhere")));
}
if (String(Request.QueryString("tLen")) != "undefined" && 
    String(Request.QueryString("tLen")) != "") { 
  tLen = parseInt(Request("tLen"));
}
if (String(Request.QueryString("sTitle")) != "undefined" && 
    String(Request.QueryString("sTitle")) != "") { 
  sTitle = String(unescape(Request.QueryString("sTitle")));
  sTitle = sTitle.substr(0,tLen);
}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<link rel="stylesheet" type="text/css" media="screen" href="css/niceforms.css" />
<link href="css/style_inner.css"  rel="stylesheet" type="text/css" />
<link type="text/css" href="css/jquery-ui-1.7.2.custom.css" rel="stylesheet" />	
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<link href="css/data_page.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easing.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.7.2.custom.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="js/jquery.jmpopups-0.5.1.js"></script>
<!--#include file="js/correctPng.js"-->
<!--#include file="js/clickMenu.js"-->

		<script type="text/javascript">
				$.setupJMPopups({
					screenLockerBackground: "#003366",
					screenLockerOpacity: "0.7"
				});

				function openStaticPopup() {
					$.openPopupLayer({
						name: "myStaticPopup",
						width: 450,
						target: "myHiddenDiv"
					});
				}
		</script>
		<style type="text/css" media="screen">
			h1 {margin-bottom:50px; font-size:40px; font-weight:normal;}
			p {margin:0; padding:0 0 30px; font-size:12px;}
			pre {font-size:12px; font-family:"Consolas","Monaco","Bitstream Vera Sans Mono","Courier New","Courier"; line-height:100%; background:#F4F4F4; padding:10px;}
			#general {margin:30px;}
			
			#myHiddenDiv {display:none;}
			
			.popup {background:#FFF; border:1px solid #333; padding:1px;}
			.popup-header {height:24px; padding:7px; background:url("images/bgr_popup_header.jpg") repeat-x;}
			.popup-header h2 {margin:0; padding:0; font-size:14px; float:left; color:gray}
			.popup-header .close-link {float:right; font-size:11px;}
			.popup-body {padding:10px;}
		</style>

<script language="javascript">
	$.ajaxSetup({ async: false });
	var newUser = 0;
	var visitobj = true;
	var selList = "";
	var selCount = 0;

	$(document).ready(function () {
		//alert("nodeID:<%=nodeID%>  sWhere:<%=sWhere%>");
		$('#mainTab').dataTable({
			"aaSorting": [[ 4, "asc" ]],
			"bLengthChange": false,
			"aoColumnDefs": [ 
				{ "bVisible": false, "aTargets": [ 8 ] }]
		});
		$("#search").click(function(){
			window.location = "userManagementDetail.asp?free=1&con=" + $("#searchText").val();
		});

		$("#filterStatus").change(function(){
			//alert($("#filterStatus").val());
			window.location = "userManagementDetail.asp?fix=1&con=" + $("#filterStatus").val();
		});
		
		$("#editUser").ajaxForm(function(re){
			//alert(re);
			if(re == 0){
				//$.get("userControl.asp?type=updateUser&userID=" + $("#ID").val() + "&realName=" + escape($("#realName").val()) + "&answer1=" + escape($("#answer1").val()) + "&answer2=" + $("#answer2").val() + "&empID=" + escape($("#empID").val()) + "&reason=" + escape($("#reason").val()) + "&times=" + (new Date().getTime()),function(re){
				$.get("userControl.asp?type=updateUser&userID=" + $("#ID").val() + "&realName=" + escape($("#realName").val()) + "&empID=" + escape($("#empID").val()) + "&reason=" + escape($("#reason").val()) + "&description=" + escape($("#description").val()) + "&times=" + (new Date().getTime()),function(re){
					document.getElementById("light").style.display="none";
					document.getElementById("fade").style.display="none";
					refreshCont();
					showSuccess();
				});
			}
			if(re == 1){
				jAlert("用户名不能为空");!
				$("#userName").focus();
			}
			if(re == 2){
				jAlert("密码不能为空!");
				$("#passwd").focus();
			}
			if(re == 3){
				jAlert("两次输入的密码不一致!");
				$("#passwd1").focus();
			}
			if(re == 4){
				jAlert("两个密码问题不能相同!");
				//$("#question1").focus();
			}
			if(re == 5){
				jAlert("公司邮箱不能为空!");
				$("#email").focus();
			}
			
			return false;
		});
		
		$("#addNew").click(function(){
			$.get("userControl.asp?type=addUser&uID=<%=nodeID%>&times=" + (new Date().getTime()),function(re){
				//alert(<%=nodeID%> + " ... " + re);
				if(re > 0){
					showEdit(re);
					newUser = 1;
				}else{
					//showFailure();
				}
			});
		});
		
		$("#delUser").click(function(){
			jConfirm("你确定要删除 " + $("#userName").val() + " 吗?", "确认对话框", function(r) {
				if(r){
					$.get("userControl.asp?type=delUser&userID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(re){
						//alert(re);
						if(re>""){
							document.getElementById("light").style.display="none";
							document.getElementById("fade").style.display="none";
							window.location = "userManagementDetail.asp?nodeID=<%=nodeID%>&free=<%=free%>&con=<%=con%>";
							showSuccess();
						}
					});
				}
			});
		});
		
		$("#userName").change(function(){
	    	if($("#userName").val() == "")   
	        {       
	            $("#userName").focus();
	            jAlert("用户名不能为空");   
	        }else{
				$.get("userControl.asp?type=chkUserName&userID=" + $("#ID").val() + "&userName=" + $("#userName").val() + "&times=" + (new Date().getTime()),function(re){
					if(re == 1){
						jAlert("该用户名已经存在，请选用其他名字。");
						$("#userName").focus();
					}else{
						//showFailure();
					}
				});
	        }
		});
		
		$("#opSel").click(function(){
			opSel();
		});
		
		$("#add2Cart").click(function(){
			add2Cart();
		});
		
		$("#clearCart").click(function(){
			clearCart();
		});
		
		$("#form2").ajaxForm(function(data){
			//alert(data);
			$.get("readExcel.asp?kindID=2&times=" + (new Date().getTime()),function(re){
				//alert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				var s = "成功地导入了 " + ar[0] + " 条数据。"; 
				if(ar[1]>""){
					s += "以下用户在当前系统中已存在，未被导入：" + ar[1];
				}
				jAlert(s,"导入结果");
				//refreshTree(0);
			});
		});

		$("#backup").click(function(){
			//alert($("#sql").val());
			$.get("writeExcel.asp?kindID=2&query=" + $("#sql").val() + "&times=" + (new Date().getTime()),function(re){
				//alert(re);
				if(re>0){
					//window.open("gin.asp?kindID=2&times=" + (new Date().getTime()),"_blank")
					$.get("gin.asp?kindID=2&times=" + (new Date().getTime()),function(re1){
						//alert(re1);
						window.open(re1,"_blank");
					});
				}
			});
		});
		$('#w').window();
		$('#w').window('close');
		getNodeInfo(<%=nodeID%>);
		setDropList();
		//alert("<%='sWhere:' + sWhere + '  free:' + free + '  fix:' + fix + '  sTitle:' + sTitle + '  nodeID:' + nodeID%>");
		document.getElementById("light").style.display="none";
		document.getElementById("fade").style.display="none";
		document.getElementById("light1").style.display="none";
		document.getElementById("fade1").style.display="none";
	});
	
	function refreshCont(){
		window.location = "userManagementDetail.asp?nodeID=<%=nodeID%>&free=<%=free%>&con=<%=con%>&sWhere=<%=sWhere%>&sTitle=<%=sTitle%>&times=" + (new Date().getTime());
	}

	function showEdit(id){
		$.get("userControl.asp?type=getUserInfo&userID=" + id + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = unescape(data).split(",");
			//alert(ar);
			for (i = 0; i < ar.length; i++){
				var ar1 = new Object();
				ar1 = ar[i].split("|");
				$("#" + ar1[0]).val(nullNoDisp(ar1[1]));
				if(ar1[0] == "loginDate" || ar1[0] == "loginCount" || ar1[0] == "lockCount"){
					$("#" + ar1[0]).html("<font color='red'>" + nullNoDisp(ar1[1]) + "</font>");
				}
				//alert(ar1[0] + ":" + ar1[1]);
			}
			$("#item_old").val($("#userName").val());
			$("#passwd1").val($("#passwd").val());
		});
		document.getElementById("light").style.display="block";
		document.getElementById("fade").style.display="block";
		setInputStatus();
		newUser = 0;
	}
	
	function showSuccess(){
		$("#success").html("<img src='images/green_check.png'>");
		window.setTimeout(function(){
			$("#success").empty();
		},5000);
	}
	
	function getNodeInfo(nodeID){
		if("<%=free%>" == "0" && "<%=fix%>" == "0" && "<%=sWhere%>" == ""){
			$.get("unitControl.asp?type=getNodeMap&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
				//alert(unescape(re));
				$("#map").html("当前位置：&nbsp;<font color='orange'>" + unescape(re) + "</font>");
				$("#addNew").show();
			});
		}
		if("<%=free%>" == "1"){
			$("#map").html("自由搜索条件：&nbsp;<font color='orange'><%=con%></font>");
			$("#searchText").val("<%=con%>");
			$("#addNew").hide();
		}
		if("<%=fix%>" == "1"){
			$("#map").html("用户状态：&nbsp;<font color='orange'><%=con%></font>");
			$("#filterStatus").val("<%=con%>");
			$("#addNew").hide();
		}
		if("<%=sWhere%>" > ""){
			$("#map").html("当前用户：&nbsp;<font color='orange'><%=sTitle%></font>");
			$("#filterStatus").val("<%=con%>");
			$("#addNew").hide();
		}
	}
	
	function setDropList(){
		$.get("commonControl.asp?op=getDicList&keyID=userStatus&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split(",");
			$("#status").empty();
			$("#filterStatus").empty();
			$("<option value='-1'>全部</option>").appendTo("#filterStatus");
			if(ar.length > 0){
				for(i=0; i<ar.length; i++){
					var ar1 = new Array();
					ar1 = ar[i].split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#status");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#filterStatus");
				}
				if(<%=fix%> == 1){
					$("#filterStatus").val(<%=con%>);
				}else{
					$("#filterStatus").val(-1);
				}
			}
		});
		$.get("commonControl.asp?op=getDicList&keyID=role&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split(",");
			$("#role").empty();
			if(ar.length > 0){
				for(i=0; i<ar.length; i++){
					var ar1 = new Array();
					ar1 = ar[i].split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#role");
				}
			}
		});
		$.get("commonControl.asp?op=getGroupList&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split(",");
			$("#acsGroup").empty();
			if(ar.length > 0){
				for(i=0; i<ar.length; i++){
					var ar1 = new Array();
					ar1 = ar[i].split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#acsGroup");
				}
			}
		});
		/*
		$.get("commonControl.asp?op=getQuestionList&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split(",");
			$("#question1").empty();
			$("#question2").empty();
			if(ar.length > 0){
				for(i=0; i<ar.length; i++){
					var ar1 = new Array();
					ar1 = ar[i].split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#question1");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#question2");
				}
			}
		});
		*/
	}
	
	function setInputStatus(){
		//根据不同身份的用户确定不同的操作范围
		if($("#role").val() == "superAdmin"){
			$("#delUser").attr("disabled","true");
			if('<%=Session("limit_key")%>' != "superAdmin"){
				$("#saveUser").attr("disabled","true");
			}
		}
	}
	
	function nullNoDisp(m){
		var s = "";
		if(m != null && m > "" && m != "null"){
			s = m;
		}
		return s;
	}
	
	function checkPwd(passwd){ 
		var r = true;
	    var repPass = /^[0-9a-zA-Z]{6,16}$/;    //检查密码 
	    var repPass1 = /[0-9]{1,}/; //数字 
	    var repPass2 = /[a-zA-Z]{1,}/; //字母 
	    if(!repPass.test(passwd.value) || (passwd.value == null)){//检查密码 
			r = false;
	    } 
	    if(!repPass1.test(passwd.value) || !repPass2.test(passwd.value)){ 
			r = false;
	    }    
	    if(passwd.value.length<6||passwd.value.length>20) 
	    { 
			r = false;
	    } 
	    if(r == false){
	        alert('密码为字母和数字的组合,长度6～20!'); 
	        passwd.value=""; 
	        passwd.select(); 
	    }

		return r; 
	} 
	function confirmPwd(){ 
		var r = true;
	    if($("#passwd").val() != $("#passwd1").val()) 
	    { 
			r = false;
	        alert('两次输入的密码不一致!'); 
	        $("#passwd1").focus();
	    } 
		return r; 
	} 
	
	function setSel(){
	    var chkother= document.getElementsByName("visitstockchk");
	    for (var i=0;i<chkother.length;i++)
	        chkother[i].checked = visitobj; 
	    visitobj = visitobj == true ? false : true;
	}
	
	function removeSel(){
	    var chkother= document.getElementsByName("visitstockchk");
	    for (var i=0;i<chkother.length;i++)
	        chkother[i].checked = false; 
	}
	
	function chkCart()
	{
		var ok = true;
	    $.get("commonControl.asp?op=getSession&sName=userCart&times=" + (new Date().getTime()), function(re){
	    	var s = unescape(re);
	    	//alert(s);
		    if(s.length<1){
		    	add2Cart();
			    $.get("commonControl.asp?op=getSession&sName=userCart&times=" + (new Date().getTime()), function(re1){
			    	s = unescape(re1);
			    	//alert(s);
				    if(s.length<1){
				        jAlert("请选择您要处理的用户!");
				        ok = false;
		    		}
		    	});
		    }
	    });
	    return ok;
	}
	
	function add2Cart()
	{
		var count = 0;
		var strSQL = "";
		selList = "";
		var chkother = document.getElementsByName("visitstockchk"); 
		for (var i = 0;i < chkother.length;i++)
		{
		    if(chkother[i].checked == true){
		        count++;
				strSQL += chkother[i].value + ",";
			}
		}
		if(count>0)
		{
			selList = strSQL.substring(0,strSQL.length-1);
			selCount = count;
			//alert(selList);
			$.get("commonControl.asp?op=setSession&sName=userCart&anyStr=" + selList + "&times=" + (new Date().getTime()),function(re){
				//alert(re);
			});
			jAlert("已经将" + selCount + "个用户添加到名单中。");
		}else{
			jAlert("您还没有选中任何用户。");
		}
	}
	
	function clearCart()
	{
		jConfirm("你确定要取消所有选中的名单吗?", "确认对话框", function(r) {
			if(r){
				$.get("commonControl.asp?op=clearSession&sName=userCart&times=" + (new Date().getTime()),function(){
					removeSel();
					jAlert("选中的用户名单已清空。");
				});
			}
		});
	}
	
	function opSel()
	{
			if(chkCart()){
				//alert(selList);
				//window.open("floatUserCart.asp","_blank");
				//jQuery.facebox({ ajax: 'floatUserCart.asp?times=' + (new Date().getTime()) });
				$("#floatTab").load("floatUserCart.asp?times=" + (new Date().getTime()));
				document.getElementById("light1").style.display="block";
				document.getElementById("fade1").style.display="block";
			}
	}

	function accountActive(){
		jConfirm("你确定要激活这些账户吗?", "确认对话框", function(r) {
			if(r){
				$.get("userControl.asp?type=accountActive&times=" + (new Date().getTime()),function(re){
					jAlert("成功激活了" + selCount + "个账户。");
				});
			}
		});
	}

	function accountClose(){
		jConfirm("你确定要禁用这些账户吗?", "确认对话框", function(r) {
			if(r){
				$.get("userControl.asp?type=accountClose&times=" + (new Date().getTime()),function(re){
					jAlert("成功禁用了" + selCount + "个账户。");
				});
			}
		});
	}

	function accountOpen(){
		jConfirm("你确定要启用这些账户吗?", "确认对话框", function(r) {
			if(r){
				$.get("userControl.asp?type=accountOpen&times=" + (new Date().getTime()),function(re){
					jAlert("成功启用了" + selCount + "个账户。");
				});
			}
		});
	}

	function accountDel(){
		jConfirm("你确定要删除这些账户吗?", "确认对话框", function(r) {
			if(r){
				$.get("userControl.asp?type=accountDel&times=" + (new Date().getTime()),function(re){
					jAlert("成功删除了" + selCount + "个账户。");
				});
			}
		});
	}

	function sendMail(){
		window.parent.open("email.asp?times=" + (new Date().getTime()),"_self");
	}

</script>
</head>
<body style="overflow:overflow-x:hidden">
<div id="layout" align="left">
 <!--#include file="js/mainMenu.js" -->
 
<div valign="baseline">
	<div id="light" class="white_content" STYLE="font-family: Arial; font-size: 12px; color: black"> 
	<div align="left">
	  <span align="left" onclick="document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'"><img src="../Images/close3.gif" />
		  </span>
	  </div>    
		<br>
		<table width="80%"  border="0" style="font:1.2em "宋体",Arial,Times">
			<tr><td>
				<form method="post" action="userControl.asp?type=update" name="form1" id="editUser">
				  <table align="center" width="80%">
				    <tr valign="baseline">
				      <td nowrap align="left"><label for="textinput">用户名:</label></td>
				      <td align="left"><input type="hidden" id="ID" name="ID" value="">
				      	<input class="textinputs" type="text" id="userName" name="userName" value="" size="20"></td>
				      <td nowrap align="left"><label for="textinput">密码:</label></td>
				      <td align="left"><input class="textinputs" type="password" id="passwd" name="passwd" value="" size="20" onChange="checkPwd(this)"></td>
				      <td nowrap align="left"><label for="textinput">确认密码:</label></td>
				      <td align="left"><input class="textinputs" type="password" id="passwd1" name="passwd1" value="" size="20" onChange="confirmPwd()"></td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="left"><label for="textinput">姓名:</label></td>
				      <td align="left"><input class="textinputs" type="text" id="realName" name="realName" value="" size="30">
				      	<input name="item_old" type="hidden" id="item_old" value=""></td>
				      <td nowrap><label for="textinput">员工编号:</label></td>
				      <td><input class="textinputs" type="text" id="empID" name="empID" value="" size="20"></td>
				      <td nowrap><label for="textinput">申请原因:</label></td>
				      <td><input class="textinputs" type="text" id="reason" name="reason" value="" size="30"></td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap><label for="textinput">类型:</label></td>
				      <td><select id="role" name="role" style="width:151px"></select></td>
				      <td nowrap><label for="textinput">状态:</label></td>
				      <td><select id="status" name="status" style="width:151px"></select></td>
				      <td nowrap><label for="textinput">密码有效期:</label></td>
				      <td><input class="textinputs" type="text" id="limitedDate" name="limitedDate" value="" size="30"></td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap><label for="textinput">ACS组别:</label></td>
				      <td><select id="acsGroup" name="acsGroup" style="width:151px"></select></td>
				      <td nowrap><label for="textinput">公司邮箱:</label></td>
				      <td><input class="textinputs" type="text" id="email" name="email" value="" size="20"></td>
				      <td nowrap><label for="textinput">个人邮箱:</label></td>
				      <td><input class="textinputs" type="text" id="emailPerson" name="emailPerson" value="" size="20"></td>
				    </tr>
				    <%
				    /*
				    <tr valign="baseline">
				      <td nowrap><label for="textinput">密码问题1:</label></td>
				      <td><select id="question1" name="question1" style="width:151px"></select></td>
				      <td nowrap><label for="textinput">问题1答案:</label></td>
				      <td><input class="textinputs" type="password" id="answer1" name="answer1" value="" size="20"></td>
				      <td nowrap><label for="textinput">密码问题2:</label></td>
				      <td><select id="question2" name="question2" style="width:151px"></select></td>
				      <td nowrap><label for="textinput">问题2答案:</label></td>
				      <td><input class="textinputs" type="password" id="answer2" name="answer2" value="" size="20"></td>
				    </tr>
				    */
				    %>
				    <tr valign="baseline">
				      <td nowrap><label for="textinput">所属部门:</label></td>
				      <td colspan="3" scope="col"><input type="hidden" id="deptID" name="deptID" value="">
				      	<input class="textinput" type="text" id="unitName" name="unitName" value="" size="30"></td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap><label for="textinput">备注:</label></td>
				      <td colspan="5" scope="col"><input class="textinput" type="text" id="description" name="description" value="" size="30"></td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap><label for="textinput">登录情况:</label></td>
				      <td colspan="5" scope="col" align="left"><div><label for="textinput">最后登录:&nbsp;</label>&nbsp;<span id="loginDate"></span>&nbsp;&nbsp;&nbsp;
				      	<label for="textinput">登录次数:&nbsp;</label><span id="loginCount"></span>&nbsp;&nbsp;&nbsp;
				      	<label for="textinput">锁定次数:&nbsp;</label><span id="lockCount"></span>
				      	</div></td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="center" colspan="8" scope="col">
				      	<input id="saveUser" style="height:20;vertical-align:middle;border:solid 1px; background: #fff;" type="submit" value="    保存    ">&nbsp;&nbsp;&nbsp;
				      	<input id="delUser" c style="height:20;vertical-align:middle;border:solid 1px; background: #fff;" type="button" value="    删除    ">  
				      </td>
				    </tr>
				  </table>
				</form>
			</td></tr>
		</table>
	</div> 
	<div id="fade" class="black_overlay"></div> 
</div>
<div valign="baseline">
	<div id="light1" class="white_content" STYLE="font-family: Arial; font-size: 12px; color: black"> 
		<div align="left">
		  <span align="left" onclick="document.getElementById('light1').style.display='none';document.getElementById('fade1').style.display='none'"><img src="../Images/close3.gif" />
		  </span>
		</div>    
		<br>
		<div id="listTitle" align="center">被选中的用户名单</div>
		<br>
		<div id="floatTab">
		</div>
		<div>
			<br>
			<a id="accountActive" onClick="accountActive()" class="l-btn">激活</a>&nbsp;&nbsp;<a id="accountClose" onClick="accountClose()" class="l-btn">禁用</a>&nbsp;&nbsp;<a id="accountOpen" onClick="accountOpen()" class="l-btn">启用</a>&nbsp;&nbsp;<a id="accountDel" onClick="accountDel()" class="l-btn" type="button">删除</a>&nbsp;&nbsp;<a id="sendMail" onClick="sendMail()" class="l-btn">发送邮件</a>
			<br>
		</div>
	</div> 
	<div id="fade1" class="black_overlay"></div> 
</div>

  	<table border="0" cellpadding="0" cellspacing="0" valign="top" width = "100%" style="background:#f0f0ff;">
  		<tr>
  			<td>
  				<span id="map" align="left">&nbsp;</span>
  			</td>
  		</tr>
	</table>
  			<div align="right" style="background:#fff0ff;">
				<form action="loadFile.asp?type=upload&kindID=2" id="form2" name="form2" encType="multipart/form-data"  method="post" target="hidden_frame" >
	  				<a href="#" class="l-btn" icon="icon-reload" name="backup" id="backup">导出结果</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<font color="gray">状态</font>&nbsp;<select id="filterStatus" name="filterStatus" style="width:70px"></select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 					<input type="text" id="searchText" name="searchText" size="10">
	  				<a href="#" class="l-btn" icon="icon-search" name="search" id="search">自由搜索</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="file" id="file" name="file" style="width:100">
	  				<input name="restore" type="submit"  id="restore" value="文件导入">&nbsp;&nbsp;
					<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>
				</form>
  			</div>
	<div align="right" style="background:#f9f9f9;">&nbsp;</div>
  	
<table cellpadding="0" cellspacing="0" border="0" class="display" id="mainTab">
	<thead>
		<tr>
			<th width="20%">用户名</th>
			<th width="13%">姓名</th>
			<th width="25%">所在部门</th>
			<th width="10%">员工号</th>
			<th width="15%">密码时限</th>
			<th width="5%">组</th>
			<th width="10%">状态</th>
			<th width="2%">&nbsp;</th>
			<th width="0%">公司邮箱</th>
		</tr>
	</thead>
	<tbody id="tbody">
	<%
	var c = "";
                      
	sql = "SELECT * FROM v_userInfo";

	if(free == 0){
		c = " where deptID=" + nodeID;
	}else{
		if(con > ""){
			c = " where userName like '%" + con + "%' or realName like '%" + con + "%' or email like '%" + con + "%' or emailPerson like '%" + con + "%' or empID like '%" + con + "%' or reason like '%" + con + "%' or unitName like '%" + con + "%'";
		}else{
			c = "";   //all records will be selected.
		}
	}
	if(fix == 1){
		if(con != "-1" && con != -1){
			c = " where status=" + con;
		}else{
			c = "";  //all records will be selected.
		}
	}
	if(sWhere != ""){
		c = " where " + sWhere;
	}
	sql += c;
	var rs = conn.Execute(sql);
	
	while (!rs.EOF){
	%>
		<tr class='grade0'>
			<td class="link1"><a href="#" onClick="showEdit('<%=rs("ID")%>')"><%=rs("userName")%></a></td>
			<td><%=rs("realName")%></td>
			<td><%=rs("unitName")%></td>
			<td><%=rs("empID")%></td>
			<td><%=rs("limitedDate")%></td>
			<td class="center"><%=rs("acsGroup")%></td>
			<td class="center"><%=rs("userStatus")%></td>
			<td>
				<input style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none" 
      type="checkbox" value='<%=rs("userName")%>' name="visitstockchk">
			</td>
			<td><%=rs("email")%></td>
		</tr>
	<%
		rs.MoveNext();
	}
	rs.Close();
	%>
	</tbody>
	<tfoot>
		<tr>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
	</tfoot>
	</table>
	<input type="hidden" id="sql" name="sql" value="<%=sql%>">
  	<div align="center" style="background:#fff0ff;">
  	<table cellpadding="0" cellspacing="0" border="0">
  		<tr>
  			<td width="50" align="left"><span id="success"></span>&nbsp;</td>
  			<td align="left">
	      <input name="uID" type="hidden" id="uID" value="">
	      <a class="l-btn" name="addNew" type="button"  id="addNew">新增用户</a>&nbsp;&nbsp;
            	<a class="l-btn" id="btnChk" onClick="setSel();">全选/取消</a>&nbsp;&nbsp;
  			</td>
            <td align="right" style="background: #fafafa;">&nbsp;处置名单:&nbsp;
            	<a class="l-btn" icon="icon-add" id="add2Cart">加入</a>
            	<a class="l-btn" icon="icon-cut" id="clearCart">清空</a>
            	<a class="l-btn" icon="icon-cart" id="opSel">处置</a>
            </td>
    </tr></table>
    </div>
</div>
</body>
</html>
