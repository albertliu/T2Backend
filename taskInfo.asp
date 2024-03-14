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
<link rel="stylesheet" href="css/token-input-facebook.css?v=20150409" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/comment.css">
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type="text/javascript" src="js/jquery.tokeninput.js"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var op = 0;
	var updateCount = 0;
	var imReceiver = 0;
	var receiverConfirmCount = 0;
	<!--#include file="js/commFunction.js"-->
	<!--#include file="receiverListIncReady.js"-->	
	<!--#include file="commentListIncReady.js"-->	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";

		getDicList("taskKind","kindID",0);
		$("#limitDate").click(function(){WdatePicker();});
		
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
			saveNode(2);
		});

		$("#addNew").click(function(){
			op = 1;
			setButton();
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个条目吗?', '确认对话框', function(r) {
				if(r){
					$.get("taskControl.asp?op=delNode&nodeID=" + $("#taskID").val() + "&times=" + (new Date().getTime()),function(data){
						jAlert("删除成功！","信息提示");
						op = 1;
						setButton();
						updateCount += 1;
					});
				}
			});
		});

  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("taskControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#taskID").val(ar[0]);
				$("#item").val(ar[1]);
				$("#status").val(ar[2]);
				$("#statusName").val(ar[3]);
				$("#kindID").val(ar[4]);
				$("#limitDate").val(ar[6]);
				//$("#finishDate").val(ar[7]);
				imReceiver = ar[7];
				$("#memo").val(ar[8]);
				//$("#userID").val(ar[9]);
				//$("#userName").val(ar[10]);
				//$("#doMemo").val(ar[9]);
				$("#regDate").val(ar[10]);
				$("#regOperator").val(ar[11]);
				$("#registorName").val(ar[12]);
				receiverConfirmCount = ar[13];
				$("#finishDate").val(ar[14]);
				$("#div_token_user").html('<input class="mustFill" type="text" id="userName" size="60" />');
				setTokenUser(0);
				getReceiverListJson("task",ar[0]);
				setSession("ar_receiverList","task|" + ar[0]);
				var j = 1;
				if((imReceiver==1 || ar[11]==currUser) && ar[2]==0){j=0;}	//任务的当事人在任务活动期间可编写评论
				setSession("ar_commentList","task|" + ar[0] + "|" + j);	//kindID,refID,status:0 可编辑，1 关闭
				getReceiverList();
				getCommentList("");
				
				getDownloadFile("taskID");
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
		//alert( $("#taskID").val() + "&item=" + ($("#item").val()) + "&status=" + status + "&kindID=" + $("#kindID").val() + "&fStart=" + $("#limitDate").val() + "&fEnd=" + $("#finishDate").val() + "&userID=" + (token_user.join("|")) + "&memo=" + ($("#memo").val()));
		$.get("taskControl.asp?op=update&nodeID=" + $("#taskID").val() + "&item=" + escape($("#item").val()) + "&status=" + status + "&kindID=" + $("#kindID").val() + "&fStart=" + $("#limitDate").val() + "&fEnd=" + $("#finishDate").val() + "&userID=" + escape(token_user.join("|")) + "&memo=" + escape($("#memo").val()) + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				//alert("保存成功!");
				jAlert("保存成功!","信息提示");
				if(op==1){	//新增
					op = 0;
				}
				updateCount += 1;
				getNodeInfo(ar[1]);
				//parent.$.close("task");
			}
			if(ar[0] == 2){
				jAlert("标题不能为空。","信息提示");
				$("#item").focus();
			}
			if(ar[0] == 3){
				jAlert("被委托人不能为空。","信息提示");
				$("#userName").focus();
			}
			if(ar[0] == 4){
				jAlert("日期不能为空。","信息提示");
				$("#limitDate").focus();
			}
		});
		return false;
	}
	
	function setButton(){
		$("#close").hide();
		$("#save").hide();
		$("#del").hide();
		$("#btnLoadFile").attr("disabled",true);
		if(op ==1){
			setEmpty();
			$("#save").show();
			$("#del").hide();
			$("#btnLoadFile").attr("disabled",true);
		}
		if(op ==0){
			if($("#regOperator").val() == currUser && $("#taskID").val()>0 && $("#status").val()==0){		//发起人动作
				$("#save").show();
				$("#close").show();
				$("#btnLoadFile").attr("disabled",false);
				if(receiverConfirmCount==0){
					$("#del").show();			//无人完成时，发起人可以删除任务
				}
			}
			if(imReceiver==1 && $("#taskID").val()>0 && $("#status").val()==0){
				$("#btnLoadFile").attr("disabled",false);		//接收人在任务关闭前可以上传附件
			}
		}
	}
	
	function setEmpty(){
		$("#taskID").val(0);
		$("#status").val(0);
		$("#statusName").val("活动");
		$("#item").val("");
		$("#kindID").val(0);
		$("#limitDate").val(currDate);
		$("#endDate").val("");
		$("#memo").val("");
		$("#userID").val("");
		$("#userName").val("");
		//$("#doMemo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_taskID").html("");
		setTokenUser(0);
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
          	<td>标题</td><input id="taskID" type="hidden" />
          	<td colspan="5"><input class="mustFill" type="text" id="item" size="70" /></td>
          </tr>
          <tr>
          	<td>类型</td>
          	<td><select id="kindID" style="width:80px" /></td>
          	<td>期望日期</td>
          	<td><input class="mustFill" type="text" id="limitDate" size="12" /></td>
          	<td>实际完成</td>
          	<td><input class="readOnly" readOnly="true" type="text" id="finishDate" size="12" /></td>
          </tr>
          </tr>
          	<td>说明</td>
          	<td colspan="5"><textarea id="memo" style="padding:2px;" rows="2" cols="68"/></textarea></td>
          <tr>
          <tr>
          	<td>受托人</td><input id="userID" type="hidden" />
          	<td colspan="5"><div id="div_token_user"><input class="mustFill" type="text" id="userName" size="60" /></div></td>
          </tr>
          <tr>
          	<td>状态</td><input id="status" type="hidden" />
          	<td><input class="readOnly" type="text" id="statusName" size="12" readOnly="true" /></td>
          	<td>委托人</td><input type="hidden" id="regOperator" />
          	<td><input class="readOnly" type="text" id="registorName" size="12" readOnly="true" /></td>
          	<td>委托日期</td>
          	<td><input class="readOnly" type="text" id="regDate" size="12" readOnly="true" /></td>
         </tr>
          <tr>
            <td colspan="6">
							<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('taskID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_taskID">&nbsp;</span>
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
  	<input class="button" type="button" id="close" name="close" value="终止执行" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="del" name="del" value="删除" />
  </div>
  
	<div style="width:99%;float:left;margin:10;height:4px;"></div>
	
	<div style="width:99%;float:left;margin:10;">
		<!--#include file="receiverListIncDetail.js"-->
	</div>
  
	<div style="width:99%;float:left;margin:10;height:4px;"></div>
	
	<div style="width:99%;float:left;margin:10;">
		<!--#include file="commentListIncDetail.js"-->
	</div>
	
</div>
</body>
