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
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var keyID = 0;
	var updateCount = 1;
	<!--#include file="js/commFunction.js"-->
	<!--#include file="need2know.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//0 预览  1 打印
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});
		getNeed2know(nodeID);
		getNodeInfo(nodeID, refID);
});

	function getNodeInfo(id,ref){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > "0"){
				$("#SNo").html(ar[25] + "&nbsp;&nbsp;班级：" + ar[34]);
			}else{
				//alert("没有找到要打印的内容。");
				return false;
			}
		});
		$.get("studentControl.asp?op=getNodeInfo&nodeID=0&refID=" + ref + "&times=" + (new Date().getTime()),function(re){
			//alert(ref + ":" + unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#username").html(ar[1]);
				$("#name").html(ar[2]);
				$("#sexName").html(ar[8]);
				$("#mobile").html(ar[7]);
				$("#age").html(ar[9]);
				$("#phone").html(ar[17]);
				$("#job").html(ar[18]);
				if(ar[29]=="znxf"){
					$("#company").html(ar[35]);
					$("#dept2").html(ar[36]);
				}else{
					$("#company").html(ar[12] + " ." + ar[13]);
					$("#dept2").html(ar[14]);
				}
				$("#educationName").html(ar[31]);
				$("#birthday").html(ar[33]);
				$("#address").html(ar[34]);
				if(ar[21] > ""){
					$("#img_photo").attr("src","/users" + ar[21]);
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
				}
				if(ar[22] > ""){
					$("#img_cardA").attr("src","/users" + ar[22]);
				}else{
					$("#img_cardA").attr("src","images/blank_cardA.png");
				}
				//$("#date").html(currDate);
				if(keyID==1){
					resumePrint();
				}
			}else{
				alert("没有找到要打印的内容。");
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
			//window.parent.asyncbox.close("enterInfo");
			window.parent.getStudentCourseList(refID);
			window.parent.$.close("enterInfo");
			//refreshMsg();
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
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style='margin: 20px;text-align:center;'><h2 style='font-size:1.3em;'>上海智能消防学校</h2></div>
			<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>消防安全责任人培训报名表</h3></div>
			<div style='margin: 12px;text-align:left; width:95%;'><span style='font-size:1.2em;'>学员编号：</span><span style='font-size:1.2em;' id="SNo"></span></div>
			<table class='table_resume' style='width:100%;'>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>姓名</td><td align="center" width='15%'><p style='font-size:1em;' id="name"></p></td>
				<td align="center" class='table_resume_title' width='13%'>性别</td><td align="center" width='13%'><p style='font-size:1em;' id="sexName"></p></td>
				<td align="center" class='table_resume_title' width='13%'>籍贯</td><td class='table_resume_title' width='11%'></td>
				<td rowspan="4" colspan="2" align="center" class='table_resume_title' width='20%'>
					<img id="img_photo" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>出生日期</td><td align="center" width='13%'><p style='font-size:1em;' id="birthday"></p></td>
				<td align="center" class='table_resume_title' width='13%'>年龄</td><td align="center" width='13%'><p style='font-size:1em;' id="age"></p></td>
				<td align="center" class='table_resume_title' width='13%'>学历</td><td class='table_resume_title' width='11%'><p style='font-size:1em;' id="educationName"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>身份证号</td><td align="center" colspan="3"><p style='font-size:1em;' id="username"></p></td>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>领导姓名</td><td align="center" width='13%'></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='13%' height='55px;'>单位电话</td><td align="center" width='13%' colspan="2"><p style='font-size:1em;' id="phone"></p></td>
				<td align="center" class='table_resume_title' width='13%'>本人手机</td><td class='table_resume_title' width='13%' colspan="2"><p style='font-size:1em;' id="mobile"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>工作单位</td><td align="center" colspan="3"><p style='font-size:1em;' id="company"></p></td>
				<td align="center" class='table_resume_title' width='13%'>单位地址</td><td align="center" colspan="3"><p style='font-size:1em;' id="address"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>工作部门</td><td align="center" width='13%'><p style='font-size:1em;' id="dept2"></p></td>
				<td align="center" class='table_resume_title' width='13%'>从事工作</td><td align="center" width='13%'><p style='font-size:1em;' id="job"></p></td>
				<td align="center" class='table_resume_title' width='13%'>职务</td><td class='table_resume_title' width='13%'></td>
				<td align="center" class='table_resume_title' width='10%'>职称</td><td class='table_resume_title' width='10%'></td>
			</tr>
			<tr>
				<td style="text-align:left;" class='table_resume_title' height='55px;' colspan="2"><div style="float: left;padding-left:10px;padding-top:10px;font-size:1em;">单位盖章处<div></td>
				<td align="center" class='table_resume_title' width='15%' height='300px;' colspan="6">
					<img id="img_cardA" src="" value="" style='disply:block;width:350px;height:auto;max-height:250px;border:none;' />
				</td>
			</tr>
			</table>
			<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>&bull; 提交1张2寸免冠彩色照片。</p></div>
			<div style='margin: 12px;text-align:right; width:95%; padding-right:100px;'><p style='font-size:1.3em;'>学员签名：</p></div>
			<div style='margin: 12px;text-align:right; width:95%;'><p id="date" style='font-size:1.3em;'></p></div>
			<div style="page-break-after:always"></div>
			<div id="needCover"></div>
		</div>
	</div>
  </div>
</div>
</body>
