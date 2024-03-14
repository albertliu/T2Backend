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
	var refID = "";
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		setButton();
		getComList("host","hostInfo","hostNo","title","status=0 order by hostName",0);		
		if(op==0){
			getNodeInfo(nodeID);
		}
		$("#btnSave").click(function(){
			saveNode();
		});
		$("#btnAdd").click(function(){
			op = 1;
			setButton();
		});
		$("#btnDel").click(function(){
			$.messager.confirm("确认","确定要删除该单位吗？",function(r){
				if(r){
					$.messager.prompt('信息记录', '请填写删除原因:', function(r){
						if (r.length > 1){
							$.get("studentControl.asp?op=delGenerateStudentNode&nodeID=" + $("#ID").val() + "&item=" + escape(r) + "&times=" + (new Date().getTime()),function(re){
								updateCount += 1;
								getNodeInfo(nodeID);
								jAlert("删除成功。");
							});
						}else{
							jAlert("请认真填写删除原因。");
						}
					});
				}
			});
		});
		$("#upload1").click(function(){
			if($("#host").val()==""){
				jAlert("请选择一个公司。");
				return false;
			}
			showLoadFile("student_list",$("#ID").val(),"studentList",$("#host").val());
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("studentControl.asp?op=getGenerateStudentNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#item").val(ar[1]);
				$("#qty").val(ar[2]);
				$("#host").val(ar[3]);
				$("#memo").val(ar[7]);
				$("#regDate").val(ar[8]);
				$("#registerName").val(ar[9]);
				$("#upload1").html("上传");
				var c = "";
				if(ar[6] > ""){
					c += "<a href='/users" + ar[6] + "' target='_blank'>报名表</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;还未上传";}
				$("#photo").html(c);
				//getDownloadFile("generateStudentID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#host").val()==""){
			jAlert("请选择一个公司。");
			return false;
		}
		if($("#item").val()==""){
			jAlert("请填写标题。");
			return false;
		}
		if($("#qty").val()=="" || $("#qty").val()==0){
			jAlert("数量不能为0");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("studentControl.asp?op=updateGenerateStudent&nodeID=" + $("#ID").val() + "&item=" + escape($("#item").val()) + "&qty=" + $("#qty").val() + "&host=" + $("#host").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功！","信息提示");
				if(op==1){
					op = 0;
					nodeID = ar[1];
					getNodeInfo(nodeID);
				}
				updateCount += 1;
			}
		});
		return false;
	}
	
	function setButton(){
		$("#btnSave").hide();
		$("#btnAdd").hide();
		$("#btnDel").hide();
		$("#upload1").hide();
		if(checkPermission("studentAdd")){
			$("#btnSave").show();
			$("#btnAdd").show();
			$("#btnDel").show();
			$("#upload1").show();
		}
		if(op ==1){
			setEmpty();
			$("#btnAdd").hide();
			$("#btnDel").hide();
			$("#upload1").hide();
		}
	}
	
	function setEmpty(){
		nodeID = 0;
		$("#ID").val(0);
		$("#item").val("");
		$("#qty").val("0");
		$("#memo").val("");
		$("#regDate").val(currDate);
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
				<td align="right">标题</td><input type="hidden" id="ID" />
				<td><input type="text" class="mustFill" id="item" size="25" /></td>
				<td align="right">数量</td>
				<td><input type="text" id="qty" size="25" /></td>
			</tr>
			<tr>
				<td align="right">公司</td>
				<td><select id="host" style="width:150px;"></select></td>
				<td align="right">名单</td>
				<td>
					<span id="upload1" style="padding:3px;margin-left:10px;border:1px solid orange;"></span>
					<span id="photo" style="margin-left:10px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">导入日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
				<td align="right">操作人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
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
  	<input class="button" type="button" id="btnSave" value="保存" />&nbsp;
  	<input class="button" type="button" id="btnAdd" value="添加" />&nbsp;
  	<input class="button" type="button" id="btnDel" value="删除" />&nbsp;
  </div>
</div>
</body>
