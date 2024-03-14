<!--#include file="js/doc1.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>实训报到</title>
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

	var backendURL = "<%=backendURL%>";
	var uploadURL = "<%=uploadURL%>";
    var rest = 0;
	var certID = "";
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
 		
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

		getNodeInfo(nodeID);
	});

	function getNodeInfo(id){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#enterID").val(id);
				$("#username").textbox("setValue",ar[1]);
				$("#name").textbox("setValue",ar[8]);
				$("#cards").textbox("setValue",ar[60]);
				$("#cardsRest").textbox("setValue",ar[61]);
				$("#courseName").textbox("setValue",ar[87]);
            	rest = ar[61];
				certID = ar[32];
				getComboList("teacherID","v_courseTeacherList","teacherID","teacherName","status=0 and host='" + currHost + "' and courseID='" + certID + "' order by teacherID",0);

			}else{
				$.messager.alert("提示","该信息未找到！");
			}
		});
	}
	
	function saveNode(){
		$.messager.progress();	// 显示进度条
		$('#forms').form('submit', {   
			url: "studentCourseControl.asp?op=checkin&times=" + (new Date().getTime()),   
			onSubmit: function(){   
				//var isValid = $(this).form('validate');
				var isValid = true;
				if($("#teacherID").combobox("getValue")==""){
					$.messager.alert("提示","请选择实训教师。","warning");
					isValid = false;
				}
				if($("#cardsRest").textbox("getValue")==0){
					$.messager.alert("提示","剩余次数不足。","warning");
					isValid = false;
				}
				if (!isValid){
					$.messager.progress('close');	// 如果表单是无效的则隐藏进度条
				}
				return isValid;	// 返回false终止表单提交
			},   
			success:function(data){  
				//$.messager.alert("提示",unescape(data));
				if(data==0){
					$.messager.alert("提示","报名成功。","info");
					$.messager.progress('close');	// 如果提交成功则隐藏进度条 
					$("#btnSave").hide();
               		$("#cardsRest").textbox("setValue",rest-1);
				}else{
					$.messager.alert("提示","提交失败。","warning");
				}
			}   
		});
	}

</script>
</head>

<body>
<div id="layout">
   <div style="height:100%;">
		<div class="comm" style="background:#f5faf8;">
			<form id="forms" method="post" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
				<table>
					<tr><input type="hidden" id="enterID" name="enterID" />
						<td align="right">课程名称</td>
						<td colspan="3"><input id="courseName" name="courseName" class="easyui-textbox" data-options="height:22,width:195,readonly:true" /></td>
					</tr>
					<tr>
						<td align="right">姓名</td>
						<td><input id="name" name="name" class="easyui-textbox" data-options="height:22,width:100,readonly:true" /></td>
						<td align="right">身份证号</td>
						<td><input id="username" name="username" class="easyui-textbox" data-options="height:22,width:100,readonly:true" /></td>
					</tr>
					<tr>
						<td align="right">实训额度</td>
						<td><input id="cards" name="cards" class="easyui-textbox" data-options="height:22,width:100,readonly:true" /></td>
						<td align="right">剩余次数</td>
						<td><input id="cardsRest" name="cardsRest" class="easyui-textbox" data-options="height:22,width:100,readonly:true" /></td>
					</tr>
					<tr>
						<td align="right">实训教师</td>
						<td><select id="teacherID" name="teacherID" class="easyui-combobox" data-options="editable:false,panelHeight:'auto',height:22,width:100"></select></td>
						<td align="right">备注</td>
						<td><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:100" /></td>
					</tr>
				</table>
			</form>
		</div>      
    </div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div class="buttonbox">
		<a class="easyui-linkbutton" id="btnSave" href="javascript:void(0)"></a>
	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
</div>

</body>
</html>
