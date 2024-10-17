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
<script src="js/jQuery.print.js" type="text/javascript"></script>
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

		$("#print").click(function(){
			resumePrint();
		});
		getClassStudyOnlineList();
	});

	function getClassStudyOnlineList(){
		$.post(uploadURL + "/public/postCommInfo", {proc:"getClassStudyOnline", params:{classID:nodeID, mark:keyID}}, function(data){
			//alert(unescape(data));
			let i = 0;
			let j = 0;
			let c = 0;
			let imgChk = "<img src='images/green_check.png' />";
			$("#cover").empty();
			arr = [];					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='10'>No</th>");
			arr.push("<th width='150'>身份证</th>");
			arr.push("<th width='120'>姓名</th>");
			arr.push("<th>在线课程</th>");
			arr.push("<th>完成课时</th>");
			arr.push("<th>练习次数</th>");
			arr.push("<th>合格数</th>");
			arr.push("<th>合格率</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(data>""){
				$.each(data,function(iNum,val){
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td>" + i + "</td>");
					arr.push("<td align='center'>" + val["username"] + "</td>");
					arr.push("<td align='left'>" + val["name"] + "</td>");
					arr.push("<td align='left'><a href='javascript:showCompletionList(" + val["enterID"] + ",0,0,0);'>" + val["completion"] + "%</a></td>");
					arr.push("<td align='left'>" + val["completion_hours"] + "</td>");
					arr.push("<td align='left'><a style='text-decoration: none;' href='javascript:showExamList(" + val["enterID"] + ",\"" + val["name"] + "\");'>" + val["examTimes"] + "</a></td>");
					arr.push("<td align='left'>" + val["goodTimes"] + "</td>");
					arr.push("<td align='left'>" + val["goodRate"] + "%</td>");
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

	function resumePrint(){
		$("#resume_print").print({
			//Use Global styles
			globalStyles : true,
			//Add link with attrbute media=print
			mediaPrint : false,
			//Custom stylesheet
			stylesheet : "",
			//Print in a hidden iframe
			iframe : true,
			//Don't print this
			noPrintSelector : ".no-print",
			//Add this at top
			prepend : "",
			//Add this on bottom
			append : "<br/>"
		});
		window.setTimeout(function () {
			window.parent.$.close("class_checkin");
		}, 1000);
	}

</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div id="pageTitle" style="text-align:center;">
		<input class="button" type="button" id="print" value="打印" />&nbsp;
	</div>
	<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
		<div style='text-align:center; margin:10px 0 10px 0;'><h3 style='font-size:1.8em;'>班级在线学习情况统计表</h3></div>
		<div id="cover" style="float:top;background:#f8fff8;">
		</div>
	</div>
</div>
</body>
