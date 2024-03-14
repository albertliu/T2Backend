<!--#include file="js/doc.js" -->

<%

if(op == "getWorkUserList"){
	sql = "SELECT ID,userID,userName from v_commUserList,dbo.getReturnLog('" + kindID + "'," + refID + ",'" + userID + "') as returnLog where kindID='" + kindID + "' and refID=" + refID + "'";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("userID").value + "|" + rs("userName").value + "|" + rs("returnLog").value;
		rs.MoveNext();
	}
	if(result>""){
		result = result.substr(2);
	}

	Response.Write(escape(result));
}	

if(op == "getRestUserList"){
	sql = "SELECT ID,userName,realName from users where status=0 and userName not in(select userID from commUserList where kindID='" + kindID + "' and refID=" + refID + "')";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("userID").value + "|" + rs("userName").value;
		rs.MoveNext();
	}
	if(result>""){
		result = result.substr(2);
	}

	Response.Write(escape(result));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_commUserList where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("status").value + "|" + rs("userID").value + "|" + rs("userName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("refID").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}
if(op == "removeUser"){
	sql = "SELECT 1 from commUserList where ID='" + nodeID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		sql = "delete from commUserList where ID='" + nodeID + "'";
		execSQL(sql);
	}else{
		nodeID = "";
	}
	Response.Write(nodeID);
}

%>
