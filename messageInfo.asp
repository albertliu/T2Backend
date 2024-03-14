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
	var refID = 0;
	var username = "";
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		op = "<%=op%>";
		username = "<%=keyID%>";
		
		getDicList("message","kindID",0);
		getDicList("emergency","emergency",0);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();

		$("#cancel").click(function(){
			jConfirm('你确定要撤回这个消息吗?', '确认对话框', function(r) {
				if(r){
					$.get("messageControl.asp?op=cancelNode&nodeID=" + $("#messageID").val() + "&times=" + (new Date().getTime()),function(data){
						jAlert("撤销成功！","信息提示");
						getNodeInfo(nodeID);
						updateCount += 1;
					});
				}
			});
		});
		
		$("#save").click(function(){
			saveNode();
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("messageControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#messageID").val(ar[0]);
				$("#refID").val(ar[1]);
				$("#item").val(ar[2]);
				$("#username").val(ar[3]);
				$("#kindID").val(ar[4]);
				$("#emergency").val(ar[6]);
				$("#statusName").val(ar[8]);
				$("#email").val(ar[10]);
				$("#mobile").val(ar[11]);
				$("#readDate").val(ar[12]);
				$("#dept1Name").val(ar[13]);
				$("#hostName").val(ar[15]);
				$("#regDate").val(ar[17]);
				$("#name").val(ar[18]);
				$("#registerName").val(ar[20]);
				
				//getDownloadFile("messageID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#item").val().length < 3){
			jAlert("消息内容请至少填写3个字的内容。");
			return false;
		}
		//alert($("#messageID").val() + "&item=" + ($("#memo").val()));
		$.get("messageControl.asp?op=update&nodeID=" + $("#messageID").val() + "&item=" + escape($("#item").val()) + "&refID=" + $("#refID").val() + "&kindID=" + $("#kindID").val() + "&emergency=" + $("#emergency").val() + "&username=" + $("#username").val() + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				if(op == 1){
					op = 0;
					getNodeInfo(ar[1]);
					jAlert("发送成功！","信息提示");
				}else{
					jAlert("保存成功！","信息提示");
				}
				updateCount += 1;
			}
			if(ar[0] != 0){
				jAlert("未能成功提交，请退出后重试。","信息提示");
			}
		});
		//return false;
	}
	
	function setButton(){
		$("#cancel").hide();
		$("#save").hide();
		if(op ==1){
			setEmpty();
			$("#save").val("发送");
		}else{
			$("#save").val("保存");
		}
		if($("#status").val()==0 && checkPermission("messageAdd")){
			$("#save").show();
			if(op == 0){
				$("#cancel").show();
			}
		}
	}
	
	function setEmpty(){
		$("#messageID").val(0);
		$("#refID").val(refID);
		$("#username").val(username);
		$("#status").val(0);
		$("#regDate").val(currDate);
		$("#registerID").val(currUser);
		$("#registerName").val(currUserName);
		if(refID == 0){
			$("#kindID").val(1);	//非回复性消息，通知
		}
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
				<td align="right">消息内容</td><input id="messageID" type="hidden" />
				<td colspan="5"><textarea id="item" style="padding:2px;" rows="4" cols="75"></textarea></td>
			</tr>
			<tr>
				<td align="right">接收人</td><input type="hidden" id="refID" /><input type="hidden" id="status" />
				<td><input class="readOnly" type="text" id="name" size="25" readOnly="true" /></td>
				<td align="right">身份证</td>
				<td><input class="readOnly" type="text" id="username" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">类型</td>
				<td><select id="kindID" style="width:100px;"></select></td>
				<td align="right">紧急程度</td>
				<td><select id="emergency" style="width:100px;"></select></td>
			</tr>
			<tr>
				<td align="right">电话</td>
				<td><input class="readOnly" type="text" id="mobile" size="25" readOnly="true" /></td>
				<td align="right">邮箱</td>
				<td><input class="readOnly" type="text" id="email" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">公司</td>
				<td><input class="readOnly" type="text" id="hostName" size="25" readOnly="true" /></td>
				<td align="right">部门</td>
				<td><input class="readOnly" type="text" id="dept1Name" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">发送人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
				<td align="right">发送日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">状态</td>
				<td><input class="readOnly" type="text" id="statusName" size="25" readOnly="true" /></td>
				<td align="right">阅读日期</td>
				<td><input class="readOnly" type="text" id="readDate" size="25" readOnly="true" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;
  	<input class="button" type="button" id="cancel" name="cancel" value="撤回" />&nbsp;
  </div>
</div>
</body>
