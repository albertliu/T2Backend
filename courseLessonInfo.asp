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

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";	//courseID
		op = "<%=op%>";
		
		getComboBoxList("statusEffect","status",0);
		getComboList("lessonID","lessonInfo","lessonID","lessonName","status=0 order by ID",1);
		
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
			iconCls:'icon-remove',
			width:70,
			height:25,
			text:'移除',
			onClick:function() {
				jConfirm('你确定要删除这个课节吗?', '确认对话框', function(r) {
					if(r){
						$.get("lessonControl.asp?op=delCourseLessonNode&nodeID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(data){
							jAlert("删除成功！","信息提示");
							op = 1;
							setButton();
							updateCount += 1;
						});
					}
				});
			}
		});
		
		if(op==1){
			setButton();
		}else{
			getNodeInfo(nodeID);
		}
	});

	function getNodeInfo(id){
		$.get("lessonControl.asp?op=getCourseLessonNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#courseID").val(ar[1]);
				$("#lessonID").combobox("setValue", ar[2]);
				$("#status").combobox("setValue", ar[4]);
				$("#seq").textbox("setValue", ar[6]);
				$("#hours").textbox("setValue", ar[7]);
				$("#memo").textbox("setValue", ar[8]);
				$("#regDate").textbox("setValue", ar[9]);
				$("#registerName").textbox("setValue", ar[11]);
				
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		//alert($("#lessonID").val() + "&item=" + ($("#memo").val()));
		if($("#lessonID").combobox("getValue")==""){
			$.messager.alert("提示","课节不能为空。","warning");
			return false;
		}
		$.get("lessonControl.asp?op=updateCourseLessonList&nodeID=" + $("#ID").val() + "&courseID=" + $("#courseID").val() + "&lessonID=" + $("#lessonID").combobox("getValue") + "&hours=" + $("#hours").textbox("getValue") + "&seq=" + $("#seq").textbox("getValue") + "&status=" + $("#status").combobox("getValue") + "&memo=" + escape($("#memo").textbox("getValue")) + "&times=" + (new Date().getTime()),function(re){
			if(re > 0){
				if(op == 1){
					op = 0;
				}
				getNodeInfo(re);
				jAlert("保存成功！","信息提示");
				updateCount += 1;
			}else{
				jAlert("操作失败。","信息提示");
			}
		});
		//return false;
	}
	
	function setButton(){
		$("#btnSave").hide();
		$("#btnDel").hide();
		if(op ==1){
			setEmpty();
		}
		if(checkPermission("courseAdd")){
			$("#btnSave").show();
			if(op==0){
				$("#btnDel").show();
			}
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#courseID").val(refID);
		$("#lessonID").textbox("setValue", "");
		$("#lessonName").textbox("setValue", "");
		$("#memo").textbox("setValue", "");
		$("#status").combobox("setValue", 0);
		$("#regDate").textbox("setValue", currDate);
		$("#registerName").textbox("setValue", currUserName);
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
				<td align="right" style="width:70px;">序号</td><input id="ID" type="hidden" /><input id="courseID" type="hidden" />
				<td><input id="seq" name="seq" class="easyui-textbox" data-options="height:22,width:100,required:true"></td>
				<td align="right" style="width:70px;">课节名称</td>
				<td><select id="lessonID" name="lessonID" class="easyui-combobox" data-options="panelHeight:'auto',height:22,width:260"></select></td>
			</tr>
			<tr>
				<td align="right">状态</td>
				<td><select id="status" name="status" class="easyui-combobox" data-options="panelHeight:'auto',height:22,width:100"></select></td>
				<td align="right">课时</td>
				<td><input id="hours" name="hours" class="easyui-textbox" data-options="height:22,width:100" />&nbsp;小时</td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="3"><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:420" /></td>
			</tr>
			<tr>
				<td align="right">登记日期</td>
				<td><input id="regDate" name="regDate" class="easyui-textbox" data-options="height:22,width:100,readonly:true" /></td>
				<td align="right">登记人</td>
				<td><input id="registerName" name="registerName" class="easyui-textbox" data-options="height:22,width:100,readonly:true" /></td>
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
</body>
