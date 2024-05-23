<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css?v=1.8.6">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery-confirm.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.12.4.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js?v=1.8.6"></script>
<script src="js/jquery-confirm.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var keyID = "A";
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//classID
		refID = "<%=refID%>";
		keyID = "<%=keyID%>";	// mark: A apply, B class
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#btnDownload").click(function(){
			$.getJSON(uploadURL + "/outfiles/generate_excel?tag=class_schedule&mark=班级授课计划&classID=" + nodeID + "&pobj=" + refID + "&keyID=" + keyID ,function(data){
				if(data>""){
					asyncbox.alert("请点击此处<a href='" + data + "' target='_blank'>下载文件</a>",'课表',function(action){
					　　//alert 返回action 值，分别是 'ok'、'close'。
					　　if(action == 'ok'){
					　　}
					　　if(action == 'close'){
					　　　　//alert('close');
					　　}
					});
					//getNodeInfo(nodeID);
				}else{
					alert("没有可供处理的数据。");
				}
			});
		});
		getClassScheduleList();
	});

	function getClassScheduleList(){
		$.get("classControl.asp?op=getClassSchedule&refID=" + nodeID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='6%'>课次</th>");
			arr.push("<th width='12%'>上课日期</th>");
			arr.push("<th width='6%'>星期</th>");
			arr.push("<th width='6%'>时段</th>");
			arr.push("<th width='12%'>上课时间</th>");
			arr.push("<th width='6%'>课时</th>");
			arr.push("<th width='6%'>类型</th>");
			arr.push("<th width='10%'>授课教师</th>");
			arr.push("<th width='18%'>授课内容</th>");
			arr.push("<th width='6%'>形式</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + ar1[3] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showScheduleInfo(" + ar1[0] + ",\"" + ar1[2] + "\",0,1);'>" + ar1[9] + "</a></td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + ar1[15] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[14] + "</td>");
					arr.push("<td class='left'>" + ar1[16] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					arr.push("<td class='left'>" + ar1[22] + "</td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cover").html(arr.join(""));
			arr = [];
			$('#cardTab').dataTable({
				"aaSorting": [],
				"bFilter": false,
				"bPaginate": true,
				"bLengthChange": false,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 50,
				"bInfo": true,
				"aoColumnDefs": []
			});
		});
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div style='text-align:center; margin:10px 0 10px 0;'><h3 style='font-size:1.8em;'>授课计划表</h3></div>
	<div style='float:right; padding-right:50px;'><input class="button" type="button" id="btnDownload" value="下载" /></div>
	<div id="cover" style="float:top;background:#f8fff8;">
	</div>
</div>
</body>
