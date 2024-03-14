<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<link rel="stylesheet" type="text/css" media="screen" href="css/niceforms.css" />
<link href="css/style_main.css"  rel="stylesheet" type="text/css" />
<link type="text/css" href="css/jquery-ui-1.7.2.custom.css" rel="stylesheet" />	
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easing.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.7.2.custom.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
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
			pre {font-size:12px; font-family:"Consolas","Monaco","Bitstream Vera Sans Mono","Courier New","Courier"; line-height:120%; background:#F4F4F4; padding:10px;}
			#general {margin:30px;}
			
			#myHiddenDiv {display:none;}
			
			.popup {background:#FFF; border:1px solid #333; padding:1px;}
			.popup-header {height:24px; padding:7px; background:url("bgr_popup_header.jpg") repeat-x;}
			.popup-header h2 {margin:0; padding:0; font-size:14px; float:left; color:gray}
			.popup-header .close-link {float:right; font-size:11px;}
			.popup-body {padding:10px;}
		</style>

<script language="javascript">
	$.ajaxSetup({ async: false });
	var Option = 0;
	$(document).ready(function () {
		$("#save").click(function(){
			/*
			if(Option == 0){
				jAlert("请选择一种方式。","提示");
				return false;
			}
			if($("#username").val() == ""){
				jAlert("请填写用户名。","提示");
				$("#username").focus();
				return false;
			}
			*/
			//$.get("userControl.asp?type=findPwd" + Option + "&userName=" + escape($("#username").val()) + "&answer1=" + escape($("#answer1").val()) + "&answer2=" + $("#answer2").val() + "&times=" + (new Date().getTime()),function(re){
			$.get("userControl.asp?type=findPwd2&userName=" + escape($("#username").val()) + "&times=" + (new Date().getTime()),function(re){
				var ar = new Array();
				ar = unescape(re).split("|");
				var k = ar[0];
				var m = ar[1];
				jAlert(m,"提示");
				if(k == 0){
						showSuccess();
				}
				/*
				if(k == 1){
					//jAlert("答案不能为空!","提示");
					$("#anwser1").focus();
				}
				if(k == 2){
					//jAlert("第一个答案不对，请重新输入。","提示");
					$("#anwser1").focus();
				}
				if(k == 3){
					//jAlert("第二个答案不对，请重新输入。","提示");
					$("#anwser2").focus();
				}
				*/
				if(k == 9){
					//jAlert("密码已成功发送到您的邮箱，请查收!","提示");
				}
			});
			
			return false;
		});
		
		$("#username").change(function(){
			$.get("userControl.asp?type=getUserInfoByName&userName=" + escape($("#username").val()) + "&times=" + (new Date().getTime()),function(re){
				if(re > ""){
					/*
					var ar = new Array();
					ar = re.split("|");
					$("#question1").attr("disabled",false);
					$("#question2").attr("disabled",false);
					$("#question1").val(ar[0]);
					$("#question2").val(ar[1]);
					$("#question1").attr("disabled",true);
					$("#question2").attr("disabled",true);
					*/
					$("#imgAllow1").html("<img src='images/green_check.png'");
					window.setTimeout(function(){
						$("#imgAllow1").empty();
					},3000);
				}else{
					$("#imgAllow1").html("<img src='images/cancel.png' width='13' height='13'>");
					window.setTimeout(function(){
						$("#imgAllow1").empty();
					},3000);
				}
			});
			return false;
		});
		/*
		$("#option1").click(function(){
			Option = 1;
		});
		$("#option2").click(function(){
			Option = 2;
			$("#anwser1").val('');
			$("#anwser2").val("");
		});
		
		$("#answer1").click(function(){
			$("#option1").attr("checked",true);
			Option = 1;
		});
		$("#answer2").click(function(){
			$("#option1").attr("checked",true);
			Option = 1;
		});
		*/
		$("#close").click(function(){
			window.opener=null;
			window.open('','_top');
			window.top.close();
		});
		
		$("#login").click(function(){
			self.location = "default.asp";
		});
		
		//setDropList();
	});
	
	function showSuccess(){
		$("#success").html("<img src='images/green_check.png'>");
		window.setTimeout(function(){
			$("#success").empty();
		},3000);
	}
	/*
	function setDropList(){
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
	}
	*/
	function nullNoDisp(m){
		var s = "";
		if(m != null && m > "" && m != "null"){
			s = m;
		}
		return s;
	}
	
</script>
</head>
<body style="overflow:overflow-x:hidden">
<div id="layout" align="left">
	<div id="header">
	<h1>SLC NAC</h1>
	</div>
<div align="center"><font color="orange" style="font-size:20px">遗失密码</font></div> 
<br>
<div valign="baseline">
				<form method="post" action="" name="form1" id="editUser">
				  <table align="center" width="80%">
				    <tr valign="baseline">
				      <td nowrap align="left" colspan="3" scope="col"></td>
				      <td>&nbsp;</td>
				    </tr>
				    <tr valign="baseline">
				      <td colspan="3" scope="col">&nbsp;</td>
				      <td>&nbsp;</td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="right"><label for="textinput">请输入用户名:</label></td>
				      <td><input class="textinputs" type="text" id="username" name="username" value="" size="20">&nbsp;<span id="imgAllow1"></span></td>
				      <td>&nbsp;</td>
				      <td>&nbsp;</td>
				    </tr>
				    <tr valign="baseline">
				      <td colspan="3" scope="col">&nbsp;</td>
				      <td>&nbsp;</td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="right"></td>
				      <td colspan="2" scope="col"><label for="textinput">系统将自动把密码发送到您预先登记的邮箱中。</label></td>
				      <td>&nbsp;</td>
				    </tr>
				    <%/*
				    <tr valign="baseline">
				      <td nowrap align="left" colspan="3" scope="col"><label for="textinput">请选择下面两种方式之一找回密码：</label></td>
				      <td>&nbsp;</td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="left"><input type="radio" id="option1" name="options"><label for="textinput">&nbsp;&nbsp;回答机密问题</label></td>
				      <td align="left"></td>
				      <td>&nbsp;</td>
				      <td>&nbsp;</td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="right"><label for="textinput">密码问题1:</label></td>
				      <td><select id="question1" name="question1" style="width:151px"></select></td>
				      <td>&nbsp;</td>
				      <td>&nbsp;</td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="right"><label for="textinput">问题1答案:</label></td>
				      <td><input class="textinputs" type="text" id="answer1" name="answer1" value="" size="20"></td>
				      <td>&nbsp;</td>
				      <td>&nbsp;</td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="right"><label for="textinput">密码问题2:</label></td>
				      <td><select id="question2" name="question2" style="width:151px"></select></td>
				      <td>&nbsp;</td>
				      <td>&nbsp;</td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="right"><label for="textinput">问题2答案:</label></td>
				      <td><input class="textinputs" type="text" id="answer2" name="answer2" value="" size="20"></td>
				      <td>&nbsp;</td>
				      <td>&nbsp;</td>
				    </tr>
				    <tr valign="baseline">
				      <td nowrap align="left"><input type="radio" id="option2" name="options"><label for="textinput">&nbsp;&nbsp;发送到邮箱</label></td>
				      <td align="left" colspan="3" scope="col"><label for="textinput">系统将自动把密码发送到您预先登记的邮箱中。</label></td>
				    </tr>
				    */%>
				    <tr valign="baseline">
				      <td nowrap colspan="4" scope="col"></td>
				    </tr>
				    <tr valign="baseline">
				    	<td align="right"><span id="success">&nbsp;</span>&nbsp;</td>
				      <td nowrap align="left" colspan="3" scope="col">
				      	<input id="save" type="submit" style="height:20;vertical-align:middle;border:solid 1px; background: #fff;" value="  确定  ">
				      	&nbsp;&nbsp;&nbsp;<input id="close" style="height:20;vertical-align:middle;border:solid 1px; background: #fff;" type="button" value="  关闭  ">
				      	&nbsp;&nbsp;&nbsp;<input id="login" style="height:20;vertical-align:middle;border:solid 1px; background: #fff;" type="button" value="  登录  ">
				      </td>
				    </tr>
				  </table>
				</form>
</div>
</div>
</body>
</html>
