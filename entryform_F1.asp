<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.35"  rel="stylesheet" type="text/css" />
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
	var host = "";
	<!--#include file="js/commFunction.js"-->
	<!--#include file="commitment.js"-->
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
		if(keyID==5){
			$("#keyItem4").hide();
			$("#resume_print").css("display", "flex");
		}else{
			$("#keyItem5").hide();
			$("#keyItem6").hide();
		}
		getNodeInfo(nodeID, refID);
	});

	function getNodeInfo(id,ref){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&public=1&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > "0"){
				//$("#SNo").html(ar[25] + "&nbsp;&nbsp;班级：" + ar[34]);
				$("#reexamine").html("上海市特种作业人员安全技术考核申请表");
				//$("#courseName").html(ar[6]);
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
						$("#f_sign50").attr("src","/users/upload/companies/signature/agree.png?times=" + (new Date().getTime()));		//鉴定同意
						$("#f_sign40").attr("src","/users" + ar[107] + "?times=" + (new Date().getTime()));		//鉴定签名
						$("#date2").html(ar[115].substr(0,4));
						$("#date2M").html(ar[115].substr(5,2));
						$("#date2D").html(ar[115].substr(8,2));
						var arr = new Array();
						arr.push('<div style="position: relative;width:100%;height:80%;">');
						arr.push('<div style="position: absolute; z-index:10;">');
						arr.push('<div style="float:left;">');
						arr.push('	<span style="padding-left:150px;"><img src="/users/upload/companies/stamp/station_' + host + '.png" style="width:150px;padding-top:870px;opacity:0.7;"></span>');
						arr.push('</div>');
						arr.push('</div>');
						arr.push('</div>');
						$("#stampCover").html(arr.join(""));
					}else{
						$("#f_sign50").hide();
						$("#date2").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
						$("#date2M").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
						$("#date2D").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
					}
					let date1 = new Date(sDate).format("yyyy.MM.dd");
					$("#date").html(date1.substr(0,4));
					$("#dateM").html(date1.substr(5,2));
					$("#dateD").html(date1.substr(8,2));
					//$("#f_sign40").hide();
				}else{
					$("#f_sign20").hide();
					$("#f_sign50").hide();
					$("#date2").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
					$("#date2M").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
					$("#date2D").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
				}
				
				var c = "";
				if(ar[49] > ""){
					c += "<a href='/users" + ar[49] + "?times=" + (new Date().getTime()) + "' target='_blank'>报名材料</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;报名材料还未生成";}
				$("#f_materials").html(c);
				if(reex == 1){
					$("#onShanghai").hide();
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
				if(ar[15] > "" && keyID !=4){
					$("#img_photo").attr("src","/users" + ar[15]);
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
				}
				if(keyID ==5){
					$("#img_A").attr("src","/users" + ar[16]);
					$("#img_B").attr("src","/users" + ar[17]);
					if(reex == 0){	//初训报名表显示学历
						$("#img_E").attr("src","/users" + ar[18]);
					}
				}

				var p = 0;
				if(reex==1 && keyID < 3){
					if(ar[32]==""){	//employe_filename
						//情况说明模板
						getCommitment(ar[1],ar[2],course,sign,sDate,k);
					}else{
						//已上传的情况说明图片
						k = 1;
						getMaterials5(ar[1],sign,p,k,s,keyID);
					}
				}
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
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style="position: relative; width:800px;height:99%;">
				<div style="position: absolute; z-index:10;">
					<div style='text-align:center; margin:10px 0 15px 0;'><h3 id="reexamine" style='font-size:1.75em; font-family: 幼圆;'></h3></div>
					<div style='text-align:left; margin:10px 0 15px 30px;'><p style='font-size:1.5em; font-family: 幼圆;'>申请考试类别：<input type="checkbox" id="R0" />&nbsp;初证 <input type="checkbox" id="R1" />&nbsp;复审</p></div>
					<table class='table_resume' style='width:99%;border:2px solid black;'>
					<tr>
						<td align="center" class='table_resume_title' width='10%' height='45px'>姓名</td><td align="center" width='13%'><p style='font-size:1em;' id="name"></p></td>
						<td align="center" class='table_resume_title' width='10%'>性别</td><td align="center" width='14%'><p style='font-size:1em;' id="sexName"></p></td>
						<td align="center" class='table_resume_title' width='13%'>出生年月</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="birthday"></p></td>
						<td rowspan="4" colspan="2" align="center" class='table_resume_title' width='18%'>
							<img id="img_photo" src="" value="" style='width:100px;border:none;' />
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='45px'>国籍</td><td align="center" width='13%'><p style='font-size:1em;'>中国</p></td>
						<td align="center" class='table_resume_title'>民族</td><td align="center" width='10%'><p style='font-size:1em;' id="ethnicity"></p></td>
						<td align="center" class='table_resume_title'>文化程度</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="educationName"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='45px'>证件类型</td><td align="center" colspan="3" class="ef1p1"><input type="checkbox" id="IDK0" />&nbsp;身份证 <input type="checkbox" />&nbsp;护照 <input type="checkbox" id="IDK1" />&nbsp;其他</td>
						<td align="center" class='table_resume_title'>证件有效期</td><td class='table_resume_title'><p style='font-size:1em;' id="IDdate"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='45px'>证件号码</td><td align="center" colspan="5"><p style='font-size:1em;' id="username"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='45px'>工作单位</td><td align="center" colspan="3"><p style='font-size:1em;' id="unit"></p></td>
						<td align="center" class='table_resume_title'>从事岗位</td><td align="center" colspan="3"><p style='font-size:1em;' id="job"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='45px'>联系地址</td><td align="center" colspan="3"><p style='font-size:1em;' id="address"></p></td>
						<td align="center" class='table_resume_title'>联系方式</td><td align="center" colspan="3"><p style='font-size:1em;' id="mobile"></p></td>
					</tr>
					<tr>
						<td align="center" rowspan="6" class='table_resume_title' height='45px'>申<br>请<br>考<br>试<br>项<br>目</td>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='60px'>电工作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" id="CC12" />&nbsp;低压电工作业 <input type="checkbox" id="CC27" />&nbsp;高压电工作业 <input type="checkbox" />&nbsp;电力电缆作业</br>
							<input type="checkbox" />&nbsp;继电保护作业 <input type="checkbox" />&nbsp;电气试验作业 <input type="checkbox" />&nbsp;防爆电气作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='40px'>焊接与热切割作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" id="CC24" />&nbsp;熔化焊接与热切割作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='40px'>高处作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" />&nbsp;登高架设作业 <input type="checkbox" id="CC15" />&nbsp;高处安装、维护、拆除作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='40px'>制冷与空调作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" id="CC25" />&nbsp;制冷与空调设备运行操作作业 <input type="checkbox" id="CC26" />&nbsp;制冷与空调设备安装修理作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='45px'>冶金(有色)生产<br>安全作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" />&nbsp;煤气作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;">危险化学品安全作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" />&nbsp;光气及光气化工艺作业 <input type="checkbox" />&nbsp;氧碱电解工艺作业 <br>
							<input type="checkbox" />&nbsp;氯化工艺作业 <input type="checkbox" />&nbsp;硝化工艺作业 <input type="checkbox" />&nbsp;合成氧工艺作业 <br>
							<input type="checkbox" />&nbsp;裂解(裂化)工艺作业 <input type="checkbox" />&nbsp;氟化工艺作业 <input type="checkbox" />&nbsp;加氢工艺作业 <br>
							<input type="checkbox" />&nbsp;重氮化工艺作业 <input type="checkbox" />&nbsp;氧化工艺作业 <input type="checkbox" />&nbsp;过氧化工艺作业 <br>
							<input type="checkbox" />&nbsp;胺基化工艺作业 <input type="checkbox" />&nbsp;磺化工艺作业 <input type="checkbox" />&nbsp;聚合工艺作业 <br>
							<input type="checkbox" />&nbsp;烷基化工艺作业 <input type="checkbox" />&nbsp;化工自动化控制仪表作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="8" style="padding-left:5px;">
							<p class="ef1p1" style='font-weight:bold;'>注意事项：</p>
							<p class="ef1p1" style='text-indent:30px;'>
							1.申请人须年满18周岁，且不超过国家法定退休年龄。
							</p>
							<p class="ef1p1" style='text-indent:30px;'>
							2.申请人须经社区或者县级以上医疗机构体检健康合格，并无妨碍从事相应特种作业的器质性心脏病、癫痫病、美尼尔氏症、眩晕症、癔病、震颤麻痹症、精神病、痴呆症以及其他疾病和生理缺陷。
							</p>
							<p class="ef1p1" style='text-indent:30px;'>
							3.申请人须具有初中及以上文化程度（申请危险化学品安全作业考试的，须具备高中或者相当于高中及以上文化程度）。
							</p>
							<p class="ef1p1" id="onShanghai" style='text-indent:30px;'>
							4.初证申请人的户籍所在地、居住地或从业所在地须为上海市。
							</p><br />
							<p class="ef1p1" style='text-indent:30px;'>
							本人已阅读并充分了解上述注意事项，承诺所提供资料真实完整有效，如因提供资料虚假而产生相关影响，由本人承担全部责任。
							</p>
							<div style="display:table-cell;height:50px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;padding-left:300px;'>申请人（签名）：</span>
								<span><img id="f_sign20" src="" style="max-width:150px;max-height:35px;padding-left:10px;"></span>
								<span id="date" style='font-size:1.5em;padding-left:10px;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>年</span>
								<span id="dateM" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>月</span>
								<span id="dateD" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>日</span>
							</div>
						</td>
					</tr>
					<tr id="keyItem1">
						<td align="left" class='table_resume_title' height='100px' colspan="8">
							<div style="display:table-cell;height:100px;vertical-align:middle;text-align:left;">
								<div style="vertical-align:middle;">
									<span style='font-size:1.2em;'>考试点审查意见：</span>
									<span style='padding-left:0px;padding-bottom:0;'><img id="f_sign50" src="" style="width:70px;"></span>
								</div>
								<div style="display:table-cell;vertical-align:middle;text-align:left;">
									<span style='font-size:1.2em;padding-left:150px;'>考试点（盖章）：</span>
									<span style='font-size:1.2em;padding-left:100px;'>经办人（签名）：</span>
									<span style='font-size:1.2em;'><img id="f_sign40" src="" style="width:70px;padding-left:10px;"></span>
									<span id="date2" style='font-size:1.4em;color:#555;font-family:"Aa跃然体","时光沙漏";'></span>
									<span style='font-size:1.2em;'>年</span>
									<span id="date2M" style='font-size:1.4em;color:#555;font-family:"Aa跃然体","时光沙漏";'></span>
									<span style='font-size:1.2em;'>月</span>
									<span id="date2D" style='font-size:1.4em;color:#555;font-family:"Aa跃然体","时光沙漏";'></span>
									<span style='font-size:1.2em;'>日</span>
								</div>
							</div>
						</td>
					</tr>
					
					</table>
				</div>
				<div id="stampCover"></div>
			</div>
			<div id="keyItem4">
				<div id="commitmentCover"></div>
				<div id="materialsCover1"></div>
				<div id="materialsCover5"></div>
				<div id="agreementCover"></div>
			</div>
			<div id="keyItem5" style="flex:1; text-align:center; width:800px;padding-left:20px;">
				<div><img id="img_A" src="" value="" style="max-width:600px;max-height:500px;padding-top:20px;" /></div>
				<div><img id="img_B" src="" value="" style="max-width:600px;max-height:500px;padding-top:20px;" /></div>
			</div>
			<div id="keyItem6" style="text-align:center; width:800px;padding-left:20px;">
				<div><img id="img_E" src="" value="" style="max-width:600px;max-height:980px;padding-top:20px;" /></div>
			</div>
		</div>
	</div>
  </div>
</div>
</body>
