<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.11"  rel="stylesheet" type="text/css" />
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
	var sign = "";
	var sDate = "";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//1 前台打印（报名表和单位证明）  2 班级档案文件（所有内容，鉴定不签字）  3 鉴定档案文件（所有内容，鉴定签字）  4 仅报名表（不显示身份证，签名时展示给学员)   5 仅报名表（申报时用）  
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		//getNeed2know(nodeID);
		getNodeInfo(nodeID, refID);
});

	function getNodeInfo(id,ref){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			// alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > "0"){
				sign = (ar[47]==1?ar[43]:"");
				sDate = ar[44];
				// $("#SNo").html(ar[0]);
				$("#certName").html(ar[56]);
				$("#certName1").html(ar[56]);
				$("#currDiplomaID").html(ar[36]);
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
		$.get("studentControl.asp?op=getNodeInfo&nodeID=0&refID=" + ref + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#username").html(ar[1]);
				$("#name").html(ar[2]);
				$("#sexName").html(ar[8]);
				$("#mobile").html(ar[7]);
				$("#phone").html(ar[13]);
				$("#job").html(ar[14]);
				$("#unit").html(ar[25]);
				$("#educationName").html(ar[21]);
				$("#address").html(ar[24]);
				$("#email").html(ar[12]);
				if(ar[16] > "" && keyID !=4){
					$("#img_cardA").attr("src","/users" + ar[16]);
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
		<div id="resume_print" style="border:none;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div style='text-align:center; margin:10px 0 10px 0;'><h3 style='font-size:1.45em;'>建筑施工特种作业人员安全技术培训考核复训报名表</h3></div>
			<div style='margin: 12px;text-align:left; width:95%;padding-top:20px;'>
				<span style='font-size:1.2em;'>操作工种：</span><span style='font-size:1.2em;' id="certName"></span>
				<span style='font-size:1.2em;float:right;padding-right:80px;'>编号：</span>
			</div>
			<table class='table_resume' style='width:95%;'>
				<tr>
					<td align="center" class='table_resume_title' width='15%' height='52px;' colspan="2">姓名</td>
					<td align="center" width='15%'><p style='font-size:1em;' id="name"></p></td>
					<td align="center" class='table_resume_title' width='15%'>性别</td>
					<td align="center" width='15%'><p style='font-size:1em;' id="sexName"></p></td>
					<td align="center" class='table_resume_title' width='20%'>文化程度</td>
					<td align="center" width='20%'><p style='font-size:1em;' id="educationName"></p></td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' height='52px;' colspan="2">身份证号</td>
					<td align="center" colspan="3"><p style='font-size:1em;' id="username"></p></td>
					<td align="center" class='table_resume_title'>操作证号</td>
					<td align="center"><p style='font-size:1em;' id="currDiplomaID"></p></td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' height='52px;' colspan="2">工作单位</td>
					<td align="center" colspan="3"><p style='font-size:1em;' id="unit"></p></td>
					<td align="center" class='table_resume_title'>本人手机号</td>
					<td align="center"><p style='font-size:1em;' id="mobile"></p></td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' height='52px;' colspan="2">单位地址</td>
					<td align="center" colspan="3"><p style='font-size:1em;' id="email"></p></td>
					<td align="center" class='table_resume_title'>单位联系电话</td>
					<td align="center"><p style='font-size:1em;' id="phone"></p></td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' height='250px;'>特<br>种<br>作<br>业<br>人<br>员<br>应<br>该<br>符<br>合<br>条<br>件</td>
					<td align="left" class='table_resume_title' colspan="6">
					<div style='text-align:left;padding:5px;line-height:25px;'>
						<p style='font-size:1.2em;'>1、年满18周岁，且不超过国家法定退休年龄；</p>
						<p style='font-size:1.2em;'>2、具有初中及以上文化程度；</p>
						<p style='font-size:1.2em;'>3、具有必要的安全技术知识与技能；</p>
						<p style='font-size:1.2em;'>4、相应特种作业规定的其他条件；</p>
						<p style='font-size:1.2em;'>5、有规定实习经历的人员；</p>
						<p style='font-size:1.2em;'>6、经社区或者县级以上医疗机构体检健康合格，并无妨碍从事相应特种作业的器质性心脏病、癫痫病、美尼尔氏症、眩晕症、癔病、震颤麻痹症、精神病、高血压、恐高症、痴呆症以及其他疾病和生理缺陷；</p>
						<p style='font-size:1.5em;'>注：以上信息由学员单位负责确认加盖公章后再报名培训</p>
					</div>
					</td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' colspan="7">
						<div style='float:left; padding-left:8px; line-height:25px;'>
							<div><p style='font-size:1.5em;'>承诺书</p></div>
							<div><p style='font-size:1.2em;text-align:left;text-indent: 2em;'>以上信息经本人确认无误。</p></div>
							<div><p style='font-size:1.2em;text-align:left;text-indent: 2em;'>本人在贵学校申报参加上海市建筑施工企业特种作业操作资格证，初办工种<span id="certName1" style='font-size:1em;'></span>。本工种绝无重复同工种操作证(或已过期)，如有隐瞒按照市建筑安全协会规定，取消办证资格，培训费不得退回。缺课50％以上不得参加考试，责任自负。</p></div>
							<div style="display:table-cell;height:40px;vertical-align:bottom;text-align:center">
								<span style='font-size:1.2em;padding-left:200px;'>学员签字：</span>
								<span><img id="f_sign30" src="" style="width:110px;padding-left:10px;padding-top:0px;"></span>
								<span style='font-size:1.2em;'>日期：</span>
								<span id="date" style='font-size:1.3em;float:right;padding-left:10px;padding-top:22px;color:#555;font-family:"qyt","Ink Free";'></span>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' height='150px;'>单<br>位<br>意<br>见</td>
					<td align="center" class='table_resume_title' colspan="4">
						<div style='float:left; padding-top:60px; padding-left:80px;line-height:25px;'>
							<div><p style='font-size:1.2em;'>经办人：__________</p></div>
							<div><p style='font-size:1.2em;'>（单位盖章）</p></div>
							<div><p style='font-size:1.2em;'>年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日</p></div>
						</div>
					</td>
					<td align="center" class='table_resume_title' colspan="5">
						<img id="img_cardA" src="" value="" style='disply:block;width:300px;height:auto;max-height:200px;border:none;' />
					</td>
				</tr>
			</table>
			<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>1、此表内容逐项填清，字迹端正，并单位盖章。</p></div>
			<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>2、请携带身份证复印件到附近考核站办理报名手续。</p></div>
			<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>3、承诺书必须由本人签字，不得代签。</p></div>
		</div>
	</div>
  </div>
</div>
</body>
