<!--#include file="js/doc.js" -->

<%

if(op == "getFeedbackList"){
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

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_studentFeedbackInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT username,item,statusName,kindName,emergencyName,hostName,memo,regDate,email,mobile" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("refID").value + "|" + rs("item").value + "|" + rs("username").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("emergency").value + "|" + rs("kindName").value + "|" + rs("statusName").value + "|" + rs("emergencyName").value;
		//10
		result += "|" + rs("email").value + "|" + rs("mobile").value + "|" + rs("readDate").value + "|" + rs("readerName").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("name").value;
		//19
		result += "|" + rs("dealDate").value + "|" + rs("dealerName").value + "|" + rs("type").value + "|" + rs("classID").value;
		rs.MoveNext();
	}

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_studentFeedbackInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("refID").value + "|" + rs("item").value + "|" + rs("username").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("emergency").value + "|" + rs("kindName").value + "|" + rs("statusName").value + "|" + rs("emergencyName").value;
		//10
		result += "|" + rs("email").value + "|" + rs("mobile").value + "|" + rs("readDate").value + "|" + rs("readerName").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("name").value;
		//19
		result += "|" + rs("dealDate").value + "|" + rs("dealerName").value + "|" + rs("type").value + "|" + rs("classID").value;
		//标记为已阅读
		sql = "exec setStudentFeedbackRead " + nodeID + ",'" + currUser + "'";
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "doDeal"){
	result = 0;
	if(result == 0){
		sql = "exec setStudentFeedbackDeal " + nodeID + ",'" + item + "', '" + currUser + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "delNode"){
	sql = "exec delFeedbackInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
