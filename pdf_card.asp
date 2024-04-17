<!--#include file="js/doc1.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title></title>
<meta name="viewport" content="width=device-width">

<!--必要样式-->
<link href="css/style.css?ver=1.1"  rel="stylesheet" type="text/css" id="css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>


<script language="javascript">
	var item = "";
	var updateCount = 0;
	var uploadURL = "<%=uploadURL%>";
	var backendURL = "<%=backendURL%>";
	var currHost = "";
	$(document).ready(function (){
		item = "<%=kindID%>";
		currHost = "<%=currHost%>";
		$.ajaxSetup({ 
			async: false 
		}); 
		getNodeInfo();
	});

	function getNodeInfo(){
			var ar = new Array();
			//var c = "";
			ar = item.split(",");
			if(ar > ""){
				$("#diplomaID").html("证书号码：" + ar[0]);
				$("#name").html("姓名：" + ar[1] + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;性别：" + ar[12]);
				$("#username").html("身份证号：" + ar[2]);
				$("#certName").html("培训项目：" + ar[4]);
				$("#unit").html("工作单位：" + ar[5].substr(0,13));
				$("#unit1").html(ar[5].substr(13));
				//$("#job").html(ar[6]);
				// $("#startDate").html("发证日期：" + ar[7]);
				$("#term").html("有效期限：" + ar[7] + " 至 " + ar[8]);
				if(ar[10]==''){
					$("#photo_filename").attr("src","/images/blankphoto.png");
				}else{
					$("#photo_filename").attr("src","/users" + ar[10]);
				}
				$("#stamp").attr("src","/users" + "/upload/companies/stamp/" + ar[15] + ".png");
				//$("#logo").attr("src","/users" + "/upload/companies/logo/znxf.png");
				$("#hostName").html("发证单位：" + ar[16]);
				// $("#diplomaNo").html(ar[13]);
				$("#qr").attr("src", uploadURL + '/public/get_qr_img?size=10&text=' + encodeURIComponent(backendURL + '/help.asp?msg=' + ar[0]));
			}/**/
	}
</script>

</head>

<body>
<section class="login-form-wrap3p0">
	<div style="position: relative;background-color:#fff;width:100%;height:100%;">
		<div style="position: absolute; z-index:20;padding-top:9mm;padding-left:8mm;">
			<img id="photo_filename" src="" style="opacity:1; width:63mm;max-height:87mm;object-fit:cover;">
		</div>
		<div style="position: absolute; z-index:30;padding-top:70mm;padding-left:10mm;">
			<img id="stamp" src="" style="opacity:0.7; width:60mm;max-height:60mm;">
		</div>
		<div style="position: absolute; z-index:30;padding-top:89mm;padding-left:173mm;">
			<img id="qr" src="" style="opacity:1; width:50mm;max-height:50mm;">
		</div>
		<div style="position: absolute; z-index:10; width:100%; padding-left:80mm;padding-top:5mm;">
			<table style="font-size: 28px; width:146mm;">
				<tr>
					<td style="height:68px;"><h6 id="diplomaID"></h6></td>
				</tr>
				<tr>
					<td><h6 id="name"></h6></td>
				</tr>
				<tr>
					<td><h6 id="username"></h6></td>
				</tr>
				<tr>
					<td><h6 id="certName"></h6></td>
				</tr>
				<tr>
					<td><h6 id="unit"></h6></td>
				</tr>
				<tr>
					<td style="padding-left:5.2em;"><h6 id="unit1"></h6></td>
				</tr>
			</table>
		</div>
		<div style="position: absolute; z-index:10; width:100%; padding-left:5mm;padding-top:105mm;">
			<div class="lineC1"><h6 id="term"></h6></div>
			<div class="lineC1"><h6 id="hostName"></h6></div>
		</div>
	</div>
</section>
</body>
</html>
