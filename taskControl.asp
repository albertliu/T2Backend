<!--#include file="js/doc.js" -->

<%

if(op == "getTaskSendList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(item like('%" + where + "%') or memo like('%" + where + "%'))";
	}
	s = "regOperator='" + currUser + "'";
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

	sql = " FROM v_taskInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT item,statusName,limitDate,finishDate,kindName,memo,dbo.getReceiverNameList('task',ID) as userName,doMemo,regDate,registorName" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " *,'' as userID,dbo.getReceiverNameList('task',ID) as userName,dbo.getReceiverReturnCount('task',ID) as returnLog,dbo.getReceiverCount('task',ID) as receiverCount,dbo.getReceiverConfirmCount('task',ID) as receiverConfirmCount" + sql + " order by ID desc";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("limitDate").value + "|" + rs("receiverConfirmCount").value + "|" + rs("memo").value + "|" + rs("userID").value + "|" + rs("userName").value + "|" + rs("doMemo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("returnLog").value + "|" + rs("receiverCount").value;
		rs.MoveNext();
	}

	Response.Write(escape(result));
}	

if(op == "getTaskReceiveList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(item like('%" + where + "%') or memo like('%" + where + "%'))";
	}
	//s = "'" + currUser + "' in(select userID from receiverList where kindID='task' and refID=v_taskInfo.ID)";
	//s = "userID='" + currUser + "'";
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
		where = " and " + where;
	}

	sql = " FROM v_taskInfo a, v_receiverList b where a.ID=b.refID and b.kindID='task' and b.userID='" + currUser + "'" + where;

	result = getBasketTip(sql,"");
	ssql = "SELECT item,statusName,limitDate,finishDate,kindName,'' as userID,dbo.getReceiverNameList('task',ID) as userName,memo,doDate,doMemo,regDate,registorName" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " a.*,b.confirmDate,'' as userID,dbo.getReceiverNameList('task',a.ID) as userName,dbo.getReturnLog('task',a.ID,'" + currUser + "') as returnLog" + sql + " order by ID desc";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("limitDate").value + "|" + rs("confirmDate").value + "|" + rs("memo").value + "|" + rs("userID").value + "|" + rs("userName").value + "|" + rs("doMemo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("returnLog").value + "|" + rs("finishDate").value;
		rs.MoveNext();
	}

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT *,dbo.imReceiver('task',ID,'" + currUser + "') as imReceiver,dbo.getReceiverConfirmCount('task',ID) as receiverConfirmCount FROM v_taskInfo where ID='" + nodeID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("limitDate").value + "|" + rs("imReceiver").value + "|" + rs("memo").value + "|" + rs("doMemo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("receiverConfirmCount").value + "|" + rs("finishDate").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(item==""){
		result = 2;  //标题不能为空。
	}
	if(result == 0 && unescape(String(Request.QueryString("userID")))==""){
		result = 3;  //被委托人不能为空。
	}
	if(result == 0 && fStart==""){
		result = 4;  //日期不能为空。
	}
	if(result == 0){
		sql = "exec updateTaskInfo " + nodeID + ",'" + item + "','" + status + "','" + fStart + "','" + fEnd + "','" + kindID + "','";
		sql += unescape(String(Request.QueryString("memo"))) + "','" + unescape(String(Request.QueryString("userID"))) + "','" + unescape(String(Request.QueryString("regOperator"))) + "'";
		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM taskInfo where regOperator='" + unescape(String(Request.QueryString("regOperator"))) + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}
	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delTaskInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
