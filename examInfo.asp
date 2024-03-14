<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?ver=1.1"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

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
		
		getComList("certID","certificateInfo","certID","certName","status=0 order by certID",1);
		getComList("courseID","courseInfo","courseID","courseName","status=0 order by courseID",1);
		getDicList("statusEffect","status",0);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();
		
		$("#save").click(function(){
			saveNode();
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("examControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#examID").val(ar[1]);
				$("#examName").val(ar[2]);
				$("#certID").val(ar[3]);
				$("#courseID").val(ar[5]);
				$("#kindID").val(ar[7]);
				$("#status").val(ar[8]);
				$("#scoreTotal").val(ar[11]);
				$("#scorePass").val(ar[12]);
				$("#minutes").val(ar[13]);
				$("#memo").val(ar[14]);
				$("#regDate").val(ar[15]);
				$("#registerName").val(ar[17]);
				
				//getDownloadFile("examID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		//alert($("#examID").val() + "&item=" + ($("#memo").val()));
		$.get("examControl.asp?op=update&nodeID=" + $("#ID").val() + "&examID=" + $("#examID").val() + "&examName=" + escape($("#examName").val()) + "&certID=" + $("#certID").val() + "&courseID=" + $("#courseID").val() + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&scoreTotal=" + $("#scoreTotal").val() + "&scorePass=" + $("#scorePass").val() + "&minutes=" + $("#minutes").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
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
		$("#save").hide();
		if(op ==1){
			setEmpty();
		}
		if(checkPermission("examAdd")){
			$("#save").show();
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#examID").val("");
		$("#examName").val("");
		$("#memo").val("");
		$("#status").val(0);
		$("#kindID").val(0);
		$("#minutes").val(90);
		$("#scoreTotal").val(100);
		$("#scorePass").val(80);
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
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right">试卷编号</td><input id="ID" type="hidden" /><input id="kindID" type="hidden" />
				<td><input type="text" id="examID" size="25" /></td>
				<td align="right">试卷名称</td>
				<td><input type="text" id="examName" size="25" /></td>
			</tr>
			<tr>
				<td align="right">认证项目</td>
				<td><select id="certID" style="width:180px;"></select></td>
				<td align="right">课程</td>
				<td><select id="courseID" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">状态</td>
				<td><select id="status" style="width:100px;"></select></td>
				<td align="right">考试时间</td>
				<td><input type="text" id="minutes" size="5" />&nbsp;&nbsp;分钟</td>
			</tr>
			<tr>
				<td align="right">总分数</td>
				<td><input type="text" id="scoreTotal" size="5" />&nbsp;&nbsp;分</td>
				<td align="right">及格线</td>
				<td><input type="text" id="scorePass" size="5" />&nbsp;&nbsp;分</td>
			</tr>
			<tr>
				<td align="right">说明</td>
				<td colspan="5"><textarea id="memo" style="padding:2px;" rows="5" cols="75"></textarea></td>
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
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;
  </div>
</div>
</body>
