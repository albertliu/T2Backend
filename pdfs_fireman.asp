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
	var kindID = 0;
	var item = "";
	var refID = 0;  //IDcard
	var updateCount = 0;
	var uploadURL = "<%=uploadURL%>";
	$(document).ready(function (){
		kindID = "<%=kindID%>";
		refID = "<%=refID%>";
		item = "<%=item%>";
		$.ajaxSetup({ 
			async: false 
		}); 
		//$("#test").html(refID);
		$("#test").hide();
		getNodeInfo(item);
		//var imgArr = $("#cover").find("img");
		//proDownImage(imgArr); 
	});

	function getNodeInfo(id){
		$.getJSON(uploadURL + "/public/getStudentMaterials?username=" + id + "&IDcard=" + refID,function(data){
			//jAlert(unescape(data));
			var c = "";
			$("#cover").empty();
			var arr = new Array();
			if(data.length>0){
				arr.push('<table style="margin-top:10mm;width:100%;">');
				$.each(data,function(iNum,val){
					if(val["kindID"]>0){
						arr.push('<tr>');
						arr.push('<td align="center" style="width:100%;">');
						//arr.push('	<img src="users' + val["filename"] + '" style="max-width:130mm;max-height:180mm;padding-top:5mm;">');
						arr.push('	<img src="users' + val["filename"] + '" style="max-width:600px;max-height:600px;padding-top:20px;">');
						arr.push('</td>');
						arr.push('</tr>');
					}
				});
				arr.push('</table>');
				
				$("#cover").html(arr.join(""));
			}else{
				alert("没有找到任何素材。");
			}
		});
	}
</script>

</head>

<body>
	<p id="test"></p>
	<div id="cover"></div>
</body>
</html>
