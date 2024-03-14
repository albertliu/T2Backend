<!--#include file="js/doc.js" -->

<%

if(op == "getAgencyList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(agencyID ='" + where + "' or agencyName like('%" + where + "%')";
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
	sql = " FROM v_agencyInfo " + where;
	ssql = "SELECT agencyNo,agencyName,title,statusName,linker,phone,email,address,memo,regDate,registerName" + sql + " order by agencyID";
	sql = "SELECT *" + sql + " order by agencyID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("agencyID").value + "|" + rs("agencyName").value + "|" + rs("title").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//8
		result +=  "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("address").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}

	Response.Write(escape(result.substr(2)));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_agencyInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("agencyID").value + "|" + rs("agencyName").value + "|" + rs("title").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//8
		result +=  "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("address").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	sql = "exec updateAgencyInfo " + Request.Form("ID") + ",'" + Request.Form("agencyID") + "','" + Request.Form("agencyName") + "','" + Request.Form("title") + "'," + Request.Form("status") + ",'" + Request.Form("linker") + "','" + Request.Form("phone") + "','" + Request.Form("email") + "','" + Request.Form("address") + "','" + Request.Form("memo") + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value;
	}
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delAgencyInfo '" + nodeID + "','" + item + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
