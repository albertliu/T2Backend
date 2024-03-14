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
	<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
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
	<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		op = "<%=op%>";
		
		getComboList("certID","certificateInfo","certID","certName","status=0 order by certID",1);
		getComboList("entryForm","entryFormInfo","ID","item","status=0 order by ID",1);
		getComboBoxList("statusEffect","status",0);
		getComboBoxList("statusNo","sc",0);
		getComboBoxList("statusNo","mark",0);
		getComboBoxList("reexamine","reexamine",1);
		
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
				jConfirm('你确定要删除这个课程吗?', '确认对话框', function(r) {
					if(r){
						$.get("courseControl.asp?op=delNode&nodeID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(data){
							jAlert("删除成功！","信息提示");
							op = 1;
							setButton();
							updateCount += 1;
						});
					}
				});
			}
		});

		$("#courseID").textbox({
			onChange:function() {
				if(op==1 && $("#courseID").textbox("getValue")>""){
					checkExistKeyInTab("courseID","courseInfo","courseID",$("#courseID").textbox("getValue"));
				}
			}
		});

		$("#btnAddLesson").linkbutton({
			iconCls:'icon-add',
			width:85,
			height:25,
			text:'添加课节',
			onClick:function() {
				showCourseLessonInfo(0, $("#courseID").textbox("getValue"),1,1);
			}
		});
		
		if(op==1){
			setButton();
		}else{
			getNodeInfo(nodeID);
		}
	});

	function getNodeInfo(id){
		$.get("courseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#courseID").textbox("setValue", ar[1]);
				$("#certID").combobox("setValue", ar[13]);
				$("#reexamine").combobox("setValue", ar[21]);
				$("#hours").textbox("setValue", ar[3]);
				$("#status").combobox("setValue", ar[5]);
				$("#completionPass").textbox("setValue", ar[14]);
				$("#sc").combobox("setValue", ar[17]);
				$("#mark").combobox("setValue", ar[18]);
				$("#price").textbox("setValue", ar[25]);
				$("#price1").textbox("setValue", ar[26]);
				$("#cards").textbox("setValue", ar[12]);
				$("#entryForm").combobox("setValue", ar[24]);
				$("#memo").textbox("setValue", ar[7]);
				$("#regDate").textbox("setValue", ar[8]);
				$("#registerName").textbox("setValue", ar[10]);
				$("#seq").numberbox("setValue", ar[27]);
				getCourseLessonList();
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}

	function getCourseLessonList(){
		$.get("lessonControl.asp?op=getCourseLessonList&refID=" + $("#courseID").textbox("getValue"),function(data1){
			//alert(unescape(data1));
			var ar = new Array();
			ar = unescape(data1).split("%%");
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='myTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='12%'>编号</th>");
			arr.push("<th width='40%'>课节名称</th>");
			arr.push("<th width='10%'>课时</th>");
			arr.push("<th width='10%'>序号</th>");
			arr.push("<th width='10%'>状态</th>");
			arr.push("<th width='12%'>备注</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			var c = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showCourseLessonInfo(" + ar1[0] + ",0,0,1);'>" + ar1[3] + "</a></td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#listCover").html(arr.join(""));
			arr = [];
			$('#myTab').dataTable({
				"aaSorting": [],
				"bFilter": false,
				"bPaginate": true,
				"bLengthChange": false,
				"iDisplayLength": 30,
				"aoColumnDefs": []
			});
		});
	}
	
	function saveNode(){
		if($("#courseID").textbox("getValue")==""){
			$.messager.alert("提示","编码不能为空。","warning");
			return false;
		}
		$.get("courseControl.asp?op=update&nodeID=" + $("#ID").val() + "&courseID=" + $("#courseID").textbox("getValue") + "&price=" + $("#price").textbox("getValue") + "&price1=" + $("#price1").textbox("getValue") + "&cards=" + $("#cards").textbox("getValue") + "&reexamine=" + $("#reexamine").combobox("getValue") + "&hours=" + $("#hours").textbox("getValue") + "&completionPass=" + $("#completionPass").textbox("getValue") + "&sc=" + $("#sc").combobox("getValue") + "&refID=" + $("#certID").combobox("getValue") + "&status=" + $("#status").combobox("getValue") + "&entryForm=" + $("#entryForm").combobox("getValue") + "&mark=" + $("#mark").combobox("getValue") + "&seq=" + $("#seq").numberbox("getValue") + "&memo=" + escape($("#memo").textbox("getValue")) + "&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				if(op == 1){
					op = 0;
					getNodeInfo(ar[1]);
				}
				jAlert("保存成功！","信息提示");
				updateCount += 1;
			}
			if(ar[0] != 0){
				jAlert("未能成功提交，请退出后重试。","信息提示");
			}
		});
		//return false;
	}
	
	function setButton(){
		$("#btnSave").hide();
		$("#btnDel").hide();
		$("#btnAddLesson").hide();
		if(op ==1){
			setEmpty();
		}
		if(checkPermission("courseAdd")){
			$("#btnSave").show();
			if(currHost=="feng"){
				// $("#btnDel").show();
				$("#btnAddLesson").show();
			}else{
				// 其他分校只能修改价格
				$("#courseID").textbox("readonly", true);
				$("#certID").combobox("readonly", true);
				$("#reexamine").combobox("readonly", true);
				$("#hours").textbox("readonly", true);
				$("#status").combobox("readonly", true);
				$("#completionPass").textbox("readonly", true);
				$("#sc").combobox("readonly", true);
				$("#mark").combobox("readonly", true);
				$("#cards").textbox("readonly", true);
				$("#entryForm").combobox("readonly", true);
				$("#memo").textbox("readonly", true);
			}
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#courseID").textbox("setValue", "");
		$("#hours").textbox("setValue", "");
		$("#completionPass").textbox("setValue", "80");
		$("#memo").textbox("setValue", "");
		$("#status").combobox("setValue", 0);
		$("#reexamine").combobox("setValue", 0);
		$("#cards").textbox("setValue", 0);
		$("#price").textbox("setValue", "0");
		$("#price1").textbox("setValue", "0");
		$("#seq").numberbox("setValue", 99);
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
				<td align="right" style="width:70px;">课程编号</td><input id="ID" type="hidden" />
				<td><input id="courseID" name="courseID" class="easyui-textbox" data-options="height:22,width:100,required:true"></td>
				<td align="right" style="width:70px;">认证项目</td>
				<td><select id="certID" name="certID" class="easyui-combobox" data-options="panelHeight:'auto',height:22,width:205"></select></td>
			</tr>
			<tr>
				<td align="right">申报类别</td>
				<td><select id="reexamine" name="reexamine" class="easyui-combobox" data-options="panelHeight:'auto',height:22,width:100"></select></td>
				<td align="right">课时</td>
				<td>
					<input id="hours" name="hours" class="easyui-textbox" data-options="height:22,width:40">&nbsp;小时
					&nbsp;&nbsp;&nbsp;报名表&nbsp;<select id="entryForm" name="entryForm" class="easyui-combobox" data-options="panelHeight:'auto',height:22,width:85"></select>
				</td>
			</tr>
			<tr>
				<td align="right">标准收费</td>
				<td><input id="price" name="price" class="easyui-textbox" data-options="height:22,width:80">&nbsp;元</td>
				<td align="right">重修收费</td>
				<td>
					<input id="price1" name="price1" class="easyui-textbox" data-options="height:22,width:70">&nbsp;元
					&nbsp;&nbsp;&nbsp;状态&nbsp;<select id="status" name="status" class="easyui-combobox" data-options="panelHeight:'auto',height:22,width:80"></select>
				</td>
			</tr>
			<tr>
				<td align="right">应会考试</td>
				<td><select id="sc" name="sc" class="easyui-combobox" data-options="panelHeight:'auto',height:22,width:100"></select></td>
				<td align="right">集中申报</td>
				<td><select id="mark" name="mark" class="easyui-combobox" data-options="panelHeight:'auto',height:22,width:100"></select></td>
			</tr>
			<tr>
				<td align="right">实训额度</td>
				<td><input id="cards" name="cards" class="easyui-textbox" data-options="height:22,width:80">&nbsp;次</td>
				<td align="right">达标进度</td>
				<td><input id="completionPass" name="completionPass" class="easyui-textbox" data-options="height:22,width:100">&nbsp;%</td>
			</tr>
			<tr>
				<td align="right">显示顺序</td>
				<td><input id="seq" name="seq" class="easyui-numberbox" data-options="height:22,width:100" /></td>
				<td align="right">登记人</td>
				<td>
					<input id="registerName" name="registerName" class="easyui-textbox" data-options="height:22,width:100,readonly:true" />&nbsp;&nbsp;
					<input id="regDate" name="regDate" class="easyui-textbox" data-options="height:22,width:80,readonly:true" />
				</td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="3"><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:420" /></td>
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
	<div class="buttonbox">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;padding:3px;">
			<a class="easyui-linkbutton" id="btnAddLesson" href="javascript:void(0)"></a>
		</div>
	</div>
	<hr size="1" noshadow />
	<div id='listCover'></div>
  </div>
</div>
</body>
