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
			showMessageInfo(0,$("#feedbackID").val(),1,0,$("#username").val());
		});
		$("#save").click(function(){
			saveNode();
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("feedbackControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#feedbackID").val(ar[0]);
				$("#item").val(ar[2]);
				$("#username").val(ar[3]);
				$("#name").val(ar[18]);
				$("#regDate").val(ar[17]);
				$("#kindName").val(ar[7]);
				$("#emergencyName").val(ar[9]);
				$("#mobile").val(ar[11]);
				$("#email").val(ar[10]);
				$("#readerName").val(ar[13]);
				$("#readDate").val(ar[12]);
				$("#memo").val(ar[16]);
				$("#dealDate").val(ar[19]);
				$("#dealerName").val(ar[20]);
				
				//getDownloadFile("feedbackID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#memo").val().length < 3){
			jAlert("处理结果请至少填写3个字的内容。");
			return false;
		}
		//alert($("#feedbackID").val() + "&item=" + ($("#memo").val()));
		$.get("feedbackControl.asp?op=doDeal&nodeID=" + $("#feedbackID").val() + "&item=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
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
		$("#reply").hide();
		$("#save").hide();
		if(checkPermission("messageAdd")){
			$("#reply").show()
		}
		if(checkPermission("feedbackAdd")){
			$("#save").show()
		}
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
				<td align="right">反馈内容</td><input id="feedbackID" type="hidden" />
				<td colspan="5"><textarea id="item" style="padding:2px;" rows="4" cols="75" readOnly="true"></textarea></td>
			</tr>
			<tr>
				<td align="right">发送人</td><input type="hidden" id="refID" />
				<td><input class="readOnly" type="text" id="name" size="25" readOnly="true" /></td>
				<td align="right">发送日期</td><input type="hidden" id="username" />
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">类型</td>
				<td><input class="readOnly" type="text" id="kindName" size="25" readOnly="true" /></td>
				<td align="right">紧急程度</td>
				<td><input class="readOnly" type="text" id="emergencyName" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">电话</td>
				<td><input class="readOnly" type="text" id="mobile" size="25" readOnly="true" /></td>
				<td align="right">邮箱</td>
				<td><input class="readOnly" type="text" id="email" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">阅读人</td>
				<td><input class="readOnly" type="text" id="readerName" size="25" readOnly="true" /></td>
				<td align="right">阅读日期</td>
				<td><input class="readOnly" type="text" id="readDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">处理结果</td>
				<td colspan="5"><textarea id="memo" style="padding:2px;" rows="3" cols="75"></textarea></td>
			</tr>
			<tr>
				<td align="right">处理人</td>
				<td><input class="readOnly" type="text" id="dealerName" size="25" readOnly="true" /></td>
				<td align="right">处理日期</td>
				<td><input class="readOnly" type="text" id="dealDate" size="25" readOnly="true" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="reply" name="reply" value="回复" />&nbsp;
  	<input class="button" type="button" id="save" name="save" value="保存处理结果" />&nbsp;
  </div>
</div>
</body>
