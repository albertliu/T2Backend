<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link rel="stylesheet" type="text/css" href="css/comment.css">
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>

<script language="javascript">
	var userName = "";
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		getUserList();
	});
	
	function getUserList(){
		$.get("userControl.asp?op=getUserList&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//alert(ar);
			$("#userListCover").empty();
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='userListTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='10%'>No</th>");
			arr.push("<th width='40%'>用户名</th>");
			arr.push("<th width='30%'>姓名</th>");
			arr.push("<th width='20%'>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='10%' class='left'>" + i + "</td>");
					arr.push("<td width='40%' class='left'>" + ar1[0] + "</td>");
					arr.push("<td width='30%' class='left'>" + ar1[1] + "</td>");
					arr.push("<td width='20%' class='link1'><a href='javascript:doAddUser(\"" + ar1[0] + "\",\"" + ar1[1] + "\");'><img src='images/add.png' border='0' title='选中'></a></td>");
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#userListCover").html(arr.join(""));
			arr = [];
			$('#userListTab').dataTable({
				"aaSorting": [],
				"bLengthChange": false,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": true,
				"aoColumnDefs": []
			});
		});
	}

	function doAddUser(userID,userName){
		$("#userName").val(userID);
		$("#realName").val(userName);
		setSession("pickUser",userID);
	}
</script>

</head>

<body>
<div id='layout' style="width:99%;float:left;margin:0;">	
	<div id="item" style="color:blue;margin:0;padding:5px;"></div>
	
	<div style="margin:2;"><input id="userName" name="userName" type="hidden" />
		&nbsp;&nbsp;选中的用户：<input class="readOnly" type="text" id="realName" name="realName" size="20" readOnly="true" />
	</div>
	<hr size="1" color="#c0c0c0" noshadow>
	<div style="margin:2;">
		<div style="color:orange;margin:0;padding:5px;text-align:center;">所有用户</div>
		<div style="border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div id="userListCover" style="margin:3px;background:#f8fff8;">
			</div>
		</div>
	</div>
</div>
</body>
