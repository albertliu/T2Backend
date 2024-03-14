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
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.19">
	<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
	<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
	<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
	<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
	<script language="javascript" src="js/jquery.form.js"></script>
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
		nodeID = "<%=nodeID%>";	//ID
		op = <%=op%>;
		$.ajaxSetup({ 
			async: false 
		}); 
		
		getComboBoxList("statusEffect","status",0);

		$("#btnSave").linkbutton({
			iconCls:'icon-save',
			width:70,
			height:25,
			text:'保存',
			onClick:function() {
				saveNode();
			}
		});
		
		$("#partnerID").textbox({
			onChange: function(val){
				if(op==1){
					nodeID = $("#partnerID").textbox("getValue");
					if(nodeID>""){
						$("#partnerID").textbox("initValue",nodeID.toUpperCase());
						$.get("hostControl.asp?op=partnerExist&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
							if(re>0){
								$("#partnerID").textbox("setValue", "");
								$.messager.alert("提示","该编码已被使用，请重新输入。","warning");
								return false;
							}
						});
					}
				}
			}
		});

		//无论点击哪一个img弹出层都会展示相应的图片。
		$("#img").click(function () {
			var src = $("#img").attr("src");//获取当前点击img的src的值
			$("#img-box").attr("src", src);//将获取的当前点击img的src赋值到弹出层的图片的src
			$("#dialog-bg").show();//弹出层显示
		});

		//弹出层隐藏
		$("#dialog-bg").click(function () {
			$(this).hide();//
		});
		
		if(op==1){
			setButton();
		}else{
			getNodeInfo(nodeID);
		}

	});

	function getNodeInfo(id){
		// alert(id);
		$.get("hostControl.asp?op=getPartnerNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#partnerName").textbox("setValue",ar[1]);
				$("#title").textbox("setValue",ar[2]);
				$("#status").combobox("setValue", ar[3]);
				$("#memo").textbox("setValue",ar[5]);
				$("#regDate").textbox("setValue",ar[6]);
				$("#registerName").textbox("setValue",ar[7]);
				$("#partnerID").textbox("setValue",ar[8]);
				nodeID = ar[8];
				let text = uploadURL + "/public/get_qr_img?size=10&text=" + encodeURIComponent("<%=mobile_url%>/#/login?host=&sales=&partner=" + nodeID);
				$("#img").prop("src", text);
			}else{
				$.messager.alert("提示","该信息未找到！");
				setEmpty();
			}
			setButton();
		});
	}
	
	function saveNode(){
		$('#forms').form('submit', {   
			url: "hostControl.asp?op=updatePartnerInfo&times=" + (new Date().getTime()),   
			onSubmit: function(){   
				//var isValid = $(this).form('validate');
				var isValid = true;
				if($("#partnerID").textbox("getValue")==""){
					$.messager.alert("提示","请填写编码。","warning");
					isValid = false;
				}
				if($("#title").textbox("getValue")==""){
					$.messager.alert("提示","请填写简称。","warning");
					isValid = false;
				}
				if($("#partnerName").textbox("getValue")==0){
					$.messager.alert("提示","请填写部门名称。","warning");
					isValid = false;
				}
				if (!isValid){
					$.messager.progress('close');	// 如果表单是无效的则隐藏进度条
				}
				return isValid;	// 返回false终止表单提交
			},   
			success:function(data){  
				// $.messager.alert("提示",unescape(data));
				// if(data>0){
					$.messager.alert("提示","保存成功！","info");
					updateCount += 1;
					op = 0;
					getNodeInfo(nodeID);
				// }else{
				// 	$.messager.alert("提示","提交失败。","warning");
				// }
			}   
		});
	}
	
	function setButton(){
		$("#btnSave").hide();
		if(op == 0){
			if(checkPermission("userAdd")){
				$("#btnSave").show();
			}
			$("#partnerID").textbox("disable");
		}
		if(op == 1){
			setEmpty();
			$("#btnSave").show();
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#partnerName").textbox("setValue","");
		$("#title").textbox("setValue","");
		$("#memo").textbox("setValue","");
		$("#status").combobox("setValue",0);
		$("#regDate").textbox("setValue",currDate);
		$("#registerName").textbox("setValue",currUserName);
		$("#partnerID").textbox("setValue","");
	}
	
	function getUpdateCount(){
		return updateCount;
	}

</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div style="width:98%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form id="forms" method="post" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
					<table border="0" cellpadding="0" cellspacing="0" width="98%" style="line-height:10px;">
						<tr><input id="ID" name="ID" type="hidden" />
							<td align="right">编码</td>
							<td><input id="partnerID" name="partnerID" class="easyui-textbox" data-options="height:22,width:100,required:true" /></td>
							<td align="right">名称</td>
							<td><input id="partnerName" name="partnerName" class="easyui-textbox" data-options="height:22,width:195,required:true" /></td>
						</tr>
						<tr>
							<td align="right">简称</td>
							<td><input id="title" name="title" class="easyui-textbox" data-options="height:22,width:100,required:true" /></td>
							<td align="right">备注</td>
							<td><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:195" /></td>
						</tr>
						<tr>
							<td align="right" colspan="4">
								<div class="img-list-box;">
									<div class="img-select">
										<div style="vertical-align:middle;text-align:center;">
											<span style="padding-left:10px;">登录</span>
											<span><img id="img" src="" /></span>
										</div>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td align="right">状态</td>
							<td><select id="status" name="status" class="easyui-combobox" data-options="height:22,editable:false,panelHeight:'auto',width:100"></select></td>
							<td align="right">登记人</td>
							<td>
								<input id="registerName" name="registerName" class="easyui-textbox" data-options="height:22,width:80,readonly:true" />
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="regDate" name="regDate" class="easyui-textbox" data-options="height:22,width:95,readonly:true" />
							</td>
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
	<div class="dialog-bg" id="dialog-bg">
    <div class="img-box">
        <img id="img-box" src="">
    </div>
</div>
</body>
