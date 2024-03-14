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
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/jSignature.js"></script>

<script language="javascript">
	var nodeID = "";
	var refID = ""; 
	var op = 0;
	var updateCount = 0;
	var reDo = "";
	<!--#include file="js/commFunction.js"-->

	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//user_letter_signature
		refID = "<%=refID%>";	//username
		op = "<%=op%>";
		reDo = refID;
		
		$("#signature").jSignature({
			color:'black',
			lineWidth:3,
			height:250,
			width:400
		});
		$.ajaxSetup({ 
			async: false 
		}); 
	});
	//输出签名图片
	function jSignatureTest(){
		if ($("#signature").jSignature("getData", "native").length == 0) {
			jAlert("请签名。");
			return false;
		}
		var $sigdiv = $("#signature");
		var datapair = $sigdiv.jSignature("getData", "image");
		var img = new Image();
		img.src = "data:" + datapair[0] + "," + datapair[1];
		//$(img).appendTo($("#image"));

		jConfirm('确定要提交签名吗?', '确认对话框', function(r) {
			if(r){
				$.post(uploadURL + "/outfiles/uploadBase64img",{upID:nodeID,username:refID,currUser:currUser,imgData:datapair[1]},function(re){
					jAlert("签名成功。");
					updateCount += 1;
					window.parent.$.close("signature");
				});
			}
		});
	}

	function reset(){
		var $sigdiv = $("#signature");
		$sigdiv.jSignature("reset");
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;height: 100%;">	
	<div id="signature" style="height:100%; width:100%; border:1px solid #blue; background:#FFF;"></div>
  	<div class="comm" align="center" style="width:96%;float:top;margin:5px;background:#eeeeee;">
		<div style="height:3px;"></div>
		<button type="button" onclick="jSignatureTest()">生成签名</button>&nbsp;&nbsp;&nbsp;&nbsp;
		<button type="button" onclick="reset()">重置签名</button>
	</div>
</div>
</body>
