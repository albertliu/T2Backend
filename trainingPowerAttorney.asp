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
	.h2{
		font-size:2em;
	}
	.h3{
		font-size:1.8em;
	}
	.h3u{
		font-size:1.8em;
		text-decoration: underline;
	}
	@font-face {
		font-family: "qyt"; /* 你可以自定义这个名称，建议用有意义的英文或拼音 */
		src: url("fonts/qyt.ttf"); /* 这里替换成你存放字体文件的真实路径和文件名 */
	}
</style>

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var keyID = 0;
	var updateCount = 1;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		keyID = "<%=keyID%>";		//0 预览  1 打印
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});
		//getNeed2know(nodeID);
		getNodeInfo(nodeID);
	});

	function getNodeInfo(id){
		$.post(uploadURL + "/public/postCommInfo", {proc:"getTrainingPowerAttorney", params:{enterID:id}},function(data){
			let ar = data[0];
			if(ar>""){
				$("#username").html(ar["username"]);
				$("#name").html(ar["name"]);
				$("#certName").html("操作项目：" + ar["certName"]);
				let r = ar["reexamine"]==0?0:2;
				$("#R" + r).prop("checked",true);
				if(ar["username"].length==18){
					$("#IDK0").prop("checked",true);
				}else{
					$("#IDK1").prop("checked",true);
				}
				$("#mobile").html(ar["mobile"]);
				$("#regNo").html(ar["regNo"]);
				$("#agent").html(ar["linker"] + "&nbsp;" + ar["agent_ID"]);
				$("#agent_phone").html(ar["phone"]);
				$("#kind" + ar["kind"]).prop("checked",true);
				$("#industry").html("行业类别：" + ar["item"]);
				if(ar["kind"]==1){
					$("#type" + ar["type"]).prop("checked",true);
				}	
				let today = ar["today"];
				let y = today.substring(0,4);
				let m = today.substring(5,7);
				let d = today.substring(8,10);
				$("#dateY1").html(y);
				$("#dateM1").html(m);
				$("#dateD1").html(d);
				$("#dateY2").html(y);
				$("#dateM2").html(m);
				$("#dateD2").html(d);
				$("#f_sign1").attr("src","/users" + ar["signature"] + "?times=" + (new Date().getTime()));
				$("#unit").html(ar["hostName"]);
				$("#stamp").attr("src","/users/upload/companies/stamp/" + ar["host"] + ".png" + "?times=" + (new Date().getTime()));
				$("#f_sign2").attr("src","/users/upload/companies/signature/poa_" + ar["host"] + ".png" + "?times=" + (new Date().getTime()));
				// $("#unit").html("上海智能消防学校");
				// $("#stamp").attr("src","/users/upload/companies/stamp/znxf.png" + "?times=" + (new Date().getTime()));
				// $("#f_sign2").attr("src","/users/upload/companies/signature/poa_znxf.png" + "?times=" + (new Date().getTime()));
			}else{
				alert("没有找到培训信息。");
				return false;
			}
			if(keyID==1){
				resumePrint();
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

<div id='layout' align='left' style="background:#ffffff;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style="position: relative;">
				<div style="position: absolute; z-index:10; width:100%;">
				<div style='text-align:center; margin:5px 0 20px 0;'><h3 style='font-size:1.55em; font-family: 幼圆;'>委托书</h3></div>
				<table class='table_resume' style='width:99%;'>
					<tr>
						<td align="center" class='table_resume_title' width='20%' height='40px'>类别</td>
						<td align="center" class='table_resume_title' width='20%'>项目</td>
						<td align="center" class='table_resume_title' width='60%' colspan='2'>内容</td>
					</tr>
					<tr>
						<td align="center" rowspan="4" class='table_resume_title'>委托人信息</td>
						<td align="left" class='table_resume_title' height='40px'>姓名</td>
						<td align="left" id="name" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>证件类型</td>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;"><input type="checkbox" id="IDK0"  />&nbsp;身份证&nbsp; <input type="checkbox" />&nbsp;护照&nbsp; <input type="checkbox" id="IDK1" />&nbsp;其他：</td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>证件号码</td>
						<td align="left" id="username" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>联系电话</td>
						<td align="left" id="mobile" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="center" rowspan="4" class='table_resume_title'>受托机构信息</td>
						<td align="left" class='table_resume_title' height='40px'>机构名称</td>
						<td align="left" id="unit" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>统一社会信用代码</td>
						<td align="left" id="regNo" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>经办人及身份证号</td>
						<td align="left" id="agent" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>联系电话</td>
						<td align="left" id="agent_phone" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="center" rowspan="4" class='table_resume_title'>委托事项</td>
						<td align="left" class='table_resume_title' height='40px'>委托事由</td>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px; line-height:1.5;">本市安全生产考试报名（包括提交报名材料、填写报名信息、缴纳报名费用等与本次报名相关的全部事项）</td>
					</tr>
					<tr>
						<td align="left" rowspan="2" class='table_resume_title' height='40px'>具体事项</td>
						<td align="center" class='table_resume_title'>考试项目</td>
						<td align="left" class="ef1p1" style="padding-left:10px; line-height:1.5;">
							<input type="checkbox" id="kind0" />&nbsp;1、特种作业人员安全技术考试： 
							<p style='font-size:1em;' id="certName"></p>
							<input type="checkbox" id="kind1" />&nbsp;2、安全生产知识和管理能力考试：
							<p style='font-size:1em;' id="industry"></p>
							人员类别：<input type="checkbox" id="type0" />&nbsp;负责人&nbsp; <input type="checkbox" id="type1" />&nbsp;安全生产管理人员
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title'>考试类型</td>
						<td align="left" class="ef1p1" style="padding-left:10px;">
							<input type="checkbox" id="R0" />&nbsp;初次取证&nbsp;&nbsp; <input type="checkbox" id="R2" />&nbsp;换证
						</td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>委托权限</td>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px; line-height:1.5;">对受托机构在办理上述事项过程中所签署的相关文件，我均予以认可，并承担相应的责任。</td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>委托期限</td>
						<td align="left" colspan="3" class="ef1p1" style="padding-left:10px;">自签署之日起至上述事项办完为止。</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='40px'></td>
						<td align="left" class='table_resume_title'>委托声明</td>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px; line-height:1.5;">此前未在其他省市申请过同类别考试项目，亦无未完成的考试流程；委托有效期内，不自行或委托其他机构/个人在其他地区重复报名，否则一切后果自负，与被委托人无关。</td>
					</tr>
					<tr>
						<td align="center" rowspan="2" class='table_resume_title'>委托人签章</td>
						<td align="left" class='table_resume_title' height='40px'>委托人签字</td>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;">
							<span style="position: relative; top: 5px;"><img id="f_sign1" src="" style="max-width:150px;max-height:35px;padding-left:10px;"></span>
						</td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>日期</td>
						<td align="left" id="date1" colspan="2" class="ef1p1" style="padding-left:10px;">
							<div style="display:table-cell;height:40px;vertical-align:middle;text-align:center">
								<span id="dateY1" style='font-size:1.5em;padding-left:10px;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>年</span>
								<span id="dateM1" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>月</span>
								<span id="dateD1" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>日</span>
							</div>
						</td>
					</tr>
					<tr>
						<td align="center" rowspan="3" class='table_resume_title'>受托机构签章</td>
						<td align="left" class='table_resume_title' height='40px'>机构盖章</td>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>经办人签字</td>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;">
							<span style="position: relative; top: 2px;"><img id="f_sign2" src="" style="max-width:150px;max-height:35px;padding-left:10px;"></span>
						</td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>日期</td>
						<td align="left" id="date2" colspan="2" class="ef1p1" style="padding-left:10px;">
							<div style="display:table-cell;height:40px;vertical-align:middle;text-align:center">
								<span id="dateY2" style='font-size:1.5em;padding-left:10px;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>年</span>
								<span id="dateM2" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>月</span>
								<span id="dateD2" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>日</span>
							</div>
						</td>
					</tr>
				</table>
				</div>
				<div style="position: absolute; z-index:10;">
				<div style="float:center; text-align:center;">
					<span><img id="stamp" src="" style="width:180px;margin:0px 0px 8px 350px;padding-left:30px;padding-top:820px;opacity:0.7;"></span>
				</div>
				</div>
			</div>
		</div>
	</div>
  </div>
</div>
</body>
