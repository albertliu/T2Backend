<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.3"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css?v=1.8.6">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery-confirm.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.12.4.min.js"></script>
<script language="javascript" src="js/jquery.form.js?v=1.0"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js?v=1.8.6"></script>
<script src="js/jquery-confirm.js" type="text/javascript"></script>
<script type="text/javascript" src="js/asyncbox.v1.5.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script src="js/jQuery.print.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->
<style>
@font-face {
	font-family: 'qyt';
	src: url('fonts/QYSXT-Regular.ttf') format('truetype');
	font-weight: normal;
	font-style: normal;
}
</style>
<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var updateCount = 1;
	var k = 0;
	var sign = "";
	var reex = 0;
	var s = 0;
	var course = "";
	var sDate = "";
	var price = 0;
	var unit = "";
	<!--#include file="js/commFunction.js"-->
	<!--#include file="agreement.js"-->
	<!--#include file="materials_emergency1.js"-->
	<!--#include file="materials_emergency3.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//1 前台打印（报名表和单位证明）  2 班级档案文件（所有内容，鉴定不签字）  3 鉴定档案文件（所有内容，鉴定签字）  4 仅报名表（不显示身份证，签名时展示给学员)   5 仅报名表（申报时用）  
		op = "<%=op%>";
		host = "<%=host%>";		//currHost
		
		$.ajaxSetup({ 
			async: false 
		}); 
		getNodeInfo(nodeID, refID);
	});

	function getNodeInfo(id,ref){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&public=1&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > "0"){
				//$("#SNo").html(ar[25] + "&nbsp;&nbsp;班级：" + ar[34]);
				$("#certName").html(ar[56]);
				$("#pcode").html(ar[101]);
				$("#currDiplomaID").html(ar[36]);
				$("#currDiplomaDate").html(ar[41]);
				sign = (ar[47]==1?ar[43]:"");
				sDate = ar[44];
				unit = ar[105];
				var jobDate = addDays(ar[88],-400);
				$("#jobDate").html(jobDate.substring(0,4) + "年" + parseInt(jobDate.substring(5,7)) + "月");
				if(sign>""){
					$("#f_sign30").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#date").html(new Date(sDate).format("yyyy.M.d"));
				}else{
					$("#f_sign30").hide();
				}
			}else{
				//alert("没有找到要打印的内容。");
				return false;
			}
		});
		
		$.get("studentControl.asp?op=getNodeInfo&nodeID=0&refID=" + ref + "&public=1&times=" + (new Date().getTime()),function(re){
			//alert(ref + ":" + unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#username").html(ar[1]);
				$("#name").html(ar[2]);
				$("#sexName").html(ar[8]);
				$("#mobile").html(ar[7]);
				$("#phone").html(ar[13]);
				$("#age").html(ar[9]);
				$("#email").html(ar[12]);
				$("#job").html(ar[14]);
				$("#unit").html(ar[25]);
				$("#unit1").html(ar[25]);
				$("#linker").html(ar[34]);
				k = (ar[25]=="个人" || ar[25]=="个体"? 1: 0);
				$("#educationName").html(ar[21]);
				$("#address").html(ar[24]);
				$("#province").html(ar[19]);
				if(ar[15] > ""){
					$("#img_photo").attr("src","/users" + ar[15]);
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
				}
				var p = 0;
				// if(keyID == 2 || keyID == 3){
				if(keyID <= 3){
					//打印学历证明、身份证
					p = 1;
					s = 1;
					getMaterials1(ar[1],sign,p,k,s,keyID);
					getMaterials3(ar[1],sign,p,k,s,keyID);
				}
				if(keyID < 3 || keyID == 4){	//
					getAgreement(ar[1],ar[2],course,sign,sDate,price,unit,host);	//协议书
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
			// append : "<br/>"
		});
		window.setTimeout(function () {
			//window.parent.asyncbox.close("enterInfo");
			// window.parent.getStudentCourseList(refID);
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
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style="position: relative;width:100%;height:99%;">
				<div style="position: absolute; z-index:10;">
					<div style='text-align:center; margin:10px 0 30px 0;'><h3 style='font-size:1.45em;'>特种设备作业人员资格复审申请表</h3></div>
					<table class='table_resume' style='width:99%;'>
					<tr>
						<td align="center" class='table_resume_title' width='17%' height='55px' colspan="2">姓名</td><td align="center" width='37%'><p style='font-size:1em;' id="name"></p></td>
						<td align="center" class='table_resume_title' width='12%'>性别</td><td align="center" width='13%'><p style='font-size:1em;' id="sexName"></p></td>
						<td rowspan="4" align="center" class='table_resume_title' width='21%'>
							<img id="img_photo" src="" value="" style='width:100px;border:none;' />
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px' colspan="2">通信地址</td><td align="left" colspan="3"><p style='font-size:1em; padding-left:20px;' id="address"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px' colspan="2">文化程度</td><td align="center"><p style='font-size:1em;' id="educationName"></p></td>
						<td align="center" class='table_resume_title'>邮政编码</td><td class='table_resume_title'><p style='font-size:1em;' id="province"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px' colspan="2">身份证件号</td><td align="center"><p style='font-size:1em;' id="username"></p></td>
						<td align="center" class='table_resume_title'>联系电话</td><td class='table_resume_title'><p style='font-size:1em;' id="mobile"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px' colspan="2">复审作业项目</td><td align="center"><p style='font-size:1em;' id="certName"></p></td>
						<td align="center" class='table_resume_title'>项目代号</td><td class='table_resume_title' colspan="2"><p style='font-size:1em;' id="pcode"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px' colspan="2">证件编号</td><td align="center"><p style='font-size:1em;' id="currDiplomaID"></p></td>
						<td align="center" class='table_resume_title'>首次发证日期</td><td class='table_resume_title' colspan="2"><p style='font-size:1em;' id="currDiplomaDate"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px' colspan="2">用人单位</td><td align="left" colspan="4"><p style='font-size:1em; padding-left:20px;' id="unit"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px' colspan="2">单位地址</td><td align="left" colspan="4"><p style='font-size:1em; padding-left:20px;' id="email"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px' colspan="2">单位联系人</td><td align="center"><p style='font-size:1em;' id="linker"></p></td>
						<td align="center" class='table_resume_title'>联系电话</td><td class='table_resume_title' colspan="2"><p style='font-size:1em;' id="phone"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='150px;'>持<br>证<br>期<br>间<br>作<br>业<br>经<br>历</td>
						<td align="center" class='table_resume_title' colspan="5">
							<div><p style='font-size:1.2em;text-align:left;text-indent: 2em;'>
								<span id="jobDate" style='font-size:1em;'></span>至今在<span id="unit1" style='font-size:1em;'></span>工作，职务：<span id="job" style='font-size:1em;'></span>
							</p></div>
						</td>
					</tr>
					<tr>
						<td align="center" height='80px;'>复<br>审<br>资<br>料</td>
						<td align="left" colspan="5" style="padding-left:10px;line-height:25px;">
							<input type="checkbox" checked />&nbsp;《特种设备安全管理和作业人员证》（原件）<br/>
						</td>
					</tr>
					<tr>
						<td align="center" height='80px;' rowspan="2">自<br>我<br>承<br>诺</td>
						<td align="left" colspan="5">
							<div><p style='font-size:1.2em;text-align:center;'>持证期间是否发生过违章作业行为和责任事故：</p></div>
						</td>
					</tr>
					<tr>
						<td align="left" colspan="5" style="padding-left:10px;line-height:25px;">
							<input type="checkbox" checked />&nbsp;未发生过
							<input type="checkbox" style="padding-left:50px;" />&nbsp;发生过
						</td>
					</tr>
					<tr>
						<td align="left" colspan="6" height='100px;' style="padding-left:5px;">
							<p style='font-size:1em;text-indent:2em;'>
							本人声明，以上填写信息及所提交的资料均合法、真实、有效，并承诺对填写的内容负责。
							</p>
							<div style="display:table-cell;height:40px;vertical-align:bottom;text-align:center">
								<span style='font-size:1.2em;padding-left:150px;'>申请人（签字）：</span>
								<span><img id="f_sign30" src="" style="width:100px;padding-left:10px;padding-top:5px;"></span>
								<span id="date" style='font-size:1.3em;padding-top:25px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style="width:50px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								<span style='font-size:1.2em;'>年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日</span>
							</div>
						</td>
					</tr>
					
					</table>
					<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>注：申请人在网上申请的，填写申请表后打印盖章签字并扫描上传。</p></div>
				</div>
			</div>

			<div id="materialsCover1"></div>
			<div id="materialsCover3"></div>
			<div id="agreementCover"></div>
		</div>
	</div>
  </div>
</div>
</body>
