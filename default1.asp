<!--#include file="js/doc.js" -->
<%
var event = "";
var msg = "";
if (String(Request.QueryString("event")) != "undefined" && 
    String(Request.QueryString("event")) != "") { 
  event = String(Request.QueryString("event"));
}
if (String(Request.QueryString("msg")) != "undefined" && 
    String(Request.QueryString("msg")) != "") { 
  msg = String(Request.QueryString("msg"));
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title>特种作业在线学习</title>

	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />  
	<meta name="format-detection" content="telephone=no" />  
	<meta name="apple-mobile-web-app-capable" content="yes" />  
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
<link href="css/style_main.css"  rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.1">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.0">
<link href="css/colortip-1.0-jquery.css" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/md5.min.js"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.0"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script src="js/colortip-1.0-jquery.js" type="text/javascript"></script>
<script src="js/colortip-script.js" type="text/javascript"></script>
<script type="text/javascript" src="js/jquery.jmpopups-0.5.1.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<!--#include file="js/correctPng.js"-->
<!--#include file="js/clickMenuHome.js"-->

<script language="javascript">
	var event = "";
	var msg = "";
	var currHost = "xxx";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		event = "<%=event%>";
		msg = "<%=msg%>";
		if(event == "logout" && msg > ""){
			jAlert(msg);
		}
		//alert(md5("123456"));
		$("#username").focus();
		$("#companyLogo").attr("src","users/upload/companies/logo/" + currHost + ".png");
	    $("#log_in").click(function(){
			alert($("#username").val());
			$.get("login.asp?op=login&username=" + $("#username").val() + "&passwd=" + md5($("#passwd").val()) + "&times=" + (new Date().getTime()),function(re){
				var ar = new Array();
				ar = unescape(re).split("|");
				alert(ar);
				if(ar[0]==0){  //passed
					if($("#passwd").val()=="123456"){
						alert("您用的是默认密码，登录以后请在首页上修改密码。");
					}
					self.location = "index.asp?times=" + (new Date().getTime());
				}
				if(ar[0]==1){  //name is wrong
					$("#imgAllow1").html("<img src='images/cancel.png' width='13' height='13'>");
					window.setTimeout(function(){
						$("#imgAllow1").empty();
					},3000);
				}
				if(ar[0]==2){  //password is wrong
					$("#imgAllow2").html("<img src='images/cancel.png' width='13' height='13'>");
					window.setTimeout(function(){
						$("#imgAllow2").empty();
					},3000);
				}
				if(ar[0]==3){  //access deny
					jAlert("该账户已经被禁用！","提示");
				}
				if(ar[0]==4){  //密码过期
					jConfirm("该账户密码已过期，请重新设置！","确认对话框",function(r){
						if(r){
							self.location = "userEdit.asp";
						}
					});
				}
			});
			return false;
		});
		
		$("#cancel").click(function(){
			$("#username").val("");
			$("#passwd").val("");
			printDiv();
		});
		
		$("#username1").change(function(){
			$.get("userControl.asp?type=getUserInfoByName&userName=" + escape($("#username1").val()) + "&times=" + (new Date().getTime()),function(re){
				if(re > ""){
					$("#imgAllow3").html("<img src='images/green_check.png' width='13'>");
					window.setTimeout(function(){
						$("#imgAllow3").html("<img src='images/blank.png' width='13'>");
					},3000);
				}else{
					$("#imgAllow3").html("<img src='images/cancel.png' width='13'>");
					window.setTimeout(function(){
						$("#imgAllow3").html("<img src='images/blank.png' width='13'>");
					},3000);
				}
			});
			return false;
		});
		
		$("#orderPwd").click(function(){
			if($("#username1").val() == ""){
				jAlert("请输入用户名！","提示");
				return false;
			}
			$.get("userControl.asp?type=findPwd2&userName=" + escape($("#username1").val()) + "&times=" + (new Date().getTime()),function(re){
				var ar = new Array();
				ar = unescape(re).split("|");
				
				//var k = ar[0];
				var m = ar[1];
				jAlert(m,"提示");
			});
			
			return false;
		});
		
		$("#username").keypress(function(event) {   
			if(event.keyCode==13){ 
				$("#log_in").click(); 
				return false;
			}      
		});
		
		$("#passwd").keypress(function(event) {   
			if(event.keyCode==13){  
				$("#log_in").click(); 
				return false;
			}      
		});
	});
	
	function openHelp(){
		window.open("help.asp?times=" + (new Date().getTime()),"_blank");
	}

	function printDiv(){
		document.body.innerHTML=document.getElementById('barcode').innerHTML;
		window.print();
	}

