<!--#include file="js/doc.js" -->

<%
if(op == "getMemoList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(item like('%" + where + "%') or memo like('%" + where + "%'))";
	}
	
	s = "host='" + currHost + "' and (registerID='" + currUser + "' or kindID=1)";
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}

	//如果有分类，按照分类查询
	if(kindID < 99 && kindID > ""){ // 有分类
		s = "kindID=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有状态，按照状态查询
	if(status ==1){ // 有分类
		s = "status=0";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有起始日期
	if(fStart > ""){ // 
		s = "regDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有截止日期
	if(fEnd > ""){ // 
		s = "regDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_memoInfo " + where;
	ssql = "SELECT item,keyDate,alertDays,kindName,statusName,privateName,holidayName,memo,regDate,registerName" + sql + " order by ID desc";
	sql = "SELECT *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		//6
		result += "|" + rs("host").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result.substr(2)));
	//Response.Write(escape(sql));
}

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_memoInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		//6
		result += "|" + rs("host").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	sql = "exec updateMemoInfo " + Request.Form("ID") + ",'" + Request.Form("kindID") + "','" + Request.Form("item") + "'," + Request.Form("status") + ",'" + Request.Form("memo") + "','" + currHost + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value;
	}
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delMemoInfo '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
