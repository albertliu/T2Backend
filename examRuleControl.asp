<!--#include file="js/doc.js" -->

<%

if(op == "getExamRuleList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(knowPointID ='" + where + "' or examID='" + where + "')";
	}
	//如果有课程
	if(refID > ""){ // 
		s = "examID='" + refID + "'";
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

	sql = " FROM v_examRuleInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT examID,knowPointID,typeName,qty,scorePer,statusName,memo,regDate,registerName" + sql + " order by examID,ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("examID").value + "|" + rs("knowPointID").value + "|" + rs("typeID").value + "|" + rs("typeName").value + "|" + rs("qty").value + "|" + rs("scorePer").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//10
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_examRuleInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("examID").value + "|" + rs("knowPointID").value + "|" + rs("typeID").value + "|" + rs("typeName").value + "|" + rs("qty").value + "|" + rs("scorePer").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//10
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateExamRuleInfo " + nodeID + ",'" + String(Request.QueryString("examID")) + "','" + String(Request.QueryString("knowPointID")) + "','" + String(Request.QueryString("typeID")) + "','" + String(Request.QueryString("qty")) + "','" + String(Request.QueryString("scorePer")) + "'," + kindID + "," + status + ",'" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM examRuleInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "cancelNode"){
	sql = "exec doCancelexamRule " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delexamRuleInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
%>
