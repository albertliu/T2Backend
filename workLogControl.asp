<!--#include file="js/doc.js" -->

<%
if(op == "getWorkLogListByWhere"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(item like('%" + where + "%') or memo like('%" + where + "%'))";
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
	//如果为工程计划，按照工程查询
	if(kindID == 1 && String(Request.QueryString("engineeringID")) > ""){ // 有分类
		s = "engineeringID=" + String(Request.QueryString("engineeringID"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果为项目计划，按照项目查询
	if(kindID == 2 && String(Request.QueryString("projectID")) > "" && String(Request.QueryString("projectID")) != "null"){ // 有分类
		s = "projectID=" + String(Request.QueryString("projectID"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果指定人员
	if(unescape(String(Request.QueryString("userID"))) > ""){ 
		s = "regOperator='" + unescape(String(Request.QueryString("userID"))) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果指定范围
	if(String(Request.QueryString("private")) > ""){ 
		s = "private='" + String(Request.QueryString("private")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
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
		s = "keyDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有截止日期
	if(fEnd > ""){ // 
		s = "keyDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_workLogInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT item,statusName,keyDate,kindName,engineeringName,projectName,privateName,memo,regDate,registorName" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("userName").value + "|" + rs("userRealName").value + "|" + rs("keyDate").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		result += "|" + rs("engineeringID").value + "|" + rs("engineeringName").value + "|" + rs("projectID").value + "|" + rs("projectName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("private").value + "|" + rs("privateName").value + "|" + rs("refID").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_workLogInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("userName").value + "|" + rs("userRealName").value + "|" + rs("keyDate").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		result += "|" + rs("engineeringID").value + "|" + rs("engineeringName").value + "|" + rs("projectID").value + "|" + rs("projectName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("private").value + "|" + rs("privateName").value + "|" + rs("refID").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(unescape(String(Request.QueryString("item")))==""){
		result = 2;  //内容不能为空。
	}
	if(result == 0 && kindID==1 && String(Request.QueryString("engineeringID"))==0){
		result = 3;  //工程不能为空。
	}
	if(result == 0 && kindID==2 && String(Request.QueryString("projectID"))==0){
		result = 4;  //项目不能为空。
	}
	if(result == 0){
		sql = "exec updateWorkLogInfo " + nodeID + ",'" + unescape(String(Request.QueryString("item"))) + "','" + String(Request.QueryString("status")) + "','" + unescape(String(Request.QueryString("userName"))) + "','" + String(Request.QueryString("keyDate")) + "','";
		sql += kindID + "','" + String(Request.QueryString("engineeringID")) + "','" + String(Request.QueryString("projectID")) + "','" + String(Request.QueryString("private")) + "','" + String(Request.QueryString("refID")) + "','" + unescape(String(Request.QueryString("memo"))) + "','" + String(Request.QueryString("regDate")) + "','" + unescape(String(Request.QueryString("regOperator"))) + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM workLogInfo where regOperator='" + unescape(String(Request.QueryString("regOperator"))) + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delWorkLogInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
