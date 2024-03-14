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
	var refID = 0;
	var kindID = 0;
	var updateCount = 0;
	var uploadURL = "<%=uploadURL%>";
	$(document).ready(function (){
		refID = "<%=refID%>";
		kindID = "<%=kindID%>";		//diplomaFontSize  0 normal  1 big
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
				var m = 2;  //rows per table
				var n = 2;  //columns per row
				var k = 0;
				var diplomaFontSize = "";
				if(kindID==1){
					diplomaFontSize = "A";
				}
				$.each(data,function(iNum,val){
					k += 1;
					if(i == 0){
						arr.push('<table style="margin-top:35mm;margin-left:15mm;display:inline-block; *display:inline; zoom:1;">');
					}
					if(i%n == 0){
						arr.push('<tr>');
					}
					arr.push('<td>');
					arr.push('<section class="login-form-wrap1">');
					arr.push('<div style="position: relative;">');
					arr.push('<div style="position: absolute; z-index:10; width:100%;padding-left:8mm;">');
					arr.push('<div style="float:left;width:100%;">');
					arr.push('	<table style="width:100%; padding-left:10mm;padding-top:1mm;">');
					arr.push('		<tr>');
					//arr.push('			<td style="height:80px;width:28%;"><h4>岗位：</h4></td>');
					arr.push('			<td style="height:80px;width:100%;text-align: center;" colspan="2"><h4' + diplomaFontSize + '>' + val["title"] + '</h4' + diplomaFontSize + '></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:80px;width:28%;"><h4>姓名：</h4></td>');
					arr.push('			<td><h4' + diplomaFontSize + '>' + val["name"] + '</h4' + diplomaFontSize + '></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:80px;"><h4>性别：</h4></td>');
					arr.push('			<td><h4' + diplomaFontSize + '>' + val["sexName"] + '</h4' + diplomaFontSize + '></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:80px;"><h4>身份证号：</h4></td>');
					arr.push('			<td><h4' + diplomaFontSize + '>' + val["username"] + '</h4' + diplomaFontSize + '></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:80px;"><h4>单位：</h4></td>');
					arr.push('			<td style="word-wrap: break-word;"><h4' + diplomaFontSize + ' style="width:85%;">' + val["hostName"] + '</h4' + diplomaFontSize + '></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:80px;"><h4>职务：</h4></td>');
					arr.push('			<td><h4' + diplomaFontSize + '>' + val["job"] + '</h4' + diplomaFontSize + '></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:80px;"><h4>证书编号：</h4></td>');
					arr.push('			<td><h4' + diplomaFontSize + '>' + val["diplomaID"] + '</h4' + diplomaFontSize + '></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:80px;"><h4>发证日期：</h4></td>');
					arr.push('			<td><h4' + diplomaFontSize + '>' + val["startDate"] + '</h4' + diplomaFontSize + '></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:80px;"><h4>有效期限：</h4></td>');
					arr.push('			<td><h4' + diplomaFontSize + '>' + val["term"] + '年</h4' + diplomaFontSize + '></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:80px;" colspan="2"><h4' + diplomaFontSize + ' style="float:left;padding-left:20px;">' + val["diplomaNo"] + '</h4' + diplomaFontSize + '>');
					arr.push('			<h4 style="float:right;padding-right:100px;">（发证机关印章）</h4></td>');
					arr.push('		</tr>');
					arr.push('	</table>');
					arr.push('</div>');
					arr.push('</div>');
					arr.push('</div>');
					arr.push('</section>');
					arr.push('</td>');
					i += 1;
					if(i%n == 0){
						arr.push('</tr>');
						arr.push('<tr style="height:10mm;"></tr>');
					}else{
						arr.push('<td style="width:3.5%;"></td>');
					}
					if(i%(n*m) == 0){
						i = 0;
						arr.push('</table><hr style="page-break-after:always; border:none;">');	//分页
					}
				});
				$("#cover").html(arr.join(""));
			}
		});
	}
	//fillFormat("1",3,"0",0) = "001"
	function fillFormat(strIn,intLng,strFill,location){
		var result = String(strIn);
		while(result.length < intLng){
			if(location==0){//填充在前面
				result = strFill + result;
			}else{
				result = result + strFill;
			}
		}
		return result;
	}
</script>

</head>

<body>
	<div id="cover"></div>
</body>
</html>
