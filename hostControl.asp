<!--#include file="js/doc.js" -->

<%

if(op == "getHostList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(hostID ='" + where + "' or hostName like('%" + where + "%')";
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
	//如果有分类
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
	sql = " FROM v_hostInfo ";
	if(currHost > ""){
		sql += "where hostNo='" + currHost + "'";
	}else{
		sql += where;
	}
	result = getBasketTip(sql,"");
	ssql = "SELECT hostNo,hostName,title,kindName,statusName,linker,phone,email,address,memo,regDate,registerName" + sql + " order by hostName";
	sql = "SELECT top " + basket + " *" + sql + " order by hostName";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("hostID").value + "|" + rs("hostNo").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//8
		result +=  "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("address").value + "|" + rs("logo").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_hostInfo where hostNo='" + nodeID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("hostID").value + "|" + rs("hostNo").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//6
		result +=  "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("address").value + "|" + rs("logo").value + "|" + rs("QR").value + "|" + rs("signature").value;
		//13
		result +=  "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	sql = "exec updateHostInfo " + Request.Form("hostID") + ",'" + Request.Form("hostNo") + "','" + Request.Form("hostName") + "','" + Request.Form("title") + "'," + Request.Form("status") + ",'" + Request.Form("linker") + "','" + Request.Form("phone") + "','" + Request.Form("email") + "','" + Request.Form("address") + "','" + Request.Form("memo") + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value;
	}
	Response.Write(result);
}

if(op == "delNode"){
	sql = "exec delHostInfo '" + nodeID + "','" + item + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getTemplateList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "item like('%" + where + "%'";
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
	sql = " FROM v_formTemplateInfo ";
	ssql = "SELECT hostNo,hostName,title,kindName,statusName,linker,phone,email,address,memo,regDate,registerName" + sql + " order by hostName";
	sql = "SELECT *" + sql + " order by seq,ID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("filename").value;
		//5
		result +=  "|" + rs("seq").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}

	Response.Write(escape(result.substr(2)));
	//Response.Write(escape(sql));
}	

if(op == "getQRqueueList"){
	sql = "exec delQRqueue";	//删除超时的记录
	execSQL(sql);

	sql = "SELECT a.ID, c.username, c.name, c.password from qrShow a, studentCourseList b, studentInfo c where a.enterID=b.ID and b.username=c.username and b.host='" + currHost + "' order by a.ID";
	rs = conn.Execute(sql);
	var list = "";
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("password").value;
		list += rs("ID").value + ",";
		rs.MoveNext();
	}

	Response.Write(escape(list + result));
	//Response.Write(escape(sql));
}	

if(op == "addQRshow"){
	sql = "exec addQRshow " + nodeID + ", '" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "emptyQRqueue"){
	sql = "exec emptyQRqueue '" + currHost + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "getPartnerList"){
	//sql = "SELECT ID, partnerID, partnerName, title, status, statusName, memo, regDate, registerName from v_partnerInfo where host='" + currHost + "' order by ID";
	sql = "SELECT ID, partnerID, partnerName, title, status, statusName, memo, regDate, registerName from v_partnerInfo order by ID";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("partnerName").value + "|" + rs("title").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("partnerID").value;
		rs.MoveNext();
	}

	Response.Write(escape(result.substr(2)));
	//Response.Write(escape(sql));
}	

if(op == "getPartnerNodeInfo"){
	sql = "SELECT * FROM v_partnerInfo where partnerID='" + nodeID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("partnerName").value + "|" + rs("title").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("partnerID").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "updatePartnerInfo"){
	result = 0;
	sql = "exec updatePartnerInfo " + Request.Form("ID") + ",'" + Request.Form("partnerID") + "','" + Request.Form("partnerName") + "','" + Request.Form("title") + "','" + Request.Form("status") + "','" + Request.Form("memo") + "','" + currHost + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value;
	}
	Response.Write(result);
}

if(op == "delPartnerNode"){
	sql = "exec delPartnerInfo " + nodeID + ",'" + item + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "partnerExist"){
	result = 0;
	sql = "SELECT 1 FROM partnerInfo where partnerID='" + nodeID + "' union select 1 from hostInfo where hostNo='" + nodeID + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = 1;
	}
	rs.Close();
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "getHostListPure"){
	sql = "SELECT hostNo, title FROM hostInfo where hostNo<>'" + currHost + "' and status=0 order by hostNo";

	result = "";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += ',"' + rs("hostNo").value + '":"' + rs("title").value + '"';
		rs.MoveNext();
	}
	result = "{" + result.substr(1) + "}";
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}	
%>
