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
	var updateCount = 0;
	var uploadURL = "<%=uploadURL%>";
	$(document).ready(function (){
		kindID = "<%=kindID%>";
		item = "<%=item%>";
		$.ajaxSetup({ 
			async: false 
		}); 
		//$("#test").html(refID);
		$("#test").hide();
		getNodeInfo(item);
	});

	function getNodeInfo(id){
		$.getJSON(uploadURL + "/public/getStudentPhotoList?where=" + id,function(data){
			//jAlert(unescape(data));
			var c = "";
			$("#cover").empty();
			var arr = new Array();
			if(data.length>0){
				var f = "f" + kindID;
				var i = 0;
				var j = 0;
				var m = 3;  //3 rows per table
				var n = 3;  //3 columns per row
				if(kindID==0){
					m = 3;
					n = 6;
				}
				$.each(data,function(iNum,val){
					if(i == 0){
						arr.push('<table style="margin-top:10mm;margin-left:15mm;">');
					}
					if(i%n == 0){
						arr.push('<tr>');
					}
					arr.push('<td>');
					arr.push('<section class="login-form-wrap" style="width:45mm;height:65mm;">');
					arr.push('<div style="position: relative;">');
					arr.push('<div style="position: absolute; z-index:10; width:100%;">');
					arr.push('<div style="float:left;width:100%;">');
					if(val[f]==''){
						c = '/images/blankphoto.png';
					}else{
						c = "/users" + val[f];
					}
					arr.push('	<img src="' + c + '" style="width:35mm;max-height:49mm;padding-top:5mm;padding-left:5mm;">');
					arr.push('</div>');
					arr.push('</div>');
					arr.push('<div style="position: absolute; z-index:20;"><p style="padding-top:55mm;padding-left:3mm;font-size:0.75em;">');
					if(val["no"]==0){
						c = '';
					}else{
						c = val["no"] + ".";
					}
					arr.push(c + val["name"] + val["username"]);
					arr.push('</p></div>');
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
</script>

</head>

<body>
	<p id="test"></p>
	<div id="cover"></div>
</body>
</html>
