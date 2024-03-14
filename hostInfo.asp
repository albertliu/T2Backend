<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />  
	<meta name="format-detection" content="telephone=no" />  
	<meta name="apple-mobile-web-app-capable" content="yes" />  
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
	<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
	<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.18">
	<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
	<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
	<script src="js/jquery.alerts.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
	<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<style>
    .img-select img {
        width: 50px;
        height: auto;
    }

    .dialog-bg {
        display: none;
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        background: rgba(0,0,0,0.4);
    }
	.dialog-bg .img-box {
		width: 400px;
		height: auto;
		position: absolute;
		left: 50%;
		right: 50%;
		transform: translateX(-50%);
	}

	.dialog-bg .img-box img {
		width: 100%;
		height: 100%;
	}
</style>
<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//hostNo
		op = "<%=op%>";
		
		getComboBoxList("statusEffect","status",0);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		$("#btnSave").linkbutton({
			iconCls:'icon-save',
			width:70,
			height:25,
			text:'保存',
			onClick:function() {
				saveNode();
			}
		});

		$("#btnSignature").click(function(){
			showSignatureInfo("host_letter_signature",nodeID,0,1,"getNodeInfo(reDo)");
		});

		//无论点击哪一个img弹出层都会展示相应的图片。
		$("#img").click(function () {
			var src = $("#img").attr("src");//获取当前点击img的src的值
			$("#img-box").attr("src", src);//将获取的当前点击img的src赋值到弹出层的图片的src
			$("#dialog-bg").show();//弹出层显示
		});
		$("#imgRegister").click(function () {
			var src = $("#imgRegister").attr("src");//获取当前点击img的src的值
			$("#img-box").attr("src", src);//将获取的当前点击img的src赋值到弹出层的图片的src
			$("#dialog-bg").show();//弹出层显示
		});

		//弹出层隐藏
		$("#dialog-bg").click(function () {
			$(this).hide();//
		});

		if(op==1){
			setButton();
		}
		if(op==0){
			getNodeInfo(nodeID);
		}
	});

	function getNodeInfo(id){
		$.get("hostControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#hostID").val(ar[0]);
				$("#hostNo").textbox("setValue",ar[1]);
				$("#hostName").textbox("setValue",ar[2]);
				$("#title").textbox("setValue",ar[3]);
				$("#status").combobox("setValue",ar[4]);
				$("#linker").textbox("setValue",ar[6]);
				$("#phone").textbox("setValue",ar[7]);
				$("#email").textbox("setValue",ar[8]);
				$("#address").textbox("setValue",ar[9]);
				$("#memo").textbox("setValue",ar[13]);
				$("#regDate").textbox("setValue",ar[14]);
				$("#registerName").textbox("setValue",ar[16]);
				if(ar[12] > ""){
					$("#signature").html("<img src='users" + ar[12] + "?times=" + (new Date().getTime()) + "' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);' />");
				}else{
					$("#signature").html("尚未签名");
				}
				let text = uploadURL + "/public/get_qr_img?size=10&text=" + encodeURIComponent("<%=mobile_url%>/#/login?host=" + currHost + "&sales=&partner=");
				$("#img").prop("src", text);
				// text = uploadURL + "/public/get_qr_img?size=10&text=" + encodeURIComponent("<%=mobile_url%>/#/login?register=" + (new Date().format("yyyy-MM-dd")));
				// $("#imgRegister").prop("src", text);
				setButton();
			}else{
				$.messager.alert("提示","该信息未找到！","warning");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		$.messager.progress();	// 显示进度条
		$('#forms').form('submit', {   
			url: "hostControl.asp?op=update&times=" + (new Date().getTime()),   
			onSubmit: function(){   
				//var isValid = $(this).form('validate');
				var isValid = true;
				if($("#hostName").textbox("getValue")=="" || $("#title").textbox("getValue")==""){
					$.messager.alert("提示","学校名称或简称不能为空","warning");
					isValid = false;
				}
				if($("#hostNo").textbox("getValue")==0){
					$.messager.alert("提示","学校代码不能为空","warning");
					isValid = false;
				}
				if (!isValid){
					$.messager.progress('close');	// 如果表单是无效的则隐藏进度条
				}
				return isValid;	// 返回false终止表单提交
			},   
			success:function(data){  
				// $.messager.alert("提示",unescape(data));
				if(data>0){
					$.messager.alert("提示","保存成功！","info");
					updateCount += 1;
					op = 0;
					getNodeInfo(nodeID);
					$.messager.progress('close');	// 如果提交成功则隐藏进度条 
				}else{
					$.messager.alert("提示","提交失败。","warning");
				}
			}   
		});
	}
	
	function setButton(){
		$("#btnSave").hide();
		$("#registerItem").hide();
		if(checkPermission("hostEdit")){
			$("#btnSave").show();
		}
		if(op ==1){
			setEmpty();
		}
	}
	
	function setEmpty(){
		nodeID = "";
		$("#hostID").val(0);
		$("#hosNo").textbox("setValue","");
		$("#hostName").textbox("setValue","");
		$("#status").combobox("setValue",0);
		$("#linker").textbox("setValue","");
		$("#phone").textbox("setValue","");
		$("#email").textbox("setValue","");
		$("#address").textbox("setValue","");
		$("#memo").textbox("setValue","");
		$("#regDate").textbox("setValue",currDate);
		$("#registerName").textbox("setValue",currUserName);
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="forms" method="post" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
				<tr>
					<td align="right">学校名称</td><input id="hostID" name="hostID" type="hidden" />
					<td><input id="hostName" name="hostName" class="easyui-textbox" data-options="height:22,width:195,required:true" /></td>
					<td align="right">简称</td>
					<td><input id="title" name="title" class="easyui-textbox" data-options="height:22,width:195,required:true" /></td>
				</tr>
				<tr>
					<td align="right">学校编码</td>
					<td><input id="hostNo" name="hostNo" class="easyui-textbox" data-options="height:22,width:195,required:true,readonly:true" /></td>
					<td align="right">联系人</td>
					<td><input id="linker" name="linker" class="easyui-textbox" data-options="height:22,width:195" /></td>
				</tr>
				<tr>
					<td align="right">地址</td>
					<td colspan="3"><input id="address" name="address" class="easyui-textbox" data-options="height:22,width:435" /></td>
				</tr>
				<tr>
					<td align="right">电话</td>
					<td><input id="phone" name="phone" class="easyui-textbox" data-options="height:22,width:195" /></td>
					<td align="right">邮箱</td>
					<td><input id="email" name="email" class="easyui-textbox" data-options="height:22,width:195" /></td>
				</tr>
				<tr>
					<td align="right"><input class="button" type="button" id="btnSignature" value="签名" /></td>
					<td><span id="signature"></span></td>
					<td align="left" colspan="2">
						<div class="img-list-box;">
							<div class="img-select">
								<div style="vertical-align:middle;text-align:center;">
									<span style="padding-left:10px;">登录</span>
									<span><img id="img" src="" /></span>
									<span id="registerItem" style="padding-left:10px;">叉车签到</span>
									<span><img id="imgRegister" src="" /></span>
								</div>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>状态</td>
					<td><select id="status" name="status" class="easyui-combobox" data-options="height:22,editable:false,panelHeight:'auto',width:195"></select></td>
					<td align="right">备注</td>
					<td><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:195" /></td>
				</tr>
				<tr>
					<td align="right">登记日期</td>
					<td><input id="regDate" name="regDate" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
					<td align="right">登记人</td><input type="hidden" id="registerID" />
					<td><input id="registerName" name="registerName" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
				</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
			<div style="width:100%;float:left;margin:10;height:4px;"></div>
			<div class="buttonbox">
				<a class="easyui-linkbutton" id="btnSave" href="javascript:void(0)"></a>
			</div>
			<div style="width:100%;float:left;margin:10;height:4px;"></div>
  </div>

	<div class="dialog-bg" id="dialog-bg">
    <div class="img-box">
        <img id="img-box" src="">
    </div>

</div>
</body>
