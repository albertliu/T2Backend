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
		
		$("#btnDel").click(function(){
			if(confirm('确定删除该课节吗?')){
				var x = prompt("请输入删除原因：","");
				if(x && x>""){
					$.get("classControl.asp?op=delStandardSchedule&nodeID=" + nodeID + "&where=" + escape(x) + "&times=" + (new Date().getTime()),function(data){
						//alert(unescape(data));
						alert("已成功删除。","信息提示");
						updateCount += 1;
						op = 1;
						setButton();
					});
				}
			}
		});
		
		$("#typeID").change(function(){
			if($("#typeID").val()==0){
				$("#period").val("08:30-11:30");
			}else{
				$("#period").val("12:30-15:30");
			}
		});
	});

	function getNodeInfo(id){
		$.get("classControl.asp?op=getStandardScheduleInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#courseID").val(ar[1]);
				$("#seq").val(ar[2]);
				$("#kindID").val(ar[3]);
				$("#typeID").val(ar[4]);
				$("#hours").val(ar[6]);
				$("#period").val(ar[7]);
				$("#item").val(ar[8]);
				$("#online").val(ar[15]);
				$("#memo").val(ar[11]);
				$("#regDate").val(ar[12]);
				$("#registerName").val(ar[14]);
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
		if($("#period").val()==""){
			jAlert("上课时段不能为空");
			return false;
		}
		if($("#item").val()==""){
			jAlert("课程内容不能为空");
			return false;
		}
		//alert($("#ID").val() + "&refID=" + $("#agencyID").val() + "&agencyName=" + ($("#agencyName").val()) + "&title=" + ($("#title").val()) + "&linker=" +  ($("#linker").val()) + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&phone=" +  ($("#phone").val()) + "&email=" + ($("#email").val()) + "&address=" + ($("#address").val()) + "&memo=" + ($("#memo").val()));
		$.get("classControl.asp?op=updateStandardSchedule&nodeID=" + $("#ID").val() + "&courseID=" + $("#courseID").val() + "&online=" + $("#online").val() + "&seq=" + $("#seq").val() + "&refID=" + $("#typeID").val() + "&period=" + $("#period").val() + "&hours=" +  $("#hours").val() + "&kindID=" + $("#kindID").val() + "&item=" + escape($("#item").val()) + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			// alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				if(op==1){
					nodeID = ar[2];
				}
				getNodeInfo(nodeID);
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
		$("#btnDel").hide();
		if(checkPermission("courseAdd")){
			$("#btnSave").show();
			if(op ==1){
				setEmpty();
			}else{
				$("#btnDel").show();
			}
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#courseID").val(refID);
		$("#seq").val(1);
		$("#kindID").val(0);
		$("#typeID").val(0);
		$("#hours").val(4);
		$("#period").val("08:30-11:30");
		$("#item").val("");
		$("#online").val(0);
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#registerID").val(currUser);
		$("#registerName").val(currUserName);
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
				<td align="right">课次</td><input id="ID" type="hidden" /><input id="courseID" type="hidden" />
				<td><input class="mustFill" type="text" id="seq" size="25" /></td>
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
				<td align="right">上课形式</td>
				<td><select id="online" style="width:100px;"></select></td>
			</tr>
			<tr>
				<td align="right">课程内容</td>
				<td colspan="3"><input class="mustFill" type="text" id="item" style="width:95%;"/></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="3"><input type="text" id="memo" style="width:95%;"/></td>
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
  	<input class="button" type="button" id="btnDel" value="删除" />&nbsp;
  </div>
</div>
</body>
