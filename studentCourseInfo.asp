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

		$("#reply").click(function(){
			showMessageInfo(0,0,1,0,$("#username").val());
		});
		$("#save").click(function(){
			saveNode();
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#studentCourseID").val(ar[0]);
				$("#username").val(ar[1]);
				$("#name").val(ar[2]);
				$("#statusName").val(ar[4]);
				$("#courseName").val(ar[6]);
				$("#sexName").val(ar[7]);
				$("#age").val(ar[8]);
				$("#hours").val(ar[9]);
				$("#completion").val(ar[10]+"%");
				$("#regDate").val(ar[11]);
				$("#hostName").val(ar[12]);
				$("#dept1Name").val(ar[13]);
				$("#dept2Name").val(ar[14]);
				$("#examScore").val(ar[15]);
				$("#memo").val(ar[16]);
				$("#mobile").val(ar[17]);
				$("#email").val(ar[18]);
				$("#startDate").val(ar[19]);
				$("#endDate").val(ar[20]);
				$("#job").val(ar[21]);
				$("#pass_condition").val(ar[22]);
				$("#educationName").val(ar[31]);
				//getDownloadFile("studentCourseID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#memo").val().length < 3){
			jAlert("备注信息请至少填写3个字的内容。");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("studentCourseControl.asp?op=setMemo&nodeID=" + $("#studentCourseID").val() + "&item=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
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
		//$("#reply").hide();
	}
	
	function setEmpty(){
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right">课程</td><input type="hidden" id="studentCourseID" />
				<td><input class="readOnly" type="text" id="courseName" size="25" readOnly="true" /></td>
				<td align="right">课时</td>
				<td><input class="readOnly" type="text" id="hours" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">进度</td>
				<td><input class="readOnly" type="text" id="completion" size="25" readOnly="true" /></td>
				<td align="right">模拟成绩</td>
				<td><input class="readOnly" type="text" id="examScore" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">姓名</td>
				<td><input class="readOnly" type="text" id="name" size="25" readOnly="true" /></td>
				<td align="right">身份证</td>
				<td><input class="readOnly" type="text" id="username" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">学号</td>
				<td><input class="readOnly" type="text" id="SNo" size="25" readOnly="true" /></td>
				<td align="right">公司</td>
				<td><input class="readOnly" type="text" id="hostName" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">一级部门</td>
				<td><input class="readOnly" type="text" id="dept1Name" size="25" readOnly="true" /></td>
				<td align="right">二级部门</td>
				<td><input class="readOnly" type="text" id="dept2Name" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">性别</td>
				<td><input class="readOnly" type="text" id="sexName" size="25" readOnly="true" /></td>
				<td align="right">年龄</td>
				<td><input class="readOnly" type="text" id="age" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">手机</td>
				<td><input class="readOnly" type="text" id="mobile" size="25" readOnly="true" /></td>
				<td align="right">邮箱</td>
				<td><input class="readOnly" type="text" id="email" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">岗位</td>
				<td><input class="readOnly" type="text" id="job" size="25" readOnly="true" /></td>
				<td align="right">状态</td>
				<td><input class="readOnly" type="text" id="statusName" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">完成条件</td>
				<td><input class="readOnly" type="text" id="pass_condition" size="25" readOnly="true" /></td>
				<td align="right">报名日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">开始日期</td>
				<td><input class="readOnly" type="text" id="startDate" size="25" readOnly="true" /></td>
				<td align="right">结束日期</td>
				<td><input class="readOnly" type="text" id="endDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="5"><input type="text" id="memo" size="70" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="reply" name="reply" value="发通知" />&nbsp;
  	<input class="button" type="button" id="save" name="save" value="保存备注" />&nbsp;
  </div>
</div>
</body>
