<!--#include file="js/doc.js" -->

<%
if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_deptInfo where deptID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("deptID").value + "|" + rs("pID").value + "|" + rs("deptName").value + "|" + rs("kindID").value + "|" + rs("dept_status").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//7
		result += "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("address").value + "|" + rs("host").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		//16
		result += "|" + rs("No").value + "|" + rs("area").value + "|" + rs("c555").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateDeptInfo " + nodeID + "," + refID + ",'" + unescape(String(Request.QueryString("deptName"))) + "'," + kindID + "," + status + ",'" + unescape(String(Request.QueryString("linker"))) + "','" + unescape(String(Request.QueryString("phone"))) + "','" + unescape(String(Request.QueryString("email"))) + "','" + unescape(String(Request.QueryString("address")));
		sql += "','" + String(Request.QueryString("No")) + "','" + unescape(String(Request.QueryString("area"))) + "'," + String(Request.QueryString("c555")) + ",'" + host + "','" + unescape(String(Request.QueryString("memo"))) + "','" + currUser + "'"; 
		
		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(deptID) as maxID FROM deptInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}/**/
	}
	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delDeptInfo '" + nodeID + "','" + item + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "checkDeptReg"){
	result = 0;
	sql = "SELECT deptID as ID FROM v_deptInfo a where (title='" + keyID + "' or name='" + refID + "') and deptID<>'" + nodeID + "'";
	/*rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value;
	}
	rs.Close();*/
	Response.Write(escape(result));
}	

if(op == "getDeptJson"){
	sql = "SELECT dbo.getDeptJson('" + nodeID + "') as item";
	
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("item").value;
	}
	
	Response.Write(("{'list':" + result + "}"));
	//Response.Write(escape(sql));
}

if(op == "getRootDeptByHost"){
	result = 0;
	sql = "SELECT deptID as ID FROM deptInfo a where pID=0 and host='" + refID + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value;
	}
	rs.Close();
	Response.Write(result);
}	

if(op == "mergeDepts"){
	sql = "exec mergeDepts '" + nodeID + "','" + item + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}
%>
