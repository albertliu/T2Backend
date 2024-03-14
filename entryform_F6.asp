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
				// $("#SNo").html(ar[0]);
				$("#certName").html(ar[56]);
				$("#currDiplomaID").html(ar[36]);
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
			<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>建筑施工特种作业人员安全技术培训考核复训报名表</h3></div>
			<div style='margin: 12px;text-align:left; width:95%;padding-top:20px;'>
				<span style='font-size:1.2em;'>操作工种：</span><span style='font-size:1.2em;' id="certName"></span>
				<span style='font-size:1.2em;float:right;padding-right:50px;'>编号：</span>
			</div>
			<table class='table_resume' style='width:95%;'>
				<tr>
					<td align="center" class='table_resume_title' width='15%' height='60px;' colspan="2">姓名</td>
					<td align="center" width='15%'><p style='font-size:1em;' id="name"></p></td>
					<td align="center" class='table_resume_title' width='15%'>性别</td>
					<td align="center" width='15%'><p style='font-size:1em;' id="sexName"></p></td>
					<td align="center" class='table_resume_title' width='20%'>文化程度</td>
					<td align="center" width='20%'><p style='font-size:1em;' id="educationName"></p></td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' height='60px;' colspan="2">身份证号</td>
					<td align="center" colspan="3"><p style='font-size:1em;' id="username"></p></td>
					<td align="center" class='table_resume_title'>操作证号</td>
					<td align="center"><p style='font-size:1em;' id="currDiplomaID"></p></td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' height='60px;' colspan="2">工作单位</td>
					<td align="center" colspan="3"><p style='font-size:1em;' id="unit"></p></td>
					<td align="center" class='table_resume_title'>本人手机号</td>
					<td align="center"><p style='font-size:1em;' id="mobile"></p></td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' height='60px;' colspan="2">单位地址</td>
					<td align="center" colspan="3"><p style='font-size:1em;' id="email"></p></td>
					<td align="center" class='table_resume_title'>单位联系电话</td>
					<td align="center"><p style='font-size:1em;' id="phone"></p></td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' height='320px;'>安<br>全<br>操<br>作<br>情<br>况</td>
					<td align="center" class='table_resume_title' colspan="6">
						<img id="img_cardA" src="" value="" style='disply:block;width:350px;height:auto;max-height:250px;border:none;' />
					</td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' height='150px;'>单<br>位<br>意<br>见</td>
					<td align="center" class='table_resume_title' colspan="6">
						<div style='float:right; padding-top:50px; padding-right:150px;line-height:25px;'>
							<div><p style='font-size:1.2em;'>经办人：__________</p></div>
							<div><p style='font-size:1.2em;'>（单位盖章）</p></div>
							<div><p style='font-size:1.2em;'>年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日</p></div>
						</div>
					</td>
				</tr>
				<tr>
					<td align="center" class='table_resume_title' height='100px;'>备<br>注</td>
					<td align="center" class='table_resume_title' colspan="6">
					</td>
				</tr>
			</table>
			<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>1、此表内容逐项填清，字迹端正，并单位盖章。</p></div>
			<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>2、请携带操作证书原件到附近考核站办理报名手续。</p></div>
		</div>
	</div>
  </div>
</div>
</body>
