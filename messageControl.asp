<!--#include file="js/doc.js" -->

<%

if(op == "getMessageList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(item like('%" + where + "%'))";
	}
	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
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
	//如果有分类
	if(kindID < 99 && kindID > ""){ // 
		s = "kindID=" + kindID;
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
	//如果是公司, 只能看自己公司发送的消息
	if(currHost > ""){ // 
		s = "registerHost='" + currHost + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_studentMessageInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT username,item,statusName,kindName,emergencyName,hostName,memo,regDate,email,mobile" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("refID").value + "|" + rs("item").value + "|" + rs("username").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("emergency").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//9
		result += "|" + rs("emergencyName").value + "|" + rs("email").value + "|" + rs("mobile").value + "|" + rs("readDate").value + "|" + rs("dept1Name").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("name").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_studentMessageInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("refID").value + "|" + rs("item").value + "|" + rs("username").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("emergency").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//9
		result += "|" + rs("emergencyName").value + "|" + rs("email").value + "|" + rs("mobile").value + "|" + rs("readDate").value + "|" + rs("dept1Name").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("name").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateStudentMessageInfo " + nodeID + "," + refID + ",'" + unescape(String(Request.QueryString("item"))) + "','" + String(Request.QueryString("username")) + "'," + kindID + "," + String(Request.QueryString("emergency")) + ",'" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM studentMessageInfo where username='" + String(Request.QueryString("username")) + "' and registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "cancelNode"){
	sql = "exec doCancelStudentMessage " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delMessageInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
%>
