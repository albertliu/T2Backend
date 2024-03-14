<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.2"  rel="stylesheet" type="text/css" />
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
<script type="text/javascript" src="js/asyncbox.v1.5.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script src="js/jQuery.print.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>

<script language="javascript">
	var nodeID = 0;
	var refID = "";
	var updateCount = 1;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//classID
		keyID = "<%=keyID%>";		//0 预览  1 打印
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});
		getNodeInfo(nodeID);
	});

	function getNodeInfo(id){
		$.get("diplomaControl.asp?op=getGenerateApplyNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			var x = 0;
            var qty = 0;
			if(ar > ""){
				refID = ar[1];
				$("#applyID").html(ar[5]);
				$("#class_title").html(ar[3]);
				$("#home_certName").html(ar[2]);
				$("#home_reexamine").html(ar[24]);
				$("#home_adviser").html(ar[46]);
				$("#home_startDate").html(ar[6] + "&nbsp;至&nbsp;" + ar[38]);

				$.get("diplomaControl.asp?op=getStudentListByClassID&refID=" + nodeID + "&times=" + (new Date().getTime()),function(data2){
					//alert(unescape(data));
					var ar4 = new Array();
					ar4 = (unescape(data2)).split("%%");
					var arr2 = [];	

					arr2.push("<table cellpadding='0' cellspacing='0' border='1' width='100%'>");
					arr2.push("<tr align='center'>");
					arr2.push("<td align='center' width='6%' height='35px'>序号</td>");
					arr2.push("<td align='center' width='10%'>姓名</td>");
					arr2.push("<td align='center' width='6%'>性别</td>");
					arr2.push("<td align='center' width='18%'>证件号码</td>");
					arr2.push("<td align='center' width='14%'>标准课时</td>");
					arr2.push("<td align='center' width='24%'>完成率%</td>");
					arr2.push("<td align='center' width='14%'>完成课时</td>");
					arr2.push("</tr>");
					var i = 0;
					
					if(ar4>""){
						$.each(ar4,function(iNum,val){
							var ar6 = new Array();
							ar6 = val.split("|");
							i += 1;
							arr2.push("<tr>");
							arr2.push("<td align='center' height='35px'>" + i + "</td>");
							arr2.push("<td align='center'>" + ar6[1] + "</td>");
							arr2.push("<td align='center'>" + ar6[2] + "</td>");
							arr2.push("<td align='center'>" + ar6[0] + "</td>");
							arr2.push("<td align='center'>" + ar6[3] + "</td>");
							arr2.push("<td align='center'>" + nullNoDisp(ar6[4]) + "</td>");
							arr2.push("<td align='center'>" + nullNoDisp(ar6[5]) + "</td>");
							arr2.push("</tr>");
						});
					}
					arr2.push("</table>");
					$("#onlineCover").html(arr2.join(""));

					if(keyID==1){
						resumePrint();
					}
				});
			}else{
				//alert("没有找到要打印的内容。");
				return false;
			}
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
			//window.parent.getStudentCourseList(refID);
			window.parent.$.close("generateApply");
		}, 1000);
	}

	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="text-align:center;">
			<input class="button" type="button" id="print" value="打印" />&nbsp;
		</div>
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;padding-left:20px;">
			<div style='text-align:center; margin:150px 0 0 0;'><h3 style='font-size:3em;'>班级管理表册</h3></div>
			<table style="margin:300px 0 0 40px; width:85%;">
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">培训机构</td><td style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="class_unit"></td><td style="width:5%; text-align:left; vertical-align: bottom; font-size:1.8em;">（章）</td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">班级名称</td><td colspan="2" style="width:65%; border-bottom: #333333 1px solid; font-size:1.7em; vertical-align: bottom; padding-left:15px;" id="class_title"></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">开班编号</td><td colspan="2" style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="applyID"></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">培训职业</td><td colspan="2" style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_certName"></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">培训等级</td><td colspan="2" style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_reexamine"></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">班&nbsp;主&nbsp;任</td><td colspan="2" style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_adviser"></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">起迄日期</td><td colspan="2" style="width:65%; border: 0px; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_startDate"></td>
			</tr>
			</table>

			<div style="page-break-after:always">&nbsp;</div>

			<div style='text-align:center; margin:10px 0 50px 0;'><h3 style='font-size:1.8em;'>文档目录</h3></div>
			<div style="float:center; margin:15px; font-size:1.2em;">
				<ul>
					<li>1. 学员报名表</li>
					<li>2. 课程表</li>
					<li>3. 学员签到表</li>
					<li>4. 在线学习统计表</li>
					<li>5. 学员评议反馈表</li>
					<li>6. 培训证明（存根）</li>
					<li>7. 考试报名汇总表</li>
				</ul>
			</div>

			<div style="page-break-after:always">&nbsp;</div>

			<div style='text-align:center; margin:10px 0 0 0;'><h3 style='font-size:1.8em;' id='title_onlineList'>在线学习课时统计</h3></div>
			<div id="onlineCover" style="float:center; margin:15px; font-size:1.2em;"></div>

		</div>
	</div>
</div>
</body>
