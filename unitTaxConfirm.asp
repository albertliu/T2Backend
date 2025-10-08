<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title></title>

<link href="css/style_inner1.css?v=1.3"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-2.1.1.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	let unitName = "";
	let taxNo = "";
	let username = "";
	let checker = "";
	let updateCount = 0;
	let re_unit = "";
	let re_tax = "";
	let address = "";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		unitName = "<%=item%>";
		taxNo = "<%=nodeID%>";
		username = "<%=refID%>";	//username
		address = "<%=where%>";	//
		$.ajaxSetup({ 
			async: false 
		});
		$("#unit").val(unitName);
		$("#tax").val(taxNo);
		$("#address").val(address);
		$("#save").click(function(){
			saveNode();
		});
		$("#tax").change(function(){
			if($("#tax").val()>""){
				if(!checkUSCI($("#tax").val())){
					alert("统一社会信用代码有误，请核对。");
				}
			}
		});
		if(taxNo>"" || unitName>""){
			getNodeInfo();
		}
	});

	function getNodeInfo(){
		$.post(uploadURL + "/public/postCommInfo", {proc:"checkUnitInfo", params:{taxNo, unitName}}, function(data){
			if(data.length > 0 && data[0]["re"] > 0){
				let ar = data[0];
				if(ar["re"] ===1 && unitName != ar["unitName"]){
					re_unit = ar["unitName"];
				}
				if(ar["re"] ===2 && taxNo != ar["taxNo"]){
					re_tax = ar["taxNo"];
				}
				$("#unit").val(ar["unitName"]);
				$("#tax").val(ar["taxNo"]);
				$("#checkerName").val(ar["checkerName"]);
				$("#address").val(ar["address"]);
				checker = ar["checkerName"];
				if(checker > ""){
					$("#checked").checkbox({checked:true});
				}else{
					$("#checked").checkbox({checked:false});
				}
				setButton();
			}
		});
	}
	
	function saveNode(){
		if($("#unit").val()==""){
			alert("请填写单位名称。");
			return false;
		}
		if($("#tax").val()==""){
			alert("请填写统一代码。");
			return false;
		}
		if(!checkUSCI($("#tax").val())){
			alert("统一社会信用代码有误，请核对。");
			return false;
		}
		$.messager.confirm('确认对话框', '要确认单位信息吗?', function(r) {
			if(r){
				$.post(uploadURL + "/public/postCommInfo", {proc:"setUnitTaxConfirm", params:{unitName:$("#unit").val(), taxNo:$("#tax").val(), address:$("#address").val(), username, registerID: currUser}}, function(data){
					let ar = data[0];
					re_unit = $("#unit").val();
					re_tax = $("#tax").val();
					$("#checked").checkbox({checked:true});
					$.messager.alert("提示","已审核。","info");
					updateCount += 1;
					$("#save").hide();
				});
			}
		});
	}
	
	function setButton(){
		$("#save").hide();
		if(checkPermission("checkUnitTax") && checker==""){
			$("#save").show();
		}
	}

	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div style="float:left;width:100%;">
		<div style="width:100%;margin:0;">
			<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
				<div class="comm" style="background:#f5faf8; float:left;width:100%;">
					<input type="hidden" id="experience" /><input type="hidden" id="bureau" />
					<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
					<table style="width:100%;">
					<tr>
						<td align="right">单位名称</td>
						<td><input type="text" id="unit" style="width:90%;" /></td>
					</tr>
					<tr>
						<td align="right">信用代码</td>
						<td>
							<input type="text" id="tax" style="width:90%;" />
						</td>
					</tr>
					<tr>
						<td align="right">单位地址</td>
						<td>
							<input type="text" id="address" style="width:90%;" />
						</td>
					</tr>
					<tr>
						<td align="right">审核人</td>
						<td>
							<input class="readOnly" type="text" id="checkerName" size="12" readOnly="true" />&nbsp;&nbsp;&nbsp;&nbsp;
							<input class="easyui-checkbox" id="checked" value="1" />&nbsp;已审核
						</td>
					</tr>
					</table>
					</form>
				</div>
			</div>
		</div>

		<div style="width:100%;float:left;margin:10;height:4px;"></div>
		<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;clear:both;">
			<input class="button" type="button" id="save" value="审核" />
		</div>

	</div>
</div>
</body>
