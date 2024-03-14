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

		$("#lessonID").textbox({
			onChange:function() {
				if(op==1 && $("#lessonID").textbox("getValue")>""){
					checkExistKeyInTab("lessonID","lessonInfo","lessonID",$("#lessonID").textbox("getValue"));
				}
			}
		});

		$("#btnAddVideo").linkbutton({
			iconCls:'icon-add',
			width:85,
			height:25,
			text:'添加视频',
			onClick:function() {
				showLessonVideoInfo(0, $("#lessonID").textbox("getValue"),1,1);
			}
		});

		$("#btnAddWare").linkbutton({
			iconCls:'icon-add',
			width:85,
			height:25,
			text:'添加课件',
			onClick:function() {
				showLessonCoursewareInfo(0, $("#lessonID").textbox("getValue"),1,1);
			}
		});
		
		if(op==1){
			setButton();
		}else{
			getNodeInfo(nodeID);
		}
	});

	function getNodeInfo(id){
		$.get("lessonControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#lessonID").textbox("setValue", ar[1]);
				$("#lessonName").textbox("setValue", ar[2]);
				$("#status").combobox("setValue", ar[3]);
				$("#memo").textbox("setValue", ar[5]);
				$("#regDate").textbox("setValue", ar[6]);
				$("#registerName").textbox("setValue", ar[8]);
				getLessonVideoList();
				getLessonCoursewareList();
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}

	function getLessonVideoList(){
		$.get("lessonControl.asp?op=getLessonVideoList&refID=" + $("#lessonID").textbox("getValue"),function(data1){
			//alert(unescape(data1));
			var ar = new Array();
			ar = unescape(data1).split("%%");
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='myTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='10%'>编号</th>");
			arr.push("<th width='37%'>视频名称</th>");
			arr.push("<th width='10%'>权重%</th>");
			arr.push("<th width='12%'>时长(秒)</th>");
			arr.push("<th width='10%'>序号</th>");
			arr.push("<th width='10%'>状态</th>");
			arr.push("<th width='10%'>备注</th>");
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
					arr.push("<td class='link1'><a href='javascript:showLessonVideoInfo(" + ar1[0] + ",0,0,1);'>" + ar1[3] + "</a></td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[12] + "</td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#listCover").html(arr.join(""));
			arr = [];
			$('#myTab').dataTable({
				"aaSorting": [],
				"bFilter": false,
				"bPaginate": false,
				"bLengthChange": false,
				"iDisplayLength": 30,
				"aoColumnDefs": []
			});
		});
	}

	function getLessonCoursewareList(){
		$.get("lessonControl.asp?op=getLessonCoursewareList&refID=" + $("#lessonID").textbox("getValue"),function(data1){
			//alert(unescape(data1));
			var ar = new Array();
			ar = unescape(data1).split("%%");
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='myTab1' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='10%'>编号</th>");
			arr.push("<th width='37%'>课件名称</th>");
			arr.push("<th width='10%'>权重%</th>");
			arr.push("<th width='10%'>页数</th>");
			arr.push("<th width='10%'>序号</th>");
			arr.push("<th width='10%'>状态</th>");
			arr.push("<th width='10%'>备注</th>");
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
					arr.push("<td class='link1'><a href='javascript:showLessonCoursewareInfo(" + ar1[0] + ",0,0,1);'>" + ar1[3] + "</a></td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[12] + "</td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			if(i>0){
				$("#listCover1").html(arr.join(""));
				$('#myTab1').dataTable({
					"aaSorting": [],
					"bFilter": false,
					"bPaginate": false,
					"bLengthChange": false,
					"iDisplayLength": 30,
					"aoColumnDefs": []
				});
			}
			arr = [];
		});
	}
	
	function saveNode(){
		//alert($("#lessonID").val() + "&item=" + ($("#memo").val()));
		if($("#lessonID").textbox("getValue")=="" || $("#lessonName").textbox("getValue")==""){
			$.messager.alert("提示","编码或名称不能为空。","warning");
			return false;
		}
		$.get("lessonControl.asp?op=update&nodeID=" + $("#ID").val() + "&lessonID=" + $("#lessonID").textbox("getValue") + "&lessonName=" + escape($("#lessonName").textbox("getValue")) + "&status=" + $("#status").combobox("getValue") + "&memo=" + escape($("#memo").textbox("getValue")) + "&times=" + (new Date().getTime()),function(re){
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
		if(op ==1){
			setEmpty();
		}
		if(checkPermission("courseAdd")){
			$("#btnSave").show();
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
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
				<td align="right" style="width:70px;">编号</td><input id="ID" type="hidden" />
				<td><input id="lessonID" name="lessonID" class="easyui-textbox" data-options="height:22,width:100,required:true"></td>
				<td align="right" style="width:70px;">课节名称</td>
				<td><input id="lessonName" name="lessonName" class="easyui-textbox" data-options="height:22,width:250,required:true"></td>
			</tr>
			<tr>
				<td align="right">状态</td>
				<td><select id="status" name="status" class="easyui-combobox" data-options="panelHeight:'auto',height:22,width:100"></select></td>
				<td align="right">备注</td>
				<td><input id="memo" name="memo" class="easyui-textbox" data-options="height:22,width:250" /></td>
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
	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div class="buttonbox">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;padding:3px;">
			<a class="easyui-linkbutton" id="btnAddVideo" href="javascript:void(0)"></a>
			<a class="easyui-linkbutton" id="btnAddWare" href="javascript:void(0)"></a>
		</div>
	</div>
	<hr size="1" noshadow />
	<div id='listCover'></div>
	<div id='listCover1'></div>
</div>
</body>
