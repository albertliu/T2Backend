<!--#include file="js/doc1.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title></title>
<meta name="viewport" content="width=device-width">

<!--必要样式-->
<link href="css/style.css?ver=1.3"  rel="stylesheet" type="text/css" id="css" />
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
				$("#diplomaID").html(ar[2]);
				$("#name").html(ar[0]);
				$("#certName").html(ar[1]);
				if(ar[11]=='spc' && ar[3]=="公司本部"){
					$("#dept1Name").html("上海石油分公司");
				}else{
					$("#dept1Name").html(ar[3]);
				}
				//if(ar[10]=='C5'){	//施工作业上岗证
					//显示工种
					$("#item_job").show();
					//减小行距和字体
					$("h3").css({'padding-top': '7px', 'font-size': '24px'});
				//}else{
					//$("#item_job").hide();
				//}
				$("#job").html(ar[4]);
				$("#startDate").html(ar[5] + "&nbsp;有效期：" + ar[6] + '年');
				//$("#term").html(ar[6] + '年');
				$("#title").html(ar[7]);
				if(ar[8]==''){
					$("#photo_filename").attr("src","/images/blankphoto.png");
				}else{
					$("#photo_filename").attr("src","/users" + ar[8]);
				}
				$("#logo").attr("src","/users" + ar[9]);
				if(ar[12]=='1'){
					$("#stamp").attr("src","/users" + "/upload/companies/stamp/" + ar[11] + ".png");
				}
				//$("#trainingDate").html(ar[13] + '至' + ar[5]);
				$("#score").html(ar[14] + '分(合格)');
			}/**/
		//});
	}
</script>

</head>

<body>
<p id="test"></p>
<section class="login-form-wrap">
	<div style="position: relative;">
	<div style="position: absolute; z-index:10; width:100%;">
		<div style="float:left;width:10%;">
			<img id="logo" src="" style="width:93px;padding-top:10px;padding-left:20px;">
		</div>
		<div style="float:right;width:89%;">
			<div style="text-align:center;"><h2 id="title"></h2></div>
			<div style="text-align:center;"><h1 id="certName"></h1></div>
		</div>
		<div style="clear: both;"></div>
		<hr size=2 color="red">
		<div style="float:left;width:30%;">
			<img id="photo_filename" src="" style="width:50mm;max-height:75mm;padding-top:8mm;padding-left:5mm;object-fit:cover;">
		</div>
		<div style="float:right;width:69%;">
			<table style="width:100%;">
				<tr>
					<td width="28%"><h3>单&nbsp;位：</h3></td>
					<td class="foot" width="71%"><h3 id="dept1Name"></h3></td>
				</tr>
				<tr>
					<td><h3>姓&nbsp;名：</h3></td>
					<td class="foot"><h3 id="name"></h3></td>
				</tr>
				<tr id="item_job">
					<td><h3>工&nbsp;种：</h3></td>
					<td class="foot"><h3 id="job"></h3></td>
				</tr>
				<tr>
					<td><h3>证&nbsp;号：</h3></td>
					<td class="foot"><h3 id="diplomaID"></h3></td>
				</tr>
				<tr>
					<td><h3>考核成绩</h3></td>
					<td class="foot"><h3 id="score"></h3></td>
				</tr>
				<tr>
					<td><h3>培训发证</h3></td>
					<td class="foot"><h3 id="startDate"></h3></td>
				</tr>
			</table>
		</div>
	</div>
	<div style="position: absolute; z-index:20;">
		<img id="stamp" src="" style="opacity:0.6; width:113mm;max-height:113mm;padding-top:25mm;padding-left:30mm;">
	</div>
	</div>
</section>
</body>
</html>
