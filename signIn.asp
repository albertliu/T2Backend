<!--#include file="js/doc1.js" -->
<%
var event = "";
var msg = "";
var count = "";
var registerID = "";
if (String(Request.QueryString("event")) != "undefined" && 
    String(Request.QueryString("event")) != "") { 
  event = String(Request.QueryString("event"));
}
if (String(Request.QueryString("msg")) != "undefined" && 
    String(Request.QueryString("msg")) != "") { 
  msg = String(Request.QueryString("msg"));
}
if (String(Request.QueryString("count")) != "undefined" && 
    String(Request.QueryString("count")) != "") { 
  count = String(Request.QueryString("count"));
}
if (String(Request.QueryString("registerID")) != "undefined" && 
    String(Request.QueryString("registerID")) != "") { 
  registerID = String(Request.QueryString("registerID"));
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>学员签到</title>
<link href="css/style_main.css?v=1.3"  rel="stylesheet" type="text/css" />
	<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
	<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script language="javascript">
	var backendURL = "<%=backendURL%>";
	var uploadURL = "<%=uploadURL%>";
	$(document).ready(function (){
      nodeID = "<%=msg%>";    //enterID
      keyID = "<%=event%>";   //name
      kindID = "<%=count%>";  //card rest count
      refID = "<%=registerID%>";    //current user
      //window.innerWidth = 86mm;
      //alert(nodeID);
      jConfirm('<p style="font-size:1.5em; color:red;">' + keyID + ': 还有' + kindID + '次练习额度\n确定要使用吗?</p>', '确认对话框', function(r) {
         if(r){
            $.post(uploadURL + "/public/student_sign_in",{ enterID:nodeID, registerID:refID },function(re){
               // alert(unescape(re))
               jAlert("签到成功。");
            });
         }
      });
      $.ajaxSetup({ 
			async: false 
		}); 
	});
</script>
</head>

<body>
<div id="layout">
   <div style="height:100%;">
      <img id="img" src="" style="display: flex; width:80%;padding:50px;margin:0 auto;-webkit-filter: drop-shadow(10px 10px 10px rgba(0, 0, 0, .5));filter: drop-shadow(10px 10px 10px rgba(0, 0, 0, .5));" />
   </div>
</div>

</body>
</html>
