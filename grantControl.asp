<!--#include file="js/doc.js" -->

<%
if(op == "getGrantSendList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(permissionName like('%" + where + "%') or memo like('%" + where + "%'))";
	}
	s = "userID='" + currUser + "'";
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}
	//如果有状态，按照状态查询
	if(status < 99){ // 有分类
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有起始日期
	if(fStart > ""){ // 
		s = "startDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有截止日期
	if(fEnd > ""){ // 
		s = "endDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_grantInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT permissionName,scopeName,statusName,startDate,endDate,grantManName,memo,grantDate" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("permissionName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("userID").value + "|" + rs("grantManName").value + "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("grantDate").value + "|" + rs("returnLog").value + "|" + rs("scopeID").value + "|" + rs("scopeName").value;
		rs.MoveNext();
	}

	Response.Write(escape(result));
}	

if(op == "getGrantReceiveList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(permissionName like('%" + where + "%') or memo like('%" + where + "%'))";
	}
	s = "grantMan='" + currUser + "'";
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}
	//如果有状态，按照状态查询
	if(status < 99){ // 有分类
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有起始日期
	if(fStart > ""){ // 
		s = "startDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有截止日期
	if(fEnd > ""){ // 
		s = "endDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_grantInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT permissionName,scopeName,statusName,startDate,endDate,userName,memo,grantDate" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("permissionName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("grantMan").value + "|" + rs("userName").value + "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("grantDate").value + "|" + rs("returnLog").value + "|" + rs("scopeID").value + "|" + rs("scopeName").value;
		rs.MoveNext();
	}
	if(result>""){
		result = result.substr(2);
	}

	Response.Write(escape(result));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_grantInfo where ID='" + nodeID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("grantItem").value + "|" + rs("permissionName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("grantMan").value + "|" + rs("grantManName").value + "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("memo").value + "|" + rs("grantDate").value + "|" + rs("userID").value + "|" + rs("userName").value + "|" + rs("scopeID").value + "|" + rs("scopeName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "getGrantUserList"){
	sql = "SELECT userName,realName from users where status=0 and userName <> '" + currUser + "' order by realName";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("userName").value + "|" + rs("realName").value;
		rs.MoveNext();
	}
	if(result>""){
		result = result.substr(2);
	}

	Response.Write(escape(result));
}	

if(op == "update"){
	result = 0;
	if(item==""){
		result = 2;  //授权内容不能为空。
	}
	if(result == 0 && String(Request.QueryString("grantMan"))==""){
		result = 3;  //被授权人不能为空。
	}
	if(result == 0 && fEnd==""){
		result = 4;  //结束日期不能为空。
	}
	if(result == 0){
		sql = "exec updateGrantInfo " + nodeID + ",'" + item + "','" + String(Request.QueryString("status")) + "','" + unescape(String(Request.QueryString("grantMan"))) + "','";
		sql += fStart + "','" + fEnd + "','" + keyID + "','" + unescape(String(Request.QueryString("scopeName"))) + "','" + unescape(String(Request.QueryString("memo"))) + "','" + String(Request.QueryString("grantDate")) + "','" + unescape(String(Request.QueryString("userID"))) + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM grantInfo where userID='" + unescape(String(Request.QueryString("userID"))) + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delGrantInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
