<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var op = 0;
	var updateCount = 0;
	var pickBefore = "";
	var timer;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";

		$("#startDate").click(function(){WdatePicker();});
		$("#endDate").click(function(){WdatePicker();});
		
    $.ajaxSetup({ 
  		async: false 
  	}); 
		if(op==1){
			setButton();
		}
		if(op!=1){
			getNodeInfo(nodeID);
		}

		$("#save").click(function(){
			saveNode("");
		});

		$("#close").click(function(){
			saveNode(1);
		});

		$("#addNew").click(function(){
			op = 1;
			setButton();
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个条目吗?', '确认对话框', function(r) {
				if(r){
					$.get("grantControl.asp?op=delNode&nodeID=" + $("#grantID").val() + "&times=" + (new Date().getTime()),function(data){
						jAlert("删除成功！","信息提示");
						op = 1;
						setButton();
						updateCount += 1;
					});
				}
			});
		});

		$.get("permissionControl.asp?op=getPermissionListByUser&userID=" + currUser + "&times=" + (new Date().getTime()),function(re){
	    //jAlert(unescape(re));
	    var data = unescape(re).split("%%");
	    if(data.length>0){
			  $("#permissionName").autocomplete(data, {
					minChars: 0,
					width: 200,
					matchContains: true,
					autoFill: false,
					formatItem: function(row, i, max) {
						var ar = row[0].split("|");
						var s = ar[1];
						if(ar[2]>0){s += " <font color=gray>(" + ar[4] + ")</font>";}
						return s;
					},
					formatMatch: function(row, i, max) {
						return row[0];
					},
					formatResult: function(row) {
						var ar = row[0].split("|");
						return ar[1];
					}
				}).result(function (event, row, formatted) {
					var ar = row[0].split("|");
					$("#item").val(ar[0]);
					$("#permissionName").val(ar[1]);
					$("#scopeID").val(ar[3]);
					$("#scopeName").val(ar[4]);
			  });
	    }
		});

		setSingleUser("grantManName","grantMan");		
  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		//alert(id);
		$.get("grantControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#grantID").val(ar[0]);
				$("#item").val(ar[1]);
				$("#permissionName").val(ar[2]);
				$("#status").val(ar[3]);
				$("#statusName").val(ar[4]);
				$("#grantMan").val(ar[5]);
				$("#grantManName").val(ar[6]);
				$("#startDate").val(ar[7]);
				$("#endDate").val(ar[8]);
				$("#memo").val(ar[9]);
				$("#grantDate").val(ar[10]);
				$("#userID").val(ar[11]);
				$("#userName").val(ar[12]);
				$("#scopeID").val(ar[13]);
				$("#scopeName").val(ar[14]);
				getDownloadFile("grantID");
				setButton();
			}else{
				jAlert("该授权信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(status){
		if(status==""){
			status = $("#status").val();
		}
		//alert($("#memoID").val() + "&pCode=" + $("#pCode").val() + "&item=" + ($("#item").val()) + "&title=" + ($("#title").val()) + "&type=" + $("#type").val() + "&kind=" + $("#kind").val() + "&status=" + $("#status").val() + "&engineeringID=" + $("#engineeringID").val() + "&dateStart=" + $("#dateStart").val() + "&dateEnd=" + $("#dateEnd").val() + "&memo=" + ($("#memo").val()) + "&mark=" + ($("#mark").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + ($("#regOperator").val()));
		$.get("grantControl.asp?op=update&nodeID=" + $("#grantID").val() + "&item=" + escape($("#item").val()) + "&status=" + status + "&grantMan=" + escape($("#grantMan").val()) + "&fStart=" + $("#startDate").val() + "&fEnd=" + $("#endDate").val() + "&keyID=" + $("#scopeID").val() + "&scopeName=" + escape($("#scopeName").val()) + "&memo=" + escape($("#memo").val()) + "&grantDate=" + $("#grantDate").val() + "&userID=" + escape($("#userID").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功!","信息提示");
				if(op==1){	//新增
					op = 0;
				}
				updateCount += 1;
				getNodeInfo(ar[1]);
			}
			if(ar[0] == 2){
				jAlert("授权内容不能为空。","信息提示");
				$("#item").focus();
			}
			if(ar[0] == 3){
				jAlert("被授权人不能为空。","信息提示");
				$("#engineeringID").focus();
			}
			if(ar[0] == 4){
				jAlert("结束日期不能为空。","信息提示");
				$("#projectID").focus();
			}
		});
		return false;
	}
	
	function setButton(){
		$("#close").hide();
		if(op ==1){
			setEmpty();
			$("#save").show();
			$("#del").hide();
			$("#btnLoadFile").attr("disabled",true);
		}
		if(op ==0){
			if($("#userID").val() == currUser && $("#grantID").val()>0 && $("#status").val()==0){
				$("#save").show();
				$("#del").show();
				$("#close").show();
				$("#btnLoadFile").attr("disabled",false);
			}else{
				$("#save").hide();
				$("#del").hide();
				$("#btnLoadFile").attr("disabled",true);
			}
		}
	}
	
	function setEmpty(){
		$("#grantID").val(0);
		$("#status").val(0);
		$("#statusName").val("有效");
		$("#item").val("");
		$("#grantMan").val("");
		$("#grantManName").val("");
		$("#startDate").val(currDate);
		$("#endDate").val("");
		$("#memo").val("");
		$("#scopeID").val(0);
		$("#scopeName").val("");
		$("#grantDate").val(currDate);
		$("#userID").val(currUser);
		$("#userName").val(currUserName);
		$("#downloadFile_grantID").html("");
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
          	<td>权限</td><input id="grantID" type="hidden" /><input id="item" type="hidden" />
          	<td><input class="mustFill" type="text" id="permissionName" size="20" /></td>
          	<td>范围</td><input id="scopeID" type="hidden" />
          	<td><input class="readOnly" type="text" id="scopeName" size="25" readOnly="true" /></td>
          </tr>
          <tr>
          	<td>被授权人</td><input type="hidden" id="grantMan" />
          	<td><input class="mustFill" type="text" id="grantManName" size="20" /></td>
          	<td>状态</td><input id="status" type="hidden" />
          	<td><input class="readOnly" type="text" id="statusName" size="25" readOnly="true" /></td>
          </tr>
          <tr>
          	<td>开始日期</td>
          	<td><input type="text" id="startDate" size="25" /></td>
          	<td>结束日期</td>
          	<td><input class="mustFill" type="text" id="endDate" size="25" /></td>
          </tr>
          </tr>
          	<td>情况说明</td>
          	<td colspan="3"><textarea id="memo" style="padding:2px;" rows="5" cols="65"/></textarea></td>
          <tr>
          <tr>
          	<td>授权人</td><input type="hidden" id="userID" />
          	<td><input class="readOnly" type="text" id="userName" size="25" readOnly="true" /></td>
          	<td>登记日期</td>
          	<td><input class="readOnly" type="text" id="grantDate" size="25" readOnly="true" /></td>
         </tr>
          <tr>
            <td colspan="6">
							<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('grantID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_grantID">&nbsp;</span>
					    </div>
            </td>
          </tr>
        	</table>
				</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  <div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="addNew" name="addNew" value="新增" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="close" name="close" value="关闭" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="del" name="del" value="删除" />
  </div>
	
</div>
</body>
