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
	var backendURL = "<%=backendURL%>";
	var currHost = "";
	$(document).ready(function (){
		refID = "<%=refID%>";
		$.ajaxSetup({ 
			async: false 
		}); 
		//$("#test").html(refID);
		//$("#test").hide();
		var ar = new Array();
		//var c = "";
		ar = refID.split(",");
		getNodeInfo(ar[0], ar[1]);
	});

	function getNodeInfo(id, h){
		// alert(host)
		$.getJSON(uploadURL + "/public/getDiplomaListByBatchID?refID=" + id,function(data){
			//alert(data);
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
					arr.push('<section class="login-form-wrap3p0">');
					arr.push('<div style="position:relative;background:#fff;width:100%;height:100%;">');
					
					arr.push('<div style="position: absolute; z-index:10; width:100%; padding-left:80mm;padding-top:5mm;">');
					arr.push('	<table style="font-size: 28px; width:146mm;">');
					arr.push('		<tr>');
					arr.push('			<td style="height:68px;"><h6>证书号码：' + val["diplomaID"] + '</h6></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h6>姓名：' + val["name"] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;性别：' + val["sexName"] + '</h6></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h6>身份证号：' + val["username"] + '</h6></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h6>培训项目：' + val["certName"] + '</h6></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h6>工作单位：' + val["unit"].substr(0,13) + '</h6></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="padding-left:5.2em;"><h6>' + val["unit"].substr(13) + '</h6></td>');
					arr.push('		</tr>');
					arr.push('	</table>');	
					arr.push('</div>');
					arr.push('<div style="position: absolute; z-index:10; width:100%; padding-left:5mm;padding-top:105mm;">');
					arr.push('	<table style="font-size: 28px; width:165mm;">');
					arr.push('		<tr>');
					arr.push('			<td><h6>有效期限：' + val["startDate"] + '&nbsp;至&nbsp;' + val["endDate"] + '</h6></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h6>发证单位：' + val["hostName"] + '</h6></td>');
					arr.push('		</tr>');
					arr.push('	</table>');	
					arr.push('</div>');
					arr.push('<div style="position: absolute; z-index:30;padding-top:9mm;padding-left:9mm;">');
					arr.push('<img id="photo" src="users' + val["photo_filename"] + '" style="opacity:1; width:60mm;max-height:87mm;object-fit:cover;">');
					arr.push('</div>');	
					arr.push('<div style="position: absolute; z-index:30;padding-top:70mm;padding-left:10mm;">');
					arr.push('<img id="photo" src="users/upload/companies/stamp/' + h + '.png" style="opacity:0.7; width:60mm;max-height:60mm;">');
					arr.push('</div>');	
					arr.push('<div style="position: absolute; z-index:30;padding-top:89mm;padding-left:173mm;">');
					arr.push('<img id="qr" src="' + uploadURL + '/public/get_qr_img?size=10&text=' + encodeURIComponent(backendURL + '/help.asp?msg=' + val["diplomaID"]) + '" style="opacity:1; width:50mm;max-height:50mm;">');
					arr.push('</div>');	
					/**/
					arr.push('</div>');
					arr.push('</section>');
					if(data.length > k){
						arr.push('<hr style="page-break-after:always; border:none;" />');	//分页, 最后一页不分，否则会留有空白页
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
