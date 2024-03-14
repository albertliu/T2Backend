<!--#include file="js/doc.js" -->

<%

if(op == "getCommentList"){
	sql = "SELECT *,dbo.getReturnLog('comment',ID,'" + currUser + "') as returnLog from v_commentInfo where kindID='" + kindID + "' and refID='" + refID + "'";
	if(String(Request.QueryString("userID")) != ""){		//按照发布人过滤
		sql += " and regOperator='" + String(Request.QueryString("userID")) + "'";
	}
	sql += " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("registorName").value + "|" + rs("regDate").value + "|" + rs("comment").value + "|" + rs("returnLog").value;
		rs.MoveNext();
	}
	rs.Close();

	if(result>""){
		result = result.substr(2);
		execSQL("exec setCommentReturnLog '" + kindID + "','" + refID + "','" + currUser + "'");
	}

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "update"){
	//sql = "insert into commentInfo(kindID,refID,comment,regOperator) values('" + kindID + "','" + refID + "','" + item.replace(/\n/g,"<br>") + "','" + currUser + "')";
	sql = "exec updateCommentInfo " + nodeID + ",'" + kindID + "','" + refID + "','" + item.replace(/\n/g,"<br>") + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
	//Response.Write(escape(sql));
}

if(op == "getCommentCount"){
	sql = "SELECT * from dbo.getCommentCount('" + keyID + "','" + refID + "','" + currUser + "')";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("cTotal").value + "|" + rs("cNew").value;
	}
	rs.Close();
	Response.Write(result);
}	

if(op == "getCommentUserList"){
	sql = "SELECT regOperator,registorName from v_commentInfo where kindID='" + kindID + "' and refID='" + refID + "' group by regOperator";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("regOperator").value + "|" + rs("registorName").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result>""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
}	
%>
