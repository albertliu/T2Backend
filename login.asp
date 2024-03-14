<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<!--#include file="Connections/conn_js.asp" -->

<%
var op = String(Request.QueryString("op"));
var result = 0;

var username = String(Request.QueryString("username")).replace(/\'/g,"").replace(/\ /g,"").replace(/\=/g,"");
var passwd = String(Request.QueryString("passwd"));
var currHost = "";

if(op == "login"){
	sql = "SELECT * from dbo.userLogin('" + username + "','" + passwd + "')";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		if(rs("e").value==0){
			Session("name_key") = rs("realName").value;
			Session("user_key") = rs("userName").value;
			//Session("user_id") = rs("userID").value;
			Session("user_host") = rs("host").value;
			Session("user_partner") = rs("partnerID").value;
			Session("user_sales") = rs("sales").value;
			Session("user_teacher") = rs("teacher").value;
			Session("user_hostName") = rs("hostName").value;
			Session.Timeout=360; //SEESION有效时间为360分钟
		}
		result = rs("e").value + "|" + rs("msg").value + "|" + rs("host").value + "|" + rs("partnerID").value;
	}	
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getAdminProperty"){
	result = 0;
	sql = "SELECT * FROM hostDict WHERE kind='" + String(Request.QueryString("kindID")) + "' and host='feng'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("item").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "updatePasswd"){
	result = 0;
	var id = 0;
	var userName = "";
	sql = "SELECT * FROM dbo.userLogin('" + username + "','" + passwd + "')";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("e").value;
		id = rs("userID").value;
		userName = rs("userName").value;
	}
	rs.Close();
	
	if(result ==0 || result==4){	//过期或正常，将进行重置
		sql = "exec updateUserPasswd '" + userName + "','" + String(Request.QueryString("newpasswd")) + "'";
		rs = conn.Execute(sql);
		result = 0;
	}
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}
%>
