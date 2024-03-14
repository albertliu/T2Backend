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
				$("#reexamine").html(ar[41]);
				$("#courseName").html(ar[6]);
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
				$("#mobile").html(ar[7] + "&nbsp;&nbsp;" + ar[17]);
				$("#age").html(ar[9]);
				$("#job").html(ar[18]);
				//$("#phone").html(ar[17]);
				$("#job").html(ar[18]);
				if(ar[29]=="znxf"){
					$("#company").html(ar[35] + "." + ar[36]);
					//$("#dept2").html(ar[36]);
				}else{
					$("#company").html(ar[12] + "." + ar[13] + "." + ar[14]);
					//$("#dept2").html(ar[14]);
				}
				$("#educationName").html(ar[31]);
				$("#birthday").html(ar[33].substr(0,7));
				$("#address").html(ar[34]);
				$("#ethnicity").html(ar[37]);
				$("#IDdate").html(ar[40] + " " + ar[41]);
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
				if(ar[23] > ""){
					$("#img_cardB").attr("src","/users" + ar[23]);
				}else{
					$("#img_cardB").attr("src","images/blank_cardB.png");
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
			<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>上海市特种作业人员安全技术考核申请表（2021版）</h3></div>
			<div style='margin: 12px;text-align:left; width:95%;'><span style='font-size:1.2em;'>学员编号：</span><span style='font-size:1.2em;' id="SNo"></span></div>
			<table class='table_resume' style='width:99%;'>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>姓名</td><td align="center" width='15%'><p style='font-size:1em;' id="name"></p></td>
				<td align="center" class='table_resume_title' width='13%'>性别</td><td align="center" width='10%'><p style='font-size:1em;' id="sexName"></p></td>
				<td align="center" class='table_resume_title' width='13%'>出生年月</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="birthday"></p></td>
				<td rowspan="4" colspan="2" align="center" class='table_resume_title' width='20%'>
					<img id="img_photo" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>国籍</td><td align="center" width='13%'><p style='font-size:1em;'>中国</p></td>
				<td align="center" class='table_resume_title' width='13%'>民族</td><td align="center" width='10%'><p style='font-size:1em;' id="ethnicity"></p></td>
				<td align="center" class='table_resume_title' width='13%'>文化程度</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="educationName"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>证件号码</td><td align="center" colspan="3"><p style='font-size:1em;' id="username"></p></td>
				<td align="center" class='table_resume_title' width='13%'>有效期限</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="IDdate"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>单位名称</td><td align="center" colspan="3"><p style='font-size:1em;' id="company"></p></td>
				<td align="center" class='table_resume_title' width='13%'>从事岗位</td><td align="center"><p style='font-size:1em;' id="job"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='13%' height='55px;'>联系地址</td><td align="center" colspan="3"><p style='font-size:1em;' id="address"></p></td>
				<td align="center" class='table_resume_title' width='13%'>联系方式</td><td align="center" width='13%' colspan="3"><p style='font-size:1em;' id="mobile"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>申请考核工种</td><td align="center" colspan="7"><p style='font-size:1em;' id="courseName"></p></td>
			</tr>
			<tr>
				<td align="center" height='55px;' colspan="4" class='table_resume_title' width='15%' height='250px;'>
					<img id="img_cardA" src="" value="" style='disply:block;width:340px;height:auto;max-height:250px;border:none;' />
				</td>
				<td align="center" colspan="4" class='table_resume_title' width='15%' height='250px;'>
					<img id="img_cardB" src="" value="" style='disply:block;width:340px;height:auto;max-height:250px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>考核类型</td><td align="center" width='13%' colspan="2"><p id="reexamine" style='font-size:1em;'></p></td>
				<td align="center" class='table_resume_title' width='13%' colspan="2">是否参加相应培训</td><td align="center" width='13%' colspan="3"><p style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;是&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" />&nbsp;&nbsp;否</p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>从事特种作业操作情况</td>
				<td align="left" colspan="7" style="padding-left:5px;">
					<p style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;本人是初次参加特种作业人员安全技术考核。</p>
					<p style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;本人此次参加特种作业人员安全技术复审考核，在持原特种作业操作证书从事相应特种作业工种内容期间，未发生过事故。</p>
					<p style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;本人因未按时参加复审导致原操作证书过期，重新申请参加特种作业人员安全技术考核。</p>
					<p style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;其他：</p>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'>个人承诺</td>
				<td align="left" colspan="7" style="padding-left:5px;">
				<p style='font-size:1em;text-indent:30px;'>
				本人年满18周岁，且不超过国家法定退休年龄；具有初中及以上文化程度；经社区或者县级以上医疗机构体检健康合格，无妨碍从事相应特种作业的器质性心脏病、癫痫病、美尼尔氏症、眩晕症、癔病、震颤麻痹症、精神病、痴呆症以及其他疾病和生理缺陷，本人对以上信息的真实性负责，如有隐瞒，相关责任全部有本人承担。
				</p>
				<p style='font-size:1em;text-align:center;'>
				承诺人（签名）：
				</p>
				</td>
			</tr>
			<tr>
				<td align="left" class='table_resume_title' width='15%' height='55px;' colspan="4">
					<p style='font-size:1em;float:left;'>申请人签名：</p>
					<br><br>
					<p id="date" style='font-size:1em;float:right;padding-right:5px;'>年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</p>
				</td>
				<td align="left" class='table_resume_title' width='15%' height='55px;' colspan="4">
					<p style='font-size:1em;float:left;'>审核意见：</p>
					<br><br>
					<span style='font-size:1em;float:center;padding-right:50px;'>经办人签名：</span>
					<span style='font-size:1em;float:right;'>年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</span>
				</td>
			</tr>
			</table>
			<div style="page-break-after:always"></div>
			<div id="needCover"></div>
		</div>
	</div>
  </div>
</div>
</body>
