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
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
	<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
	<script language="javascript" src="js/jquery.form.js"></script>

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
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
		
		$("#btnDel").linkbutton({
			iconCls:'icon-cancel',
			width:70,
			height:25,
			text:'删除',
			onClick:function() {
				$.messager.confirm("确认","确定要删除该机构吗？",function(r){
					if(r){
						$.messager.prompt('信息记录', '请填写删除原因:', function(r){
							if (r.length > 1){
								$.get("agencyControl.asp?op=delNode&nodeID=" + $("#ID").val() + "&item=" + escape(r) + "&times=" + (new Date().getTime()),function(re){
									updateCount += 1;
									op = 1;
									setButton();
									$.messager.alert("提示","删除成功。");
								});
							}else{
								$.messager.alert("提示","请认真填写删除原因。");
							}
						});
					}
				});
			}
		});
		
		if(op==0){
			getNodeInfo(nodeID);
		}else{
			setButton();
		}
	});

	function getNodeInfo(id){
		$.get("agencyControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#agencyID").textbox("setValue",ar[1]);
				$("#agencyName").textbox("setValue",ar[2]);
				$("#title").textbox("setValue",ar[3]);
				$("#status").combobox("setValue",ar[5]);
				$("#linker").textbox("setValue",ar[8]);
				$("#phone").textbox("setValue",ar[9]);
				$("#email").textbox("setValue",ar[10]);
				$("#address").textbox("setValue",ar[11]);
				$("#memo").textbox("setValue",ar[12]);
				$("#regDate").textbox("setValue",ar[13]);
				$("#registerName").textbox("setValue",ar[15]);
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
			url: "agencyControl.asp?op=update&times=" + (new Date().getTime()),   
			onSubmit: function(){   
				//var isValid = $(this).form('validate');
				var isValid = true;
				if($("#agencyName").textbox("getValue")==""){
					$.messager.alert("提示","请填单位名称。","warning");
					isValid = false;
				}
				if($("#title").textbox("getValue")==0){
					$.messager.alert("提示","请填写简称。","warning");
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
					nodeID = data;
					op = 0;
					getNodeInfo(data);
					$.messager.progress('close');	// 如果提交成功则隐藏进度条 
				}else{
					$.messager.alert("提示","提交失败。","warning");
				}
			}   
		});
	}
	
	function setButton(){
		$("#btnSave").hide();
		$("#btnDel").hide();
		if(checkPermission("agencyAdd")){
			$("#btnSave").show();
			$("#btnDel").show();
		}
		if(op ==1){
			setEmpty();
			$("#btnDel").hide();
		}
	}
	
	function setEmpty(){
		nodeID = 0;
		$("#agencyID").textbox("setValue","");
		$("#ID").val(0);
		$("#agencyName").textbox("setValue","");
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
					<td align="right">机构名称</td><input id="ID" name="ID" type="hidden" />
					<td><input id="agencyName" name="agencyName" class="easyui-textbox" data-options="height:22,width:195,required:true" /></td>
					<td align="right">简称</td>
					<td><input id="title" name="title" class="easyui-textbox" data-options="height:22,width:195,required:true" /></td>
				</tr>
				<tr>
					<td align="right">编号</td>
					<td><input id="agencyID" name="agencyID" class="easyui-textbox" data-options="height:22,width:195,required:true" /></td>
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
				<a class="easyui-linkbutton" id="btnDel" href="javascript:void(0)"></a>
			</div>
			<div style="width:100%;float:left;margin:10;height:4px;"></div>
  </div>
</div>
</body>
