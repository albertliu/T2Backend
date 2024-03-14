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
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//学员姓名
		$("#studentName").val(refID);
		
		$.ajaxSetup({ 
			async: false 
		}); 

		getStudentExamStat();
	});

	function getStudentExamStat(){
		$.get("studentCourseControl.asp?op=getStudentExamStat&refID=" + nodeID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			//var ar0 = new Array();
			//ar0 = ar.shift().split("|");
			arr = [];		
			//arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='5%'>序号</th>");
			arr.push("<th width='10%'>提交日期</th>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='15%'>考试名称</th>");
			arr.push("<th width='12%'>知识点</th>");
			arr.push("<th width='6%'>类型</th>");
			arr.push("<th width='6%'>得分</th>");
			arr.push("<th width='6%'>题目数</th>");
			arr.push("<th width='6%'>正确数</th>");
			arr.push("<th width='6%'>正确率</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var h1 = "";
				var h2 = "";
				var j = 0;
				var score = 0;
				var qty = 0;
				var qtyYes = 0;
				var seq = 0;
				var n = 0;
				var lens = ar.length;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					j += 1;
					c = 0;
					n += 1;
					if(ar1[6] == seq){
						h = "";
						h1 = "";
						h2 = "";
					}else{
						if(n>1){
							//total row
							arr.push("<tr class='grade" + c + "'>");
							arr.push("<td class='left'></td>");
							arr.push("<td class='left'></td>");
							arr.push("<td class='center'>合计</td>");
							arr.push("<td class='left'></td>");
							arr.push("<td class='left'></td>");
							arr.push("<td class='left'></td>");
							arr.push("<td class='left'>" + nullNoDisp(score) + "</td>");
							arr.push("<td class='left'>" + nullNoDisp(qty) + "</td>");
							arr.push("<td class='left'>" + nullNoDisp(qtyYes) + "</td>");
							arr.push("<td class='left'>" + nullNoDisp(Math.round(qtyYes*10000/qty)/100) + "</td>");
							arr.push("</tr>");
						}
						i += 1;
						j = 1;
						h = ar1[6];
						h1 = ar1[0];
						h2 = i;
						seq = ar1[6];
						score = 0;
						qty = 0;
						qtyYes = 0;
					}
					score += parseInt(ar1[3]);
					qty += parseInt(ar1[4]);
					qtyYes += parseInt(ar1[5]);
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='left'>" + h2 + "</td>");
					arr.push("<td class='left'>" + h1 + "</td>");
					arr.push("<td class='center'>" + j + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + nullNoDisp(Math.round(ar1[5]*10000/ar1[4])/100) + "</td>");
					arr.push("</tr>");
					if(n == lens){
						//total row
						arr.push("<tr class='grade" + c + "'>");
						arr.push("<td class='left'></td>");
						arr.push("<td class='left'></td>");
						arr.push("<td class='center'>合计</td>");
						arr.push("<td class='left'></td>");
						arr.push("<td class='left'></td>");
						arr.push("<td class='left'></td>");
						arr.push("<td class='left'>" + nullNoDisp(score) + "</td>");
						arr.push("<td class='left'>" + nullNoDisp(qty) + "</td>");
						arr.push("<td class='left'>" + nullNoDisp(qtyYes) + "</td>");
						arr.push("<td class='left'>" + nullNoDisp(Math.round(qtyYes*10000/qty)/100) + "</td>");
						arr.push("</tr>");
					}
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
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
				"bInfo": true,
				"aoColumnDefs": []
			});
		});
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="left">学员姓名：</td>
				<td><input type="text" id="studentName" class="readOnly" readOnly="true" size="15" /></td>
				<td align="left"></td>
				<td>&nbsp;</td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<hr size="1" noshadow />
	<div id="cover" style="float:top;margin:3px;background:#f8fff8;">
	</div>
  </div>
</div>
</body>
