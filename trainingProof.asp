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
	.h2{
		font-size:1.5em;
	}
	.h3{
		font-size:1.4em;
	}
	.h3u{
		font-size:1.4em;
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
		$.getJSON(uploadURL + "/public/getTrainingProofInfo?enterID=" + id + "&times=" + (new Date().getTime()),function(ar){
			if(ar>""){
				$("#ID").html(ar["No"]);
				$("#username").html(ar["username"]);
				$("#name").html(ar["name"]);
				$("#sexName").html(ar["sexName"]);
				$("#certName").html(ar["certName"]);
				$("#ID1").html(ar["No"]);
				$("#username1").html(ar["username"]);
				$("#name1").html(ar["name"]);
				$("#sexName1").html(ar["sexName"]);
				$("#certName1").html(ar["certName"]);
				$("#R" + ar["reexamine"]).prop("checked",true);
				$("#ys1").html(ar["dateStart"].substring(0,4));
				$("#ms1").html(ar["dateStart"].substring(5,7));
				$("#ds1").html(ar["dateStart"].substring(8,10));
				$("#ye1").html(ar["dateEnd"].substring(0,4));
				$("#me1").html(ar["dateEnd"].substring(5,7));
				$("#de1").html(ar["dateEnd"].substring(8,10));
				$("#ys2").html(ar["dateStart"].substring(0,4));
				$("#ms2").html(ar["dateStart"].substring(5,7));
				$("#ds2").html(ar["dateStart"].substring(8,10));
				$("#ye2").html(ar["dateEnd"].substring(0,4));
				$("#me2").html(ar["dateEnd"].substring(5,7));
				$("#de2").html(ar["dateEnd"].substring(8,10));
				$("#reexamine").html("(" + (ar["reexamine"]==0?"初训":"复训") + ")，");
				$("#unit").html(currHostName);
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

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="text-align:center;">
		<input class="button" type="button" id="print" value="打印" />&nbsp;
		</div>
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			
			<table class='table_resume' style='width:99%;'>
			<tr>
				<td align="center" class='table_resume_title' height='45px;' style="border-bottom-style:none">
					<div style='margin: 20px;text-align:center;'><h2 style='font-size:1.5em;'>培训证明（存根）</h2></div>
				</td>
			</tr>
			<tr>
				<td class='table_resume_title' height='30px;' style="border-bottom-style:none; border-top-style:none;">
					<div style='float:right; margin:10px 0 20px 0; padding-right:50px;'><span class='h3'>编号：</span><span class='h3u' id="ID"></span></div>
				</td>
			</tr>
			<tr>
				<td align="left" class='table_resume_title' height='45px;' style="border-bottom-style:none; border-top-style:none;">
					<div style='float:left;margin:10px 0 20px 0; padding-left:50px;'>
						<span class='h3'>姓名：</span><span class='h3u' id="name"></span><span class='h3' style="padding-left:30px;">身份证号：</span><span class='h3u' id="username"></span>
					</div>
				</td>
			</tr>
			<tr>
				<td align="left" class='table_resume_title' height='45px;' style="border-bottom-style:none; border-top-style:none;">
					<div style='float:left;margin:10px 0 20px 0; padding-left:50px;'>
						<span class='h3'>操作项目：</span><span class='h3u' id="certName"></span><span class='h3' style="padding-left:30px;">培训类别：</span><input type="checkbox" id="R0" />&nbsp;<span class='h3'>初训</span> <input type="checkbox" id="R1" />&nbsp;<span class='h3'>复训</span>
					</div>
				</td>
			</tr>
			<tr>
				<td align="left" class='table_resume_title' height='45px;' style="border-top-style:none;">
					<div style='float:left; margin:10px 0 40px 0; padding-left:50px;'>
						<span class='h3'>培训日期：</span><span class='h3u' id="name"></span>
						<span class='h3u' id="ys1"></span><span class='h3'>年</span>
						<span class='h3u' id="ms1"></span><span class='h3'>月</span>
						<span class='h3u' id="ds1"></span><span class='h3'>日-</span>
						<span class='h3u' id="ye1"></span><span class='h3'>年</span>
						<span class='h3u' id="me1"></span><span class='h3'>月</span>
						<span class='h3u' id="de1"></span><span class='h3'>日</span>
					</div>
					<div style='float:right; margin:13px 0 20px 0; padding-right:30px;'>
						<span>（加盖骑缝章）</span>
					</div>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='60px;' style="border-bottom-style:none;">
					<div style='margin: 40px;text-align:center;'><h2 style='font-size:1.5em;'>培&nbsp;&nbsp;训&nbsp;&nbsp;证&nbsp;&nbsp;明</h2></div>
				</td>
			</tr>
			<tr>
				<td class='table_resume_title' height='30px;' style="border-bottom-style:none; border-top-style:none;">
					<div style='float:right; margin:10px 0 20px 0; padding-right:50px;'><span class='h3'>编号：</span><span class='h3u' id="ID1"></span></div>
				</td>
			</tr>
			<tr>
				<td class='table_resume_title' height='30px;' style="border-bottom-style:none; border-top-style:none;">
					<div style='float:left; margin:10px 0 20px 0; padding-left:30px;'><span class='h3'>上海市安全生产资格考试机构:</span></div>
				</td>
			</tr>
			<tr>
				<td align="left" class='table_resume_title' height='45px;' style="border-bottom-style:none; border-top-style:none;">
					<div style='float:left;margin:10px 0 20px 0; padding-left:50px;'>
						<span class='h3'>兹有学员&nbsp;&nbsp;</span><span class='h3u' id="name1"></span>
						<span class='h3' style="padding-left:30px;">性别&nbsp;&nbsp;</span><span class='h3u' id="sexName"></span>
						<span class='h3' style="padding-left:30px;">身份证号：&nbsp;</span><span class='h3u' id="username1"></span>
					</div>
				</td>
			</tr>
			<tr>
				<td align="left" class='table_resume_title' height='45px;' style="border-top-style:none;">
					<div style='float:left; margin:10px 0 20px 0; padding-left:50px;'>
						<span class='h3'>于</span><span class='h3u' id="name1"></span>
						<span class='h3u' id="ys2"></span><span class='h3'>年</span>
						<span class='h3u' id="ms2"></span><span class='h3'>月</span>
						<span class='h3u' id="ds2"></span><span class='h3'>日-</span>
						<span class='h3u' id="ye2"></span><span class='h3'>年</span>
						<span class='h3u' id="me2"></span><span class='h3'>月</span>
						<span class='h3u' id="de2"></span><span class='h3'>日，在本培训机构</span><span class='h3u' id="unit" style="padding-left:5px;"></span>
					</div>
				</td>
			</tr>
			<tr>
				<td align="left" class='table_resume_title' height='45px;' style="border-bottom-style:none; border-top-style:none;">
					<div style='float:left;margin:10px 0 20px 0; padding-left:50px;'>
						<span class='h3'>参加了</span><span class='h3u' id="certName1" style="padding-left:30px;"></span><span class='h3' style="padding-left:30px;">的培训</span><span class='h3' id="reexamine"></span>
					</div>
				</td>
			</tr>
			<tr>
				<td class='table_resume_title' height='30px;' style="border-bottom-style:none; border-top-style:none;">
					<div style='float:left; margin:10px 0 20px 0; padding-left:50px;'><span class='h3'>完成了规定的安全培训大纲要求的培训内容和培训时间。</span></div>
				</td>
			</tr>
			<tr>
				<td class='table_resume_title' height='30px;' style="border-bottom-style:none; border-top-style:none;">
					<div style='float:left; margin:10px 0 20px 0; padding-left:80px;'><span class='h3'>特此证明。</span></div>
				</td>
			</tr>
			<tr>
				<td class='table_resume_title' height='50px;' style="border-bottom-style:none; border-top-style:none;">
					<div style='float:center; margin:10px 0 20px 0;'>
						<span class='h3'>培训机构（盖章）：</span>
						<span class='h3' style="padding-left:60px;">经办人（签名）：</span>
					</div>
				</td>
			</tr>
			<tr>
				<td class='table_resume_title' height='30px;' style="border-bottom-style:none; border-top-style:none;">
					<div style='float:right; margin:10px 0 20px 0; padding-right:50px;'><span class='h3'>年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</span></div>
				</td>
			</tr>
			</table>
		</div>
	</div>
  </div>
</div>
</body>
