<!--#include file="js/doc1.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title></title>
<meta name="viewport" content="width=device-width">

<!--必要样式-->
<link href="css/style.css?ver=1.0"  rel="stylesheet" type="text/css" id="css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>


<script language="javascript">
	var item = "";
	var updateCount = 0;
	$(document).ready(function (){
		item = "<%=kindID%>";
		$.ajaxSetup({ 
			async: false 
		}); 
		//$("#test").html(item);
		$("#test").hide();
		getNodeInfo();
	});

	function getNodeInfo(){
		//$.get("diplomaControl.asp?op=getNodeInfoShort&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			//var c = "";
			ar = item.split(",");
			if(ar > ""){
				$("#diplomaID").html(ar[0]);
				$("#name").html(ar[1]);
				$("#name1").html(ar[1]);
				$("#username").html(ar[2]);
				$("#hostName").html(ar[5]);
				$("#job").html(ar[6]);
				$("#startDate").html(ar[7]);
				$("#term").html(ar[11] + '年');
				$("#title").html(ar[9]);
				if(ar[10]==''){
					$("#photo_filename").attr("src","/images/blankphoto.png");
				}else{
					$("#photo_filename").attr("src","/users" + ar[10]);
				}
				$("#stamp").attr("src","/users" + "/upload/companies/stamp/znxf.png");
				$("#logo").attr("src","/users" + "/upload/companies/logo/znxf.png");
				$("#sexName").html(ar[12]);
				$("#diplomaNo").html(ar[13]);
				$("#educationName").html(ar[14]);
				$("#class_startDate").html(ar[15]);
				$("#class_endDate").html(ar[16]);
			}/**/
		//});
	}
</script>

</head>

<body style="background: url(/images/background_diploma.jpg) repeat; opacity:0.75;">
<p id="test"></p>
<section class="login-form-wrap3">
	<div style="position: relative;">
	<div style="position: absolute; z-index:20;padding-top:5mm;padding-left:220mm;">
		<img id="photo_filename" src="" style="width:40mm;max-height:60mm;">
	</div>
	<div style="text-align:center; padding-top:20px;"><h2>安全培训合格证书</h2></div>
	<div style="position: absolute; z-index:10; width:40%; padding-left:10mm;padding-top:10mm;">
		<div class="lineC1"><span id="name" style="padding-left:10mm;"></span><span style="padding-left:5mm;">同志于</span><span id="class_startDate" style="padding-left:5mm;"></span>
		<span>至</span><span id="class_endDate" style="padding-left:5mm;"></span><span style="padding-left:5mm;">参加</span><span id="title"></span>
		<span>安全培训，完成了规定课程的学习，经考核合格，特发此证。</span></div>
		<div class="lineC1"><span>&nbsp;</span></div>
		<div class="lineC1"><span>&nbsp;</span></div>
		<div class="lineC1"><span>&nbsp;</span></div>
		<div class="lineC1"><span>&nbsp;</span></div>
		<div class="lineC1"><span>&nbsp;</span></div>
		<div class="lineC1"><span>发证单位（盖章）</span></div>
		<div class="lineC1"><span>发证日期：</span><span id="startDate"></span></div>
		<div class="lineC1"><span>有效期限：</span><span id="term"></span></div>
	</div>
	<div style="position: absolute; z-index:10; width:100%; padding-left:130mm;">
		<div style="float:left;width:100%; padding-top: 35mm;">
			<table style="width:100%;">
				<tr>
					<td style="height:45px;width:30%;"><h5>证&nbsp;&nbsp;号：</h5></td>
					<td width="70%"><h5 id="diplomaID"></h5></td>
				</tr>
				<tr>
					<td style="height:45px;"><h5>姓&nbsp;&nbsp;名：</h5></td>
					<td><h5 id="name1"></h5></td>
				</tr>
				<tr>
					<td style="height:45px;"><h5>性&nbsp;&nbsp;别：</h5></td>
					<td><h5 id="sexName"></h5></td>
				</tr>
				<tr>
					<td style="height:45px;"><h5>身份证号：</h5></td>
					<td><h5 id="username"></h5></td>
				</tr>
				<tr>
					<td style="height:45px;"><h5>文化程度：</h5></td>
					<td><h5 id="educationName"></h5></td>
				</tr>
				<tr>
					<td style="height:45px;"><h5>职&nbsp;&nbsp;称：</h5></td>
					<td><h5></h5></td>
				</tr>
				<tr>
					<td style="height:45px;"><h5>现任职务：</h5></td>
					<td><h5 id="job"></h5></td>
				</tr>
				<tr>
					<td style="height:45px;"><h5>单&nbsp;&nbsp;位：</h5></td>
					<td style="word-wrap: break-word;"><h5 id="hostName"></h5></td>
				</tr>
			</table>
		</div>
	</div>
	<div style="position: absolute; z-index:30;padding-top:65mm;padding-left:38mm;">
		<img id="stamp" src="" style="opacity:0.7; width:60mm;max-height:60mm;">
	</div>
	<div style="position: absolute; z-index:30;padding-top:70mm;padding-left:120mm;">
		<img id="logo" src="" style="opacity:0.15; width:50mm;max-height:80mm;">
	</div>
	</div>
</section>
</body>
</html>
