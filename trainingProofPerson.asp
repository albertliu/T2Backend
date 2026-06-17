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
		$.post(uploadURL + "/public/postCommInfo", {proc:"getTrainingProofInfo", params:{enterID:id}},function(data){
			let ar = data[0];
			if(ar>""){
				$("#username").html(ar["username"]);
				$("#name").html(ar["name"]);
				$("#sexName").html(ar["sexName"]);
				$("#certName").html(ar["certName"]);
				$("#certKind").html(ar["certKind"]);
				$("#reexamine").html(ar["reexamine"]==0?"初次取证":"换证");
				$("#kind").html(ar["username"].length==18?"身份证":"港澳台通行证/护照");
				// $("#attendance").html(ar["attendance"]);
				$("#attendance").html(ar["hours"]);
				$("#hours").html(ar["hours"]);
				$("#date").html(ar["dateStart"] + "至" + ar["dateEnd"]);
				$("#date1").html(ar["dateEnd"]);
				if(ar["photo_filename"] > ""){	//  && keyID !=4
					$("#img_photo").attr("src","/users" + ar["photo_filename"] + "?times=" + (new Date().getTime()));
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
				}
				$("#unit").html(ar["hostName"]);
				$("#stamp").attr("src","/users/upload/companies/stamp/" + ar["host"] + ".png" + "?times=" + (new Date().getTime()));
				// $("#unit").html("上海智能消防学校");
				// $("#stamp").attr("src","/users/upload/companies/stamp/znxf.png" + "?times=" + (new Date().getTime()));
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
				<table class='table_resume' style='width:99%;'>
					<tr>
						<td align="center" class='table_resume_title' colspan="4" height='80px'><h3>特种作业人员安全技术培训证明</h3></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>姓名</td>
						<td align="left" id="name" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
						<td rowspan="4" align="center" class='table_resume_title' width='18%'>
							<img id="img_photo" src="" value="" style='width:100px;border:none;' />
						</td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>性别</td>
						<td align="left" id="sexName" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>证件类型</td>
						<td align="left" id="kind" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>证件号码</td>
						<td align="left" id="username" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>培训类型</td>
						<td align="left" id="reexamine" colspan="3" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>作业类别</td>
						<td align="left" id="certKind" colspan="3" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>操作项目</td>
						<td align="left" id="certName" colspan="3" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>培训日期</td>
						<td align="left" id="date" colspan="3" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' colspan="2" height='40px'>应修学时</td>
						<td align="center" class='table_resume_title' colspan="2" height='40px'>实修学时</td>
					</tr>
					<tr>
						<td align="center" id="hours" colspan="2" class="ef1p1" height='40px' style="padding-left:10px;"></td>
						<td align="center" id="attendance" colspan="2" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='40px'>培训单位名称</td>
						<td align="left" id="unit" colspan="3" class="ef1p1" style="padding-left:10px;"></td>
					</tr>
					<tr>
						<td align="left" colspan="4" class="ef1p1" style="padding-left:10px; line-height:1.8;">
						说明：<br>
						我单位已按照《中华人民共和国安全生产法》、《特种作业人员安全技术培训考核管理规定》(应急管理部令第19号)、《安全培训管理办法》(原国家安监总局令第44号)以及《特种作业人员安全技术培训大纲和考核标准》、
						安全生产培训机构基本条件》AQ8011-2023 等法规文件规定，组织开展了特种作业人员安全技术培训，该学员在我单位参加特种作业人员安全技术培训内容和时长符合相关要求，培训合格。
						<br>
						<p class="ef1p1" id="date1" style="float:right; padding-right:10px;"></p>
						</td>
					</tr>
				</table>
				</div>
				<div style="position: absolute; z-index:10;">
				<div style="float:center; text-align:center;">
					<span><img id="stamp" src="" style="width:180px;margin:0px 0px 8px 200px;padding-left:30px;padding-top:420px;opacity:0.7;"></span>
				</div>
				</div>
			</div>
		</div>
	</div>
  </div>
</div>
</body>
