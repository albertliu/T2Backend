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
			iconCls:'icon-cancel',
			width:85,
			height:25,
			text:'拒绝申请',
			onClick:function() {
				var s = "你确定要暂时拒绝这个证书申请吗? 请在备注中填写拒绝原因。";
				var k = 0;
				if($("#diplomaID").val()=="*"){
					k = 1;
					s = "你确定要恢复这个证书申请吗? ";
				}
				jConfirm(s, '确认对话框', function(r) {
					if(r){
						if(k==0 && $("#memo").textbox("getValue").length < 1){
							jAlert("请在备注中填写拒绝原因。");
							return false;
						}
						$.get("diplomaControl.asp?op=setNeedDiplomaCancel&nodeID=" + $("#ID").val() + "&item=" + escape($("#memo").textbox("getValue")) + "&kindID=" + k + "&times=" + (new Date().getTime()),function(data){
							jAlert("操作成功！","信息提示");
							getNodeInfo(nodeID);
							updateCount += 1;
						});
					}
				});
			}
		});
		
		getNodeInfo(nodeID);
	});

	function getNodeInfo(id){
		$.get("diplomaControl.asp?op=getNeedDiplomaNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#username").textbox("setValue",ar[1]);
				$("#name").textbox("setValue",ar[2]);
				$("#certName").textbox("setValue",ar[4]);
				$("#unit").textbox("setValue",ar[8]);
				$("#diplomaID").val(ar[9]);
				$("#job").textbox("setValue",ar[10]);
				$("#educationName").textbox("setValue",ar[12]);
				$("#mobile").textbox("setValue",ar[14]);
				$("#memo").textbox("setValue",ar[15]);
				//getDownloadFile("studentNeedDiplomaID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#memo").val().length < 1){
			jAlert("请输入备注信息。");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("diplomaControl.asp?op=setNeedDiplomaMemo&nodeID=" + $("#ID").val() + "&item=" + escape($("#memo").textbox("getValue")) + "&times=" + (new Date().getTime()),function(re){
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
		var c = $("#diplomaID").val();
		if(c == ""){
			$("#btnCancel").linkbutton({text: '拒绝申请'});
		}
		if(c == "*"){
			$("#btnCancel").linkbutton({text:'恢复申请'});
		}
		if(!checkPermission("diplomaAdd")){
			$("#btnCancel").hide();
			$("#btnSave").hide();
		}
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
					<td align="right">姓名</td><input type="hidden" id="ID" /><input type="hidden" id="diplomaID" />
					<td><input id="name" name="name" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
					<td align="right">身份证</td>
					<td><input id="username" name="username" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
				</tr>
				<tr>
					<td align="right">单位名称</td>
					<td colspan="3"><input id="unit" name="unit" class="easyui-textbox" data-options="height:22,width:450,readonly:true" /></td>
				</tr>
				<tr>
					<td align="right">工种</td>
					<td>
						<input id="job" name="job" class="easyui-textbox" data-options="height:22,width:80,readonly:true" />
						&nbsp;&nbsp;学历&nbsp;<input id="educationName" name="educationName" class="easyui-textbox" data-options="height:22,width:80,readonly:true" />
					</td>
					<td align="right">手机</td>
					<td><input id="mobile" name="mobile" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
				</tr>
				<tr>
					<td align="right">证书</td>
					<td><input id="certName" name="certName" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
					<td align="right">结束日期</td>
					<td><input id="endDate" name="endDate" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
				</tr>
				<tr>
					<td align="right">备注</td>
					<td colspan="3"><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:450" /></td>
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
</body>
