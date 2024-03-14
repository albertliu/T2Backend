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
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
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
		op = <%=op%>;

		getDicList("workLogKind","kindID",0);
		getDicList("private","",0);
		getComList("engineeringID","engineeringInfo","ID","item","status>0",1);
		$("#keyDate").click(function(){WdatePicker();});
		
    $.ajaxSetup({ 
  		async: false 
  	}); 
		if(op==1){
			$("#private").val(1);
			$("#kindID").val(2);
			setButton();
		}
		if(op!=1){
			getNodeInfo(nodeID);
		}
		
		$("#kindID").change(function(){
			if($("#kindID").val()==0){
				$("#engineeringID").attr("disabled",true);
				$("#projectID").attr("disabled",true);
				$("#engineeringID").val("");
				$("#projectID").val("");
			}
			if($("#kindID").val()==1){
				$("#engineeringID").attr("disabled",false);
				$("#projectID").attr("disabled",true);
				$("#projectID").val("");
				$("#engineeringID").focus();
			}
			if($("#kindID").val()==2){
				$("#engineeringID").attr("disabled",false);
				$("#projectID").attr("disabled",false);
				$("#engineeringID").change();
				$("#engineeringID").focus();
			}
		});
		
		$("#engineeringID").change(function(){
			if($("#kindID").val()==2 && $("#engineeringID").val()>0){
				getComList("projectID","projectInfo","ID","item","engineeringID=" + $("#engineeringID").val() + " and status>0",1);
			}
		});

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
					$.get("memoControl.asp?op=delNode&nodeID=" + $("#memoID").val() + "&times=" + (new Date().getTime()),function(data){
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
		//alert(id);
		$.get("workLogControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#workLogID").val(ar[0]);
				$("#item").val(ar[1]);
				$("#status").val(ar[2]);
				$("#statusName").val(ar[3]);
				$("#userName").val(ar[4]);
				$("#userRealName").val(ar[5]);
				$("#keyDate").val(ar[6]);
				$("#kindID").val(ar[7]);
				if(ar[7]==0){
					$("#engineeringID").val("");
					$("#projectID").val("");
				}
				if(ar[7]==1){
					$("#engineeringID").val(ar[9]);
					$("#projectID").val("");
				}
				if(ar[7]==2){
					$("#engineeringID").val(ar[9]);
					getComList("projectID","projectInfo","ID","item","engineeringID=" + ar[9] + " and status>0",1);
					$("#projectID").val(ar[11]);
				}
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#regOperator").val(ar[15]);
				$("#registorName").val(ar[16]);
				$("#private").val(ar[17]);
				$("#refID").val(ar[19]);
				getDownloadFile("workLogID");
				setButton();
			}else{
				jAlert("该日志信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(status){
		var eID = 0;
		var pID = 0;
		if($("#kindID").val()==1){
			eID = $("#engineeringID").val();
		}
		if($("#kindID").val()==2){
			eID = $("#engineeringID").val();
			pID = $("#projectID").val();
		}
		if(status==""){
			status = $("#status").val();
		}
		//alert($("#workLogID").val() + "&pCode=" + $("#pCode").val() + "&item=" + ($("#item").val()) + "&title=" + ($("#title").val()) + "&type=" + $("#type").val() + "&kind=" + $("#kind").val() + "&status=" + $("#status").val() + "&engineeringID=" + $("#engineeringID").val() + "&dateStart=" + $("#dateStart").val() + "&dateEnd=" + $("#dateEnd").val() + "&memo=" + ($("#memo").val()) + "&mark=" + ($("#mark").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + ($("#regOperator").val()));
		$.get("workLogControl.asp?op=update&nodeID=" + $("#workLogID").val() + "&item=" + escape($("#item").val()) + "&status=" + status + "&keyDate=" + $("#keyDate").val() + "&userName=" + escape($("#userName").val()) + "&kindID=" + $("#kindID").val() + "&engineeringID=" +eID + "&projectID=" + pID + "&private=" + $("#private").val() + "&refID=" + $("#refID").val() + "&memo=" + escape($("#memo").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
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
				jAlert("项目名称不能为空。","信息提示");
				$("#item").focus();
			}
			if(ar[0] == 3){
				jAlert("请选择一个工程。","信息提示");
				$("#engineeringID").focus();
			}
			if(ar[0] == 4){
				jAlert("请选择一个项目。","信息提示");
				$("#projectID").focus();
			}
		});
		return false;
	}
	
	function setButton(){
		//alert(op + ":" + $("#regOperator").val() + ":" + $("#memoID").val());
		$("#status").attr("disabled",true);
		$("#kindID").attr("disabled",true);
		$("#close").hide();
		if(op ==1){
			setEmpty();
			$("#save").show();
			$("#del").hide();
			$("#btnLoadFile").attr("disabled",true);
			$("#kindID").attr("disabled",false);
			$("#item").focus();
		}
		if(op ==0){
			if($("#regOperator").val() == currUser && $("#memoID").val()>0 && $("#status").val()==0){
				$("#save").show();
				$("#del").show();
				$("#close").show();
				$("#kindID").attr("disabled",false);
				$("#btnLoadFile").attr("disabled",false);
			}else{
				$("#save").hide();
				$("#del").hide();
				$("#btnLoadFile").attr("disabled",true);
			}
		}
		if($("#kindID").val()==0){
			$("#engineeringID").attr("disabled",true);
			$("#projectID").attr("disabled",true);
		}
	}
	
	function setEmpty(){
		$("#workLogID").val(0);
		$("#status").val(0);
		$("#statusName").val("活动");
		$("#item").val("");
		//$("#kindID").val("");
		//$("#engineeringID").val(0);
		//$("#projectID").val(0);
		$("#keyDate").val(currDate);
		$("#userName").val(currUser);
		$("#userRealName").val(currUserName);
		$("#refID").val(0);
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_workLogID").html("");
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
          	<td>范围</td><input id="refID" type="hidden" />
          	<td><select id="private" style="width:100px"></select></td>
          	<td>标记日期</td>
          	<td><input type="text" id="keyDate" size="20" /></td>
          	<td>当事人</td><input id="userName" type="hidden" />
          	<td><input class="readOnly" type="text" id="userRealName" size="18" readOnly="true" /></td>
          </tr>
          <tr>
          	<td>标题</td><input id="workLogID" type="hidden" />
          	<td colspan="3"><input class="mustFill" type="text" id="item" size="60" /></td>
          	<td>状态</td><input id="status" type="hidden" />
          	<td><input class="readOnly" type="text" id="statusName" size="20" readOnly="true" /></td>
          </tr>
          <tr>
          	<td>类型</td>
          	<td><select id="kindID" style="width:100px"></select></td>
          	<td>工程</td>
          	<td><select id="engineeringID" style="width:100px"></select></td>
          	<td>项目</td>
          	<td><select id="projectID" style="width:100px"></select></td>
          </tr>
          </tr>
          	<td>内容</td>
          	<td colspan="5"><textarea id="memo" style="padding:2px;" rows="5" cols="95"/></textarea></td>
          <tr>
          <tr>
          	<td>登记日期</td>
          	<td><input class="readOnly" type="text" id="regDate" size="20" readOnly="true" /></td>
          	<td>登记人</td><input type="hidden" id="regOperator" />
          	<td><input class="readOnly" type="text" id="registorName" size="20" readOnly="true" /></td>
          	<td>&nbsp;</td>
          	<td>&nbsp;</td>
         </tr>
          <tr>
            <td colspan="6">
							<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('memoID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_memoID">&nbsp;</span>
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
