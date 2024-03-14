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

<script language="javascript">
	var card = window.parent.cardJson;
	var sel = window.parent.original_item;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#btnSel").click(function(){
			setSel("");
		});
		$("#btnClose").click(function(){
			window.parent.$.close("useCard");
		});
		getNodeInfo();
		$("#btnClose").hide();
	});

	function getNodeInfo(){
		$("#img_photo").attr("src","data:image/jpeg;base64,"+card.base64Data);
		$("#img_cardA").attr("src","data:image/jpeg;base64,"+card.imageFront);
		$("#img_cardB").attr("src","data:image/jpeg;base64,"+card.imageBack);
		if(sel > ""){
			var ar = new Array();
			ar = sel.split(",");
			$.each(ar,function(iNum,val){
				$(":checkbox[value='" + val + "']").prop("checked",true);
			});
		}
	}
	
	function getUpdateCount(){
		getSelCart("");
		
		return selCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<h3 style="margin:5px;">请选择替换现有资料：</h3>
	<input class="button" type="button" id="btnSel" value="全选/取消" />&nbsp;&nbsp;
	<input class="button" type="button" id="btnClose" value="确定" />&nbsp;&nbsp;
	<div style="padding: 5px;text-align:center;overflow:hidden;margin:0 auto;flot:right;">
		<table style="width:99%;">
			<tr>
				<td align="right" style="width:15%;"><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='photo' name='visitstockchk'></td>
				<td align="center" style="width:85%;">
					<img id="img_photo" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="right" style="width:15%;"><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='cardA' name='visitstockchk'></td>
				<td style="width:85%;">
					<img id="img_cardA" src="" style='width:200px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="right" style="width:15%;"><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='cardB' name='visitstockchk'></td>
				<td style="width:85%;">
					<img id="img_cardB" src="" style='width:200px;border:none;' />
				</td>
			</tr>
		</table>
	</div>
</div>
</body>
