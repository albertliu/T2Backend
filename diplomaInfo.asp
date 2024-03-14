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
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.18">
	<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
	<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
	<script src="js/jquery.alerts.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>

<script language="javascript">
	var nodeID = "";
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		setButton();
		
		getNodeInfo(nodeID);

		$("#btnSave").linkbutton({
			iconCls:'icon-save',
			width:85,
			height:25,
			text:'保存备注',
			onClick:function() {
				saveNode();
			}
		});

		$("#btnCancel").linkbutton({
			iconCls:'icon-clear',
			width:70,
			height:25,
			text:'作废',
			onClick:function() {
				jConfirm("确定要将该证书作废吗？作废后不可恢复。","确认",function(r){
					if(r){
						$.get("diplomaControl.asp?op=cancelDiploma&nodeID=" + $("#diplomaID").val() + "&times=" + (new Date().getTime()),function(re){
							jAlert("操作成功！","信息提示");
							updateCount += 1;
						});
					}
				});
			}
		});
	});

	function getNodeInfo(id){
		$.get("diplomaControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#username").textbox("setValue", ar[1]);
				$("#name").textbox("setValue", ar[2]);
				$("#statusName").textbox("setValue", ar[4]);
				$("#certName").textbox("setValue", ar[6]);
				$("#diplomaID").textbox("setValue", ar[7]);
				$("#sexName").textbox("setValue", ar[8]);
				$("#age").textbox("setValue", ar[9]);
				$("#mobile").textbox("setValue", ar[10]);
				$("#unit").textbox("setValue", ar[13]);
				$("#startDate").textbox("setValue", ar[14]);
				$("#endDate").textbox("setValue", ar[15]);
				$("#term").textbox("setValue", ar[16] + '年');
				$("#memo").textbox("setValue", ar[17]);
				$("#agencyName").textbox("setValue", ar[18]);
				c = "";
				if(ar[22] > ""){
					c += "&nbsp;&nbsp;<a href='/users" + ar[22] + "' target='_blank' style='text-decoration:none;color:green;'>电子证书</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;还未上传";}
				$("#photo").html(c);
				//getDownloadFile("diplomaID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#memo").textbox("getValue").length < 3){
			jAlert("备注信息请至少填写3个字的内容。");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("diplomaControl.asp?op=setMemo&nodeID=" + $("#diplomaID").textbox("getValue") + "&item=" + escape($("#memo").textbox("getValue")) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功！","信息提示");
				updateCount += 1;
			}
		});
		return false;
	}
	
	function setButton(){
		if(!checkPermission("diplomaAdd")){
			$("#btnSave").hide();
		}
		if(!checkPermission("diplomaCancel")){
			$("#btnCancel").hide();
		}
	}
	
	function setEmpty(){
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
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right">证书名称</td><input type="hidden" id="ID" />
				<td><input id="certName" name="certName" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
				<td align="right">证书编号</td>
				<td><input id="diplomaID" name="diplomaID" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
			</tr>
			<tr>
				<td align="right">有效期限</td>
				<td>
					<input id="startDate" name="startDate" class="easyui-textbox" data-options="height:22,width:90,readonly:true" />
					&nbsp;<input id="endDate" name="endDate" class="easyui-textbox" data-options="height:22,width:90,readonly:true" />
				</td>
				<td align="right">期限</td>
				<td>
					<input id="term" name="term" class="easyui-textbox" data-options="height:22,width:50,readonly:true" />
					&nbsp;&nbsp;&nbsp;&nbsp;状态&nbsp;<input id="statusName" name="statusName" class="easyui-textbox" data-options="height:22,width:100,readonly:true" />
				</td>
			</tr>
			<tr>
				<td align="right">发证机构</td>
				<td colspan="3">
					<input id="agencyName" name="agencyName" class="easyui-textbox" data-options="height:22,width:295,readonly:true" />
					&nbsp;&nbsp;&nbsp;&nbsp;领取日期&nbsp;<input id="issueDate" name="issueDate" class="easyui-textbox" data-options="height:22,width:100,readonly:true" />
				</td>
			</tr>
			<tr>
				<td align="right">姓名</td>
				<td><input id="name" name="name" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
				<td align="right">身份证</td>
				<td><input id="username" name="username" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
			</tr>
			<tr>
				<td align="right">性别</td>
				<td>
					<input id="sexName" name="sexName" class="easyui-textbox" data-options="height:22,width:80,readonly:true" />
					&nbsp;&nbsp;&nbsp;&nbsp;年龄&nbsp;<input id="age" name="age" class="easyui-textbox" data-options="height:22,width:70,readonly:true" />
				</td>
				<td align="right">手机</td>
				<td><input id="mobile" name="mobile" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
			</tr>
			<tr>
				<td align="right">公司</td>
				<td colspan="3"><input id="unit" name="unit" class="easyui-textbox" data-options="height:22,width:480" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="3"><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:480" /></td>
			</tr>
			<tr>
				<td align="right">文件</td>
				<td colspan="3">
					<span id="photo" style="margin-left:10px;"></span>
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
		<a class="easyui-linkbutton" id="btnCancel" href="javascript:void(0)"></a>
  	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  </div>
</div>
</body>
