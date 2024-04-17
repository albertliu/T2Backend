<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<%
var op = "";
var nodeID = 0;
var status = 0;
var keyID = "";
var kindID = "";
var refID = "";
var item = "";
var memo = "";
var currHost = Session("user_host");
var host = "";
var uploadURL = getSysEnv("NODE_ENV_UPLOAD_URL");
var backendURL = getSysEnv("NODE_ENV_BACKEND_T2");

if (String(Request.QueryString("op")) != "undefined" && 
    String(Request.QueryString("op")) != "") { 
  op = String(Request.QueryString("op"));
}
if (String(Request.QueryString("nodeID")) != "undefined" && 
    String(Request.QueryString("nodeID")) != "") { 
  nodeID = String(Request.QueryString("nodeID"));
}
if (String(Request.QueryString("keyID")) != "undefined" && 
    String(Request.QueryString("keyID")) != "") { 
  keyID = String(Request.QueryString("keyID"));
}
if (String(Request.QueryString("refID")) != "undefined" && 
    String(Request.QueryString("refID")) != "") { 
  refID = String(Request.QueryString("refID"));
}
if (String(Request.QueryString("kindID")) != "undefined" && 
    String(Request.QueryString("kindID")) != "") { 
  kindID = String(Request.QueryString("kindID"));
}
if (String(Request.QueryString("status")) != "undefined" && 
    String(Request.QueryString("status")) != "") { 
  status = String(Request.QueryString("status"));
}
if (String(Request.QueryString("item")) != "undefined" && 
    String(Request.QueryString("item")) != "") { 
  item = unescape(String(Request.QueryString("item")));
}
if (String(Request.QueryString("memo")) != "undefined" && 
    String(Request.QueryString("memo")) != "") { 
	memo = unescape(String(Request.QueryString("memo")));
}
if (String(Request.QueryString("host")) != "undefined" && 
    String(Request.QueryString("host")) != "") { 
	host = String(Request.QueryString("host"));
}

function getSysEnv(env){
	var WshShell = new ActiveXObject("WScript.Shell");  
	var strRet =  WshShell.Environment("system").item(env);
	return strRet;
}
%>
