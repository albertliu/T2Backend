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
	var s = 0;
	var sign = "";
	var reex = 0;
	var course = "";
	var sDate = "";
	var price = 0;
	var unit = "";
	<!--#include file="js/commFunction.js"-->
	<!--#include file="commitment.js"-->
	<!--#include file="agreement.js"-->
	<!--#include file="materials_emergency1.js"-->
	<!--#include file="materials_emergency3.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//1 前台打印（报名表和单位证明）  2 班级档案文件（所有内容，鉴定不签字）  3 鉴定档案文件（所有内容，鉴定签字）  4 仅报名表（不显示身份证，签名时展示给学员)   5 仅报名表（申报时用）  
		op = "<%=op%>";
		
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
				$("#reexamine").html("上海市生产经营单位主要负责人、安全生产管理人员<br>安全技术培训考核申请（备案）表");
				//$("#courseName").html(ar[6]);
				$("#C" + ar[32]).prop("checked",true);
				sign = (ar[47]==1?ar[43]:"");
				reex = ar[37];
				course = ar[87];
				sDate = ar[44];
				price = ar[63];
				unit = ar[105];
				if(sign>""){
					$("#f_sign1").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign20").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign30").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign40").attr("src","/users" + ar[106] + "?times=" + (new Date().getTime()));		//经办人签名
					if(keyID == 3 && ar[107]>""){  //除鉴定归档以外，其他鉴定不签字
						$("#f_sign50").attr("src","/users" + ar[107] + "?times=" + (new Date().getTime()));		//鉴定签字
					}else{
						$("#f_sign50").hide();
					}
				}else{
					$("#f_sign1").hide();
					$("#f_sign20").hide();
					$("#f_sign30").hide();
					$("#f_sign40").hide();
					$("#f_sign50").hide();
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
				$("#age").html(ar[9]);
				$("#job").html(ar[14]);
				$("#unit").html(ar[25]);
				k = (ar[25]=="个人" || ar[25]=="个体"? 1: 0);
				$("#educationName").html(ar[21]);
				$("#birthday").html(ar[23].substr(0,7));
				$("#address").html(ar[24]);
				$("#province").html(ar[19]);
				if(ar[15] > "" && keyID !=4){
					$("#img_photo").attr("src","/users" + ar[15]);
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
				}
				if(keyID < 3 || keyID == 4){	//
					getAgreement(ar[1],ar[2],course,sign,sDate,price,unit);	//协议书
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

<div id='layout' align='left' style="background:#f0f0f0; width:100%;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style="position: relative;width:100%;height:99%;">
				<div style="position: absolute; z-index:10;">
					<div style='text-align:center; margin:10px 0 20px 0;'><h3 id="reexamine" style='font-size:1.45em;line-height:30px;'></h3></div>
					<table class='table_resume' style='width:100%;'>
					<tr>
						<td align="center" class='table_resume_title' width='20%' height='55px'>姓名</td><td align="center" width='20%'><p style='font-size:1em;' id="name"></p></td>
						<td align="center" class='table_resume_title' width='20%'>性别</td><td align="center" width='20%'><p style='font-size:1em;' id="sexName"></p></td>
						<td rowspan="3" align="center" class='table_resume_title' width='20%'>
							<img id="img_photo" src="" value="" style='width:100px;border:none;' />
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px'>出生年月</td><td class='table_resume_title'><p style='font-size:1em;' id="birthday"></p></td>
						<td align="center" class='table_resume_title'>文化程度</td><td class='table_resume_title'><p style='font-size:1em;' id="educationName"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px'>职务</td><td class='table_resume_title'><p style='font-size:1em;' id="job"></p></td>
						<td align="center" class='table_resume_title'>职称</td><td class='table_resume_title'><p style='font-size:1em;'></p></td>
					</tr>
					<tr>
						<td rowspan="2" align="center" class='table_resume_title' height='100px'>联系方式</td>
						<td align="center" class='table_resume_title'>手机号码</td><td class='table_resume_title' colspan="3"><p style='font-size:1em;' id="mobile"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title'>固定电话</td><td class='table_resume_title' colspan="3"><p style='font-size:1em;' id="phone"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px'>单位全称</td><td align="center" colspan="4"><p style='font-size:1em;' id="unit"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px'>单位地址</td><td align="center" colspan="4"><p style='font-size:1em;' id="address"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px'>单位邮编</td><td align="center" colspan="4"><p style='font-size:1em;' id="province"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px'>身份证号码</td><td align="center" colspan="4"><p style='font-size:1em;' id="username"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='100px'>岗位类别</td>
						<td align="left" colspan="4" style="padding:20px;">
							<div style="font-size:1em;"><input type="checkbox" id="CC23" />&nbsp;主要负责人 &nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="CC22" />&nbsp;安全管理人 &nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="CC1" />&nbsp;危化品从业人员</div>
							<div style="padding-top:20px;font-size:1em;"><input type="checkbox" id="CC35" />&nbsp;有毒有限空间操作</div>
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='55px'>单位类别</td>
						<td align="left" colspan="4" style="padding:20px;">
							<input type="checkbox" checked />&nbsp;生产单位 &nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" />&nbsp;经营单位
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='200px'>备注</td>
						<td align="left" colspan="4"></td>
					</tr>
					
					</table>
				</div>
			</div>

			<div id="commitmentCover"></div>
			<div id="materialsCover1"></div>
			<div id="materialsCover3"></div>
			<div id="agreementCover"></div>
		</div>
	</div>
  </div>
</div>
</body>
