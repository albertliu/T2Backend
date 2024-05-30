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
<html>
  <head>
	<meta charset="utf-8">  
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />  
	<meta name="format-detection" content="telephone=no" />  
	<meta name="apple-mobile-web-app-capable" content="yes" />  
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.1">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.0">
	<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="js/md5.min.js"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.0"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
	<script src="http://pv.sohu.com/cityjson?ie=utf-8"></script>
  <title>系统登录</title>
        <style>
            .container {
                text-align: center;
                width: 100%;
            }
            .inputContainer {
                width:300px;
                margin: auto;
                margin-top: 20px;
            }
            .inputLabel {
                font-size: 13px;
                padding-right: 10px;
                font-weight: normal;
				font-family:'幼圆';
				color:#000;
            }
            .inputButton {
                margin-top: 20px;
            }
        </style>
    </head>
<script language="javascript">
	var event = "";
	var msg = "";
	var currHost = "xxx";
	var mySection = "ak47";	//本区编号
	$(document).ready(function (){
		event = "<%=event%>";
		msg = "<%=msg%>";
		//$.messager.alert("提示",md5("111"));
		if(event == "logout" && msg > ""){
			$.messager.alert("提示","对不起，您的操作已经超时，请重新登录。");
		}
		//$("#companyLogo").attr("src","users/upload/companies/logo/" + currHost + ".png");
		$("#username").textbox("setValue","");
		$("#username").textbox({
			inputEvents: $.extend({}, $.fn.textbox.defaults.inputEvents, {
			   keypress: function (e) {
			       if (e.keyCode == 13) {
							login(); 
							return false;
			       }
			   }
			})
		});
		$("#passwd").textbox({
			inputEvents: $.extend({}, $.fn.textbox.defaults.inputEvents, {
			   keypress: function (e) {
			       if (e.keyCode == 13) {
							login(); 
							return false;
			       }
			   }
			})
		});
		/*
		$.get("login.asp?op=" + ff("getAdminProperty") + "&kindID=" + ff("adminPhone") + "&host=" + currHost + "&times=" + (new Date().getTime()),function(re){
			$("#adminPhone").tooltip({
				content:"请联系管理员 " + unescape(re)
			});
		});*/
		$.get("login.asp?op=" + ("getAdminProperty") + "&kindID=" + ("adminPhone") + "&times=" + (new Date().getTime()),function(re){
			$("#adminPhone").tooltip({
				content:"请联系管理员 " + unescape(re)
			});
		});
		$("#winButton").window({
			title:'系统登录',
			width:320,
			height:330,
			collapsible:false,
			minimizable:false,
			maximizable:false
		});

		$("#btnCancel").linkbutton({
			iconCls:'icon-cancel',
			width:80,
			height:30,
			text:'取消',
			onClick:function() {
				$('#winButton').window('close');
			}
		});

		$("#btnLogin").linkbutton({
			iconCls:'icon-ok',
			width:80,
			height:30,
			text:'登陆',
			onClick:function() {
				login();
			}
		});
		$('#dlg').dialog('close');
		$("#username").textbox().next('span').find('input').focus();
	});

	function ff(str){
		str = String(str);
		if(str == null || str == "" || str == undefined){
			return "";
		}
		//return str;
		var last = "";
		var m = mySection;  //key
		for(var i=0; i<str.length; i++){
			for(var j=0; j<m.length; j++){
				var k = m.charCodeAt(j);
				var tt = str.charCodeAt(i) ^ k;
			}
			last += String.fromCharCode(tt);
		}
		return escape(last);
	}

	function ff0(str){
		str = unescape(str);
		if(str == null || str == "" || str == undefined){
			return "";
		}
		//return str;
		var last = "";
		var m = mySection;  //key
		for(var i=0; i<str.length; i++){
			for(var j=0; j<m.length; j++){
				var k = m.charCodeAt(j);
				var tt = str.charCodeAt(i) ^ k;
			}
			last += String.fromCharCode(tt);
		}
		return last;
	}
	
  	function login(){
    //alert($("#username").textbox("getValue") + "," + $("#passwd").textbox("getValue") + "," + window.location.host.split(".")[0]);
		if($("#username").val()=="" || $("#passwd").val()==""){
			$.messager.alert("提示","用户名或密码不能为空。","warning");
			return false;
		}
		
		$.get("login.asp?op=login&username=" + $("#username").val() + "&passwd=" + md5($("#passwd").val()) + "&times=" + (new Date().getTime()),function(re){
			// alert(unescape(re));
			ar = unescape(re).split("|");
			if(ar[0]==0){  //passed
				if($("#passwd").val()=="123456"){
					$('#dlg').dialog('open');
					$.messager.alert("提示","您用的是默认密码，修改后请重新登录。");
					return false;
				}
				if($("#username").val()=="room"){
					self.location = "face_camera.asp?times=" + (new Date().getTime());
				}else{
					self.location = "index.asp?times=" + (new Date().getTime());
				}
				//self.location = "default1.asp?times=" + (new Date().getTime());
			}else{  //something is wrong
				$.messager.alert("提示",ar[1],"warning");
			}
		});
		return false;
	}
	
  	function updatePasswd(){
		if($("#newpasswd1").val()==$("#newpasswd2").val()){
			$.get("login.asp?op=updatePasswd&username=" + $("#p_username").val() + "&passwd=" + md5($("#p_passwd").val()) + "&newpasswd=" + md5($("#newpasswd1").val()) + "&times=" + (new Date().getTime()),function(re){
				//alert(unescape(re));
				var ar = unescape(re);
				if(ar==0){  //passed
					$.messager.alert("提示","密码修改成功。");
					$('#dlg').dialog('close');
				}else{  //something is wrong
					if(ar==1){
						$.messager.alert("提示","用户名错误。","warning");
					}
					if(ar==2){
						$.messager.alert("提示","原密码输入错误。","warning");
					}
					if(ar==3){
						$.messager.alert("提示","账号已被禁用，请与管理员联系。","warning");
					}
				}
			});
		}else{
			$.messager.alert("提示","两次输入的新密码不一致。","warning");
		}
		return false;
	}

	document.oncontextmenu=Click;
	function Click(){
		window.event.returnValue=false;
	}

