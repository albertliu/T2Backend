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
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";
		
		getDicList("examResult","status",0);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo();
		}
		setButton();
		
		$("#btnSave").click(function(){
			saveNode();
		});
	});

	function getNodeInfo(){
		$.get("diplomaControl.asp?op=getApplyNodeInfo&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#step").val(ar[7]);
				$("#score").val(ar[10]);
				$("#score1").val(ar[11]);
				$("#status").val(ar[13]);
				$("#memo").val(ar[1]);
				$("#memo1").val(ar[2]);
				$("#examDate").val(ar[6]);
				$("#age").val(ar[8]);
				$("#IDdateEnd").val(ar[9]);
				$("#unit").val(ar[5]);
				$("#memo_enter").val(ar[14]);
				$("#examAddress").val(ar[15]);
				if(ar[3]==1){
					$("#upload").prop("checked",true);
				}else{
					$("#upload").prop("checked",false);
				}
				if(ar[4]==1){
					$("#uploadPhoto").prop("checked",true);
				}else{
					$("#uploadPhoto").prop("checked",false);
				}
				
				//getDownloadFile("hostID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
			}
		});
	}
	
	function saveNode(){
		let upload = 0;
		if($("#upload").prop("checked")){
			upload = 1;
		}
		let uploadPhoto = 0;
		if($("#uploadPhoto").prop("checked")){
			uploadPhoto = 1;
		}
		$.post(uploadURL + "/public/postCommInfo", {proc:"updateApplyInfo", params:{ID:nodeID,status:$("#status").val(),examDate:$("#examDate").val(),examAddress:$("#examAddress").val(),step:$("#step").val(), memo:$("#memo").val(), memo1:$("#memo1").val(), score1:$("#score1").val(), score:$("#score").val(),upload:upload,uploadPhoto:uploadPhoto,registerID:currUser}}, function(data){
			getNodeInfo();
			jAlert("保存成功！","信息提示");
			updateCount += 1;
		});
	}
	
	function setButton(){
		$("#btnSave").hide();
		if(checkPermission("applyEdit")){
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
				<td align="right">单位名称</td>
				<td colspan="3"><input class="readOnly" type="text" id="unit" style="width:100%;" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">报名情况</td>
				<td><input type="text" id="step" size="25" /></td>
				<td align="right">考试日期</td>
				<td><input type="text" id="examDate" size="25" /></td>
			</tr>
			<tr>
				<td align="right">上传资料</td>
				<td>
					<input type="checkbox" id="upload" />
					&nbsp;&nbsp;上传照片&nbsp;<input type="checkbox" id="uploadPhoto" />
				</td>
				<td align="right">考试地址</td>
				<td><input type="text" id="examAddress" size="25" /></td>
			</tr>
			<tr>
				<td align="right">应知成绩</td>
				<td><input type="text" id="score" size="3" />&nbsp;&nbsp;应会&nbsp;<input type="text" id="score1" size="3" /></td>
				<td align="right">结果</td>
				<td><select id="status" style="width:100px;"></select></td>
			</tr>
			<tr>
				<td align="right">申报备注</td>
				<td colspan="3"><input type="text" id="memo" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">备注历史</td>
				<td colspan="3"><input type="text" id="memo1" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">报名备注</td>
				<td colspan="3"><input class="readOnly" type="text" id="memo_enter" readOnly="true" style="padding:2px; width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">年龄</td>
				<td colspan="3">
					<input class="readOnly" type="text" id="age" size="5" readOnly="true" />
					&nbsp;&nbsp;&nbsp;&nbsp;身份证有效日期&nbsp;&nbsp;<input class="readOnly" type="text" id="IDdateEnd" size="10" readOnly="true" />
				</td>
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
