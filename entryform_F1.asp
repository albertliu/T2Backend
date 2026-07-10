<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.36"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css?v=1.8.6">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery-confirm.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.12.4.min.js"></script>
<script language="javascript" src="js/jquery.form.js?v=1.0"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js?v=1.8.6"></script>
<script src="js/jquery-confirm.js" type="text/javascript"></script>
<script type="text/javascript" src="js/asyncbox.v1.5.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/jQuery.print.js" type="text/javascript"></script>
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
	var kindID = 0;
	var updateCount = 1;
	let classID = 0;
	var k = 0;
	var s = 0;
	var sign = "";
	var reex = 0;
	var course = "";
	var sDate = "";
	let startDate = "";
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
		kindID = "<%=kindID%>";		// 0 普通  1 带培训证明
		keyID = "<%=keyID%>";		//1 前台打印（报名表和单位证明）  2 班级档案文件（所有内容，鉴定不签字）  3 鉴定档案文件（仅报名表，鉴定签字）  4 仅报名表（不显示身份证，签名时展示给学员)   5 仅报名表（申报时用）  
		op = "<%=op%>";
		host = "<%=host%>";		//currHost
		classID = "<%=status%>";		//classID
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#keyItem6").hide();
		if(keyID==5){
			$("#keyItem4").hide();
			$("#resume_print").css("display", "flex");
			if(kindID==0){
				$("#keyItem7").hide();
			}
		}else{
			$("#keyItem5").hide();
			$("#keyItem7").hide();
		}
		getNodeInfo(nodeID, refID);
	});

	function getNodeInfo(id,ref){
		$.post(uploadURL + "/public/postCommInfo", {proc:"getEntryformInfo", params:{enterID:id, classID:classID, host:host}}, function(data){
			let ar = data[0];
			if(ar>""){
				$("#reexamine").html("上海市特种作业人员安全技术考试申请表");
				$("#C" + ar["certID"]).prop("checked",true);
				sign = (ar["signatureType"]==1?ar["signature"]:"");
				reex = ar["reexamine"];
				let rex = reex;
				if(ar["express"]===1){
					rex = 2;
				}
				$("#R" + (rex==1?2:rex)).prop("checked",true);
				course = ar["courseName"];
				sDate = ar["signatureDate"];
				startDate = ar["startDate"];
				price = ar["price"];
				unit = ar["hostName"];
				$("#hostName").html(ar["hostName"]);
				$("#username").html(ar["username"]);
				$("#name").html(ar["name"]);
				$("#sexName").html(ar["sexName"]);
				$("#mobile").html(ar["mobile"]);
				$("#age").html(ar["age"]);
				$("#job").html(ar["job"]);
				$("#unit").html(ar["unit"]);
				$("#educationName").html(ar["educationName"]);
				$("#birthday").html(ar["birthday"].substr(0,7));
				$("#address").html(ar["address"]);
				$("#ethnicity").html(ar["ethnicity"]);
				// $("#IDdate").html(ar[29] + (ar[29]>"" && ar[30]==""? "<br>长期":"<br>" + ar[30]));
				$("#IDdate").html(ar["IDdateStart"] + (ar["IDdateStart"]>"" && ar["IDdateEnd"]==""? "<br>长期":"<br>" + ar["IDdateEnd"]));
				if(ar["username"].length==18){
					$("#IDK0").prop("checked",true);
				}else{
					$("#IDK1").prop("checked",true);
				}
				if(ar["photo_filename"] > ""){	//  && keyID !=4
					$("#img_photo").attr("src","/users" + ar["photo_filename"] + "?times=" + (new Date().getTime()));
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
				}
				$("#img_E_stamp").hide();
				if(keyID ==5){
					$("#img_A").attr("src","/users" + ar["IDa_filename"] + "?times=" + (new Date().getTime()));
					$("#img_B").attr("src","/users" + ar["IDb_filename"] + "?times=" + (new Date().getTime()));
					$("#f_sign40").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					if(reex == 0){	//初训报名表显示学历
						// $("#img_E").attr("src","/users" + ar["edu_filename"] + "?times=" + (new Date().getTime()));
						// $("#f_sign50").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					}else{
						$("#img_E_stamp").hide();
					}
					if(kindID == 1){	//显示培训证明
						$("#img_P").attr("src","/users" + ar["proof_filename"] + "?times=" + (new Date().getTime()));
					}
				}
				if(sign>""){
					$("#f_sign20").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign30").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					let date1 = new Date(sDate).format("yyyy.MM.dd");
					let date2 = new Date(startDate).format("yyyy.MM.dd");
					$("#date").html(date1.substr(0,4));
					$("#dateM").html(date1.substr(5,2));
					$("#dateD").html(date1.substr(8,2));
					$("#date1").html(date1.substr(0,4));
					$("#date1M").html(date1.substr(5,2));
					$("#date1D").html(date1.substr(8,2));
					$("#date0").html(date2.substr(0,4));
					$("#date0M").html(date2.substr(5,2));

				}else{
					$("#f_sign20").hide();
					$("#f_sign30").hide();
				}

				var p = 0;
				if(keyID < 3){
					//打印学历证明、身份证
					p = 1;
					s = 1;
					getMaterials1(ar["username"],sign,p,k,s,keyID);
				}
				if(keyID < 3 || keyID == 4){	//
					getAgreement(ar["username"],ar["name"],course,sign,sDate,price,unit,host);	//协议书
				}
				if(keyID==1){
					resumePrint();
				}
			}else{
				//alert("没有找到要打印的内容。");
				return false;
			}
		}, 'json');
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

<body style="background:#ffffff;">

<div align='left'>	
	
	<div style="width:1000;float:left;margin:0;">
		<div id="resume_print" style="border:none;width:100%;margin:1px;line-height:18px;">
			<div style="position: relative; width:800px;height:99%;">
				<div style="position: absolute; z-index:10; width:100%;">
					<div style='text-align:center; margin:5px 0 10px 0;'><h3 id="reexamine" style='font-size:1.55em; font-family: 幼圆;'></h3></div>
					<div style='text-align:left; margin:15px 10 10px 30px;'><p style='font-size:1.5em; font-family: 幼圆;'>申请类别：<input type="checkbox" id="R0" />&nbsp;初次取证&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="R2" />&nbsp;换证</p></div>
					<table class='table_resume' style='width:99%;border:2px solid black;'>
					<tr>
						<td align="center" class='table_resume_title' width='10%' height='40px'>姓名</td><td align="center" width='13%'><p style='font-size:1em;' id="name"></p></td>
						<td align="center" class='table_resume_title' width='10%'>性别</td><td align="center" width='14%'><p style='font-size:1em;' id="sexName"></p></td>
						<td align="center" class='table_resume_title' width='13%'>出生年月</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="birthday"></p></td>
						<td rowspan="4" colspan="2" align="center" class='table_resume_title' width='18%'>
							<img id="img_photo" src="" value="" style='width:100px;border:none;' />
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='40px'>证件号码</td><td align="center" colspan="3"><p style='font-size:1em;' id="username"></p></td>
						<td align="center" class='table_resume_title'>文化程度</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="educationName"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='40px'>工作单位</td><td align="center" colspan="3"><p style='font-size:1em;' id="unit"></p></td>
						<td align="center" class='table_resume_title'>从事岗位</td><td align="center"><p style='font-size:1em;' id="job"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='40px'>联系地址</td><td align="center" colspan="3"><p style='font-size:1em;' id="address"></p></td>
						<td align="center" class='table_resume_title'>联系方式</td><td align="center"><p style='font-size:1em;' id="mobile"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='40px'>培训机构</td><td align="center" colspan="3"><p style='font-size:1em;' id="hostName"></p></td>
						<td align="center" class='table_resume_title'>培训时间</td>
						<td align="center" colspan="3">
								<span id="date0" style='font-size:1em;padding-left:10px;padding-top:20px;'></span>
								<span style='font-size:1.2em;'>年</span>
								<span id="date0M" style='font-size:1em;padding-top:20px;'></span>
								<span style='font-size:1.2em;'>月</span>
						</td>
					</tr>
					<tr>
						<td align="center" rowspan="6" class='table_resume_title' height='40px'>申<br>请<br>项<br>目</td>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='40px'>电工作业</td>
						<td align="left" colspan="5" class="ef1p1" style='line-height: 1.5;'>
							<input type="checkbox" id="CC12" />&nbsp;低压电工作业 <input type="checkbox" id="CC27" />&nbsp;高压电工作业 <input type="checkbox" id="CCE01" />&nbsp;电力电缆作业</br>
							<input type="checkbox" id="CCE02" />&nbsp;继电保护作业 <input type="checkbox" id="CCE03" />&nbsp;电气试验作业
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
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='40px'>涉氨制冷作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" id="CC25" />&nbsp;涉氨制冷设备运行、维修操作作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;line-height: 1.5;" height='40px'>冶金、有色、建材生产<br>安全作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" />&nbsp;煤气作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;">危险化学品安全作业</td>
						<td align="left" colspan="5" class="ef1p1" style='line-height: 1.5;'>
							<input type="checkbox" id="CCE05" />&nbsp;光气及光气化工艺 <input type="checkbox" id="CCE06" />&nbsp;氧碱电解工艺 <input type="checkbox" id="CCE07" />&nbsp;氯化工艺<br>
							<input type="checkbox" id="CCE08" />&nbsp;硝化工艺 <input type="checkbox" id="CCE09" />&nbsp;合成氨工艺 <input type="checkbox" id="CCE10" />&nbsp;裂解(裂化)工艺 <br>
							<input type="checkbox" id="CCE011" />&nbsp;氟化工艺 <input type="checkbox" id="CCE012" />&nbsp;加氢工艺<input type="checkbox" id="CCE013" />&nbsp;重氮化工艺 <input type="checkbox" id="CCE014" />&nbsp;氧化工艺 <br> 
							<input type="checkbox" id="CCE015" />&nbsp;过氧化工艺 <input type="checkbox" id="CCE016" />&nbsp;胺基化工艺 <input type="checkbox" id="CCE017" />&nbsp;磺化工艺 <input type="checkbox" id="CCE018" />&nbsp;聚合工艺 <br>
							<input type="checkbox" id="CCE019" />&nbsp;烷基化工艺 <input type="checkbox" />&nbsp;新型煤化工工艺 <input type="checkbox" />&nbsp;电石生产工艺<br>
							<input type="checkbox" />&nbsp;偶氮化工艺 <input type="checkbox" id="CCE020" />&nbsp;化工自动化控制仪表作业
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='40px'>健<br>康<br>承<br>诺</td>
						<td align="left" colspan="7" class="ef1p1">
							<p class="ef1p1" style='text-indent:30px;font-weight:bold;padding:10px;line-height: 1.5;'>
							我承诺：本人身体健康，肢体健全，无器质性心脏病、癫痫病、美尼尔氏症、眩晕症、癔症、帕金森病、精神病、痴呆以及影响肢体活动的神经系统疾病，且无妨碍安全作业的身体缺陷。
							</p>
							<div style="display:table-cell;height:40px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;padding-left:200px;'>承诺人（签名）：</span>
								<span style="position: relative; top: 5px;"><img id="f_sign20" src="" style="max-width:150px;max-height:35px;padding-left:10px;"></span>
								<span id="date" style='font-size:1.5em;padding-left:10px;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>年</span>
								<span id="dateM" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>月</span>
								<span id="dateD" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>日</span>
							</div>
						</td>
					</tr>
					<tr>
						<td align="left" colspan="8" style="padding-left:5px;line-height: 1.5;">
							<p class="ef1p1" style='font-weight:bold;font-size:1.5em;'>申请须知：</p>
							<p class="ef1p1" style='text-indent:30px;'>
							1.申请人须年满18 周岁，且不超过国家法定退休年龄。申请人须提交有效身份证件复印件1 份（复印件应使用A4 白色复印纸，复印件应清晰、完整）、安全技术培训学时证明。
							</p>
							<p class="ef1p1" style='text-indent:30px;'>
							2.申请人申请危险化学品安全作业、冶金（有色）生产安全作业考试的，须具备高中或者相当于高中及以上文化程度。符合免予安全技术培训条件的申请人须提交学历证明、职业技能等级证书等材料。
							</p>
							<p class="ef1p1" style='text-indent:30px;'>
							3.申请人须提交1 寸近期（半年内）免冠彩色照片电子版，分辨率为295 像素×413 像素，格式为jpg，文件大小在100kb 以内，头部占照片尺寸的2/3，人像清晰，神态自然，无明显畸变，未美颜处理。
							</p>
							<p class="ef1p1" style='text-indent:30px;'>
							4.申请人经考试成绩合格后，可通过“免申即享”服务，获取特种作业操作证。
							</p>
						</td>
					</tr>
					<tr>
						<td align="left" colspan="8" style="padding-left:5px;">
							<p class="ef1p1" style='text-indent:30px;font-weight:bold;padding:5px;'>
							本人已阅读并充分了解上述申请须知。本人承诺所提供的资料真实、完整、有效，如因提供资料虚假而产生相关影响，由本人承担全部责任。
							</p>
							<div style="display:table-cell;height:40px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;padding-left:300px;'>申请人（签名）：</span>
								<span style="position: relative; top: 5px;"><img id="f_sign30" src="" style="max-width:150px;max-height:35px;padding-left:10px;"></span>
								<span id="date1" style='font-size:1.5em;padding-left:10px;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>年</span>
								<span id="date1M" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>月</span>
								<span id="date1D" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>日</span>
							</div>
						</td>
					</tr>
					</table>
				<div class="ef1p1" style="float:right; padding-right:10px;">（2026 年6 月版）</div>
				</div>
			</div>
			<div id="keyItem4">
				<div id="commitmentCover"></div>
				<div id="materialsCover1"></div>
				<div id="materialsCover5"></div>
				<div id="agreementCover"></div>
			</div>
			<div id="keyItem5" style="flex:1; text-align:center; width:800px;padding-left:20px;">
				<div style="position: relative;">
					<div style="position: absolute; z-index:10;">
					<div style="float:center; text-align:center;">
						<span><img id="f_sign40" src="" style="width:120px;margin:0px 0px 0px 520px;padding-left:0px;padding-top:360px;"></span>
					</div>
					</div>
					<div style="position: absolute; z-index:10;">
					<div style="float:center; text-align:center;">
						<span><img src="images/sign_stamp.png" style="width:180px;margin:0px 0px 0px 440px;padding-left:0px;padding-top:330px;opacity:0.6;"></span>
					</div>
					</div>
				</div>
				<div><img id="img_A" src="" value="" style="max-width:600px;max-height:500px;padding-top:20px;" /></div>
				<div><img id="img_B" src="" value="" style="max-width:600px;max-height:500px;padding-top:20px;" /></div>
			</div>
			<div id="keyItem6" style="text-align:center; width:800px;padding-left:20px;">
				<div style="position: relative;">
					<div style="position: absolute; z-index:10;">
					<div style="float:center; text-align:center;">
						<span><img id="f_sign50" src="" style="width:120px;margin:0px 0px 0px 630px;padding-left:0px;padding-top:290px;"></span>
					</div>
					</div>
					<div style="position: absolute; z-index:10;">
					<div style="float:center; text-align:center;">
						<span id="img_E_stamp"><img src="images/sign_stamp.png" style="width:180px;margin:0px 0px 0px 550px;padding-left:0px;padding-top:260px;opacity:0.6;"></span>
					</div>
					</div>
				</div>
				<div><img id="img_E" src="" value="" style="max-width:600px;max-height:980px;padding-top:20px;" /></div>
			</div>
			<div id="keyItem7" style="text-align:center; width:800px;padding-left:20px;">
				<div><img id="img_P" src="" value="" style="max-width:600px;max-height:980px;padding-top:20px;" /></div>
			</div>
		</div>
	</div>
  </div>
</div>
</body>
