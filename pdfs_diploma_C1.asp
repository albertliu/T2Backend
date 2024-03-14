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
				var m = 1;  //rows per table
				var n = 1;  //columns per row
				var k = 0;
				$.each(data,function(iNum,val){
					k += 1;
					arr.push('<section class="login-form-wrap3s">');
					arr.push('<div style="position: relative;">');
					arr.push('<div style="position: absolute; z-index:10; width:100%; padding-left:18mm;padding-top:30mm;">');
					arr.push('<div class="lineC1s"><span style="padding-left:15mm;">' + val["name"] + '</span><span style="padding-left:52mm;">' + val["class_startDate"] + '</span></div>');
					arr.push('<div class="lineC1s"><span style="padding-left:18mm;">' + val["class_endDate"] + '</span></div>');
					arr.push('<div class="lineC1s" style="padding-top:120mm;padding-left:65mm;"><span style="padding-left:20mm;">' + val["startDate"] + '</span></div>');
					arr.push('</div>');
					arr.push('<div style="position: absolute; z-index:10; width:100%; padding-left:250mm; padding-top:97mm;">');
					arr.push('	<table style="width:100%;">');
					arr.push('		<tr>');
					arr.push('			<td style="height:58px;"><h5>' + val["diplomaID"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:58px;"><h5>' + val["name"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:58px;"><h5>' + val["sexName"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:58px;"><h5>' + val["username"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:58px;"><h5>' + val["educationName"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:58px;"><h5></h5></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:58px;"><h5>' + val["job"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:58px; word-wrap: break-word;"><h5 style=" width:85%;">' + val["hostName"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('	</table>');	
					arr.push('</div>');
					arr.push('</div>');
					arr.push('</section><hr style="page-break-after:always; border:none;">');	//分页
					arr.push('<div style="width:100%; padding-left:15mm;padding-top:85mm;">');
					arr.push('<div class="lineC1s"><span style="padding-left:10mm;">' + val["class_startDate"].substr(0,7) + '月</span><span style="padding-left:5mm;">上海智能消防学校</span><span style="padding-left:10mm;">合格</span><span style="padding-left:13mm;">上海智能消防学校</span><span style="padding-left:20mm;">' + val["term"] + '年</span></div>');
					arr.push('</div><hr style="page-break-after:always; border:none;">');	//分页
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
