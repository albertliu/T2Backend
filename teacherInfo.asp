<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title>教师信息</title>

	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />  
	<meta name="format-detection" content="telephone=no" />  
	<meta name="apple-mobile-web-app-capable" content="yes" />  
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
	<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
	<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.11">
	<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
	<script language="javascript" src="js/jquery.form.js"></script>
	<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
	<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var updateCount = 0;
	var refID = "";		
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//ID
		refID = "<%=refID%>";	//teacherID
		op = <%=op%>;
		$.ajaxSetup({ 
			async: false 
		}); 
		
		getComboBoxList("userStatus","status",0);

		$("#btnSave").linkbutton({
			iconCls:'icon-save',
			width:70,
			height:25,
			text:'保存',
			onClick:function() {
				saveNode();
			}
		});

		$("#teacherID").textbox({
			onChange:function() {
				if(op==1 && $("#teacherID").textbox("getValue")>""){
					checkExistKeyInTab("teacherID","teacherInfo","teacherID",$("#teacherID").textbox("getValue"));
				}
			}
		});
		
		if(op==1){
			setButton();
		}else{
			getNodeInfo(nodeID);
		}

	});

	function getNodeInfo(id){
		//alert(id);
		$.get("userControl.asp?op=getTeacherInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#teacherID").textbox("setValue",ar[1]);
				$("#teacherName").textbox("setValue",ar[2]);
				$("#status").combobox("setValue", ar[3]);
				$("#memo").textbox("setValue",ar[7]);
				$("#regDate").textbox("setValue",ar[8]);
				$("#registerName").textbox("setValue",ar[10]);
				getTeacherCourseList();
				getCourseListByTeacher();
			}else{
				$.messager.alert("提示","该信息未找到！");
				setEmpty();
			}
			op = 0;
			setButton();
		});
	}
	
	function saveNode(){
		$.messager.progress();	// 显示进度条
		$('#forms').form('submit', {   
			url: "userControl.asp?op=updateTeacherInfo&times=" + (new Date().getTime()),   
			onSubmit: function(){   
				//var isValid = $(this).form('validate');
				var isValid = true;
				if($("#teacherID").textbox("getValue")==""){
					$.messager.alert("提示","请填写教师编号。","warning");
					isValid = false;
				}
				if($("#teacherName").textbox("getValue")==0){
					$.messager.alert("提示","请填写教师姓名。","warning");
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
		if(op == 0){
			if(checkPermission("teacherAdd")){
				$("#btnSave").show();
				$("#teacherID").textbox("readonly",true);
			}
		}
		if(op == 1){
			setEmpty();
			$("#btnSave").show();
			$("#teacherID").textbox("readonly",false);
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#teacherID").textbox("setValue","");
		$("#status").combobox("setValue",0);
		$("#regDate").textbox("setValue",currDate);
		$("#registerName").textbox("setValue",currUserName);
		$("#userListCover").empty();
		$("#taskUserCover").empty();
	}
	
	function getUpdateCount(){
		return updateCount;
	}

	function getTeacherCourseList(){
		//alert($("#teacherID").val());
		$.get("userControl.asp?op=getTeacherCourseList&refID=" + $("#teacherID").textbox("getValue") + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//alert(ar);
			$("#userListCover").empty();
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='userListTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='10%'>No</th>");
			arr.push("<th width='40%'>课程</th>");
			arr.push("<th width='10%'>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='10%' class='left'>" + i + "</td>");
					arr.push("<td width='40%' class='left'>" + ar1[1] + "</td>");
					if(checkPermission("teacherAdd")){
						arr.push("<td width='10%' class='link1'><a href='javascript:doAddUser(\"" + ar1[0] + "\");'><img src='images/add.png' border='0' title='添加'></a></td>");
					}else{
						arr.push("<td width='10%' class='link1'>&nbsp;</td>");
					}
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#userListCover").html(arr.join(""));
			arr = [];
			$('#userListTab').dataTable({
				"aaSorting": [],
				"bLengthChange": false,
				"aLengthMenu": [15, 25, 30, 50],
				"iDisplayLength": 50,
				"bFilter": false,
				"aoColumnDefs": []
			});
		});
	}
	
	function getCourseListByTeacher(){
		$.get("userControl.asp?op=getCourseListByTeacher&refID=" + $("#teacherID").textbox("getValue") + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//alert(ar);
			$("#taskUserCover").empty();
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='taskUserTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='10%'>No</th>");
			arr.push("<th width='40%'>课程</th>");
			arr.push("<th width='10%'>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='10%' class='left'>" + i + "</td>");
					arr.push("<td width='40%' class='left'>" + ar1[2] + "</td>");
					if(checkPermission("teacherAdd")){
						arr.push("<td width='10%' class='link1'><a href='javascript:doRemoveUser(\"" + ar1[0] + "\");'><img src='images/remove.png' border='0' title='撤销'></a></td>");
					}else{
						arr.push("<td width='10%' class='link1'>&nbsp;</td>");
					}
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#taskUserCover").html(arr.join(""));
			arr = [];
			$('#taskUserTab').dataTable({
				"aaSorting": [],
				"bLengthChange": false,
				"aLengthMenu": [15, 25, 30, 50],
				"iDisplayLength": 50,
				"bFilter": false,
				"aoColumnDefs": []
			});
		});
	}

	function doAddUser(user){
		$.get("userControl.asp?op=addCourse2Teacher&refID=" + $("#teacherID").textbox("getValue") + "&nodeID=" + user + "&times=" + (new Date().getTime()),function(re){
			if(re==0){
				getTeacherCourseList();
				getCourseListByTeacher();
				$.messager.alert("提示","添加成功。");
			}
		});
	}

	function doRemoveUser(nodeID){
		$.messager.confirm("确认对话框","确实要退出该课程吗？",function(r){
			if(r){
				$.get("userControl.asp?op=removeCourse4Teacher&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
					if(re>""){
						getTeacherCourseList();
						getCourseListByTeacher();
						// $.messager.alert("提示","删除成功。");
					}
				});
			}
		});
	}

</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<table border='0' cellpadding='0' cellspacing='0' valign='top' width = '99%'>
		<tr>
	   	<td valign='top'>
			<div style="width:98%;float:left;margin:0;">
				<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
					<div class="comm" style="background:#f5faf8;">
						<form id="forms" method="post" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
							<table border="0" cellpadding="0" cellspacing="0" width="98%" style="line-height:10px;">
								<tr><input id="ID" name="ID" type="hidden" />
									<td align="right">编号</td>
									<td><input id="teacherID" name="teacherID" class="easyui-textbox" data-options="height:22,width:120,required:true" /></td>
									<td align="right">姓名</td>
									<td><input id="teacherName" name="teacherName" class="easyui-textbox" data-options="height:22,width:120,required:true" /></td>
								</tr>
								<tr>
									<td align="right">状态</td>
									<td><select id="status" name="status" class="easyui-combobox" data-options="height:22,editable:false,panelHeight:'auto',width:120"></select></td>
									<td align="right">身份证号</td>
									<td><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:120" /></td>
								</tr>
								<tr>
									<td align="right">登记日期</td>
									<td><input id="regDate" name="regDate" class="easyui-textbox" data-options="height:22,width:120,readonly:true" /></td>
									<td align="right">登记人</td><input type="hidden" id="registerID" />
									<td><input id="registerName" name="registerName" class="easyui-textbox" data-options="height:22,width:120,readonly:true" /></td>
								</tr>
							</table>
						</form>
					</div>
				</div>
			</div>
			<div style="width:120%;float:left;margin:10;height:4px;"></div>
			<div class="buttonbox">
				<a class="easyui-linkbutton" id="btnSave" href="javascript:void(0)"></a>
			</div>
			<div style="width:120%;float:left;margin:10;height:4px;"></div>
	   	</td>
		</tr>
		<tr>
	   	<td width = '100%'>
			<div class="comm"><h2>教授课程</h2></div>
				<div style="width:48%;float:left;margin:2;">
					<div style="color:orange;margin:0;padding:5px;text-align:center;">未分配课程</div>
					<div style="border:solid 1px #e0e0e0;width:120%;margin:1px;background:#ffffff;line-height:18px;">
						<div id="userListCover" style="float:top;margin:3px;background:#f8fff8;">
						</div>
					</div>
				</div>
				<div style="width:48%;float:right;margin:2;">
					<div style="color:orange;margin:0;padding:5px;text-align:center;">已分配课程</div>
					<div style="border:solid 1px #e0e0e0;width:120%;margin:1px;background:#ffffff;line-height:18px;">
						<div id="taskUserCover" style="float:top;margin:3px;background:#f8fff8;">
						</div>
					</div>
				</div>
			</div>
	   	</td>
		</tr>
	</table>
</div>
</body>
