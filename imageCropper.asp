<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title></title>

<link href="css/style_inner1.css?v=1.3"  rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/cropper.css" type="text/css" rel="stylesheet" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/cropper.js"></script>

<script language="javascript">
	var nodeID = "";
	var refID = "";
	var kindID = "";
	var op = 0;
	var updateCount = 0;

	<!--#include file="js/commFunction.js"-->

	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//users/upload/students/photos/120107196604032113.png
		refID = "<%=refID%>";	//username
		kindID = "student_" + "<%=kindID%>";	//photo
		op = "<%=op%>";
		
		$("#image").prop("src", nodeID + "?times=" + (new Date().getTime()));
		getDicList("cropperScale","scale",0);
		//alert($("#image")[0].src);
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#scale").change(function(){
			var s = [0,3/4,2/3,5/7];
			var i = $("#scale").val();
			$('#image').cropper('setAspectRatio',s[i]);
		});

		$('#image').cropper({
			aspectRatio: 0,
			viewMode:1,
			dragMode:'crop',
			preview:".small",
			responsive:true,
			restore:true,
			autoCropArea: 1,
	        modal:false,
	//        guides:false,
	//        background:false,
	//        autoCrop:false,
	//        autoCropArea:0.1,
	//        movable:false,
	//        scalable:false,
	//        zoomable:false,
	//        wheelZoomRatio:false,
	//        cropBoxMovable:false,
	//        cropBoxResizable:false,
			ready:function () {
				console.log("ready");
			},
			cropstart: function (e) {
				console.log("cropstart");
			},
			cropmove: function (e) {
				console.log("cropmove");
			},
			cropend: function (e) {
				console.log("cropend");
			},
			crop: function (e) {
				console.log("crop");
			},
			zoom: function (e) {
				console.log("zoom");
			},
		});


	});
//输出签名图片
	function save(){
		if (0 == 1) {
			alert("请签名。");
			return false;
		}
        var cas=$('#image').cropper('getCroppedCanvas');
        var base64url=cas.toDataURL('image/jpeg');

		jConfirm('确定要保存照片的修改吗?', '确认对话框', function(r) {
			if(r){
				$.post(uploadURL + "/outfiles/uploadBase64img",{upID:kindID,username:refID,currUser:currUser,imgData:base64url.replace("data:image/jpeg;base64,","")},function(re){
					alert("保存成功。");
					updateCount += 1;
					//window.parent.$.close("cropper");
				});
			}
		});
	}

	function reset(){
		$('#image').cropper('reset');
	}

	function rotateRight(){
		$('#image').cropper('rotate',90);
	}

	function rotateLeft(){
		$('#image').cropper('rotate',-90);
	}
	
	function quit(){
		window.parent.$.close("cropper");
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
  	<div class="comm" align="center" style="width:98%;height:98%;float:top;background:#eeeeee;">
	  	<div style="padding: 4px;">
			<button type="button" onclick="reset()">复位</button>&nbsp;&nbsp;
			<button type="button" onclick="rotateRight()">顺时针90度</button>&nbsp;&nbsp;
			<button type="button" onclick="rotateLeft()">逆时针90度</button>&nbsp;&nbsp;
			裁剪比例&nbsp;<select id="scale" style="width:60px;"></select>
		</div>
		<div class="box" style="display: block; max-width: 100%;height:500px;">
			<img id="image" style="display: block; max-width: 100%;max-height:500px;" />
		</div>
	  	<div style="padding: 4px;">
			<button type="button" onclick="save()">保存</button>
		</div>
	</div>
</div>
</body>
