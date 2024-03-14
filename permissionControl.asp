<!--#include file="js/doc.js" -->

<%
var userID = 0;
var permissionID = 0;
var roleID = "";

if (String(Request.QueryString("userID")) != "undefined" && 
    String(Request.QueryString("userID")) != "") { 
  userID = String(Request.QueryString("userID"));
}
if (String(Request.QueryString("permissionID")) != "undefined" && 
    String(Request.QueryString("permissionID")) != "") { 
  permissionID = String(Request.QueryString("permissionID"));
}
if (String(Request.QueryString("roleID")) != "undefined" && 
    String(Request.QueryString("roleID")) != "") { 
  roleID = String(Request.QueryString("roleID"));
}

if(op == "checkPermission"){
	result = userHasPermission(currUser,permissionID);
	Response.Write(result);
}	

if(op == "checkRole"){
	result = userHasRole(currUser,roleID);
	Response.Write(result);
}	

if(op == "imChecker"){
	result = 0;
	sql = "SELECT dbo.imChecker('" + refID + "') as re";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	Response.Write(result);
}	

if(op == "getPermissionListByUser"){
	sql = " FROM dbo.getPermissionListByUser('" + userID + "')";
	ssql = "SELECT permissionID,permissionName,scopeName,description" + sql + " order by permissionID desc";
	sql = "SELECT *" + sql;

	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("permissionID").value + "|" + rs("permissionName").value + "|" + rs("scope").value + "|" + rs("scopeID").value + "|" + rs("scopeName").value + "|" + rs("description").value;
		rs.MoveNext();
	}
	rs.Close();
	
	if(result > ""){
		result = result.substr(2);
	}
	Session(op) = ssql;

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

%>