</script>
    <body>
        <div class="easyui-window" id="winButton" style="overflow-x:hidden;overflow-y:hidden;">
			<div style="background:orange;height:90px;">
				<div style="padding:20px;0;0;50px;font-size:2em;font-weight:normal;font-family:'幼圆';color:#EEE;">特种作业学习管理系统</div>
				<div style="float:right;padding:5px;font-size:0.9em;font-weight:normal;font-family:'幼圆';color:#EEE;background:#000;">eTraining V2.0&nbsp;</div>
            </div>
            <div class="container">
                <div class="inputContainer">
                    <label class="inputLabel">请输入账号</label>
                    <input id="username" name="username" class="easyui-textbox" data-options="height:22,width:160">
                </div>
                <div class="inputContainer">
                    <label class="inputLabel">请输入密码</label>
                    <input id="passwd" name="passwd" class="easyui-textbox" type="password" data-options="height:22,width:160">
                </div>
                <a id="btnLogin" class="easyui-linkbutton inputButton" href="javascript:void(0)" style="margin-left: 20px"></a>
                <a id="btnCancel" class="easyui-linkbutton inputButton" href="javascript:void(0)"></a>
                <div style="padding-top:20px;flot:left;font-family:'幼圆';color:#666;">忘记密码? 请联系<a id="adminPhone" href="#" title="" class="easyui-tooltip" style='text-decoration:none;color:green;'>管理员</a></div>
                <div style="padding-top:5px;flot:left;font-family:'幼圆';color:#666;">密码已过期? 请<a href="#" title="" onclick="$('#dlg').dialog('open')" style='text-decoration:none;color:green;'>更新密码</a></div>
            </div>
        </div>
		<div id="dlg" class="easyui-dialog" title="更新密码" data-options="
			iconCls:'icon-lock',
			buttons: [{
				text:'Ok',
				iconCls:'icon-ok',
				handler:function(){
					updatePasswd();
				}
			},{
				text:'Cancel',
				handler:function(){
					$('#dlg').dialog('close');
				}
			}]
			" style="width:330px;height:300px;padding:10px">
			<form>
	          <div class="inputContainer">
	              <label class="inputLabel">输入账号</label>
	              <input id="p_username" name="p_username" class="easyui-textbox" data-options="height:22,width:160,required:true">
	          </div>
	          <div class="inputContainer">
	              <label class="inputLabel">当前密码</label>
	              <input id="p_passwd" name="p_passwd" class="easyui-textbox" type="password" data-options="height:22,width:160,validType:'length[6,20]',required:true">
	          </div>
	          <div class="inputContainer">
	              <label class="inputLabel">新的密码</label>
	              <input id="newpasswd1" name="newpasswd1" class="easyui-textbox" type="password" data-options="height:22,width:160,validType:'length[6,20]',required:true">
	          </div>
	          <div class="inputContainer">
	              <label class="inputLabel">确认一次</label>
	              <input id="newpasswd2" name="newpasswd2" class="easyui-textbox" type="password" data-options="height:22,width:160,validType:'length[6,20]',required:true">
	          </div>
			</form>
		</div>
    </body>
</html>