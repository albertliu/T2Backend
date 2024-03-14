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
	var refID = 0;
	var updateCount = 0;
	var uploadURL = "<%=uploadURL%>";
	$(document).ready(function (){
		refID = "<%=refID%>";
		$.ajaxSetup({ 
			async: false 
		}); 
		//$("#test").html(refID);
		//$("#test").hide();
		getNodeInfo(refID);
	});

	function getNodeInfo(id){
		$.getJSON(uploadURL + "/public/getDiplomaListByBatchID?refID=" + id,function(data){
			//jAlert(unescape(data));
			var c = "";
			$("#cover").empty();
			var arr = new Array();
			if(data.length>0){
				var i = 0;
				var j = 0;
				var m = 3;  //3 rows per table
				var n = 3;  //3 columns per row
				var certID = "";
				$.each(data,function(iNum,val){
					if(i == 0){
						arr.push('<table style="margin-top:15mm;margin-left:15mm;">');
					}
					if(i%n == 0){
						arr.push('<tr>');
					}
					arr.push('<td>');
					arr.push('<section class="login-form-wrap">');
					arr.push('<div style="position: relative;">');
					arr.push('<div style="position: absolute; z-index:10; width:100%;">');
					arr.push('<div style="float:left;width:10%;">');
					arr.push('	<img src="/users' + val["logo"] + '" style="width:93px;padding-top:10px;padding-left:20px;">');
					arr.push('</div>');
					arr.push('<div style="float:right;width:89%;">');
					arr.push('	<div style="text-align:center;"><h2>' + val["title"] + '</h2></div>');
					arr.push('	<div style="text-align:center;"><h1>' + val["certName"] + '</h1></div>');
					arr.push('</div>');
					arr.push('<div style="clear: both;"></div>');
					arr.push('<hr size=2 color="red">');
					arr.push('<div style="float:left;width:30%;">');
					if(val["photo_filename"]==''){
						c = '/images/blankphoto.png';
					}else{
						c = "/users" + val["photo_filename"];
					}
					arr.push('	<img src="' + c + '" style="width:50mm;max-height:75mm;padding-top:8mm;padding-left:7mm;object-fit:cover;">');
					arr.push('</div>');
					arr.push('<div style="float:right;width:69%;">');
					arr.push('	<table style="width:100%;">');
					arr.push('		<tr>');
					arr.push('			<td width="28%"><h3>单&nbsp;位：</h3></td>');
					if(val["host"]=='spc' && val["dept1Name"]=="公司本部"){
						c = "上海石油分公司";
					}else{
						c = val["dept1Name"];
					}
					arr.push('			<td class="foot" width="71%"><h3>' + c + '</h3></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h3>姓&nbsp;名：</h3></td>');
					arr.push('			<td class="foot"><h3>' + val["name"] + '</h3></td>');
					arr.push('		</tr>');
					//if(val["certID"]=='C5'){	//施工作业上岗证
					certID = 'C5';
					arr.push('		<tr>');
					arr.push('			<td><h3>工&nbsp;种：</h3></td>');
					arr.push('			<td class="foot"><h3>' + val["job"] + '</h3></td>');
					arr.push('		</tr>');
					//}
					arr.push('		<tr>');
					arr.push('			<td><h3>证&nbsp;号：</h3></td>');
					arr.push('			<td class="foot"><h3>' + val["diplomaID"] + '</h3></td>');
					arr.push('		</tr>');
					/*
					arr.push('		<tr>');
					arr.push('			<td><h3>培训日期</h3></td>');
					arr.push('			<td class="foot"><h3>' + val["trainingDate"] + '至' + val["startDate"] + '</h3></td>');
					arr.push('		</tr>');
					*/
					arr.push('		<tr>');
					arr.push('			<td><h3>考核成绩</h3></td>');
					arr.push('			<td class="foot"><h3>' + val["score"] + '分(合格)</h3></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h3>培训发证</h3></td>');
					arr.push('			<td class="foot"><h3>' + val["startDate"] + '&nbsp;有效期：' + val["term"] + '年</h3></td>');
					arr.push('		</tr>');
					arr.push('	</table>');
					arr.push('</div>');
					arr.push('</div>');
					
					if(val["stamp"]==1){
						arr.push('<div style="position: absolute; z-index:20;">');
						arr.push('<img id="stamp" src="/users/upload/companies/stamp/' + val["host"] + '.png" style="opacity:0.6; width:113mm;max-height:113mm;padding-top:25mm;padding-left:30mm;">');
						arr.push('</div>');
					}
					/**/
					arr.push('</div>');
					arr.push('</section>');
					arr.push('</td>');
					i += 1;
					if(i%n == 0){
						arr.push('</tr>');
					}
					if(i%(n*m) == 0){
						i = 0;
						arr.push('</table><hr style="page-break-after:always; border:none;">');	//分页
					}
				});
				$("#cover").html(arr.join(""));
				if(certID=='C5'){	//施工作业上岗证
					//减小行距和字体
					$("h3").css({'padding-top': '7px', 'font-size': '24px'});
				}
			}
		});
	}
</script>

</head>

<body>
	<div id="cover"></div>
</body>
</html>
