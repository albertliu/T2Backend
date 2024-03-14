<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script language="javascript">
	var nodeID = "";
	var op = 0;
	var updateCount = 0;
	var username = "";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#restore").click(function(){
            var form = new FormData(document.getElementById("formUpload"));
			var act = action + "?upID=" + $("input[name='uploadKind']:checked").val() + "&username=" + username;
            $.ajax({
                url: act,
                type:"post",
                data:form,
                processData:false,
                contentType:false,
                success:function(data){
	                updateCount += 1;
                },
                error:function(e){
					//alert(e);
                }
            });        
		});
	});
</script>

</head>

<body>

 <!--#include file='commLoadFileDetail.asp' -->

</body>
