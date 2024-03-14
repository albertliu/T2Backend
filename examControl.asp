<!--#include file="js/doc.js" -->

<%

if(op == "getExamList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(examName like('%" + where + "%') or examID='" + where + "')";
	}
	//如果有课程
	if(refID > ""){ // 
		s = "certID='" + refID + "'";
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

	sql = " FROM v_examInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT examID,examName,certID,certName,courseID,courseName,statusName,scoreTotal,scorePass,minutes,memo,regDate,registerName" + sql + " order by examID";
	sql = "SELECT top " + basket + " *" + sql + " order by examID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("examID").value + "|" + rs("examName").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//11
		result += "|" + rs("scoreTotal").value + "|" + rs("scorePass").value + "|" + rs("minutes").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_examInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("examID").value + "|" + rs("examName").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//11
		result += "|" + rs("scoreTotal").value + "|" + rs("scorePass").value + "|" + rs("minutes").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateExamInfo " + nodeID + ",'" + String(Request.QueryString("certID")) + "','" + String(Request.QueryString("courseID")) + "','" + String(Request.QueryString("examID")) + "','" + unescape(String(Request.QueryString("examName"))) + "','" + String(Request.QueryString("scoreTotal")) + "','" + String(Request.QueryString("scorePass")) + "','" + String(Request.QueryString("minutes")) + "'," + kindID + "," + status + ",'" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM examInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "cancelNode"){
	sql = "exec doCancelExam " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delExamInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getStudentExamByEnterID"){
	sql = "SELECT * FROM v_studentExamList where enterID=" + refID + " and kind=1";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("paperID").value + "|" + rs("examID").value + "|" + rs("score").value + "|" + rs("scorePass").value + "|" + rs("startDate").value + "|" + rs("endDate").value;
		//6
		result += "|" + rs("statusName").value + "|" + rs("username").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "getStudentQuestionList"){
	sql = "select * from v_studentQuestionList where refID=" + refID;
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("kindID").value + "|" + rs("questionName").value + "|" + rs("scorePer").value + "|" + rs("score").value + "|" + rs("answer").value + "|" + rs("myAnswer").value;
		//6
		result += "|" + rs("A").value + "|" + rs("B").value + "|" + rs("C").value + "|" + rs("D").value + "|" + rs("E").value + "|" + rs("F").value + "|" + rs("image").value;
		//13
		result += "|" + rs("imageA").value + "|" + rs("imageB").value + "|" + rs("imageC").value + "|" + rs("imageD").value + "|" + rs("imageE").value + "|" + rs("imageF").value + "|" + rs("questionID").value;
		rs.MoveNext();
	}
	Response.Write(escape(result.substr(2)));
}	
%>
