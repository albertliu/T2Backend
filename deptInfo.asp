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
		
		getDicList("student","kindID",0);
		getDicList("statusEffect","status",0);
		getDicList("statusNo","c555",0);
		
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
			$.messager.confirm("确认","确定要删除该部门吗？",function(r){
				if(r){
					$.messager.prompt('信息记录', '请填写删除原因:', function(r){
						if (r.length > 1){
							$.get("deptControl.asp?op=delNode&nodeID=" + $("#deptID").val() + "&item=" + escape(r) + "&times=" + (new Date().getTime()),function(re){
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
		
		$("#btnAdd").click(function(){
			op = 1;
			refID = nodeID;	//添加下级部门
			setButton();
		});
	});

	function getNodeInfo(id){
		$.get("deptControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#deptID").val(ar[0]);
				$("#pID").val(ar[1]);
				$("#deptName").val(ar[2]);
				$("#kindID").val(ar[3]);
				$("#status").val(ar[4]);
				$("#linker").val(ar[7]);
				$("#phone").val(ar[8]);
				$("#email").val(ar[9]);
				$("#address").val(ar[10]);
				$("#host").val(ar[11]);
				$("#memo").val(ar[12]);
				$("#regDate").val(ar[13]);
				$("#registerName").val(ar[15]);
				$("#No").val(ar[16]);
				$("#area").val(ar[17]);
				$("#c555").val(ar[18]);
				
				if(ar[11] !== "spc"){
					$("#kindID").hide();
				}
				//getDownloadFile("deptID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		//alert($("#deptID").val() + "&item=" + ($("#memo").val()));
		if($("#deptName").val()==""){
			jAlert("部门名称不能为空。");
			return false;
		}
		if($("#pID").val()=="" || $("#pID").val()==0){
			jAlert("上级部门缺失，请重新添加。");
			return false;
		}
		$.get("deptControl.asp?op=update&nodeID=" + $("#deptID").val() + "&refID=" + $("#pID").val() + "&deptName=" + escape($("#deptName").val()) + "&linker=" +  escape($("#linker").val()) + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&host=" + $("#host").val() + "&phone=" +  escape($("#phone").val()) + "&email=" + escape($("#email").val()) + "&address=" + escape($("#address").val()) + "&No=" + $("#No").val() + "&area=" + escape($("#area").val()) + "&c555=" + $("#c555").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				updateCount += 1;
				//if(op == 1){
					//op = 0;
					//getNodeInfo(ar[1]);
					alert("保存成功！","信息提示");
					window.parent.$.close("dept");
				//}
				//jAlert("保存成功！","信息提示");
			}
			if(ar[0] != 0){
				jAlert("未能成功提交，请退出后重试。","信息提示");
			}
		});
		//return false;
	}
	
	function setButton(){
		$("#btnSave").hide();
		$("#btnAdd").hide();
		$("#btnDel").hide();
		if(checkPermission("deptAdd")){
			$("#btnSave").show();
			$("#btnAdd").show();
			$("#btnDel").show();
		}
		if(op ==1){
			setEmpty();
			$("#btnAdd").hide();
			$("#btnDel").hide();
		}
	}
	
	function setEmpty(){
		nodeID = 0;
		$("#pID").val(refID);
		$("#deptID").val(0);
		$("#deptName").val("");
		$("#status").val(0);
		$("#linker").val("");
		$("#phone").val("");
		$("#email").val("");
		$("#address").val("");
		$("#c555").val(0);
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
				<td align="right">编号</td><input id="pID" type="hidden" /><input id="host" type="hidden" />
				<td><input type="text" class="readOnly" id="deptID" size="25" readOnly="true" /></td>
				<td align="right">部门名称</td>
				<td><input type="text" id="deptName" size="25" /></td>
			</tr>
			<tr>
				<td align="right">类型</td>
				<td><select id="kindID" style="width:100px;"></select></td>
				<td align="right">状态</td>
				<td><select id="status" style="width:100px;"></select></td>
			</tr>
			<tr>
				<td align="right">联系人</td>
				<td><input type="text" id="linker" size="25" /></td>
				<td align="right">地址</td>
				<td><input type="text" id="address" size="25" /></td>
			</tr>
			<tr>
				<td align="right">电话</td>
				<td><input type="text" id="phone" size="25" /></td>
				<td align="right">邮箱</td>
				<td><input type="text" id="email" size="25" /></td>
			</tr>
			<tr>
				<td align="right">内部编号</td>
				<td><input type="text" id="No" size="25" /></td>
				<td align="right">所属区</td>
				<td><input type="text" id="area" size="25" /></td>
			</tr>
			<tr>
				<td align="right">超龄取证</td>
				<td colspan="3"><select id="c555" style="width:100px;"></select>&nbsp;*55岁-60岁可取得施工作业上岗证</td>
			</tr>
			<tr>
				<td align="right">说明</td>
				<td colspan="3"><input type="text" id="memo" style="width:100%;" /></td>
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
  	<input class="button" type="button" id="btnAdd" value="添加下级" />&nbsp;
  	<input class="button" type="button" id="btnDel" value="删除" />&nbsp;
  </div>
</div>
</body>
