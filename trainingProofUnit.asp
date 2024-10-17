<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.5"  rel="stylesheet" type="text/css" />
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
		nodeID = "<%=nodeID%>";		//classID
		keyID = "<%=keyID%>";		//0 预览  1 打印
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		getNodeInfo(nodeID);
});

	function getNodeInfo(id){
		$.getJSON(uploadURL + "/public/getUnitTrainingProofInfo?classID=" + id + "&times=" + (new Date().getTime()),function(ar){
			if(ar>""){
				$("#applyID").html(ar["applyID"]);
				$("#certName").html(ar["certName"]);
				$("#R" + ar["reexamine"]).prop("checked",true);
				$("#ys").html(ar["dateStart"].substring(0,4));
				$("#ms").html(ar["dateStart"].substring(5,7));
				$("#ds").html(ar["dateStart"].substring(8,10));
				$("#ye").html(ar["dateEnd"].substring(0,4));
				$("#me").html(ar["dateEnd"].substring(5,7));
				$("#de").html(ar["dateEnd"].substring(8,10));
				$("#yy").html(ar["dateEnd"].substring(0,4));
				$("#mm").html(ar["dateEnd"].substring(5,7));
				$("#dd").html(ar["dateEnd"].substring(8,10));
				$("#reexamine1").html("（" + (ar["reexamine"]==0?"初次取证":"复审") + "）");
				$("#unit").html(ar["hostName"]);
				$("#stamp").attr("src","/users/upload/companies/stamp/" + ar["host"] + ".png" + "?times=" + (new Date().getTime()));
				$("#f_sign").attr("src","/users/upload/companies/signature/host_" + ar["host"] + ".png" + "?times=" + (new Date().getTime()));
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

<body style="background:#fff; width:700px; height:900px;">

<div>	
	
	<div style="width:100%;float:left;margin:0;">
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style="position: relative;">
				<div style="position: absolute; z-index:10; width:100%;">
				<table class='table_resume' style='width:99%;'>
				<tr>
					<td align="center" class='table_resume_title' height='60px;' style="border-bottom-style:none;">
						<div style='margin: 10px;text-align:center;'><h2 style='font-size:2.8em; margin:30px 0 0 0;'>上海市特种作业培训证明</h2></div>
						<div style='margin: 10px;text-align:center;'><h2 style='font-size:2.2em;'>（机构申报版）</h2></div>
					</td>
				</tr>
				<tr>
					<td class='table_resume_title' height='30px;' style="border-bottom-style:none; border-top-style:none;">
						<div style='float:left; margin:30px 0 10px 0; padding-left:30px;'><span class='h3'>上海市安全生产资格考试机构（上海市安全生产科学研究所）:</span></div>
					</td>
				</tr>
				<tr>
					<td align="left" class='table_resume_title' height='45px;' style="border-bottom-style:none; border-top-style:none;">
						<div style='float:left;margin:30px; padding-left:10px; text-align: left; line-height: 2; text-indent:4em;'>
							<span class='h3'>兹有班级班号&nbsp;&nbsp;</span><span class='h3u' id="applyID"></span>
							<span class='h3'>，于</span>
							<span class='h3u' id="ys"></span><span class='h3'>年</span>
							<span class='h3u' id="ms"></span><span class='h3'>月</span>
							<span class='h3u' id="ds"></span><span class='h3'>日</span>
							<span class='h3'>至</span>
							<span class='h3u' id="ye"></span><span class='h3'>年</span>
							<span class='h3u' id="me"></span><span class='h3'>月</span>
							<span class='h3u' id="de"></span><span class='h3'>日，在本培训机构参加了特种作业操作项目：</span>
							<span class='h3u' id="certName" style="padding-left:10px;"></span>
							<span class='h3' style="padding-left:10px;">的培训</span>
							<span class='h3' id="reexamine1"></span><span class='h3'>，完成了相应特种作业人员安全技术培训大纲规定的培训内容和培训学时。</span>
						</div>
					</td>
				</tr>
				<tr>
					<td class='table_resume_title' height='30px;' style="border-bottom-style:none; border-top-style:none;">
						<div style='float:left; margin:10px 0 20px 0; padding-left:80px;'><span class='h3'>特此证明。</span></div>
					</td>
				</tr>
				<tr>
					<td class='table_resume_title' height='50px;' style="border-bottom-style:none; border-top-style:none;">
						<div style='float:left; margin:50px 0 20px 0; padding-left:150px;'>
							<span class='h3'>培训机构（盖章）：</span>
							<span id="unit" class='h3' style="padding-left:1px;"></span>
						</div>
					</td>
				</tr>
				<tr>
					<td class='table_resume_title' height='50px;' style="border-bottom-style:none; border-top-style:none;">
						<div style='float:left; margin:10px 0 20px 0; padding-left:172px;'>
							<span class='h3' style="padding-left:0;">经办人（签名）：</span>
							<span style="position: relative; top: 15px;"><img id="f_sign" src="" style="max-width:180px;max-height:50px;padding-left:10px;"></span>
						</div>
					</td>
				</tr>
				<tr>
					<td class='table_resume_title' height='30px;' style="border-bottom-style:none; border-top-style:none;">
						<div style='float:right; margin:10px 0 20px 0; padding-right:50px;'>
							<span class='h3u' id="yy"></span><span class='h3'>年</span>
							<span class='h3u' id="mm"></span><span class='h3'>月</span>
							<span class='h3u' id="dd"></span><span class='h3'>日</span>
						</div>
					</td>
				</tr>
				<tr>
					<td class='table_resume_title' height='30px;' style="border-bottom-style:none; border-top-style:none;">
						<div style='float:left; margin:30px; padding-left:10px;text-align: left; line-height: 1.8;'>
							<span class='h3' style='font-size:1.4em; font-weight:bold; padding-left:2.6em;'>
							相关法律责任：
							</span>
							<span class='h3' style='font-size:1.4em;'>
							根据《特种作业人员安全技术培训考核管理规定》（原国家安监总局令第30号公布，第63号、第80号修正）第十三条第一款“参加特种作业操作资格考试的人员，应当填写考试申请表，由申请人或者申请人的用人单位持学历证明或者培训机构出具的培训证明向申请人户籍所在地或者从业所在地的考核发证机关或其委托的单位提出申请”的规定，培训机构需出具培训证明。
							</span>
							<span class='h3' style='font-size:1.4em; font-weight:bold;'>
							培训机构应依法对所出具培训证明的真实性负责！
							</span>
						</div>
					</td>
				</tr>
				</table>
				</div>
				<div style="position: absolute; z-index:10;">
				<div style="float:center; text-align:center;">
					<span><img id="stamp" src="" style="width:200px;margin:0px 0px 8px 350px;padding-left:30px;padding-top:440px;opacity:0.7;"></span>
				</div>
				</div>
			</div>
		</div>
	</div>
  </div>
</div>
</body>
