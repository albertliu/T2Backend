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
		$.getJSON(uploadURL + "/public/getPasscardListByBatchID?refID=" + id,function(data){
			//jAlert(unescape(data));
			var c = "";
			$("#cover").empty();
			var arr = new Array();
			if(data.length>0){
				var i = 0;
				var j = 0;
				var m = 3;  //3 rows per table
				var n = 3;  //3 columns per row
				var k = 0;
				$.each(data,function(iNum,val){
					k += 1;
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
					arr.push('	<img src="/users/upload/companies/logo/znxf.png" style="width:93px;padding-top:10px;padding-left:20px;">');
					arr.push('</div>');
					arr.push('<div style="float:right;width:89%;">');
					arr.push('	<div style="text-align:center;"><h3>' + val["title"] + '</h2></div>');
					arr.push('	<div style="text-align:center;"><h2>准考证</h2></div>');
					arr.push('</div>');
					arr.push('<div style="clear: both;"></div>');
					arr.push('<hr size=2 color="red">');
					arr.push('<div style="float:left;width:100%;">');
					arr.push('	<table style="width:100%; padding-left:10px;">');
					arr.push('		<tr>');
					arr.push('			<td width="25%"><h3>姓&nbsp;名：</h3></td>');
					arr.push('			<td class="foot" width="25%"><h3>' + val["name"] + '</h3></td>');
					arr.push('			<td width="25%" align="right"><h3>性&nbsp;别：</h3></td>');
					arr.push('			<td class="foot" width="25%"><h3>' + val["sexName"] + '</h3></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h3>身份证号：</h3></td>');
					arr.push('			<td class="foot" colspan="3"><h3>' + val["username"] + '</h3></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h3>考生标识：</h3></td>');
//					arr.push('			<td class="foot"><h3>' + val["startDate"].replace(/-/g,"") + fillFormat(k,2,"0",0) + '</h3></td>');
					arr.push('			<td class="foot"><h3>' + val["passNo"] + '</h3></td>');
					arr.push('			<td align="right"><h3>密&nbsp;码：</h3></td>');
//					arr.push('			<td class="foot"><h3>' + val["username"].substr(12,6) + '</h3></td>');
					arr.push('			<td class="foot"><h3>' + val["password"] + '</h3></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h3>考试时间：</h3></td>');
					arr.push('			<td class="foot" colspan="3"><h3>' + val["startDate"] + '</h3></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h3>考试地点：</h3></td>');
					arr.push('			<td class="foot" colspan="3"><h3>' + val["address"] + '</h3></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h3>注意事项：</h3></td>');
					arr.push('			<td colspan="3"><h3>' + val["notes"] + '</h3></td>');
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
