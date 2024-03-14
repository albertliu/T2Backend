<!--#include file="js/doc.js" -->
<%
chkUserActive();
var userid = Session("user_key");

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
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easing.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.7.2.custom.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/jquery.jmpopups-0.5.1.js"></script>
<!--#include file="js/correctPng.js"-->
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	
	$(document).ready(function () {
		$.ajaxSetup({ async: false });
		$("#editUser").ajaxForm(function(re){
			//alert((re));
			if(re == 0 || re == 9){
				showSuccess();
			}
			if(re == 1){
				jAlert("用户名不能为空");!
				$("#userName").focus();
			}
			if(re == 2){
				jAlert("密码不能为空!");
				$("#passwd").focus();
			}
			if(re == 9 || re == 0){
				window.location.reload();
			}
			
			return false;
		});
		
		$("#close").click(function(){
			window.opener = null;
			window.open("","_self");
			window.close();
		});
	});
	
	function showSuccess(){
		$("#success").html("<img src='images/green_check.png'>");
		window.setTimeout(function(){
			$("#success").empty();
		},3000);
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
	    if(passwd.value.length<6) 
	    { 
			r = false;
	    } 
	    if(r == false){
	        alert('密码长度不能少于6位!'); 
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
	/*
	*/
</script>
</head>
<body style="overflow:overflow-x:hidden">
<div id="layout">
	<div id="header">
	<h1>SLC NAC</h1>
	</div>
	<br><br>
	<%
	sql = "SELECT * FROM users where userName='" + userid + "'";
	var rs = conn.Execute(sql);
	
	if (!rs.EOF){
	%>
<div style="padding-left:30%;" align="left"><font color="#3F410F" style="font-size:16px"><%=rs("userName")%>&nbsp;(<%=rs("realName")%>)&nbsp;个人信息管理</font></div> 
<hr>
<br>
<div valign="baseline" align="center">
				<form method="post" action="userControl.asp?op=edit" name="editUser" id="editUser">
				  <table  style="border:solid 1px #e0e0e0;width:80%;margin:10px;background:#ffffff;line-height:38px;">
				    <tr valign="baseline">
				      <td align="left" colspan="2" scope="col" style="backgroud:#f0f0f9;">
				      	<div style="background:#fcfcfc;">
				      	<font color="red">*</font>&nbsp;密码要求至少6位，重置密码时不得与原密码相同。
				      	<input type="hidden" id="userName" name="userName" value="<%=rs("userName")%>">
				      	<input type="hidden" id="realName" name="realName" value="<%=rs("realName")%>">
				      	</div>
				      </td>
				    </tr>
				    <tr valign="baseline">
				      <td align="left"><label for="textinput">密码:</label>
				    	<input type="hidden" id="userID" name="userID" value="<%=rs("ID")%>"></td>
				      <td align="left"><input class="textinput" type="password" id="passwd" name="passwd" value="<%=rs("passwd")%>" size="20" onChange="checkPwd(this)">
				      	<input type="hidden" id="old_passwd" name="old_passwd" value="<%=rs("passwd")%>">
				      	<input type="hidden" id="status" name="status" value="<%=rs("status")%>">
				      </td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="left"><label for="textinput">确认密码:</label></td>
				      <td align="left"><input class="textinput" type="password" id="passwd1" name="passwd1" value="<%=rs("passwd")%>" size="20" onChange="confirmPwd()">
				      </td>
				    </tr>
				    <tr valign="baseline">
				    	<td align="left" width="30%"><span id="success">&nbsp;&nbsp;</span></td>
				      <td nowrap align="left">
				      	<input id="saveUser" style="height:20;vertical-align:middle;border:solid 1px; background: #fff;" type="submit" value="  保存  ">
				      	&nbsp;&nbsp;&nbsp;<input id="close" style="height:20;vertical-align:middle;border:solid 1px; background: #fff;" type="button" value="  退出  ">
				      </td>
				    </tr>
				  </table>
				</form>
</div>
				  <%
				  }
				  rs.Close();
				  %>
<div class="clear"></div>
</div>
</body>
</html>
