<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.1"  rel="stylesheet" type="text/css" />
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
		$("#studentName").html(refID);
		
		$.ajaxSetup({ 
			async: false 
		}); 

		getStudentExamByEnterID();
	});

	function getStudentExamByEnterID(){
		$.get("examControl.asp?op=getStudentExamByEnterID&refID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#score").html(ar[2] + " (及格线" + ar[3] + ")");
				$("#startDate").html(ar[4]);
				$("#endDate").html(ar[5]);
				$("#statusName").html(ar[6]);
				$("#username").html(ar[7]);
				getStudentQuestionList(ar[0]);
			}else{
				alert("该试卷未找到！请核实是否为在线考试。","信息提示");
			}
		});
	}

	function getStudentQuestionList(paperID){
		//alert(paperID);
		$.get("examControl.asp?op=getStudentQuestionList&refID=" + paperID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];					
			if(ar>""){
				var t_check = "";
				var t_none = "";
				var ck = "";

				arr.push("<ol>");
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");

					if(ar1[0] == 2){
						t_check = "<input style='border:0px;' type='checkbox' checked />";
						t_none = "<input style='border:0px;' type='checkbox' />";
					}else{
						t_check = "<input style='border:0px;' type='radio' checked />";
						t_none = "<input style='border:0px;' type='radio' />";
					}

					if(ar1[4]==ar1[5]){
						ck = "images/check_right.png";
					}else{
						ck = "images/check_wrong.png";
					}

					arr.push("<li>" + ar1[1] + "（" + ar1[2] + "分）<img style='border:0; width:20px;' src='" + ck + "' /> 正确答案：" + ar1[4]);
					arr.push("<ul>");
					if(ar1[5].indexOf("A")==-1){
						arr.push("<li>" + t_none + " A. " + ar1[6] + "</li>");
					}else{
						arr.push("<li>" + t_check + " A. " + ar1[6] + "</li>");
					}
					if(ar1[5].indexOf("B")==-1){
						arr.push("<li>" + t_none + " B. " + ar1[7] + "</li>");
					}else{
						arr.push("<li>" + t_check + " B. " + ar1[7] + "</li>");
					}
					if(ar1[8]>""){
						if(ar1[5].indexOf("C")==-1){
							arr.push("<li>" + t_none + " C. " + ar1[8] + "</li>");
						}else{
							arr.push("<li>" + t_check + " C. " + ar1[8] + "</li>");
						}
					}
					if(ar1[9]>""){
						if(ar1[5].indexOf("D")==-1){
							arr.push("<li>" + t_none + " D. " + ar1[9] + "</li>");
						}else{
							arr.push("<li>" + t_check + " D. " + ar1[9] + "</li>");
						}
					}
					if(ar1[10]>""){
						if(ar1[5].indexOf("E")==-1){
							arr.push("<li>" + t_none + " E. " + ar1[10] + "</li>");
						}else{
							arr.push("<li>" + t_check + " E. " + ar1[10] + "</li>");
						}
					}
					if(ar1[11]>""){
						if(ar1[5].indexOf("F")==-1){
							arr.push("<li>" + t_none + " F. " + ar1[11] + "</li>");
						}else{
							arr.push("<li>" + t_check + " F. " + ar1[11] + "</li>");
						}
					}
				arr.push("</ul>");
					arr.push("</li>");
				});
				arr.push("</ol>");
				$("#cover").html(arr.join(""));
				arr = [];
			}
		});
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;" id="detailCover">
			<table>
				<tr>
					<td align="left" style="width:10%;">学员姓名：</td>
					<td style="width:20%;"><p id="studentName"></p></td>
					<td align="left" style="width:10%;">身份证：</td>
					<td style="width:55%;"><p id="username"></p></td>
				</tr>
				<tr>
					<td align="left">状态：</td>
					<td><p id="statusName"></p></td>
					<td align="left">得分：</td>
					<td><p id="score"></p></td>
				</tr>
				<tr>
					<td align="left">开始时间：</td>
					<td><p id="startDate"></p></td>
					<td align="left">交卷时间：</td>
					<td><p id="endDate"></p></td>
				</tr>
			</table>
			</div>
		</div>
	</div>
	
	<hr size="1" noshadow />
	<div id="cover" style="float:top;margin:3px;background:#f8fff8;">
	</div>
  </div>
</div>
</body>
