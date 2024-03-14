<!--#include file="js/doc.js" -->

<%

if(op == "getQuestionList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(questionName like('%" + where + "%') or questionID='" + where + "' or knowPointName='" + where + "')";
	}
	//如果有课程
	if(refID > ""){ // 
		s = "knowpointID='" + refID + "'";
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
	//如果有类型
	if(kindID > ""){ // 
		s = "kindID=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_questionInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT questionID,questionName,kindName,answer,A,B,C,D,E,knowpointID,knowpointName,statusName,memo,regDate,registerName" + sql + " order by questionID";
	sql = "SELECT top " + basket + " *" + sql + " order by questionID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("questionID").value + "|" + rs("questionName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		//7
		result += "|" + rs("answer").value + "|" + rs("A").value + "|" + rs("B").value + "|" + rs("C").value + "|" + rs("D").value + "|" + rs("E").value;
		//13
		result += "|" + rs("knowpointID").value + "|" + rs("knowpointName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_questionInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("questionID").value + "|" + rs("questionName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		//7
		result += "|" + rs("answer").value + "|" + rs("A").value + "|" + rs("B").value + "|" + rs("C").value + "|" + rs("D").value + "|" + rs("E").value;
		//13
		result += "|" + rs("knowpointID").value + "|" + rs("knowpointName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		//19
		result += "|" + rs("F").value + "|" + rs("image").value + "|" + rs("imageA").value + "|" + rs("imageB").value + "|" + rs("imageC").value + "|" + rs("imageD").value + "|" + rs("imageE").value + "|" + rs("imageF").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateQuestionInfo " + nodeID + ",'" + String(Request.QueryString("questionID")) + "','" + unescape(String(Request.QueryString("questionName"))) + "','" + refID + "','" + String(Request.QueryString("answer")) + "','" + unescape(String(Request.QueryString("A"))) + "','" + unescape(String(Request.QueryString("B"))) + "','" + unescape(String(Request.QueryString("C"))) + "','" + unescape(String(Request.QueryString("D"))) + "','" + unescape(String(Request.QueryString("E"))) + "','" + unescape(String(Request.QueryString("F"))) + "'," + kindID + "," +  + status + ",'" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM questionInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "cancelNode"){
	sql = "exec doCancelQuestion " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delQuestionInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
%>
