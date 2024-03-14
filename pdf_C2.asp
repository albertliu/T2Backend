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
			}/**/
		//});
	}
</script>

</head>

<body style="background: url(/images/background_diploma.jpg) no-repeat; opacity:0.75;">
<p id="test"></p>
<section class="login-form-wrap2">
	<div style="position: relative;">
	<div style="position: absolute; z-index:20;padding-top:25mm;padding-left:130mm;">
		<img id="photo_filename" src="" style="width:40mm;max-height:60mm;">
	</div>
	<div style="clear: both;"></div>
	<div style="position: absolute; z-index:10; width:100%;">
		<div style="text-align:center; padding-top:15px;"><h2 id="title"></h2></div>
		<hr size=2 color="red">
		<div style="float:left;width:100%; padding-left:15px; padding-top: 15px;">
			<table style="width:100%;">
				<tr>
					<td style="height:85px;"><h4>姓名：</h4></td>
					<td width="71%"><h4 id="name"></h4></td>
				</tr>
				<tr>
					<td style="height:85px;"><h4>性别：</h4></td>
					<td><h4 id="sexName"></h4></td>
				</tr>
				<tr>
					<td style="height:85px;"><h4>身份证号：</h4></td>
					<td><h4 id="username"></h4></td>
				</tr>
				<tr>
					<td style="height:85px;"><h4>单位：</h4></td>
					<td style="word-wrap: break-word;"><h4 id="hostName"></h4></td>
				</tr>
				<tr>
					<td style="height:85px;"><h4>职务：</h4></td>
					<td><h4 id="job"></h4></td>
				</tr>
				<tr>
					<td style="height:85px;"><h4>证书编号：</h4></td>
					<td><h4 id="diplomaID"></h4></td>
				</tr>
				<tr>
					<td style="height:85px;"><h4>发证日期</h4></td>
					<td><h4 id="startDate"></h4></td>
				</tr>
				<tr>
					<td style="height:85px;"><h4>有效期限：</h4></td>
					<td><h4 id="term"></h4></td>
				</tr>
				<tr>
					<td style="height:85px;"><h4>发证单位：</h4></td>
					<td ><h4>上海智能消防学校</h4></td>
				</tr>
				<tr>
					<td style="height:85px;" colspan="2"><h4 style="float:left;padding-left:20px;" id="diplomaNo"></h4></td>
				</tr>
			</table>
		</div>
	</div>
	<div style="position: absolute; z-index:30;padding-top:175mm;padding-left:75mm;">
		<img id="stamp" src="" style="opacity:0.7; width:70mm;max-height:70mm;">
	</div>
	<div style="position: absolute; z-index:30;padding-top:125mm;padding-left:120mm;">
		<img id="logo" src="" style="opacity:0.15; width:50mm;max-height:80mm;">
	</div>
	</div>
</section>
</body>
</html>
