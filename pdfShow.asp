<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title></title>

<link href="css/style_inner1.css?v=1.3"  rel="stylesheet" type="text/css" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-2.1.1.min.js"></script>

<script language="javascript">
	var nodeID = "";
	var refID = "";
	var op = 0;
	var updateCount = 0;

	<!--#include file="js/commFunction.js"-->

	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//url
		refID = "<%=refID%>";
		op = "<%=op%>";
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#img").prop("src","users/" + nodeID + "?times=" + (new Date().getTime()) + "#view=fit");
	});
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0; overflow: hidden;height:100%;">	
	<iframe id="img" src="" width="100%" height="500" style="border:0px;"></iframe>
</div>
</body>
