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

		$("#btnFiremanMaterials").click(function(){
			generateFiremanMaterials();
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
				//$("#reexamine").html(ar[41]);
				$("#courseName").html(ar[6]);
				sign = (ar[52]==1?ar[48]:"");
				reex = ar[40];
				course = ar[56];
				sDate = ar[49];
				price = ar[53];
				
				if(sign>""){
					$("#f_sign30").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#date").html(sDate);
				}else{
					$("#f_sign30").hide();
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
				//$("#birthday").html(ar[33].substr(0,7));
				$("#address").html(ar[34]);
				$("#IDaddress").html(ar[38]);
				//$("#ethnicity").html(ar[37]);
				var c = "";
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
				if(ar[24] > ""){
					c += "<a href='/users" + ar[24] + "' target='_blank'>学历证明</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;缺少学历证明";}
				$("#img_education").html(c);
				c = "";
				if(ar[49] > ""){
					c += "<a href='/users" + ar[49] + "' target='_blank'>身份证正反面</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;身份证正反面还未生成";}
				$("#fire_materials").html(c);
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
	
	function generateFiremanMaterials(){
		$.getJSON(uploadURL + "/outfiles/generate_IDcard_materials?username=" + refID + "&registerID=" + currUser ,function(data){
			if(data>""){
				alert("已生成文件");
				getNodeInfo(nodeID, refID);
			}else{
				alert("没有可供处理的数据。");
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

<div id='layout' align='left' style="background:#f0f0f0;width:1000px;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="text-align:center;">
		<input class="button" type="button" id="print" value="打印" />&nbsp;
		</div>
		<div>
		申报文件
			<span id="img_education" style="margin-left:20px;"></span>
			<span id="fire_materials" style="margin-left:20px;"></span>
			<input class="button" style="margin-left:20px;" type="button" id="btnFiremanMaterials" value="生成文件" />
		</div>
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>特种设备作业人员资格申请表</h3></div>
			<div style='margin: 12px;text-align:left; width:95%;'><span style='font-size:1.2em;'>学员编号：</span><span style='font-size:1.2em;' id="SNo"></span></div>
			<table class='table_resume' style='width:99%;'>
			<tr>
				<td align="center" class='table_resume_title' width='18%' height='48px;'>姓名</td><td align="center" width='27%'><p style='font-size:1em;' id="name"></p></td>
				<td align="center" class='table_resume_title' width='15%'>性别</td><td align="center" width='15%'><p style='font-size:1em;' id="sexName"></p></td>
				<td rowspan="4" align="center" class='table_resume_title' width='25%'>
					<img id="img_photo" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='48px;'>身份证件号</td><td align="center"><p style='font-size:1em;' id="username"></p></td>
				<td align="center" class='table_resume_title'>文化程度</td><td class='table_resume_title'><p style='font-size:1em;' id="educationName"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='48px;'>工作单位</td><td align="center" colspan="3"><p style='font-size:1em;' id="company"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='48px;'>工作单位地址</td><td align="center" colspan="3"><p style='font-size:1em;'>上海市______区</p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='48px;'>通信地址</td><td align="center" colspan="4"><p style='font-size:1em;'>上海市______区</p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='48px;'>邮编</td><td align="center"><p id="zip" style='font-size:1em;'></p></td>
				<td align="center" class='table_resume_title'>联系电话</td><td align="center" colspan="2"><p style='font-size:1em;' id="mobile"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='48px;'>申请作业项目</td><td align="center" ><p style='font-size:1em;' id="courseName"></p></td>
				<td align="center" class='table_resume_title'>申请项目代号</td><td align="center" colspan="2"><p style='font-size:1em;' id="certCode">A</p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='120px;'>工作简历</td><td align="left" colspan="4"><p style='font-size:1em;padding-top:60px;padding-left:5px;'>从事特种作业相关工作两年以上</p></td>
			</tr>
				<td align="center" class='table_resume_title' width='15%' height='120px;'>相关资料</td>
				<td align="left" colspan="4">
					<input type="checkbox" />&nbsp;身份证明（复印件1份）</br>
					<input type="checkbox" />&nbsp;学历证明（毕业证复印件1份）</br>
					<input type="checkbox" />&nbsp;体检报告（1份，相应考试大纲有要求的）</br>
				</td>
			<tr>
				<td align="left" class='table_resume_title' width='15%' height='120px;'>
					<p style='font-size:1em;float:left;'>用人单位意见</p>
				</td>
				<td align="left" class='table_resume_title' colspan="4">
					<p style='font-size:1em;float:left;'>（申请人在非户籍工作所在地申请时需填写本栏）</p>
					<br><br>
					<br><br>
					<span style='font-size:1em;float:center;padding-right:50px;'>用人单位（加盖公章）：</span>
					<span style='font-size:1em;float:right;'>年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</span>
				</td>
			</tr>
			<tr>
				<td align="left" class='table_resume_title' height='60px;' colspan="5">
					<p style='font-size:1em;float:left;'>本人声明，以上填写信息及所提交的资料均合法、真实、有效，并承诺对填写内容负责。</p>
					<br><br>
					<span style='font-size:1em;float:center;padding-right:50px;'>申请人（签字）：</span>
					<span><img id="f_sign30" src="" style="width:170px;padding-left:80px;"></span>
					<span id="date" style='font-size:1.2em;float:right;padding-top:10px;padding-right:5px;'>年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</span>
				</td>
			</tr>
			</table>
			<p style='font-size:1.2em;'>注：申请人在网上申请的，填报申请表后打印盖章签字并扫描上传。同时提供身份证明、学历证明复印件各一份。相应考试大纲有要求的，还需提供一份体检报告。</p>
			<div style="page-break-after:always"></div>
			<div id="needCover"></div>
		</div>
	</div>
  </div>
</div>
</body>
