<!--#include file="js/doc.js" -->

<%

if(op == "getKnowPointList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(knowpointName like('%" + where + "%') or knowpointID='" + where + "' or courseID='" + where + "')";
	}
	//如果有课程
	if(refID > ""){ // 
		s = "courseID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有状态
	if(status > ""){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_knowpointInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT knowpointID,knowpointName,statusName,courseID,courseName,memo,regDate,registerName" + sql + " order by knowpointID";
	sql = "SELECT top " + basket + " *" + sql + " order by knowpointID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("knowpointID").value + "|" + rs("knowpointName").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//5
		result += "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_knowpointInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("knowpointID").value + "|" + rs("knowpointName").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//5
		result += "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateKnowPointInfo " + nodeID + ",'" + String(Request.QueryString("knowpointID")) + "','" + unescape(String(Request.QueryString("knowpointName"))) + "','" + refID + "'," + status + ",'" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM knowpointInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "cancelNode"){
	sql = "exec doCancelKnowPoint " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delKnowPointInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
%>
