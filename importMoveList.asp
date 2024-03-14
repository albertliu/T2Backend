<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>

<script language="javascript">
	var refID = "";
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		$("#item").html("<font color='red'>" + currUserName + "</font>导入的待转档记录");
   
    $("#delMoveBatch").click(function(){
    	getSelCart("vsk0");
    	if(selCount > 0){
				jConfirm("确定要将选中的" + selCount + "份转档数据删除吗?", "确认对话框", function(r) {
					if(r){
						$.get("archivesMoveControl.asp?op=delMoveBatch&refID=" + selList + "&times=" + (new Date().getTime()),function(data){
							getMoveList();
						});
					}
				});
    	}
    });   

		getMoveList();
	});
	
	function getMoveList(){
		var where = "status=0 and regOperator='" + currUser + "'";
		$.get("archivesMoveControl.asp?op=getMoveList&anyStr=" + escape(where) + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#listCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			var s = "<div>" + ar.shift() + "</div>";					
			s = "<table cellpadding='0' cellspacing='0' border='0' class='display' id='listTab' width='100%'>";
			s += "<thead>";
			s += "<tr align='center'>";
			s += "<th width='10%'>姓名</th>";
			s += "<th width='20%'>身份证号</th>";
			s += "<th width='10%'>位置</th>";
			s += "<th width='12%'>转档标识</th>";
			s += "<th width='10%'>去向</th>";
			s += "<th width='12%'>导入日期</th>";
			s += "<th width='18%'>备注</th>";
			s += "<th width='8%'>&nbsp;</th>";
			s += "</tr>";
			s += "</thead>";
			s += "<tbody>";
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					s += "<tr class='grade0'>";
					s += "<td width='10%' class='left'>" + ar1[1] + "</td>";
					s += "<td width='20%' class='left'>" + ar1[2] + "</td>";
					s += "<td width='10%' class='left'>" + ar1[3] + "</td>";
					s += "<td width='12%' class='left'>" + ar1[4] + "</td>";
					s += "<td width='10%' class='left'>" + ar1[5] + "</td>";
					s += "<td width='12%' class='left'>" + ar1[7] + "</td>";
					s += "<td width='18%' class='left'>" + ar1[17] + "</td>";
					s += "<td width='8%' class='left'><input type='checkbox' value='" + ar1[0] + "' name='vsk0'></td>";
					s += "</tr>";
				});
			}
			s += "</tbody>";
			s += "<tfoot>";
			s += "<tr>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "</tr>";
			s += "</tfoot>";
			s += "</table>";
			$("#listCover").html(s);
			$('#listTab').dataTable({
				"aaSorting": [],
				"bLengthChange": true,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aoColumnDefs": []
			});
		});
	}
</script>

</head>

<body>

<div id='layout' align='left'>	
	<div class="comm" style="background:#dddddd;"><h2><span id="item"></span></h2></div>
	<br>
  <div align="center" class="comm">
  	<input class="button" type="button" id="btnChk1" onClick="setSel('vsk0');" value="全选/取消" />&nbsp;
  	<input class="button" type="button" id="delMoveBatch" value="删除" />
  </div>
  <hr color="#c0c0c0" noshadow>
	
	<div style="width:99%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div id="listCover" style="float:top;margin:3px;background:#f8fff8;">
			</div>
		</div>
	</div>
</div>
</body>
