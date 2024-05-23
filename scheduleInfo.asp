<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var refID = 0;
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>"; //classSchedule.ID
		refID = "<%=refID%>";	//courseID
		op = "<%=op%>";
		
		getDicList("scheduleKind","kindID",0);
		getDicList("scheduleType","typeID",0);
		getDicList("online","online",0);
		getComList("teacher","v_courseTeacherList a, courseInfo b","teacherID","teacherName","a.courseID=b.certID and a.status=0 and b.courseID='" + refID + "' group by teacherID,teacherName",1);
		$("#theDate").click(function(){WdatePicker();});
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();
		
		$("#btnSave").click(function(){
			saveNode();
		});
	});

	function getNodeInfo(id){
		$.get("classControl.asp?op=getClassScheduleInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#seq").val(ar[3]);
				$("#kindID").val(ar[4]);
				$("#typeID").val(ar[5]);
				$("#hours").val(ar[7]);
				$("#period").val(ar[8]);
				$("#theDate").val(ar[9]);
				$("#theWeek").val(ar[10]);
				$("#item").val(ar[11]);
				$("#teacher").val(ar[13]);
				$("#memo").val(ar[17]);
				$("#regDate").val(ar[18]);
				$("#registerName").val(ar[20]);
				$("#online").val(ar[21]);
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		//alert($("#agencyID").val() + "&item=" + ($("#memo").val()));
		if($("#seq").val()==""){
			jAlert("课次不能为空");
			return false;
		}
		if($("#theDate").val()==""){
			jAlert("上课日期不能为空");
			return false;
		}
		if($("#period").val()==""){
			jAlert("上课时段不能为空");
			return false;
		}
		//alert($("#ID").val() + "&refID=" + $("#agencyID").val() + "&agencyName=" + ($("#agencyName").val()) + "&title=" + ($("#title").val()) + "&linker=" +  ($("#linker").val()) + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&phone=" +  ($("#phone").val()) + "&email=" + ($("#email").val()) + "&address=" + ($("#address").val()) + "&memo=" + ($("#memo").val()));
		$.get("classControl.asp?op=updateClassSchedule&nodeID=" + $("#ID").val() + "&online=" + $("#online").val() + "&seq=" + $("#seq").val() + "&refID=" + $("#typeID").val() + "&period=" + $("#period").val() + "&hours=" +  $("#hours").val() + "&kindID=" + $("#kindID").val() + "&teacher=" + $("#teacher").val() + "&theDate=" +  $("#theDate").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功！","信息提示");
				updateCount += 1;
			}else{
				jAlert("未能成功保存，教师安排有冲突（" + ar[1] + "）","信息提示");
			}
		});
		//return false;
	}
	
	function setButton(){
		$("#btnSave").hide();
		if(checkRole("operator") || checkRole("partner") || checkRole("adviser")){
			$("#btnSave").show();
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
				<td align="right">课次</td><input id="ID" type="hidden" />
				<td><input class="mustFill" type="text" id="seq" size="25" /></td>
				<td align="right">上课日期</td>
				<td><input class="mustFill" type="text" id="theDate" size="25" /></td>
			</tr>
			<tr>
				<td align="right">星期</td>
				<td><input type="text" id="theWeek" size="25" class="readOnly" readOnly="true" /></td>
				<td align="right">时段</td>
				<td><select id="typeID" style="width:100px;"></select></td>
			</tr>
			<tr>
				<td align="right">上课时间</td>
				<td><input class="mustFill" type="text" id="period" size="25" /></td>
				<td align="right">课时</td>
				<td><input class="mustFill" type="text" id="hours" size="25" /></td>
			</tr>
			<tr>
				<td align="right">上课类型</td>
				<td><select id="kindID" style="width:100px;"></select></td>
				<td align="right">授课教师</td>
				<td><select id="teacher" style="width:100px;"></select></td>
			</tr>
			<tr>
				<td align="right">上课形式</td>
				<td><select id="online" style="width:100px;"></select></td>
				<td align="right">备注</td>
				<td><input type="text" id="memo" size="25"/></td>
			</tr>
			<tr>
				<td align="right">登记人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
				<td align="right">登记日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="btnSave" value="保存" />&nbsp;
  </div>
</div>
</body>
