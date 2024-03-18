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
	var course = "";
	var sDate = "";
	var price = 0;
	var unit = "";
	var host = "";
	<!--#include file="js/commFunction.js"-->
	<!--#include file="agreement.js"-->
	<!--#include file="materials_emergency1.js"-->
	<!--#include file="materials_emergency5.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//1 前台打印（报名表和单位证明）  2 班级档案文件（所有内容，鉴定不签字）  3 鉴定档案文件（仅报名表，鉴定签字）  4 仅报名表（不显示身份证，签名时展示给学员)   5 仅报名表（申报时用）  
		op = "<%=op%>";
		host = "<%=host%>";		//currHost
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});
		if(keyID>1){
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
				$("#C" + ar[32]).prop("checked",true);
				$("#R" + ar[37]).prop("checked",true);
				sign = (ar[47]==1?ar[43]:"");
				reex = ar[37];
				course = ar[87];
				sDate = ar[44];
				price = ar[63];
				unit = ar[105];
				k = ar[111];
				$("#f_sign40").hide();	// 经办人不签名，不写日期
				if(sign>""){
					$("#f_sign20").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					// $("#f_sign30").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					// 经办人不签名，不写日期
					// if(ar[106]>""){ 	
					// 	$("#f_sign40").attr("src","/users" + ar[106] + "?times=" + (new Date().getTime()));		//经办人签名
					// 	$("#date2").html(new Date(sDate).format("yyyy.M.d"));
					// 	// $("#date2").html(new Date(addDays(sDate,3)).format("yyyy.M.d"));
					// }
					// alert(ar[115])
					if(keyID == 3 && ar[107]>""){  //除鉴定归档以外，其他鉴定不签字
						$("#f_sign40").show();
						// $("#f_sign50").attr("src","/users/upload/companies/stamp/station_feng.png?times=" + (new Date().getTime()));		//鉴定印章
						$("#f_sign40").attr("src","/users" + ar[107] + "?times=" + (new Date().getTime()));		//鉴定签名
						$("#date2").html(ar[115]);
						var arr = new Array();
						arr.push('<div style="position: relative;width:100%;height:80%;">');
						arr.push('<div style="position: absolute; z-index:10;">');
						arr.push('<div style="float:left;">');
						arr.push('	<span style="padding-left:150px;"><img src="/users/upload/companies/stamp/station_' + host + '.png" style="width:150px;padding-top:840px;opacity:0.7;"></span>');
						arr.push('</div>');
						arr.push('</div>');
						arr.push('</div>');
						$("#stampCover").html(arr.join(""));
					}
					$("#date").html(new Date(sDate).format("yyyy.M.d"));
					//$("#f_sign40").hide();
				}else{
					$("#f_sign20").hide();
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
				$("#mobile").html(ar[7]);
				$("#age").html(ar[9]);
				$("#job").html(ar[14]);
				k = (k == 1 || ar[25]=="个人" || ar[25]=="个体"? 1: 0);
				if(k==1){
					$("#unit").html("个人");
				}else{
					$("#unit").html(ar[25]);
				}
				$("#educationName").html(ar[21]);
				$("#birthday").html(ar[23].substr(0,7));
				$("#address").html(ar[37]);
				$("#ethnicity").html(ar[26]);
				$("#IDdate").html(ar[29] + (ar[29]>"" && ar[30]==""? "<br>长期":"<br>" + ar[30]));
				if(ar[1].length==18){
					$("#IDK0").prop("checked",true);
				}else{
					$("#IDK1").prop("checked",true);
				}
				if(ar[15] > ""){
					$("#img_photo").attr("src","/users" + ar[15]);
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
				}
				var p = 0;
				// if(keyID == 2){
				if(keyID < 3){
					//打印学历证明、身份证
					p = 1;
					s = 1;
					getMaterials1(ar[1],sign,p,k,s,keyID);
					// getMaterials3(ar[1],sign,p,k,s,keyID);
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
		<div id="pageTitle" style="text-align:center;">
			<input class="button" type="button" id="print" value="打印" />&nbsp;
		</div>
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style="position: relative;width:100%;height:100%;">
				<div style="position: absolute; z-index:10;">
					<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>上海市高危行业负责人及安全生产管理人员安全知识和管理能力</h3></div>
					<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>考核申请表</h3></div>
					<div style='text-align:left; margin:10px 0 15px 30px;'>
						<span style='font-size:1.5em; font-family: 幼圆;'>申请考试类别：<input type="checkbox" id="R0" />&nbsp;初证 <input type="checkbox" id="R1" />&nbsp;复审</span>
					</div>
					<table class='table_resume' style='width:99%;'>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='65px'>姓名</td><td align="center" width='13%'><p style='font-size:1em;' id="name"></p></td>
						<td align="center" class='table_resume_title' width='10%'>性别</td><td align="center" width='10%'><p style='font-size:1em;' id="sexName"></p></td>
						<td align="center" class='table_resume_title' width='13%'>出生年月</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="birthday"></p></td>
						<td rowspan="4" colspan="2" align="center" class='table_resume_title' width='20%'>
							<img id="img_photo" src="" value="" style='width:100px;border:none;' />
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='65px'>国籍</td><td align="center" width='13%'><p style='font-size:1em;'>中国</p></td>
						<td align="center" class='table_resume_title' width='10%'>民族</td><td align="center" width='10%'><p style='font-size:1em;' id="ethnicity"></p></td>
						<td align="center" class='table_resume_title' width='13%'>文化程度</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="educationName"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='65px'>证件类型</td><td align="center" colspan="3"><input type="checkbox" id="IDK0" />&nbsp;身份证 <input type="checkbox" />&nbsp;护照 <input type="checkbox" id="IDK1" />&nbsp;其他</td>
						<td align="center" class='table_resume_title'>证件有效期</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="IDdate"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='65px'>证件号码</td><td align="center" colspan="5"><p style='font-size:1em;' id="username"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='65px'>工作单位</td><td align="center" colspan="3"><p style='font-size:1em;' id="company"></p></td>
						<td align="center" class='table_resume_title'>从事岗位</td><td align="center" colspan="3"><p style='font-size:1em;' id="job"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='65px'>联系地址</td><td align="center" colspan="3"><p style='font-size:1em;' id="address"></p></td>
						<td align="center" class='table_resume_title'>联系方式</td><td align="center" colspan="3"><p style='font-size:1em;' id="mobile"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='200px'>申请考试<br>项目</td>
						<td align="left" colspan="7" style="line-height:30px;">
							<input type="checkbox" />&nbsp;危险化学品生产单位主要负责人 <input type="checkbox" />&nbsp;&nbsp;&nbsp;危险化学品生产单位安全生产管理人员<br/>
							<input type="checkbox" id="CC98" />&nbsp;危险化学品经营单位主要负责人 <input type="checkbox" id="CC99" />&nbsp;&nbsp;&nbsp;危险化学品经营单位安全生产管理人员<br/>
							<input type="checkbox" />&nbsp;金属冶炼（炼钢）单位主要负责人 <input type="checkbox" />&nbsp;金属冶炼（炼钢）单位安全生产管理人员<br/>
							<input type="checkbox" />&nbsp;金属冶炼（炼铁）单位主要负责人 <input type="checkbox" />&nbsp;金属冶炼（炼铁）单位安全生产管理人员<br/>
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='140px;'>注意事项</td>
						<td align="left" colspan="7" style="padding-left:5px;line-height:30px;">
							<p style='font-size:1em;'>&nbsp;&nbsp;&nbsp;&nbsp;本人承诺所提供资料真实完整有效，如因提供资料虚假而产生相关影响，由本人承担全部责任。</p>
							<div style="display:table-cell;height:50px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;padding-left:280px;'>申请人（签名）：</span>
								<span><img id="f_sign20" src="" style="max-width:170px;max-height:40px;padding-left:10px;"></span>
								<span id="date" style='font-size:1.5em;padding-top:3px;color:#555;font-family:"qyt","Ink Free";'></span>
							</div>
						</td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='140px' colspan="8">
							<div style="display:table-cell;height:100px;vertical-align:middle;text-align:left;">
								<div><p style='font-size:1.2em;'>考试点审查意见：</p></div>
								<div style="display:table-cell;vertical-align:middle;text-align:left;">
									<span style='font-size:1.2em;padding-left:150px;'>考试点（盖章）：</span>
									<span style='font-size:1.2em;padding-left:100px;'>经办人（签名）：</span>
									<span style='font-size:1.2em;'><img id="f_sign40" src="" style="width:100px;padding-left:10px;"></span>
									<span id="date2" style='font-size:1.4em;color:#555;font-family:"Aa跃然体","时光沙漏";'></span>
								</div>
							</div>
						</td>
					</tr>
					</table>
				</div>
				<div id="stampCover"></div>
			</div>
			<div id="needCover"></div>
			<div id="agreementCover"></div>
			<div id="materialsCover"></div>
		</div>
	</div>
</div>
</body>
