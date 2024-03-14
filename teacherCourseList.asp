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
	var refID = "";
	var item = "";
	var kindID = 1;
	
	$(document).ready(function (){
		refID = "<%=refID%>";
		item = "<%=item%>";
		kindID = "<%=kindID%>";
		$("#item").html("<h2>课程列表：" + item + "</h2>");
		getTeacherCourseList();
		getCourseListByTeacher();
	});
	
	function getCourseListByTeacher(){
		$.get("userControl.asp?op=getCourseListByTeacher&refID=" + refID + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//alert(ar);
			$("#userListCover").empty();
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='userListTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='10%'>No</th>");
			arr.push("<th width='40%'>课程</th>");
			arr.push("<th width='10%'>&nbsp;</th>");
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
					arr.push("<td width='40%' class='left'>" + ar1[1] + "</td>");
					if(kindID==1){
						arr.push("<td width='10%' class='link1'><a href='javascript:doAddUser(\"" + ar1[0] + "\");'><img src='images/add.png' border='0' title='选中'></a></td>");
					}else{
						arr.push("<td width='10%' class='link1'>&nbsp;</td>");
					}
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
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
	
	function getTeacherCourseList(){
		$.get("userControl.asp?op=getTeacherCourseList&refID=" + refID + "&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			//alert(ar);
			$("#taskUserCover").empty();
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='taskUserTab' width='95%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='10%'>No</th>");
			arr.push("<th width='40%'>课程</th>");
			arr.push("<th width='10%'>&nbsp;</th>");
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
					arr.push("<td width='40%' class='left'>" + ar1[1] + "</td>");
					if(kindID==1){
						arr.push("<td width='10%' class='link1'><a href='javascript:doRemoveUser(\"" + ar1[0] + "\");'><img src='images/remove.png' border='0' title='撤销'></a></td>");
					}else{
						arr.push("<td width='10%' class='link1'>&nbsp;</td>");
					}
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#taskUserCover").html(arr.join(""));
			arr = [];
			$('#taskUserTab').dataTable({
				"aaSorting": [],
				"bLengthChange": false,
				"aLengthMenu": [[15, 25, 30, -1], [15, 25, 30, "All"]],
				"bFilter": false,
				"aoColumnDefs": []
			});
		});
	}

	function doAddUser(user){
		$.get("userControl.asp?op=addCourse2Teacher&refID=" + refID + "&nodeID=" + user + "&times=" + (new Date().getTime()),function(re){
			if(re>""){
				getTeacherCourseList();
				getCourseListByTeacher();
			}
		});
	}

	function doRemoveUser(nodeID){
		jConfirm("确实要退出该课程吗？","确认对话框",function(r){
			if(r){
				$.get("userControl.asp?op=removeCourse4Teacher&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
					if(re>""){
						getTeacherCourseList();
						getCourseListByTeacher();
					}
				});
			}
		});
	}
</script>

</head>

<body>
<div id='layout' style="width:99%;float:left;margin:0;">	
	<div id="item" class="comm"></div>
	
	<div style="width:48%;float:left;margin:2;">
		<div style="color:orange;margin:0;padding:5px;text-align:center;">未分配课程</div>
		<div style="border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div id="userListCover" style="float:top;margin:3px;background:#f8fff8;">
			</div>
		</div>
	</div>
	<div style="width:48%;float:right;margin:2;">
		<div style="color:orange;margin:0;padding:5px;text-align:center;">已分配课程</div>
		<div style="border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div id="taskUserCover" style="float:top;margin:3px;background:#f8fff8;">
			</div>
		</div>
	</div>
</div>
</body>
