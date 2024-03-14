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
	var k = 0;
	var sign = "";
	var reex = 0;
	var course = "";
	var sDate = "";
	var price = 0;
	<!--#include file="js/commFunction.js"-->
	<!--#include file="need2know.js"-->
	<!--#include file="agreement.js"-->
	<!--#include file="materials_emergency.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//0 预览  1 打印  2 文件
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});
		if(keyID==2){
			$("#pageTitle").hide();
		}
		//getNeed2know(nodeID);
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
				
				sign = (ar[52]==1?ar[48]:"");
				reex = ar[40];
				course = ar[56];
				sDate = ar[49];
				price = ar[53];
				if(reex==1){
					$("#check2").prop("checked",true);	//复训
				}else{
					if(ar[57]==1){
						$("#check3").prop("checked",true);	//复训过期，参加初训
					}else{
						$("#check1").prop("checked",true);	//第一次初训
					}
				}
				
				if(sign>""){
					$("#f_sign1").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign20").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign30").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign40").attr("src","/users/upload/companies/stamp/sign_znxf.png?times=" + (new Date().getTime()));
					$("#date").html(sDate);
					//$("#f_sign40").hide();
					$("#date2").html(sDate);
				}else{
					$("#f_sign1").hide();
					$("#f_sign20").hide();
					$("#f_sign30").hide();
					$("#f_sign40").hide();
				}
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
					$("#f_sign1").hide();
				}
				if(sign=="" || ar[22] == ""){
					$("#same1").hide();
				}
				if(ar[23] > ""){
					$("#img_cardB").attr("src","/users" + ar[23]);
				}else{
					$("#img_cardB").attr("src","images/blank_cardB.png");
				}
				//$("#date").html(currDate);
				var p = 0;
				if(keyID == 2){
					//打印学历证明
					p = 1;
				}else{
					getNeed2know(nodeID);
					getAgreement(ar[1],ar[2],course,sign,sDate,price);
				}
				getMaterials(ar[1],sign,p,k);
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
		<div id="pageTitle" style="text-align:center;">
			<input class="button" type="button" id="print" value="打印" />&nbsp;
		</div>
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style="position: relative;width:100%;height:100%;">
				<div style="position: absolute; z-index:30;">
				<div style="float:left;">
					<span><img id="f_sign1" src="" style="width:170px;margin:0px 0px 8px 60px;padding-left:80px;padding-top:530px;"></span>
					<p id="same1" style='font-size:1.3em;text-indent:30px;font-family:方正舒体,幼圆;padding-top:20px;'>与原件内容一致</p>
				</div>
				</div>
				<div style="position: absolute; z-index:10;">
					<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>上海市高危行业负责人及安全生产管理人员安全知识和管理能力</h3></div>
					<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>考核申请表（2023版）</h3></div>
					<div style='margin: 12px;text-align:left; width:95%;'><span style='font-size:1.2em;'>学员编号：</span><span style='font-size:1.2em;' id="SNo"></span></div>
					<table class='table_resume' style='width:99%;'>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='40px;'>姓名</td><td align="center" width='15%'><p style='font-size:1em;' id="name"></p></td>
						<td align="center" class='table_resume_title' width='13%'>性别</td><td align="center" width='10%'><p style='font-size:1em;' id="sexName"></p></td>
						<td align="center" class='table_resume_title' width='13%'>出生年月</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="birthday"></p></td>
						<td rowspan="4" colspan="2" align="center" class='table_resume_title' width='20%'>
							<img id="img_photo" src="" value="" style='width:100px;border:none;' />
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='40px;'>国籍</td><td align="center" width='13%'><p style='font-size:1em;'>中国</p></td>
						<td align="center" class='table_resume_title' width='13%'>民族</td><td align="center" width='10%'><p style='font-size:1em;' id="ethnicity"></p></td>
						<td align="center" class='table_resume_title' width='13%'>文化程度</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="educationName"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='45px;'>证件号码</td><td align="center" colspan="3"><p style='font-size:1em;' id="username"></p></td>
						<td align="center" class='table_resume_title' width='13%'>有效期限</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="IDdate"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='50px;'>单位名称</td><td align="center" colspan="3"><p style='font-size:1em;' id="company"></p></td>
						<td align="center" class='table_resume_title' width='13%'>从事岗位</td><td align="center"><p style='font-size:1em;' id="job"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' width='13%' height='40px;'>联系地址</td><td align="center" colspan="3"><p style='font-size:1em;' id="address"></p></td>
						<td align="center" class='table_resume_title' width='13%'>联系方式</td><td align="center" width='13%' colspan="3"><p style='font-size:1em;' id="mobile"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='40px;'>申请考核工种</td><td align="center" colspan="7"><p style='font-size:1em;' id="courseName"></p></td>
					</tr>
					<tr>
						<td align="center" height='45px;' colspan="4" class='table_resume_title' width='15%' height='250px;'>
							<img id="img_cardA" src="" value="" style='disply:block;width:auto;max-width:340px;height:auto;max-height:250px;border:none;' />
						</td>
						<td align="center" colspan="4" class='table_resume_title' width='15%' height='250px;'>
							<img id="img_cardB" src="" value="" style='disply:block;width:auto;max-width:340px;height:auto;max-height:250px;border:none;' />
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='40px;'>考核类型</td><td align="center" width='13%' colspan="2"><p id="reexamine" style='font-size:1em;'></p></td>
						<td align="center" class='table_resume_title' width='13%' colspan="2">是否参加相应培训</td><td align="center" width='13%' colspan="3"><p style='font-size:1em;'><input type="checkbox" checked />&nbsp;&nbsp;是&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" />&nbsp;&nbsp;否</p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='40px;'>承担高危行业相关岗位情况</td>
						<td align="left" colspan="7" style="padding-left:5px;">
							<p style='font-size:1em;'><input id="check1" type="checkbox" />&nbsp;&nbsp;本人是初次参加高危行业人员安全知识和管理能力考核。</p>
							<p style='font-size:1em;'><input id="check2" type="checkbox" />&nbsp;&nbsp;本人此次参加高危行业人员安全知识和管理能力复审考核，在持原特种作业操作证书从事相应岗位期间，未发生过事故。</p>
							<p style='font-size:1em;'><input style="border:0px;" type="checkbox" id="check3" value="" />&nbsp;&nbsp;本人因未按时参加复审导致原操作证书过期，重新申请参加高危行业人员安全知识和管理能力考核。</p>
							<p style='font-size:1em;'>&nbsp;&nbsp;&nbsp;&nbsp;本人对填写所有信息以及提交材料的真实性、有效性和完整性负责，如有隐瞒，相关责任全部由本人承担。</p>
							<div style="display:table-cell;height:50px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;padding-left:280px;'>承诺人签名：</span>
								<span><img id="f_sign20" src="" style="width:170px;padding-left:80px;"></span>
							<div>
						</td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' width='15%' height='40px;' colspan="4">
							<div style="display:table-cell;height:50px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;'>申请人签名：</span>
								<span><img id="f_sign30" src="" style="width:170px;padding-left:80px;"></span>
							<div>
							<p id="date" style='font-size:1.2em;float:right;padding-top:10px;padding-right:5px;'>年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</p>
						</td>
						<td align="left" class='table_resume_title' width='15%' height='120px;' colspan="4">
							<p style='font-size:1em;float:left;'>考试点意见：</p>
							<br><br>
							<div style="display:table-cell;height:30px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;padding-left:80px;'>经办人签名：</span>
								<span><img id="f_sign40" src="" style="width:120px;padding-left:10px;"></span>
							<div>
							<p id="date2" style='font-size:1.2em;float:left;padding-left:150px;padding-top:10px;'>年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</p>
						</td>
					</tr>
					</table>
				</div>
			</div>
			<div id="needCover"></div>
			<div id="agreementCover"></div>
			<div id="materialsCover"></div>
		</div>
	</div>
</div>
</body>