</script>

</head>

<body>
<div id="layout">
	<div style="background-image: url(images/logo_long1.png);height:60px;">
		<span style="float:right;padding-right:8px;padding-top:5px;margin:0px;border:0px;"><img id="companyLogo" src="" style="border:0px;height:50px;" /></span>
	</div>
	<div>
		<table height="460">
			<tr>
				<td width="55%" align="center">&nbsp;</td>
				<td width="10%" align="center">&nbsp;</td>
				<td width="30%" align="center">&nbsp;</td>
				<td width="5%">&nbsp;</td>
			<tr>
				<td>
					<div id="headlines"> 
					<p>
						<div style="background:#fcfcfc;" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<h5>用户登录</h5></div>
						<div style="background:#fcfcfc;">&nbsp;</div>
						<div style="background:#f0f0f9;" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如果忘记了密码，请与管理员联系。</div>
						<br>
					</p> 
						<form name="form1" id="form1" action="login.asp" class="comm">
							<table>
								<tr>
									<td align="left">
								<label>用户名：</label>
									</td>
									<td align="left">
								<input type="text" id="username" class="easyui-textbox" style="height:18px;width:256px;vertical-align:middle;border:solid 1px gray;" />
									</td>
									<td align="left"><span id="imgAllow1"><img src='images/blank.png' width='13'></span></td>
								</tr>
								<tr>
									<td>
								<label>密&nbsp;&nbsp;码：</label> 
									</td>
									<td>
									<input type="password" id="passwd" class="easyui-textbox" style="height:18px;width:256px;vertical-align:middle;border:solid 1px gray;" />
									</td>
									<td align="left"><span id="imgAllow2"><img src='images/blank.png' width='13'></span></td>
								</tr>
								<tr>
									<td>&nbsp;
									</td>
									<td align="center">
										<br />
												<a class="easyui-linkbutton" icon="icon-ok" style="font-size:12px;" id="log_in" href="#">登录</a>&nbsp;&nbsp;&nbsp;
												<a class="easyui-linkbutton" icon="icon-redo" id="cancel" href="#">重写</a>
                <a id="btnLogin" class="easyui-linkbutton inputButton" href="javascript:void(0)" style="margin-left: 20px"></a>
                <a id="btnCancel" class="easyui-linkbutton inputButton" href="javascript:void(0)"></a>
									</td>
									<td align="left">&nbsp;</td>
								</tr>
							</table>
						</form>
						<br>
						<br>
						<div align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如果遇到问题，请使用<a href="#" title="021-62312239"> 电话 </a>或<a href="#" title="xxx@163.com"> 邮件 </a>与管理员联系！</div>
						<br>
						<br>
					</div>
				</td>
				<td>&nbsp;</td>
				<td>
					<table>
						<tr>
						<td width="100">&nbsp;</td>
						<td width="150">
					<div style="background:#fcfcfc;border:solid 1px gray; width:80%;"> 
						<br><br>
						&nbsp;&nbsp;<a href="output\系统使用手册_前台.docx">查看帮助</a>&nbsp;&nbsp;&nbsp;&nbsp;
						<br><br><br>
					</div>
						</td>
						</tr>
						<tr>
						<td height="200">&nbsp;</td>
						<td>&nbsp;</td>
						</tr>
					</table>
				</td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</div>
	<br>
	<div class="clear"></div>
<!-- InstanceEndEditable -->

 <!--#include file="js/mainFooter.js" -->

</div>
  
</body>
<!-- InstanceEnd --></html>
